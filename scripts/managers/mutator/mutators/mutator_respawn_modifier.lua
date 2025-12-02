-- chunkname: @scripts/managers/mutator/mutators/mutator_respawn_modifier.lua

require("scripts/managers/mutator/mutators/mutator_base")

local MutatorRespawnModifier = class("MutatorRespawnModifier", "MutatorBase")

MutatorRespawnModifier.init = function (self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)
	MutatorRespawnModifier.super.init(self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)
end

MutatorRespawnModifier.time = function (self)
	return self._template.time
end

MutatorRespawnModifier.respawn_state = function (self)
	return self._template.respawn_state or "hogtied"
end

return MutatorRespawnModifier
