local Byte = {}

function Byte.isOverflow(value)
   return value > 0xFFFF
end

function Byte.isUnderflow(value)
   return value < 0
end

function Byte.outBounds(value)
   return Byte.isOverflow(value) or Byte.isUnderflow(value)
end

function Byte.clamp(value)
   return math.max(0, math.min(value, 0xFFFF))
end

function Byte.loop(value)
   return value % 0xFFFF
end

return Byte
