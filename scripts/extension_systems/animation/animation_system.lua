-- chunkname: @scripts/extension_systems/animation/animation_system.lua

require("scripts/extension_systems/animation/authoritative_player_unit_animation_extension")
require("scripts/extension_systems/animation/minion_animation_extension")
require("scripts/extension_systems/animation/player_husk_animation_extension")
require("scripts/extension_systems/animation/player_unit_animation_extension")
require("scripts/extension_systems/animation/prop_animation_extension")

local AnimCallbackTemplates = require("scripts/extension_systems/animation/anim_callback_templates")
local CompanionHubInteractionsSettings = require("scripts/settings/companion_hub_interactions/companion_hub_interactions_settings")
local AnimationSystem = class("AnimationSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_prop_anim_event",
	"rpc_prop_anim_event_variable_float",
	"rpc_prop_anim_set_variable",
	"rpc_minion_anim_event",
	"rpc_minion_anim_event_variable_float",
	"rpc_player_anim_event",
	"rpc_player_anim_event_variable_float",
	"rpc_player_anim_event_variable_floats",
	"rpc_player_anim_event_variable_int",
	"rpc_sync_anim_state",
}

AnimationSystem.init = function (self, ...)
	AnimationSystem.super.init(self, ...)

	self._animation_lod_units = {}

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

AnimationSystem.destroy = function (self, ...)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	AnimationSystem.super.destroy(self, ...)
end

AnimationSystem.register_extension_update = function (self, unit, extension_name, extension)
	AnimationSystem.super.register_extension_update(self, unit, extension_name, extension)

	local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")

	if unit_data_extension then
		local breed = unit_data_extension:breed()
		local use_bone_lod = breed.use_bone_lod

		if use_bone_lod then
			local radius = breed.bone_lod_radius or BoneLod.DEFAULT_UNIT_RADIUS

			extension.bone_lod_extension_id = Managers.state.bone_lod:register_unit(unit, radius, true)
			self._animation_lod_units[unit] = extension
		end
	end
end

AnimationSystem.on_remove_extension = function (self, unit, extension_name)
	local extension = self._animation_lod_units[unit]

	if extension then
		Managers.state.bone_lod:unregister_unit(extension.bone_lod_extension_id)

		self._animation_lod_units[unit] = nil
	end

	AnimationSystem.super.on_remove_extension(self, unit, extension_name)
end

AnimationSystem.anim_callback = function (self, unit, callback_name, param1)
	local callback

	if self._is_server then
		callback = AnimCallbackTemplates.server[callback_name]

		if callback then
			callback(unit, param1)
		end
	end

	callback = AnimCallbackTemplates.client[callback_name]

	if callback then
		callback(unit, param1)
	end
end

AnimationSystem.rpc_prop_anim_event = function (self, channel_id, unit_id, is_level_unit, event_index)
	if not is_level_unit or unit_id ~= NetworkConstants.invalid_level_unit_id then
		local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)

		Unit.animation_event_by_index(unit, event_index)
	end
end

AnimationSystem.rpc_prop_anim_event_variable_float = function (self, channel_id, unit_id, is_level_unit, event_index, variable_index, variable_value)
	if not is_level_unit or unit_id ~= NetworkConstants.invalid_level_unit_id then
		local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)

		Unit.animation_set_variable(unit, variable_index, variable_value)
		Unit.animation_event_by_index(unit, event_index)
	end
end

AnimationSystem.rpc_prop_anim_set_variable = function (self, channel_id, unit_id, is_level_unit, variable_index, variable_value)
	if not is_level_unit or unit_id ~= NetworkConstants.invalid_level_unit_id then
		local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)

		Unit.animation_set_variable(unit, variable_index, variable_value)
	end
end

AnimationSystem.rpc_minion_anim_event = function (self, channel_id, unit_id, event_index)
	local unit = Managers.state.unit_spawner:unit(unit_id)

	Unit.animation_event_by_index(unit, event_index)
end

