-- Implementation of Flappy Bird
push=require("push")
Class=require("class")
require("Bird")
require("Pipe")
require("PipePair") 
require("StateMachine")
require("states/BaseState")
require("states/PlayState")
require("states/TitleScreenState")
require("states/ScoreState")
require("states/CountdownState")

WINDOW_WIDTH=1280
WINDOW_HEIGHT=720

VIRTUAL_WIDTH=512
VIRTUAL_HEIGHT=288
local background_img=love.graphics.newImage('assets/images/background.png')
local background_img_scroll=0 --keep track of position to create parallax scroll effect
local BACKGROUND_LOOPING_POINT=413 --reset after point
local BACKGROUND_SCROLL_SPEED=30

local ground_img=love.graphics.newImage('assets/images/ground.png')
local ground_img_scroll=0
local GROUND_SCROLL_SPEED=60 --ground image does not need  looping point as it is entirely the same image

--the use of the scrolling variable is replaced by the use of a state machine
--local scrolling=true --keep track of if game is paused or over to stop updating positions

function love.load() --load all assets and initialize
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest','nearest')
    love.window.setTitle('Flappy Bird')
    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,
    {
        vsync=true,
        resizable=true,
        fullscreen=false
    })
    small_font=love.graphics.newFont("assets/fonts/Montserrat-Bold.ttf",8)
    medium_font=love.graphics.newFont("assets/fonts/Montserrat-Bold.ttf",14)
    large_font=love.graphics.newFont("assets/fonts/Montserrat-Bold.ttf",56)
    title_font=love.graphics.newFont("assets/fonts/Anton-Regular.ttf",28)
    love.graphics.setFont(title_font)
    
    sounds={
        ['jump']=love.audio.newSource('assets/sounds/jump.wav','static'),
        ['score']=love.audio.newSource('assets/sounds/score.wav','static'),
        ['collision']=love.audio.newSource('assets/sounds/collision.wav','static'),
        ['explosion']=love.audio.newSource('assets/sounds/explosion.wav','static'),

        ['title_music']=love.audio.newSource('assets/sounds/title_music.ogg','static')
    }
    sounds['title_music']:setLooping(true)
    sounds['title_music']:play()

    gStateMachine= StateMachine{
        ['title']=function()
            return TitleScreenState() --
        end ,
        ['play']=function()
            return PlayState()
        end ,
        ['score']= function()
            return ScoreState()
        end ,
        ['countdown']= function()
            return CountdownState()
        end
    }
    gStateMachine:change('title')
    love.keyboard.keypressmap={}
end

function love.keyboard.detect_key_press(key)
    return love.keyboard.keypressmap[key]
end

function love.keypressed(Key) --detect key press
    love.keyboard.keypressmap[Key]=true
    if Key=='escape' then
        love.event.quit()
    end
end

function love.update( dt ) --update in delta time   
    background_img_scroll=(background_img_scroll+BACKGROUND_SCROLL_SPEED*dt)%BACKGROUND_LOOPING_POINT    
    --using modulo with looping point resets the image after it crrosses the limit
    ground_img_scroll=(ground_img_scroll+GROUND_SCROLL_SPEED*dt)%VIRTUAL_WIDTH --reset it not noticable
    
    gStateMachine:update(dt)
    
    love.keyboard.keypressmap={}
end

function love.resize( w,h ) --resize game window    
    push:resize(w,h)    
end

function love.draw( ) --render game
    push:start() --since push:apply('start') is now depreceated
    love.graphics.draw(background_img,-background_img_scroll,0) --to draw image onto screen, pass drawable with position    
    gStateMachine:render()
    love.graphics.draw(ground_img,-ground_img_scroll,VIRTUAL_HEIGHT-16) --negative to render behind viewable area and start scroll
    push:finish()
end


