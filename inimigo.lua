local Inimigo = {}

local ParticulaFactory = require "particula"

function Inimigo.new(x, y)
    local self = {
        x = x,
        y = y,
        width = 50,
        height = 50,
        angle = 0,
        velocidade = 200,
        velocidade_rotacao = 2,
        isDead = false,
        tipo = "inimigo",
        death_timer = 1,
        death_particles = {}
    }

    local function createParticles()
        if #self.death_particles == 0 then
            for i = 1, 10 do
                local particle = ParticulaFactory.new(self.x, self.y, self.width, self.velocidade)
                table.insert(self.death_particles, particle)
            end
        end
    end

    function self.update(dt)
        self.y = self.y + self.velocidade * dt
        self.angle = self.angle + self.velocidade_rotacao * dt

        if self.y > love.graphics.getHeight() then
            self.isDead = true
        end

        if self.isDead then
            self.death_timer = self.death_timer - dt
            createParticles()
            if #self.death_particles > 0 then
                for i, particle in ipairs(self.death_particles) do
                    particle.update(dt)
                end
            end
        end
    end

    function self.draw()
        if not self.isDead then
            love.graphics.push()
            love.graphics.translate(self.x, self.y)
            love.graphics.rotate(self.angle)
            love.graphics.setColor(1, 0, 0)
            love.graphics.rectangle("fill", -self.width / 2, -self.height / 2, self.width, self.height)
            love.graphics.pop()
        else
            for i, particle in ipairs(self.death_particles) do
                particle.draw()
            end
        end
    end

    return self
end

return Inimigo
