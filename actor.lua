local Object = require "object"
local Vector2 = require "vector"

local Actor = Object()

function Actor:__new()
	self.position = Vector2(1, 1)
	self.lposition = self.position

	self.passable = true
	
	self.color = self.color or {1, 1, 1, 1}
	self.char = self.char or "@"

	self.name = self.actor or "Actor"
	self.conjugate = self.conjugate or true
	self.heshe = self.heshe or "it"
	self.aan = self.aan or "a"

	self.actions = self.actions or {}
	self.reactions = self.reactions or {}
	self.innateConditions = self.innateConditions or {}
	self.conditions = {}

	for k, v in pairs(self.innateConditions) do
		self:applyCondition(v())
	end

	if self.components then
		local comp = {}
		for k,v in pairs(self.components) do
			table.insert(comp, v)
		end
		self.components = comp
	else
		self.components = {}
	end

	self:initializeComponents()
end

function Actor:draw(display)
	display:write(self.char, self.position.x, self.position.y)
end

function Actor:addComponent(component)
	if not component:checkRequirements(self) then
		error("Unsupported component added to actor!")
	end

	table.insert(self.components, component)
end

function Actor:addComponents(component, ...)
	if not component then return end

	if not component:checkRequirements(self) then
		error("Unsupported component added to actor!")
	end

	table.insert(self.components, component)
	self:addComponents(...)
end

function Actor:removeComponent(component)
	for i = 1, #self.components do
		if self.components[i]:is(component) then
			table.remove(self.components, i)
			return
		end
	end
end

function Actor:hasComponent(type)
	for k, component in pairs(self.components) do
		if component:is(type) then
			return true
		end
	end

	return false
end

function Actor:initializeComponents()
	for k,component in pairs(self.components) do
		component:initialize(self)
	end
end

function Actor:addAction(action)
	table.insert(self.actions, action)
end

function Actor:getAction(action)
	for k,v in pairs(self.actions) do
		if v:is(action) then
			return v
		end
	end
end


function Actor:addReaction(reaction)
	table.insert(self.reactions, reaction)
end

function Actor:getReaction(reaction)
	for k,v in pairs(self.reactions) do
		if v:is(reaction) then
			return v
		end
	end
end

function Actor:applyCondition(condition)
	table.insert(self.conditions, condition)
	condition.actor = self
end

function Actor:removeCondition(condition)
	for i = 1, #self.conditions do
		if self.conditions[i] == condition then
			table.remove(self.conditions, i)
			return true
		end
	end

	return false
end

function Actor:getConditions()
	return self.conditions
end

-- utility functions
function Actor:getRange(type, actor)
	if type == "box" then
		local range
		local i = 1
		local a1 = self
		local a2 = actor
		while not range do
			if 
				a2.position.x >= a1.position.x - i and
		    	a2.position.x <= a1.position.x + i and
		    	a2.position.y >= a1.position.y - i and
		    	a2.position.y <= a1.position.y + i 
		    then
		    	range = i
		    end

		    i = i + 1
		end

		return range
	else
    	return math.sqrt(math.pow(self.position.x - actor.position.x, 2) + math.pow(self.position.y - actor.position.y, 2))
    end
end

return Actor