-- 𐑩 𐑐𐑱𐑡 𐑢𐑦𐑞𐑬𐑑 𐑥𐑸𐑒𐑛𐑬𐑯 𐑓𐑲𐑤: 𐑥𐑧𐑑𐑩 𐑯 body(). 𐑞 𐑥𐑸𐑒𐑛𐑬𐑯 𐑦𐑟 𐑪𐑐𐑖𐑩𐑯𐑩𐑤, 𐑦𐑯 c.md 𐑚𐑤𐑪𐑒𐑕.
return {
  title = "lab",
  layout = "page",
  date = "2026-10-31",
  tags = { "code", "test" },

  body = function(c, site, page)
    local md, card, profile = c.md, c.card, c.profile

    return {
      md[[
        This paragraph is **Markdown** inside a Lua page.
        The block is dedented for you, so indent it however you like.
      ]],

      profile{ name = "senwa", avatar = "/images/kuromi.png", bio = "a component built from another component" },

      md[[
        Text, then code, then text again.
      ]],

      -- 𐑩 𐑯𐑱𐑥𐑛 𐑐𐑸𐑑: 𐑩𐑯𐑳𐑞𐑼 𐑐𐑱𐑡 𐑒𐑨𐑯 c.embed("lab", "pages") 𐑦𐑑
      c.part("pages", card{ title = "blog posts",
        c.postlist{ pages = site.by_kind("blog") },
      }),

      -- 𐑦𐑥𐑚𐑧𐑛 𐑩 𐑕𐑧𐑒𐑖𐑩𐑯 𐑪𐑝 𐑩 𐑥𐑸𐑒𐑛𐑬𐑯 𐑐𐑱𐑡: 𐑞 "## haha title" 𐑐𐑸𐑑 𐑪𐑝 blog/b1
      card{ title = "embedded: a section of blog/b1",
        c.embed("blog/b1", "haha-title"),
      },
    }
  end,
}
