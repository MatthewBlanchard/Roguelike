local Component = require "component"

local Light = Component()

function Light:__new(lightColor)
	self.color = lightColor
end

function Light:initialize(actor)
	actor.light = self.color
end

return Light