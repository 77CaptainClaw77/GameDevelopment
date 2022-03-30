-- First implentation using the language Lua with Love2D 
--push is used to use game logic regardless of window dimensions
push= require("push")
Class=require("class") --helper class to use classes more easily in lua
require("Ball") --using class.lua allows direct imports like this
require("Paddle")

WINDOW_WIDTH=1280
WINDOW_HEIGHT=720

VIRTUAL_WIDTH=432 --Logic is written considering these heights
VIRTUAL_HEIGHT=243

WIN_LIMIT=5 --number of points required to win
--[[
    This is a multiline comment in Lua
    Now the main code starts
]]

function  love.load()  -- so this function is called only on game load and is like a constructor
   --[[ love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen=false,
        resizable=false,
        vsync=true
    }) ]]
    sounds={ --static are small audio files kept in memory
        ['paddle_hit']=love.audio.newSource('sounds/collision.wav','static'), --can use as sounds.paddle_hit
        ['wall']=love.audio.newSource('sounds/hit.wav','static'), --or sounds['paddle_hit']
        ['score']=love.audio.newSource('sounds/point.wav','static')
    }
    winner=''
    love.window.setTitle('Pong')
    math.randomseed(os.time()) --seeding the random function
    titlefont=love.graphics.newFont('fonts/homelanderwide.ttf',20) --Load font
    scorefont=love.graphics.newFont('fonts/Pixeboy-z8XGD.ttf',20)
    fpsfont=love.graphics.newFont('fonts/batmfa__.ttf',6)
    love.graphics.setFont(titlefont) --set loaded font
    love.graphics.setDefaultFilter('nearest','nearest') --arg 1 is for scaling up and arg 2 is for scaling down
    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen=false,
        resizable=true,
        vsync=true
    })
    -- initializing the two players
    player1= Paddle(10,30,5,20)
    player2= Paddle(VIRTUAL_WIDTH-15,VIRTUAL_HEIGHT-50,5,20)
    -- initializing the ball
    ball= Ball(VIRTUAL_WIDTH/2-2,VIRTUAL_HEIGHT/2-2,4,4)
    -- initializing the game state
    state= 'start'
end -- end is used to mark the scope in Lua

function love.keypressed( key ) --this function is called everythime a keypress is detected.
    if key=='escape' then
        love.event.quit() --exit game
    elseif key=='enter' or key=='return' then
        if state=='done' then
            state='serve'
            serve=winner
            ball:reset()
            player1.score=0
            player2.score=0
        else
            state='play'
        end
    end
end
--[[
    The update funcion runs every frame as well and takes deleta time as an argument
]]
function love.resize(w,h)
    push:resize(w,h) --to call from push so it is scaled
end
function love.update(dt)
    --handle paddle movement
    --player1 uses w and s for movement while player2 used up and down arrows
    if love.keyboard.isDown('w') then 
        player1.speed_Y= -player1.default_speed_Y --set the direction to -ve ie. moving upwards
    elseif love.keyboard.isDown('s') then --above is negative movement since origin is at top left corner
        player1.speed_Y= player1.default_speed_Y --set the direction to -ve ie. moving downwards
    else
        player1.speed_Y= 0
    end --using else if instead of if ensures movement only in single direction
    --player2 movement
    if love.keyboard.isDown('up') then -- -20 because height of paddle is 20
        player2.speed_Y= -player2.default_speed_Y
    elseif love.keyboard.isDown('down') then
        player2.speed_Y= player2.default_speed_Y
    else
        player2.speed_Y= 0
    end
    --check for collisions and perform actions only during play state
    if state=='play' then
        if ball:check_collision(player1) then
            sounds['paddle_hit']:play()
            ball:rebound(player1,'left')
        elseif ball:check_collision(player2) then
            sounds['paddle_hit']:play()
            ball:rebound(player2,'right')
        elseif ball.Y<0 then
            sounds['wall']:play()
            ball:rebound(nil,'top')
        elseif ball.Y>VIRTUAL_HEIGHT-ball.height then
            sounds['wall']:play()
            ball:rebound(nil,'bottom')
        end
    end
    --check if any player scores a point 
    --if yes update the serve and the score as well as game state
    if ball.X<0 then
        sounds['score']:play()
        serve='player1' -- change the serve 
        player2.score=player2.score+1
        if player2.score==WIN_LIMIT then
            state='done'
            winner='player2'
        else
            state='serve'            
        end
        ball:reset()
    elseif ball.X+ball.width>VIRTUAL_WIDTH then
        sounds['score']:play()
        serve='player2'
        player1.score=player1.score+1
        if player1.score==WIN_LIMIT then
            state='done'
            winner='player1'
        else
            state='serve'
        end
        ball:reset()
    end
    --handle player's serve
    if state=='serve' then 
        ball.speed_Y=math.random( -50,50 ) --y speed is a random value independent of serve
        if serve=='player1' then
            ball.speed_X= math.random( 140,200 ) --move towards right
        else
            ball.speed_X= -math.random( 140,200 ) --move towards left
        end
    end
    if state=='play' then
        ball:update_position(dt) --ball moves only in  'play' state
    end
    player1:update_position(dt)
    player2:update_position(dt) -- : for member functions and  . for member variables

end

function love.draw(  ) --This function is called every for single frame
    push:apply('start') --from here on all rendering is done at virtual resolutioon

    love.graphics.clear(0,0,0,1) -- flush screen with a particular colour last arg is opacity ,others are RGB
    love.graphics.setFont(titlefont)
    if state=='start' then
        love.graphics.printf('PRESS ENTER TO START',0,20,VIRTUAL_WIDTH,'center')
    elseif state=='serve' then
        love.graphics.printf(serve:upper() .. "'s Serve",0,10,VIRTUAL_WIDTH,'center')
        love.graphics.printf('PRESS ENTER TO SERVE',0,30,VIRTUAL_WIDTH,'center')
        --     love.graphics.printf('Press Enter to Reset',0,20,VIRTUAL_WIDTH,'center')
    elseif state=='done' then
        love.graphics.setFont(titlefont)
        love.graphics.printf(winner.." won!!",0,10,VIRTUAL_WIDTH,'center')
        love.graphics.setFont(fpsfont)
        love.graphics.printf("Press enter to restart",0,30,VIRTUAL_WIDTH,'center')
    end
    --now drawing the paddles and the ball
    player1:render()
    player2:render()
    ball:render()    
    --display the FPS
    displayFPS()
    --display the score
    displayScore()
    push:apply('end')
end

function displayFPS()
   love.graphics.setFont(fpsfont)
   love.graphics.setColor(1,0,0,1)
   love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10) -- the .. operator is used for string concatenation 
end

function displayScore()
    love.graphics.setFont(scorefont)
    love.graphics.print(tostring(player1.score), VIRTUAL_WIDTH / 2 - 50,VIRTUAL_HEIGHT / 4)
    love.graphics.print(tostring(player2.score), VIRTUAL_WIDTH / 2 + 30,VIRTUAL_HEIGHT / 4) 
end