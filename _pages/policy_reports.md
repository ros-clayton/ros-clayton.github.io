---
layout: page
permalink: /policy-reports/
title: Policy Engagements
description: 
nav: true
nav_order: 4
---

## Policy Reports

{% for report in site.data.cv_content.policy_reports %}
- {% if report.url %}**[{{ report.title }}]({{ report.url }})**{% else %}**{{ report.title }}**{% endif %} ({{ report.detail }})
{% endfor %}

## Policy Presentations

{% for presentation in site.data.cv_content.policy_presentations %}
- {% if presentation.url %}**[{{ presentation.title }}]({{ presentation.url }})**{% else %}**{{ presentation.title }}**{% endif %} ({% if presentation.detail_html %}{{ presentation.detail_html }}{% else %}{{ presentation.detail }}{% endif %})
{% endfor %}
