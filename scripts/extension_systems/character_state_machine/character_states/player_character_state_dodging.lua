require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local BuffSettings = require("scripts/settings/buff/buff_settings")
local Crouch = require("scripts/extension_systems/character_state_machine/character_states/utilities/crouch")
local DisruptiveStateTransition = require("scripts/extension_systems/character_state_machine/character_states/utilities/disruptive_state_transition")
local Dodge = require("scripts/extension_systems/character_state_machine/character_states/utilities/dodge")
local HealthStateTransitions = require("scripts/extension_systems/character_state_machine/character_states/utilities/health_state_transitions")
local Stamina = require("scripts/utilities/attack/stamina")
local proc_events = BuffSettings.proc_events
local PlayerCharacterStateDodging = class("PlayerCharacterStateDodging", "PlayerCharacterStateBase")

PlayerCharacterStateDodging.init = function (self, character_state_init_context, ...)
	PlayerCharacterStateDodging.super.init(self, character_state_init_context, ...)

	local unit_data_extension = character_state_init_context.unit_data
	local dodge_character_state_component = unit_data_extension:write_component("dodge_character_state")
	dodge_character_state_component.cooldown = 0
	dodge_character_state_component.consecutive_dodges = 0
	dodge_character_state_component.consecutive_dodges_cooldown = 0
	dodge_character_state_component.distance_left = 0
	dodge_character_state_component.dodge_direction = Vector3.zero()
	dodge_character_state_component.jump_override_time = 0
	dodge_character_state_component.dodge_time = 0
	dodge_character_state_component.started_from_crouch = false
	self._dodge_character_state_component = dodge_character_state_component
	self._sway_control_component = unit_data_extension:write_component("sway_control")
	self._spread_control_component = unit_data_extension:write_component("spread_control")
end

PlayerCharacterStateDodging._on_enter_animation = function (self, unit, dodge_direction, estimated_dodge_time, animation_extension)
	local x_value = Vector3.x(dodge_direction)
	local y_value = Vector3.y(dodge_direction)
	local dodge_animation = nil

	if math.abs(x_value) < math.abs(y_value) then
		dodge_animation = "dodge_bwd"
	elseif x_value > 0 then
		dodge_animation = "dodge_right"
	else
		dodge_animation = "dodge_left"
	end

	estimated_dodge_time = math.clamp(estimated_dodge_time, 0, 1)

	animation_extension:anim_event_with_variable_float(dodge_animation, "dodge_time", estimated_dodge_time)
	animation_extension:anim_event_1p(dodge_animation)
end

local function _calculate_dodge_diminishing_return(dodge_character_state_component, weapon_dodge_template, buff_extension)
	local stat_buffs = buff_extension:stat_buffs()
	local extra_consecutive_dodges = math.round(stat_buffs.extra_consecutive_dodges or 0)
	local dr_start = (weapon_dodge_template and weapon_dodge_template.diminishing_return_start or 2) + extra_consecutive_dodges
	local dr_limit = dr_start + (weapon_dodge_template and weapon_dodge_template.diminishing_return_limit or 1)
	local consecutive_dodges = math.min(dodge_character_state_component.consecutive_dodges, dr_limit + dr_start)
	local dr_distance_modifier = weapon_dodge_template and weapon_dodge_template.diminishing_return_distance_modifier or 1
	local base = 1 - dr_distance_modifier
	local diminishing_return = base + dr_distance_modifier * (1 - math.clamp(consecutive_dodges - dr_start, 0, dr_limit) / dr_limit)

	return diminishing_return
end

local function _find_speed_settings_index(time_in_dodge, start_index, dodge_speed_at_times, distance_scale)
	local speed_settings_index = #dodge_speed_at_times

	for index = start_index, #dodge_speed_at_times do
		if dodge_speed_at_times[index].time_in_dodge >= time_in_dodge / distance_scale then
			speed_settings_index = index - 1

			break
		end
	end

	return speed_settings_index
end

