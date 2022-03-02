local Splash = {}

local Timer = require("libraries.hump.timer")

function Splash:load(sceneManager)
    self.sceneManager = sceneManager
    self.image = love.graphics.newImage("imgs/logo.png")
    self.splashTime = 3
    
    self.opacity = {1, 1, 1, 0}

    Timer.tween(1.5, self.opacity, {1, 1, 1, 1}, "linear", function() Timer.after(1, function() Timer.tween(0.5, self.opacity, {1, 1, 1, 0}, "linear") end) end)
    Timer.after(self.splashTime, function() self:onFinished() end)
end

function Splash:update(dt)
    Timer.update(dt)
end

function Splash:draw()
    love.graphics.setColor(1, 1, 1, self.opacity[4])
    love.graphics.draw(self.image, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, 0.7, 0.7, self.image:getWidth() / 2, self.image:getHeight() / 2)
end

function Splash:onFinished()
    love.graphics.setColor(1, 1, 1)
    self.sceneManager:startApp()
end

return Splash