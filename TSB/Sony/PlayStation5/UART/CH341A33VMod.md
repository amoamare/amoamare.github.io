# CH341A UART Module 3.3V Modification Guide

## Overview
The mod is required because the CH341A produces 5v on the original layout for UART. 
The PlayStation 5 southbridge will only respond with 3.3v. to send commands to the southbridge.
If 5v is sent to the southbridge the southbridge will stop communicating on the RX line.


## Steps 
- Lift pin 15 from board (make sure it doesn't touch the 5v pad beneath isolate the pad from the pin)
- Solder 1 side of a wire to the mosfets middle pin on bottom.
- Solder the other side of wire to PIN 15 of the IC.
- Solder a second wire from the mofets top pin to PIN 9 on the IC.
- Verify you have 3v3 instead of 5v.
- After the required modifications have been completed you are ready to use.
