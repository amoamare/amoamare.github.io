---
layout: minimal
title: UART Locations
subtitle: UART Locations
permalink: /tsb/sony/playstation5/uart/gettingstarted
---

# UART Getting Started

### Table of Contents
1. [Overview](#overview)
2. [Pinouts and Locations](#pinouts-and-uart-locations)
3. [Trouble Shooting](#trouble-shooting)
4. [Questions and Answers](#questions-&-answers)


## Overview 

## Pinouts and UART Locations
{% include_relative Pinouts.md %}


## Trouble Shooting
* Operation Cancelled - this occurs either because of user cancelled the operation or a time out has occurred waiting for response from the console. 
1. Verify have a TTL, CH341 or other similar device that runs at 3.3v important! and that the correct drivers have been installed. If drivers have been installed, make sure they are not pending a restart. If you are unsure. Restart your computer. 
2. Go to device manager -> start devmgmt. Check under Serial ports and verify that a serial port is listed. Unplug your TTL/CH341 and see if it disappears. If it does. Replug the device in and check what COMPORT it is assigned to. 
3. Check that your TX,RX and GND are securely connected to your console.
4. Check that the console is plugged into a powered wall outlet. The ps5 does not need to be powered on but does need to have powered supplied to it. 
5. Click read codes. If you still get Operation Cancelled. Try swapping your TX and RX wires.
6. Check fuse F7003 if blown UART will not respond.
7. Check NOR - Bad or Currupted NOR will prevent UART.
8. Still getting Operation Cancelled. Switch the software to "Monitor" mode and connect. This mode will listen for anything the PS5 will say. Unplug the PS5 and wait 5 secs. Reconnect power to the PS5 and check that the PS5 has given signal to the software. If you still do not see anything from the PS5 and you swapped your TX and RX try swapping them back and repeat the steps. If still no response from the console. Try a known good console to rule out a hardware / software issue. If that works. Your console that did not respond has a dead southbridge.


## Questions & Answers

#### Q: Why does CST show more than 10 error codes?
A: CST shows all error codes until the response No Error Codes comes from the console. 
The reason to do this is to give the user a better and clear idea of what may originally 
happend. Its easy for an end user to fill all 10 previous error slots with just a couple of
codes such as, APU halt or freeze, Unxpected shut down etc.

#### Q: I Keep getting "Operation Cancelled" do you know why?

A: Short answer if everything is connected properly, then you possibly have a dead southbridge as the southbridge is required to function for UART to work.

A: Long answer, Check Trouble shooting.


## Hardware Recommended
UART Interface 3.3v
For ease of use recommend the USB to TTL found here: https://www.amazon.com/gp/product/B0B1HYCN34/ref=ppx_yo_dt_b_search_asin_image?ie=UTF8&psc=1
If you buy a CH341 make sure to get one that has a switch from 5v to 3.3v otherwise you will need to mod it for 3.3v. 


## Fuse Information and Information (EDM-002)
F5401 - No UART errors when pulled - console still boots normally.

F5402 - Disk Drive, No UART errors displayed. - console still boots normally.

F7502 - Storage Controller - Following codes will display.

    1. 80810001
    2. C0160203
    3. C0160303 

F7003 - No UART errors when pulled - console still boots normally. 

F7501 - External M.2 Storage No UART errors displayed. If no M.2 storage detected Check Fuse and 3.3v regulator.

F3502 - Pending - No UART errors displayed.

NOR - Bad / Currupted / Missing - No UART response. 3 quick beeps off.

Fuses can have continuity but fail under load. Simply checking continuity doesn't guaranteed fuse is good.


## Some tips while using UART
UART Codes can be thrown from standby or power on state. 
I recommend you first read and save any codes your PS5 has thrown. After that be sure to clear the errlog.
Unplug the PS5 from the wall and wait 5 seconds. 
Plug the PS5 back into the wall DO NOT POWER ON THE PS5, wait 10 seconds for standby to initialize.
Read error codes. If you have error codes. These are most likely related to standby issues. Fix them first. 
Once you have no error codes in standby.
Click the power button only 1 time. 
Read codes - after you have read the codes. Fix these issues. These should mostly be related to power on, so don't spend much time focusing on standby rails.
Check things related to powering on the console. Enable pins etc. 

### A Project in works by [Fix MY](https://www.utah.repair)
https://www.utah.repair

In Utah? Looking for a repair on your console? Reach out to Fix MY! 

## Want to help or contribute?
We are looking for donor boards to further this project.
Send email: amoamare+cst@gmail.com
