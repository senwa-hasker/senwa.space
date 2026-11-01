-- 𐑣𐑑𐑥𐑩𐑤 𐑚𐑦𐑤𐑛𐑼: 𐑑𐑨𐑜 𐑓𐑳𐑙𐑒𐑖𐑩𐑯𐑟 𐑞𐑨𐑑 𐑑𐑻𐑯 𐑑𐑱𐑚𐑩𐑤𐑟 𐑦𐑯𐑑𐑵 𐑣𐑑𐑥𐑩𐑤.
-- h.div{ class = "card", h.h1{ "hi" } }  ->  <div class="card"><h1>hi</h1></div>
local M = {}

local escapes = { ["&"] = "&amp;", ["<"] = "&lt;", [">"] = "&gt;", ['"'] = "&quot;" }
local function esc(s) return (tostring(s):gsub('[&<>"]', escapes)) end
M.esc = esc

-- 𐑮𐑷 = 𐑣𐑑𐑥𐑩𐑤 𐑞𐑨𐑑 𐑦𐑟 𐑷𐑤𐑮𐑧𐑛𐑦 𐑕𐑱𐑓, 𐑕𐑴 𐑦𐑑 𐑦𐑟 𐑯𐑭𐑑 𐑦𐑕𐑒𐑱𐑐𐑑 𐑩𐑜𐑧𐑯.
local Raw = {}
function M.raw(s) return setmetatable({ s = s }, Raw) end

-- 𐑕𐑑𐑮𐑦𐑙𐑟 𐑜𐑧𐑑 𐑦𐑕𐑒𐑱𐑐𐑑, 𐑮𐑷 𐑦𐑟 𐑒𐑧𐑐𐑑, 𐑤𐑦𐑕𐑑𐑕 𐑜𐑧𐑑 𐑓𐑤𐑨𐑑𐑩𐑯𐑛.
local function render(x)
  if type(x) == "table" then
    if getmetatable(x) == Raw then return x.s end
    local out = {}
    for i, child in ipairs(x) do out[i] = render(child) end
    return table.concat(out)
  elseif x == nil or x == true or x == false then
    return ""
  end
  return esc(x)
end
M.render = render

-- 𐑝𐑶𐑛 𐑧𐑤𐑦𐑥𐑩𐑯𐑑𐑕 𐑣𐑨𐑝 𐑯𐑴 𐑒𐑤𐑴𐑟𐑦𐑙 𐑑𐑨𐑜.
local void = { area = 1, base = 1, br = 1, col = 1, hr = 1, img = 1,
               input = 1, link = 1, meta = 1, source = 1 }

local function element(name)
  return function(args)
    -- div"text" 𐑯 div(h.raw"x") 𐑢𐑻𐑒 𐑑𐑵
    if type(args) ~= "table" or getmetatable(args) == Raw then args = { args } end
    local attrs = {}
    for k, v in pairs(args) do
      if type(k) == "string" and v ~= false and v ~= nil then
        attrs[#attrs + 1] = (v == true) and (" " .. k) or (" " .. k .. '="' .. esc(v) .. '"')
      end
    end
    table.sort(attrs)
    local open = "<" .. name .. table.concat(attrs) .. ">"
    if void[name] then return M.raw(open) end
    return M.raw(open .. render(args) .. "</" .. name .. ">")
  end
end

-- 𐑯𐑦𐑤 𐑦𐑯 𐑩 𐑤𐑦𐑕𐑑 𐑧𐑯𐑛𐑟 𐑦𐑑, 𐑕𐑴 𐑿𐑟 when() 𐑓𐑹 𐑒𐑪𐑯𐑛𐑦𐑖𐑩𐑯𐑟.
function M.when(cond, node) return cond and node or false end

function M.each(list, fn)
  local out = {}
  for i, v in ipairs(list) do
    local node = fn(v, i)
    -- 𐑯𐑦𐑤 𐑹 𐑓𐑪𐑤𐑕 = 𐑕𐑒𐑦𐑐 𐑞𐑦𐑕 𐑦𐑑𐑩𐑥 (𐑯𐑴 𐑣𐑴𐑤𐑟 𐑦𐑯 𐑞 𐑤𐑦𐑕𐑑)
    if node ~= nil and node ~= false then out[#out + 1] = node end
  end
  return out
end

return setmetatable(M, {
  __index = function(t, name)
    local f = element(name)
    rawset(t, name, f)
    return f
  end,
})
