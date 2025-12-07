-- main.lua
-- Dimensões da janela
local window_width, window_height = love.graphics.getDimensions()

local utils = require "utils"

-- Player
local player = require "player"

-- Balas Factory
local BalaFactory = require "bala"
local balas = {}

-- Inimigos Factory
local InimigoFactory = require "inimigo"
local inimigos = {}

local spawn_handler = {
    tempo_spawn = 0,
    intervalo_spawn = 2
}

-- FUNÇÕES
function love.load()
    -- Configurações iniciais da janela, se necessário
    love.window.setTitle("Protótipo Shooter")

    -- PLAYER
    player.load()
end

function love.update(dt)
    -- Player
    player.update(dt)

    -- #balas é o tamanho da tabela
    -- 1 é o destino
    -- -1 é o passo (andar para trás)
    for i = #balas, 1, -1 do
        local bala = balas[i]
        bala.update(dt)

        if bala.isDead then
            table.remove(balas, i)
        else
            for i2 = #inimigos, 1, -1 do
                local inimigo = inimigos[i2]
                local esta_colidindo = utils.checkCollisionEnemy(inimigo.x, inimigo.y, inimigo.width, inimigo.height,
                    bala.x, bala.y, bala.width, bala.height)

                if esta_colidindo then
                    table.remove(balas, i)
                    table.remove(inimigos, i2)
                    break
                end
            end
        end
    end

    -- Inimigos
    spawn_handler.tempo_spawn = spawn_handler.tempo_spawn + dt

    if spawn_handler.tempo_spawn > spawn_handler.intervalo_spawn then
        table.insert(inimigos, InimigoFactory.new(math.random(0, window_width), 0))
        spawn_handler.tempo_spawn = 0
    end

    for i = #inimigos, 1, -1 do
        local e = inimigos[i]
        e.update(dt)

        if e.isDead then
            table.remove(inimigos, i)
        end
    end
end

function love.draw()
    -- PLAYER
    player.draw()

    -- BALAS
    love.graphics.setColor(1, 1, 1)
    for i, bala in ipairs(balas) do
        bala.draw()
    end

    -- INIMIGOS
    for i, e in ipairs(inimigos) do
        e.draw()
    end
end

function love.keypressed(key)
    if key == "space" then
        local bala_x = BalaFactory.get_bullet_x(player.x, player.width) 
        local bala_y = player.y
        table.insert(balas, BalaFactory.new(bala_x, bala_y))
    end
end
