local Action = require("scripts/utilities/weapon/action")
local PlayerUnitData = require("scripts/extension_systems/unit_data/utilities/player_unit_data")
local WeaponTemperatureEffects = class("WeaponTemperatureEffects")
local FX_SOURCE_NAME = "_muzzle"
local PARAMETER_NAME = "weapon_temperature"
local LOOPING_SOUND_ALIAS = "weapon_temperature"
local INCREASE_RATE = 0.05
local DECAY_RATE = 0.1
local GRACE_TIME = 1.8
local SHOOTING_ACTIONS = {
	shoot_pellets = true,
	shoot_hit_scan = true,
	shoot_projectile = true,
	flamer_gas = true,
	flamer_gas_burst = true
}

WeaponTemperatureEffects.init = function (self, context, slot, weapon_template, fx_sources)
	self._is_husk = context.is_husk
	self._wwise_world = context.wwise_world
	self._weapon_template = weapon_template
	self._weapon_actions = weapon_template.actions
	self._temperature_fx_settings = weapon_template.temperature_fx
	local owner_unit = context.owner_unit
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	local looping_sound_component_name = PlayerUnitData.looping_sound_component_name(LOOPING_SOUND_ALIAS)
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	self._fx_source_name = fx_sources[FX_SOURCE_NAME]
	self._looping_sound_component = unit_data_extension:read_component(looping_sound_component_name)
	self._shooting_status_component = unit_data_extension:read_component("shooting_status")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._wieldable_slot_component = unit_data_extension:read_component(slot.name)
	self._parameter_value = 0
end

WeaponTemperatureEffects.destroy = function (self)
	if self._looping_sound_component.is_playing then
		self:_stop_looping_sound()
	end
end

WeaponTemperatureEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

WeaponTemperatureEffects.update = function (self, unit, dt, t)
	local shooting_status_component = self._shooting_status_component
	local wieldable_slot_component = self._wieldable_slot_component
	local shooting_end_time = shooting_status_component.shooting_end_time
	local current_ammunition_clip = wieldable_slot_component.current_ammunition_clip
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local parameter_value = self._parameter_value
	local is_shoot_action = action_settings and SHOOTING_ACTIONS[action_settings.kind]
	local within_grace = shooting_end_time < t and t < shooting_end_time + GRACE_TIME

	if is_shoot_action and current_ammunition_clip > 0 then
		parameter_value = math.min(1, parameter_value + dt * INCREASE_RATE)
	elseif not within_grace then
		parameter_value = math.max(0, parameter_value - dt * DECAY_RATE)
	end

	local sfx_playing = self._looping_sound_component.is_playing

	if parameter_value > 0 and not sfx_playing then
		self:_start_looping_sound()
	elseif parameter_value <= 0 and sfx_playing then
		self:_stop_looping_sound()
	end

	self._parameter_value = parameter_value

	self:_update_wwise_source_parameter()
end

WeaponTemperatureEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

WeaponTemperatureEffects.wield = function (self)
	return
end

WeaponTemperatureEffects.unwield = function (self)
	if self._looping_sound_component.is_playing then
		self:_stop_looping_sound()
	end
end

WeaponTemperatureEffects._start_looping_sound = function (self)
	if self._is_husk then
		return
	end

	self._fx_extension:trigger_looping_wwise_event(LOOPING_SOUND_ALIAS, self._fx_source_name)
	self:_update_wwise_source_parameter()
end

WeaponTemperatureEffects._stop_looping_sound = function (self)
	if self._is_husk then
		return
	end

	self._fx_extension:stop_looping_wwise_event(LOOPING_SOUND_ALIAS)
	self:_update_wwise_source_parameter(0)
end

WeaponTemperatureEffects._update_wwise_source_parameter = function (self, override_parameter_value)
	local sound_source = self._fx_extension:sound_source(self._fx_source_name)

	WwiseWorld.set_source_parameter(self._wwise_world, sound_source, PARAMETER_NAME, override_parameter_value or self._parameter_value)
end

return WeaponTemperatureEffects
