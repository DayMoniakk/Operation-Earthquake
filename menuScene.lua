local MenuScene = {}

local Utils = require("utils")
local Timer = require("libraries.hump.timer")
local Transition = require("transition")

function MenuScene:load(sceneManager)
    SceneManager = sceneManager
    buttonsLocked = false

    fonts = {}
    fonts.smaller = love.graphics.newFont("fonts/Perfect DOS VGA 437.ttf", 15)
    fonts.small = love.graphics.newFont("fonts/Perfect DOS VGA 437.ttf", 25)
    fonts.medium = love.graphics.newFont("fonts/Perfect DOS VGA 437.ttf", 35)
    fonts.big = love.graphics.newFont("fonts/Perfect DOS VGA 437.ttf", 75)

    title = {}
    title.text = "Operation: Earthquake"
    title.w = fonts.big:getWidth(title.text)
    title.h = fonts.big:getHeight(title.text)
    title.x = 0
    title.y = 60

    warning = {}
    warning.firstText = "The game was made in 7 days"
    warning.firstW = fonts.smaller:getWidth(warning.firstText)
    warning.firstH = fonts.smaller:getWidth(warning.firstText)
    warning.firstX = 0
    warning.firstY = 0
    warning.secondText = "for the LOVE JAM 2022."
    warning.secondW = fonts.smaller:getWidth(warning.secondText)
    warning.secondH = fonts.smaller:getWidth(warning.secondText)
    warning.secondX = 0
    warning.secondY = 0
    warning.thirdText = "This is not meant to be a full game,"
    warning.thirdW = fonts.smaller:getWidth(warning.thirdText)
    warning.thirdH = fonts.smaller:getWidth(warning.thirdText)
    warning.thirdX = 0
    warning.thirdY = 0
    warning.fourthText = "just a small challenge."
    warning.fourthW = fonts.smaller:getWidth(warning.fourthText)
    warning.fourthH = fonts.smaller:getWidth(warning.fourthText)
    warning.fourthX = 0
    warning.fourthY = 0

    playBtn = {}
    playBtn.text = "Start Mission"
    playBtn.textW = fonts.medium:getWidth(playBtn.text)
    playBtn.textH = fonts.medium:getHeight(playBtn.text)
    playBtn.textX = 0
    playBtn.textY = 0
    playBtn.x = 0
    playBtn.y = 0
    playBtn.w = 300
    playBtn.h = 70
    playBtn.hovered = false
    playBtn.lastHovered = false
    playBtn.clicked = false

    quitBtn = {}
    quitBtn.text = "Leave"
    quitBtn.textW = fonts.medium:getWidth(quitBtn.text)
    quitBtn.textH = fonts.medium:getHeight(quitBtn.text)
    quitBtn.textX = 0
    quitBtn.textY = 0
    quitBtn.x = 0
    quitBtn.y = 0
    quitBtn.w = 300
    quitBtn.h = 70
    quitBtn.hovered = false
    quitBtn.lastHovered = false
    quitBtn.clicked = false

    menuSounds = {}
    menuSounds.hover = love.audio.newSource("audio/ui_hover.wav", "static")
    menuSounds.hover:setVolume(0.5)
    menuSounds.click = love.audio.newSource("audio/ui_click.wav", "static")
    menuSounds.background = love.audio.newSource("audio/menu_background.wav", "stream")
    menuSounds.background:setLooping(true)
    menuSounds.background:setVolume(0.35)
    menuSounds.background:play()

    info = {}
    info.w = 250
    info.h = 400
    info.x = 25
    info.y = 0
    info.text1 = "Welcome Agent !"
    info.w1 = fonts.smaller:getWidth(info.text1)
    info.h1 = fonts.smaller:getHeight(info.text1)
    info.x1 = 150
    info.y1 = 0
    info.text2 = "A gang of criminals stole"
    info.w2 = fonts.smaller:getWidth(info.text2)
    info.h2 = fonts.smaller:getHeight(info.text2)
    info.x2 = 150
    info.y2 = 0
    info.text3 = "a dangerous weapon:"
    info.w3 = fonts.smaller:getWidth(info.text3)
    info.h3 = fonts.smaller:getHeight(info.text3)
    info.x3 = 150
    info.y3 = 0
    info.text4 = "the EARTHQUAKE machine"
    info.w4 = fonts.smaller:getWidth(info.text4)
    info.h4 = fonts.smaller:getHeight(info.text4)
    info.x4 = 150
    info.y4 = 0
    info.text5 = "They are planning to use it"
    info.w5 = fonts.smaller:getWidth(info.text5)
    info.h5 = fonts.smaller:getHeight(info.text5)
    info.x5 = 150
    info.y5 = 0
    info.text6 = "very soon against all"
    info.w6 = fonts.smaller:getWidth(info.text6)
    info.h6 = fonts.smaller:getHeight(info.text6)
    info.x6 = 150
    info.y6 = 0
    info.text7 = "the nations !"
    info.w7 = fonts.smaller:getWidth(info.text7)
    info.h7 = fonts.smaller:getHeight(info.text7)
    info.x7 = 150
    info.y7 = 0
    info.text8 = "Your mission, if you accept it"
    info.w8 = fonts.smaller:getWidth(info.text8)
    info.h8 = fonts.smaller:getHeight(info.text8)
    info.x8 = 150
    info.y8 = 0
    info.text9 = "is to eliminate the gang and"
    info.w9 = fonts.smaller:getWidth(info.text9)
    info.h9 = fonts.smaller:getHeight(info.text9)
    info.x9 = 150
    info.y9 = 0
    info.text10 = "destroy the earthquake machine."
    info.w10 = fonts.smaller:getWidth(info.text10)
    info.h10 = fonts.smaller:getHeight(info.text10)
    info.x10 = 150
    info.y10 = 0
    info.text11 = "Good luck Agent."
    info.w11 = fonts.smaller:getWidth(info.text11)
    info.h11 = fonts.smaller:getHeight(info.text11)
    info.x11 = 150
    info.y11 = 0

    Transition:fadeIn()
