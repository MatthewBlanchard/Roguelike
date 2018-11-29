local Panel = require "panel"

local Message = Panel()

Message.handlers = {}

function Message:__new(display, parent)
	Panel.__new(self, display, parent, 16, 51, 50, 3)
	self.messages = {}
end

function Message:update(dt, level, actor)
	if actor:hasComponent(components.Message) then
		for i = 1, #actor.messages do
			if Message.handlers[getmetatable(actor.messages[i])] then
				local s = Message.handlers[getmetatable(actor.messages[i])](actor, actor.messages[i])
				if s then
					table.insert(self.messages, s)
				end
			end
		end

		actor.messages = {}
	end
end

function Message:draw()
	for i = 1, 3 do
		local message = self.messages[#self.messages-(i-1)]
		if self.messages[#self.messages-(i-1)] then
			local msg = message:sub(1,1):upper()..message:sub(2)
			self:write(msg, 1, i, {.3, .3, .3, 1})
		end
	end
end

function Message.actorString(curActor, actor, action)
	local addS = true
	local ownerstring
	if actor == curActor then
		ownerstring = "you"
		addS = false
	elseif actor.aan then
		ownerstring = string.format("%s %s", actor.aan, actor.name)
	else
		ownerstring = actor.name
	end

	return ownerstring, addS
end

Message.handlers[actions.Attack] = function(actor, action)
	local ownerstring, addS = Message.actorString(actor, action.owner, action)
	local targetString = Message.actorString(actor, action.targetActors[1], action)

	local verbstring
	if addS then verbstring = "attacks" else verbstring = "attack" end

	return string.format("%s %s %s", ownerstring, verbstring, targetString)
end

return Message