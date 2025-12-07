local Utils = {}

function Utils.checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function Utils.checkCollisionEnemy(x1,y1,w1,h1, x2,y2,w2,h2)
  local x1 = x1 + ( -w1/2 )
  local y1 = y1 + ( -h1/2 )
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

return Utils