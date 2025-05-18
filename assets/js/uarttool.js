// ---- Error Map and Decoding Tables ----
const NG_ERROR_MAP = {
  "E0000004": "Bad Checksum",
  "F0000006": "Command Not Found",
  "F0000001": "Incorrect Argument"
};

const UPCAUSE_MAP_BITS = [
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

const DEVPM_FLAGS_MAP = [
  [4, "HDMI (5V)"],
  [3, "BD Drive"],
  [2, "HDMI (CEC)"],
  [1, "USB"],
  [0, "WLAN/BT Module"]
];

const OS_STATE_MAP = {
  0x00: "SYSTEM Ready",
  0x01: "Main On Standby",
  0x40: "EAP READY",
  0xFF: "HOSTOS_OFF"
};

const SYSTEM_STATE_MAP = {
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

// ---- Decoders ----
function rtcCounterToDateTime(rtc) {
  if (!rtc || rtc.toUpperCase() === 'FFFFFFFF') return "No RTC (not set)";
  const rtcEpoch = Date.UTC(2012, 0, 1, 0, 0, 0);
  const seconds = parseInt(rtc, 16);
  if (isNaN(seconds)) return "Invalid RTC";
  const date = new Date(rtcEpoch + seconds * 1000);
  return date.toISOString().replace('T', ' ').replace(/\.\d+Z$/, ' GMT');
}

function decodeSeqNo(seqHex) {
  if (!seqHex) return "";
  return parseInt(seqHex, 16) + " (0x" + seqHex.toUpperCase() + ")";
}

function decodeDevPm(devPmHex) {
  if (!devPmHex) return "Unknown";
  const value = parseInt(devPmHex, 16) & 0x1F;
  if (isNaN(value)) return "Invalid DevPM";
  const activeFlags = DEVPM_FLAGS_MAP
    .filter(([bit]) => (value & (1 << bit)) !== 0)
    .map(([, name]) => name);
  return activeFlags.length ? activeFlags.join(", ") : "None Active";
}

function decodeTemp(tempHex) {
  if (!tempHex || tempHex.toUpperCase() === "FFFF") return "Unavailable";
  const val = parseInt(tempHex, 16);
  const intPart = (val >> 8) & 0xFF;
  const decPart = val & 0xFF;
  return `${intPart}.${decPart.toString().padStart(2, "0")}°C`;
}

function decodePowerStateInfo(powStateHex) {
  if (!powStateHex) return { os: "Unknown", system: "Unknown" };
  const value = parseInt(powStateHex, 16);
  const osByte = (value >> 16) & 0xFF;
  const sysWord = value & 0xFFFF;

  let osStr;
  if (osByte >= 0x10 && osByte <= 0x1F) osStr = "PSP";
  else if (osByte >= 0x20 && osByte <= 0x3F) osStr = "BIOS";
  else if (osByte >= 0x41 && osByte <= 0x4F) osStr = "EAP";
  else if (osByte >= 0x50 && osByte <= 0xBF) osStr = "Kernel";
  else if (osByte >= 0xC0 && osByte <= 0xFE) osStr = "Init Process";
  else osStr = OS_STATE_MAP[osByte] || `Reserved (0x${osByte.toString(16).padStart(2,"0").toUpperCase()})`;

  const sysStr = SYSTEM_STATE_MAP[sysWord] || `Unknown (0x${sysWord.toString(16).padStart(4,"0").toUpperCase()})`;

  return { os: osStr, system: sysStr };
}

function decodeUpCause(upCauseHex) {
  if (!upCauseHex) return "Unknown";
  const value = parseInt(upCauseHex, 16);
  if (isNaN(value)) return "Invalid UpCause";
  const causes = UPCAUSE_MAP_BITS
    .filter(([bit]) => (value & (1 << bit)) !== 0)
    .map(([, label]) => label);
  return causes.length ? causes.join(", ") : "Unknown Starting Factor";
}

// ---- Web Serial Port Classes ----
class WebSerialPort {
  constructor(baudRate = 115200, delimiter = '\n') {
    this.port = null;
    this.reader = null;
    this.writer = null;
    this.baudRate = baudRate;
    this.delimiter = delimiter;
    this.isConnected = false;
    this.lineBuffer = '';
  }

  async connect() {
    if (!navigator.serial) throw new Error("Web Serial API not supported.");
    this.port = await navigator.serial.requestPort();
    await this.port.open({ baudRate: this.baudRate });
    this.isConnected = true;
    this.textDecoder = new TextDecoder();
    this.textEncoder = new TextEncoder();
    this.reader = this.port.readable.getReader();
    this.writer = this.port.writable.getWriter();
  }

  async writeAsync(data) {
    if (!this.writer) throw new Error("Writer not initialized");
    const encoded = new TextEncoder().encode(data + this.delimiter);
    await this.writer.write(encoded);
  }

  async close() {
    if (this.reader) { try { await this.reader.cancel(); } catch {} this.reader = null; }
    if (this.writer) { try { await this.writer.releaseLock(); } catch {} this.writer = null; }
    if (this.port) { try { await this.port.close(); } catch {} this.port = null; }
    this.isConnected = false;
  }

  async disconnect() { await this.close(); }
}

class UartSerialPort extends WebSerialPort {
  constructor() {
    super(115200, '\n');
  }

  static formatCommand(command) {
    const checksum = UartSerialPort.calculateChecksum(command);
    return `${command}:${checksum.toString(16).toUpperCase().padStart(2, '0')}`;
  }

  static calculateChecksum(data) {
    const bytes = new TextEncoder().encode(data);
    const sum = bytes.reduce((acc, val) => acc + val, 0);
    return (sum + 256) % 256;
  }

  async writeAsync(data, format = true) {
    let formatted = data;
    if (format) {
      const cleanData = data.trim();
      formatted = UartSerialPort.formatCommand(cleanData);
    }
    return super.writeAsync(formatted);
  }

  async ReadLineWithTimeout(timeoutMs) {
    if (!this.reader) throw new Error("Reader not initialized");
    let timeout;
    const timeoutPromise = new Promise((_, reject) => {
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
        this.lineBuffer += new TextDecoder().decode(value);
      }
    } finally {
      clearTimeout(timeout);
    }
    // No complete line, return leftovers (timeout)
    const fallback = this.lineBuffer;
    this.lineBuffer = '';
    return fallback.trim();
  }

  async readFrame(command, timeoutMs = 300) {
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
    return { status, fields };
  }

  emcBaseFromString(uartLine) {
    const fields = uartLine.trim().split(/\s+/);
    return {
      status: fields[0].toUpperCase() === "OK",
      fields
    };
  }

  async ReadErrorCodesAsync(count = 0x40) {
    const results = [];
    for (let i = 0; i <= count; i++) {
      const cmd = `errlog ${i.toString(16).toUpperCase().padStart(2, '0')}`;
      const formatted = UartSerialPort.formatCommand(cmd);
      await this.writeAsync(formatted, false);
      const baseFrame = await this.readFrame(formatted, 300);
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

  parseEmcFrame(frame) {
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

// Factory
const SerialPortType = { UART: "uart" };
function createSerialPort({ type }) {
  if (type === SerialPortType.UART) return new UartSerialPort();
  throw new Error("Unsupported serial port type");
}

// -------- Widget UI and Logic --------
document.addEventListener("DOMContentLoaded", function () {
  const connectBtn = document.getElementById("connect");
  const readLogsBtn = document.getElementById("readLogs");
  const output = document.getElementById("output");
  let port = null;
  let logBuffer = [];
  let isConnected = false;

  function logMessage(msg, addDate = true) {
    const date = `[${new Date().toLocaleTimeString()}]`;
    const line = addDate ? `${date} ${msg}` : `${msg}`;
    output.textContent += line + "\n";
    logBuffer.push(line + "\n");
    output.scrollTop = output.scrollHeight;
  }

  function clearLogMessage() {
    output.textContent = "";
    logBuffer = [];
  }

  async function connectSerial() {
    if (isConnected) {
      await disconnectSerial();
      return;
    }
    connectBtn.textContent = "Connecting...";
    connectBtn.disabled = true;
    try {
      port = createSerialPort({ type: SerialPortType.UART });
      await port.connect();
      isConnected = true;
      connectBtn.textContent = "Disconnect";
    } catch (e) {
      logMessage("Connect failed: " + e.message);
      isConnected = false;
      connectBtn.textContent = "Connect";
    }
    connectBtn.disabled = false;
  }

  async function disconnectSerial() {
    if (!port) return;
    try { await port.disconnect(); } catch {}
    isConnected = false;
    connectBtn.textContent = "Connect";
  }

  async function readLogs() {
    if (!isConnected) return;
    clearLogMessage();
    let results = [];
    try {
      results = await port.ReadErrorCodesAsync(2);
    } catch (e) {
      logMessage("Error reading logs: " + e.message);
      return;
    }
    renderTable(results);
  }

  connectBtn.addEventListener("click", connectSerial);
  readLogsBtn?.addEventListener("click", readLogs);

  window.addEventListener("beforeunload", async () => {
    try { if (port) await port.disconnect(); } catch {}
  });

  function renderTable(results) {
    output.innerHTML = "";
    const table = document.createElement('table');
    table.className = "uart-table";
    const thead = document.createElement('thead');
    thead.innerHTML = `
      <tr>
        <th>Slot #</th>
        <th>Date Time</th>
        <th>Error Code</th>
        <th>Power State (OS)</th>
        <th>Power State (System)</th>
        <th>Up Cause</th>
        <th>Last Seq</th>
        <th>DevPM</th>
        <th>Temp (SoC)</th>
        <th>Temp (Env)</th>
      </tr>
    `;
    table.appendChild(thead);

    const tbody = document.createElement('tbody');
    results.forEach(({ index, frame, raw }) => {
      if (frame.status) {
        const powerStateInfo = decodePowerStateInfo(frame.powState);
        const humanRow = {
          slot: index,
          dateTime: rtcCounterToDateTime(frame.rtc_date_time),
          code: frame.code,
          powState: powerStateInfo.os,
          powerState: powerStateInfo.system,
          upCause: decodeUpCause(frame.upCause),
          seqNo: decodeSeqNo(frame.sqNo),
          devPm: decodeDevPm(frame.dvPm),
          tSoc: decodeTemp(frame.tSoc),
          tEnv: decodeTemp(frame.tEnv)
        };
        const tr = document.createElement('tr');
        tr.className = "ok-row";
        tr.innerHTML = `
          <td>${humanRow.slot}</td>
          <td>${humanRow.dateTime}</td>
          <td>${humanRow.code}</td>
          <td>${humanRow.powState}</td>
          <td>${humanRow.powerState}</td>
          <td>${humanRow.upCause}</td>
          <td>${humanRow.seqNo}</td>
          <td>${humanRow.devPm}</td>
          <td>${humanRow.tSoc}</td>
          <td>${humanRow.tEnv}</td>
        `;
        tr.addEventListener('click', () => {
          tr.classList.toggle('expanded');
          if (tr.nextSibling && tr.nextSibling.classList.contains('expand-row')) {
            tr.nextSibling.remove();
          } else {
            const expandTr = document.createElement('tr');
            expandTr.className = "expand-row";
            expandTr.innerHTML = `
<td colspan="10">
  <b>Raw Frame:</b>
  <code>${raw}</code>
  <br/>
  <span style="display:block; font-family:monospace; color:#888; font-size:0.9em;">
    Raw Frame Break Down By Field<br/>
    [UART Frame ${frame.fields ? frame.fields.join("] [") : ""}]
  </span><br/>
<div class="error-details" style="margin:0.75em 0 0.75em 0; padding:0.75em 1em; border-left:4px solid #aaf; font-size:1em;">
  <strong>Error Code:</strong> <span style="color:#b13;">${frame.code}</span><br/>
  <strong>Description:</strong> ${NG_ERROR_MAP[frame.code] || 'Thermal Shutdown : Main SoC'}<br/>
</div><br/>
</td>
            `;
            tr.parentNode.insertBefore(expandTr, tr.nextSibling);
          }
        });
        tbody.appendChild(tr);
      } else {
        const tr = document.createElement('tr');
        tr.className = "ng-row";
        tr.innerHTML = `
          <td>${index}</td>
          <td colspan="9" style="color:#c00"><b>NG</b> ${frame.code}: ${frame.message}</td>
        `;
        tbody.appendChild(tr);
      }
    });
    table.appendChild(tbody);
    output.appendChild(table);
  }
});