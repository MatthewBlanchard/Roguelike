local Action = require "action"

local Reaction = Action()

function Reaction:__new(owner, targets)
	Action.__new(self, owner, target)
	self.reaction = true
end

return Reaction