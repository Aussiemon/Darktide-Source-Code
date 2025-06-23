-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_alerted_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionMovement = require("scripts/utilities/minion_movement")
local Vo = require("scripts/utilities/vo")
local BtAlertedAction = class("BtAlertedAction", "BtNode")
local ALERTED_MODES = {
	directional_alerted = 3,
	alerted = 5,
	hesitate = 4,
	instant_aggro = 1,
	moving_alerted = 2
}
local LINE_OF_SIGHT_CHECK_SHORT_DISTANCE = 15
local LINE_OF_SIGHT_CHECK_DELAY_SHORT = 0.15
local LINE_OF_SIGHT_CHECK_DELAY = 0.75

BtAlertedAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local animation_extension = ScriptUnit.extension(unit, "animation_system")
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	scratchpad.animation_extension = animation_extension
	scratchpad.navigation_extension = navigation_extension
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")
	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")

	local perception_component = blackboard.perception

	scratchpad.perception_component = perception_component
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.perception_system = Managers.state.extension:system("perception_system")

	local alerted_mode = self:_select_alerted_mode(action_data)

	scratchpad.alerted_mode = alerted_mode

	local delay = perception_component.target_distance < LINE_OF_SIGHT_CHECK_SHORT_DISTANCE and LINE_OF_SIGHT_CHECK_DELAY_SHORT or LINE_OF_SIGHT_CHECK_DELAY

	scratchpad.check_line_of_sight_timing = t + delay

	if alerted_mode == ALERTED_MODES.alerted then
		local alerted_anim_events = action_data.alerted_anim_events
		local alerted_event = Animation.random_event(alerted_anim_events)
		local alerted_duration = action_data.alerted_duration

		if type(alerted_duration) == "table" then
			alerted_duration = math.random_range(alerted_duration[1], alerted_duration[2])
		end

		scratchpad.alerted_duration = t + alerted_duration

		animation_extension:anim_event(alerted_event)
	elseif alerted_mode == ALERTED_MODES.moving_alerted then
		navigation_extension:set_enabled(true, breed.run_speed)
		animation_extension:anim_event("idle")

		if breed.slot_template then
			local slot_system = Managers.state.extension:system("slot_system")

			slot_system:register_prioritized_user_unit_update(unit)
		end
	elseif alerted_mode == ALERTED_MODES.hesitate then
		local hesitate_anim_events = action_data.hesitate_anim_events
		local hesitate_event = Animation.random_event(hesitate_anim_events)
		local alerted_durations = action_data.alerted_durations
		local alerted_duration = alerted_durations[hesitate_event]

		if type(alerted_duration) == "table" then
			alerted_duration = math.random_range(alerted_duration[1], alerted_duration[2])
		end

		scratchpad.alerted_duration = t + alerted_duration

		animation_extension:anim_event(hesitate_event)
	end
end

BtAlertedAction._select_alerted_mode = function (self, action_data)
	local hesitate_chance = action_data.hesitate_chance
	local should_hesitate = hesitate_chance and hesitate_chance > math.random()

	if should_hesitate then
		return ALERTED_MODES.hesitate
	else
		local instant_aggro_chance = action_data.instant_aggro_chance
		local should_aggro_instantly = instant_aggro_chance and instant_aggro_chance > math.random()

		if should_aggro_instantly then
			return ALERTED_MODES.instant_aggro
		elseif action_data.moving_alerted_anim_events then
			return ALERTED_MODES.moving_alerted
		elseif action_data.directional_alerted_anim_events then
			return ALERTED_MODES.directional_alerted
		else
			return ALERTED_MODES.alerted
		end
	end
end

local DEFAULT_ALERTED_LOOP_EVENT = "alerted"

BtAlertedAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local perception_component = scratchpad.perception_component

	if not destroy and perception_component.aggro_state ~= "passive" then
		local perception_extension = scratchpad.perception_extension

		perception_extension:aggro()

		local alert_spread_radius, target_unit = action_data.alert_spread_radius, perception_component.target_unit

		if alert_spread_radius and ALIVE[target_unit] then
			local optional_require_los = true
			local optional_max_distance_to_target = action_data.alert_spread_max_distance_to_target

			perception_extension:alert_nearby_allies(target_unit, alert_spread_radius, optional_require_los, optional_max_distance_to_target)
		end
	end

	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	local alerted_mode = scratchpad.alerted_mode

	if alerted_mode == ALERTED_MODES.moving_alerted then
		local behavior_component = scratchpad.behavior_component
		local move_state = behavior_component.move_state

		if reason ~= "done" and move_state == "moving" then
			behavior_component.move_state = ""
		end

		scratchpad.navigation_extension:set_enabled(false)
	elseif alerted_mode == ALERTED_MODES.directional_alerted and not scratchpad.triggered_directional_alerted_loop then
		scratchpad.triggered_directional_alerted_loop = true

		local alerted_anim_events = action_data.alerted_anim_events
		local alerted_event = alerted_anim_events and Animation.random_event(alerted_anim_events) or DEFAULT_ALERTED_LOOP_EVENT

		scratchpad.animation_extension:anim_event(alerted_event)
	end
end

BtAlertedAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local behavior_component, navigation_extension = scratchpad.behavior_component, scratchpad.navigation_extension
	local move_state, is_following_path = behavior_component.move_state, navigation_extension:is_following_path()

	if move_state == "moving" and not is_following_path then
		return "failed"
	end

	local perception_component = scratchpad.perception_component

	if not scratchpad.confirmed_line_of_sight then
		local has_line_of_sight = perception_component.has_line_of_sight

		if t > scratchpad.check_line_of_sight_timing then
			scratchpad.confirmed_line_of_sight = has_line_of_sight
		elseif has_line_of_sight then
			scratchpad.perception_system:register_prioritized_unit_update(unit)
		end
	end

	local has_los = scratchpad.confirmed_line_of_sight or perception_component.ignore_alerted_los
	local alerted_mode = scratchpad.alerted_mode
	local ignore_set_anim_driven = true

	if alerted_mode == ALERTED_MODES.moving_alerted and is_following_path and has_los then
		if not scratchpad.started_directional_animation then
			self:_start_alerted_direction_anim(unit, scratchpad, action_data, t)

			behavior_component.move_state = "moving"
			scratchpad.started_directional_animation = true
		end

		local start_rotation_timing = scratchpad.start_rotation_timing

		if start_rotation_timing and start_rotation_timing <= t then
			MinionMovement.update_anim_driven_start_rotation(unit, scratchpad, action_data, t, nil, true)
		end

		if not scratchpad.is_anim_driven then
			MinionMovement.apply_animation_wanted_movement_speed(unit, navigation_extension, dt)
		end

		if scratchpad.rotate_towards_target then
			self:_rotate_towards_target_unit(unit, scratchpad, perception_component.target_unit)
		end
	elseif alerted_mode == ALERTED_MODES.directional_alerted then
		if not scratchpad.started_directional_animation then
			self:_start_alerted_direction_anim(unit, scratchpad, action_data, t)

			scratchpad.started_directional_animation = true
		end

		local start_rotation_timing = scratchpad.start_rotation_timing

		if start_rotation_timing and start_rotation_timing <= t then
			local target_position = POSITION_LOOKUP[scratchpad.perception_component.target_unit]

			MinionMovement.update_anim_driven_start_rotation(unit, scratchpad, action_data, t, target_position, ignore_set_anim_driven)
		end

		if scratchpad.rotate_towards_target then
			self:_rotate_towards_target_unit(unit, scratchpad, perception_component.target_unit)
		end
	elseif (scratchpad.rotate_towards_target or alerted_mode == ALERTED_MODES.hesitate) and perception_component.target_unit then
		self:_rotate_towards_target_unit(unit, scratchpad, perception_component.target_unit)
	end

	local alerted_duration = scratchpad.alerted_duration
	local alerted_durtation_done = alerted_duration and alerted_duration < t
	local vo_event = action_data.vo_event
	local alert_done = has_los and (alerted_duration and alerted_duration < t or alerted_mode == ALERTED_MODES.instant_aggro)
	local trigger_vo = alert_done and vo_event and alerted_mode == ALERTED_MODES.moving_alerted

	if trigger_vo then
		Vo.enemy_generic_vo_event(unit, vo_event, breed.name)
	end

	if alert_done then
		return "done"
	elseif alerted_durtation_done and alerted_mode == ALERTED_MODES.directional_alerted and not scratchpad.triggered_directional_alerted_loop then
		local alerted_anim_events = action_data.alerted_anim_events
		local alerted_event = alerted_anim_events and Animation.random_event(alerted_anim_events) or DEFAULT_ALERTED_LOOP_EVENT

		scratchpad.animation_extension:anim_event(alerted_event)

		scratchpad.triggered_directional_alerted_loop = true
	end

	local override_aggro_distance = action_data.override_aggro_distance

	if override_aggro_distance then
		local target_distance = perception_component.target_distance
		local override_aggro = target_distance <= override_aggro_distance

		if override_aggro then
			return "failed"
		end
	end

	return "running"
end

BtAlertedAction._start_alerted_direction_anim = function (self, unit, scratchpad, action_data, t)
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	local alerted_mode = scratchpad.alerted_mode
	local direction_name, anim_events

	if alerted_mode == ALERTED_MODES.moving_alerted then
		direction_name = MinionMovement.get_moving_direction_name(unit, scratchpad)
		anim_events = action_data.moving_alerted_anim_events
	else
		local rotation = Unit.local_rotation(unit, 1)
		local forward = Quaternion.forward(rotation)
		local right = Quaternion.right(rotation)
		local position = POSITION_LOOKUP[unit]
		local target_position = POSITION_LOOKUP[scratchpad.perception_component.target_unit]
		local direction = Vector3.flat(Vector3.normalize(target_position - position))

		direction_name = MinionMovement.get_relative_direction_name(right, forward, direction)
		anim_events = action_data.directional_alerted_anim_events
	end

	local alerted_anim_events = anim_events[direction_name]
	local alerted_anim = Animation.random_event(alerted_anim_events)

	if direction_name ~= "fwd" then
		MinionMovement.set_anim_driven(scratchpad, true)

		local start_move_rotation_timings = action_data.start_move_rotation_timings
		local start_rotation_timing = start_move_rotation_timings[alerted_anim]

		scratchpad.start_rotation_timing = t + start_rotation_timing
		scratchpad.move_start_anim_event_name = alerted_anim
	else
		scratchpad.start_rotation_timing = nil
		scratchpad.move_start_anim_event_name = nil
		scratchpad.rotate_towards_target = true
	end

	scratchpad.animation_extension:anim_event(alerted_anim)

	local alerted_durations = action_data.alerted_durations
	local alerted_duration = alerted_durations[alerted_anim]

	if type(alerted_duration) == "table" then
		alerted_duration = math.random_range(alerted_duration[1], alerted_duration[2])
	end

	scratchpad.alerted_duration = t + alerted_duration
end

BtAlertedAction._rotate_towards_target_unit = function (self, unit, scratchpad, target_unit)
	local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)
	local locomotion_extension = scratchpad.locomotion_extension

	locomotion_extension:set_wanted_rotation(flat_rotation)
end

return BtAlertedAction
