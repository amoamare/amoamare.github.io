# CH341A UART Module 3.3V Modification Guide

## Overview
The mod is necessary to ensure compatibility with devices requiring 3.3v on the TX/RX lines, such as the PlayStation 5's southbridge.

## CH341A Reference Image

![CH341A_3v3_Mod](/assets/img/uart/CH341A_3_3VMod.webp){:loading='lazy'}

**Steps:**

1.  **Locate PIN 15:**
    *   Identify PIN 15 on the CH341A IC ([Reference Image](#ch341a-reference-image) labeled 1) and isolate it from the board, ensuring it doesn't touch the original 5v pad below.
2.  **Soldering:**    
    *   Using two wires:
        * Connect one end of the first wire to the lifted PIN 15 on the CH341A IC.  
        *[Reference Image](#ch341a-reference-image) labeled 1*
        * Connect the other end of the first wire to the 3Vout middle pin on the bottom of the voltage regulator.  
        *[Reference Image](#ch341a-reference-image) labeled 2 - orange and blue wire.*  
        * Connect one end of the second wire to PIN 9 on the CH341A IC.  
        *[Reference Image](#ch341a-reference-image) labeled 3*
        * Connect the other end of the second wire to the 3Vout top pin of the voltage regulator.  
        *[Reference Image](#ch341a-reference-image) labeled 3 - green and blue wire.*
3.  **Verification:**    
    *   Verify that there is a 3v output on both TX and RX pins.
4.  **Switch CH341A Interface To TTL/UART IMPORTANT:** 
    * Move or add a jumper to PINS labeled 2 and 3.  
    *[Reference Image](#ch341a-reference-image) labeled Important  4.*   
    *Note: This step is important. You will not get a serial port if you do not switch or add a jumper.  
5.  **Completion:**    
    *   Once the modifications are verified, the CH341A UART Module is ready for use with devices requiring 3.3v on the TX/RX lines.