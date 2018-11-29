local Actor = require "actor"
local Action = require "action"
local Condition = require "condition"

local Drink = Action()
Drink.name = "drink"
Drink:addTarget(targets.Item)

function Drink:__new(owner, target)
	Action.__new(self, owner, target)
	self.name = "drink"
end

function Drink:perform(level)
	local target = self.targetActors[1]
	target.name = "bottle"
	target.color = {.5, .5, .5, 1}
	target:removeComponent(components.Light)
	target:removeComponent(components.Usable)

	self.owner:setHP(self.owner:getHP() + 5)
end

local ExplodeCondition = Condition("innate")

ExplodeCondition:onAction(
	actions.Attack,
	function(self, level, action)
		level:performAction(action.owner:getReaction(reactions.Damage)(action.owner, self, 1))
	end
):where(
	Condition.ownerIsTarget
)

local Potion = Actor()

Potion:addComponents(
	components.Light{ 0.3, 0.0, 0.0, 1 },
	components.Item(),
	components.Usable{Drink},
	components.Stats
	{
		STR = 0,
		DEX = 0,
		INT = 0,
		CON = 0,
		maxHP = 1,
		AC = 5
	}
)

function Potion:__new()
	Actor.__new(self)
	self.name = "potion"
	self.color = {1, 0, 0, 1}
	self.char = "!"

	self:applyCondition(ExplodeCondition())
end

return Potion