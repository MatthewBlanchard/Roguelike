local Action = require "action"

local ThrowTarget = targets.Creature()
ThrowTarget:setRange(6)

local Throw = Action()
Throw.name = "throw"
Throw:addTarget(targets.Item)
Throw:addTarget(ThrowTarget)

function Throw:perform(level)
	local thrown = self.targetActors[1]
	local target = self.targetActors[2]

	level:moveActor(thrown, target.position)
end

return Throw