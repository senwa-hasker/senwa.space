---
date: "{{ .Date }}"
draft: true
featured: false
title: '{{ replace .File.ContentBaseName "-" " " | title }}'
description: "thingincardpreviews"
summary: "thingundertitleinpost"
cover: "images/projects/{{ .File.ContentBaseName }}.jpg"
categories:
  - changethis
status: "planning"
lightbox:
  enabled: true
justified_gallery:
  enabled: true
---
