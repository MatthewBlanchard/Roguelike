local Panel = require "panel"
local Selector = require "panels.selector"

local ContextPanel = Panel()

function ContextPanel:__new(display, parent, target)
	Panel.__new(self, display, parent, 1, 1, display:getWidth(), display:getHeight())
	self.interceptInput = true
	self.targetActor = target
end

function ContextPanel:draw()
	self.allowedAction = {}

	if self.targetActor:hasComponent(components.Usable) then
		for k, action in pairs(self.targetActor.useActions) do
			if action:getNumTargets() > 0 and action:validateTarget(1, self.curActor, self.targetActor) then
				table.insert(self.allowedAction, action)
			end
		end
	end

	for k, action in pairs(self.curActor.actions) do
		if action:getNumTargets() > 0 and action:validateTarget(1, self.curActor, self.targetActor) and not action:is(actions.Attack) then
			table.insert(self.allowedAction, action)
		end
	end

	for i = 1, #self.allowedAction do
		self.display:write(i .. " - " .. self.allowedAction[i].name, 1, i)
	end

	Panel.draw(self)
end

function ContextPanel:handleKeyPress(keypress)
	if self:getPanel() then
		local target = self:getPanel():handleKeyPress(keypress)

		if target then
			return self.currentAction(self.curActor, {self.targetActor, target})
		end

		return
	end

	if keypress == "backspace" then
		self.parent:popPanel()
	end

	local chosenAction = self.allowedAction[tonumber(keypress)] 
	if chosenAction then
		if chosenAction:getNumTargets() == 1 then
			self:popPanel()
			return chosenAction(self.curActor, self.targetActor)
		else
			self:closeOnChild()
			self.currentAction = chosenAction
			self:pushPanel(Selector(display, self, chosenAction.targets[2]))
		end
	end
end

return ContextPanel