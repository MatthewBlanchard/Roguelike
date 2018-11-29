local Component = require "component"
local Condition = require "condition"

local EquipCondition = Condition()

EquipCondition:afterAction(actions.Equip,
	function(self, level, action)
		print(self.name)
		for k, effect in pairs(self.effects) do
			print(self.name)
			action.owner:applyCondition(effect())
		end
	end
):where(Condition.ownerIsTarget)

EquipCondition:afterAction(actions.Unequip,
	function(self, level, action)
		for k, effect in pairs(self.effects) do
			action.owner:removeCondition(effect)
		end
	end
):where(Condition.ownerIsTarget)

local Equipment = Component()

Equipment:requires(components.Item)

function Equipment:__new(options)
	self.slot = options.slot
	self.effects = options.effects
end

function Equipment:initialize(actor)
	actor.slot = self.slot
	actor.effects = self.effects
	actor:applyCondition(EquipCondition)
end

return Equipment