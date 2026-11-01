local h = require "h"
local html, head, meta, title, link, body = h.html, h.head, h.meta, h.title, h.link, h.body
local header, nav, main, footer, a, p, span = h.header, h.nav, h.main, h.footer, h.a, h.p, h.span
local div, img = h.div, h.img

-- 𐑞 𐑖𐑧𐑤 𐑞𐑨𐑑 𐑧𐑝𐑮𐑦 𐑐𐑱𐑡 𐑖𐑺𐑟. inner = 𐑞 𐑐𐑱𐑡𐑩𐑟 𐑥𐑱𐑯 𐑒𐑪𐑯𐑑𐑧𐑯𐑑.
return function(page, site, inner)

  local css_folder = "/css"
  local css_files = {}

  local ok, ki = pcall(function()
    return io.popen("ls $PWD/static/css")
  end)

  if ok and ki then
    for file in ki:lines() do
      if file and file:match("%.css$") then
        css_files[#css_files + 1] = link{ rel = "stylesheet", href = css_folder .. "/" .. file }
      end
    end
    ki:close()
  end

  return "<!doctype html>\n" .. h.render(
    html{ lang = site.config.lang,
      head{
        meta{ charset = "utf-8" },
        meta{ name = "viewport", content = "width=device-width, initial-scale=1" },
        title{ page.title .. " | " .. site.config.title },
        css_files,
        link{ rel = "icon", type = "image/png", href = "/images/kuromi.png" },
      },
      body{
        header{ 
          nav{ 
            div{
              class="home-button",
              img{ class="icon", src = "/images/kuromi.png" },
              a{ href = "/", site.config.title },
            },
            a{ href = "/blog", "blog"},
            a{ href = "/articles", "articles"},
            a{ href = "/projects", "projects" },
            a{ href = "/webring", "webring" },
          }},
        main{ inner },
        footer{ 
          p{
            class="footer-text",
            span{class="mid", "senwa-hasker" },
            span{class="tiny", "/2026/senwa.space" },
          },
        },
        img{ class="kuromi", src = "/images/kuromi.png" }
      },
    }
  ) .. "\n"
end