end

function MenuScene:reloadMenu()
    buttonsLocked = true
    playBtn.hovered = false
    playBtn.lastHovered = false
    playBtn.clicked = false
    quitBtn.hovered = false
    quitBtn.lastHovered = false
    quitBtn.clicked = false
    Timer.after(0.5, function() buttonsLocked = false end)
    menuSounds.background:play()
    
    Transition:fadeIn()
end

function MenuScene:stopAudio()
    menuSounds.background:stop()
end

function MenuScene:update(dt)
    Timer.update(dt)

    if buttonsLocked then return end

    local mx, my = love.mouse.getPosition()

    if Utils:button(mx, my, playBtn.x, playBtn.y, playBtn.w, playBtn.h) then
        playBtn.hovered = true
        if not playBtn.lastHovered then
            playBtn.lastHovered = true
            menuSounds.hover:play()
        end

        if love.mouse.isDown(1) and not playBtn.clicked then
            playBtn.clicked = true
            menuSounds.click:play()
            Transition:fadeOut()
            Timer.after(1, function() SceneManager:loadGame() end)
        end
    else
        playBtn.hovered = false
        playBtn.lastHovered = false
    end

    if Utils:button(mx, my, quitBtn.x, quitBtn.y, quitBtn.w, quitBtn.h) then
        quitBtn.hovered = true
        if not quitBtn.lastHovered then
            quitBtn.lastHovered = true
            menuSounds.hover:play()
        end

        if love.mouse.isDown(1) and not quitBtn.clicked then
            menuSounds.click:play()
            quitBtn.clicked = true
            Transition:fadeOut()
            Timer.after(0.25, function() SceneManager:quitGame() end)
        end
    else
        quitBtn.hovered = false
        quitBtn.lastHovered = false
    end
end

