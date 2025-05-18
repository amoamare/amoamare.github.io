import { WebSerialPort } from './WebSerialPort';
import type { EmcFrameBase, EmcFrame, TableResult }  from '@lib/manufacturer/sony';
import { NG_ERROR_MAP }  from '@lib/manufacturer/sony';

export class UartSerialPort extends WebSerialPort {
  constructor() {
    super(115200, '\n'); // PS5 defaults
  }

  private lineBuffer: string = '';

  static formatCommand(command: string): string {
    const checksum =  UartSerialPort.calculateChecksum(command);
    return `${command}:${checksum.toString(16).toUpperCase().padStart(2, '0')}`;
  }

  private static calculateChecksum(data: string): number {
    const bytes = new TextEncoder().encode(data);
    const sum = bytes.reduce((acc, val) => acc + val, 0);
    return (sum + 256) % 256;
  }

  async writeAsync(data: string, format: boolean = true): Promise<void> {
    let formatted = data;
    if (format)
    {   
      const cleanData = data.trim();
      formatted = UartSerialPort.formatCommand(cleanData);
    }
    return super.writeAsync(formatted);
  }

  async ReadLineWithTimeout(timeoutMs: number): Promise<string> {
  if (!this.reader) throw new Error("Reader not initialized");
  let timeout: ReturnType<typeof setTimeout>;

  const timeoutPromise = new Promise<never>((_, reject) => {
    timeout = setTimeout(() => reject(new Error("Line read timeout")), timeoutMs);
  });

  try {
    while (true) {
      // Check for a complete line in the buffer
      const newlineIndex = this.lineBuffer.indexOf('\n');
      if (newlineIndex >= 0) {
        const line = this.lineBuffer.slice(0, newlineIndex);
        this.lineBuffer = this.lineBuffer.slice(newlineIndex + 1);
        return line.trim();
      }
      // Otherwise read more data
      const { value, done } = await Promise.race([
        this.reader.read(),
        timeoutPromise,
      ]);
      clearTimeout(timeout);
      if (done || !value) break;
      this.lineBuffer += value;
    }
  } finally {
    clearTimeout(timeout);
  }
  // No complete line, return leftovers (timeout)
  const fallback = this.lineBuffer;
  this.lineBuffer = '';
  return fallback.trim();
}


async readFrame(command: string, timeoutMs: number = 300): Promise<EmcFrameBase> {
  let echoLine = null;
  const timout = { status: false, fields: ["NG", "", "timeout"] };
  try {
    echoLine = await this.ReadLineWithTimeout(timeoutMs);
    if (echoLine.trim() !== command) 
      return { status: false, fields: ["NG", "", "Echo Mismatch"] };
  } catch {
      return timout;
  }
  let statusLine = null;
  try {
    statusLine = await this.ReadLineWithTimeout(timeoutMs);
  } catch {
      return timout;
  }
  const fields = statusLine.trim().split(/\s+/);
  const status = fields[0]?.toUpperCase() === 'OK';

 return {
    status,
    fields
  };
}

emcBaseFromString(uartLine: string) {
  const fields = uartLine.trim().split(/\s+/);
  return {
    status: fields[0].toUpperCase() === "OK",
    fields
  };
}


  async ReadErrorCodesAsync(count: number = 0x40): Promise<TableResult[]> {
    const results = [];
    for (let i = 0; i <= count; i++) {
      const cmd = `errlog ${i.toString(16).toUpperCase().padStart(2, '0')}`;
      const formatted = UartSerialPort.formatCommand(cmd);
      await this.writeAsync(formatted, false);
     const baseFrame = await this.readFrame(formatted, 300);
     //const baseFrame = this.emcBaseFromString("OK 00000000 808D0000 1803A22A 15000005 10010000 217B 003E 6497 1CD3"); 
     const parsed = this.parseEmcFrame(baseFrame);
      results.push({
        index: i,
        frame: parsed,
        raw: baseFrame.fields.join(' ')
      });
      if (
        parsed.status &&
        parsed.code?.toUpperCase() === 'FFFFFFFF'
      ) {
        break;
      }
    }
    return results;
  }

 parseEmcFrame(frame: EmcFrameBase): EmcFrame 
  {
    const fields = frame.fields;
    if (frame.status === true) {
      return {
        status: true,
        fields,
        code: fields[2] || '',
        rtc_date_time: fields[3] || '',
        powState: fields[4] || '',
        upCause: fields[5] || '',
        sqNo: fields[6] || '',
        dvPm: fields[7] || '',
        tSoc: fields[8] || '',
        tEnv: fields[9] || ''
      };
    } else {
      const code = fields[1] || '';
      const rawMsg = fields.slice(2).join(' ') || '';
      return {
        status: false,
        fields, code,
        message: NG_ERROR_MAP[code] || rawMsg
      };
    }
  }

}