local function _find_current_dodge_speed(time_in_dodge, speed_settings_index, dodge_speed_at_times, speed_modifier, diminishing_return_factor, distance_scale)
	local speed = nil
	local num_dodge_speed_at_times = #dodge_speed_at_times
	local total_modifier = speed_modifier * diminishing_return_factor
	local next_speed_setting_index = speed_settings_index + 1

	if num_dodge_speed_at_times >= next_speed_setting_index then
		local current_speed_settings = dodge_speed_at_times[speed_settings_index]
		local next_speed_settings = dodge_speed_at_times[next_speed_setting_index]
		local current_time_in_setting = current_speed_settings.time_in_dodge
		local next_time_in_setting = next_speed_settings.time_in_dodge
		local current_setting_speed = current_speed_settings.speed

		if current_setting_speed > 4 then
			current_setting_speed = current_setting_speed * distance_scale
		end

		local next_setting_speed = next_speed_settings.speed

		if next_setting_speed > 4 then
			next_setting_speed = next_setting_speed * distance_scale
		end

		local time_between_settings = next_time_in_setting - current_time_in_setting
		local time_in_setting = time_in_dodge / distance_scale - current_time_in_setting
		local percentage_in_between = time_in_setting / time_between_settings
		speed = math.lerp(current_setting_speed, next_setting_speed, percentage_in_between) * total_modifier
	else
		local current_speed_settings = dodge_speed_at_times[speed_settings_index]
		local current_setting_speed = current_speed_settings.speed
		speed = current_setting_speed * total_modifier
	end

	return speed
end

local function _calculate_dodge_total_time(specialization_dodge_template, diminishing_return_factor, weapon_dodge_template, buff_extension)
	local time_step = GameParameters.fixed_time_step
	local hit_end = false
	local time_in_dodge = 0
	local distance_travelled = 0
	local stat_buffs = buff_extension:stat_buffs()
	local weapon_speed_modifier = weapon_dodge_template and weapon_dodge_template.speed_modifier or 1
	local buff_speed_modifier = stat_buffs.dodge_speed_multiplier
	local speed_modifier = weapon_speed_modifier * buff_speed_modifier
	local distance_scale = (weapon_dodge_template and weapon_dodge_template.distance_scale or 1) * diminishing_return_factor
	local base_distance = weapon_dodge_template and weapon_dodge_template.base_distance or specialization_dodge_template.base_distance
	local dodge_distance = base_distance * distance_scale

	if dodge_distance <= 0 then
		return 0
	end

	local dodge_speed_at_times = weapon_dodge_template and weapon_dodge_template.dodge_speed_at_times or specialization_dodge_template.dodge_speed_at_times

	while not hit_end do
		time_in_dodge = time_in_dodge + time_step
		local start_point = 1
		local current_speed_setting_index = _find_speed_settings_index(time_in_dodge, start_point, dodge_speed_at_times, distance_scale)
		local speed = _find_current_dodge_speed(time_in_dodge, current_speed_setting_index, dodge_speed_at_times, speed_modifier, diminishing_return_factor, distance_scale)
		distance_travelled = distance_travelled + speed * time_step

		if dodge_distance < distance_travelled then
			hit_end = true
		end
	end

	return time_in_dodge * 10
end

local tg_on_dodge_data = {}
local TRAINING_GROUNDS_GAME_MODE_NAME = "training_grounds"

