local Action = require("scripts/utilities/weapon/action")
local ActionHandlerSettings = require("scripts/settings/action/action_handler_settings")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local buff_keywords = BuffSettings.keywords
local Sprint = {}
local SPRINT_DODGE_ANGLE_THRESHOLD_RAD = math.degrees_to_radians(50)
Sprint.SPRINT_DODGE_ANGLE_THRESHOLD_RAD = SPRINT_DODGE_ANGLE_THRESHOLD_RAD
local TAU = math.pi * 2
local INPUT_ALIGNED_WITH_MOVENESS = TAU / 7
local ENOUGH_MOVE_IN_FORWARD_DIRECTION = 0.7
local VELOCITY_ALIGNED_WITH_ORIENTATION = TAU / 7
local throwing_action_kinds = {
	throw_grenade = true,
	throw = true
}
local aiming_projectile_kinds = {
	aim_projectile = true
}

Sprint.check = function (t, unit, movement_state_component, sprint_character_state_component, input_source, locomotion_component, weapon_action_component, alternate_fire_component, weapon_template, player_character_constants)
	local is_sprinting = Sprint.is_sprinting(sprint_character_state_component)
	local current_action_name, action_setting = Action.current_action(weapon_action_component, weapon_template)
	local action_requires_press = Sprint.requires_press_to_interrupt(action_setting)
	local action_prevents_sprint = Sprint.prevent_sprint(action_setting)
	local has_sprint_input = Sprint.sprint_input(input_source, is_sprinting, action_requires_press)
	local wants_sprint = not action_prevents_sprint and has_sprint_input
	local move = input_source:get("move")
	local has_enough_forward_move = ENOUGH_MOVE_IN_FORWARD_DIRECTION < move.y
	local valid_input_direction = false
	local moving_in_forward_direction = false

	if has_enough_forward_move then
		local yaw, _, roll = input_source:get_orientation()
		local flat_rotation = Quaternion.from_yaw_pitch_roll(yaw, 0, roll)
		local world_move = Quaternion.rotate(flat_rotation, move)
		local flat_velocity = Vector3.flat(locomotion_component.velocity_current)
		local input_angle = Vector3.angle(flat_velocity, world_move, true)
		valid_input_direction = input_angle < INPUT_ALIGNED_WITH_MOVENESS
		local orientation_forward = Quaternion.forward(flat_rotation)
		local vel_to_orientation_angle = Vector3.angle(flat_velocity, orientation_forward, true)
		moving_in_forward_direction = vel_to_orientation_angle < VELOCITY_ALIGNED_WITH_ORIENTATION
	end

	local sprint_ready_time = weapon_action_component.sprint_ready_time
	local allowed_by_weapon_action = true

	if current_action_name ~= "none" and t < sprint_ready_time then
		allowed_by_weapon_action = false
	end

	local is_throwing_projectile = action_setting and throwing_action_kinds[action_setting.kind]
	local is_aiming_projectile = action_setting and aiming_projectile_kinds[action_setting.kind]
	local is_aiming = alternate_fire_component.is_active or is_aiming_projectile
	local is_crouching = movement_state_component.is_crouching
	local action_input_extension = ScriptUnit.extension(unit, "action_input_system")
	local action_input = action_input_extension:peek_next_input("weapon_action")
	local has_no_action_input = action_input == nil
	local sprint_cooldown_finished = sprint_character_state_component.cooldown < t
	local can_sprint = wants_sprint and valid_input_direction and moving_in_forward_direction and allowed_by_weapon_action and not is_crouching and not is_aiming and not is_throwing_projectile and has_no_action_input and sprint_cooldown_finished

	return can_sprint
end

Sprint.sprint_input = function (input_source, is_sprinting, sprint_requires_press_to_interrupt)
	local wants_sprint = nil
	local hold_to_sprint = input_source:get("hold_to_sprint")

	if hold_to_sprint and (is_sprinting or not sprint_requires_press_to_interrupt) then
		wants_sprint = input_source:get("sprinting")
	elseif input_source:get("sprint") then
		wants_sprint = not is_sprinting
	else
		wants_sprint = is_sprinting
	end

	return wants_sprint
