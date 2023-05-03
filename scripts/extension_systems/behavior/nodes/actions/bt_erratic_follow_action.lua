require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local DialogueBreedSettings = require("scripts/settings/dialogue/dialogue_breed_settings")
local MinionMovement = require("scripts/utilities/minion_movement")
local Vo = require("scripts/utilities/vo")
local BtErraticFollowAction = class("BtErraticFollowAction", "BtNode")
BtErraticFollowAction.TIME_TO_FIRST_EVALUATE = 0.5
BtErraticFollowAction.CONSECUTIVE_EVALUATE_INTERVAL = 0.25

BtErraticFollowAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.navigation_extension = navigation_extension
	scratchpad.stagger_component = Blackboard.write_component(blackboard, "stagger")
	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.perception_component = blackboard.perception
	local spawn_component = blackboard.spawn
	scratchpad.physics_world = spawn_component.physics_world

	navigation_extension:set_enabled(true, action_data.move_speed or breed.run_speed)

	local rotation_speed = action_data.rotation_speed

	if rotation_speed then
		scratchpad.original_rotation_speed = locomotion_extension:rotation_speed()

		locomotion_extension:set_rotation_speed(rotation_speed)
	end

	scratchpad.time_to_next_evaluate = t + BtErraticFollowAction.TIME_TO_FIRST_EVALUATE
	local follow_vo_interval_t = DialogueBreedSettings[breed.name].follow_vo_interval_t

	if action_data.vo_event and follow_vo_interval_t then
		scratchpad.follow_vo_interval_t = follow_vo_interval_t
		scratchpad.next_follow_vo_t = t + scratchpad.follow_vo_interval_t
	end

	if action_data.effect_template then
		local fx_system = Managers.state.extension:system("fx_system")
		scratchpad.fx_system = fx_system
	end

	scratchpad.state = "running"
	scratchpad.walk_anim_switch_duration = 0
	scratchpad.random_dirs = {
		action_data.move_jump_fwd_anims,
		action_data.move_jump_right_anims,
		action_data.move_jump_fwd_anims
	}
end

BtErraticFollowAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	local original_rotation_speed = scratchpad.original_rotation_speed

	if original_rotation_speed then
		scratchpad.locomotion_extension:set_rotation_speed(original_rotation_speed)
	end

	if scratchpad.stagger_duration then
		MinionMovement.stop_running_stagger(scratchpad)
	end

	scratchpad.navigation_extension:set_enabled(false)

	if scratchpad.global_effect_id then
		scratchpad.fx_system:stop_template_effect(scratchpad.global_effect_id)
	end
end

local MOVE_CHECK_DISTANCE_SQ = 9

BtErraticFollowAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local behavior_component = scratchpad.behavior_component
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit
	local vo_event = action_data.vo_event
	local next_follow_vo_t = scratchpad.next_follow_vo_t

	if vo_event and next_follow_vo_t and next_follow_vo_t < t then
		Vo.enemy_generic_vo_event(unit, vo_event, breed.name)

		scratchpad.next_follow_vo_t = t + scratchpad.follow_vo_interval_t
	end

	local should_start_idle, should_be_idling = MinionMovement.should_start_idle(scratchpad, behavior_component)

	if should_start_idle or should_be_idling then
		if should_start_idle and scratchpad.time_to_next_evaluate < t then
			MinionMovement.start_idle(scratchpad, behavior_component, action_data)

			scratchpad.time_to_next_evaluate = t + BtErraticFollowAction.CONSECUTIVE_EVALUATE_INTERVAL
		elseif should_be_idling and scratchpad.state ~= nil then
			self:_rotate_towards_target_unit(unit, target_unit, scratchpad)
		end

		local evaluate = not scratchpad.running_stagger_block_evaluate and scratchpad.time_to_next_evaluate < t

		return "running", evaluate
	end

	local move_state = behavior_component.move_state

	if move_state ~= "moving" then
		self:_start_move_anim(unit, breed, t, scratchpad, action_data)
	end

	local is_anim_driven = scratchpad.is_anim_driven

	if is_anim_driven and scratchpad.start_rotation_timing and scratchpad.start_rotation_timing <= t then
		MinionMovement.update_anim_driven_start_rotation(unit, scratchpad, action_data, t)
	end

	local state = scratchpad.state

	if state == "running" then
		self:_update_running(unit, t, scratchpad, blackboard, action_data)
	elseif state == "jumping" then
		self:_update_jumping(unit, t, scratchpad, blackboard, action_data, breed)
	end

	local navigation_extension = scratchpad.navigation_extension

	if scratchpad.start_move_event_anim_speed_duration and t < scratchpad.start_move_event_anim_speed_duration then
		MinionMovement.apply_animation_wanted_movement_speed(unit, navigation_extension, dt)
	end

	local effect_template = action_data.effect_template

	if effect_template then
		self:_update_effect_template(unit, scratchpad, action_data, target_unit)
	end

	local target_position = POSITION_LOOKUP[target_unit]
	local destination = navigation_extension:destination()
	local distance_to_destination_sq = Vector3.distance_squared(destination, target_position)
	local target_is_near_destination = distance_to_destination_sq < MOVE_CHECK_DISTANCE_SQ
	local should_evaluate = not scratchpad.running_stagger_block_evaluate and (scratchpad.time_to_next_evaluate < t or target_is_near_destination)

	if should_evaluate then
		scratchpad.time_to_next_evaluate = t + BtErraticFollowAction.CONSECUTIVE_EVALUATE_INTERVAL
	end

	return "running", should_evaluate
