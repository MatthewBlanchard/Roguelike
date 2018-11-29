local Component = require "component"

local Attacker = Component()

Attacker:requires(components.Stats)

function Attacker:__new(options)
	self.defaultAttack = options.defaultAttack
end

function Attacker:initialize(actor)
	actor.defaultAttack = self.defaultAttack
	actor.attack = self.defaultAttack

	actor:addAction(actions.Attack)
end

return Attacker