﻿-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_in_cover_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local AttackIntensity = require("scripts/utilities/attack_intensity")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local CoverSettings = require("scripts/settings/cover/cover_settings")
local MinionAttack = require("scripts/utilities/minion_attack")
local MinionPerception = require("scripts/utilities/minion_perception")
local Vo = require("scripts/utilities/vo")
local BtInCoverAction = class("BtInCoverAction", "BtNode")

BtInCoverAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	behavior_component.move_state = "attacking"
	scratchpad.behavior_component = behavior_component

	local cover_component = Blackboard.write_component(blackboard, "cover")

	scratchpad.aim_component = Blackboard.write_component(blackboard, "aim")
	scratchpad.cover_component = cover_component
	scratchpad.perception_component = Blackboard.write_component(blackboard, "perception")
	scratchpad.suppression_component = blackboard.suppression

	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	locomotion_extension:set_movement_type("script_driven")

	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")

	MinionAttack.init_scratchpad_shooting_variables(unit, scratchpad, action_data, blackboard, breed)

	local clear_shot_line_of_sight_id = action_data.clear_shot_line_of_sight_id
	local line_of_sight_data = breed.line_of_sight_data

	for i = 1, #line_of_sight_data do
		local data = line_of_sight_data[i]

		if data.id == clear_shot_line_of_sight_id then
			scratchpad.clear_shot_line_of_sight_data = data

			break
		end
	end

	scratchpad.initial_enter = true

	self:_enter_cover(unit, breed, scratchpad, action_data, cover_component, t)
end

local DEFAULT_ABORTED_COVER_DISABLE_RANGE = {
	3,
	10
}
local DEFAULT_DONE_COVER_DISABLE_RANGE = {
	2,
	5
}

BtInCoverAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local cover_component = scratchpad.cover_component

	cover_component.is_in_cover = false

	local cover_user_extension = ScriptUnit.extension(unit, "cover_system")
	local disable_cover_range

	if reason ~= "done" then
		disable_cover_range = action_data.aborted_disable_cover_range or DEFAULT_ABORTED_COVER_DISABLE_RANGE
	else
		disable_cover_range = action_data.done_disable_cover_range or DEFAULT_DONE_COVER_DISABLE_RANGE
	end

	cover_user_extension:release_cover_slot(math.random_range(disable_cover_range[1], disable_cover_range[2]))
	scratchpad.locomotion_extension:set_movement_type("snap_to_navmesh")

	local state = scratchpad.state

	if state == "aiming" then
		MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)
	elseif state == "shooting" then
		MinionAttack.stop_shooting(unit, scratchpad)
	end

	if action_data.exit_anim_event then
		scratchpad.animation_extension:anim_event(action_data.exit_anim_event)
	end
end

local CLOSE_TO_COVER_DISTANCE_SQ = 0.010000000000000002

BtInCoverAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local perception_component = scratchpad.perception_component
	local suppression_component = scratchpad.suppression_component
	local attack_delay = MinionAttack.get_attack_delay(unit)
	local is_suppressed = suppression_component.is_suppressed or attack_delay > 0
	local cover_component = scratchpad.cover_component
	local state = scratchpad.state

	if state == "entering" then
		self:_update_entering(unit, scratchpad, action_data, t, cover_component)
	elseif state == "suppressed" then
		self:_update_suppressed(unit, scratchpad, action_data, t, cover_component, is_suppressed)
	elseif state == "peeking" then
		self:_update_peeking(unit, scratchpad, action_data, t, cover_component, perception_component, is_suppressed)
	elseif state == "aiming" then
		self:_update_aiming(unit, breed, scratchpad, blackboard, action_data, t, cover_component)
	elseif state == "shooting" then
		self:_update_shooting(unit, breed, scratchpad, blackboard, action_data, t, cover_component, perception_component, is_suppressed)
	end

	return "running"
end

BtInCoverAction._enter_cover = function (self, unit, breed, scratchpad, action_data, cover_component, t)
	local cover_type = cover_component.type
	local enter_cover_anim_state = action_data.enter_cover_anim_states[cover_type]
	local enter_cover_anim_event = Animation.random_event(enter_cover_anim_state)

	scratchpad.animation_extension:anim_event(enter_cover_anim_event)

	local enter_cover_duration = action_data.enter_cover_durations[enter_cover_anim_state]

	scratchpad.enter_cover_duration = t + enter_cover_duration
	scratchpad.state = "entering"

	local breed_name = breed.name

	Vo.enemy_generic_vo_event(unit, "take_cover", breed_name)
end

local DEFAULT_MIN_PEAK_DISTANCE = 40

