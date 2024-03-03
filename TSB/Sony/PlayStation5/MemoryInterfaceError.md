---
layout: minimal
title: 'Error {0}'
background_image: /assets/img/ps5motherboard.jpg
highlighted_areas: "1,2,4,3,5,6,7,8" # Pass any combination of area numbers separated by 
includeImageHighlights: true

subtitle: Technical Service Bulletin
permalink: /tsb/sony/playstation5/MemoryInterfaceError/
css: /assets/css/highlight_page.css
---

# Error Code: 

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

Testing Plugin

{% highlight_img_areas img:/assets/img/ps5motherboard.jpg %}
{% endhighlight_img_areas %}


## Original 

<div class="highlight_image_areas_container">
  <img class="img_highlight_image_areas" src="{{ page.background_image }}" alt="Background Image">
  {% if page.highlighted_areas %}
    {% assign selected_areas = page.highlighted_areas | split: ',' %}
    {% for area_id in selected_areas %}
      {% assign area_info = site.data.highlight_areas | where: "id", area_id | first %}
      {% if area_info %}
         <div class="highlight" name="bank-{{ area_info.id }}" style="top: {{ area_info.top }}%; left: {{ area_info.left }}%; width: {{ area_info.width }}%; height: {{ area_info.height }}%;">
      {{ area_info.id }}
      </div>  
      {% endif %}
    {% endfor %}
  {% endif %}
</div>