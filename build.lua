-- 𐑚𐑦𐑤𐑛: 𐑥𐑸𐑒𐑛𐑬𐑯 𐑯 𐑤𐑱𐑬𐑑𐑕 𐑦𐑯, 𐑕𐑑𐑨𐑑𐑦𐑒 𐑕𐑲𐑑 𐑬𐑑. 𐑮𐑳𐑯 𐑦𐑑 𐑓𐑮𐑪𐑥 𐑞 𐑐𐑮𐑭𐑡𐑧𐑒𐑑 𐑓𐑴𐑤𐑛𐑼:  texlua build.lua  (𐑹 lua build.lua)
package.path = "./?.lua;./lib/?.lua;" .. package.path
local h = require "h"
local make_components = require "c"

local config = {
  title = "senwa.space",
  author = "Senwa Hasker",
  lang = "en",
  url = "https://senwa.space",
  content = "content",
  static = "static",
  out = "public",
  mods = "mods",
  -- 𐑞 𐑧𐑯𐑝 𐑝𐑺𐑦𐑩𐑚𐑩𐑤 𐑤𐑧𐑑𐑕 𐑿 𐑕𐑢𐑪𐑐 𐑞 𐑥𐑸𐑒𐑛𐑬𐑯 𐑒𐑩𐑥𐑪𐑯𐑛 𐑢𐑦𐑞𐑬𐑑 𐑧𐑛𐑦𐑑𐑦𐑙 𐑞𐑦𐑕 𐑓𐑲𐑤
  markdown_cmd = os.getenv("MARKDOWN_CMD") or "pandoc -f gfm -t html --syntax-highlighting=none",

  -- 𐑒𐑲𐑯𐑛𐑟 𐑪𐑝 𐑐𐑪𐑕𐑑: 𐑞 𐑓𐑻𐑕𐑑 𐑓𐑴𐑤𐑛𐑼 𐑦𐑯 content/ (𐑹 𐑩 kind: 𐑒𐑰 𐑦𐑯 𐑞 𐑓𐑮𐑳𐑯𐑑 𐑥𐑨𐑑𐑼). 𐑞 𐑹𐑛𐑼 𐑣𐑽 = 𐑞 𐑹𐑛𐑼 𐑦𐑯 𐑞 𐑕𐑲𐑑.
  kinds = {
    { id = "blog", title = "Blog" },
    { id = "article", title = "Articles" },
    { id = "poem", title = "Poems" },
    { id = "page", title = "Pages" },
  },

  -- 𐑩𐑐𐑖𐑩𐑯𐑩𐑤 𐑑𐑨𐑜 𐑛𐑧𐑓𐑦𐑯𐑦𐑖𐑩𐑯𐑟, 𐑒𐑰𐑛 𐑚𐑲 𐑞 𐑑𐑨𐑜𐑕 𐑕𐑤𐑩𐑜: title, description, icon
  tags = {
    code = { description = "making things with code" },
  },
}

local webring = {
  { name = "Senwa's Blog", url = "https://senwa.space", icon = "/images/webring/senwa.gif" },
  { name = "quaerere", url = "https://quaere.re", icon = "/images/webring/quaerere.gif" },
  { name = "glocean", url = "https://glocean.dev", icon = "/images/webring/glocean.gif" },
  { name = "44-free", url = "https://akimons.codeberg.page/", icon = "/images/webring/44-free.gif" },
  { name = "blix", url = "https://0x4248.dev/", icon = "/images/webring/blix.gif" },
  { name = "ayulume", url = "https://ayulume.is-a.dev/", icon = "/images/webring/ayulume.gif" },
  { name = "dramaticdecay", url = "https://dramaticdecay.neocities.org/", icon = "/images/webring/dramaticdecay.gif" },
}

-- 𐑣𐑫𐑒𐑕: 𐑥𐑪𐑛𐑟 𐑨𐑛 𐑓𐑳𐑙𐑒𐑖𐑩𐑯𐑟 𐑣𐑽. 𐑞 𐑒𐑹 𐑚𐑦𐑤𐑛 𐑿𐑟𐑩𐑟 𐑞 𐑕𐑱𐑥 𐑣𐑫𐑒𐑕.
local hooks = { after_parse = {}, before_render = {}, after_write = {} }
local function run(stage, ...)
  for _, fn in ipairs(hooks[stage]) do fn(...) end
