-- 𐑩 𐑥𐑪𐑛 = 𐑩 𐑓𐑳𐑙𐑒𐑖𐑩𐑯 𐑞𐑨𐑑 𐑮𐑧𐑡𐑦𐑕𐑑𐑼𐑟 𐑣𐑫𐑒𐑕. 𐑞𐑦𐑕 𐑢𐑳𐑯 𐑮𐑲𐑑𐑕 sitemap.xml 𐑨𐑓𐑑𐑼 𐑞 𐑚𐑦𐑤𐑛.
local h = require "h"

return function(hooks)
  table.insert(hooks.after_write, function(site)
    local lines = { '<?xml version="1.0" encoding="UTF-8"?>',
                    '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' }
    for _, page in ipairs(site.pages) do
      lines[#lines + 1] = "  <url><loc>" .. h.esc(site.config.url .. page.url) .. "</loc></url>"
    end
    lines[#lines + 1] = "</urlset>\n"
    site.write(site.config.out .. "/sitemap.xml", table.concat(lines, "\n"))
  end)
end