BtInCoverAction._update_entering = function (self, unit, scratchpad, action_data, t, cover_component)
	local cover_position = cover_component.position:unbox()
	local cover_rotation = Quaternion.look(cover_component.direction:unbox())
	local enter_cover_duration = scratchpad.enter_cover_duration
	local min_peak_distance = action_data.min_peak_distance or DEFAULT_MIN_PEAK_DISTANCE
	local perception_component = scratchpad.perception_component
	local can_peak = ALIVE[perception_component.target_unit] and min_peak_distance > perception_component.target_distance

	if can_peak and enter_cover_duration <= t then
		self:_start_peeking(unit, scratchpad, action_data, cover_component, nil, t)
		scratchpad.locomotion_extension:teleport_to(cover_position, cover_rotation)

		scratchpad.initial_enter = nil
	elseif scratchpad.initial_enter then
		local locmotion_extension = scratchpad.locomotion_extension
		local to_cover = cover_position - POSITION_LOOKUP[unit]
		local to_cover_length_sq = Vector3.length_squared(to_cover)

		if to_cover_length_sq < CLOSE_TO_COVER_DISTANCE_SQ then
			locmotion_extension:set_wanted_velocity(Vector3.zero())
		else
			local direction = Vector3.normalize(to_cover)
			local wanted_velocity = direction * action_data.enter_cover_speed

			locmotion_extension:set_wanted_velocity(wanted_velocity)
			locmotion_extension:set_wanted_rotation(cover_rotation)
		end
	end
end

local DEFAULT_SUPPRESSED_DURATION = {
	2,
	3
}

BtInCoverAction._start_suppressed = function (self, unit, scratchpad, action_data, t, delayed_suppresed_anim, teleport)
	Vo.enemy_call_backup_event(unit)

	local animation_extension = scratchpad.animation_extension
	local cover_component = scratchpad.cover_component

	if delayed_suppresed_anim then
		local cover_type = cover_component.type
		local enter_cover_anim_state = action_data.enter_cover_anim_states[cover_type]

		animation_extension:anim_event(enter_cover_anim_state)

		local enter_cover_duration = action_data.enter_cover_durations[enter_cover_anim_state]

		scratchpad.delayed_suppressed_anim_t = t + enter_cover_duration
	else
		local suppressed_anim = action_data.suppressed_anim
		local suppressed_duration = action_data.suppressed_duration or DEFAULT_SUPPRESSED_DURATION

		scratchpad.suppressed_duration = t + math.random_range(suppressed_duration[1], suppressed_duration[2])

		animation_extension:anim_event(suppressed_anim)
	end

	if teleport then
		local cover_position = cover_component.position:unbox()
		local cover_rotation = Quaternion.look(cover_component.direction:unbox())

		scratchpad.locomotion_extension:teleport_to(cover_position, cover_rotation)
	end

	scratchpad.state = "suppressed"
end

BtInCoverAction._update_suppressed = function (self, unit, scratchpad, action_data, t, cover_component, is_suppressed)
	if scratchpad.delayed_suppressed_anim_t and t >= scratchpad.delayed_suppressed_anim_t then
		local suppressed_anim = action_data.suppressed_anim

		scratchpad.animation_extension:anim_event(suppressed_anim)

		scratchpad.delayed_suppressed_anim_t = nil

		local suppressed_duration = action_data.suppressed_duration or DEFAULT_SUPPRESSED_DURATION

		scratchpad.suppressed_duration = t + math.random_range(suppressed_duration[1], suppressed_duration[2])
	elseif not is_suppressed and scratchpad.suppressed_duration and t >= scratchpad.suppressed_duration then
		local min_peak_distance = action_data.min_peak_distance or DEFAULT_MIN_PEAK_DISTANCE
		local can_peak = min_peak_distance > scratchpad.perception_component.target_distance

		if can_peak then
			self:_start_peeking(unit, scratchpad, action_data, cover_component, nil, t)

			scratchpad.suppressed_duration = nil
		end
	end
end

local function _target_is_left_or_right(unit, scratchpad, action_data)
	local forward = Quaternion.forward(Unit.local_rotation(unit, 1))
	local clear_shot_line_of_sight_id = action_data.clear_shot_line_of_sight_id
	local aim_position = MinionAttack.get_aim_position(unit, scratchpad, clear_shot_line_of_sight_id) or POSITION_LOOKUP[scratchpad.perception_component.target_unit]
	local unit_position = POSITION_LOOKUP[unit]
	local flat_direction_to_target = Vector3.flat(Vector3.normalize(aim_position - unit_position))

	if Vector3.cross(forward, flat_direction_to_target).z > 0 then
		return "left"
	else
		return "right"
	end
