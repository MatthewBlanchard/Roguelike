local Object = require "object"

local targets = {}

local Target = Object()
targets.Target = Target

function Target:__new(range)
	if self.requirements then
		local comp = {}
		for k,v in pairs(self.requirements) do
			table.insert(comp, v)
		end
		self.requirements = comp
	else
		self.requirements = {}
	end

	self.range = 0 or range
end

function Target:addRequirement(component)
	table.insert(self.requirements, component)
end

function Target:setRange(range, enum)
	self.range = range
	self.rtype = enum
end

function Target:validate(owner, actor)
	local range

	if self.range == 0 then
		if owner:hasComponent(components.Inventory) then
			for k, v in pairs(owner.inventory) do
				if v == actor then
					range = true
				end
			end
		end

		if owner.position == actor.position then
			range = true
		end
	else
		range = owner:getRange(self.rtype, actor)
	end

	return self:checkRequirements(actor) and range
end

function Target:checkRequirements(actor)
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

targets.Creature = Target()

targets.Creature:addRequirement(components.Stats)

targets.Item = Target()

targets.Item:addRequirement(components.Item)

targets.Pickup = targets.Item()

function targets.Pickup:validate(owner, actor)
	if actor == owner then
		return false
	end
	
	for k, item in pairs(owner.inventory) do
		if item == actor then
			return false
		end
	end

	if owner.slots and owner.slots[actor.slot] == actor then
		return false
	end

	return Target.validate(self, owner, actor)
end

targets.Equipment = targets.Item()
targets.Equipment:addRequirement(components.Equipment)

function targets.Equipment:validate(owner, actor)
	return Target.validate(self, owner, actor) and owner:hasSlot(actor.slot) and not owner.slots[actor.slot]
end


targets.Unequip = targets.Item()
targets.Unequip:addRequirement(components.Equipment)

function targets.Unequip:validate(owner, actor)
	return Target.validate(self, owner, actor) and owner.slots[actor.slot] == actor
end

return targets