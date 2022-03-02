local SceneManager = require("sceneManager")

function love.load()
    math.randomseed(os.time())

    love.graphics.setDefaultFilter("nearest", "nearest")

    SceneManager:load()
end

function love.update(dt)
    SceneManager:update(dt)
end

function love.draw()
    love.graphics.scale(1, 1)

    SceneManager:draw()
end