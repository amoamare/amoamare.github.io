
# {{ page.title }}

### Table of Contents
1. [Overview](#overview)
2. [Models](#models)
3. [Symptom / Condition](#symptom--condition)
4. [Possible Problems](#possible-problems)
5. [IC Images and Locations](#ic-images-and-locations)
6. [Diagnosis](#diagnosis)
6. [Repair Procedure](#repair-procedure)
6. [Parts Information](#parts-information)

# GDDR6 Memory Banks No Reponse

#### GDDR6 Memory Bank Refrence Locations EDM-001,002,003 etc
{% highlight_img_areas site.data.highlight_areas.EDM001.GDDR6 %}
{% endhighlight_img_areas %}

## Symptom / Condition
When trying to power on the console, the console will give a single beep and a 1 second blue light, then power off.

## Possible Problems
- Bad Communication From APU (Damaged trace, lifted or corroded APU solder balls or pads).<br>
- Liquid Damage
- Liquid Metal Damage
{% if page.error == '808011FF' %}
- Bad Memcore<br>
- All Ram Modules Damaged *Not likely, check for other issues before.<br>
{% endif %}
{% if page.error | contains: '8080110F, 808011F0' %}
- 1 or more of the integrated memory controller(s) failing.(Internal or External)<br>
{% endif %}