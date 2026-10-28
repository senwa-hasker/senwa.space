---
date: "{{ .Date }}"
draft: false
featured: false
title: '{{ replace .File.ContentBaseName "-" " " | title }}'
description: "thingincardpreviews"
summary: "thingundertitleinpost"
cover: "images/articles/{{ .File.ContentBaseName }}.jpg"
topics:
  - changethis
status: "planning"
lightbox:
  enabled: true
justified_gallery:
  enabled: true
---
