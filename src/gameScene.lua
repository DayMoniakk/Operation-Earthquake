local GameScene = {}
local Utils = require("utils")
local Player = require("player")
local Bullet = require("bullet")
local EnemyBullet = require("enemyBullet")
local Enemy = require("enemy")
local Gui = require("gui")
local Medkit = require("medkit")
local Explosion = require("explosion")
local Transition = require("transition")

local Camera = require("libraries.hump.camera")
local Timer = require("libraries.hump.timer")
local Sti = require("libraries.sti")
local Windfield = require("libraries.windfield")

function GameScene:load(_sceneManager)
    sceneManager = _sceneManager
    unloaded = false
    paused = false
    pauseCooldown = false
    
    world = Windfield.newWorld(0, 0)
    world:addCollisionClass('solid')
    world:addCollisionClass('player')
    world:addCollisionClass('enemy')
    --world:addCollisionClass('player', {ignores = {'solid'}}) -- cheat/debug
    world:addCollisionClass('playerBullet', {ignores = {'player'}})
    world:addCollisionClass('enemyBullet', {ignores = {'enemy', 'playerBullet'}})
    world:addCollisionClass('water', {ignores = {'enemyBullet', 'playerBullet'}})
    world:setQueryDebugDrawing(true)
    self.debug = false

    allColliders = {}

    Player:load(world)
    Enemy:load(world)
    Bullet:load(world)
    EnemyBullet:load(world)
    Gui:load(_sceneManager, self)
    Medkit:load()
    Explosion:load()

    playerDeathRequired = false
    playerDeathRequiredLock = false

    camZoom = 2

    gameMap = Sti("maps/map1.lua")
    setupColliders()
    spawnEnemies()
    spawnMedkits()

    cam = Camera(Player.x, Player.y, camZoom)

    firstCheckPointReached = false
    gameEnded = false
    gameResult = false
    waitingForExplosion = false
    exploded = false
    inBombRange = false

    helicopter = {}
    helicopter.sprite = love.graphics.newImage("imgs/helicopter_body.png")
    helicopter.width = helicopter.sprite:getWidth()
    helicopter.height = helicopter.sprite:getHeight()
    helicopter.x = 2480
    helicopter.y = 1250
    helicopter.rot = math.rad(45)
    helicopter.scale = 1.5
    helicopter.active = false
    helicopter.sound = love.audio.newSource("audio/helicopter.wav", "static")
    helicopter.sound:setLooping(true)
    helicopter.sound:setVolume(0.5)
    helicopter.moveSpeed = 150

    helicopterHelix = {}
    helicopterHelix.sprite = love.graphics.newImage("imgs/helicopter_helix.png")
    helicopterHelix.width = helicopterHelix.sprite:getWidth()
    helicopterHelix.height = helicopterHelix.sprite:getHeight()
    helicopterHelix.x = 2455
    helicopterHelix.y = 1220
    helicopterHelix.rot = math.rad(45)
    helicopterHelix.speed = 1500
    helicopterHelix.scale = 1.5

    activateHelicopter(false)

    arrow = {}
    arrow.sprite = love.graphics.newImage("imgs/arrow.png")
    arrow.defaultY = 1325
    arrow.minY = 1325
    arrow.maxY = 1330
    arrow.x = 2880
    arrow.y = 1325
    arrow.w = arrow.sprite:getWidth()
    arrow.h = arrow.sprite:getHeight()
    arrow.scale = 1
    arrow.visible = true
    arrow.dir = 0

    winSound = love.audio.newSource("audio/victory.wav", "static")
    winSound:setVolume(0.55)

    Transition:fadeIn(3)
end

