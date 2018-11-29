local Component = require "component"

local Inventory = Component()

function Inventory:__new()
end

function Inventory:initialize(actor)
	actor.hasItem = self.hasItem
	actor.addItem = self.addItem
	actor.inventory = {}
	actor:addAction(actions.Drop)
	actor:addAction(actions.Pickup)
	actor:addAction(actions.Throw)
end

function Inventory.hasItem(owner, item)
	for k, v in pairs(owner.inventory) do
		if v == item then
			return k
		end
	end

	return false
end

function Inventory:addItem(owner, item)
	table.insert(owner.inventory, item)
end

function Inventory:removeItem(owner, item)
	for i = 1, #owner.inventory do
		if owner.inventory[i] == item then
			table.remove(owner.inventory, i)
		end
	end
end

return Inventory