local h = require "h"
local base = require "layouts.base"
local article, h1, h2, a, span, ul, li, div, p = h.article, h.h1, h.h2, h.a, h.span, h.ul, h.li, h.div, h.p

return function(page, site)
  -- 𐑒𐑩𐑤𐑧𐑒𐑖𐑩𐑯: 𐑩𐑤 𐑐𐑱𐑡𐑩𐑟 𐑢𐑪𐑟 𐑿𐑸𐑧𐑤 𐑕𐑑𐑸𐑑𐑕 𐑢𐑦𐑞 /blog/
  local posts = {}
  for _, item in ipairs(site.pages) do
    if item.url:find("^/blog/") then posts[#posts + 1] = item end
  end

  local webring = {}
  for _, entry in ipairs(site.webring) do
    webring[#webring + 1] = a{ href = entry.url, alt = entry.name, target = "_blank", h.img{ class="blinkie", src = entry.icon }}
  end

  return base(page, site, article{ class = "card",
    h1{ page.title },
    h.raw(page.html),
    {div{
      class = "webring-images",
      webring
    }},
  })
end
