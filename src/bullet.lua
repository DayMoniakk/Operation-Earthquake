local Bullet = {}
Bullet.__index = Bullet
local ActiveBullets = {}

local Utils = require("utils")

function Bullet:load(_world)
    world = _world
    wallHitSound = love.audio.newSource("audio/hit_wall.wav", "static")
    wallHitSound:setVolume(0.6)
end

function Bullet.new(x, y, dirX, dirY, rot, damage)
    local instance = setmetatable({}, Bullet)
    instance.x = x
    instance.y = y
    instance.dirX = dirX
    instance.dirY = dirY
    instance.rot = rot + math.rad(90)
    instance.img = love.graphics.newImage("imgs/bullet.png")
    instance.width = instance.img:getWidth()
    instance.height = instance.img:getHeight()
    instance.scale = 1.8
    instance.timer = 2.5
    instance.damage = damage
    instance.collider = world:newBSGRectangleCollider(instance.x, instance.y, instance.width, instance.height, 4)
    instance.collider:setFixedRotation(true)
    instance.collider:setCollisionClass("playerBullet")
    instance.collider:setObject(instance)
    table.insert(ActiveBullets, instance)
end

function Bullet:remove()
    for i, instance in ipairs(ActiveBullets) do
        if instance == self then
            instance.collider:destroy()
            table.remove(ActiveBullets, i)
        end
    end
end

function Bullet.removeAll()
    for i, instance in ipairs(ActiveBullets) do
        instance.collider:destroy()
    end
    ActiveBullets = {}
end

function Bullet:update(dt)
    self:move(dt)
    self:hitDetection(dt)
end

function Bullet:move(dt)
    local vx = self.dirX
    local vy = self.dirY

    self.collider:setLinearVelocity(vx, vy)

    self.timer = self.timer - dt
    if self.timer <= 0 then
        self:remove()
    end
end

function Bullet:hitDetection(dt)
    if self.collider:enter('enemy') then
        local collisionData = self.collider:getEnterCollisionData('enemy')
        local enemy = collisionData.collider:getObject()
        enemy:damage(self.damage)
        self:remove()
    end

    if self.collider:enter('solid') then
        wallHitSound:play()
        self:remove()
    end
end

function Bullet:draw()
    love.graphics.draw(self.img, self.x, self.y, self.rot, self.scale, self.scale, self.width / 2, self.height / 2)
end

function Bullet:updateAll(dt)
    for i, instance in ipairs(ActiveBullets) do
        instance:update(dt)
        if instance.collider.body == nil then return end
        instance.x = instance.collider:getX()
        instance.y = instance.collider:getY()
    end
end

function Bullet:stopAll()
    for i, instance in ipairs(ActiveBullets) do
        if instance.collider == nil then return end
        if instance.collider.body ~= nil then
            instance.collider:setLinearVelocity(0, 0)
        end
    end
end

function Bullet.drawAll()
    for i,instance in ipairs(ActiveBullets) do
        instance:draw()
    end
end

return Bullet