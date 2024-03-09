---
layout: minimal
error: 808011A0
title: Unkown Error Code

subtitle: Technical Service Bulletin
permalink: /tsb/codenotfound
---

{% assign url_parts = page.url | split: '=' %}
{% assign parameter_value = url_parts | last %}

# Error Code: {{ parameter_value }}

{% assign url_parts = page.url | split: '?' %}

# Error Code: {{ url_parts }}
# Error Code: {{ url_parts.size }}
{% if url_parts.size > 1 %}
  {% assign url_params = url_parts[1] %}
  {% assign parameters = url_params | query_params %}
  {% for key in parameters %}
    Key: {{ key }}, Value: {{ parameters[key] }}
  {% endfor %}
{% endif %}
