local EnemySprites = {}

function EnemySprites:load()
    blue = {}
    blue.aim = love.graphics.newImage("imgs/characters/enemy_blue_aim.png")
    blue.dead = love.graphics.newImage("imgs/characters/enemy_blue_dead.png")
    blue.idle = love.graphics.newImage("imgs/characters/enemy_blue_idle.png")
    blue.reload = love.graphics.newImage("imgs/characters/enemy_blue_reload.png")
    blue.shoot = love.graphics.newImage("imgs/characters/enemy_blue_shoot.png")

    cyan = {}
    cyan.aim = love.graphics.newImage("imgs/characters/enemy_cyan_aim.png")
    cyan.dead = love.graphics.newImage("imgs/characters/enemy_cyan_dead.png")
    cyan.idle = love.graphics.newImage("imgs/characters/enemy_cyan_idle.png")
    cyan.reload = love.graphics.newImage("imgs/characters/enemy_cyan_reload.png")
    cyan.shoot = love.graphics.newImage("imgs/characters/enemy_cyan_shoot.png")

    green = {}
    green.aim = love.graphics.newImage("imgs/characters/enemy_green_aim.png")
    green.dead = love.graphics.newImage("imgs/characters/enemy_green_dead.png")
    green.idle = love.graphics.newImage("imgs/characters/enemy_green_idle.png")
    green.reload = love.graphics.newImage("imgs/characters/enemy_green_reload.png")
    green.shoot = love.graphics.newImage("imgs/characters/enemy_green_shoot.png")

    lime = {}
    lime.aim = love.graphics.newImage("imgs/characters/enemy_lime_aim.png")
    lime.dead = love.graphics.newImage("imgs/characters/enemy_lime_dead.png")
    lime.idle = love.graphics.newImage("imgs/characters/enemy_lime_idle.png")
    lime.reload = love.graphics.newImage("imgs/characters/enemy_lime_reload.png")
    lime.shoot = love.graphics.newImage("imgs/characters/enemy_lime_shoot.png")

    orange = {}
    orange.aim = love.graphics.newImage("imgs/characters/enemy_orange_aim.png")
    orange.dead = love.graphics.newImage("imgs/characters/enemy_orange_dead.png")
    orange.idle = love.graphics.newImage("imgs/characters/enemy_orange_idle.png")
    orange.reload = love.graphics.newImage("imgs/characters/enemy_orange_reload.png")
    orange.shoot = love.graphics.newImage("imgs/characters/enemy_orange_shoot.png")

    red = {}
    red.aim = love.graphics.newImage("imgs/characters/enemy_red_aim.png")
    red.dead = love.graphics.newImage("imgs/characters/enemy_red_dead.png")
    red.idle = love.graphics.newImage("imgs/characters/enemy_red_idle.png")
    red.reload = love.graphics.newImage("imgs/characters/enemy_red_reload.png")
    red.shoot = love.graphics.newImage("imgs/characters/enemy_red_shoot.png")

    white = {}
    white.aim = love.graphics.newImage("imgs/characters/enemy_white_aim.png")
    white.dead = love.graphics.newImage("imgs/characters/enemy_white_dead.png")
    white.idle = love.graphics.newImage("imgs/characters/enemy_white_idle.png")
    white.reload = love.graphics.newImage("imgs/characters/enemy_white_reload.png")
    white.shoot = love.graphics.newImage("imgs/characters/enemy_white_shoot.png")

    yellow = {}
    yellow.aim = love.graphics.newImage("imgs/characters/enemy_yellow_aim.png")
    yellow.dead = love.graphics.newImage("imgs/characters/enemy_yellow_dead.png")
    yellow.idle = love.graphics.newImage("imgs/characters/enemy_yellow_idle.png")
    yellow.reload = love.graphics.newImage("imgs/characters/enemy_yellow_reload.png")
    yellow.shoot = love.graphics.newImage("imgs/characters/enemy_yellow_shoot.png")
end

function EnemySprites:getSpriteSet()
    local temp = {
        [1] = blue,
        [2] = cyan,
        [3] = green,
        [4] = lime,
        [5] = orange,
        [6] = red,
        [7] = white,
        [8] = yellow
    }
    local rdm = math.random(1, 8)
    return temp[rdm]
end

return EnemySprites