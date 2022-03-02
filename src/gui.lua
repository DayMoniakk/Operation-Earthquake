local Gui = {}

local Player = require("player")
local Utils = require("utils")
local Transition = require("transition")

local Timer = require("libraries.hump.timer")

function Gui:load(sceneManager, gameScene)
    crosshairRadius = 6
    self.pauseCooldown = false

    SceneManager = sceneManager
    GameScene = gameScene

    font = love.graphics.newFont("fonts/Perfect DOS VGA 437.ttf", 25)
    fontSmall = love.graphics.newFont("fonts/Perfect DOS VGA 437.ttf", 15)
    fontMedium = love.graphics.newFont("fonts/Perfect DOS VGA 437.ttf", 35)
    fontBig = love.graphics.newFont("fonts/Perfect DOS VGA 437.ttf", 75)

    objective = {}
    objective.text = "Find and destroy the earthquake machine !"
    objective.w = font:getWidth(objective.text)
    objective.h = font:getHeight(objective.text)
    objective.y = 20

    healthBar = {}
    healthBar.x = 20
    healthBar.y = 20
    healthBar.w = 210
    healthBar.h = 50

    healthIcon = {}
    healthIcon.sprite = love.graphics.newImage("imgs/gui/health.png")
    healthIcon.scale = 4
    healthIcon.x = 35
    healthIcon.y = 45
    healthIcon.spacing = 20

    ammoBar = {}
    ammoBar.w = 150
    ammoBar.h = 50
    ammoBar.y = 20

    ammoIcon = {}
    ammoIcon.sprite = love.graphics.newImage("imgs/gui/ammo.png")
    ammoIcon.scale = 4
    ammoIcon.y = 45
    ammoIcon.spacing = 20

    bombPopup = {}
    bombPopup.text = "Press [F] to plant the bomb"
    bombPopup.w = fontSmall:getWidth(bombPopup.text)
    bombPopup.h = fontSmall:getHeight(bombPopup.text)

    winScreen = {}
    winScreen.mainText = "Mission completed."
    winScreen.mainW = fontBig:getWidth(winScreen.mainText)
    winScreen.mainH = fontBig:getHeight(winScreen.mainText)
    winScreen.altText = "You saved the world !"
    winScreen.altW = fontMedium:getWidth(winScreen.altText)
    winScreen.altH = fontMedium:getHeight(winScreen.altText)

    deathScreen = {}
    deathScreen.mainText = "Mission failed."
    deathScreen.mainW = fontBig:getWidth(deathScreen.mainText)
    deathScreen.mainH = fontBig:getHeight(deathScreen.mainText)
    deathScreen.altText = "The world is going to be destroyed by the earthquake machine !"
    deathScreen.altW = fontMedium:getWidth(deathScreen.altText)
    deathScreen.altH = fontMedium:getHeight(deathScreen.altText)

    retryBtn = {}
    retryBtn.text = "Restart"
    retryBtn.textW = fontMedium:getWidth(retryBtn.text)
    retryBtn.textH = fontMedium:getHeight(retryBtn.text)
    retryBtn.w = 300
    retryBtn.h = 60
    retryBtn.hovered = false
    retryBtn.lastHovered = false
    retryBtn.clicked = false
    retryBtn.x = 0
    retryBtn.y = 0

    menuBtn = {}
    menuBtn.text = "Main Menu"
    menuBtn.textW = fontMedium:getWidth(menuBtn.text)
    menuBtn.textH = fontMedium:getHeight(menuBtn.text)
    menuBtn.w = 300
    menuBtn.h = 60
    menuBtn.hovered = false
    menuBtn.lastHovered = false
    menuBtn.clicked = false
    menuBtn.x = 0
    menuBtn.y = 0

    guiSounds = {}
    guiSounds.hover = love.audio.newSource("audio/ui_hover.wav", "static")
    guiSounds.hover:setVolume(0.5)
    guiSounds.click = love.audio.newSource("audio/ui_click.wav", "static")

    pause = {}
    pause.x = 0
    pause.y = 0
    pause.w = 300
    pause.h = 400
    pause.btnW = 250
    pause.btnH = 60
    pause.btn1x = 0
    pause.btn1y = 0
    pause.text = "Paused"
    pause.textX = 0
    pause.textY = 0
    pause.textW = fontBig:getWidth(pause.text)
    pause.textH = fontBig:getHeight(pause.text)
    pause.btn1Hovered = false
    pause.btn1LastHovered = false
    pause.btn1Clicked = false
    pause.btn1Text = "Resume"
    pause.btn1TextW = fontMedium:getWidth(pause.btn1Text)
    pause.btn1TextH = fontMedium:getHeight(pause.btn1Text)
    pause.btn1TextX = 0
    pause.btn1TextY = 0
    pause.btn2x = 0
    pause.btn2y = 0
    pause.btn2Hovered = false
    pause.btn2LastHovered = false
    pause.btn2Clicked = false
    pause.btn2Text = "Main Menu"
    pause.btn2TextW = fontMedium:getWidth(pause.btn2Text)
    pause.btn2TextH = fontMedium:getHeight(pause.btn2Text)
    pause.btn2TextX = 0
    pause.btn2TextY = 0
