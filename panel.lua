local Object = require "object"

local Panel = Object()

function Panel:__new(display, parent, x, y, w, h)
	self.display = display
	self.parent = parent
	self.x = x or 1
	self.y = y or 1
	self.w = w or display and display:getWidth() or 1
	self.h = h or display and display:getHeight() or 1

	self.panels = {}
end

function Panel:draw(x, y)
	if self:getPanel() then
    	self:getPanel():draw()
    end
end

function Panel:update(dt, level, actor)
	self.curLevel = level
	self.curActor = actor

	if self:getPanel() then
		self:getPanel():update(dt, level, actor)
	end
end

function Panel:write(c, x, y, fg, bg)
	local w, h = x + string.len(c) - 1
	if x < 1 or w > self.w or y < 1 or y > self.h then
		error("Tried to write out of bounds to a panel!")
	end

	display:write(c, self.x+x-1, self.y+y-1, fg, bg)
end

function Panel:handleKeyPress(keypress)
	if self:getPanel() then
		local a = self:getPanel():handleKeyPress(keypress)
		return a
	end

	if keypress == "backspace" then
		self.parent:popPanel()
	end
end

function Panel:pushPanel(panel)
	table.insert(self.panels, panel)
end

function Panel:getPanel()
	return self.panels[#self.panels]
end

function Panel:popPanel()
	if self.panels[#self.panels] then
		self.panels[#self.panels] = nil
		if #self.panels == 0 and self.shouldClose == true then
			self.parent:popPanel()
		end
	else
		self.parent:popPanel()
	end
end

function Panel:closeOnChild()
	self.shouldClose = true
end

return Panel