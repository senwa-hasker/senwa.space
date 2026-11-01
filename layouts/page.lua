local h = require "h"
local base = require "layouts.base"
local article, h1, p, time, ul, li, a = h.article, h.h1, h.p, h.time, h.ul, h.li, h.a

return function(page, site)
  -- 𐑑𐑨𐑜 𐑗𐑦𐑐𐑕 𐑤𐑦𐑙𐑒 𐑑 𐑞 𐑑𐑨𐑜 𐑐𐑱𐑡 𐑪𐑝 𐑞 𐑕𐑱𐑥 𐑒𐑲𐑯𐑛 (𐑩𐑤 𐑒𐑲𐑯𐑛𐑟 𐑓𐑹 𐑞 𐑜𐑧𐑯𐑼𐑩𐑤 "page" 𐑒𐑲𐑯𐑛)
  local scope = page.kind ~= "page" and page.kind or nil
  return base(page, site, article{ class = "card",
    h1{ page.title },
    h.when(page.date, p{ class = "meta", time{ page.date } }),
    h.when(#page.tags > 0, ul{ class = "tags",
      h.each(page.tags, function(t)
        if page.virtual or not site.tag_url then return li{ t } end
        return li{ a{ href = site.tag_url(t, scope), t } }
      end),
    }),
    h.raw(page.html),
  })
end