end

function Gui:reload()
    retryBtn.hovered = false
    retryBtn.lastHovered = false
    retryBtn.clicked = false
    menuBtn.hovered = false
    menuBtn.lastHovered = false
    menuBtn.clicked = false
end

function Gui:update(dt)
    Timer.update(dt)
end

function Gui:draw()
    drawHealth()
    drawAmmo()
    drawObjective()
end

function Gui:drawCrosshair()
    local mx, my = love.mouse.getPosition()
    love.graphics.setColor(1, 1, 1, 0.7)
    love.graphics.circle("line", mx, my, crosshairRadius)
end

function drawHealth()
    --background
    love.graphics.setColor(0, 0, 0, 0.3)
    love.graphics.rectangle("fill", healthBar.x, healthBar.y, healthBar.w, healthBar.h)
    love.graphics.setColor(1, 1, 1)

    if Player.health <= 0 then return end

    --icons
    for i = Player.health - 1, 0, -1 do 
        love.graphics.draw(healthIcon.sprite, healthIcon.x + (i * healthIcon.spacing), healthIcon.y, 0, healthIcon.scale, healthIcon.scale, healthIcon.sprite:getWidth() / 2, healthIcon.sprite:getHeight() / 2)
    end
end

function drawAmmo()
    --background
    love.graphics.setColor(0, 0, 0, 0.3)
    love.graphics.rectangle("fill", (love.graphics.getWidth() - 20) - (ammoBar.w), ammoBar.y, ammoBar.w, ammoBar.h)
    love.graphics.setColor(1, 1, 1)

    --icons
    for i = Player.ammo - 1, 0, -1 do 
        love.graphics.draw(ammoIcon.sprite, love.graphics.getWidth() - 155 + (i * ammoIcon.spacing), ammoIcon.y, 0, ammoIcon.scale, ammoIcon.scale, ammoIcon.sprite:getWidth() / 2, ammoIcon.sprite:getHeight() / 2)
    end
end

function drawObjective()
    love.graphics.print(objective.text, font, (love.graphics.getWidth() / 2) - (objective.w / 2), objective.y, 0, 1, 1, objective.width, objective.height)
end

function Gui:updateObjective(text)
    objective.text = text
    objective.w = font:getWidth(objective.text)
    objective.h = font:getHeight(objective.text)
end

function Gui:drawExplodeBomb()
    love.graphics.print(bombPopup.text, fontSmall, (love.graphics.getWidth() / 2) + (bombPopup.w / 2), (love.graphics.getHeight() / 2) + (bombPopup.h + 25), 0, 1, 1, bombPopup.w, bombPopup.h)
end

