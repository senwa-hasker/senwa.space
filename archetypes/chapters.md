---
date: '{{ .Date }}'
draft: false
featured: false
title: '{{ replace .File.ContentBaseName "-" " " | title }}'
description: "thingincardpreviews"
summary: "thingundertitleinpost"
cover: 'images/books/{{.File.ContentBaseName}}/cover.jpg'
books:
    - Rooms to Mates
status: "in_progress"
lightbox:
  enabled: true
justified_gallery:
  enabled: true
---
