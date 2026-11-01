-- 𐑩 𐑐𐑱𐑡 𐑢𐑦𐑞𐑬𐑑 𐑥𐑸𐑒𐑛𐑬𐑯 𐑓𐑲𐑤: 𐑥𐑧𐑑𐑩 𐑯 body(). 𐑞 𐑥𐑸𐑒𐑛𐑬𐑯 𐑦𐑟 𐑪𐑐𐑖𐑩𐑯𐑩𐑤, 𐑦𐑯 c.md 𐑚𐑤𐑪𐑒𐑕.
return {
  title = "projects",
  date = "2026-10-31",
  list = "projects",

  body = function(c, site, page)
    local md, card, profile = c.md, c.card, c.profile

    return {
      md[[
        hello it is i the projects tab
      ]],
      md[[
        this is a test of the projects tab
      ]],
    }
  end,
}
