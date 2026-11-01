-- 𐑑𐑨𐑜𐑟 𐑢𐑦𐑞 𐑒𐑲𐑯𐑛𐑟. 𐑩 𐑒𐑲𐑯𐑛 = 𐑞 𐑓𐑻𐑕𐑑 𐑓𐑴𐑤𐑛𐑼 𐑦𐑯 content/ (𐑹 𐑩 kind: 𐑒𐑰). 𐑞𐑦𐑕 𐑥𐑪𐑛 𐑥𐑱𐑒𐑕:
--   /tags/                 𐑩𐑤 𐑑𐑨𐑜𐑟, 𐑩𐑤 𐑒𐑲𐑯𐑛𐑟 𐑯 𐑞𐑩𐑯 𐑚𐑲 𐑒𐑲𐑯𐑛
--   /tags/<tag>/           𐑩𐑤 𐑐𐑱𐑡𐑩𐑟 𐑢𐑦𐑞 𐑞 𐑑𐑨𐑜, 𐑜𐑮𐑵𐑐𐑑 𐑚𐑲 𐑒𐑲𐑯𐑛
--   /<kind>/tags/<tag>/    𐑪𐑯𐑤𐑦 𐑞𐑨𐑑 𐑒𐑲𐑯𐑛
-- 𐑦𐑑 𐑨𐑤𐑕𐑴 𐑕𐑧𐑑𐑕 site.tags, site.tag_list, site.tag_url(name[, kind]) 𐑓𐑹 𐑤𐑱𐑬𐑑𐑕 𐑯 𐑒𐑩𐑥𐑐𐑴𐑯𐑩𐑯𐑑𐑕.
return function(hooks, config)
  table.insert(hooks.after_parse, function(site)
    local slug = site.slug

    local function kind_title(id)
      for _, k in ipairs(config.kinds or {}) do
        if k.id == id then return k.title end
      end
      return id:sub(1, 1):upper() .. id:sub(2)
    end

    -- 𐑒𐑲𐑯𐑛 𐑦𐑛𐑟 𐑦𐑯 config.kinds 𐑹𐑛𐑼, 𐑞𐑧𐑯 𐑞 𐑮𐑧𐑕𐑑 𐑩𐑤𐑓𐑩𐑚𐑧𐑑𐑦𐑒𐑩𐑤𐑦
    local function ordered(set)
      local out, seen, rest = {}, {}, {}
      for _, k in ipairs(config.kinds or {}) do
        if set[k.id] then out[#out + 1] = k.id; seen[k.id] = true end
      end
      for id in pairs(set) do
        if not seen[id] then rest[#rest + 1] = id end
      end
      table.sort(rest)
      for _, id in ipairs(rest) do out[#out + 1] = id end
      return out
    end

    local function tag_url(name, kind)
      local s = slug(name)
      if kind then return "/" .. kind .. "/tags/" .. s .. "/" end
      return "/tags/" .. s .. "/"
    end
    site.tag_url, site.kind_title = tag_url, kind_title

    -- 𐑒𐑪𐑤𐑧𐑒𐑑: tags[slug] = { name, def, pages = {...}, kinds = { blog = {...}, ... } }
    local tags, list = {}, {}
    for _, page in ipairs(site.pages) do
      if not page.virtual and not page.meta.delist then
        local seen = {}
        for _, name in ipairs(page.tags) do
          local s = slug(name)
          if s ~= "" and not seen[s] then
            seen[s] = true
            local tag = tags[s]
            if not tag then
              local def = (config.tags or {})[s] or {}
              tag = { slug = s, name = def.title or name, def = def, pages = {}, kinds = {} }
              tags[s] = tag
              list[#list + 1] = tag
            end
            tag.pages[#tag.pages + 1] = page
            local bucket = tag.kinds[page.kind]
            if not bucket then bucket = {}; tag.kinds[page.kind] = bucket end
            bucket[#bucket + 1] = page
          end
        end
      end
    end
    table.sort(list, function(a, b) return a.slug < b.slug end)
    site.tags, site.tag_list = tags, list

    -- 𐑝𐑻𐑗𐑩𐑢𐑩𐑤 𐑐𐑱𐑡𐑩𐑟: 𐑛𐑱𐑑𐑩 𐑓𐑹 𐑞 𐑚𐑦𐑤𐑛, 𐑯𐑴 𐑓𐑲𐑤 𐑦𐑯 content/
    local function add(url, title, render)
      site.pages[#site.pages + 1] = {
        meta = { delist = true }, virtual = true, kind = "tags",
        url = url, key = url:gsub("^/+", ""):gsub("/+$", ""),
        out = url:gsub("^/", "") .. "index.html",
        title = title, tags = {}, layout = "page", render = render,
      }
    end

    -- 𐑩 𐑤𐑦𐑕𐑑 𐑪𐑝 𐑑𐑨𐑜 𐑤𐑦𐑙𐑒𐑕. 𐑢𐑧𐑯 kind 𐑦𐑟 𐑜𐑦𐑝𐑩𐑯, 𐑒𐑬𐑯𐑑𐑕 𐑯 𐑤𐑦𐑙𐑒𐑕 𐑕𐑒𐑴𐑐 𐑑 𐑞𐑨𐑑 𐑒𐑲𐑯𐑛.
    local function tag_links(c, entries, kind)
      return c.ul{ class = "tags",
        c.each(entries, function(tag)
          local n = kind and #tag.kinds[kind] or #tag.pages
          return c.li{
            c.a{ href = tag_url(tag.slug, kind), tag.name }, " ",
            c.span{ class = "meta", "(" .. n .. ")" },
          }
        end),
      }
    end

    add("/tags/", "tags", function(c)
      if #list == 0 then return c.p{ "no tags yet" } end
      local kinds_seen = {}
      for _, tag in ipairs(list) do
        for k in pairs(tag.kinds) do kinds_seen[k] = true end
      end
      local out = { c.card{ title = "all kinds", tag_links(c, list) } }
      for _, kind in ipairs(ordered(kinds_seen)) do
        local in_kind = {}
        for _, tag in ipairs(list) do
          if tag.kinds[kind] then in_kind[#in_kind + 1] = tag end
        end
        out[#out + 1] = c.card{ title = kind_title(kind), tag_links(c, in_kind, kind) }
      end
      return out
    end)

    for _, tag in ipairs(list) do
      add(tag_url(tag.slug), "tag: " .. tag.name, function(c)
        local out = {}
        if tag.def.icon then out[#out + 1] = c.img{ src = tag.def.icon, alt = "", height = 32 } end
        if tag.def.description then out[#out + 1] = c.p{ tag.def.description } end
        for _, kind in ipairs(ordered(tag.kinds)) do
          out[#out + 1] = c.card{
            title = c.a{ href = tag_url(tag.slug, kind), kind_title(kind) },
            c.postlist{ pages = tag.kinds[kind] },
          }
        end
        return out
      end)

      for _, kind in ipairs(ordered(tag.kinds)) do
        add(tag_url(tag.slug, kind), kind_title(kind) .. ": " .. tag.name, function(c)
          local others = {}
          for _, other in ipairs(ordered(tag.kinds)) do
            if other ~= kind then
              others[#others + 1] = c.li{
                c.a{ href = tag_url(tag.slug, other), kind_title(other) }, " ",
                c.span{ class = "meta", "(" .. #tag.kinds[other] .. ")" },
              }
            end
          end
          return {
            c.postlist{ pages = tag.kinds[kind] },
            c.when(#others > 0, c.p{ class = "meta", "also tagged in:" }),
            c.when(#others > 0, c.ul{ others }),
            c.p{ c.a{ href = tag_url(tag.slug), "all kinds" }, " | ", c.a{ href = "/tags/", "all tags" } },
          }
        end)
      end
    end
  end)
end
