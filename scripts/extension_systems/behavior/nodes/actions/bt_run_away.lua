require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local Vo = require("scripts/utilities/vo")
local BtRunAwayAction = class("BtRunAwayAction", "BtNode")
local MainPathQueries = require("scripts/utilities/main_path_queries")
BtRunAwayAction.TIME_TO_FIRST_EVALUATE = {
	2,
	2.75
}
BtRunAwayAction.CONSECUTIVE_EVALUATE_INTERVAL = {
	1,
	1.5
}

BtRunAwayAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.perception_component = blackboard.perception
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.navigation_extension = navigation_extension
	local nav_world = navigation_extension:nav_world()
	scratchpad.nav_world = nav_world
	local disable_nav_tag_layers = action_data.disable_nav_tag_layers

	if disable_nav_tag_layers then
		navigation_extension:allow_nav_tag_layers(disable_nav_tag_layers, false)
	end

	local run_speed = action_data.run_speed

	navigation_extension:set_enabled(true, run_speed)

	scratchpad.time_to_next_evaluate = t + math.random_range(BtRunAwayAction.TIME_TO_FIRST_EVALUATE[1], BtRunAwayAction.TIME_TO_FIRST_EVALUATE[2])
	scratchpad.current_move_to_position = Vector3Box()
	local move_type = action_data.move_type
	scratchpad.move_type = move_type
	scratchpad.combat_vector_component = blackboard.combat_vector
	scratchpad.current_move_to_position = Vector3Box()
	local wanted_position = self:_get_wanted_position(unit, scratchpad, action_data)

	self:_move_to_position(scratchpad, wanted_position, navigation_extension)

	local vo_event = action_data.vo_event

	if vo_event then
		Vo.set_dynamic_smart_tag(unit, vo_event)
	end

	if action_data.max_duration then
		scratchpad.exit_t = t + action_data.max_duration
	end

	local fx_system = Managers.state.extension:system("fx_system")
	scratchpad.fx_system = fx_system

	self:_start_effect_template(unit, scratchpad, action_data)
end

BtRunAwayAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	local vo_event = action_data.vo_event

	if vo_event then
		Vo.set_dynamic_smart_tag(unit, breed.name)
	end

	local navigation_extension = scratchpad.navigation_extension
	local disable_nav_tag_layers = action_data.disable_nav_tag_layers

	if disable_nav_tag_layers then
		navigation_extension:allow_nav_tag_layers(disable_nav_tag_layers, true)
	end

	navigation_extension:set_enabled(false)
	self:_stop_effect_template(scratchpad)
end

local MIN_MOVE_DISTANCE_CHANGE_SQ = 9

BtRunAwayAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if scratchpad.exit_t and scratchpad.exit_t < t then
		return "done"
	end

	local navigation_extension = scratchpad.navigation_extension
	local num_failed_move_attempts = navigation_extension:failed_move_attempts()
	local has_path = navigation_extension:has_path()

	if not has_path and num_failed_move_attempts > 2 then
		return "failed"
	end

	scratchpad.has_followed_path = scratchpad.has_followed_path or navigation_extension:is_following_path()
	scratchpad.has_reached_destination = scratchpad.has_followed_path and navigation_extension:has_reached_destination()

	if action_data.leave_when_reached_destination and scratchpad.has_reached_destination then
		return "done"
	end

	local current_move_to_position = scratchpad.current_move_to_position:unbox()
	local wanted_position = current_move_to_position

	if scratchpad.has_reached_destination or navigation_extension:distance_to_destination() < 3 then
		wanted_position = self:_get_wanted_position(unit, scratchpad, action_data)
	end

	if action_data.allow_fallback_movement and not navigation_extension:has_path() and num_failed_move_attempts >= 1 then
		local current_move_type = scratchpad.move_type
		local new_move_type = current_move_type == "combat_vector" and "main_path" or "combat_vector"
		scratchpad.move_type = new_move_type
		wanted_position = self:_get_wanted_position(unit, scratchpad, action_data)
	end

	local distance_sq = Vector3.distance_squared(current_move_to_position, wanted_position)

	if MIN_MOVE_DISTANCE_CHANGE_SQ < distance_sq then
		self:_move_to_position(scratchpad, wanted_position, navigation_extension)
	end

	if scratchpad.start_move_event_anim_speed_duration then
		if t < scratchpad.start_move_event_anim_speed_duration then
			MinionMovement.apply_animation_wanted_movement_speed(unit, navigation_extension, dt)
		else
			navigation_extension:set_max_speed(action_data.speed)

			scratchpad.start_move_event_anim_speed_duration = nil
		end
	end

	local should_evaluate = scratchpad.time_to_next_evaluate <= t

	if should_evaluate then
		scratchpad.time_to_next_evaluate = t + math.random_range(BtRunAwayAction.CONSECUTIVE_EVALUATE_INTERVAL[1], BtRunAwayAction.CONSECUTIVE_EVALUATE_INTERVAL[2])
	end

	local behavior_component = scratchpad.behavior_component
	local should_start_idle, should_be_idling = MinionMovement.should_start_idle(scratchpad, behavior_component)

	if should_start_idle or should_be_idling then
		if should_start_idle then
			MinionMovement.start_idle(scratchpad, behavior_component, action_data)
		end

		local target_unit = scratchpad.perception_component.target_unit

		if not action_data.dont_rotate_towards_target and ALIVE[target_unit] then
			local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

			scratchpad.locomotion_extension:set_wanted_rotation(flat_rotation)
		end

		return "running", should_evaluate
	end

	local move_state = behavior_component.move_state

	if move_state ~= "moving" then
		self:_start_move_anim(unit, t, behavior_component, scratchpad, action_data)
	end

	if scratchpad.is_anim_driven and scratchpad.start_rotation_timing and scratchpad.start_rotation_timing <= t then
		MinionMovement.update_anim_driven_start_rotation(unit, scratchpad, action_data, t)
	end

	if action_data.ground_normal_rotation then
		local direction = Vector3.normalize(wanted_position - POSITION_LOOKUP[unit])

		MinionMovement.update_ground_normal_rotation(unit, scratchpad, direction)
	end

	return "running", should_evaluate
