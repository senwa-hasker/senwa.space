-- c.postlist{ pages = { ... } }  ->  𐑩 𐑤𐑦𐑕𐑑 𐑪𐑝 𐑤𐑦𐑙𐑒𐑕 𐑢𐑦𐑞 𐑛𐑱𐑑𐑕
return function(props, c)
  return c.ul{ class = "posts",
    c.each(props.pages, function(p)
      return c.li{ c.a{ href = p.url, p.title }, " ", c.span{ class = "meta", p.date or "" } }
    end),
  }
end
