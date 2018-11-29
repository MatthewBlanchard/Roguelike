local Action = require "action"

local Pickup = Action()
Pickup.name = "pick up"
Pickup:addTarget(targets.Pickup)

function Pickup:perform(level)
	local target = self.targetActors[1]
	level:removeActor(target)
	table.insert(self.owner.inventory, target)
end

return Pickup