return {
  black = 0xff0d0818,
  white = 0xffe8dff5,
  red = 0xfffc5d7c,
  green = 0xff9ed072,
  blue = 0xff76c8e0,
  yellow = 0xfff5e642,
  orange = 0xffef7b3e,
  magenta = 0xffb57bee,
  grey = 0xff7a6b99,
  transparent = 0x00000000,

  purple = 0xffb57bee,
  gold = 0xfff0b429,
  flash = 0xfff5e642,

  bar = {
    bg = 0xf01a0e28,
    border = 0xff1a0e28,
  },
  popup = {
    bg = 0xc01a0e28,
    border = 0xff7a6b99,
  },
  bg1 = 0xff241535,
  bg2 = 0xff372050,

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
