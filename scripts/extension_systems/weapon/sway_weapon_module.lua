local Suppression = require("scripts/utilities/attack/suppression")
local WeaponMovementState = require("scripts/extension_systems/weapon/utilities/weapon_movement_state")
local SwayWeaponModule = class("SwayWeaponModule")
local TYPE_INFO = Network.type_info("weapon_sway_offset")
local MIN = TYPE_INFO.min
local MAX = TYPE_INFO.max
local EPSILON = 0.01
local math_clamp = math.clamp

SwayWeaponModule.init = function (self, unit, unit_data_extension, weapon_extension)
	self._movement_state_component = unit_data_extension:read_component("movement_state")
	self._sway_component = unit_data_extension:write_component("sway")
	self._sway_control_component = unit_data_extension:write_component("sway_control")
	self._suppression_component = unit_data_extension:read_component("suppression")
	self._alternate_fire_component = unit_data_extension:read_component("alternate_fire")
	self._shooting_status_component = unit_data_extension:read_component("shooting_status")
	self._weapon_tweak_templates_component = unit_data_extension:write_component("weapon_tweak_templates")
	self._buff_extension = ScriptUnit.extension(unit, "buff_system")
	local unit_data_ext = ScriptUnit.extension(unit, "unit_data_system")
	self._action_module_charge_component = unit_data_ext:read_component("action_module_charge")
	self._sway_component.pitch = 0
	self._sway_component.yaw = 0
	self._sway_component.offset_x = 0
	self._sway_component.offset_y = 0
	self._sway_control_component.immediate_pitch = 0
	self._sway_control_component.immediate_yaw = 0
	self._weapon_tweak_templates_component.sway_template_name = "none"
	self._unit = unit
end

SwayWeaponModule.extensions_ready = function (self, world, unit)
	self._weapon_extension = ScriptUnit.extension(unit, "weapon_system")
end

SwayWeaponModule.fixed_update = function (self, dt, t)
	local sway_control_component = self._sway_control_component
	local weapon_tweak_templates_component = self._weapon_tweak_templates_component
	local sway_template_name = weapon_tweak_templates_component.sway_template_name

	if sway_template_name == "none" then
		return
	end

	local sway_component = self._sway_component
	local shooting_status_component = self._shooting_status_component
	local movement_state_component = self._movement_state_component
	local weapon_movement_state = WeaponMovementState.translate_movement_state_component(movement_state_component)
	local sway_template = self._weapon_extension:sway_template()
	local sway_settings = sway_template[weapon_movement_state]
	local shooting_grace_duration = sway_settings.decay.from_shooting_grace_time or 0
	local shooting = shooting_status_component.shooting or not shooting_status_component.shooting and t <= shooting_status_component.shooting_end_time + shooting_grace_duration
	local sway_settings_decay = sway_settings.decay
	local player_mobility_grace, player_mobility_decay = self:_player_event_decay(sway_settings_decay, t)
	local decay_settings = player_mobility_grace and player_mobility_decay or shooting and sway_settings_decay.shooting or sway_settings_decay.idle
	local min_pitch = sway_settings.continuous_sway.pitch
	local min_yaw = sway_settings.continuous_sway.yaw
	local max_pitch = sway_settings.max_sway.pitch
	local max_yaw = sway_settings.max_sway.yaw
	local pitch = sway_component.pitch
	local yaw = sway_component.yaw
	local pitch_ratio = 1 - pitch / max_pitch
	local yaw_ratio = 1 - yaw / max_yaw
	local stat_buffs = self._buff_extension:stat_buffs()
	local sway_modifier = stat_buffs.sway_modifier or 1
	local pitch_decay_curve = 1 + 2 * pitch_ratio * pitch_ratio
	local yaw_decay_curve = 1 + 2 * yaw_ratio * yaw_ratio
	min_pitch = min_pitch * sway_modifier
	min_yaw = min_yaw * sway_modifier
	pitch_decay_curve = pitch_decay_curve * 1 / sway_modifier
	yaw_decay_curve = yaw_decay_curve * 1 / sway_modifier

	if min_pitch < pitch then
		local decay = decay_settings.pitch
		pitch = math.max(min_pitch, pitch - pitch * dt * decay * pitch_decay_curve)
	elseif EPSILON < min_pitch - pitch then
		pitch = math.min(max_pitch, pitch + pitch * dt * min_pitch * pitch_decay_curve)
	end

	if min_yaw < yaw then
		local decay = decay_settings.yaw
		yaw = math.max(min_yaw, yaw - yaw * dt * decay * yaw_decay_curve)
	elseif EPSILON < min_yaw - yaw then
		yaw = math.min(max_yaw, yaw + yaw * dt * min_yaw * yaw_decay_curve)
	end

	pitch = pitch + sway_control_component.immediate_pitch
	yaw = yaw + sway_control_component.immediate_yaw
	sway_control_component.immediate_pitch = 0
	sway_control_component.immediate_yaw = 0
	pitch = math.clamp(pitch, 0, max_pitch)
	yaw = math.clamp(yaw, 0, max_yaw)
	sway_component.pitch = pitch
	sway_component.yaw = yaw

	self:_calculate_sway_offsets(dt, t)
