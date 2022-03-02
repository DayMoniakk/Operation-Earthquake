local SceneManager = {}
local Splash = require("splash")
local MenuScene = require("menuScene")
local GameScene = require("gameScene")
local Transition = require("transition")

local currentScene = -1

function SceneManager:load()
    self.debug = false
    Transition:load()
    Splash:load(self)
end

function SceneManager:update(dt)
    Transition:update(dt)

    if currentScene == -1 then Splash:update(dt) end
    if currentScene == 0 then MenuScene:update(dt) end
    if currentScene == 1 then GameScene:update(dt) end
end

function SceneManager:draw()
    if currentScene == -1 then Splash:draw() end
    if currentScene == 0 then MenuScene:draw() end
    if currentScene == 1 then GameScene:draw() end

    Transition:draw()
end

function SceneManager:startApp()
    MenuScene:load(self)
    currentScene = 0
end

function SceneManager:loadMenu()
    love.graphics.setBackgroundColor(0, 0, 0)
    currentScene = 0
    GameScene:clear()
    MenuScene:reloadMenu()
    love.mouse.setVisible(true)
end

function SceneManager:loadGame()
    MenuScene:stopAudio()
    currentScene = 1
    GameScene:load(self)
    love.mouse.setVisible(false)
end

function SceneManager:reloadGame()
    GameScene:reload()
    love.mouse.setVisible(false)
end

function SceneManager:quitGame()
    love.event.quit()
end

return SceneManager