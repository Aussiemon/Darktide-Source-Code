-- chunkname: @scripts/managers/input/haptic_trigger.lua

local InputUtils = require("scripts/managers/input/input_utils")
local HapticTriggerSettings = require("scripts/settings/equipment/haptic_trigger_settings")
local HapticTrigger = class("HapticTrigger")
local VIBRATION_STATE = HapticTriggerSettings.vibration_state
local WIELD_STATE = HapticTriggerSettings.wield_state
local EFFECT_MODE = HapticTriggerSettings.effect_mode
local TRIGGER_INDEX = HapticTriggerSettings.trigger_index
local TRIGGER_MASK = HapticTriggerSettings.trigger_mask
local LOW_AMMO_EXTRA_VIBRATION_AMPLITUDE = HapticTriggerSettings.low_ammo_extra_vibration_amplitude
local RESISTANCE_MULTIPLIER = HapticTriggerSettings.resistance_multiplier
local VIBRATION_MULTIPLIER = HapticTriggerSettings.vibration_multiplier
local DEFAULT_RESISTANCE_MULTIPLIER = RESISTANCE_MULTIPLIER.strong
local DEFAULT_VIBRATION_MULTIPLIER = VIBRATION_MULTIPLIER.strong

local function _set_trigger_effect(trigger_index, trigger_mask, effect_mode, params_or_nil)
	local input_device_list = InputUtils.platform_device_list()

	for ii = 1, #input_device_list do
		local device = input_device_list[ii]

		if device.active() then
			device.set_trigger_effect(trigger_index, trigger_mask, effect_mode, params_or_nil)

			break
		end
	end
end

HapticTrigger.init = function (self, trigger_side)
	self._haptics_enabled = nil
	self._ammo_count_percentage = nil
	self._vibration_state = VIBRATION_STATE.off
	self._vibration_frequency = 0
	self._resistance_multiplier = {
		[WIELD_STATE.melee] = DEFAULT_RESISTANCE_MULTIPLIER,
		[WIELD_STATE.ranged] = DEFAULT_RESISTANCE_MULTIPLIER,
	}
	self._vibration_multiplier = {
		[WIELD_STATE.melee] = DEFAULT_VIBRATION_MULTIPLIER,
		[WIELD_STATE.ranged] = DEFAULT_VIBRATION_MULTIPLIER,
	}
	self._trigger_side = trigger_side
	self._trigger_index = trigger_side == "left" and TRIGGER_INDEX.l2 or TRIGGER_INDEX.r2
	self._trigger_mask = trigger_side == "left" and TRIGGER_MASK.l2 or TRIGGER_MASK.r2
end

HapticTrigger.update = function (self, dt, t)
	self:_update_vibration(dt, t)
end

HapticTrigger._update_vibration = function (self, dt, t)
	if self._haptics_suppressed then
		return
	end

	local vibration_state = self._vibration_state

	if vibration_state == VIBRATION_STATE.stopping then
		local stop_vibration_time = self._stop_vibration_time - dt

		if stop_vibration_time <= 0 then
			self:_apply_current_template()

			vibration_state = VIBRATION_STATE.off
		end

		self._stop_vibration_time = stop_vibration_time
	end

	self._vibration_state = vibration_state
end

HapticTrigger.set_ammo_count_percentage = function (self, ammo_percentage)
	self._ammo_count_percentage = ammo_percentage
end

