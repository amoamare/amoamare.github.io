import type { ISerialPort } from './ISerialPort';

export class WebSerialPort implements ISerialPort {
  protected port: SerialPort | null = null;
 // protected streamClosed?: Promise<void>;
  protected reader: ReadableStreamDefaultReader<string> | null = null;
  protected decoder?: TextDecoderStream;
  constructor(
    protected baudRate: number = 115200,
    protected lineEnding: string = '\n'
  ) {}

async connect(): Promise<void> {
  this.port = await navigator.serial.requestPort();

  const options = {
    baudRate: this.baudRate,
    dataBits: 8,
    stopBits: 1,
    parity: "none",
    flowControl: "none",
    bufferSize: 4096, // ❌ not supported in modern Web Serial API
  };
  await this.port.open(options);

  if (!this.port.readable) {
    throw new Error("Serial port is not readable.");
  }

  // ✅ Ensure decoder is created BEFORE using it
  this.decoder = new TextDecoderStream();

  // ✅ Pipe readable to decoder.writable
  this.streamClosed = this.port.readable.pipeTo(this.decoder.writable);

  // ✅ Use decoder.readable to get stream of decoded text
  this.reader = this.decoder.readable.getReader();

}

protected delay(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async disconnect(): Promise<void> {
  try {
    // Cancel and release the reader
    await this.reader?.cancel();
    this.reader?.releaseLock();

    // Break the pipe between port.readable and decoder.writable
    await this.streamClosed?.catch(() => {
      // Ignore pipe errors — this is expected if canceling
    });

    // Now safe to close the port
    await this.port?.close();
  } catch (err) {
    console.error("Error during disconnect:", err);
  } finally {
    this.reader = null;
    this.decoder = undefined;
    this.port = null;
    this.streamClosed = undefined;
  }
}

  async readAsync(onData: (data: string) => void): Promise<void> {
    if (!this.reader) throw new Error('Port is not connected');
    while (true) {
      const { value, done } = await this.reader.read();
      if (done) break;
      onData(value ?? '');
    }
  }

    async readLineAsync(): Promise<string> {
    if (!this.reader) throw new Error('Port is not connected');
    while (this.port.open) {
      const _reader = this.reader;
      const { value, done } = await _reader.read();
      if (done){ 
        console.error(done);
        break;}
      return value;
    }
    return "";
  }

   async ReadLineAsync(): Promise<string> 
   {
    if (!this.reader) {
      throw new Error("Reader not initialized. Did you call connect()?");
    }

    let line = '';

    while (true)
    {
      const { value, done } = await this.reader.read();
      if (done) break;
      if (value) 
      {
        line += value;
        console.log(line);
        if (line.includes('\n')) {
          return line.trim(); // ✅ return once line is complete
        }
      }
    }
    return line.trim(); // fallback return if stream closes
  }


  async writeAsync(data: string): Promise<void> {
    if (!this.port?.writable) throw new Error('Port is not connected');
    const writer = this.port.writable.getWriter();
    const encoder = new TextEncoder();
    await writer.write(encoder.encode(data + this.lineEnding));
    writer.releaseLock();
  }

  async readUntilIdleAsync(timeoutMs: number = 500): Promise<string> {
    if (!this.port?.readable) throw new Error('Port is not open.');

    if (!this.decoder) {
      this.decoder = new TextDecoderStream();
      this.streamClosed = this.port.readable.pipeTo(this.decoder);
      this.reader = this.decoder.readable.getReader();
    }

    let output = '';
    let timeout: ReturnType<typeof setTimeout>;
    let timedOut = false;

    const timeoutPromise = () =>
      new Promise<never>((_, reject) => {
        timeout = setTimeout(() => {
          timedOut = true;
          reject(new Error('UART idle timeout'));
        }, timeoutMs);
      });

    try {
      while (!timedOut) {
        const { value, done } = await Promise.race([
          this.reader.read(),
          timeoutPromise()
        ]);
        clearTimeout(timeout);
        if (done || !value) break;
        output += value;
      }
    } catch (_) {
      // Ignore timeout
    } finally {
      clearTimeout(timeout);
      // Don't release lock so it can continue to be reused
    }

    return output.trim();
  }


async flushBuffer(timeoutMs: number = 100): Promise<void> {
  if (!this.reader) throw new Error("Reader not initialized");

  let flushed = '';
  let timeout: ReturnType<typeof setTimeout>;
  let timedOut = false;

  const timeoutPromise = () =>
    new Promise<never>((_, reject) => {
      timeout = setTimeout(() => {
        timedOut = true;
        reject(new Error("Flush timeout"));
      }, timeoutMs);
    });

  try {
    while (!timedOut) {
      const { value, done } = await Promise.race([
        this.reader.read(),
        timeoutPromise(),
      ]);
      clearTimeout(timeout);

      if (done || !value) break;
      flushed += value;
    }
  } catch (_) {
    // Timeout reached — ignore
  } finally {
    clearTimeout(timeout);
    if (flushed.trim().length > 0) {
      console.warn("Flushed UART buffer:", flushed.trim());
    }
  }
}


}