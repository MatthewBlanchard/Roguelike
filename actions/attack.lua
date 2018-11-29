local Action = require "action"

local Attack = Action()
Attack.name = "attack"
Attack:addTarget(targets.Creature)

function Attack:perform(level)
	local roll = self.owner:rollCheck(self.owner.attack.stat)
	local target = self:getTarget(1)
	local dmg = ROT.Dice.roll(self.owner.attack.dice) + self.owner:getStatBonus(self.owner.attack.stat)

	print(target:getAC())
	if roll >= target:getAC() then
		local damage = target:getReaction(reactions.Damage)(target, self.owner, dmg)
		level:performAction(damage)
	end
end

return Attack