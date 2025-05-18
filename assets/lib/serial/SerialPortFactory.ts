import type { ISerialPort } from './ISerialPort';
import { WebSerialPort } from './WebSerialPort';
import { UartSerialPort } from './UartSerialPort';

export enum SerialPortType {
  Web = 'web',
  UART = 'uart',
}

export interface SerialPortConfig {
  type: SerialPortType;
  baudRate?: number;
  lineEnding?: string;
}

export function createSerialPort(config: SerialPortConfig): ISerialPort {
  switch (config.type) {
    case SerialPortType.UART:
      return new UartSerialPort();
    case SerialPortType.Web:
    default:
      return new WebSerialPort(config.baudRate, config.lineEnding);
  }
}