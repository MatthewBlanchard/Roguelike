local Component = require "component"

local Usable = Component()

function Usable:__new(actions)
	self.useActions = actions
end

function Usable:initialize(actor)
	actor.useActions = self.useActions
end

return Usable