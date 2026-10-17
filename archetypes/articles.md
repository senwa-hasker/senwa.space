---
date: '{{ .Date }}'
draft: true
featured: false
title: '{{ replace .File.ContentBaseName "-" " " | title }}'
description: "thingincardpreviews"
summary: "thingundertitleinpost"
cover: ""
topics:
    - changethis
status: "in_progress"
lightbox:
  enabled: true
justified_gallery:
  enabled: true
slug: { { substr .File.UniqueID 0 7 } }
---