end

BtInCoverAction._get_peek_identifier = function (self, unit, scratchpad, action_data, cover_component)
	local peek_type = cover_component.peek_type
	local cover_type = cover_component.type
	local peek_types = CoverSettings.peek_types
	local cover_types = CoverSettings.types
	local peek_identifier

	if peek_type == peek_types.both then
		local left_or_right = _target_is_left_or_right(unit, scratchpad, action_data)

		peek_identifier = left_or_right
	elseif peek_type == peek_types.right then
		if cover_type == cover_types.low then
			local left_or_right = _target_is_left_or_right(unit, scratchpad, action_data)

			if left_or_right == "left" then
				peek_identifier = "up"
			else
				peek_identifier = "right"
			end
		else
			peek_identifier = "right"
		end
	elseif peek_type == peek_types.left then
		if cover_type == cover_types.low then
			local left_or_right = _target_is_left_or_right(unit, scratchpad, action_data)

			if left_or_right == "right" then
				peek_identifier = "up"
			else
				peek_identifier = "left"
			end
		else
			peek_identifier = "left"
		end
	elseif cover_type == cover_types.low and peek_type == peek_types.blocked then
		peek_identifier = "up"
	end

	return peek_identifier
end

BtInCoverAction._start_peeking = function (self, unit, scratchpad, action_data, cover_component, peek_identifier, t)
	peek_identifier = peek_identifier or self:_get_peek_identifier(unit, scratchpad, action_data, cover_component)

	local anim_event = action_data.peek_anim_events[peek_identifier]
	local animation_extension = scratchpad.animation_extension

	animation_extension:anim_event(anim_event)

	local peek_duration = action_data.peek_duration

	scratchpad.peek_duration = t + peek_duration
	scratchpad.current_peak_identifier = peek_identifier
	scratchpad.state = "peeking"
end

BtInCoverAction._update_peeking = function (self, unit, scratchpad, action_data, t, cover_component, perception_component, is_suppressed)
	if not ALIVE[perception_component.target_unit] then
		return
	end

	if is_suppressed then
		local delayed_suppresed_anim = false
		local teleport = true

		self:_start_suppressed(unit, scratchpad, action_data, t, delayed_suppresed_anim, teleport)

		return
	end

	local peek_duration = scratchpad.peek_duration

	if peek_duration <= t then
		local target_unit = perception_component.target_unit
		local has_clear_shot, aim_position = self:_has_clear_shot_from_aiming_when_peeking(unit, scratchpad, action_data, perception_component, target_unit)
		local attack_allowed = AttackIntensity.minion_can_attack(unit, action_data.attack_intensity_type, target_unit)

		if attack_allowed and has_clear_shot then
			scratchpad.current_aim_position:store(aim_position)
			self:_start_aiming(unit, scratchpad, action_data, t)
			AttackIntensity.add_intensity(target_unit, action_data.attack_intensities)
			AttackIntensity.set_attacked(target_unit)
		else
			local min_peak_distance = action_data.min_peak_distance or DEFAULT_MIN_PEAK_DISTANCE
			local can_peak = min_peak_distance > scratchpad.perception_component.target_distance

			if can_peak then
				local peek_identifier = self:_get_peek_identifier(unit, scratchpad, action_data, cover_component)

				if peek_identifier ~= scratchpad.current_peak_identifier then
					self:_start_peeking(unit, scratchpad, action_data, cover_component, peek_identifier, t)
					Vo.enemy_ranged_idle_event(unit)
				end
			end
		end
	end
end

BtInCoverAction._has_clear_shot_from_aiming_when_peeking = function (self, unit, scratchpad, action_data, perception_component, target_unit)
	local cover_component = scratchpad.cover_component
	local cover_type, peek_identifier = cover_component.type, scratchpad.current_peak_identifier
	local clear_shot_offset_from_peeking = action_data.clear_shot_offset_from_peeking[cover_type]
	local boxed_offset = clear_shot_offset_from_peeking[peek_identifier]

	if not boxed_offset then
		return false, nil
	end

	local local_offset = boxed_offset:unbox()
	local unit_world_pose = Unit.world_pose(unit, 1)
	local from_position = Matrix4x4.transform(unit_world_pose, local_offset)
	local clear_shot_line_of_sight_id = action_data.clear_shot_line_of_sight_id
	local to_node = scratchpad.clear_shot_line_of_sight_data.to_node
	local to_position = MinionAttack.get_aim_position(unit, scratchpad, clear_shot_line_of_sight_id, to_node)

	if not to_position then
		return false, nil
	end

	local vector = to_position - from_position
	local distance = Vector3.length(vector)
	local direction = Vector3.normalize(vector)
	local hit = PhysicsWorld.raycast(scratchpad.physics_world, from_position, direction, distance, "any", "types", "both", "collision_filter", "filter_minion_line_of_sight_check")

	if hit then
		return false, nil
	else
		return true, to_position
	end
