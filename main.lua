
function init()
   game = {
      w = love.graphics.getWidth(),
      h = love.graphics.getHeight(),
      
      counter = 0,
      
      paddle1 = {
         active = true,
         nr = 1,
         w = 20,
         h = 80,
         x = 0,
         y = 60,
         speed = {
            x = 400,
            y = 400,
         }, 
         color = {255, 0, 0, 255},
         upKey = 'w',
         downKey = 's',
         leftKey = 'a',
         rightKey = 'd',
      },
      
      paddle2 = {
         active = true,
         nr = 2,
         w = 20,
         h = 80,
         x = love.graphics.getWidth() - 40,
         y = 0,
         speed = {
            x = 400,
            y = 400,
         },
         color = {0, 0, 255, 255},
         upKey = 'up',
         downKey = 'down',
         leftKey = 'left',
         rightKey = 'right',
      },
      
      ball = {
         r = 20,
         x = love.graphics.getWidth() / 2,
         y = love.graphics.getHeight() / 2,
         speed = {
            x = -200,
            y = -100,
         },
         color = {0, 255, 0, 255},
      },
      
   }
end

function love.load()
   init()
end

function love.update(dt)
   
   updatePaddle(dt, game.paddle1)
   updatePaddle(dt, game.paddle2)
   
   updateBall(dt, game.ball)
   
end

function updatePaddle(dt, paddle)
   -- move paddle according to input
   
   if love.keyboard.isDown( paddle.upKey )
   then
      movePaddle(dt, paddle, 'up')
   end
   if
      love.keyboard.isDown( paddle.downKey )
   then
      movePaddle(dt, paddle, 'down')
   end
   if
      love.keyboard.isDown( paddle.leftKey )
   then
      movePaddle(dt, paddle, 'left')
   end
   if
      love.keyboard.isDown( paddle.rightKey )
   then
      movePaddle(dt, paddle, 'right')
   end
   
end

function movePaddle(dt, paddle, dir)
   local shiftX = 0
   local shiftY = 0
   
   if dir == 'up'
   then
      shiftY = -(paddle.speed.y * dt)
   elseif dir == 'down'
   then
      shiftY = paddle.speed.y * dt
   elseif dir == 'left'
   then
      shiftX = -(paddle.speed.x * dt)
   elseif dir == 'right'
   then
      shiftX = paddle.speed.x * dt
   end

   local newX = paddle.x + shiftX
   local newY = paddle.y + shiftY

   -- new pos y
   if newY < 0
   then 
      paddle.y = 0
   elseif newY > game.h - paddle.h
   then
      paddle.y = game.h - paddle.h
   else 
      paddle.y = newY
   end

   -- new pos x
   if (paddle.nr == 1 
       and newX >= 0 
       and newX <= game.w / 2 - paddle.w)
   then
      paddle.x = newX
   elseif (paddle.nr == 2 
           and newX >= game.w / 2
           and newX <= game.w - paddle.w)
   then
      paddle.x = newX
   end

end

function updateBall(dt, ball)

   checkWallCollision(ball)
   
   checkPaddleCollision(ball, game.paddle1)
   checkPaddleCollision(ball, game.paddle2)   

   moveBall(dt, ball)

   -- -- collision with paddle2
   -- if (ball.x + shiftX + ball.r >= game.paddle2.x 
   --     and ball.y >= game.paddle2.y
   --     and ball.y <= game.paddle2.y + game.paddle2.h)
   -- then
   --    ball.dir.x = -1
   --    game.counter = game.counter + 1
   -- else
   --    ball.x = ball.x + shiftX
   -- end
  
end

function checkWallCollision(ball)
   -- wall collision (left|right)
   if (ball.x >= love.graphics.getWidth() + ball.r or ball.x <= 0 - ball.r)
   then
      init()
   end
   
   -- wall collision (up|down)
   if (ball.y - ball.r <= 0 or ball.y + ball.r >= love.graphics.getHeight())
   then
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
         print("-- T|B")
         if diffY > 0 -- hit bottom
         then
            print("---- B")
            if ball.speed.y > 0
            then
               ball.speed.y = ball.speed.y
            else
               ball.speed.y = -ball.speed.y
            end
         else -- hit top
            print("---- T")
            if ball.speed.y > 0
            then
               ball.speed.y = -ball.speed.y
            else
               ball.speed.y = ball.speed.y
            end
         end
      end

      if (dx >= paddle.w / 2 -- hit right or left
         and dy <= paddle.h / 2 + ball.r) -- corner correction
      then
         hit = true
         print("-- R|L")
         if diffX > 0 -- hit right
         then
            print("---- R")
            if ball.speed.x > 0
            then
               ball.speed.x = ball.speed.x
            else
               ball.speed.x = -ball.speed.x
            end
         else -- hit left
            print("---- L")
            if ball.speed.x > 0
            then
               ball.speed.x = -ball.speed.x
            else
               ball.speed.x = ball.speed.x
            end
         end
      end

   end

   if hit
   then
      print("hit", dx, dy, diffX, diffY)
      changeTurn(paddle)
   end

end

function changeTurn(paddle)
   paddle.active = false
   game.counter = game.counter + 1
   
   if paddle.nr == 1
   then
      game.paddle2.active = true
   elseif
      paddle.nr == 2
   then
      game.paddle1.active = true
   end

end

function moveBall(dt, ball)
   local shiftX = ball.speed.x * dt
   local shiftY = ball.speed.y * dt

   ball.x = ball.x + shiftX
   ball.y = ball.y + shiftY
end

function love.draw()
   drawCopyright()
   drawCounter()
   drawPaddle(game.paddle1)
   drawPaddle(game.paddle2)
   drawBall(game.ball)   
end

function drawCopyright()
   love.graphics.setColor(255, 255, 255, 255)
   love.graphics.print("© 2012 Eraldo Helal", love.graphics.getWidth() / 2 - 70, 4)
end

function drawCounter()
   love.graphics.setColor(255, 255, 255, 255)
   love.graphics.print(tostring(game.counter), love.graphics.getWidth() / 2, 24)  
end

function drawPaddle(paddle)
   love.graphics.setColor(unpack(paddle.color))
   love.graphics.rectangle("fill", paddle.x, paddle.y, paddle.w, paddle.h)
end


function drawBall(ball)
   love.graphics.setColor(unpack(ball.color))
   love.graphics.circle("fill", ball.x, ball.y, ball.r)
end
