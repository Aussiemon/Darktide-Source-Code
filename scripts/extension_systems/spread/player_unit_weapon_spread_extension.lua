local Suppression = require("scripts/utilities/attack/suppression")
local WeaponMovementState = require("scripts/extension_systems/weapon/utilities/weapon_movement_state")
local PlayerUnitWeaponSpreadExtension = class("PlayerUnitWeaponSpreadExtension")
local DEFAULT_MIN_RATIO = 0.25
local DEFAULT_RANDOM_RATIO = 0.75
local DEFAULT_FIRST_SHOT_MIN_RATIO = 0.25
local DEFAULT_FIRST_SHOT_RANDOM_RATIO = 0.4
local DEFAULT_MAX_YAW_DELTA = 2
local DEFAULT_MAX_PITCH_DELTA = 3
local _spread_settings, _rotation_from_offset = nil

PlayerUnitWeaponSpreadExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	local world = extension_init_context.world
	local initial_seed = extension_init_data.spread_seed
	self._unit = unit
	self._world = world
	self._spread_template = nil

	self:_init_components(unit, initial_seed)
end

PlayerUnitWeaponSpreadExtension._init_components = function (self, unit, initial_seed)
	local unit_data_ext = ScriptUnit.extension(unit, "unit_data_system")
	self._movement_state_component = unit_data_ext:read_component("movement_state")
	self._locomotion_component = unit_data_ext:read_component("locomotion")
	self._spread_component = unit_data_ext:write_component("spread")
	self._spread_control_component = unit_data_ext:write_component("spread_control")
	self._suppression_component = unit_data_ext:read_component("suppression")
	self._weapon_tweak_templates_component = unit_data_ext:write_component("weapon_tweak_templates")
	self._action_module_charge_component = unit_data_ext:read_component("action_module_charge")
	self._alternate_fire_component = unit_data_ext:read_component("alternate_fire")
	self._shooting_status_component = unit_data_ext:read_component("shooting_status")
	self._buff_extension = ScriptUnit.extension(unit, "buff_system")
	self._weapon_extension = ScriptUnit.extension(unit, "weapon_system")
	self._spread_component.pitch = 0
	self._spread_component.yaw = 0
	self._spread_control_component.seed = initial_seed
	self._spread_control_component.immediate_pitch = 0
	self._spread_control_component.immediate_yaw = 0
	self._spread_control_component.previous_yaw_offset = 0
	self._spread_control_component.previous_pitch_offset = 0
	self._weapon_tweak_templates_component.spread_template_name = "none"
end

PlayerUnitWeaponSpreadExtension.fixed_update = function (self, unit, dt, t)
	local spread_settings = _spread_settings(self._weapon_extension, self._movement_state_component)

	if not spread_settings then
		return
	end

	self:_update_spread(dt, t, spread_settings)
end