end

BtInCoverAction._start_aiming = function (self, unit, scratchpad, action_data, t)
	local aim_event = action_data.aim_anim_event

	scratchpad.animation_extension:anim_event(aim_event)

	local cover_aim_stances = action_data.cover_aim_stances

	if cover_aim_stances then
		local cover_type = scratchpad.cover_component.type
		local aim_stance = cover_aim_stances[cover_type]

		scratchpad.aim_stance = aim_stance
	end

	local aim_duration = action_data.aim_duration

	if type(aim_duration) == "table" then
		scratchpad.aim_duration = t + math.random_range(aim_duration[1], aim_duration[2])
	else
		scratchpad.aim_duration = t + aim_duration
	end

	local start_aiming_at_target_timings = action_data.start_aiming_at_target_timings
	local start_aiming_at_target_timing = start_aiming_at_target_timings[aim_event]

	scratchpad.start_aiming_at_target_timing = t + start_aiming_at_target_timing
	scratchpad.state = "aiming"

	MinionPerception.set_target_lock(unit, scratchpad.perception_component, true)
end

BtInCoverAction._update_aiming = function (self, unit, breed, scratchpad, blackboard, action_data, t, cover_component)
	if not ALIVE[scratchpad.perception_component.target_unit] then
		return
	end

	if t >= scratchpad.start_aiming_at_target_timing then
		self:_aim_at_target(unit, t, action_data, scratchpad, blackboard)
	end

	local aim_duration = scratchpad.aim_duration

	if aim_duration <= t then
		MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)
		self:_start_shooting(unit, scratchpad, action_data, t)
	end
end

BtInCoverAction._aim_at_target = function (self, unit, t, action_data, scratchpad, blackboard)
	local clear_shot_line_of_sight_id = action_data.clear_shot_line_of_sight_id
	local to_node = scratchpad.clear_shot_line_of_sight_data.to_node
	local aim_position = MinionAttack.get_aim_position(unit, scratchpad, clear_shot_line_of_sight_id, to_node)

	if not aim_position then
		return
	end

	scratchpad.current_aim_position:store(aim_position)

	local from_node = scratchpad.clear_shot_line_of_sight_data.from_node
	local aim_node = Unit.node(unit, from_node)
	local unit_position = Unit.world_position(unit, aim_node)
	local to_target = aim_position - unit_position
	local to_target_direction = Vector3.normalize(to_target)
	local unit_rotation = Unit.local_rotation(unit, 1)
	local current_peak_identifier = scratchpad.current_peak_identifier
	local right = Quaternion.right(unit_rotation)
	local lean_dot = 1

	if current_peak_identifier == "right" then
		lean_dot = Vector3.dot(right, to_target_direction)
	elseif current_peak_identifier == "left" then
		lean_dot = Vector3.dot(-right, to_target_direction)
	end

	local aim_component = scratchpad.aim_component

	aim_component.lean_dot = lean_dot

	MinionAttack.update_scope_reflection(unit, scratchpad, t, action_data)
end

BtInCoverAction._start_shooting = function (self, unit, scratchpad, action_data, t)
	local ignore_add_intensity = true

	MinionAttack.start_shooting(unit, scratchpad, t, action_data, nil, ignore_add_intensity)

	scratchpad.state = "shooting"
end

BtInCoverAction._update_shooting = function (self, unit, breed, scratchpad, blackboard, action_data, t, cover_component, perception_component, is_suppressed)
	if not ALIVE[perception_component.target_unit] then
		return
	end

	if is_suppressed then
		MinionAttack.stop_shooting(unit, scratchpad)

		local delayed_suppresed_anim = true

		self:_start_suppressed(unit, scratchpad, action_data, t, delayed_suppresed_anim)

		return
	end

	self:_aim_at_target(unit, t, action_data, scratchpad, blackboard)

	local _, fired_last_shot = MinionAttack.update_shooting(unit, scratchpad, t, action_data)

	if fired_last_shot then
		self:_enter_cover(unit, breed, scratchpad, action_data, cover_component, t)
		Vo.enemy_shooting_from_covers_event()
	end
end

return BtInCoverAction
