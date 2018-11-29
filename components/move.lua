local Component = require "component"

local Move = Component()

function Move:initialize(actor)
	actor:addAction(actions.Move)
	actor.passable = false
end

return Move