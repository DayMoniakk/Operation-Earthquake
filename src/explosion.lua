local Explosion = {}

function Explosion:load()
    self.frames = {
        [1] = love.graphics.newImage("imgs/explosion_0.png"),
        [2] = love.graphics.newImage("imgs/explosion_1.png"),
        [3] = love.graphics.newImage("imgs/explosion_2.png"),
        [4] = love.graphics.newImage("imgs/explosion_3.png"),
        [5] = love.graphics.newImage("imgs/explosion_4.png"),
        [6] = love.graphics.newImage("imgs/explosion_5.png"),
        [7] = love.graphics.newImage("imgs/explosion_6.png"),
        [8] = love.graphics.newImage("imgs/explosion_7.png")
    }

    self.bombSprite = love.graphics.newImage("imgs/bomb.png")

    self.currentFrame = self.frames[1]
    self.x = 0
    self.y = 0
    self.scale = 1
    self.rate = 0.1
    self.timer = self.rate
    self.finished = true
    self.index = 1
    self.sound = love.audio.newSource("audio/explosion.wav", "static")
    self.explode = false
end

function Explosion:new(x, y, scale, rate)
    self.currentFrame = self.frames[1]
    self.x = x
    self.y = y
    self.scale = scale
    self.rate = rate
    self.timer = self.rate
    self.finished = false
    self.index = 1
    self.explode = false

end

function Explosion:update(dt)
    if self.finished then return end

    if not self.explode then return end

    self.timer = self.timer - dt

    if self.timer <= 0 then
        self.timer = self.rate
        self.index = self.index + 1

        if self.index > #self.frames then
            self.finished = true
        else
            self.currentFrame = self.frames[self.index]
        end
    end
end

function Explosion:explodeBomb()
    if self.finished then return end
    self.sound:play()
    self.explode = true
end

function Explosion:draw()
    if self.finished then return end

    if self.explode then 
        love.graphics.draw(self.currentFrame, self.x, self.y, 0, self.scale, self.scale, self.frames[1]:getWidth() / 2, self.frames[1]:getHeight() / 2)
    else
        love.graphics.draw(self.bombSprite, self.x, self.y, 0, 1, 1, self.bombSprite:getWidth() / 2, self.bombSprite:getHeight() / 2)
    end

end

return Explosion