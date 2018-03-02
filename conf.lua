function love.conf(t)
   t.version  = "0.10.1"
   t.console  = true
   t.identity = "Virtual Machine 2"

   t.window.vsync  = false
   t.window.title  = "Virtual Machine 2"
   t.window.width  = 512
   t.window.height = 512

   t.modules.video    = false
   t.modules.touch    = false
   t.modules.thread   = false
   t.modules.physics  = false
   t.modules.joystick = false
end
