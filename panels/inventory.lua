local Panel = require "panel"
local ContextPanel = require "panels.context"

local InventoryPanel = Panel()

function InventoryPanel:__new(display, parent)
	Panel.__new(self, display, parent, 1, 1, display:getWidth(), display:getHeight())
	self.interceptInput = true
end

function InventoryPanel:draw()
	if self:getPanel() then
		Panel.draw(self)
		return
	end

	local actor = self.curActor

	display:write("Inventory", 1, 1)
	if actor.inventory and #actor.inventory > 0 then
		for i = 1, #actor.inventory do
			self.display:write(i .. "    " .. actor.inventory[i].name, 1, 1+i)
		end
	end

	Panel.draw(self)
end

function InventoryPanel:update(dt, level, actor)
	Panel.update(self, dt, level, actor)

	if #actor.inventory == 0 then
		self.parent:popPanel()
	end

	if not self:getPanel() and self.shouldClose then
		self.parent:popPanel()
	end
end

function InventoryPanel:handleKeyPress(keypress)
	action = Panel.handleKeyPress(self, keypress)

	if action then
		return action
	end

	local item = self.curActor.inventory[tonumber(keypress)]
	if item then
		self.shouldClose = true
		self:pushPanel(ContextPanel(self.display, self, self.curActor.inventory[tonumber(keypress)]))
	end
end

return InventoryPanel