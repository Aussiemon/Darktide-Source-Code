-- chunkname: @scripts/extension_systems/animation/player_unit_animation_extension.lua

local Action = require("scripts/utilities/action/action")
local PlayerUnitAnimationState = require("scripts/extension_systems/animation/utilities/player_unit_animation_state")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")

local function _log(...)
	Log.info("PlayerUnitAnimationExtension", ...)
end

local PlayerUnitAnimationExtension = class("PlayerUnitAnimationExtension")

PlayerUnitAnimationExtension.init = function (self, extension_init_context, unit, extension_init_data)
	self._unit = unit

	local unit_data = ScriptUnit.extension(unit, "unit_data_system")

	self._unit_data_extension = unit_data

	local animation_state = unit_data:write_component("animation_state")

	PlayerUnitAnimationState.init_anim_state_component(animation_state)

	self._animation_state_component = animation_state
	self._weapon_action_component = unit_data:read_component("weapon_action")
	self._character_state_component = unit_data:read_component("character_state")
	self._alternate_fire_component = unit_data:read_component("alternate_fire")
	self._alternate_fire_component = unit_data:read_component("alternate_fire")
	self._local_wielded_weapon_template = ""
	self._anim_variable_ids_third_person = {}
	self._anim_variable_ids_first_person = {}
	self._fixed_time_step = Managers.state.game_session.fixed_time_step
end

PlayerUnitAnimationExtension.extensions_ready = function (self, world, unit)
	local first_person_unit = ScriptUnit.extension(unit, "first_person_system"):first_person_unit()

	self._first_person_unit = first_person_unit

	PlayerUnitAnimationState.cache_anim_variable_ids(unit, first_person_unit, self._anim_variable_ids_third_person, self._anim_variable_ids_first_person)
end

PlayerUnitAnimationExtension.anim_event = function (self, event_name)
	local unit = self._unit

	Unit.animation_event(unit, event_name)
	PlayerUnitAnimationState.record_animation_state(self._animation_state_component, unit, self._first_person_unit)
end

PlayerUnitAnimationExtension.anim_event_with_variable_float = function (self, event_name, variable_name, variable_value)
	local unit = self._unit
	local variable_index = Unit.animation_find_variable(unit, variable_name)

	Unit.animation_set_variable(unit, variable_index, variable_value)
	Unit.animation_event(unit, event_name)
	PlayerUnitAnimationState.record_animation_state(self._animation_state_component, unit, self._first_person_unit)
end

PlayerUnitAnimationExtension.anim_event_with_variable_floats = function (self, event_name, ...)
	local unit = self._unit
	local num_params = select("#", ...)

	for ii = 1, num_params, 2 do
		local variable_name, variable_value = select(ii, ...)
		local variable_index = Unit.animation_find_variable(unit, variable_name)

		if variable_value and variable_index then
			Unit.animation_set_variable(unit, variable_index, variable_value)
		end
	end

	Unit.animation_event(unit, event_name)
	PlayerUnitAnimationState.record_animation_state(self._animation_state_component, unit, self._first_person_unit)
end

PlayerUnitAnimationExtension.anim_event_with_variable_int = function (self, event_name, variable_name, variable_value)
	local unit = self._unit
	local variable_index = Unit.animation_find_variable(unit, variable_name)

	Unit.animation_set_variable(unit, variable_index, variable_value)
	Unit.animation_event(unit, event_name)
	PlayerUnitAnimationState.record_animation_state(self._animation_state_component, unit, self._first_person_unit)
end

PlayerUnitAnimationExtension.anim_event_1p = function (self, event_name)
	local fp_unit = self._first_person_unit

	Unit.animation_event(fp_unit, event_name)
	PlayerUnitAnimationState.record_animation_state(self._animation_state_component, self._unit, fp_unit)
end

PlayerUnitAnimationExtension.anim_event_with_variable_float_1p = function (self, event_name, variable_name, variable_value)
	local first_person_unit = self._first_person_unit
	local variable_index = Unit.animation_find_variable(first_person_unit, variable_name)

	Unit.animation_set_variable(first_person_unit, variable_index, variable_value)
	Unit.animation_event(first_person_unit, event_name)
	PlayerUnitAnimationState.record_animation_state(self._animation_state_component, self._unit, first_person_unit)
