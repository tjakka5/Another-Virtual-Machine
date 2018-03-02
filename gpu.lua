local W, H = 128, 128

local function defaultEffect(color, tx, ty, sx, sy)
   return math.floor(color + 0.5)
end

local Gpu = {
   address = 0x0000,
   size    = 0x0000,
   buffer  = love.image.newImageData(W, H),
   palette = setmetatable({ -- ID, Mapping, Transparancy, Color
      [0x0] = {0x0,  true, {  0,   0,   0}}, -- Black
      [0x1] = {0x1, false, { 29,  43,  83}}, -- Dark-Blue
      [0x2] = {0x2, false, {126,  37,  83}}, -- Dark-Purple
      [0x3] = {0x3, false, {  0, 135,  81}}, -- Dark-Green
      [0x4] = {0x4, false, {171,  82,  54}}, -- Brown
      [0x5] = {0x5, false, { 95,  87,  79}}, -- Dark-Gray
      [0x6] = {0x6, false, {194, 195, 199}}, -- Light-Gray
      [0x7] = {0x7, false, {255, 241, 232}}, -- White
      [0x8] = {0x8, false, {255,   0,  77}}, -- Red
      [0x9] = {0x9, false, {255, 163,   0}}, -- Orange
      [0xA] = {0xA, false, {255, 236,  39}}, -- Yellow
      [0xB] = {0xB, false, {  0, 228,  54}}, -- Green
      [0xC] = {0xC, false, { 41, 173, 255}}, -- Blue
      [0xD] = {0xD, false, {131, 118, 156}}, -- Indigo
      [0xE] = {0xE, false, {255, 119, 168}}, -- Pink
      [0xF] = {0xF, false, {255, 204, 170}}, -- Peach
   }, {
      __index = function(t, key)
         return t[key % 0x10]
      end,
   }),
   effect = defaultEffect,
}

Gpu.image = love.graphics.newImage(Gpu.buffer)
Gpu.image:setFilter("nearest", "nearest")

function Gpu.plot(x, y, color, tx, ty)
   color = Gpu.effect(color, tx or 1, ty or 1, x / W, y / H)
   color = Gpu.palette[color][3]
   Gpu.buffer:setPixel(x, y, color[1], color[2], color[3], 255)
end

function Gpu.line(x0, y0, x1, y1, color)
   x0 = math.floor(x0)
   x1 = math.floor(x1)
   y0 = math.floor(y0)
   y1 = math.floor(y1)

   local dx = math.abs(x1 - x0)
   local sx = x0 < x1 and 1 or -1
   local dy = math.abs(y1 - y0)
   local sy = y0 < y1 and 1 or -1
   local err = math.floor((dx > dy and dx or -dy) / 2)
   local e2 = 0

   while true do
      Gpu.plot(x0, y0, color)
      if x0 == x1 and y0 == y1 then break end
      e2 = err
      if e2 >= -dx then
         err = err - dy
         x0 = x0 + sx
      end
      if e2 < dy then
         err = err + dx
         y0 = y0 + sy
      end
   end
end

function Gpu.rect()
end

function Gpu.rectFill()
end

function Gpu.circ(xc, yc, r, color)
   local x, y  = 0, r
   local d, dE = 1 - r, 3
   local dSE   = 5 - 2 * r

   Gpu.plot(xc - r, yc, color)
   Gpu.plot(xc + r, yc, color)
   Gpu.plot(xc, yc - r, color)
   Gpu.plot(xc, yc + r, color)

   while (y > x) do
      if (d < 0) then
         d   = d + dE
         dE  = dE + 2
         dSE = dSE + 2
      else
         d   = d + dSE
         dE  = dE + 2
         dSE = dSE + 4
         y   = y - 1
      end
      x = x + 1

      Gpu.plot(xc-x, yc-y, color)
      Gpu.plot(xc-y, yc-x, color)
      Gpu.plot(xc+y, yc-x, color)
      Gpu.plot(xc+x, yc-y, color)
      Gpu.plot(xc-x, yc+y, color)
      Gpu.plot(xc-y, yc+x, color)
      Gpu.plot(xc+y, yc+x, color)
      Gpu.plot(xc+x, yc+y, color)
   end
end

function Gpu.circFill(xc, yc, r, color)
   local x, y  = 0, r
   local d, dE = 1 - r, 3
   local dSE   = 5 - 2 * r

   Gpu.line(xc - r, yc, xc + r, yc, color)
   Gpu.line(xc, yc - r, xc, yc + r, color)

   while (y > x) do
      if (d < 0) then
         d   = d + dE
         dE  = dE + 2
         dSE = dSE + 2
      else
         d   = d + dSE
         dE  = dE + 2
         dSE = dSE + 4
         y   = y - 1
      end
      x = x + 1

      Gpu.line(xc-x, yc-y, xc+x, yc-y, color)
      Gpu.line(xc-x, yc+y, xc+x, yc+y, color)
      Gpu.line(xc-y, yc-x, xc+y, yc-x, color)
      Gpu.line(xc-y, yc+x, xc+y, yc+x, color)
   end
end

function Gpu.clear()
end

function Gpu.setPaletteMapping()
end

function Gpu.setEffect(effect)
   Gpu.effect = effect or defaultEffect
end

function Gpu.render()

   Gpu.image:refresh()
end

function Gpu.draw()
   love.graphics.setColor(255, 255, 255)
   love.graphics.draw(Gpu.image, 0, 0, nil, love.graphics.getWidth() / W, love.graphics.getHeight() / H)
end

return Gpu