function MenuScene:draw()
    love.graphics.setBackgroundColor(Utils:hexToRgb("#232b15"))

    -- GAME TITLE
    title.x = love.graphics.getWidth() / 2
    love.graphics.setColor(Utils:hexToRgb("#384720"))
    love.graphics.print(title.text, fonts.big, title.x + 2, title.y + 2, 0, 1, 1, title.w / 2, title.h /2)

    love.graphics.setColor(Utils:hexToRgb("#5d7337"))
    love.graphics.print(title.text, fonts.big, title.x, title.y, 0, 1, 1, title.w / 2, title.h /2)

    -- TEXT BOTTOM RIGHT
    warning.firstX = love.graphics.getWidth() - (warning.firstW / 2) - 20
    warning.firstY = love.graphics.getHeight() + 10
    love.graphics.print(warning.firstText, fonts.smaller, warning.firstX, warning.firstY, 0, 1, 1, warning.firstW / 1.45, warning.firstH / 2)
    warning.secondX = love.graphics.getWidth() - (warning.secondW / 2) - 20
    warning.secondY = love.graphics.getHeight() + 10
    love.graphics.print(warning.secondText, fonts.smaller, warning.secondX, warning.secondY, 0, 1, 1, warning.secondW / 1.2, warning.secondH / 2)
    warning.thirdX = love.graphics.getWidth() - (warning.thirdW / 2) - 20
    warning.thirdY = love.graphics.getHeight() + 90
    love.graphics.print(warning.thirdText, fonts.smaller, warning.thirdX, warning.thirdY, 0, 1, 1, warning.thirdW / 2, warning.thirdH / 2)
    warning.fourthX = love.graphics.getWidth() - (warning.fourthW / 2) - 20
    warning.fourthY = love.graphics.getHeight() + 55
    love.graphics.print(warning.fourthText, fonts.smaller, warning.fourthX, warning.fourthY, 0, 1, 1, warning.fourthW / 1.32, warning.fourthH / 2)

    -- INFO PANEL
    love.graphics.setColor(Utils:hexToRgb("#384720"))
    info.y = (love.graphics.getHeight()) - (info.h + 25)
    love.graphics.rectangle("line", info.x - 2, info.y + 2, info.w, info.h, 10)
    love.graphics.setColor(Utils:hexToRgb("#5d7337"))
    love.graphics.rectangle("line", info.x, info.y, info.w, info.h, 10)
    info.y1 = love.graphics.getHeight() - 350
    love.graphics.print(info.text1, fonts.smaller, info.x1, info.y1, 0, 1, 1, info.w1 / 2, info.w1 / 2)
    info.y2 = love.graphics.getHeight() - 250
    love.graphics.print(info.text2, fonts.smaller, info.x2, info.y2, 0, 1, 1, info.w2 / 2, info.w2 / 2)
    info.y3 = love.graphics.getHeight() - 250
    love.graphics.print(info.text3, fonts.smaller, info.x3, info.y3, 0, 1, 1, info.w3 / 2, info.w3 / 2)
    love.graphics.setColor(Utils:hexToRgb("#8a2716"))
    info.y4 = love.graphics.getHeight() - 215
    love.graphics.print(info.text4, fonts.smaller, info.x4, info.y4, 0, 1, 1, info.w4 / 2, info.w4 / 2)
    love.graphics.setColor(Utils:hexToRgb("#5d7337"))
    info.y5 = love.graphics.getHeight() - 160
    love.graphics.print(info.text5, fonts.smaller, info.x5, info.y5, 0, 1, 1, info.w5 / 2, info.w5 / 2)
    info.y6 = love.graphics.getHeight() - 160
    love.graphics.print(info.text6, fonts.smaller, info.x6, info.y6, 0, 1, 1, info.w6 / 2, info.w6 / 2)
    info.y7 = love.graphics.getHeight() - 168
    love.graphics.print(info.text7, fonts.smaller, info.x7, info.y7, 0, 1, 1, info.w7 / 2, info.w7 / 2)
    info.y8 = love.graphics.getHeight() - 60
    love.graphics.print(info.text8, fonts.smaller, info.x8, info.y8, 0, 1, 1, info.w8 / 2, info.w8 / 2)
    info.y9 = love.graphics.getHeight() - 47
    love.graphics.print(info.text9, fonts.smaller, info.x9, info.y9, 0, 1, 1, info.w9 / 2, info.w9 / 2)
    info.y10 = love.graphics.getHeight() - 14
    love.graphics.print(info.text10, fonts.smaller, info.x10, info.y10, 0, 1, 1, info.w10 / 2, info.w10 / 2)
    info.y11 = love.graphics.getHeight() - 14
    love.graphics.print(info.text11, fonts.smaller, info.x11, info.y11, 0, 1, 1, info.w11 / 2, info.w11 / 2)

    -- PLAY BUTTON
    if playBtn.hovered then
        love.graphics.setColor(Utils:hexToRgb("#3b4a1f"))
    else
        love.graphics.setColor(Utils:hexToRgb("#485c27"))
    end
    playBtn.x = (love.graphics.getWidth() / 2) - (playBtn.w / 2)
    playBtn.y = love.graphics.getHeight() - 200
    love.graphics.rectangle("fill", playBtn.x, playBtn.y, playBtn.w, playBtn.h, 10)
    love.graphics.setColor(1, 1, 1)
    playBtn.textX = love.graphics.getWidth() / 2 + (playBtn.textW / 2)
    playBtn.textY = love.graphics.getHeight() - (182 - playBtn.textH)
    love.graphics.print(playBtn.text, fonts.medium, playBtn.textX, playBtn.textY, 0, 1, 1, playBtn.textW, playBtn.textH)

    -- QUIT BUTTON
    if quitBtn.hovered then
        love.graphics.setColor(Utils:hexToRgb("#3b4a1f"))
    else
        love.graphics.setColor(Utils:hexToRgb("#485c27"))
    end
    quitBtn.x = (love.graphics.getWidth() / 2) - (quitBtn.w / 2)
    quitBtn.y = love.graphics.getHeight() - 120
    love.graphics.rectangle("fill", quitBtn.x, quitBtn.y, quitBtn.w, quitBtn.h, 10)
    love.graphics.setColor(1, 1, 1)
    quitBtn.textX = love.graphics.getWidth() / 2 + (quitBtn.textW / 2)
    quitBtn.textY = love.graphics.getHeight() - (102 - quitBtn.textH)
    love.graphics.print(quitBtn.text, fonts.medium, quitBtn.textX, quitBtn.textY, 0, 1, 1, quitBtn.textW, quitBtn.textH)
end

return MenuScene