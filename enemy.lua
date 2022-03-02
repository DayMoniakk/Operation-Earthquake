local Enemy = {}
Enemy.__index = Enemy
local ActiveEnemies = {}

local EnemySprites = require("enemySprites")
local Player = require("player")
local Utils = require("utils")
local EnemyBullet = require("enemyBullet")

local Timer = require("libraries.hump.timer")

local world

function Enemy:load(_world)
    EnemySprites:load()
    self.activeEnemies = ActiveEnemies
    world = _world

    enemySounds = {}
    enemySounds.hurt = love.audio.newSource("audio/hit.wav", "static")
    enemySounds.hurt:setVolume(0.8)
    enemySounds.shoot = love.audio.newSource("audio/shoot.wav", "static")
end

function Enemy.new(x, y)
    local instance = setmetatable({}, Enemy)
    instance.x = x
    instance.y = y
    instance.spriteSet = EnemySprites:getSpriteSet()
    instance.img = instance.spriteSet.idle
    instance.width = instance.img:getWidth()
    instance.height = instance.img:getHeight()
    instance.scale = 1
    instance.rot = math.rad(math.random(0, 360))
    instance.speed = 50
    instance.stoppingDistance = 80
    instance.health = math.random(2, 3)
    instance.lastHealth = instance.health
    instance.tintDuration = 0.2
    instance.tintTimer = 0
    instance.collider = world:newBSGRectangleCollider(instance.x, instance.y, instance.width, instance.height, 14)
    instance.collider:setFixedRotation(true)
    instance.collider:setCollisionClass("enemy")
    instance.collider:setObject(instance)
    instance.bulletSpeed = 700
    instance.timeBtwShots = 0.5
    instance.shotTimer = 0
    instance.inSight = false
    instance.detectionDistance = 300
    instance.shootRange = 160
    instance.despawnDistance = 800
    instance.clipSize = 7
    instance.ammo = instance.clipSize
    instance.reloading = false
    instance.reloadTime = 3
    instance.randomAccuracy = 12

    table.insert(ActiveEnemies, instance)
end

function Enemy:remove()
    for i, instance in ipairs(ActiveEnemies) do
        if instance == self then
            instance.collider:destroy()
            table.remove(ActiveEnemies, i)
        end
    end
end

function Enemy.removeAll()
    for i, instance in ipairs(ActiveEnemies) do
        if instance.collider.body ~= nil then instance.collider:destroy() end
    end
    ActiveEnemies = {}
end

function Enemy:update(dt)
    self:move(dt)
    self:tint(dt)
end

function Enemy:move(dt)
    local dist = Utils:distance(self.x, self.y, Player.x, Player.y)

    if dist >= self.despawnDistance then
        if self.collider:getLinearVelocity() ~= 0 then
            self.collider:setLinearVelocity(0, 0)
            self.img = self.spriteSet.idle
        end
        return
    end

    if dist <= self.detectionDistance then
        self.inSight = true
        if not self.reloading then self.img = self.spriteSet.aim end
    else
        self.inSight = false
        if not self.reloading then self.img = self.spriteSet.idle end
    end

    if self.inSight and dist <= self.shootRange then
        self:shoot(dt)
        self.rot = math.atan2((Player.y - self.y), (Player.x - self.x))
    end

    if dist <= self.stoppingDistance or not self.inSight then
        if self.collider:getLinearVelocity() ~= 0 then
            self.collider:setLinearVelocity(0, 0)
        end
        return
    end

    if not self.inSight then return end

    local angle = math.atan2(Player.y - self.y, Player.x - self.x)
    local vx, vy = math.cos(angle) * self.speed, math.sin(angle) * self.speed

    self.rot = angle
    self.collider:setLinearVelocity(vx, vy)

end

function Enemy:checkCollision()
    if Utils:collision(self.x, self.y, self.width, self.height, Player.x, Player.y, Player.width, Player.height) then
        Player:damage()
    end
end

function Enemy:shoot(dt)
    self.shotTimer = self.shotTimer - dt

    if self.shotTimer <= 0 and self.ammo > 0 and not self.reloading then
        self.img = self.spriteSet.shoot
        self.shotTimer = self.timeBtwShots
        self.ammo = self.ammo - 1
        enemySounds.shoot:setPitch(math.random(0.9, 1))
        enemySounds.shoot:play()

        local shootOffset = math.rad(math.random(-self.randomAccuracy, self.randomAccuracy))
        local vx, vy = math.cos(self.rot + shootOffset) * self.bulletSpeed, math.sin(self.rot + shootOffset) * self.bulletSpeed

        EnemyBullet.new(self.x, self.y, vx, vy, self.rot, self.bulletDamage)

        if self.ammo <= 0 then
            self.img = self.spriteSet.reload
            self.reloading = true
            Timer.after(self.reloadTime, function() self.ammo = self.clipSize self.reloading = false self.img = self.spriteSet.aim end)
        end
    end
end

function Enemy:damage(damage)
    self.health = self.health - damage
    self.tintTimer = self.tintDuration
    enemySounds.hurt:play()
    if self.health <= 0 then
        --self:remove()
        self.collider:destroy()
        self.img = self.spriteSet.dead
        self.tintTimer = 0
    end
end

function Enemy:tint(dt)
    self.tintTimer = self.tintTimer - dt
end

function Enemy:draw()
    if self.lastHealth == self.health and self.tintTimer <= 0 then
        love.graphics.draw(self.img, self.x, self.y, self.rot, self.scale, self.scale, self.width / 2, self.height / 2)
    else
        self.lastHealth = self.health
        love.graphics.setColor(1, 0, 0, 0.7)
        love.graphics.draw(self.img, self.x, self.y, self.rot, self.scale, self.scale, self.width / 2, self.height / 2)
        love.graphics.setColor(1, 1, 1)
    end
end

function Enemy:updateAll(dt)
    if Player.health <= 0 then return end
    Timer.update(dt)

    for i, instance in ipairs(ActiveEnemies) do
        if instance.health > 0 then
            instance:update(dt)
            instance.x = instance.collider:getX()
            instance.y = instance.collider:getY()
        else
            instance.img = instance.spriteSet.dead
        end
    end
end

function Enemy:stopAll()
    for i, instance in ipairs(ActiveEnemies) do
        if instance.collider == nil then return end
        if instance.collider.body ~= nil then
            instance.collider:setLinearVelocity(0, 0)
        end
    end
end

function Enemy.drawAll()
    for i,instance in ipairs(ActiveEnemies) do
        instance:draw()
    end
end

return Enemy