local Panel = require "panel"

function blink(period)
	local t = 0
	return function(dt)
		t = t + dt
		if t < period then
			return true
		elseif t > period*2 then
			t = t - period * 2
			return false
		elseif t > period then
			return false
		end
	end
end

local SelectorPanel = Panel()

function SelectorPanel:__new(display, parent, targetType)
	Panel.__new(self, display, parent, 1, 1, display:getWidth(), display:getHeight())
	self.interceptInput = true
	self.targetType = targetType
	self.blinkFunc = blink(0.3)
end

function SelectorPanel:draw()
	local target = self.curActor.seenActors[self.curTarget]
	local blinkString = self.blink and target.char or "X"
	local blinkColor = self.blink and target.color or {.6, 0, 0, 1}

	display:write(blinkString, target.position.x, target.position.y, blinkColor)
	display:write(target.name, target.position.x+2, target.position.y)
end

function SelectorPanel:update(dt, level, actor)
	Panel.update(self, dt, level, actor)
	self.blink = self.blinkFunc(dt)

	if not self.curTarget then
		self:tabTarget(actor)
	end
end

function SelectorPanel:tabTarget(actor)
	if self.curTarget then
		if self.curTarget + 1 > #actor.seenActors then
			n = 1
		else
			n = self.curTarget+1
		end
	else
		n = 1
	end

	for i = n, #actor.seenActors do
		if self.targetType:validate(actor, actor.seenActors[i]) then
			self.curTarget = i
			break
		end
	end

	if not self.curTarget then
		self.parent:popPanel()
	end
end

function SelectorPanel:handleKeyPress(keypress)
	Panel.handleKeyPress(self, keypress)
	
	if keypress == "tab" then
		self:tabTarget(self.curActor)
	elseif keypress == "return" then
		self.parent:popPanel()
		return self.curActor.seenActors[self.curTarget]
	end
end

return SelectorPanel