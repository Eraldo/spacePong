
function init()
   game = {
      w = love.graphics.getWidth(),
      h = love.graphics.getHeight(),
      
      counter = 0,
      
      paddle1 = {
         nr = 1,
         w = 20,
         h = 80,
         x = 20,
         y = 60,
         speed = 400,
         color = {255, 0, 0, 255},
         upKey = 'w',
         downKey = 's',
         leftKey = 'a',
         rightKey = 'd',
      },
      
      paddle2 = {
         nr = 2,
         w = 20,
         h = 80,
         x = love.graphics.getWidth() - 40,
         y = 0,
         speed = 400,
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
            x = 100,
            y = 100,
         },
         color = {0, 255, 0, 255},
         dir = {
            x = -1,
            y = -1,
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
      shiftY = -(paddle.speed * dt)
   elseif dir == 'down'
   then
      shiftY = paddle.speed * dt
   elseif dir == 'left'
   then
      shiftX = -(paddle.speed * dt)
   elseif dir == 'right'
   then
      shiftX = paddle.speed * dt
   end

   -- new pos y
   paddle.y = (paddle.y + shiftY) % (game.h - paddle.h)

   -- new pos x
   if (paddle.nr == 1 
       and paddle.x + shiftX >= 0 
       and paddle.x + shiftX <= game.w / 2 - paddle.w)
   then
      paddle.x = paddle.x + shiftX
   elseif (paddle.nr == 2 
           and paddle.x + shiftX >= game.w / 2
           and paddle.x + shiftX <= game.w - paddle.w)
   then
      paddle.x = paddle.x + shiftX
   end

end

function updateBall(dt, ball)
   
   local shiftX = 0
   local shiftY = 0
   
   shiftX = ball.dir.x * (ball.speed.x * dt)
   shiftY = ball.dir.y * (ball.speed.y * dt)

   checkWallCollision(ball, shiftX, shiftY)
   
   checkPaddleCollision(ball, shiftX, shiftY, game.paddle1)
   
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

function checkWallCollision(ball, shiftX, shiftY)
   -- wall collision (left|right)
   if (ball.x >= love.graphics.getWidth() or ball.x <= 0)
   then
      -- init()
   end
   
   -- wall collision (up|down)
   if (ball.y + shiftY - ball.r <= 0 or ball.y + shiftY + ball.r >= love.graphics.getHeight())
   then
      ball.dir.y = -ball.dir.y
   else
      ball.y = ball.y + shiftY
   end
end

function checkPaddleCollision(ball, shiftX, shiftY, paddle)
   -- in x range?
   if (ball.x + shiftX - ball.r <= game.paddle1.x + game.paddle1.w
       and ball.y >= game.paddle1.y
       and ball.y <= game.paddle1.y + game.paddle1.h)
   then
      ball.dir.x = 1
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
