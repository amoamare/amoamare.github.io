---
layout: minimal
title: PS5 UART Getting Started Guide
subtitle: Getting Started with UART for Hardware Diagnosis
permalink: /tsb/sony/playstation5/uart/gettingstarted
---

# PS5 UART Diagnostics Guide

## Table of Contents
1. [Overview](#overview)
2. [Pinouts and Locations](#pinouts-and-uart-locations)
3. [Troubleshooting](#troubleshooting)
4. [Questions and Answers](#questions-&-answers)
5. [Recommended Hardware](#recommended-hardware)
6. [Fuse Information and Details (EDM-002)](#fuse-information-and-details)

## Overview 

Welcome to Consoel Service Tool UART for PlayStation 5! This tool is designed to assist technicians in diagnosing hardware issues such as GDDR6 memory, APU, HDMI shorts, and more using UART communication and reading the error codes directly from the console. With the communities help with reverse engineering codes, hardware solutions and repairs related to specific errors. We can continue to update this tool and provide a great value to the repair industry.

## Prerequisites

Before getting started, make sure you have the following:

- **PlayStation 5 Console**: Ensure you have a PlayStation 5 console.
- **UART Module**: Obtain a UART module compatible with the PlayStation 5 console. (CH341A*)
  *Note: If using the CH341A UART module, you will need to modify it to work with 3.3V instead of 5V. Refer to the following documentation for guidance on how to perform this modification: [CH341A UART Module 3.3V Modification Guide](#CH341A-UART-Module-3.3V-Modification-Guide).*
- **Console Service Tool**: This software or similar software to read the error codes from UART.

## Setup Instructions

1. **Connect UART Module and Install Drivers**: Connect the UART module to your computer.
   *Note: Ensure that any required drivers are installed following the manufacturer's instructions.*

2. **Solder UART Wires to Module & PlayStation 5**: Using three wires in total: [Reference Images](#pinouts-and-uart-locations)
   - Connect the first wire from the RX pin on the UART module to the TX pin on the PlayStation 5.
   - Connect a second wire from the TX pin on the UART module to the RX pin on the PlayStation 5.
   - Connect a third wire from the GND pin on the UART module to the GND pin on the PlayStation 5.

3. **Supply 12V power to the PlayStation 5**: Connect the PlayStation 5 to a powered wall outlet, or supply 12V using a DC power supply.
   *Note: Do not power on the PlayStation 5 at this time.*

4. **Using Console Service Tool**: Select "Read All Codes" while the PlayStation 5 is unpowered and in standby mode. If you encounter any errors during this process, they are most likely related to standby state. Record any codes that may be displayed.

5. **Using Console Service Tool**: Select "Clear Codes". This will clear any codes including any from standby. At this time, press the power button one time on the PlayStation 5 to initiate power on state.
   *Note: Do not worry if the console does not fully power on. If it just beeps or shuts down that is fine.*

6. **Repeat step 4**: Read all codes again. If any codes are preset, these codes most likely deal with powering-on or powered-on state. Record any codes that may be displayed.

7. **Diagnose and Troubleshoot**: You may now have a list of error codes and/or descriptions. Utilize the information provided, community forums, or other means to further diagnose or troubleshoot your PlayStation 

{% include_relative PinoutsContent.md %}

{% include_relative CH341A33VMod.md %}

## Troubleshooting

1. **Verify Hardware and Drivers**:
   - Ensure you have a TTL or CH341 device operating at 3.3V. Install the correct drivers and restart your computer if needed.
2. **Check Device Manager**:
   - Navigate to Device Manager and confirm the presence of a serial port under Serial Ports. Unplug and replug your TTL/CH341 to identify the COM port.
3. **Verify Connections**:
   - Ensure TX, RX, and GND connections are secure between your console and UART device.
4. **Power Supply**:
   - Confirm that the console is plugged into a powered wall outlet, even if it's powered off.
5. **Read Codes**:
   - If you encounter "Operation Cancelled," try swapping TX and RX wires.
6. **Check Fuses and NOR**:
   - Inspect fuse F7003 and ensure NOR is not corrupted, as these may affect UART response.
7. **Monitor Mode**:
   - Switch software to "Monitor" mode and reconnect the console. If no response, try swapping TX and RX again.
   Remember TTL-TX --> PS5-RX and TTL-RX --> PS5-TX. Tx is the mouth and Rx is the Ear. You dont talk mouth to mouth.
8. **Hardware/Software Comparison**:
   - Test with a known working console to isolate hardware or software issues.

## Questions & Answers
#### Q: Why does CST show more than 10 error codes?
   - A: CST displays all error codes until "No Error Codes" response is received from the console, providing a clearer understanding of the issue.

#### Q: I Keep getting "Operation Cancelled" do you know why?
   - A: If all connections are correct, a dead southbridge may be the cause. Refer to troubleshooting for detailed steps.

## Recommended Hardware
   - For optimal performance, use a 3.3V UART interface. We recommend USB to TTL converters such as [this one](https://www.amazon.com/gp/product/B0B1HYCN34/ref=ppx_yo_dt_b_search_asin_image?ie=UTF8&psc=1). If using a CH341, ensure it has a 5V to 3.3V switch or perform the necessary modifications.

## Fuse Information and Details
- **F5401**: No UART errors when pulled; console boots normally.
- **F5402**: Disk Drive; no UART errors displayed; console boots normally.
- **F7502**: Storage Controller; specific error codes displayed.
- **F7003**: No UART errors when pulled; console boots normally.
- **F7501**: External M.2 Storage; no UART errors displayed.
- **F3502**: Pending; no UART errors displayed.
- **NOR**: Bad/Corrupted/Missing; no UART response, with 3 quick beeps.

## Additional Tips for UART Usage
   - UART codes can be thrown from standby or power-on states. Read and save any codes, then clear the error log.
   - After clearing, unplug the console, wait 5 seconds, then plug it back without powering on. Read error codes again; issues may be related to standby.
   - Finally, power on the console and read codes. Focus on issues related to power-on.

### A Project in Works by Fix MY
   - Visit [Fix MY](https://www.utah.repair) for console repairs in Utah!

## Want to Help or Contribute?
   - We are seeking donor boards to advance this project. Contact us at amoamare+cst@gmail.com to contribute.