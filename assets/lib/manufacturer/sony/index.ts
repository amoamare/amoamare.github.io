export interface TableResult {
  index: number;
  frame: EmcFrame;
  raw: string;
}


export interface EmcFrameBase 
{
  status: boolean;
  fields: string[];
} 

export interface EmcOkFrame extends EmcFrameBase {
  status: true;
  code: string;
  rtc_date_time: string;
  powState: string;
  upCause: string;
  sqNo: string;
  dvPm: string;
  tSoc: string;
  tEnv: string;
}

export interface EmcNgFrame extends EmcFrameBase {
  status: false;
  code: string;
  message: string;
}
export type EmcFrame =
  | ({ status: true; fields: string[] } & EmcOkFrame)
  | ({ status: false; fields: string[] } & EmcNgFrame);
  
export const NG_ERROR_MAP: Record<string, string> = {
  "E0000004": "Bad Checksum",
  "F0000006": "Command Not Found",
  "F0000001": "Incorrect Argument"
};


export const UPCAUSE_MAP_BITS: [number, string][] = [
  [26, "UART Command (DEV UART)"],
  [19, "Bluetooth (PS Button of DualSense)"],
  [18, "HDMI-CEC"],
  [17, "EAP's Order"],
  [16, "Main SoC's Order"],
  [10, "Eject Button"],
  [9,  "Disc Loaded"],
  [8,  "Power Button"],
  [0,  "Boot-Up at Power-On"]
];

const DEVPM_FLAGS_MAP: [number, string][] = [
  [4, "HDMI (5V)"],
  [3, "BD Drive"],
  [2, "HDMI (CEC)"],
  [1, "USB"],
  [0, "WLAN/BT Module"]
];

const OS_STATE_MAP: Record<number, string> = {
  0x00: "SYSTEM Ready",
  0x01: "Main On Standby",
  // 0x02-0x0F: Reserved
  // 0x10-0x1F: PSP
  // 0x20-0x3F: BIOS
  0x40: "EAP READY",
  // 0x41-0x4F: EAP
  // 0x50-0xBF: Kernel
  // 0xC0-0xFE: Init Process
  0xFF: "HOSTOS_OFF"
};

const SYSTEM_STATE_MAP: Record<number, string> = {
  0x0000: "ACIN_L (Before Standby)",
  0x0001: "STANDBY (Standby State)",
  0x0002: "PG2_ON (PG2 ON State)",
  0x0003: "EFC_ON (EFC ON State)",
  0x0004: "EAP_ON (EAP ON State)",
  0x0005: "SOC_ON (Main SoC ON State)",
  0x0006: "ERROR_DET (Error Detected State)",
  0x0007: "FATAL_ERROR (Fatal Shutdown)",
  0x0008: "NEVER_BOOT (Never Boot State)",
  0x0009: "FORCE_OFF (Forced OFF State)",
  0x000A: "FORCE_OFF (BT Firmware Download State)"
};

export function rtcCounterToDateTime(rtc: string) {
  if (!rtc || rtc.toUpperCase() === 'FFFFFFFF') return "No RTC (not set)";
  const rtcEpoch = Date.UTC(2012, 0, 1, 0, 0, 0); // Jan = 0
  const seconds = parseInt(rtc, 16);
  if (isNaN(seconds)) return "Invalid RTC";
  const date = new Date(rtcEpoch + seconds * 1000);
  return date.toISOString().replace('T', ' ').replace(/\.\d+Z$/, ' GMT');
}

export function decodeSeqNo(seqHex: string) {
  if (!seqHex) return "";
  return parseInt(seqHex, 16) + " (0x" + seqHex.toUpperCase() + ")";
}

export function decodeDevPm(devPmHex: string): string {
  console.log("umm " + devPmHex);
  if (!devPmHex) return "Unknown";
  const value = parseInt(devPmHex, 16) & 0x1F;
  if (isNaN(value)) return "Invalid DevPM";

  const activeFlags = DEVPM_FLAGS_MAP
    .filter(([bit]) => (value & (1 << bit)) !== 0)
    .map(([, name]) => name);

  return activeFlags.length ? activeFlags.join(", ") : "None Active";
}

export function decodeTemp(tempHex: string) {
  if (!tempHex || tempHex.toUpperCase() === "FFFF") return "Unavailable";
  const val = parseInt(tempHex, 16);
  const intPart = (val >> 8) & 0xFF;
  const decPart = val & 0xFF;
  return `${intPart}.${decPart.toString().padStart(2, "0")}°C`;
}

export function decodePowerStateInfo(powStateHex: string) {
  if (!powStateHex) return { os: "Unknown", system: "Unknown" };

  const value = parseInt(powStateHex, 16);

  // OS State: bits 23-16
  const osByte = (value >> 16) & 0xFF;
  // System State: bits 15-0
  const sysWord = value & 0xFFFF;

  // OS State: handle ranges
  let osStr;
  if (osByte >= 0x10 && osByte <= 0x1F) osStr = "PSP";
  else if (osByte >= 0x20 && osByte <= 0x3F) osStr = "BIOS";
  else if (osByte >= 0x41 && osByte <= 0x4F) osStr = "EAP";
  else if (osByte >= 0x50 && osByte <= 0xBF) osStr = "Kernel";
  else if (osByte >= 0xC0 && osByte <= 0xFE) osStr = "Init Process";
  else osStr = OS_STATE_MAP[osByte] || `Reserved (0x${osByte.toString(16).padStart(2,"0").toUpperCase()})`;

  // System State: map or fallback
  const sysStr = SYSTEM_STATE_MAP[sysWord] || `Unknown (0x${sysWord.toString(16).padStart(4,"0").toUpperCase()})`;

  return { os: osStr, system: sysStr };
}

export function decodeUpCause(upCauseHex: string): string {
  if (!upCauseHex) return "Unknown";
  const value = parseInt(upCauseHex, 16);
  if (isNaN(value)) return "Invalid UpCause";

  const causes = UPCAUSE_MAP_BITS
    .filter(([bit]) => (value & (1 << bit)) !== 0)
    .map(([, label]) => label);

  return causes.length ? causes.join(", ") : "Unknown Starting Factor";
}