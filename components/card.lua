-- 𐑩 𐑒𐑩𐑥𐑐𐑴𐑯𐑩𐑯𐑑: 𐑓𐑳𐑙𐑒𐑖𐑩𐑯(props, c). 𐑞 𐑦𐑯𐑛𐑧𐑒𐑕𐑛 𐑦𐑑𐑩𐑥𐑟 𐑦𐑯 props 𐑚𐑰𐑒𐑩𐑥 𐑦𐑑𐑕 𐑗𐑦𐑤𐑛𐑮𐑩𐑯.
return function(props, c)
  return c.section{ class = "card",
    c.when(props.title, c.h2{ props.title }),
    props,
  }
end
