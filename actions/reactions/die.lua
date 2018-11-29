local Reaction = require "reaction"

local Die = Reaction()
Die.name = "damage"

function Die:perform(level)	
	level:destroyActor(self.owner)
end

return Die