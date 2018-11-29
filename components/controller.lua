local Component = require "component"

local Controller = Component()

function Controller:__new(options)
	self.inputControlled = self.inputControlled or options.inputControlled
end

function Controller:initialize(actor)
	actor.inputControlled = self.inputControlled
end

return Controller