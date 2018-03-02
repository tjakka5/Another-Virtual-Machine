local Byte = require("byte")

local Ram = {}

function Ram.set(address, value)
   if Byte.outBounds(address) then
      error("Address '"..bit.tohex(address).."' out of bounds")
   end

   Ram[address] = Byte.clamp(value)
end

function Ram.get(address)
   return Ram[address] or 0x0000
end

return Ram
