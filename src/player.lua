local Player = {}
local Bullet = require("bullet")

local Timer = require("libraries.hump.timer")
local Vector = require("libraries.hump.vector")

function Player:load(world)
    self.x = 150 --2550
    self.y = 150 --1250
    self.rot = 0
    self.scale = 1
    self.speed = 100
    self.sprite = love.graphics.newImage("imgs/characters/player_aim.png")
    self.width = self.sprite:getWidth()
    self.height = self.sprite:getHeight()
    self.collider = world:newBSGRectangleCollider(self.x, self.y, 12, 12, 8)
    self.collider:setFixedRotation(true)
    self.collider:setCollisionClass('player')
    self.collider:setObject(self)
    self.bulletSpeed = 1000
    self.bulletDamage = 1
    self.timeBtwShots = 0.3
    self.shotTimer = 0
    self.health = 10
    self.lastHealth = self.health
    self.timeBtwHits = 0.5
    self.hitTimer = 0
    self.clipSize = 7
    self.ammo = self.clipSize
    self.reloading = false
    self.reloadTime = 2.5
    self.startBlock = true

    anims = {}
    anims.aim = love.graphics.newImage("imgs/characters/player_aim.png")
    anims.shoot = love.graphics.newImage("imgs/characters/player_shoot.png")
    anims.reload = love.graphics.newImage("imgs/characters/player_reload.png")
    anims.dead = love.graphics.newImage("imgs/characters/player_dead.png")
    anims.shootTime = 0.1
    anims.shootTimer = 0

    sounds = {}
    sounds.shoot = love.audio.newSource("audio/shoot.wav", "static")
    sounds.hurt = love.audio.newSource("audio/hurt.wav", "static")
    sounds.hurt:setVolume(0.7)
    sounds.lose = love.audio.newSource("audio/lose.wav", "static")
    sounds.reload = love.audio.newSource("audio/reload.wav", "static")
    sounds.reload:setVolume(0.7)
    sounds.reloaded = love.audio.newSource("audio/reloaded.wav", "static")
    sounds.reloaded:setVolume(0.7)

    Timer.after(0.5, function() self.startBlock = false end)
    self.paused = false
end

function Player:reloadPlayer()
    self.x = 150
    self.y = 150
    self.rot = 0
    self.sprite = love.graphics.newImage("imgs/characters/player_aim.png")
    self.collider = world:newBSGRectangleCollider(self.x, self.y, 12, 12, 8)
    self.collider:setFixedRotation(true)
    self.collider:setCollisionClass('player')
    self.collider:setObject(self)
    self.health = 10
    self.lastHealth = self.health
    self.shotTimer = 0
    self.hitTimer = 0
    self.ammo = self.clipSize
    self.reloading = false
    self.startBlock = true
    self.paused = false

    Timer.after(0.5, function() self.startBlock = false end)
end

function Player:unpause()
    self.startBlock = true
    Timer.after(0.5, function() self.startBlock = false end)
end

function Player:unload()
    self.collider:destroy()
end

function Player:update(dt, mouseX, mouseY)
    if self.health <= 0  then
        self.health = 0
        self.sprite = anims.dead
        if self.collider ~= nil and self.collider.body ~= nil then
            self.collider:setLinearVelocity(0, 0)
        end
        self.lastHealth = self.health
        return
    end
    Timer.update(dt)
    self:movement(dt)
    self:shoot(dt, mouseX, mouseY)
    self:cooldowns(dt)

    if love.keyboard.isDown("r") and self.ammo < self.clipSize and not self.reloading then
        self:reload()
    end
end

function Player:dead() -- prevent to switch animation if the player dies before completing the reload animation
    if self.health > 0 then return end
    self.sprite = anims.dead
end

function Player:draw()
    if self.lastHealth ~= self.health then
        love.graphics.setColor(1, 0.5, 0.5, 0.8)
    end

    love.graphics.draw(self.sprite, self.x, self.y, self.rot, self.scale, self.scale, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)
    love.graphics.setColor(1, 1, 1)
end

function Player:movement(dt)
    if self.collider.body == nil then return end

    local magnitude = 0
    local x, y = 0, 0

    local vx, vy = 0, 0

    if love.keyboard.isDown("w") then
        magnitude = magnitude + 1
        y = -1
        vy = self.speed * -1
    elseif love.keyboard.isDown("s") then
        magnitude = magnitude + 1
        y = 1
        vy = self.speed
    end

    if love.keyboard.isDown("a") then
        magnitude = magnitude + 1
        x = -1
        vx = self.speed * -1
    elseif love.keyboard.isDown("d") then
        magnitude = magnitude + 1
        x = 1
        vx = self.speed
    end

    local vec = Vector(vx, vy):normalized() * self.speed

    self.collider:setLinearVelocity(vec.x, vec.y)
end

function Player:shoot(dt, mouseX, mouseY)
    if self.startBlock then return end

    self.rot = math.atan2((mouseY - self.y), (mouseX - self.x))

    self.shotTimer = self.shotTimer - dt
    if love.mouse.isDown(1) and self.shotTimer <= 0 and self.ammo > 0 and not self.reloading then
        self.sprite = anims.shoot
        self.ammo = self.ammo - 1
        sounds.shoot:stop()
        sounds.shoot:setPitch(math.random(0.95, 1))
        sounds.shoot:play()

        self.shotTimer = self.timeBtwShots
        local angle = math.atan2(mouseY - self.y, mouseX - self.x)
        local vx, vy = math.cos(angle) * self.bulletSpeed, math.sin(angle) * self.bulletSpeed

        Bullet.new(self.x, self.y, vx, vy, angle, self.bulletDamage)

        if self.ammo <= 0 then
            self:reload()
        else
            Timer.after(anims.shootTime, function () self.sprite = anims.aim end)
        end
    end
end
 
function Player:reload()
    sounds.reload:play()
    self.reloading = true
    self.sprite = anims.reload
    Timer.after(self.reloadTime, function() self.sprite = anims.aim self.ammo = self.clipSize self.reloading = false sounds.reloaded:play() end)
end

function Player:cooldowns(dt)
    self.hitTimer = self.hitTimer - dt
end

function Player:damage()
    if self.hitTimer <= 0 then
        sounds.hurt:play()
        self.hitTimer = self.timeBtwHits
        self.health = self.health - 1
        if self.health > 0 then
            Timer.after(self.timeBtwHits / 2, function() self.lastHealth = self.health end)
        else
            sounds.lose:play()
        end
    end
end

return Player