end

BtErraticFollowAction._start_move_anim = function (self, unit, breed, t, scratchpad, action_data)
	scratchpad.state = "running"
	local moving_direction_name = MinionMovement.get_moving_direction_name(unit, scratchpad)
	scratchpad.moving_direction_name = moving_direction_name
	local start_move_event = nil
	local state = scratchpad.state
	local using_anim_driven = false

	if action_data.start_move_anim_events and action_data.start_move_anim_events[state] then
		local start_move_anim_events = action_data.start_move_anim_events[state]
		start_move_event = Animation.random_event(start_move_anim_events[moving_direction_name])
		using_anim_driven = true
	end

	scratchpad.animation_extension:anim_event(start_move_event or action_data.run_anim_event)

	if using_anim_driven and moving_direction_name ~= "fwd" then
		MinionMovement.set_anim_driven(scratchpad, true)

		local start_move_rotation_timings = action_data.start_move_rotation_timings
		local start_rotation_timing = start_move_rotation_timings[start_move_event]
		scratchpad.start_rotation_timing = t + start_rotation_timing
		scratchpad.move_start_anim_event_name = start_move_event
	else
		scratchpad.start_rotation_timing = nil
		scratchpad.move_start_anim_event_name = nil
	end

	local start_move_event_anim_speed_duration = action_data.start_move_event_anim_speed_durations and action_data.start_move_event_anim_speed_durations[start_move_event]

	if start_move_event_anim_speed_duration then
		scratchpad.start_move_event_anim_speed_duration = t + start_move_event_anim_speed_duration
	end

	local behavior_component = scratchpad.behavior_component
	behavior_component.move_state = "moving"
end

BtErraticFollowAction._update_running = function (self, unit, t, scratchpad, blackboard, action_data)
	local is_jumping = self:_investigate_jump(unit, t, scratchpad, blackboard, action_data)

	if is_jumping then
		return
	end
end

BtErraticFollowAction._update_jumping = function (self, unit, t, scratchpad, blackboard, action_data, breed)
	local jump_duration = scratchpad.jump_duration

	if jump_duration and jump_duration <= t then
		local navigation_extension = scratchpad.navigation_extension
		local slot_system = Managers.state.extension:system("slot_system")
		local slot_position = slot_system:user_unit_slot_position(unit) or POSITION_LOOKUP[scratchpad.perception_component.target_unit]

		navigation_extension:move_to(slot_position)

		local is_jumping = self:_investigate_jump(unit, t, scratchpad, blackboard, action_data)

		if not is_jumping then
			self:_start_move_anim(unit, breed, t, scratchpad, action_data)
		end
	end
end

BtErraticFollowAction._check_for_high_jump = function (self, unit, scratchpad)
	if math.random() < 0.5 then
		return
	end

	local physics_world = scratchpad.physics_world
	local ray_length = 1.2
	local pos = POSITION_LOOKUP[unit]
	local fwd = Vector3.normalize(Quaternion.forward(Unit.world_rotation(unit, 1)))
	local above_pos = pos + Vector3(0, 0, 2)
	local infront_pos = above_pos + fwd * 2
	local result, hit_position = PhysicsWorld.raycast(physics_world, infront_pos, Vector3(0, 0, 1), ray_length, "closest", "collision_filter", "filter_minion_line_of_sight_check")
	local result2, hit_position2 = PhysicsWorld.raycast(physics_world, above_pos, Vector3(0, 0, 1), ray_length, "closest", "collision_filter", "filter_minion_line_of_sight_check")
	local can_jump_high = (not result or not hit_position) and (not result2 or not hit_position2)

	return can_jump_high
end

BtErraticFollowAction.check_dir = function (self, p0, travel_dir, nav_world, traverse_logic, data)
	local jump_dir = Quaternion.rotate(Quaternion(Vector3.up(), data.ray_angle), travel_dir)
	local p1 = p0 + jump_dir * data.ray_dist
	local success, hit_pos = GwNavQueries.raycast(nav_world, p0, p1, traverse_logic)
	local num_fields = #data

	if success then
		local j = math.random(num_fields)

		for i = 1, num_fields do
			local d = data[j]
			local end_dir = Quaternion.rotate(Quaternion(Vector3.up(), d.ray_angle), jump_dir)
			local end_dot = Vector3.dot(travel_dir, end_dir)
			local p2 = p1 + end_dir * d.ray_dist

			if end_dot <= 0 then
				return false
			end

			success = GwNavQueries.raycast(nav_world, p1, p2, traverse_logic)

			if success then
				return d
			end

			j = j + 1

			if num_fields < j then
				j = 1
			end
		end
	elseif hit_pos then
		return false
	end
