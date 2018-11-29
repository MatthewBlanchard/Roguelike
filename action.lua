local Object = require "object"

local Action = Object()

function Action:__new(owner, targets)
	if targets and not targets[1] then
		targets = {targets}
	end

	self.owner = owner
	self.name = self.name or "ERROR"
	self.targets = self.targets or {}
	self.targetActors = targets
end

function Action:addTarget(target)
	table.insert(self.targets, target)
end

function Action:getTarget(n)
	--print(self.targetActors[1])
	if self.targetActors[n] then
		return self.targetActors[n]
	end
end

function Action:getNumTargets()
	return #self.targets
end

function Action:getTargets()
	return self.targetActors
end

function Action:hasTarget(actor)
	for _, a in pairs(self.targetActors) do
		if a == actor then return true end
	end
end

function Action:validateTarget(n, owner, toValidate)
	return self.targets[n]:validate(owner, toValidate)
end

return Action