StateMachine=Class{}

function StateMachine:init(states)
    self.empty = {
        render= function() end,
        update= function() end,
        enter= function() end,
        exit= function() end
    }
    self.states=states or {} --if states is not defined set it to empty table 
    self.current=self.empty
end

function StateMachine:change(state_name,enter_params) --enter_params is optional
    assert(self.states[state_name]) --state must exist
    self.current:exit() --exit current state
    self.current=self.states[state_name]() --get the new state
    self.current:enter(enter_params) --enter the new state with enter_params
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end