HapticTrigger.trigger_vibration = function (self, frequency)
	if not self._haptics_enabled then
		return
	end

	local haptic_trigger_template = self._haptic_trigger_template

	if not haptic_trigger_template then
		return
	end

	local settings_type = haptic_trigger_template.settings_type
	local haptics_settings = haptic_trigger_template[self._trigger_side]
	local has_settings = not not haptics_settings
	local frequency_to_use = frequency

	if has_settings and (frequency and frequency > 0 or haptics_settings.use_template_vibration_frequency) then
		local vibration_params = haptics_settings.vibration
		local multi_position_vibration_params = haptics_settings.multi_position_vibration
		local scale_vibration_with_ammo = haptics_settings.scale_vibration_with_ammo
		local ammo_modifier = 0
		local ammo_count_percentage = self._ammo_count_percentage

		if ammo_count_percentage and scale_vibration_with_ammo then
			local ammo_modifier_index = math.clamp(math.ceil((-0.7 + (1 - ammo_count_percentage / 100)) * 10), 0, 3)

			if ammo_modifier_index > 0 then
				ammo_modifier = LOW_AMMO_EXTRA_VIBRATION_AMPLITUDE[ammo_modifier_index]
			end
		end

		local use_vibration = self._vibration_multiplier[settings_type] > 0

		if vibration_params and use_vibration then
			local amplitude = math.min(vibration_params.amplitude + ammo_modifier, 8)

			if haptics_settings.use_template_vibration_frequency then
				frequency_to_use = vibration_params.frequency
			end

			self:_set_vibration_effect(settings_type, vibration_params.position, frequency_to_use, amplitude)
		elseif multi_position_vibration_params and use_vibration then
			local amplitude = multi_position_vibration_params.amplitude

			for ii = 1, #amplitude do
				amplitude[ii] = math.min(amplitude[ii] + ammo_modifier, 8)
			end

			if haptics_settings.use_template_vibration_frequency then
				frequency_to_use = multi_position_vibration_params.frequency
			end

			self:_set_multi_position_vibration_effect(settings_type, frequency_to_use, amplitude)
		end
	else
		frequency_to_use = 0
	end

	self._vibration_frequency = frequency_to_use
	self._vibration_state = frequency_to_use > 0 and VIBRATION_STATE.active or VIBRATION_STATE.off
end

HapticTrigger.stop_vibration = function (self)
	if not self._haptics_enabled then
		return
	end

	if self._vibration_state ~= VIBRATION_STATE.active then
		return
	end

	local vibration_frequency = self._vibration_frequency

	if vibration_frequency > 0 then
		self._vibration_state = VIBRATION_STATE.stopping
		self._stop_vibration_time = 1 / vibration_frequency
	end
end

HapticTrigger.set_haptic_trigger_template = function (self, haptic_trigger_template)
	self._haptic_trigger_template = haptic_trigger_template

	self:_apply_current_template()
end

HapticTrigger._apply_current_template = function (self)
	local haptic_trigger_template = self._haptic_trigger_template

	if not haptic_trigger_template then
		self:_set_no_effect()

		return
	end

	if not self._haptics_enabled then
		self:_set_no_effect()

		return
	end

	local haptics_settings = haptic_trigger_template[self._trigger_side]

	if not haptics_settings then
		self:_set_no_effect()

		return
	end

	local settings_type = haptic_trigger_template.settings_type
	local weapon_effect_params = haptics_settings.weapon
	local slope_feedback_params = haptics_settings.slope_feedback
	local multi_position_feedback_params = haptics_settings.multi_position_feedback
	local feedback_params = haptics_settings.feedback

	if weapon_effect_params then
		self:_set_weapon_effect(settings_type, weapon_effect_params)
	elseif slope_feedback_params then
		self:_set_slope_feedback_effect(settings_type, slope_feedback_params)
	elseif multi_position_feedback_params then
		self:_set_multi_position_feedback_effect(settings_type, multi_position_feedback_params)
	elseif feedback_params then
		self:_set_feedback_effect(settings_type, feedback_params)
	else
		self:_set_no_effect()
	end
end

HapticTrigger.unwield = function (self)
	self._ammo_count_percentage = nil

	self:_set_no_effect()
end

HapticTrigger.destroy = function (self)
	self._ammo_count_percentage = nil

	self:_set_no_effect()
end

HapticTrigger.suppress_haptics = function (self, suppressed)
	self._haptics_suppressed = suppressed

	if suppressed then
		self:_set_no_effect()
	else
		self:_apply_current_template()
	end
end

HapticTrigger.disable_haptics = function (self)
	self._haptics_enabled = false

	self:_set_no_effect()
end

HapticTrigger.enable_haptics = function (self)
	self._haptics_enabled = true

	self:_apply_current_template()
end

HapticTrigger.set_haptic_trigger_melee_resistance_strength = function (self, value)
	self._resistance_multiplier[WIELD_STATE.melee] = RESISTANCE_MULTIPLIER[value] or DEFAULT_RESISTANCE_MULTIPLIER
end

HapticTrigger.set_haptic_trigger_ranged_resistance_strength = function (self, value)
	self._resistance_multiplier[WIELD_STATE.ranged] = RESISTANCE_MULTIPLIER[value] or DEFAULT_RESISTANCE_MULTIPLIER
