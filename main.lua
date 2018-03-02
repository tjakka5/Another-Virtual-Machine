local Gpu = require("gpu")
local Ram = require("ram")


--[[
Gpu.circFill(30, 30, 27, 0x7)
Gpu.circFill(60, 50, 13, 0x7)
Gpu.circFill(55, 70, 5, 0x7)
]]
for i = 0, 0x2F do
   for j = 0, 0x2F do
      Gpu.plot(i + j, i, i + j / 10)
   end
end

function love.update(dt)
   love.window.setTitle(love.timer.getFPS())
end

function love.draw()
   Gpu.render()
   Gpu.draw()
end
