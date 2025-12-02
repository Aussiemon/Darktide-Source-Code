-- chunkname: @scripts/extension_systems/weapon/actions/action_base.lua

local ActionBase = class("ActionBase")

ActionBase.init = function (self, action_context, action_params, action_settings)
	self._world = action_context.world
	self._physics_world = action_context.physics_world
	self._wwise_world = action_context.wwise_world
	self._first_person_unit = action_context.first_person_unit

	local player_unit = action_context.player_unit

	self._player_unit = player_unit

	local player_unit_spawn_manager = Managers.state.player_unit_spawn

	self._player = player_unit_spawn_manager:owner(player_unit)
	self._animation_extension = action_context.animation_extension
	self._camera_extension = action_context.camera_extension
	self._first_person_extension = action_context.first_person_extension
	self._fx_extension = action_context.fx_extension
	self._input_extension = action_context.input_extension
	self._visual_loadout_extension = action_context.visual_loadout_extension
	self._smart_targeting_extension = action_context.smart_targeting_extension
	self._unit_data_extension = action_context.unit_data_extension
	self._dialogue_input = action_context.dialogue_input

	local weapon_action_component = action_context.weapon_action_component

	self._weapon_action_component = weapon_action_component
	self._ability_extension = action_context.ability_extension
	self._first_person_component = action_context.first_person_component
	self._inair_state_component = action_context.inair_state_component
	self._inventory_component = action_context.inventory_component
	self._locomotion_component = action_context.locomotion_component
	self._movement_state_component = action_context.movement_state_component
	self._sprint_character_state_component = action_context.sprint_character_state_component
	self._action_settings = action_settings
	self._is_server = action_context.is_server
	self._is_local_unit = action_context.is_local_unit
	self._is_human_controlled = action_context.is_human_controlled
	self._buff_extension = ScriptUnit.extension(player_unit, "buff_system")
end

ActionBase.start = function (self, action_settings, t, time_scale, action_start_params)
	return
end

ActionBase.finish = function (self, reason, data, t, time_in_action)
	return
end

ActionBase.update = function (self, dt, t)
	return
end

ActionBase.fixed_update = function (self, dt, t, time_in_action)
	return
end

ActionBase.action_settings = function (self)
	return self._action_settings
end

ActionBase.server_correction_occurred = function (self)
	return
end

ActionBase.trigger_anim_event = function (self, anim_event, anim_event_3p, action_time_offset, ...)
	local time_scale = self._weapon_action_component.time_scale
	local anim_ext = self._animation_extension

	action_time_offset = action_time_offset or 0

	anim_ext:anim_event_with_variable_floats_1p(anim_event, "attack_speed", time_scale, "action_time_offset", action_time_offset, ...)

	if anim_event_3p then
		anim_ext:anim_event_with_variable_floats(anim_event_3p, "attack_speed", time_scale, "action_time_offset", action_time_offset, ...)
	end
end

ActionBase.running_action_state = function (self, t, time_in_action)
	return nil
end

ActionBase.allow_chain_actions = function (self)
	return true
end

ActionBase.sensitivity_modifier = function (self, t)
	local action_settings = self._action_settings
	local sensitivity_modifier = action_settings and action_settings.sensitivity_modifier or 1

	return sensitivity_modifier
end

ActionBase.rotation_contraints = function (self)
	local action_settings = self._action_settings
	local rotation_contraints = action_settings and action_settings.rotation_contraints

	return rotation_contraints
end

ActionBase._use_ability_charge = function (self, optional_num_charges)
	local action_settings = self._action_settings
	local ability_type = action_settings.ability_type
	local ability_extension = self._ability_extension

	ability_extension:use_ability_charge(ability_type, optional_num_charges)
end

return ActionBase
