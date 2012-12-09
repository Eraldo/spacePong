
function init()
   game = {
      field = {
         w = love.graphics.getWidth() - 20,
         h = love.graphics.getHeight() - 40,
         x = 10,
         y = 20,
      },      
      
      counter = 0,
      
      player1 = {
         score = 0,
         paddle = {
            active = true,
            nr = 1,
            w = 20,
            h = 100,
            x = 0,
            y = 0,
            speed = {
               x = 0,
               y = 0,
            }, 
            color = {255, 0, 0, 255},
            upKey = 'w',
            downKey = 's',
            leftKey = 'a',
            rightKey = 'd',
         },         
         pockets = {
            top = {
               x = 0,
               y = 0,
               angle1 = 0,
               angle2 = math.pi / 2,
               r = 0,
            },
            middle = {
               x = 0,
               y = 0,
               angle1 = - math.pi / 2,
               angle2 = math.pi / 2,
               r = 0,
            },
            bottom = {
               x = 0,
               y = 0,
               angle1 = -math.pi / 2,
               angle2 = 0,
               r = 0,
            },
         },
      },

      player2 = {
         score = 0,
         paddle = {
            active = true,
            nr = 2,
            w = 20,
            h = 100,
            x = 0,
            y =  0,
            speed = {
               x = 0,
               y = 0,
            },
            color = {0, 0, 255, 255},
            upKey = 'up',
            downKey = 'down',
            leftKey = 'left',
            rightKey = 'right',
         },
         pockets = {
            top = {
               x = 0,
               y = 0,
               angle1 = math.pi / 2,
               angle2 = math.pi,
               r = 0,
            },
            middle = {
               x = 0,
               y = 0,
               angle1 = math.pi / 2,
               angle2 = math.pi + math.pi / 2,
               r = 0,
            },
            bottom = {
               x = 0,
               y = 0,
               angle1 = math.pi,
               angle2 = math.pi + math.pi / 2,
               r = 0,
            },
         },
      },
      
      ball = {
         r = 20,
         x = love.graphics.getWidth() / 2,
         y = love.graphics.getHeight() / 2,
         speed = {
            x = 0,
            y = 0,
         },
         color = {0, 255, 0, 255},
      },
      
   }

   game.player1.paddle.x = game.field.x + game.field.w / 4 - game.player1.paddle.w / 2
   game.player1.paddle.y = game.field.y + game.field.h / 2 - game.player1.paddle.h / 2
   game.player2.paddle.x = game.field.x + game.field.w - game.field.w / 4 - game.player2.paddle.w / 2
   game.player2.paddle.y = game.field.y + game.field.h / 2 - game.player2.paddle.h / 2

   -- init pockets player1
   game.player1.pockets.top.x = game.field.x
   game.player1.pockets.top.y = game.field.y
   game.player1.pockets.top.r = game.ball.r * 4
   game.player1.pockets.middle.x = game.field.x
   game.player1.pockets.middle.y = game.field.y + game.field.h / 2
   game.player1.pockets.middle.r = game.ball.r * 3
   game.player1.pockets.bottom.x = game.field.x
   game.player1.pockets.bottom.y = game.field.y + game.field.h
   game.player1.pockets.bottom.r = game.ball.r * 4

   -- init pockets player2
   game.player2.pockets.top.x = game.field.x + game.field.w
   game.player2.pockets.top.y = game.field.y
   game.player2.pockets.top.r = game.ball.r * 4
   game.player2.pockets.middle.x = game.field.x + game.field.w
   game.player2.pockets.middle.y = game.field.y + game.field.h / 2
   game.player2.pockets.middle.r = game.ball.r * 3
   game.player2.pockets.bottom.x = game.field.x + game.field.w
   game.player2.pockets.bottom.y = game.field.y + game.field.h
   game.player2.pockets.bottom.r = game.ball.r * 4

end

function love.load()
   -- init defaults
   init()

end

function restart()
   local score1 = game.player1.score
   local score2 = game.player2.score
   init()
   game.player1.score = score1
   game.player2.score = score2

end   

function love.update(dt)
   
   updatePaddle(dt, game.player1.paddle)
   updatePaddle(dt, game.player2.paddle)
   
   updateBall(dt, game.ball)
   
end

function updatePaddle(dt, paddle)
   -- move paddle according to input

   local accelerationY = 20
   local accelerationX = 10

   if love.keyboard.isDown( paddle.upKey )
   then
      paddle.speed.y = decelerate(paddle.speed.y)
   end
   if
      love.keyboard.isDown( paddle.downKey )
   then
      paddle.speed.y = accelerate(paddle.speed.y)
   end
   if
      love.keyboard.isDown( paddle.leftKey )
   then
      paddle.speed.x = decelerate(paddle.speed.x)
   end
   if
      love.keyboard.isDown( paddle.rightKey )
   then
      paddle.speed.x = accelerate(paddle.speed.x)
   end

   movePaddle(dt, paddle)
   
