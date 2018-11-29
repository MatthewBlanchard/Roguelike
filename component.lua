local Object = require "object"

local Component = Object()

function Component:__new()
	self.requirements = {}
end

function Component:requires(component)
	table.insert(self.requirements, component)
end

function Component:checkRequirements(actor)
	local foundreqs = {}

	for k, component in pairs(actor.components) do
		for k, req in pairs(self.requirements) do
			if component:is(req) then
				table.insert(foundreqs, component)
			end
		end
	end

	if #foundreqs == #self.requirements then
		return true
	end

	return false
end

return Component