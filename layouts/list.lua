local h = require "h"
local base = require "layouts.base"
local article, h1, h2, a, span, ul, li = h.article, h.h1, h.h2, h.a, h.span, h.ul, h.li

return function(page, site)
  -- 𐑞 𐑐𐑱𐑡𐑩𐑟 𐑪𐑝 𐑩 𐑒𐑲𐑯𐑛 (𐑛𐑦𐑓𐑷𐑤𐑑: blog). 𐑦𐑯 𐑓𐑮𐑳𐑯𐑑 𐑥𐑨𐑑𐑼 𐑿 𐑒𐑨𐑯 𐑕𐑱  list: article
  local posts = site.by_kind(page.meta.list)

  return base(page, site, article{ class = "card",
    h1{ page.title },
    h.raw(page.html),
    h2{ "Posts" },
    ul{ class = "posts",
      h.each(posts, function(post)
        if post.meta.delist == true then
          return nil
        end
        return li{ a{ href = post.url, post.title }, " ", span{ class = "meta", post.date or "" } }
      end),
    },
  })
end
