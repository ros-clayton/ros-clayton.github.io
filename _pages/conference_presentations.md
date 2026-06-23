---
layout: page
permalink: /conference-presentations/
title: Conference Presentations
description: 
nav: true
nav_order: 3
---

{% for presentation in site.data.cv_content.conference_presentations %}
- {% if presentation.url %}**[{{ presentation.title }}]({{ presentation.url }})**{% else %}**{{ presentation.title }}**{% endif %} ({{ presentation.detail }})
{% endfor %}