AnimationSystem.rpc_minion_anim_event_variable_float = function (self, channel_id, unit_id, event_index, variable_index, variable_value, variable_name)
	local unit = Managers.state.unit_spawner:unit(unit_id)
	local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")

	if unit_data_extension then
		local breed = unit_data_extension:breed()

		if breed then
			local variable_bounds = breed.get_animation_variable_bounds and breed.get_animation_variable_bounds() or breed.animation_variable_bounds

			if variable_bounds and variable_bounds[variable_name] then
				variable_value = math.clamp(variable_value, variable_bounds[variable_name][1], variable_bounds[variable_name][2])
			end
		end
	end

	Unit.animation_set_variable(unit, variable_index, variable_value)
	Unit.animation_event_by_index(unit, event_index)
end

AnimationSystem.rpc_player_anim_event = function (self, channel_id, unit_id, event_index, is_first_person)
	local unit
	local third_person_unit = Managers.state.unit_spawner:unit(unit_id)

	if is_first_person then
		local first_person_ext = ScriptUnit.extension(third_person_unit, "first_person_system")

		unit = first_person_ext:first_person_unit()
	else
		unit = third_person_unit
	end

	Unit.animation_event_by_index(unit, event_index)
end

AnimationSystem.rpc_player_anim_event_variable_float = function (self, channel_id, unit_id, event_index, variable_index, variable_value, is_first_person)
	local unit
	local third_person_unit = Managers.state.unit_spawner:unit(unit_id)

	if is_first_person then
		local first_person_ext = ScriptUnit.extension(third_person_unit, "first_person_system")

		unit = first_person_ext:first_person_unit()
	else
		unit = third_person_unit
	end

	Unit.animation_set_variable(unit, variable_index, variable_value)
	Unit.animation_event_by_index(unit, event_index)
end

AnimationSystem.rpc_player_anim_event_variable_floats = function (self, channel_id, unit_id, event_index, variable_indexes, variable_values, is_first_person)
	local unit
	local third_person_unit = Managers.state.unit_spawner:unit(unit_id)

	if is_first_person then
		local first_person_ext = ScriptUnit.extension(third_person_unit, "first_person_system")

		unit = first_person_ext:first_person_unit()
	else
		unit = third_person_unit
	end

	for i = 1, #variable_indexes do
		local variable_index = variable_indexes[i]
		local variable_value = variable_values[i]

		Unit.animation_set_variable(unit, variable_index, variable_value)
	end

	Unit.animation_event_by_index(unit, event_index)
end

AnimationSystem.rpc_player_anim_event_variable_int = function (self, channel_id, unit_id, event_index, variable_index, variable_value, is_first_person)
	local unit
	local third_person_unit = Managers.state.unit_spawner:unit(unit_id)

	if is_first_person then
		local first_person_ext = ScriptUnit.extension(third_person_unit, "first_person_system")

		unit = first_person_ext:first_person_unit()
	else
		unit = third_person_unit
	end

	Unit.animation_set_variable(unit, variable_index, variable_value)
	Unit.animation_event_by_index(unit, event_index)
end

AnimationSystem.rpc_sync_anim_state = function (self, channel_id, unit_id, is_level_unit, animation_state, seeds)
	local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)

	Unit.animation_set_state(unit, unpack(animation_state))
	Unit.animation_set_seeds(unit, unpack(seeds))
end

AnimationSystem.play_companion_interaction_anim_event = function (player_unit, companion_unit, anim_event_player, anim_event_companion, optional_variable_name, optional_variable_value)
	if optional_variable_name and optional_variable_value then
		local variable_index = Unit.animation_find_variable(player_unit, optional_variable_name)
		local variable_index_companion = Unit.animation_find_variable(companion_unit, optional_variable_name)

		Unit.animation_set_variable(player_unit, variable_index, optional_variable_value)
		Unit.animation_set_variable(companion_unit, variable_index_companion, optional_variable_value)
	end

	local player_event_index = Unit.animation_event(player_unit, anim_event_player)
	local companion_event_index = Unit.animation_event(companion_unit, anim_event_companion)

	Unit.animation_event_by_index(player_unit, player_event_index)
	Unit.animation_event_by_index(companion_unit, companion_event_index)
end

return AnimationSystem