end

Sprint.is_sprinting = function (sprint_character_state_component)
	return sprint_character_state_component.is_sprinting or sprint_character_state_component.is_sprint_jumping
end

local NO_STAT_BUFFS = {
	[BuffSettings.stat_buffs.sprint_dodge_reduce_angle_threshold_rad] = 0
}

Sprint.is_sprint_dodging = function (target_unit, attacking_unit, run_away_dodge)
	local target_unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")

	if not target_unit_data_extension then
		return false
	end

	local target_breed = target_unit_data_extension:breed()

	if not Breed.is_player(target_breed) then
		return false
	end

	local sprint_character_state_component = target_unit_data_extension:read_component("sprint_character_state")
	local is_sprinting = sprint_character_state_component.is_sprinting
	local is_sprinting_overtime = sprint_character_state_component.sprint_overtime > 0
	local target_buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")
	local allow_doding_in_overtime = target_buff_extension and target_buff_extension:has_keyword(buff_keywords.sprint_dodge_in_overtime)

	if is_sprinting and (not is_sprinting_overtime or allow_doding_in_overtime) then
		local first_person_component = target_unit_data_extension:read_component("first_person")
		local look_rotation = first_person_component.rotation
		local look_direction = Vector3.normalize(Vector3.flat(Quaternion.forward(look_rotation)))
		local stat_buffs = target_buff_extension and target_buff_extension:stat_buffs() or NO_STAT_BUFFS
		local sprint_dodge_angle_threshold_rad = SPRINT_DODGE_ANGLE_THRESHOLD_RAD - stat_buffs.sprint_dodge_reduce_angle_threshold_rad
		local attacking_unit_position = POSITION_LOOKUP[attacking_unit]
		local player_unit_position = POSITION_LOOKUP[target_unit]
		local to_target = Vector3.normalize(Vector3.flat(attacking_unit_position - player_unit_position))
		local dot = Vector3.dot(to_target, look_direction)
		local look_away_angle = math.acos(math.abs(dot))
		local is_running_sideways = sprint_dodge_angle_threshold_rad < look_away_angle

		if not is_running_sideways and run_away_dodge then
			is_running_sideways = dot < 0.5
		end

		return is_running_sideways
	end

	return false
end

local _sprint_requires_press_to_interrupt_table = {}

for i = 1, #ActionHandlerSettings.sprint_requires_press_to_interrupt do
	local action_kind = ActionHandlerSettings.sprint_requires_press_to_interrupt[i]
	_sprint_requires_press_to_interrupt_table[action_kind] = true
end

Sprint.requires_press_to_interrupt = function (action_setting)
	if not action_setting then
		return false
	end

	local action_setting_sprint_requires_press_to_interrupt = action_setting.sprint_requires_press_to_interrupt

	if action_setting_sprint_requires_press_to_interrupt ~= nil then
		return action_setting_sprint_requires_press_to_interrupt
	end

	local action_kind = action_setting.kind
	local action_kind_sprint_requires_press_to_interrupt = _sprint_requires_press_to_interrupt_table[action_kind]

	return action_kind_sprint_requires_press_to_interrupt
end

local _prevent_sprint_table = {}

for i = 1, #ActionHandlerSettings.prevent_sprint do
	local action_kind = ActionHandlerSettings.prevent_sprint[i]
	_prevent_sprint_table[action_kind] = true
end

Sprint.prevent_sprint = function (action_setting)
	if not action_setting then
		return false
	end

	local action_setting_prevent_sprint = action_setting.prevent_sprint

	if action_setting_prevent_sprint ~= nil then
		return action_setting_prevent_sprint
	end

	local action_kind = action_setting.kind
	local action_kind_prevent_sprint = _prevent_sprint_table[action_kind]

	return action_kind_prevent_sprint
end

return Sprint