end

SwayWeaponModule._player_event_decay = function (self, decay, t)
	local alternate_fire_component = self._alternate_fire_component
	local enter_alternate_fire_grace_time = decay.enter_alternate_fire_grace_time or 0
	local enter_alternate_fire_grace = t <= alternate_fire_component.start_t + enter_alternate_fire_grace_time
	local crouch_transition_grace_time = decay.crouch_transition_grace_time or 0
	local crouch_transition_grace = t <= self._movement_state_component.is_crouching_transition_start_t + crouch_transition_grace_time
	local is_in_player_event = enter_alternate_fire_grace or crouch_transition_grace
	local decay_settings = nil

	if is_in_player_event then
		decay_settings = decay.player_event or decay.idle
	end

	return is_in_player_event, decay_settings
end

SwayWeaponModule._calculate_sway_offsets = function (self, dt, t)
	local movement_state_component = self._movement_state_component
	local sway_component = self._sway_component
	local weapon_tweak_templates_component = self._weapon_tweak_templates_component
	local sway_template_name = weapon_tweak_templates_component.sway_template_name

	if sway_template_name == "none" then
		return
	end

	local weapon_movement_state = WeaponMovementState.translate_movement_state_component(movement_state_component)
	local sway_template = self._weapon_extension:sway_template()
	local sway_settings = sway_template[weapon_movement_state]
	local sway_pattern = sway_settings.sway_pattern
	local suppression_component = self._suppression_component
	local pitch = sway_component.pitch
	local yaw = sway_component.yaw
	pitch, yaw = Suppression.apply_suppression_offsets_to_sway(suppression_component, pitch, yaw)
	local offset_x, offset_y = sway_pattern(dt, t, sway_settings, yaw, pitch)

	if self._action_module_charge_component then
		local charge_level = self._action_module_charge_component.charge_level

		if sway_template.charge_scale then
			local charge_max_pitch = sway_template.charge_scale.max_pitch
			local charge_max_yaw = sway_template.charge_scale.max_yaw
			local pitch_charge_offset = math.lerp(1, charge_max_pitch, math.sqrt(charge_level))
			local yaw_charge_offset = math.lerp(1, charge_max_yaw, math.sqrt(charge_level))
			offset_x = offset_x * pitch_charge_offset
			offset_y = offset_y * yaw_charge_offset
		end
	end

	offset_x = math_clamp(offset_x, MIN, MAX)
	offset_y = math_clamp(offset_y, MIN, MAX)
	sway_component.offset_x = offset_x
	sway_component.offset_y = offset_y
end

return SwayWeaponModule