PlayerUnitWeaponSpreadExtension._update_spread = function (self, dt, t, spread_settings)
	local spread_component = self._spread_component
	local spread_control_component = self._spread_control_component
	local shooting_status_component = self._shooting_status_component
	local pitch = spread_component.pitch
	local yaw = spread_component.yaw
	local shooting_grace_duration = spread_settings.decay.from_shooting_grace_time or 0
	local shooting = shooting_status_component.shooting or not shooting_status_component.shooting and t <= shooting_status_component.shooting_end_time + shooting_grace_duration
	local spread_settings_decay = spread_settings.decay
	local player_event_grace, player_event_decay = self:_player_event_decay(spread_settings_decay, t)
	local decay_settings = player_event_grace and player_event_decay or shooting and spread_settings.decay.shooting or spread_settings.decay.idle
	local min_pitch = spread_settings.continuous_spread.min_pitch
	local min_yaw = spread_settings.continuous_spread.min_yaw
	local start_pitch = min_pitch
	local start_yaw = min_yaw

	if spread_settings.start_spread then
		start_pitch = spread_settings.start_spread.start_pitch
		start_yaw = spread_settings.start_spread.start_yaw
	end

	if self._action_module_charge_component then
		local charge_level = self._action_module_charge_component.charge_level
		local spread_template = self._weapon_extension:spread_template()

		if spread_template.charge_scale then
			local charge_max_pitch = spread_template.charge_scale.max_pitch
			local charge_max_yaw = spread_template.charge_scale.max_yaw
			local pitch_charge_offset = math.lerp(1, charge_max_pitch, math.sqrt(charge_level))
			local yaw_charge_offset = math.lerp(1, charge_max_yaw, math.sqrt(charge_level))
			min_pitch = min_pitch * pitch_charge_offset
			min_yaw = min_yaw * yaw_charge_offset
			start_pitch = min_pitch
			start_yaw = min_yaw

			if charge_level ~= 0 then
				decay_settings = spread_settings.decay.charging or decay_settings
			end
		end
	end

	local max_pitch = spread_settings.max_spread.pitch
	local max_yaw = spread_settings.max_spread.yaw
	local pitch_ratio = 1 - pitch / max_pitch
	local yaw_ratio = 1 - yaw / max_yaw
	local pitch_decay_curve = 0.3 + 2 * pitch_ratio * pitch_ratio
	local yaw_decay_curve = 0.3 + 2 * yaw_ratio * yaw_ratio

	if pitch ~= start_pitch then
		local decay = decay_settings.pitch

		if decay ~= 0 then
			pitch = pitch - pitch * dt * decay * pitch_decay_curve
			pitch = math.max(start_pitch, pitch)
		end
	end

	if yaw ~= start_yaw then
		local decay = decay_settings.yaw

		if decay ~= 0 then
			yaw = yaw - yaw * dt * decay * yaw_decay_curve
			yaw = math.max(start_yaw, yaw)
		end
	end

	pitch = pitch + spread_control_component.immediate_pitch
	yaw = yaw + spread_control_component.immediate_yaw
	spread_control_component.immediate_pitch = 0
	spread_control_component.immediate_yaw = 0
	pitch = math.clamp(pitch, min_pitch, max_pitch)
	yaw = math.clamp(yaw, min_yaw, max_yaw)
	spread_component.pitch = pitch
	spread_component.yaw = yaw
end

PlayerUnitWeaponSpreadExtension._player_event_decay = function (self, decay, t)
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

PlayerUnitWeaponSpreadExtension._max_pitch_rotation = function (self, roll_rotation, pitch, yaw)
	local x = yaw * math.cos(roll_rotation)
	local y = pitch * math.sin(roll_rotation)
	local length = Vector3.length(Vector3(x, y, 0))

	if length == 0 then
		return 0
	end

	local max_pitch_rotation = pitch * yaw / length

	return math.degrees_to_radians(max_pitch_rotation)
end

PlayerUnitWeaponSpreadExtension._combine_spread_rotations = function (self, roll, pitch, current_rotation)
	local roll_rotation = Quaternion(Vector3.forward(), roll)
	local pitch_rotation = Quaternion(Vector3.right(), pitch)
	local combined_rotation = Quaternion.multiply(current_rotation, roll_rotation)
	combined_rotation = Quaternion.multiply(combined_rotation, pitch_rotation)

	return combined_rotation
end

local PI_2 = math.pi * 2
local EMPTY_TABLE = {}

