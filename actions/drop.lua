local Action = require "action"

local Vector2 = require "vector"

local Drop = Action()
Drop.name = "drop"
Drop:addTarget(targets.Item)

function Drop:perform(level)
	for k,v in pairs(self.owner.inventory) do
		if v == self.targetActors[1] then
			level:moveActor(v, self.owner.position)
			break
		end
	end
end

return Drop