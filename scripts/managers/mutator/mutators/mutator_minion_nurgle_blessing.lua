-- chunkname: @scripts/managers/mutator/mutators/mutator_minion_nurgle_blessing.lua

require("scripts/managers/mutator/mutators/mutator_base")

local MutatorMinionNurgleBlessing = class("MutatorMinionNurgleBlessing", "MutatorBase")

MutatorMinionNurgleBlessing.init = function (self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)
	MutatorMinionNurgleBlessing.super.init(self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)

	local template = self._template
	local modify_pacing_settings = template.modify_pacing

	if self._is_server and modify_pacing_settings then
		Managers.state.pacing:add_pacing_modifiers(modify_pacing_settings)
	end
end

return MutatorMinionNurgleBlessing