function Gui:drawWinScreen()
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(Utils:hexToRgb("#11AB09"))
    
    love.graphics.print(winScreen.mainText, fontBig, (love.graphics.getWidth() / 2) + (winScreen.mainW / 2), 100, 0, 1, 1, winScreen.mainW, winScreen.mainH)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(winScreen.altText, fontMedium, (love.graphics.getWidth() / 2) + (winScreen.altW / 2), 150, 0, 1, 1, winScreen.altW, winScreen.altH)
    
    if retryBtn.hovered then
        love.graphics.setColor(Utils:hexToRgb("#BDBDBD"))
    end

    retryBtn.x = (love.graphics.getWidth() / 2) - (retryBtn.w / 2)
    retryBtn.y = (love.graphics.getHeight() - 150) - (retryBtn.h / 2)
    love.graphics.rectangle("fill", retryBtn.x, retryBtn.y, retryBtn.w, retryBtn.h, 10)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(retryBtn.text, fontMedium, (love.graphics.getWidth() / 2), love.graphics.getHeight() - 150, 0, 1, 1, retryBtn.textW / 2, retryBtn.textH / 2)
    love.graphics.setColor(1, 1, 1)

    if menuBtn.hovered then
        love.graphics.setColor(Utils:hexToRgb("#BDBDBD"))
    end

    menuBtn.x = (love.graphics.getWidth() / 2) - (menuBtn.w / 2)
    menuBtn.y = (love.graphics.getHeight() - 80) - (menuBtn.h / 2)
    love.graphics.rectangle("fill", menuBtn.x, menuBtn.y, menuBtn.w, menuBtn.h, 10)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(menuBtn.text, fontMedium, (love.graphics.getWidth() / 2), love.graphics.getHeight() - 80, 0, 1, 1, menuBtn.textW / 2, menuBtn.textH / 2)
end

function Gui:updateScreen()
    local mouseX, mouseY = love.mouse.getPosition()

    if Utils:button(mouseX, mouseY, retryBtn.x, retryBtn.y, retryBtn.w, retryBtn.h) then
        retryBtn.hovered = true
        if not retryBtn.lastHovered then
            retryBtn.lastHovered = true
            guiSounds.hover:play()
        end

        if love.mouse.isDown(1) and not retryBtn.clicked then
            retryBtn.clicked = true
            guiSounds.click:play()
            Transition:fadeOut()
            Timer.after(1, function() SceneManager:reloadGame() end)
        end
    else
        retryBtn.hovered = false
        retryBtn.lastHovered = false
    end

    if Utils:button(mouseX, mouseY, menuBtn.x, menuBtn.y, menuBtn.w, menuBtn.h) then
        menuBtn.hovered = true
        if not menuBtn.lastHovered then
            menuBtn.lastHovered = true
            guiSounds.hover:play()
        end


        if love.mouse.isDown(1) and not menuBtn.clicked then
            menuBtn.clicked = true
            guiSounds.click:play()
            --TODO:
            Transition:fadeOut()
            Timer.after(1, function() SceneManager:loadMenu() end)
        end
    else
        menuBtn.hovered = false
        menuBtn.lastHovered = false
    end
end

function Gui:drawDeathScreen()
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(Utils:hexToRgb("#ab0909"))
    
    love.graphics.print(deathScreen.mainText, fontBig, (love.graphics.getWidth() / 2) + (deathScreen.mainW / 2), 100, 0, 1, 1, deathScreen.mainW, deathScreen.mainH)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(deathScreen.altText, fontMedium, (love.graphics.getWidth() / 2) + (deathScreen.altW / 2), 150, 0, 1, 1, deathScreen.altW, deathScreen.altH)
    
    if retryBtn.hovered then
        love.graphics.setColor(Utils:hexToRgb("#BDBDBD"))
    end

    retryBtn.x = (love.graphics.getWidth() / 2) - (retryBtn.w / 2)
    retryBtn.y = (love.graphics.getHeight() - 150) - (retryBtn.h / 2)
    love.graphics.rectangle("fill", retryBtn.x, retryBtn.y, retryBtn.w, retryBtn.h, 10)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(retryBtn.text, fontMedium, (love.graphics.getWidth() / 2), love.graphics.getHeight() - 150, 0, 1, 1, retryBtn.textW / 2, retryBtn.textH / 2)
    love.graphics.setColor(1, 1, 1)

    if menuBtn.hovered then
        love.graphics.setColor(Utils:hexToRgb("#BDBDBD"))
    end

    menuBtn.x = (love.graphics.getWidth() / 2) - (menuBtn.w / 2)
    menuBtn.y = (love.graphics.getHeight() - 80) - (menuBtn.h / 2)
    love.graphics.rectangle("fill", menuBtn.x, menuBtn.y, menuBtn.w, menuBtn.h, 10)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(menuBtn.text, fontMedium, (love.graphics.getWidth() / 2), love.graphics.getHeight() - 80, 0, 1, 1, menuBtn.textW / 2, menuBtn.textH / 2)
    love.graphics.setColor(1, 1, 1)
