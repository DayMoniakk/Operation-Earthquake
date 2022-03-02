local Medkit = {}
Medkit.__index = Medkit
local ActiveMedkits = {}

local Utils = require("utils")
local Player = require("player")

function Medkit:load()
    healSound = love.audio.newSource("audio/heal.wav", "static")
end

function Medkit.new(x, y)
    local instance = setmetatable({}, Medkit)
    instance.x = x
    instance.y = y
    instance.rot = 0
    instance.img = love.graphics.newImage("imgs/medkit.png")
    instance.width = instance.img:getWidth()
    instance.height = instance.img:getHeight()
    instance.scale = 1
    instance.pickupDistance = 15
    instance.x = instance.x + instance.width / 2
    instance.y = instance.y + instance.height / 2
    table.insert(ActiveMedkits, instance)
end

function Medkit:remove()
    for i, instance in ipairs(ActiveMedkits) do
        if instance == self then
            table.remove(ActiveMedkits, i)
        end
    end
end

function Medkit.removeAll()
    ActiveMedkits = {}
end

function Medkit:update()
    local dist = Utils:distance(Player.x, Player.y, self.x, self.y)

    if dist <= self.pickupDistance then
        healSound:play()
        Player.health = 10
        Player.lastHealth = 10
        self:remove()
    end
end
function Medkit:draw()
    love.graphics.draw(self.img, self.x, self.y, self.rot, self.scale, self.scale, self.width / 2, self.height / 2)
end

function Medkit:updateAll(dt)
    for i, instance in ipairs(ActiveMedkits) do
        instance:update(dt)
    end
end

function Medkit.drawAll()
    for i,instance in ipairs(ActiveMedkits) do
        instance:draw()
    end
end

return Medkit