export interface ISerialPort {
  connect(): Promise<void>;
  disconnect(): Promise<void>;
  readAsync(onData: (data: string) => void): Promise<void>;
  writeAsync(data: string): Promise<void>;
  readUntilIdleAsync(timeoutMs?: number): Promise<string>;
  ReadLineAsync(): Promise<string>;
  flushBuffer(timeoutMs: number): Promise<void>;
}