require("scripts/extension_systems/animation/authoritative_player_unit_animation_extension")
require("scripts/extension_systems/animation/minion_animation_extension")
require("scripts/extension_systems/animation/player_husk_animation_extension")
require("scripts/extension_systems/animation/player_unit_animation_extension")
require("scripts/extension_systems/animation/prop_animation_extension")

local AnimCallbackTemplates = require("scripts/extension_systems/animation/anim_callback_templates")
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
	"rpc_sync_anim_state"
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
			extension.bone_lod_extension_id = Managers.state.bone_lod:register_unit(unit, radius, false)
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
	local callback = nil

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
	if unit_id ~= NetworkConstants.invalid_level_unit_id then
		local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)

		Unit.animation_event_by_index(unit, event_index)
	end
end

AnimationSystem.rpc_prop_anim_event_variable_float = function (self, channel_id, unit_id, is_level_unit, event_index, variable_index, variable_value)
	if unit_id ~= NetworkConstants.invalid_level_unit_id then
		local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)

		Unit.animation_set_variable(unit, variable_index, variable_value)
		Unit.animation_event_by_index(unit, event_index)
	end
end

AnimationSystem.rpc_prop_anim_set_variable = function (self, channel_id, unit_id, is_level_unit, variable_index, variable_value)
	if unit_id ~= NetworkConstants.invalid_level_unit_id then
		local unit = Managers.state.unit_spawner:unit(unit_id, is_level_unit)

		Unit.animation_set_variable(unit, variable_index, variable_value)
	end
end

AnimationSystem.rpc_minion_anim_event = function (self, channel_id, unit_id, event_index)
	local unit = Managers.state.unit_spawner:unit(unit_id)

	Unit.animation_event_by_index(unit, event_index)
end

AnimationSystem.rpc_minion_anim_event_variable_float = function (self, channel_id, unit_id, event_index, variable_index, variable_value)
	local unit = Managers.state.unit_spawner:unit(unit_id)

	Unit.animation_set_variable(unit, variable_index, variable_value)
	Unit.animation_event_by_index(unit, event_index)
end

AnimationSystem.rpc_player_anim_event = function (self, channel_id, unit_id, event_index, is_first_person)
	local unit = nil
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
	local unit = nil
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
	local unit = nil
	local third_person_unit = Managers.state.unit_spawner:unit(unit_id)

	if is_first_person then
		local first_person_ext = ScriptUnit.extension(third_person_unit, "first_person_system")
		unit = first_person_ext:first_person_unit()
	else
		unit = third_person_unit
	end

	for i = 1, #variable_indexes, 1 do
		local variable_index = variable_indexes[i]
		local variable_value = variable_values[i]

		Unit.animation_set_variable(unit, variable_index, variable_value)
	end

	Unit.animation_event_by_index(unit, event_index)
end

AnimationSystem.rpc_player_anim_event_variable_int = function (self, channel_id, unit_id, event_index, variable_index, variable_value, is_first_person)
	local unit = nil
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

return AnimationSystem