end

local RANDOM_JUMP_COOLDOWN = {
	1,
	2
}
local JUMP_COOLDOWN_CHANCE = 0.25
local MAX_DISTANCE_TO_TARGET_FOR_JUMP = 6

BtErraticFollowAction._investigate_jump = function (self, unit, t, scratchpad, blackboard, action_data)
	if scratchpad.jump_cooldown and t < scratchpad.jump_cooldown then
		return false
	elseif scratchpad.jump_cooldown then
		scratchpad.jump_cooldown = nil
	end

	local navigation_extension = scratchpad.navigation_extension

	if not navigation_extension:is_following_path() then
		return false
	end

	local nav_bot = navigation_extension._nav_bot
	local node_index = GwNavBot.get_path_current_node_index(nav_bot)
	local num_index = GwNavBot.get_path_nodes_count(nav_bot)
	local distance_to_target = scratchpad.perception_component.target_distance

	if distance_to_target < MAX_DISTANCE_TO_TARGET_FOR_JUMP then
		return false
	end

	if node_index < 0 or node_index == num_index then
		return false
	end

	local unit_position = POSITION_LOOKUP[unit]
	local sub_goal = GwNavBot.get_path_node_pos(nav_bot, node_index + 1)
	local travel_dir = Vector3.normalize(sub_goal - unit_position)
	local move_dir = Quaternion.forward(Unit.local_rotation(unit, 1))
	local dot = Vector3.dot(move_dir, travel_dir)
	local nav_world = navigation_extension:nav_world()
	local traverse_logic = navigation_extension:traverse_logic()
	local jump_anim, jump_data = nil
	local moving_towards_target = dot > 0.25

	if moving_towards_target then
		local random_dirs = scratchpad.random_dirs

		table.shuffle(random_dirs)

		for i = 1, 3 do
			jump_data = self:check_dir(unit_position, move_dir, nav_world, traverse_logic, random_dirs[i])

			if jump_data then
				break
			end
		end
	else
		local right_of_to_goal = Vector3.cross(move_dir, travel_dir)[3] > 0

		if right_of_to_goal then
			jump_data = self:check_dir(unit_position, move_dir, nav_world, traverse_logic, action_data.move_jump_only_fwd_left_anims)

			if not jump_data then
				jump_data = self:check_dir(unit_position, move_dir, nav_world, traverse_logic, action_data.move_jump_only_left_anims)
			end
		else
			jump_data = self:check_dir(unit_position, move_dir, nav_world, traverse_logic, action_data.move_jump_only_right_anims)
			jump_data = jump_data or self:check_dir(unit_position, move_dir, nav_world, traverse_logic, action_data.move_jump_only_fwd_right_anims)
		end
	end

	if jump_data then
		jump_anim = jump_data[1]
		scratchpad.jump_duration = t + action_data.jump_durations[jump_anim]

		if action_data.uses_high_jumps and self:_check_for_high_jump(unit, scratchpad) then
			jump_anim = jump_anim .. "_high"
		end

		local locomotion_extension = scratchpad.locomotion_extension

		locomotion_extension:set_movement_type("snap_to_navmesh")
		MinionMovement.set_anim_driven(scratchpad, true)
		scratchpad.animation_extension:anim_event(jump_anim)

		scratchpad.state = "jumping"

		if math.random() < JUMP_COOLDOWN_CHANCE then
			scratchpad.jump_cooldown = t + math.random_range(RANDOM_JUMP_COOLDOWN[1], RANDOM_JUMP_COOLDOWN[2])
		end

		return true
	end

	return false
end

BtErraticFollowAction._update_effect_template = function (self, unit, scratchpad, action_data, target_unit)
	local self_position = POSITION_LOOKUP[unit]
	local target_position = POSITION_LOOKUP[target_unit]
	local distance = Vector3.distance(self_position, target_position)
	local fx_system = scratchpad.fx_system

	if scratchpad.global_effect_id then
		local stop_distance = action_data.effect_template_stop_distance

		if stop_distance <= distance then
			fx_system:stop_template_effect(scratchpad.global_effect_id)

			scratchpad.global_effect_id = nil
		end
	else
		local start_distance = action_data.effect_template_start_distance

		if distance <= start_distance then
			scratchpad.global_effect_id = fx_system:start_template_effect(action_data.effect_template, unit)
		end
	end
end

BtErraticFollowAction._rotate_towards_target_unit = function (self, unit, target_unit, scratchpad)
	local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

	scratchpad.locomotion_extension:set_wanted_rotation(flat_rotation)
end

return BtErraticFollowAction
