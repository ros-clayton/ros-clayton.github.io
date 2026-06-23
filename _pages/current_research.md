---
layout: page
permalink: /current-research/
title: Research
nav: true
nav_order: 2
---

## Working Papers

{% for paper in site.data.cv_content.working_papers %}
{% if paper.url %}
**[{{ paper.title }}]({{ paper.url }})**
{% else %}
**{{ paper.title }}**
{% endif %}

{% if paper.coauthors %}({{ paper.coauthors }}){% endif %}

{{ paper.status }}

{{ paper.description }}

{% unless forloop.last %}---{% endunless %}
{% endfor %}

## In Progress

{% for project in site.data.cv_content.in_progress %}
**{{ project.title }}**

{{ project.description }}
{% endfor %}
