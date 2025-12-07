local Inimigo = {}

function Inimigo.new(x, y)
    local self = {
        x = x,
        y = y,
        width = 70,
        height = 70,
        angle = 0,
        velocidade = 200,
        velocidade_rotacao = 2,
        isDead = false,
        tipo = "inimigo"
    }

    function self.update(dt)
        self.y = self.y + self.velocidade * dt
        self.angle = self.angle + self.velocidade_rotacao * dt

        if self.y > love.graphics.getHeight() then
            self.isDead = true
        end
    end

    function self.draw()
        love.graphics.push()
        love.graphics.translate(self.x, self.y)
        love.graphics.rotate(self.angle)
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", -self.width / 2, -self.height / 2, self.width, self.height)
        love.graphics.pop()
    end

    return self
end

return Inimigo
