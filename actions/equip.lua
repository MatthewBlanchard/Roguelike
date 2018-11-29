local Action = require "action"

local Equip = Action()
Equip.name = "equip"
Equip:addTarget(targets.Equipment)

function Equip:perform(level)
	local equipment = self:getTarget(1)
	
	self.owner.slots[equipment.slot] = equipment
end

return Equip