end

function accelerate(speed)
   local acceleration = 20

   if speed >= 0
   then
      return speed + acceleration
   else
      return acceleration
   end
end

function decelerate(speed)
   local deceleration = 20

   if speed <= 0
   then
      return speed - deceleration
   else
      return -deceleration
   end
end

function movePaddle(dt, paddle)
   local shiftX = paddle.speed.x * dt
   local shiftY = paddle.speed.y * dt

   local newX = paddle.x + shiftX
   local newY = paddle.y + shiftY

   -- new pos y
   if newY < game.field.y
   then 
      paddle.y = game.field.y
      paddle.speed.y = 0
   elseif newY > game.field.y + game.field.h - paddle.h
   then
      paddle.y = game.field.y + game.field.h - paddle.h
      paddle.speed.y = 0
   else 
      paddle.y = newY
   end

   -- new pos x
   if (paddle.nr == 1 
       and newX >= game.field.x 
       and newX <= game.field.x + (game.field.w / 2) - paddle.w)
   then
      paddle.x = newX
   elseif (paddle.nr == 2 
           and newX >= game.field.x + (game.field.w / 2)
           and newX <= game.field.x + game.field.w - paddle.w)
   then
      paddle.x = newX
   else
      paddle.speed.x = 0
   end

end

function updateBall(dt, ball)
   local speedCap = 1000

   checkWallCollision(ball)
   
   checkPaddleCollision(ball, game.player1.paddle)
   checkPaddleCollision(ball, game.player2.paddle)

   -- if ball in pocket range.. check for collision
   if ball.x <= game.field.x + ball.r * 4 or ball.x >= game.field.x + game.field.w - ball.r * 4 then
      if checkPocketCollision(ball, game.player1.pockets) then 
         game.player2.score = game.player2.score + 1
         restart()
      end
      if checkPocketCollision(ball, game.player2.pockets) then 
         game.player1.score = game.player1.score + 1
         restart()
      end
   end

   -- cap speed x
   if ball.speed.x > speedCap then
      ball.speed.x = speedCap
   end
   -- cap speed y
   if ball.speed.y > speedCap then
      ball.speed.y = speedCap
   end

   -- slow speed x
   if ball.speed.x > 1 or ball.speed.x < -1 then
      ball.speed.x = ball.speed.x - (ball.speed.x * 0.1 * dt)
   else
      ball.speed.x = 0
   end
   -- slow speed y
   if ball.speed.y > 1 or ball.speed.y < -1 then
      ball.speed.y = ball.speed.y - (ball.speed.y * 0.1 * dt)
   else
      ball.speed.y = 0
   end

   moveBall(dt, ball)
  
end

function checkPocketCollision(ball, pockets)
   for position, pocket in pairs(pockets) do
      if (circleCollision(ball.x, ball.y, -ball.r, pocket.x, pocket.y, pocket.r)) then 
         return true
      end
   end
   return false
end

function circleCollision(x1, y1, r1, x2, y2, r2)
   local dx = 0
   local dy = 0
   if x1 > x2 then dx = x1 - x2 else dx = x2 - x1 end
   if y1 > y2 then dy = y1 - y2 else dy = y2 - y1 end
   return (dx)^2 + (dy)^2 <= (r1 + r2)^2
end

function checkWallCollision(ball)
   -- wall collision (right|left)
   if (ball.x >= game.field.x + game.field.w - ball.r) -- right
   then
      ball.x = game.field.x + game.field.w - ball.r
      ball.speed.x = -ball.speed.x
   elseif (ball.x <= game.field.x + ball.r)
   then
      ball.x = game.field.x + ball.r
      ball.speed.x = -ball.speed.x
   end
   
   -- wall collision (top|bottom)
   if (ball.y - ball.r <= game.field.y) -- top
   then
      ball.y = game.field.y + ball.r
      ball.speed.y = -ball.speed.y
   elseif ball.y + ball.r >= game.field.y + game.field.h -- bottom
   then
      ball.y = game.field.y + game.field.h - ball.r
      ball.speed.y = -ball.speed.y
   end
end