function GameScene:update(dt)
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    if w > 1280 and h > 720 and w >= 1600 and h >= 900 then
        cam:zoomTo(camZoom * 1.5)
    elseif w >= 2400 and y >= 1300 then
        cam:zoomTo(camZoom * 1.7)
    else
        cam:zoomTo(camZoom)
    end

    Timer.update(dt)

    if love.keyboard.isDown("escape") and Player.health > 0 and not pauseCooldown then
        pauseCooldown = true
        if not paused then 
            self:pause()
        else
            self:unpause()
        end
        Timer.after(1, function() pauseCooldown = false end)
    end

    if paused then Gui:updatePause() end

    if gameResult then Gui:updateScreen() end

    if Player.health <= 0 and not playerDeathRequiredLock then
        playerDeathRequiredLock = true
        Timer.after(1, function() playerDeathRequired = true love.mouse.setVisible(true) end)
    end

    if playerDeathRequired then
        Gui:updateScreen()
        Player:dead()
        return
    end

    if helicopter.active then updateHelicopter(dt) end

    if gameEnded then return end

    mouseX, mouseY = cam:mousePosition()

    world:update(dt)

    if Player.collider.body ~= nil then
        Player.x = Player.collider:getX()
        Player.y = Player.collider:getY()
    end

    if paused then
        if Player.collider ~= nil and Player.collider.body ~= nil then
            Player.collider:setLinearVelocity(0, 0)
            return
        end

        return
    end
    
    Player:update(dt, mouseX, mouseY)

    Bullet:updateAll(dt)
    EnemyBullet:updateAll(dt)
    Enemy:updateAll(dt)
    Medkit:updateAll()
    Explosion:update(dt)
    Gui:update(dt)

    if arrow.visible then updateArrow(dt) end

    cameraManagement()

    if not firstCheckPointReached then changeObjective() end
    checkForExplosion()
end

function GameScene:draw()
    love.graphics.setBackgroundColor(Utils:hexToRgb("#386900"))

    cam:attach()

    gameMap:drawLayer(gameMap.layers["Ground"])
    gameMap:drawLayer(gameMap.layers["Buildings"])
    gameMap:drawLayer(gameMap.layers["Props"])
    if not exploded then gameMap:drawLayer(gameMap.layers["EarthQuakeMachine"]) end
    
    Bullet:drawAll()
    EnemyBullet:drawAll()
    Enemy:drawAll()
    if not gameEnded then Player:draw() end
    Medkit:drawAll()
    Explosion:draw()

    if arrow.visible and not playerDeathRequired then love.graphics.draw(arrow.sprite, arrow.x, arrow.y, 0, arrow.scale, arrow.scale, arrow.w / 2, arrow.h / 2) end

    if sceneManager.debug then world:draw() end
    if helicopter.active then drawHelicopter() end

    cam:detach()

    if paused then Gui:drawPauseMenu() end
    if not paused and Player.health > 0 then Gui:drawCrosshair() end
    
    if playerDeathRequired then
        Gui:drawDeathScreen() 
        return
    end
    
    if not gameEnded then Gui:draw() end
    if inBombRange then Gui:drawExplodeBomb() end
    if gameResult then Gui:drawWinScreen() end
    
    love.graphics.setColor(1, 1, 1)
end

function changeObjective()
    if Utils:collision(Player.x, Player.y, Player.width, Player.height, 2930, 1120, 70, 50) then
        firstCheckPointReached = true
        Gui:updateObjective("Place the bomb to explode the earthquake machine !")
    end
end

function activateHelicopter(value)
    helicopter.active = value
    if value then
        helicopter.sound:play()
    else
        helicopter.sound:stop()
    end
end

function updateHelicopter(dt)
    helicopterHelix.rot = helicopterHelix.rot + math.rad(helicopterHelix.speed * dt)

    if gameEnded then 
        helicopter.x = helicopter.x - (helicopter.moveSpeed * dt)
        helicopter.y = helicopter.y - (helicopter.moveSpeed * dt)
        helicopterHelix.x = helicopterHelix.x - (helicopter.moveSpeed * dt)
        helicopterHelix.y = helicopterHelix.y - (helicopter.moveSpeed * dt)
        helicopter.sound:setPitch(1.1)
        return
    end

    if Utils:collision(Player.x, Player.y, Player.width, Player.height, 2400, 1180, 100, 100) then
        gameEnded = true
        Bullet:removeAll() 
        EnemyBullet:removeAll()
        Timer.after(3, function() gameResult = true activateHelicopter(false) love.mouse.setVisible(true) winSound:play() end)
    end
end

function drawHelicopter()
    love.graphics.draw(helicopter.sprite, helicopter.x, helicopter.y, helicopter.rot, helicopter.scale, helicopter.scale, helicopter.width / 2, helicopter.height / 2)
    love.graphics.draw(helicopterHelix.sprite, helicopterHelix.x, helicopterHelix.y, helicopterHelix.rot, helicopterHelix.scale, helicopterHelix.scale, helicopterHelix.width / 2, helicopterHelix.height / 2)
end

function checkForExplosion()
    if waitingForExplosion then return end

    if Utils:collision(Player.x, Player.y, Player.width, Player.height, 2845, 1315, 70, 50) then
        inBombRange = true
        if love.keyboard.isDown("f") then
            explodeBomb()
            arrow.visible = false
        end
    else
        inBombRange = false
    end
