require("scripts/managers/mutator/mutators/mutator_base")

local MutatorMinionNurgleBlessing = class("MutatorMinionNurgleBlessing", "MutatorBase")

MutatorMinionNurgleBlessing.init = function (self, is_server, network_event_delegate, mutator_template)
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate
	self._is_active = false
	self._buffs = {}
	self._template = mutator_template
	local template = self._template
	local modify_pacing_settings = template.modify_pacing

	if self._is_server and modify_pacing_settings then
		Managers.state.pacing:add_pacing_modifiers(modify_pacing_settings)
	end
end

return MutatorMinionNurgleBlessing
