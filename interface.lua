local Object = require "object"
local Vector2 = require "vector"

local Panel = require "panel"
local Inventory = require "panels.inventory"
local Status = require "panels.status"
local Message = require "panels.message"

local Interface = Panel()

function Interface:__new(display)
	Panel.__new(self, display)
	self.statusPanel = Status(display)
	self.messagePanel = Message(display)
end

function Interface:update(dt, level, actor)
	Panel.update(self, dt, level, actor)
	self.messagePanel:update(dt, level, actor)
end

local function value(c)
	return (c[1]+c[2]+c[3])/3
end

function Interface:draw()
    local fov = self.curActor.fov
    local explored = self.curActor.explored
    local seenActors = self.curActor:getRevealedActors()

    self.curLevel:updateLighting()

    for x = 1, self.curLevel.width do
        for y = 1, self.curLevel.height do
            if fov[x] and fov[x][y] then
                if self.curLevel.light[x] and self.curLevel.light[x][y] and value(self.curLevel.light[x][y]) > .05 then
                    self:write(fov[x][y] == 0 and "." or "#", x, y, self.curLevel.light[x][y])
                else
                    self:write(fov[x][y] == 0 and "." or "#", x, y, {.175, .175, .175, 1})
                end
            elseif explored[x] and explored[x][y] then
                self:write(explored[x][y] == 0 and "." or "#", x, y, {.175, .175, .175, 1})
            end
        end
    end

    for k, actor in pairs(seenActors) do
    	local x, y = actor.position.x, actor.position.y
    	if self.curLevel.light[x] and self.curLevel.light[x][y] then
    		local l = self.curLevel.light[x][y]
    		local c = {(l[1] + 1)/2, (l[2] + 1)/2, (l[3] + 1)/2, 1}
    		self:write(actor.char, x, y, actor.color)
    	end
    end

    self.statusPanel:draw(self.curActor)
    self.messagePanel:draw(self.curActor)

    Panel.draw(self)
end

local movementTranslation = {
	-- cardinal
	w = Vector2(0, -1),
	s = Vector2(0, 1),
	a = Vector2(-1, 0),
	d = Vector2(1, 0),

	-- diagonal
	q = Vector2(-1, -1),
	e = Vector2(1, -1),
	z = Vector2(-1, 1),
	c = Vector2(1, 1)
}

local keybinds = {
	i = "inventory",
	p = "pickup"
}

function Interface:handleKeyPress(keypress)
	if self:getPanel() then
		local a = self:getPanel():handleKeyPress(keypress)
		self:setAction(a)
		return 
	end

	if self.curActor:hasComponent(components.Inventory) then
		if keybinds[keypress] == "inventory" then
			self:pushPanel(Inventory(self.display, self))
		end

		if keybinds[keypress] == "pickup" then
			local item
			for k, i in pairs(self.curActor.seenActors) do
				if actions.Pickup:validateTarget(1, self.curActor, i) then
					return self:setAction(self.curActor:getAction(actions.Pickup)(self.curActor, i))
				end
			end
		end
	end

	-- we're dealing with a directional command here
	if movementTranslation[keypress] and self.curActor:hasComponent(components.Move) then
		local targetPosition = self.curActor.position + movementTranslation[keypress]

		local enemy
		for k, actor in pairs(self.curActor.seenActors) do
			if actor:hasComponent(components.Stats) and not actor.passable and actor.position == targetPosition then
				enemy = actor
			end
		end

		if enemy then
			return self:setAction(self.curActor:getAction(actions.Attack)(self.curActor, enemy))
		end

		return self:setAction(self.curActor:getAction(actions.Move)(self.curActor, movementTranslation[keypress]))
	end
end

function Interface:setAction(action)
	self.action = action
end

function Interface:getAction()
	local action = self.action
	self.action = nil
	return action
end

return Interface