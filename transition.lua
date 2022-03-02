local Transition = {}

local Timer = require("libraries.hump.timer")

function Transition:load()
    self.opacity = {1, 1, 1, 0}
end

function Transition:update(dt)
    Timer.update(dt)
end

function Transition:draw()
    love.graphics.setColor(0, 0, 0, self.opacity[4])
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1)
end

function Transition:fadeIn(duration)
    self.opacity = {0, 0, 0, 1}
    Timer.tween(duration or 1, self.opacity, {0, 0, 0, 0}, "quad")
end

function Transition:fadeOut(duration)
    self.opacity = {0, 0, 0, 0}
    Timer.tween(duration or 1, self.opacity, {0, 0, 0, 1}, "quad")
end

return Transition