end

function explodeBomb()
    inBombRange = false
    Explosion:new(2880, 1335, 2, 0.02)
    waitingForExplosion = true
    Timer.after(5, function() exploded = true Explosion:explodeBomb() Gui:updateObjective("Escape with the helicopter !") activateHelicopter(true) end)
end

function setupColliders()
    rectangleCols = {}
    if gameMap.layers["Rectangles"] then
        for i, obj in pairs(gameMap.layers["Rectangles"].objects) do
            local col = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            col:setType("static")
            col:setCollisionClass('solid')
            table.insert(rectangleCols, col)
            table.insert(allColliders, col)
        end
    end

    if gameMap.layers["Water"] then
        for i, obj in pairs(gameMap.layers["Water"].objects) do
            local col = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            col:setType("static")
            col:setCollisionClass('water')
            table.insert(rectangleCols, col)
            table.insert(allColliders, col)
        end
    end

    circleCols = {}
    if gameMap.layers["Circles"] then
        for i, obj in pairs(gameMap.layers["Circles"].objects) do
            local col = world:newCircleCollider((obj.x + obj.width / 2), (obj.y + obj.height / 2), obj.width / 2)
            col:setType("static")
            col:setCollisionClass('solid')
            table.insert(circleCols, col)
            table.insert(allColliders, col)
        end
    end
end

function spawnEnemies()
    if gameMap.layers["Enemies"] then
        for i, obj in pairs(gameMap.layers["Enemies"].objects) do
            Enemy.new(obj.x, obj.y)
        end
    end
end

function spawnMedkits()
    if gameMap.layers["Medkits"] then
        for i, obj in pairs(gameMap.layers["Medkits"].objects) do
            Medkit.new(obj.x, obj.y)
        end
    end
end

function cameraManagement()
    cam:lookAt(Player.x, Player.y)
end

function playerBoundings()
    -- left border
    if Player.x < 20 then
        Player.collider:setX(20)
    end
    -- top border
    if Player.y < 20 then
        Player.collider:setY(20)
    end

    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    -- right border
    if Player.x > (mapW - 20) then
        Player.collider:setX(mapW - 20)
    end
    -- bottom border
    if Player.y > (mapH -20) then
        Player.collider:setY(mapH - 20)
    end
end

function updateArrow(dt)
    if arrow.y >= arrow.maxY then
        arrow.dir = 0
    elseif arrow.y <= arrow.minY then
        arrow.dir = 1
    end

    if arrow.dir == 0 then
        arrow.y = arrow.y - (10 * dt)
    else
        arrow.y = arrow.y + (10 * dt)
    end
end

function GameScene:reload()
    self:clear()
    unloaded = false

    Gui:reload()
    Gui:updateObjective("Find and destroy the earthquake machine !")
    Player:reloadPlayer()
    self.debug = false
    setupColliders()
    spawnEnemies()
    spawnMedkits()

    arrow.y = arrow.defaultY
    arrow.dir = 0
    arrow.visible = true

    firstCheckPointReached = false
    gameEnded = false
    gameResult = false
    waitingForExplosion = false
    exploded = false
    inBombRange = false

    helicopter.x = 2480
    helicopter.y = 1250
    helicopter.rot = math.rad(45)

    helicopterHelix.x = 2455
    helicopterHelix.y = 1220
    helicopterHelix.rot = math.rad(45)

    Transition:fadeIn(3)
end

function GameScene:clear()
    Timer.clear()
    paused = false

    for i, col in pairs(allColliders) do
        if col.body ~= nil then col:destroy() end
    end

    allColliders = {}

    Player:unload()
    playerDeathRequired = false
    playerDeathRequiredLock = false
    Enemy:removeAll()
    Medkit:removeAll()
    Bullet:removeAll()
    EnemyBullet:removeAll()

    self.debug = false
end

function GameScene:pause()
    Gui.pauseCooldown = true
    Player.paused = true
    Enemy:stopAll()
    EnemyBullet:stopAll()
    Bullet:stopAll()
    paused = true
    love.mouse.setVisible(true)
    Timer.after(0.7, function() Gui.pauseCooldown = false end)
end

function GameScene:unpause()
    paused = false
    love.mouse.setVisible(false)
    Gui:resetBtn()
    Player:unpause()
    Player.paused = false
end

return GameScene