-- chunkname: @scripts/managers/mutator/mutators/mutator_stagger_overrides.lua

require("scripts/managers/mutator/mutators/mutator_base")

local MutatorStaggerOverrides = class("MutatorStaggerOverrides", "MutatorBase")

MutatorStaggerOverrides.init = function (self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)
	MutatorStaggerOverrides.super.init(self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)

	local template = self._template
	local stagger_overrides = template.stagger_overrides

	self._stagger_overrides = stagger_overrides
end

MutatorStaggerOverrides.stagger_overrides = function (self)
	return self._stagger_overrides
end

return MutatorStaggerOverrides