end

PlayerUnitAnimationExtension.anim_event_with_variable_floats_1p = function (self, event_name, ...)
	local first_person_unit = self._first_person_unit
	local num_params = select("#", ...)

	for ii = 1, num_params, 2 do
		local variable_name, variable_value = select(ii, ...)
		local variable_index = Unit.animation_find_variable(first_person_unit, variable_name)

		if variable_value and variable_index then
			Unit.animation_set_variable(first_person_unit, variable_index, variable_value)
		end
	end

	Unit.animation_event(first_person_unit, event_name)
	PlayerUnitAnimationState.record_animation_state(self._animation_state_component, self._unit, first_person_unit)
end

PlayerUnitAnimationExtension.inventory_slot_wielded = function (self, weapon_template, t)
	local weapon_template_name = weapon_template.name

	self._local_wielded_weapon_template = weapon_template_name

	local unit, first_person_unit, is_local_unit = self._unit, self._first_person_unit, true

	PlayerUnitAnimationState.set_anim_state_machine(unit, first_person_unit, weapon_template, is_local_unit, self._anim_variable_ids_third_person, self._anim_variable_ids_first_person)
	PlayerUnitAnimationState.record_animation_state(self._animation_state_component, unit, first_person_unit)
end

PlayerUnitAnimationExtension.anim_variable_id = function (self, anim_variable)
	return self._anim_variable_ids_third_person[anim_variable]
end

PlayerUnitAnimationExtension.anim_variable_id_1p = function (self, anim_variable)
	return self._anim_variable_ids_first_person[anim_variable]
end

PlayerUnitAnimationExtension.fixed_update = function (self, unit, dt, t, frame)
	PlayerUnitAnimationState.record_animation_state(self._animation_state_component, unit, self._first_person_unit)
end

PlayerUnitAnimationExtension.destroy = function (self)
	return
end

local ALWAYS_ROLLBACK_ACTION_KINDS = {
	reload_shotgun = true,
	reload_state = true,
}

PlayerUnitAnimationExtension.server_correction_occurred = function (self, unit, from_frame, to_frame, simulated_components)
	local first_person_unit = self._first_person_unit
	local weapon_action_component = self._weapon_action_component
	local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)

	if not weapon_template then
		return
	end

	local weapon_template_name = weapon_template.name
	local set_state_machine = false

	if self._local_wielded_weapon_template ~= weapon_template_name then
		self._local_wielded_weapon_template = weapon_template_name

		local is_local_unit = true

		PlayerUnitAnimationState.set_anim_state_machine(unit, first_person_unit, weapon_template, is_local_unit, self._anim_variable_ids_third_person, self._anim_variable_ids_first_person)

		set_state_machine = true
	end

	local mispredict_warrants_animation_rollback = false
	local alternate_fire = self._alternate_fire_component

	if alternate_fire.is_active ~= simulated_components.alternate_fire.is_active then
		mispredict_warrants_animation_rollback = true
	end

	local character_state = self._character_state_component

	if character_state.state_name ~= simulated_components.character_state.state_name or weapon_action_component.current_action_name ~= simulated_components.weapon_action.current_action_name then
		mispredict_warrants_animation_rollback = true
	end

	local _, current_action_settings = Action.current_action(weapon_action_component, weapon_template)

	if current_action_settings and ALWAYS_ROLLBACK_ACTION_KINDS[current_action_settings.kind] then
		mispredict_warrants_animation_rollback = true
	end

	if set_state_machine or mispredict_warrants_animation_rollback then
		local anim_state_component = self._animation_state_component
		local override_3p, override_1p

		if set_state_machine then
			override_3p, override_1p = true, true
		else
			override_3p, override_1p = PlayerUnitAnimationState.should_override_animation_state(anim_state_component, simulated_components.animation_state)
		end

		if override_3p or override_1p then
			local fixed_time_step = self._fixed_time_step
			local start_t = from_frame * fixed_time_step
			local end_t = to_frame * fixed_time_step
			local simulated_time = end_t - start_t

			PlayerUnitAnimationState.override_animation_state(anim_state_component, unit, first_person_unit, simulated_time, override_3p, override_1p)
		end
	end
end

return PlayerUnitAnimationExtension