end

-- 𐑖𐑧𐑤 𐑣𐑧𐑤𐑐𐑼𐑟
local function q(s) return "'" .. (s:gsub("'", "'\\''")) .. "'" end

local function read(path)
  local f = assert(io.open(path, "rb"))
  local s = f:read("*a")
  f:close()
  return s
end

local function write(path, s)
  os.execute("mkdir -p " .. q(path:match("^(.*)/[^/]*$") or "."))
  local f = assert(io.open(path, "wb"))
  f:write(s)
  f:close()
end

local function list(dir, glob)
  local out = {}
  local p = assert(io.popen("find " .. q(dir) .. " -type f -name " .. q(glob) .. " 2>/dev/null | sort"))
  for line in p:lines() do out[#out + 1] = line end
  p:close()
  return out
end

-- 𐑓𐑮𐑳𐑯𐑑 𐑥𐑨𐑑𐑼: 𐑞 𐑚𐑤𐑪𐑒 𐑚𐑦𐑑𐑢𐑰𐑯 𐑞 𐑑𐑵 --- 𐑤𐑲𐑯𐑟, 𐑢𐑳𐑯 "key: value" 𐑐𐑻 𐑤𐑲𐑯.
local function unquote(v)
  v = v:match("^%s*(.-)%s*$")
  return v:match('^"(.*)"$') or v:match("^'(.*)'$") or v
end

local function value(v)
  if v == "true" then return true end
  if v == "false" then return false end
  local items = v:match("^%[(.*)%]$")
  if items then
    local t = {}
    for item in items:gmatch("[^,]+") do t[#t + 1] = unquote(item) end
    return t
  end
  return unquote(v)
end

local function parse(src)
  src = src:gsub("\r\n", "\n") .. "\n"
  local meta, body = {}, src
  local fm, rest = src:match("^%-%-%-\n(.-)\n%-%-%-[ \t]*\n(.*)$")
  if fm then
    body = rest
    for line in fm:gmatch("[^\n]+") do
      local k, v = line:match("^([%w_%-]+):%s*(.-)%s*$")
      if k then meta[k] = value(v) end
    end
  end
  return meta, body
end

-- 𐑥𐑸𐑒𐑛𐑬𐑯 → 𐑣𐑑𐑥𐑩𐑤. 𐑞 𐑢𐑳𐑯 𐑐𐑤𐑱𐑕 𐑞𐑨𐑑 𐑯𐑰𐑛𐑟 𐑐𐑨𐑯𐑛𐑪𐑒; 𐑕𐑢𐑪𐑐 𐑦𐑑 𐑤𐑱𐑑𐑼.
local function markdown(src)
  local tmp = os.tmpname()
  write(tmp, src)
  local p = assert(io.popen(config.markdown_cmd .. " " .. q(tmp)))
  local html = p:read("*a")
  local ok = p:close()
  os.remove(tmp)
  assert(ok, "markdown command failed: " .. config.markdown_cmd)
  return html
end

-- "About me" -> "about-me". 𐑯𐑭𐑯-𐑨𐑕𐑒𐑦 𐑤𐑧𐑑𐑼𐑟 (𐑧𐑒𐑕𐑩𐑯𐑑𐑕, 𐑕𐑒𐑮𐑦𐑐𐑑𐑕) 𐑕𐑑𐑱 𐑩𐑑 𐑞𐑱 𐑮.
local function slug(s)
  s = tostring(s):lower():gsub("[^%w\128-\255]+", "-"):gsub("^%-+", ""):gsub("%-+$", "")
  return s
end

-- 𐑕𐑐𐑤𐑦𐑑 𐑥𐑸𐑒𐑛𐑬𐑯 𐑦𐑯𐑑𐑵 𐑕𐑧𐑒𐑖𐑩𐑯𐑟 𐑨𐑑 "## heading" 𐑤𐑲𐑯𐑟 (𐑯𐑭𐑑 𐑦𐑯𐑕𐑲𐑛 𐑒𐑴𐑛 𐑓𐑧𐑯𐑕𐑩𐑟).
-- 𐑞 𐑑𐑧𐑒𐑕𐑑 𐑚𐑦𐑓𐑹 𐑞 𐑓𐑻𐑕𐑑 𐑣𐑧𐑛𐑦𐑙 𐑦𐑟 𐑞 𐑕𐑧𐑒𐑖𐑩𐑯 "intro".
local function split_sections(body)
  local sections, order = {}, {}
  local cur = { name = "intro", lines = {} }
  local function finish()
    if not sections[cur.name] then
      sections[cur.name] = cur
      order[#order + 1] = cur.name
    end
  end
  local fence = false
  for line in (body .. "\n"):gmatch("(.-)\n") do
    if line:match("^```") or line:match("^~~~") then fence = not fence end
    local heading = (not fence) and line:match("^##%s+(.-)%s*$")
    if heading then
      finish()
      cur = { name = slug(heading), lines = { line } }
    else
      cur.lines[#cur.lines + 1] = line
    end
  end
  finish()
  return sections, order
end

-- 𐑐𐑱𐑡 𐑓𐑲𐑤: .md (𐑑𐑧𐑒𐑕𐑑 + 𐑓𐑮𐑳𐑯𐑑 𐑥𐑨𐑑𐑼) 𐑹 .lua (𐑩 𐑑𐑱𐑚𐑩𐑤 𐑢𐑦𐑞 𐑥𐑧𐑑𐑩 𐑯 𐑩 body() 𐑓𐑳𐑙𐑒𐑖𐑩𐑯)
local function load_page(path)
  if path:match("%.lua$") then
    local chunk = assert(dofile(path))
    local meta = {}
    for k, v in pairs(chunk) do
      if k ~= "body" then meta[k] = v end
    end
    return meta, nil, chunk.body
  end
  local meta, body = parse(read(path))
  return meta, body, nil
end

-- blog/b1.md -> 𐑿𐑸𐑧𐑤 /blog/b1/  𐑯 𐑓𐑲𐑤 blog/b1/index.html
local function url_for(rel)
  local base = rel:gsub("%.%w+$", "")
  if base == "index" then return "/", "index.html" end
  base = base:gsub("/index$", "")
  return "/" .. base .. "/", base .. "/index.html"
end

local function build()
  assert(config.out ~= "" and config.out ~= "." and config.out ~= "/", "unsafe output dir")

  local site = { config = config, webring = webring, pages = {}, read = read, write = write,
                 markdown = markdown }
  local c = make_components(site)
  site.c = c
  site.slug = slug

  -- 𐑓𐑲𐑯𐑛 𐑩 𐑐𐑱𐑡 𐑚𐑲 𐑿𐑸𐑧𐑤 ("/about/", "about"), 𐑓𐑲𐑤 𐑐𐑭𐑔 ("blog/b1"), id: 𐑒𐑰, 𐑹 𐑞 𐑐𐑱𐑡 𐑦𐑑𐑕𐑧𐑤𐑓
  function site.find(ref)
    if type(ref) == "table" then return ref end
    local key = tostring(ref):gsub("^/+", ""):gsub("/+$", "")
    for _, p in ipairs(site.pages) do
      if p.key == key or (p.meta.id ~= nil and p.meta.id == ref) then return p end
    end
  end

  -- 𐑮𐑩𐑤 𐑐𐑱𐑡𐑩𐑟 𐑪𐑝 𐑩 𐑒𐑲𐑯𐑛, 𐑯𐑵𐑦𐑕𐑑 𐑓𐑻𐑕𐑑, 𐑢𐑦𐑞𐑬𐑑 𐑛𐑦𐑤𐑦𐑕𐑑𐑩𐑛 𐑹 𐑡𐑧𐑯𐑩𐑮𐑱𐑑𐑩𐑛 𐑐𐑱𐑡𐑩𐑟
  function site.by_kind(kind)
    local out = {}
    for _, p in ipairs(site.pages) do
      if p.kind == kind and not p.virtual and not p.meta.delist then out[#out + 1] = p end
    end
    return out
  end

  -- 𐑞 𐑐𐑱𐑡𐑩𐑟 𐑣𐑑𐑥𐑩𐑤, 𐑮𐑧𐑯𐑛𐑼𐑛 𐑢𐑳𐑯 𐑯 𐑒𐑨𐑖𐑑. 𐑞 stack 𐑒𐑨𐑗𐑩𐑟 𐑦𐑥𐑚𐑧𐑛 𐑕𐑲𐑒𐑩𐑤𐑟 (𐑩 𐑦𐑥𐑚𐑧𐑛𐑦𐑙 𐑩 𐑦𐑥𐑚𐑧𐑛𐑦𐑙 𐑩).
  local stack = {}
  site.stack = stack
  function site.content(page)
    if page.html then return page.html end
    local chain, cyclic = {}, false
    for _, p in ipairs(stack) do
      chain[#chain + 1] = p.url
      if p == page then cyclic = true end
    end
    if cyclic then
      error("embed cycle: " .. table.concat(chain, " -> ") .. " -> " .. page.url, 0)
    end
    stack[#stack + 1] = page
    page.parts = {}
    if page.render then
      page.html = h.render(page.render(c, site, page))
    else
      page.html = markdown(page.body)
    end
    stack[#stack] = nil
    return page.html
  end

  -- 𐑢𐑳𐑯 𐑯𐑱𐑥𐑛 𐑕𐑧𐑒𐑖𐑩𐑯 𐑪𐑝 𐑩 𐑐𐑱𐑡. 𐑥𐑸𐑒𐑛𐑬𐑯: ## 𐑣𐑧𐑛𐑦𐑙𐑟; 𐑤𐑵𐑩: c.part("name", ...)
  function site.part(page, name)
    site.content(page)
    local html, names = nil, {}
    if page.render then
      html = page.parts[name]
      for n in pairs(page.parts) do names[#names + 1] = n end
    else
      if not page.sections then page.sections, page.section_order = split_sections(page.body) end
      local sec = page.sections[name]
      if sec then
        if not sec.html then sec.html = markdown(table.concat(sec.lines, "\n")) end
        html = sec.html
      end
      names = page.section_order
    end
    if not html then
      table.sort(names)
      error(("page %s has no section %q (it has: %s)"):format(page.url, name, table.concat(names, ", ")), 0)
    end
    return html
  end

  for _, path in ipairs(list(config.mods, "*.lua")) do
    local modname = path:gsub("%.lua$", ""):gsub("/", ".")
    require(modname)(hooks, config)
  end

  -- 𐑮𐑰𐑛 𐑧𐑝𐑮𐑦 𐑥𐑸𐑒𐑛𐑬𐑯 𐑓𐑲𐑤, 𐑕𐑒𐑦𐑐 𐑛𐑮𐑨𐑓𐑑𐑕
  local files = list(config.content, "*.md")
  for _, path in ipairs(list(config.content, "*.lua")) do files[#files + 1] = path end
  for _, path in ipairs(files) do
    local rel = path:sub(#config.content + 2)
    local meta, body, render_fn = load_page(path)
    if not meta.draft then
      local url, out = url_for(rel)
      local tags = meta.tags
      if type(tags) == "string" then tags = { tags } end
      site.pages[#site.pages + 1] = {
        meta = meta, body = body, render = render_fn, url = url, out = out,
        title = meta.title or rel, date = meta.date,
        tags = tags or {}, layout = meta.layout or "page",
        kind = meta.kind or rel:match("^([^/]+)/") or "page",
        key = url:gsub("^/+", ""):gsub("/+$", ""),
      }
    end
  end

  -- 𐑯𐑵𐑦𐑕𐑑 𐑓𐑻𐑕𐑑
  table.sort(site.pages, function(a, b)
    local da, db = a.date or "", b.date or ""
    if da ~= db then return da > db end
    return a.title < b.title
  end)

  run("after_parse", site)

  os.execute("rm -rf " .. q(config.out))
  os.execute("mkdir -p " .. q(config.out))
  if os.execute("test -d " .. q(config.static)) then
    os.execute("cp -r " .. q(config.static) .. "/. " .. q(config.out) .. "/")
  end

  -- 𐑥𐑸𐑒𐑛𐑬𐑯 𐑓𐑻𐑕𐑑 (𐑞𐑱 𐑦𐑯𐑜𐑵 𐑩 𐑤𐑱𐑬𐑑𐑕 𐑯𐑰𐑛 𐑞 𐑣𐑑𐑥𐑩𐑤), 𐑞𐑧𐑯 𐑤𐑱𐑬𐑑
  for _, page in ipairs(site.pages) do site.content(page) end
  for _, page in ipairs(site.pages) do
    run("before_render", page, site)
    local layout = require("layouts." .. page.layout)
    write(config.out .. "/" .. page.out, layout(page, site, c))
  end

  run("after_write", site)
  print(("built %d pages -> %s/"):format(#site.pages, config.out))
end

build()
