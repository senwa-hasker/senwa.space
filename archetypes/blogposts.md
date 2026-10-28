---
date: "{{ .Date }}"
draft: false
featured: false
title: '{{ replace .File.ContentBaseName "-" " " | title }}'
description: "thingincardpreviews"
summary: "thingundertitleinpost"
cover: "images/blog/{{ .File.ContentBaseName }}.jpg"
tags:
  - changethis
status: "in_progress"
lightbox:
  enabled: true
justified_gallery:
  enabled: true
---