PlayerCharacterStateDodging.on_enter = function (self, unit, dt, t, previous_state, params)
	local specialization_dodge_template = self._specialization_dodge_template
	local dodge_character_state_component = self._dodge_character_state_component
	local weapon_dodge_template = self._weapon_extension:dodge_template()
	local dodge_direction = params.dodge_direction
	dodge_character_state_component.dodge_direction = dodge_direction
	params.dodge_direction = nil
	local buff_extension = self._buff_extension

	if dodge_character_state_component.consecutive_dodges_cooldown < t then
		dodge_character_state_component.consecutive_dodges = 1
	else
		dodge_character_state_component.consecutive_dodges = math.min(dodge_character_state_component.consecutive_dodges + 1, NetworkConstants.max_consecutive_dodges)
	end

	local diminishing_return_factor = _calculate_dodge_diminishing_return(dodge_character_state_component, weapon_dodge_template, self._buff_extension)
	local base_distance = weapon_dodge_template and weapon_dodge_template.base_distance or specialization_dodge_template.base_distance
	dodge_character_state_component.distance_left = base_distance * (weapon_dodge_template and weapon_dodge_template.distance_scale or 1) * diminishing_return_factor
	dodge_character_state_component.jump_override_time = t + specialization_dodge_template.dodge_jump_override_timer
	local movement_state = self._movement_state_component
	dodge_character_state_component.started_from_crouch = movement_state.is_crouching
	local estimated_dodge_time = _calculate_dodge_total_time(specialization_dodge_template, diminishing_return_factor, weapon_dodge_template, self._buff_extension)

	self:_on_enter_animation(unit, dodge_direction, estimated_dodge_time, self._animation_extension)

	self._locomotion_steering_component.disable_velocity_rotation = true
	movement_state.method = "dodging"
	movement_state.is_dodging = true
	local game_mode_name = Managers.state.game_mode:game_mode_name()

	if game_mode_name == TRAINING_GROUNDS_GAME_MODE_NAME then
		table.clear(tg_on_dodge_data)

		tg_on_dodge_data.unit = unit
		tg_on_dodge_data.direction = dodge_direction

		Managers.event:trigger("tg_on_dodge_enter", tg_on_dodge_data)
	end

	Stamina.drain(unit, 0, t)

	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		buff_extension:add_proc_event(proc_events.on_dodge_start, param_table)
	end
end

PlayerCharacterStateDodging.on_exit = function (self, unit, t, next_state)
	local dodge_character_state_component = self._dodge_character_state_component
	local weapon_dodge_template = self._weapon_extension:dodge_template()
	local specialization_dodge_template = self._specialization_dodge_template
	local buff_extension = self._buff_extension
	local time_in_dodge = t - self._character_state_component.entered_t
	local cd = math.max(specialization_dodge_template.dodge_cooldown, specialization_dodge_template.dodge_jump_override_timer - time_in_dodge)
	dodge_character_state_component.cooldown = t + cd
	local weapon_consecutive_dodges_reset = weapon_dodge_template and weapon_dodge_template.consecutive_dodges_reset or 0
	dodge_character_state_component.consecutive_dodges_cooldown = t + specialization_dodge_template.consecutive_dodges_reset + weapon_consecutive_dodges_reset
	dodge_character_state_component.dodge_time = t
	self._movement_state_component.is_dodging = false
	self._locomotion_steering_component.disable_velocity_rotation = false
	local animation_extension = self._animation_extension
	local dodge_animation = "dodge_end"

	animation_extension:anim_event(dodge_animation)
	animation_extension:anim_event_1p(dodge_animation)

	if next_state == "sliding" and _calculate_dodge_diminishing_return(dodge_character_state_component, weapon_dodge_template, self._buff_extension) == 1 then
		dodge_character_state_component.consecutive_dodges = math.min(dodge_character_state_component.consecutive_dodges + 1, NetworkConstants.max_consecutive_dodges)
	end

	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		buff_extension:add_proc_event(proc_events.on_dodge_end, param_table)
	end
end

PlayerCharacterStateDodging.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	local time_in_dodge = t - self._character_state_component.entered_t
	local weapon_extension = self._weapon_extension

	weapon_extension:update_weapon_actions(fixed_frame)
	self._ability_extension:update_ability_actions(fixed_frame)

	local input_ext = self._input_extension
	local is_crouching = Crouch.check(unit, self._first_person_extension, self._animation_extension, weapon_extension, self._movement_state_component, self._sway_control_component, self._sway_component, self._spread_control_component, input_ext, t)
	local started_from_crouch = self._dodge_character_state_component.started_from_crouch
	local has_slide_input = not started_from_crouch and time_in_dodge > 0.2 and is_crouching
	local still_dodging, wants_slide = self:_update_dodge(unit, dt, time_in_dodge, has_slide_input)

	return self:_check_transition(unit, t, input_ext, next_state_params, still_dodging, wants_slide)
end

