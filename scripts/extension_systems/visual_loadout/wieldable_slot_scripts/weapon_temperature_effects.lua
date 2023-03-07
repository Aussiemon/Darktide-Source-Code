local Action = require("scripts/utilities/weapon/action")
local PlayerUnitData = require("scripts/extension_systems/unit_data/utilities/player_unit_data")
local WeaponTemperatureEffects = class("WeaponTemperatureEffects")
local FX_SOURCE_NAME = "_muzzle"
local PARAMETER_NAME = "weapon_temperature"
local LOOPING_SOUND_ALIAS = "weapon_temperature"
local INCREASE_RATE = 0.05
local DECAY_RATE = 0.1
local GRACE_TIME = 1.8
local BARREL_THRESHOLD = 0
local CHARGE_INCREASE_RATE = 0.05
local SHOOTING_ACTIONS = {
	shoot_pellets = true,
	shoot_hit_scan = true,
	shoot_projectile = true,
	flamer_gas = true,
	flamer_gas_burst = true
}
local CHARGE_ACTIONS = {
	charge_ammo = true,
	chain_lightning = true,
	charge = true,
	overload_charge_target_finder = true,
	overload_charge_position_finder = true,
	overload_charge = true,
	charge_aim = true
}

WeaponTemperatureEffects.init = function (self, context, slot, weapon_template, fx_sources)
	self._is_husk = context.is_husk
	self._wwise_world = context.wwise_world
	self._weapon_template = weapon_template
	self._weapon_actions = weapon_template.actions
	self._temperature_fx_settings = weapon_template.temperature_fx
	self._slot = slot
	self._equipment_component = context.equipment_component
	local owner_unit = context.owner_unit
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	local looping_sound_component_name = PlayerUnitData.looping_sound_component_name(LOOPING_SOUND_ALIAS)
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	self._fx_source_name = fx_sources[FX_SOURCE_NAME]
	self._looping_sound_component = unit_data_extension:read_component(looping_sound_component_name)
	self._shooting_status_component = unit_data_extension:read_component("shooting_status")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._wieldable_slot_component = unit_data_extension:read_component(slot.name)
	self._action_module_charge_component = unit_data_extension:read_component("action_module_charge")
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
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local parameter_value = self:_update_temperature_parameter(action_settings, dt, t)
	local sfx_playing = self._looping_sound_component.is_playing

	if parameter_value > 0 and not sfx_playing then
		self:_start_looping_sound()
	elseif parameter_value <= 0 and sfx_playing then
		self:_stop_looping_sound()
	end

	self:_update_wwise_source_parameter(parameter_value)
end

WeaponTemperatureEffects._update_temperature_parameter = function (self, action_settings, dt, t)
	local parameter_value = self._parameter_value or 0
	local shooting_status_component = self._shooting_status_component
	local wieldable_slot_component = self._wieldable_slot_component
	local action_module_charge_component = self._action_module_charge_component
	local shooting_end_time = shooting_status_component.shooting_end_time
	local current_ammunition_clip = wieldable_slot_component.current_ammunition_clip
	local charge_level = action_module_charge_component.charge_level
	local increase_rate = INCREASE_RATE
	local decay_rate = DECAY_RATE
	local charge_increase_rate = CHARGE_INCREASE_RATE
	local grace_time = GRACE_TIME
	local use_charge = false
	local weapon_template = self._weapon_template
	local weapon_temperature_settings = weapon_template.weapon_temperature_settings

	if weapon_temperature_settings then
		increase_rate = weapon_temperature_settings.increase_rate or INCREASE_RATE
		decay_rate = weapon_temperature_settings.decay_rate or DECAY_RATE
		charge_increase_rate = weapon_temperature_settings.charge_increase_rate or CHARGE_INCREASE_RATE
		grace_time = weapon_temperature_settings.grace_time or GRACE_TIME
		use_charge = weapon_temperature_settings.use_charge or false
	end

	local is_shoot_action = action_settings and SHOOTING_ACTIONS[action_settings.kind]
	local is_charge_action = action_settings and CHARGE_ACTIONS[action_settings.kind]
	local within_grace = shooting_end_time < t and t < shooting_end_time + grace_time

	if use_charge and is_charge_action then
		local charge_value = charge_level * charge_increase_rate * dt
		parameter_value = math.clamp01(parameter_value + charge_value)
	elseif is_shoot_action and current_ammunition_clip > 0 then
		parameter_value = math.min(1, parameter_value + dt * increase_rate)
	elseif not within_grace then
		parameter_value = math.max(0, parameter_value - dt * decay_rate)
	end

	self._parameter_value = parameter_value

	return parameter_value
end

WeaponTemperatureEffects._update_charge_temperature = function (self, parameter_value, action_settings, dt, t)
	return
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

	self._parameter_value = 0

	self._equipment_component.send_component_event(self._slot, "set_barrel_overheat", 0)
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

WeaponTemperatureEffects._update_wwise_source_parameter = function (self, parameter_value)
	local sound_source = self._fx_extension:sound_source(self._fx_source_name)

	WwiseWorld.set_source_parameter(self._wwise_world, sound_source, PARAMETER_NAME, parameter_value)
end

return WeaponTemperatureEffects
