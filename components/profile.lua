-- 𐑩 𐑒𐑩𐑥𐑐𐑴𐑯𐑩𐑯𐑑 𐑞𐑨𐑑 𐑿𐑟𐑩𐑟 𐑩𐑯𐑳𐑞𐑼 𐑒𐑩𐑥𐑐𐑴𐑯𐑩𐑯𐑑 (card)
return function(props, c)
  return c.card{ title = props.name,
    c.img{ src = props.avatar, alt = props.name, width = 64 },
    c.p{ props.bio },
  }
end
