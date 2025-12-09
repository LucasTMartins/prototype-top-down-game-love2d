local Particula = {}

function Particula.new(x, y, entity_width, entity_speed)
    local self = {
        x = math.random(x - (entity_width / 2), x + (entity_width / 2)),
        y = y,
        width = math.random(2, 5),
        height = math.random(2, 5),
        speed = math.random(entity_speed * 0.7, entity_speed * 2)
    }

    function self.update(dt)
        self.y = self.y + self.speed * dt
    end

    function self.draw()
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    end

    return self
end

return Particula