PlayerCharacterStateDodging._check_transition = function (self, unit, t, input_extension, next_state_params, still_dodging, wants_slide)
	local unit_data_extension = self._unit_data_extension
	local health_transition = HealthStateTransitions.poll(unit_data_extension, next_state_params)

	if health_transition then
		return health_transition
	end

	local is_colliding_on_hang_ledge, hang_ledge_unit = self:_should_hang_on_ledge(unit, t)

	if is_colliding_on_hang_ledge then
		next_state_params.hang_ledge_unit = hang_ledge_unit

		return "ledge_hanging"
	end

	local disruptive_transition = DisruptiveStateTransition.poll(unit, unit_data_extension, next_state_params)

	if disruptive_transition then
		return disruptive_transition
	end

	local dodge_character_state_component = self._dodge_character_state_component
	local movement_state = self._movement_state_component

	if input_extension:get("jump") and t < dodge_character_state_component.jump_override_time and movement_state.can_jump then
		next_state_params.post_dodge_jump = true

		return "jumping"
	end

	local inair_state = self._inair_state_component

	if not inair_state.on_ground then
		return "falling"
	end

	local is_sticky = self._action_sweep_component.is_sticky
	local should_cancel = is_sticky

	if should_cancel then
		return "walking"
	end

	if wants_slide then
		return "sliding"
	end

	if not still_dodging then
		return "walking"
	end
end

PlayerCharacterStateDodging._update_dodge = function (self, unit, dt, time_in_dodge, has_slide_input)
	local specialization_dodge_template = self._specialization_dodge_template
	local dodge_character_state_component = self._dodge_character_state_component
	local weapon_dodge_template = self._weapon_extension:dodge_template()
	local locomotion_steering_component = self._locomotion_steering_component
	local prev_wanted_velocity = locomotion_steering_component.velocity_wanted
	local velocity_current = self._locomotion_component.velocity_current
	local prev_velocity_wanted_flat = Vector3.flat(prev_wanted_velocity)
	local velocity_current_flat = Vector3.flat(velocity_current)
	local prev_length_sq = Vector3.length_squared(prev_velocity_wanted_flat)
	local current_length_sq = Vector3.length_squared(velocity_current_flat)
	local amount_progressed_from_wanted = current_length_sq / prev_length_sq

	if amount_progressed_from_wanted < specialization_dodge_template.stop_threshold then
		return false
	end

	if dodge_character_state_component.distance_left <= 0 then
		return false
	end

	local speed_at_times = weapon_dodge_template and weapon_dodge_template.dodge_speed_at_times or specialization_dodge_template.dodge_speed_at_times
	local start_point = 1
	local diminishing_return_factor = _calculate_dodge_diminishing_return(dodge_character_state_component, weapon_dodge_template, self._buff_extension)
	local distance_scale = (weapon_dodge_template and weapon_dodge_template.distance_scale or 1) * diminishing_return_factor
	local current_speed_setting_index = _find_speed_settings_index(time_in_dodge, start_point, speed_at_times, distance_scale)
	local speed_modifier = weapon_dodge_template and weapon_dodge_template.speed_modifier or 1
	local base_speed = _find_current_dodge_speed(time_in_dodge, current_speed_setting_index, speed_at_times, speed_modifier, diminishing_return_factor, distance_scale)
	local stat_buffs = self._buff_extension:stat_buffs()
	local buff_speed_modifier = stat_buffs.dodge_speed_multiplier
	local speed = base_speed * buff_speed_modifier
	local unit_rotation = self._first_person_component.rotation
	local flat_unit_rotation = Quaternion.look(Vector3.normalize(Vector3.flat(Quaternion.forward(unit_rotation))), Vector3.up())
	local move_direction = Quaternion.rotate(flat_unit_rotation, dodge_character_state_component.dodge_direction)
	self._locomotion_steering_component.velocity_wanted = move_direction * speed
	local move_delta = speed * dt
	dodge_character_state_component.distance_left = math.max(dodge_character_state_component.distance_left - move_delta, 0)
	local slide_threshold_sq = self._constants.slide_move_speed_threshold_sq
	local wants_slide = has_slide_input and slide_threshold_sq < current_length_sq

	return true, wants_slide
end

return PlayerCharacterStateDodging
