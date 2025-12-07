-- main.lua
-- Dimensões da janela
local window_width, window_height = love.graphics.getDimensions()

local utils = require "utils"

-- Player
local player = require "player"

-- Handler Balas
local balas = {}
local tamanho_bala = 10

-- Handler Inimigos
local inimigos = {}
local tamanho_inimigo = 100

local spawn_handler = {
    tempo_spawn = 0,
    intervalo_spawn = 2
}

local angle = 0

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
        local bala_existe = true
        bala.y = bala.y - dt * 500

        if bala.y < 0 then
            table.remove(balas, i)
            bala_existe = false
        end

        if bala_existe then
            for i2 = #inimigos, 1, -1 do
                local inimigo = inimigos[i2]
                local esta_colidindo = utils.checkCollisionEnemy(inimigo.x, inimigo.y, tamanho_inimigo, tamanho_inimigo,
                    bala.x, bala.y, tamanho_bala, tamanho_bala)

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
        table.insert(inimigos, {
            x = math.random(0, window_width),
            y = 0,
            angle = 0
        })
        spawn_handler.tempo_spawn = 0
    end

    for i = #inimigos, 1, -1 do
        local inimigo = inimigos[i]
        inimigo.y = inimigo.y + dt * 200
        inimigo.angle = inimigo.angle + dt * 100

        if inimigo.y > window_height then
            table.remove(inimigos, i)
        end
    end

    angle = angle + .5 * math.pi * dt
end

function love.draw()
    -- PLAYER
    player.draw()

    -- BALAS
    love.graphics.setColor(1, 1, 1)
    for i, bala in ipairs(balas) do
        love.graphics.rectangle("fill", bala.x, bala.y, tamanho_bala, tamanho_bala)
    end

    -- INIMIGOS
    love.graphics.setColor(1, 0, 0)
    for i, inimigo in ipairs(inimigos) do
        drawInimigo("fill", inimigo.x, inimigo.y, 100, 100, angle)
    end
end

function love.keypressed(key)
    if key == "space" then
        table.insert(balas, {
            x = player.x + (player.largura / 2) - (tamanho_bala / 2),
            y = player.y
        })
    end
end

function drawInimigo(mode, x, y, width, height, angle)
    love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.rotate(angle)
	love.graphics.rectangle(mode, -width/2, -height/2, width, height)
	love.graphics.pop()
end