end

HapticTrigger.set_haptic_trigger_melee_vibration_strength = function (self, value)
	self._vibration_multiplier[WIELD_STATE.melee] = VIBRATION_MULTIPLIER[value] or DEFAULT_VIBRATION_MULTIPLIER
end

HapticTrigger.set_haptic_trigger_ranged_vibration_strength = function (self, value)
	self._vibration_multiplier[WIELD_STATE.ranged] = VIBRATION_MULTIPLIER[value] or DEFAULT_VIBRATION_MULTIPLIER
end

HapticTrigger._set_no_effect = function (self)
	_set_trigger_effect(self._trigger_index, self._trigger_mask, EFFECT_MODE.off)
end

local _weapon_params = {}

HapticTrigger._set_weapon_effect = function (self, settings_type, params)
	local resistance_multiplier = self._resistance_multiplier[settings_type] or DEFAULT_RESISTANCE_MULTIPLIER

	_weapon_params[1] = params.start_position
	_weapon_params[2] = params.end_position
	_weapon_params[3] = math.round(params.strength * resistance_multiplier)

	_set_trigger_effect(self._trigger_index, self._trigger_mask, EFFECT_MODE.weapon, _weapon_params)
end

local _feedback_params = {}

HapticTrigger._set_feedback_effect = function (self, settings_type, params)
	local resistance_multiplier = self._resistance_multiplier[settings_type] or DEFAULT_RESISTANCE_MULTIPLIER

	_feedback_params[1] = params.position
	_feedback_params[2] = math.round(params.strength * resistance_multiplier)

	_set_trigger_effect(self._trigger_index, self._trigger_mask, EFFECT_MODE.feedback, _feedback_params)
end

local _multi_position_feedback_params = {}

HapticTrigger._set_multi_position_feedback_effect = function (self, settings_type, params)
	local resistance_multiplier = self._resistance_multiplier[settings_type] or DEFAULT_RESISTANCE_MULTIPLIER

	table.clear(_multi_position_feedback_params)

	local strength = params.strength

	for ii = 1, #strength do
		_multi_position_feedback_params[ii] = math.round(strength[ii] * resistance_multiplier)
	end

	_set_trigger_effect(self._trigger_index, self._trigger_mask, EFFECT_MODE.multi_position_feedback, _multi_position_feedback_params)
end

local _slope_feedback_params = {}

HapticTrigger._set_slope_feedback_effect = function (self, settings_type, params)
	local resistance_multiplier = self._resistance_multiplier[settings_type] or DEFAULT_RESISTANCE_MULTIPLIER

	_slope_feedback_params[1] = params.start_position
	_slope_feedback_params[2] = params.end_position
	_slope_feedback_params[3] = math.round(params.start_strength * resistance_multiplier)
	_slope_feedback_params[4] = math.round(params.end_strength * resistance_multiplier)

	_set_trigger_effect(self._trigger_index, self._trigger_mask, EFFECT_MODE.slope_feedback, _slope_feedback_params)
end

local _vibration_params = {}

HapticTrigger._set_vibration_effect = function (self, settings_type, position, frequency, amplitude)
	local vibration_multiplier = self._vibration_multiplier[settings_type] or DEFAULT_VIBRATION_MULTIPLIER

	_vibration_params[1] = position
	_vibration_params[2] = math.round(amplitude * vibration_multiplier)
	_vibration_params[3] = frequency

	_set_trigger_effect(self._trigger_index, self._trigger_mask, EFFECT_MODE.vibration, _vibration_params)
end

local _multi_position_vibration_params = {
	[2] = {},
}

HapticTrigger._set_multi_position_vibration_effect = function (self, settings_type, frequency, amplitude)
	local vibration_multiplier = self._vibration_multiplier[settings_type] or DEFAULT_VIBRATION_MULTIPLIER

	_multi_position_vibration_params[1] = frequency

	table.clear(_multi_position_vibration_params[2])

	for ii = 1, #amplitude do
		_multi_position_vibration_params[2][ii] = math.round(amplitude[ii] * vibration_multiplier)
	end

	_set_trigger_effect(self._trigger_index, self._trigger_mask, EFFECT_MODE.multi_position_vibration, _multi_position_vibration_params)
end

return HapticTrigger
