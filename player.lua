local Player = {
    x = 100,
    y = 100,
    velocidade = 300,
    height = 40,
    width = 30,
    sprite = nil
}

function Player.load(player_x, player_y)
    Player.sprite = love.graphics.newCanvas(Player.width, Player.height)

    Player.x = player_x
    Player.y = player_y

    love.graphics.setCanvas(Player.sprite)
    local height = Player.height
    local width = Player.width
    local meio_horizontal = (width / 2)

    local vertices = {0,height, meio_horizontal,(height * 0.7), width,height, meio_horizontal,0}
    local triangles = love.math.triangulate(vertices)

    for i, triangle in ipairs(triangles) do
        love.graphics.polygon("fill", triangle)
    end
    love.graphics.setCanvas()
end

function Player.update(dt)
    -- if love.keyboard.isDown('s') then
    --     Player.y = Player.y + Player.velocidade * dt
    -- end

    -- if love.keyboard.isDown('w') then
    --     Player.y = Player.y - Player.velocidade * dt
    -- end

    if love.keyboard.isDown('d') then
        Player.x = Player.x + Player.velocidade * dt
    end

    if love.keyboard.isDown('a') then
        Player.x = Player.x - Player.velocidade * dt
    end
end

function Player.draw()
    -- Sintaxe: love.graphics.rectangle(mode, x, y, width, height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(Player.sprite, Player.x, Player.y)
end

return Player
