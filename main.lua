
function init()
   game = {
      
      counter = 0,
      
      paddle1 = {
         w = 20,
         h = 80,
         x = 20,
         y = 0,
         speed = 400,
         color = {255, 0, 0, 255},
         upKey = 'w',
         downKey = 's',
      },
      
      paddle2 = {
         w = 20,
         h = 80,
         x = love.graphics.getWidth() - 40,
         y = 0,
         speed = 400,
         color = {0, 0, 255, 255},
         upKey = 'up',
         downKey = 'down',
      },
      
      ball = {
         r = 20,
         x = 100,
         y = 100,
         speed = 200,
         color = {0, 255, 0, 255},
         dir = {
            x = 1,
            y = 1,
         },
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
   elseif
      love.keyboard.isDown( paddle.downKey )
   then
      movePaddle(dt, paddle, 'down')
   end
   
end

function movePaddle(dt, paddle, dir)
   local shift = 0
   
   if dir == 'up'
   then
      shift = -(paddle.speed * dt)
   elseif dir == 'down'
   then
      shift = paddle.speed * dt
   end
   
   paddle.y = (paddle.y + shift) % (love.graphics.getHeight() - paddle.h)
end

function updateBall(dt, ball)
   
   local shiftX = 0
   local shiftY = 0
   
   shiftX = ball.dir.x * (ball.speed * dt)
   shiftY = ball.dir.y * (ball.speed * dt)

   -- wall collision (left|right)
   if (ball.x >= love.graphics.getWidth() or ball.x <= 0)
   then
      init()
   end
   
   -- wall collision (up|down)
   if (ball.y + shiftY - ball.r <= 0 or ball.y + shiftY + ball.r >= love.graphics.getHeight())
   then
      ball.dir.y = -ball.dir.y
   else
      ball.y = ball.y + shiftY
   end
   
   -- collision with paddle1
   if (ball.x + shiftX - ball.r <= game.paddle1.x + game.paddle1.w
       and ball.y >= game.paddle1.y
       and ball.y <= game.paddle1.y + game.paddle1.h)
   then
      ball.dir.x = 1
      game.counter = game.counter + 1
   else
      ball.x = ball.x + shiftX
   end
   
   -- collision with paddle2
   if (ball.x + shiftX + ball.r >= game.paddle2.x 
       and ball.y >= game.paddle2.y
       and ball.y <= game.paddle2.y + game.paddle2.h)
   then
      ball.dir.x = -1
      game.counter = game.counter + 1
   else
      ball.x = ball.x + shiftX
   end
  
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
   love.graphics.print("© 2012 Eraldo Helal", love.graphics.getWidth() / 2, 4)
end

function drawCounter()
   love.graphics.setColor(255, 255, 255, 255)
   love.graphics.print(tostring(game.counter), love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)  
end

function drawPaddle(paddle)
   love.graphics.setColor(unpack(paddle.color))
   love.graphics.rectangle("fill", paddle.x, paddle.y, paddle.w, paddle.h)
end


function drawBall(ball)
   love.graphics.setColor(unpack(ball.color))
   love.graphics.circle("fill", ball.x, ball.y, ball.r)
end