end

function Gui:drawPauseMenu()
    love.graphics.setColor(0, 0, 0, 0.4)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(0, 0, 0, 0.6)
    pause.x = love.graphics.getWidth() / 2 - (pause.w / 2)
    pause.y = love.graphics.getHeight() / 2 -( pause.h / 2)
    love.graphics.rectangle("fill", pause.x, pause.y, pause.w, pause.h)
    love.graphics.setColor(1, 1, 1)

    if pause.btn1Hovered then
        love.graphics.setColor(Utils:hexToRgb("#BDBDBD"))
    end
    pause.btn1x = love.graphics.getWidth() / 2 - (pause.btnW / 2)
    pause.btn1y = love.graphics.getHeight() / 2 + 20
    love.graphics.rectangle("fill", pause.btn1x, pause.btn1y, pause.btnW, pause.btnH, 10)
    pause.btn2x = love.graphics.getWidth() / 2 - (pause.btnW / 2)
    pause.btn2y = love.graphics.getHeight() / 2 + 100

    if pause.btn2Hovered then
        love.graphics.setColor(Utils:hexToRgb("#BDBDBD"))
    else
        love.graphics.setColor(1, 1, 1)
    end

    love.graphics.rectangle("fill", pause.btn2x, pause.btn2y, pause.btnW, pause.btnH, 10)
    pause.textX = love.graphics.getWidth() / 2
    pause.textY = love.graphics.getHeight() / 2 - 150

    love.graphics.setColor(1, 1, 1)
    love.graphics.print(pause.text, fontBig, pause.textX, pause.textY, 0, 1, 1, pause.textW / 2, pause.textH / 2)
    love.graphics.setColor(0, 0, 0)

    pause.btn1TextX = love.graphics.getWidth() / 2
    pause.btn1TextY = love.graphics.getHeight() / 2 + 50
    love.graphics.print(pause.btn1Text, fontMedium, pause.btn1TextX, pause.btn1TextY, 0, 1, 1, pause.btn1TextW / 2, pause.btn1TextH / 2)
    pause.btn2TextX = love.graphics.getWidth() / 2
    pause.btn2TextY = love.graphics.getHeight() / 2 + 130
    love.graphics.print(pause.btn2Text, fontMedium, pause.btn2TextX, pause.btn2TextY, 0, 1, 1, pause.btn2TextW / 2, pause.btn2TextH / 2)
    love.graphics.setColor(1, 1, 1)
end

function Gui:updatePause()
    if self.pauseCooldown then return end
    
    local mx, my = love.mouse.getPosition()

    if Utils:button(mx, my, pause.btn1x, pause.btn1y, pause.btnW, pause.btnH) then
        pause.btn1Hovered = true
        if not pause.btn1LastHovered then
            pause.btn1LastHovered = true
            guiSounds.hover:play()
        end

        if love.mouse.isDown(1) and not pause.btn1Clicked then
            pause.btn1Clicked = true
            guiSounds.click:play()
            GameScene:unpause()
        end
    else
        pause.btn1Hovered = false
        pause.btn1LastHovered = false
    end

    if Utils:button(mx, my, pause.btn2x, pause.btn2y, pause.btnW, pause.btnH) then
        pause.btn2Hovered = true
        if not pause.btn2LastHovered then
            pause.btn2LastHovered = true
            guiSounds.hover:play()
        end

        if love.mouse.isDown(1) and not pause.btn2Clicked then
            pause.btn2Clicked = true
            guiSounds.click:play()
            Transition:fadeOut()
            Timer.after(1, function() SceneManager:loadMenu() end)
        end
    else
        pause.btn2Hovered = false
        pause.btn2LastHovered = false
    end
end

function Gui:resetBtn()
    pause.btn1Hovered = false
    pause.btn1LastHovered = false
    pause.btn1Clicked = false
    pause.btn2Hovered = false
    pause.btn2LastHovered = false
    pause.btn2Clicked = false
end

return Gui