PlayerUnitWeaponSpreadExtension.randomized_spread = function (self, current_rotation, optional_skip_update_component_data)
	local spread_control_component = self._spread_control_component
	local shooting_status_component = self._shooting_status_component
	local movement_state_component = self._movement_state_component
	local suppression_component = self._suppression_component
	local weapon_extension = self._weapon_extension
	local spread_settings = _spread_settings(weapon_extension, movement_state_component)

	if not spread_settings then
		return current_rotation
	end

	local randomized_spread = spread_settings.randomized_spread or EMPTY_TABLE
	local random_value = nil
	local seed = spread_control_component.seed
	local previous_yaw_offset = spread_control_component.previous_yaw_offset
	local previous_pitch_offset = spread_control_component.previous_pitch_offset
	local stat_buffs = self._buff_extension:stat_buffs()
	local spread_modifier = stat_buffs.spread_modifier or 1
	local spread_component = self._spread_component
	local current_pitch = spread_component.pitch * spread_modifier
	local current_yaw = spread_component.yaw * spread_modifier
	current_pitch, current_yaw = Suppression.apply_suppression_offsets_to_spread(suppression_component, current_pitch, current_yaw)
	local min_spread_ratio = randomized_spread.min_ratio or DEFAULT_MIN_RATIO
	local random_spread_ratio = randomized_spread.random_ratio or DEFAULT_RANDOM_RATIO
	local first_shot = shooting_status_component.num_shots == 0

	if first_shot then
		min_spread_ratio = randomized_spread.first_shot_min_ratio or DEFAULT_FIRST_SHOT_MIN_RATIO
		random_spread_ratio = randomized_spread.first_shot_random_ratio or DEFAULT_FIRST_SHOT_RANDOM_RATIO
	end

	seed, random_value = math.next_random(seed)
	local multiplier = min_spread_ratio + random_spread_ratio * random_value
	seed, random_value = math.next_random(seed)
	local random_roll_rotation = random_value * PI_2
	local yaw_offset = math.sin(random_roll_rotation) * current_yaw * multiplier
	local pitch_offset = math.cos(random_roll_rotation) * current_pitch * multiplier

	if first_shot then
		previous_yaw_offset = yaw_offset
		previous_pitch_offset = pitch_offset
	end

	local yaw_rotation, lerped_yaw_offset = _rotation_from_offset(yaw_offset, previous_yaw_offset, randomized_spread.max_yaw_delta or DEFAULT_MAX_YAW_DELTA, Vector3.up())
	local pitch_rotation, lerped_pitch_offset = _rotation_from_offset(pitch_offset, previous_pitch_offset, randomized_spread.max_pitch_delta or DEFAULT_MAX_PITCH_DELTA, Vector3.right())
	local final_rotation = Quaternion.multiply(current_rotation, pitch_rotation)
	final_rotation = Quaternion.multiply(final_rotation, yaw_rotation)

	if not optional_skip_update_component_data then
		spread_control_component.seed = seed
		spread_control_component.previous_yaw_offset = lerped_yaw_offset
		spread_control_component.previous_pitch_offset = lerped_pitch_offset
	end

	return final_rotation
end

PlayerUnitWeaponSpreadExtension.target_style_spread = function (self, current_rotation, num_shots_fired, num_shots_in_attack, num_spread_circles, bullseye, spread_pitch, spread_yaw, scatter_range, no_random, roll_offset)
	if bullseye and num_shots_fired == 1 then
		return current_rotation
	end

	local seed = self._spread_control_component.seed
	local random_value = nil
	local current_shot = bullseye and num_shots_fired - 1 or num_shots_fired
	local max_shots = bullseye and num_shots_in_attack - 1 or num_shots_in_attack
	local shot_roll_current_angle = num_spread_circles * current_shot / max_shots
	local shot_roll_spread_modifier = num_spread_circles / max_shots
	seed, random_value = math.next_random(seed)
	local random_roll = nil

	if scatter_range then
		random_roll = 1 - scatter_range + scatter_range * random_value * 2
	elseif no_random then
		random_roll = 1
	else
		random_roll = 0.9 + 0.2 * random_value
	end

	local roll = (roll_offset or 0) + random_roll * shot_roll_spread_modifier * 2 + shot_roll_current_angle - shot_roll_spread_modifier
	local rolled_rotation = roll * PI_2
	local max_pitch_rotation = self:_max_pitch_rotation(rolled_rotation, spread_pitch, spread_yaw)
	local shots_per_layer = max_shots / num_spread_circles
	local current_layer_of_shot = math.ceil(current_shot / shots_per_layer)
	seed, random_value = math.next_random(seed)
	local random_pitch_scale = math.sqrt(0.25 + 0.5 * random_value)

	if no_random then
		random_pitch_scale = 1
	end

	local pitch_rotation = random_pitch_scale * max_pitch_rotation * current_layer_of_shot / num_spread_circles
	local final_rotation = self:_combine_spread_rotations(rolled_rotation, pitch_rotation, current_rotation)
	self._spread_control_component.seed = seed

	return final_rotation
end

function _spread_settings(weapon_extension, movement_state_component)
	local spread_template = weapon_extension:spread_template()

	if not spread_template then
		return nil
	end

	local weapon_movement_state = WeaponMovementState.translate_movement_state_component(movement_state_component)
	local spread_settings = spread_template[weapon_movement_state]

	return spread_settings
end

function _rotation_from_offset(offset, previous_offset, max_delta, around_vector)
	local diff = math.abs(previous_offset - offset)
	local lerp_ratio = diff == 0 and 1 or math.min(max_delta, 1)
	local lerped_offset = math.lerp(previous_offset, offset, lerp_ratio)
	local rotation = Quaternion(around_vector, math.degrees_to_radians(lerped_offset))

	return rotation, lerped_offset
end

return PlayerUnitWeaponSpreadExtension
