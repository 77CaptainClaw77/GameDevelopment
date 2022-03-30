TitleScreenState= Class{__includes=BaseState} --inherit from base state

function TitleScreenState:update(dt)
    if love.keyboard.detect_key_press('enter') or love.keyboard.detect_key_press('return') then
        gStateMachine:change('countdown')
    end
end

function TitleScreenState:render()
    love.graphics.setFont(title_font)
    love.graphics.printf('Flappy Bird',0,64,VIRTUAL_WIDTH,'center')
    love.graphics.setFont(medium_font)
    love.graphics.printf('Press Enter!',0,100,VIRTUAL_WIDTH,'center')
end