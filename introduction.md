---
layout: page
title: About
permalink: /introduction/
hasMermaid: true
---


# PlayStation 5 Troubleshooting

## Introduction
Place holder.

## Flow Diagram Troubleshooting
<div class="mermaid">
graph LR; Start[Press Power button] 
-->SoundLight{Sound / Light}; 
SoundLight -->StaysOn{Stays On}; 
SoundLight -->TurnsOff{Turns Off};

StaysOn-->IsLedBlue{LED Blue};
StaysOn-->IsLedWhite{LED White};
IsLedBlue-->CheckPowerOnVoltages{Check Power On Voltages};
CheckPowerOnVoltages-->CheckSsd{Check SSD};
CheckPowerOnVoltages-->CheckRam{Check RAM};
CheckPowerOnVoltages-->CheckApu{Check APU};
IsLedWhite-->PictureOnScreen{Picture on screen};
PictureOnScreen-->HdmiEncoder{Check HDMI / Encoder};


SoundLight -->SmpsPowerSupplyGood{SMPS Power Supply Good?};
SmpsPowerSupplyGood-->CheckBootSeq{Check Boot Sequence};
CheckBootSeq-->CheckStandByVolts{Check Standby Voltages};
CheckStandByVolts-->CheckPowerOnVolts{Check Power On Voltages};
CheckPowerOnVolts-->CheckSouthBridge{Check Southbridge IC};
</div>

## UART Locations

| PS5 boot sequences and possible causes/solutions                   |                                   |                         | Created by TheCod3r 6th August 2023                                                                                              |  |
| ------------------------------------------------------------------ | --------------------------------- | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------- |  |
|                                                                    |                                   |                         |                                                                                                                                  |  |
| Indication Of                                                      | Power Stage                       | Sleep                   | Info                                                                                                                             |  |
| All Rails Present                                                  | 310ma                             | 7ma                     | Should attempt to turn on                                                                                                        |  |
| Faulty BIOS                                                        | 0ma                               | 0ma                     | Flash BIOS (with matching S/N if possible)                                                                                       |  |
| Blown F7003 fuse                                                   | 0ma                               | 0ma                     | Check F7003 for continuity                                                                                                       |  |
| Bad SSD or controller                                              | 225ma                             | 7ma                     | Check SSD ICs and controller for L/D or reflow. Possibly bad controller IC                                                       |  |
| Bad F7002 or shorted SBV (TLV62090) circuit                        | 275ma                             | No Sleep                | Check for shorts around F7002 or blown F7002 fuse                                                                                |  |
| Shorted 3.3v rail above SBV (TLV62090) IC                          | 315ma                             | No Sleep                | Check for shorts around WiFi IC/HDMI encoder or inject voltage into inductor above SBV IC (F7002 area)                           |  |
| Shorted WiFi IC                                                    | High current draw (5a in my case) | No Sleep                | Check for shorts around capacitors behind WiFi IC                                                                                |  |
| Blown F7001 fuse                                                   | 58ma                              | 7ma after 20 seconds    | Check F7001 fuse for continuity. Check Left caps near SBV @ F7502 for short to ground.                                           |  |
| Shorted inductor around DA9065                                     | 5ma                               | No Sleep                | Check bottom left inductor next to DA9065 (near F7003) for short to ground. Likely cause would be bad IC or Southbridge          |  |
| Shorted inductor around DA9065                                     | 5ma for 1 second                  | 0ma                     | Check top left inductor next to DA9065 (near F7003) for short to ground. Likely cause would be bad IC or Southbridge             |  |
| Blown F7502 fuse                                                   | 24ma                              | 7ma after 10-20 seconds | Check for continuity on F7502                                                                                                    |  |
| 12v missing while plugged in                                       | 0ma                               | 0ma                     | Check power supply or short to ground on 12v main input                                                                          |  |
| Shorted 1.1v rail                                                  | Pulsing between 7ma and 12ma      | Continuous pulsing      | Check for short on bottom middle inductor behind Southbridge. Possible bad Southbridge or shorted cap behind Southbridge         |  |
| Shorted 2v rail                                                    | 35ma                              | No Sleep                | Check for short on 2v rail (back of board, bottom inductor near middle left SBV IC)                                              |  |
| Shorted SOP-23 behind HDMI encoder                                 | 5ma                               | No Sleep                | Check for shorted SOP-23 IC behind MN864739 HDMI encoder. Could be a bad component or a bad HDMI encoder                         |  |
| Bad Southbridge most likely caused by power surge on ethernet port | 7ma                               | No Sleep                | Check for shorts on Bothand Magnetics Module (below ethernet port) for shorts. If short on any pin to ground replace Southbridge |