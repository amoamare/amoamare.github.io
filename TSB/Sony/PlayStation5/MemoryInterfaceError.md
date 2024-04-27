
# Error Code: {{ page.error }}

### Table of Contents
1. [Overview](#overview)
2. [Models](#models)
3. [Symptom / Condition](#symptom--condition)
4. [Possible Problems](#possible-problems)
5. [IC Images and Locations](#ic-images-and-locations)
6. [Diagnosis](#diagnosis)
6. [Repair Procedure](#repair-procedure)
6. [Parts Information](#parts-information)

## Overview
Indicated memory banks failed to communicate or initialize from APU.

*   **Faulty Memory Modules**: One or more memory modules (RAM) may be malfunctioning or improperly seated, preventing communication or initialization.
    
*   **APU Malfunction**: The APU itself may be experiencing issues, such as power supply problems or internal component failures, leading to communication failures with the memory banks.
    
*   **Connection Issues**: There might be connectivity problems between the APU and the memory banks, either due to loose connections, damaged traces, or faulty connectors.
    
*   **Compatibility Problems**: Incompatibility between the APU and the memory modules could lead to communication failures or initialization issues.

#### GDDR6 Memory Bank Reference Locations EDM-010,020,030 etc
{% highlight_img_areas site.data.highlight_areas.EDM001.GDDR6 %}
{% endhighlight_img_areas %}

## Symptom / Condition
When trying to power on the console, the console will give a single beep and a 1 second blue light, then power off.
{% if page.error == '808011FF' %}
Sometimes instant power loss, other times BLOD for 2 minutes. 
{% endif %}

## Possible Problems
- Bad Communication From APU (Damaged trace, lifted or corroded APU solder balls or pads).<br>
- Liquid Damage<br>
- Liquid Metal Damage<br>
{% if page.error == '808011FF' %}
- Bad Memcore Regulation<br>
- Memory Modules not Communicated or Responding.<br>
- All 8 Memory Modules Damaged *Not likely, check for other issues before.<br>
{% endif %}
{% if page.error | contains: '8080110F, 808011F0' %}
- 1 or more of the integrated memory controller(s) failing.(Internal or External)<br>
{% endif %}