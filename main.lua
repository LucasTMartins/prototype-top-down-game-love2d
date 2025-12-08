-- main.lua
-- Dimensões da janela
local window_width, window_height = love.graphics.getDimensions()
local estado_atual = "menu"

local utils = require "utils"
local score = 0
local shake_handler = {
    duration = 0,
    magnetude = 2
}

-- Player
local player = require "player"
local player_default_pos = {
    x = window_width / 2,
    y = window_height - 100
}

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
    player.load(player_default_pos.x, player_default_pos.y)
end

function love.update(dt)
    if estado_atual == "menu" then
        updateMenu(dt)
    elseif estado_atual == "game" then
        updateGame(dt)
    elseif estado_atual == "gameover" then
        updateGameOver(dt)
    end
end

function love.draw()
    if estado_atual == "menu" then
        drawMenu()
    elseif estado_atual == "game" then
        drawGame()
    elseif estado_atual == "gameover" then
        drawGameOver()
    end
end

function love.keypressed(key)
    if estado_atual == "menu" then
        keypressedMenu(key)
    elseif estado_atual == "game" then
        keypressedGame(key)
    elseif estado_atual == "gameover" then
        keypressedGameOver(key)
    end
end

-- ESTADO MENU
function updateMenu(dt)
end

function drawMenu()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Prototipo de TopDownShooter", window_width / 2 - 180, window_height / 2 - 100, 0, 2)
    love.graphics.print("Pressione Enter para Continuar", window_width / 2 - 140, window_height / 2 - 40, 0, 1.5)
end

function keypressedMenu(key)
    if key == "return" then
        estado_atual = "game"
    end
end

-- ESTADO GAME
function updateGame(dt)
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
                    score = score + 100
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
        local inimigo = inimigos[i]
        inimigo.update(dt)

        if inimigo.isDead then
            table.remove(inimigos, i)
        else
            local esta_colidindo = utils.checkCollisionEnemy(inimigo.x, inimigo.y, inimigo.width, inimigo.height,
                player.x, player.y, player.width, player.height)

            if esta_colidindo then
                estado_atual = "gameover"
                shake_handler.duration = 2
            end
        end
    end
end

function drawGame()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. score, 10, 10)

    -- PLAYER
    player.draw()

    -- BALAS
    for i, bala in ipairs(balas) do
        bala.draw()
    end

    -- INIMIGOS
    for i, e in ipairs(inimigos) do
        e.draw()
    end
end

function keypressedGame(key)
    if key == "space" then
        local bala_x = BalaFactory.get_bullet_x(player.x, player.width)
        local bala_y = player.y
        table.insert(balas, BalaFactory.new(bala_x, bala_y))
    end

    if key == "r" then
        if love.keyboard.isDown("lctrl") then
            resetGame()
        end
    end
end

-- ESTADO GAMEOVER
function updateGameOver(dt)
    if shake_handler.duration > 0 then
        shake_handler.duration = shake_handler.duration - dt
    end
end

function drawGameOver()
    if shake_handler.duration > 0 then
        love.graphics.translate(math.random(-shake_handler.magnetude, shake_handler.magnetude), math.random(-shake_handler.magnetude, shake_handler.magnetude))
    end
    love.graphics.setColor(1, 0, 0)
    love.graphics.print("GAME OVER", window_width / 2 - 80, window_height / 2 - 100, 0, 2)
    love.graphics.print("Pressione Enter para Continuar", window_width / 2 - 140, window_height / 2 - 40, 0, 1.5)
end

function keypressedGameOver(key)
    if key == "return" then
        resetGame()
        estado_atual = "game"
    end
end

function resetGame()
    balas = {}
    inimigos = {}
    spawn_handler.tempo_spawn = 0
    player.x = player_default_pos.x
    player.y = player_default_pos.y
    score = 0
end
