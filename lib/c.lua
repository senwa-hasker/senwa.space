-- 𐑒𐑩𐑥𐑐𐑴𐑯𐑩𐑯𐑑𐑕: 𐑢𐑳𐑯 𐑯𐑱𐑥𐑕𐑐𐑱𐑕 𐑓𐑹 𐑧𐑝𐑮𐑦𐑔𐑦𐑙 𐑿 𐑒𐑨𐑯 𐑯𐑱𐑕𐑑.
--   c.card{ ... }   -> 𐑓𐑲𐑤 components/card.lua  (𐑩 𐑒𐑩𐑥𐑐𐑴𐑯𐑩𐑯𐑑 𐑦𐑟 𐑓𐑳𐑙𐑒𐑖𐑩𐑯(props, c))
--   c.div{ ... }    -> 𐑞 𐑣𐑑𐑥𐑩𐑤 𐑑𐑨𐑜 (𐑦𐑓 𐑯𐑴 𐑒𐑩𐑥𐑐𐑴𐑯𐑩𐑯𐑑 𐑣𐑨𐑟 𐑞𐑨𐑑 𐑯𐑱𐑥)
--   c.md[[ text ]]  -> 𐑥𐑸𐑒𐑛𐑬𐑯 𐑦𐑯 𐑞 𐑥𐑦𐑛𐑩𐑤 𐑪𐑝 𐑒𐑴𐑛
--   c.each / c.when / c.raw -> 𐑞 𐑣𐑧𐑤𐑐𐑼𐑟 𐑓𐑮𐑪𐑥 h.lua
-- 𐑒𐑩𐑥𐑐𐑴𐑯𐑩𐑯𐑑𐑕 𐑜𐑧𐑑 c 𐑩𐑜𐑧𐑯, 𐑕𐑴 𐑞𐑱 𐑒𐑨𐑯 𐑿𐑟 𐑳𐑞𐑼 𐑒𐑩𐑥𐑐𐑴𐑯𐑩𐑯𐑑𐑕.
local h = require "h"

-- 𐑮𐑦𐑥𐑵𐑝 𐑞 𐑦𐑯𐑛𐑧𐑯𐑑𐑱𐑖𐑩𐑯 𐑞𐑨𐑑 𐑩𐑤 𐑤𐑲𐑯𐑟 𐑖𐑺, 𐑕𐑴 𐑦𐑯𐑛𐑧𐑯𐑑𐑩𐑛 𐑑𐑧𐑒𐑕𐑑 𐑦𐑟 𐑯𐑭𐑑 𐑑𐑻𐑯𐑛 𐑦𐑯𐑑𐑵 𐑒𐑴𐑛
local function dedent(s)
  s = s:gsub("^\n", "")
  local min
  for line in s:gmatch("[^\n]+") do
    if line:find("%S") then
      local n = #line:match("^[ \t]*")
      if not min or n < min then min = n end
    end
  end
  if not min or min == 0 then return s end
  return (s:gsub("[^\n]*", function(line) return line:sub(min + 1) end))
end

return function(site)
  local c = {}
  return setmetatable(c, {
    __index = function(t, name)
      local f
      if name == "md" then
        f = function(text) return h.raw(site.markdown(dedent(text))) end
      elseif name == "part" then
        -- c.part("intro", nodes): 𐑯𐑱𐑥 𐑩 𐑐𐑸𐑑 𐑪𐑝 𐑞 𐑐𐑱𐑡 𐑞𐑨𐑑 𐑩𐑯𐑳𐑞𐑼 𐑐𐑱𐑡 𐑒𐑨𐑯 c.embed
        f = function(pname, nodes)
          local cur = site.stack[#site.stack]
          assert(cur, "c.part() only works while a page is being rendered")
          local html = h.render(nodes)
          cur.parts[pname] = html
          return h.raw(html)
        end
      elseif name == "embed" then
        -- c.embed("blog/b1")  𐑣𐑬𐑤 𐑐𐑱𐑡    c.embed("blog/b1", "haha-title")  𐑢𐑳𐑯 𐑕𐑧𐑒𐑖𐑩𐑯
        f = function(ref, part)
          local page = site.find(ref)
          if not page then error("embed: no page matches " .. tostring(ref), 2) end
          return h.raw(part and site.part(page, part) or site.content(page))
        end
      elseif package.searchpath("components." .. name, package.path) then
        local impl = require("components." .. name)
        f = function(props) return impl(props, c) end
      else
        f = h[name]
      end
      rawset(t, name, f)
      return f
    end,
  })
end
