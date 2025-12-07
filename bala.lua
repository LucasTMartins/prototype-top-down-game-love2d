local Bala = {}

local default_width = 10

function Bala.new(x, y)
    local self = {
        x = x,
        y = y,
        width = default_width,
        height = 10,
        velocidade = 500,
        isDead = false,
        tipo = "projetil"
    }

    function self.update(dt)
        self.y = self.y - self.velocidade * dt

        if self.y < 0 then
            self.isDead = true
        end
    end

    function self.draw()
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    end

    function self.get_bullet_x(player_x, player_width)
        local bullet_x = player_x + (player_width / 2) - (self.width / 2)

        return bullet_x
    end

    return self
end

function Bala.get_bullet_x(player_x, player_width)
    local bullet_x = player_x + (player_width / 2) - (default_width / 2)
    return bullet_x
end

return Bala
