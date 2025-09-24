-- chunkname: @scripts/managers/mutator/mutators/mutator_stimmed_minions.lua

require("scripts/managers/mutator/mutators/mutator_base")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MutatorStimmedMinions = class("MutatorStimmedMinions", "MutatorBase")

MutatorStimmedMinions.init = function (self, is_server, network_event_delegate, mutator_template)
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate
	self._is_active = false
	self._buffs = {}
	self._template = mutator_template
	self._breed_chances = self._template.breed_chances
	self._units_to_buff = {}

	if self._is_server then
		Managers.event:register(self, "minion_aggroed", "_on_minion_aggroed")
	end
end

MutatorStimmedMinions.destroy = function (self)
	if self._is_server then
		Managers.event:unregister(self, "minion_aggroed")
	end
end

MutatorStimmedMinions.on_gameplay_post_init = function (self, level, themes)
	local modify_pacing_settings = {
		require_aggro_event = true,
	}

	if self._is_server and modify_pacing_settings then
		Managers.state.pacing:add_pacing_modifiers(modify_pacing_settings)
	end
end

MutatorStimmedMinions._on_minion_aggroed = function (self, unit)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local breed_name = unit_data_extension:breed_name()
	local breed_chance

	if not self._breed_chances[breed_name] then
		return
	else
		breed_chance = self._breed_chances[breed_name]
	end

	if breed_chance > math.random() then
		local blackboard = BLACKBOARDS[unit]
		local stim_component = Blackboard.write_component(blackboard, "stim")

		stim_component.can_use_stim = true
	end
end

return MutatorStimmedMinions