end

BtRunAwayAction._get_wanted_position = function (self, unit, scratchpad, action_data)
	local wanted_position = nil
	local move_type = scratchpad.move_type

	if move_type == "combat_vector" then
		wanted_position = self:_get_combat_vector_position(unit, scratchpad)
	elseif move_type == "main_path" then
		wanted_position = self:_get_main_path_position(unit, action_data)
	end

	return wanted_position
end

BtRunAwayAction._get_main_path_position = function (self, unit, action_data)
	local move_settings = action_data.main_path_move_settings
	local position_target_side_id = move_settings.position_target_side_id
	local travel_distance_random_range = move_settings.travel_distance_random_range
	local min_distance = move_settings.min_distance
	local main_path_manager = Managers.state.main_path
	local travel_distance = nil

	if move_settings.direction == "fwd" then
		local _, distance = main_path_manager:ahead_unit(position_target_side_id)
		travel_distance = distance
	else
		local _, distance = main_path_manager:behind_unit(position_target_side_id)
		travel_distance = distance
	end

	local random_offset = math.random_range(travel_distance_random_range[1], travel_distance_random_range[2])
	local total_path_distance = MainPathQueries.total_path_distance()
	local wanted_distance = math.clamp(travel_distance + random_offset, 0, total_path_distance)
	local wanted_position = MainPathQueries.position_from_distance(wanted_distance)
	local unit_position = POSITION_LOOKUP[unit]
	local distance = Vector3.distance(wanted_position, unit_position)

	if distance < min_distance then
		local fallback_distance_random_range = move_settings.fallback_distance_random_range
		local extra_offset = math.clamp(wanted_distance + math.random_range(fallback_distance_random_range[1], fallback_distance_random_range[2]), 0, total_path_distance)
		wanted_position = MainPathQueries.position_from_distance(extra_offset)
	end

	return wanted_position
end

BtRunAwayAction._get_combat_vector_position = function (self, unit, scratchpad)
	local combat_vector_component = scratchpad.combat_vector_component
	local wanted_position = combat_vector_component.position:unbox()

	return wanted_position
end

BtRunAwayAction._move_to_position = function (self, scratchpad, wanted_position, navigation_extension)
	navigation_extension:move_to(wanted_position)
	scratchpad.current_move_to_position:store(wanted_position)
end

BtRunAwayAction._start_move_anim = function (self, unit, t, behavior_component, scratchpad, action_data)
	local animation_extension = scratchpad.animation_extension
	local start_move_anim_events = action_data.start_move_anim_events
	local start_move_event = nil

	if start_move_anim_events then
		local moving_direction_name = MinionMovement.get_moving_direction_name(unit, scratchpad)
		start_move_event = start_move_anim_events[moving_direction_name]

		animation_extension:anim_event(start_move_event)

		if moving_direction_name ~= "fwd" then
			MinionMovement.set_anim_driven(scratchpad, true)

			local start_rotation_timing = action_data.start_move_rotation_timings[start_move_event]
			scratchpad.start_rotation_timing = t + start_rotation_timing
			scratchpad.move_start_anim_event_name = start_move_event
		else
			scratchpad.start_rotation_timing = nil
			scratchpad.move_start_anim_event_name = nil
		end
	elseif action_data.move_anim_event then
		start_move_event = action_data.move_anim_event

		animation_extension:anim_event(start_move_event)
	end

	local start_move_event_anim_speed_duration = action_data.start_move_event_anim_speed_durations and action_data.start_move_event_anim_speed_durations[start_move_event]

	if start_move_event_anim_speed_duration then
		scratchpad.start_move_event_anim_speed_duration = t + start_move_event_anim_speed_duration
	end

	behavior_component.move_state = "moving"
end

BtRunAwayAction._start_effect_template = function (self, unit, scratchpad, action_data)
	local effect_template = action_data.effect_template

	if not effect_template then
		return
	end

	local fx_system = scratchpad.fx_system
	local effect_id = fx_system:start_template_effect(effect_template, unit)
	scratchpad.effect_id = effect_id
end

BtRunAwayAction._stop_effect_template = function (self, scratchpad)
	local effect_id = scratchpad.effect_id

	if effect_id then
		local fx_system = scratchpad.fx_system

		fx_system:stop_template_effect(effect_id)

		scratchpad.effect_id = nil
	end
end

return BtRunAwayAction