function checkPaddleCollision(ball, paddle)
   local paddleCX = paddle.x + paddle.w / 2 -- paddle x center
   local paddleCY = paddle.y + paddle.h / 2 -- paddle y center
   local diffX = ball.x - paddleCX
   local diffY = ball.y - paddleCY
   local dx = math.abs(diffX) -- center distance delta x
   local dy = math.abs(diffY) -- center distance delta y
   local hit = false

   if (paddle.active
       and dx <= ball.r + paddle.w / 2 -- in x range?
       and dy <= ball.r + paddle.h / 2) -- in y range?
   then
      
      if (dy >= paddle.h / 2 -- hit top or bottom 
         and dx <= paddle.w / 2 + ball.r) -- corner correction
      then
         hit = true
         if diffY > 0 -- hit bottom
         then
            if ball.speed.y > 0
            then
               ball.speed.y = ball.speed.y + (paddle.speed.y / 2)
            else
               ball.speed.y = -ball.speed.y + (paddle.speed.y / 2)
            end
         else -- hit top
            if ball.speed.y > 0
            then
               ball.speed.y = -ball.speed.y + (paddle.speed.y / 2)
            else
               ball.speed.y = ball.speed.y + (paddle.speed.y / 2)
            end
         end
      end

      if (dx >= paddle.w / 2 -- hit right or left
         and dy <= paddle.h / 2 + ball.r) -- corner correction
      then
         hit = true
         if diffX > 0 -- hit right
         then
            if ball.speed.x > 0
            then
               ball.speed.x = ball.speed.x + (paddle.speed.x / 2)
            else
               ball.speed.x = -ball.speed.x + (paddle.speed.x / 2)
            end
         else -- hit left
            if ball.speed.x > 0
            then
               ball.speed.x = -ball.speed.x + (paddle.speed.x / 2)
            else
               ball.speed.x = ball.speed.x + (paddle.speed.x / 2)
            end
         end
      end
   else
      paddle.active = true
   end

   if hit
   then
      changeTurn(paddle)
   end

end

function changeTurn(paddle)
   paddle.active = false
   game.counter = game.counter + 1
   
   if paddle.nr == 1
   then
      game.player2.paddle.active = true
   elseif
      paddle.nr == 2
   then
      game.player1.paddle.active = true
   end

end

function moveBall(dt, ball)
   local shiftX = ball.speed.x * dt
   local shiftY = ball.speed.y * dt

   ball.x = ball.x + shiftX
   ball.y = ball.y + shiftY

end

function love.draw()
   drawField()
   drawTitle()
   drawCopyright()
   drawCounter()
   drawScore()
   drawPockets()
   drawPaddle(game.player1.paddle)
   drawPaddle(game.player2.paddle)
   drawBall(game.ball)   
end

function drawField()
   love.graphics.setColor(250, 250, 250, 250)
   love.graphics.rectangle( "fill", 0, love.graphics.getWidth(), love.graphics.getWidth(), love.graphics.getHeight() )
   love.graphics.setColor(100, 100, 100, 100)
   love.graphics.rectangle( "fill", game.field.x, game.field.y, game.field.w, game.field.h )
end

function drawTitle()
   love.graphics.setColor(255, 255, 255, 255)
   local text = "Spacy Pong 4.0"
   local x = 0
   local y = 4
   local limit = love.graphics.getWidth()
   love.graphics.printf(text, x, y, limit, "center")
end

function drawCopyright()
   love.graphics.setColor(255, 255, 255, 255)
   local text = "© 2012 Eraldo Helal"
   local x = 0
   local y = love.graphics.getHeight() - 15
   local limit = love.graphics.getWidth()
   love.graphics.printf(text, x, y, limit, "center")
end

function drawCounter()
   love.graphics.setColor(255, 255, 255, 255)
   love.graphics.print(tostring(game.counter), 0, love.graphics.getHeight() - 15)
end

function drawScore()
   love.graphics.setColor(255, 255, 255, 50)
   local text = game.player1.score .. " : " .. game.player2.score
   local x = 0
   local y = love.graphics.getHeight() / 2 - 40
   local limit = love.graphics.getWidth()
   love.graphics.setFont(love.graphics.newFont(64))
   love.graphics.printf(text, x, y, limit, "center")
   love.graphics.setFont(love.graphics.newFont(14))
end

function drawPocket(pocket)
   love.graphics.setColor(200, 200, 200, 200)

   local x = pocket.x
   local y = pocket.y
   local angle1 = pocket.angle1
   local angle2 = pocket.angle2
   local radius = pocket.r
   love.graphics.arc("line", x, y, radius, angle1, angle2) 

end

function drawPockets()
   love.graphics.setColor(200, 200, 200, 200)

   for position, pocket in pairs(game.player1.pockets) do
      drawPocket(pocket)
   end
   for position, pocket in pairs(game.player2.pockets) do
      drawPocket(pocket)
   end

end

function drawPaddle(paddle)
   love.graphics.setColor(unpack(paddle.color))
   love.graphics.rectangle("fill", paddle.x, paddle.y, paddle.w, paddle.h)
end


function drawBall(ball)
   love.graphics.setColor(unpack(ball.color))
   love.graphics.circle("fill", ball.x, ball.y, ball.r)
end
