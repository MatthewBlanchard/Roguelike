local Controller = require "components.controller"

local AIController = Controller{ inputControlled = false }

function AIController:__new(options)
	Controller.__new(self, {inputControlled = false})
	self.act = options and options.act or self.act
end

function AIController:initialize(actor)
	actor.act = self.act
end