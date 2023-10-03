require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Dodge = require("scripts/extension_systems/character_state_machine/character_states/utilities/dodge")
local HitScan = require("scripts/utilities/attack/hit_scan")
local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local MinionAttack = require("scripts/utilities/minion_attack")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionPatrols = require("scripts/utilities/minion_patrols")
local MinionPerception = require("scripts/utilities/minion_perception")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local NavigationCostSettings = require("scripts/settings/navigation/navigation_cost_settings")
local NavQueries = require("scripts/utilities/nav_queries")
local Trajectory = require("scripts/utilities/trajectory")
local Vo = require("scripts/utilities/vo")
local STATES = table.index_lookup_table("passive", "aiming", "shooting")
local BtAggroedPatrolAction = class("BtAggroedPatrolAction", "BtNode")
local NAV_TAG_LAYER_COSTS = {
	jumps = 30,
	ledges_with_fence = 30,
	doors = 10,
	teleporters = 20,
	ledges = 30
}
local DEFAULT_ROTATION_SPEED = 3.5

BtAggroedPatrolAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.animation_extension = animation_extension
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.behavior_component = behavior_component
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.navigation_extension = navigation_extension
	local nav_world = navigation_extension:nav_world()
	scratchpad.nav_world = nav_world
	local traverse_logic = navigation_extension:traverse_logic()
	scratchpad.traverse_logic = traverse_logic
	scratchpad.perception_component = Blackboard.write_component(blackboard, "perception")
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")
	local aim_component = Blackboard.write_component(blackboard, "aim")
	scratchpad.aim_component = aim_component
	local walk_speed = breed.walk_speed

	navigation_extension:set_enabled(true, walk_speed)

	for nav_tag_name, cost in pairs(NAV_TAG_LAYER_COSTS) do
		navigation_extension:set_nav_tag_layer_cost(nav_tag_name, cost)
	end

	local patrol_component = Blackboard.write_component(blackboard, "patrol")
	scratchpad.patrol_component = patrol_component
	local patrol_index = patrol_component.patrol_index
	local is_patrol_leader = patrol_index == 1
	scratchpad.is_patrol_leader = is_patrol_leader

	if is_patrol_leader then
		GwNavBot.set_use_channel(navigation_extension._nav_bot, true)

		local patrol = Blackboard.write_component(blackboard, "patrol")
		local walk_position = patrol.walk_position:unbox()

		navigation_extension:move_to(walk_position)

		local group_extension = ScriptUnit.extension(unit, "group_system")
		local group_system = Managers.state.extension:system("group_system")
		scratchpad.group_system = group_system
		local group_id = group_extension:group_id()
		scratchpad.group_id = group_id
		scratchpad.group_extension = group_extension
		local walk_position_direction = Vector3.normalize(walk_position - POSITION_LOOKUP[unit])
		local unit_fwd = Quaternion.forward(Unit.local_rotation(unit, 1))
		local dot = Vector3.dot(walk_position_direction, unit_fwd)

		if dot < 0 then
			local group = group_system:group_from_id(group_id)
			local members = group.members

			for j = 1, #members do
				local member_unit = members[j]

				if member_unit ~= unit then
					local member_blackboard = BLACKBOARDS[member_unit]
					local member_patrol = Blackboard.write_component(member_blackboard, "patrol")
					local old_index = member_patrol.patrol_index

					if old_index % 2 == 0 then
						member_patrol.patrol_index = member_patrol.patrol_index + 1
					else
						member_patrol.patrol_index = member_patrol.patrol_index - 1
					end
				end
			end
		end
	end

	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local current_rotation_speed = locomotion_extension:rotation_speed()
	scratchpad.original_rotation_speed = current_rotation_speed

	locomotion_extension:set_rotation_speed(DEFAULT_ROTATION_SPEED or action_data.rotation_speed)

	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.previous_speed = walk_speed
	scratchpad.next_patrol_update_t = 0
	scratchpad.previous_move_to_position = Vector3Box()

	MinionAttack.init_scratchpad_shooting_variables(unit, scratchpad, action_data, blackboard, breed)

	local spawn_component = blackboard.spawn
	scratchpad.spawn_component = spawn_component
	scratchpad.breed = breed

	self:_start_aiming(unit, t, scratchpad, action_data)

	local fx_system = Managers.state.extension:system("fx_system")
	scratchpad.fx_system = fx_system
	scratchpad.unit = unit
	scratchpad.hit_units = {}

	if action_data.push_minions_radius then
		scratchpad.broadphase_system = Managers.state.extension:system("broadphase_system")
		scratchpad.pushed_minions = {}
		scratchpad.side_system = Managers.state.extension:system("side_system")
	end
end

BtAggroedPatrolAction.init_values = function (self, blackboard)
	local patrol_component = Blackboard.write_component(blackboard, "patrol")

	patrol_component.walk_position:store(0, 0, 0)

	patrol_component.should_patrol = false
	patrol_component.patrol_leader_unit = nil
	patrol_component.patrol_index = 0
	patrol_component.patrol_id = 0
	patrol_component.auto_patrol = false
end

BtAggroedPatrolAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	self:_stop_liquid_beam(unit, scratchpad, blackboard)

	local aim_component = scratchpad.aim_component
	aim_component.controlled_aiming = false
	local navigation_extension = scratchpad.navigation_extension

	navigation_extension:set_enabled(false)

	local locomotion_extension = scratchpad.locomotion_extension

	locomotion_extension:set_rotation_speed(scratchpad.original_rotation_speed)

	scratchpad.behavior_component.move_state = "idle"
	local default_nav_tag_layers_minions = NavigationCostSettings.default_nav_tag_layers_minions

	for nav_tag_name, _ in pairs(NAV_TAG_LAYER_COSTS) do
		local default_cost = default_nav_tag_layers_minions[nav_tag_name]

		navigation_extension:set_nav_tag_layer_cost(nav_tag_name, default_cost)
	end

	local breed_nav_tag_allowed_layers = breed.nav_tag_allowed_layers

	if breed_nav_tag_allowed_layers then
		for nav_tag_name, cost in pairs(breed_nav_tag_allowed_layers) do
			navigation_extension:set_nav_tag_layer_cost(nav_tag_name, cost)
		end
	end

	if scratchpad.is_patrol_leader and not breed.use_navigation_path_splines then
		GwNavBot.set_use_channel(navigation_extension._nav_bot, false)
	end

	if scratchpad.is_patrol_leader then
		self:trigger_patrol_sound(scratchpad, false)
	end
end

local WAIT_AT_DESTINATION_TIME_RANGE = {
	1,
	3
}

BtAggroedPatrolAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local is_patrol_leader = scratchpad.is_patrol_leader

	self:_update_patrolling(unit, breed, blackboard, scratchpad, action_data, dt, t)

	local patrol_component = scratchpad.patrol_component
	local behavior_component = scratchpad.behavior_component
	local should_start_idle, should_be_idling = MinionMovement.should_start_idle(scratchpad, behavior_component)

	if is_patrol_leader then
		local navigation_extension = scratchpad.navigation_extension
		scratchpad.has_followed_path = scratchpad.has_followed_path or navigation_extension:is_following_path()

		if not scratchpad.wait_at_destination_t and is_patrol_leader and scratchpad.has_followed_path and navigation_extension:has_reached_destination() then
			scratchpad.wait_at_destination_t = t + math.random_range(WAIT_AT_DESTINATION_TIME_RANGE[1], WAIT_AT_DESTINATION_TIME_RANGE[2])
		end
	end

	local move_state = behavior_component.move_state

	if (not scratchpad.start_move_cooldown or scratchpad.start_move_cooldown <= t) and (move_state ~= "moving" or scratchpad.patrol_anim_end_at_t and scratchpad.patrol_anim_end_at_t <= t) then
		self:_start_move_anim(unit, scratchpad, behavior_component, action_data, t)
	end

	local shoot_state = scratchpad.shoot_state
	local target_unit = scratchpad.perception_component.target_unit

	Debug:text(shoot_state .. tostring(target_unit))

	if not ALIVE[target_unit] then
		return "running"
	end

	if shoot_state == "aiming" then
		local done = self:_update_aiming(unit, t, dt, scratchpad, action_data)
	elseif shoot_state == "shooting" then
		local done = self:_update_shooting(unit, t, dt, scratchpad, action_data)

		if done then
			local end_anim_events = action_data.end_anim_events

			if end_anim_events then
				self:_stop_liquid_beam(unit, scratchpad, blackboard)

				local end_anim_event = Animation.random_event(end_anim_events)

				scratchpad.animation_extension:anim_event(end_anim_event)

				local end_duration = action_data.end_durations[end_anim_event]
				scratchpad.end_duration = t + end_duration
				scratchpad.shoot_state = "ending"
			else
				self:_stop_liquid_beam(unit, scratchpad, blackboard)

				local end_duration = action_data.end_duration
				scratchpad.end_duration = t + end_duration
				scratchpad.shoot_state = "ending"
			end

			return "running"
		end
	elseif shoot_state == "ending" and scratchpad.end_duration <= t then
		self:_start_aiming(unit, t, scratchpad, action_data)

		return "running"
	end

	if should_start_idle or should_be_idling then
		if should_start_idle then
			MinionMovement.start_idle(scratchpad, behavior_component, action_data)

			scratchpad.patrol_anim_end_at_t = nil

			if scratchpad.is_patrol_leader then
				self:trigger_patrol_sound(scratchpad, false)
			end
		end

		if scratchpad.wait_at_destination_t and scratchpad.wait_at_destination_t <= t then
			if patrol_component.auto_patrol then
				self:_set_new_patrol_position(unit, patrol_component)
			else
				patrol_component.walk_position:store(0, 0, 0)

				patrol_component.should_patrol = false
			end

			return "done"
		end

		return "running"
	end

	return "running"
end

local DEFAULT_MOVE_ANIM_EVENT = "move_fwd"
local ANIM_VARIABLE_NAME = "anim_move_speed"
local DEFAULT_SPEED = 0.9
local MIN_VARIABLE_VALUE = 0.2
local MAX_VARIABLE_VALUE = 2

BtAggroedPatrolAction._start_move_anim = function (self, unit, scratchpad, behavior_component, action_data, t)
	behavior_component.move_state = "moving"
	local move_event = Animation.random_event(action_data.anim_events or DEFAULT_MOVE_ANIM_EVENT)

	scratchpad.animation_extension:anim_event(move_event)

	local duration = action_data.durations and action_data.durations[move_event]

	if duration then
		scratchpad.patrol_anim_end_at_t = t + duration
	end

	local speed = nil

	if scratchpad.is_patrol_leader then
		self:trigger_patrol_sound(scratchpad, true)

		speed = action_data.speeds[move_event] or DEFAULT_SPEED
	else
		local patrol_component = scratchpad.patrol_component
		local patrol_leader_unit = patrol_component.patrol_leader_unit
		local patrol_leader_nav_extension = ALIVE[patrol_leader_unit] and ScriptUnit.has_extension(patrol_leader_unit, "navigation_system")
		speed = patrol_leader_nav_extension and patrol_leader_nav_extension:max_speed() or action_data.speeds[move_event] or DEFAULT_SPEED
	end

	scratchpad.navigation_extension:set_max_speed(speed)

	local variable_value = math.clamp(speed, 0, MAX_VARIABLE_VALUE)

	scratchpad.animation_extension:set_variable(ANIM_VARIABLE_NAME, variable_value)

	scratchpad.start_move_cooldown = t + 0.05
end

local AHEAD_TRAVEL_DISTANCE_RANDOM_RANGE = {
	-30,
	30
}
local FALLBACK_DISTANCE_RANDOM_RANGE = {
	1,
	30
}
local NEW_PATROL_POSITION_TARGET_SIDE_ID = 1
local MIN_DISTANCE_TO_NEW_PATROL_POS = 2

BtAggroedPatrolAction._set_new_patrol_position = function (self, unit, patrol_component)
	local main_path_manager = Managers.state.main_path
	local _, ahead_travel_distance = main_path_manager:ahead_unit(NEW_PATROL_POSITION_TARGET_SIDE_ID)

	if not ahead_travel_distance then
		return
	end

	local random_offset = math.random_range(AHEAD_TRAVEL_DISTANCE_RANDOM_RANGE[1], AHEAD_TRAVEL_DISTANCE_RANDOM_RANGE[2])
	local total_path_distance = MainPathQueries.total_path_distance()
	local wanted_distance = math.clamp(ahead_travel_distance + random_offset, 0, total_path_distance)
	local wanted_position = MainPathQueries.position_from_distance(wanted_distance)
	local unit_position = POSITION_LOOKUP[unit]
	local distance = Vector3.distance(wanted_position, unit_position)

	if distance < MIN_DISTANCE_TO_NEW_PATROL_POS then
		local extra_offset = math.clamp(wanted_distance + math.random_range(FALLBACK_DISTANCE_RANDOM_RANGE[1], FALLBACK_DISTANCE_RANDOM_RANGE[2]), 0, total_path_distance)
		wanted_position = MainPathQueries.position_from_distance(extra_offset)
	end

	patrol_component.walk_position:store(wanted_position)
end

BtAggroedPatrolAction.trigger_patrol_sound = function (self, scratchpad, should_start)
	if should_start and not scratchpad.started_patrol_sound then
		local group_system = scratchpad.group_system
		local group = scratchpad.group_extension:group()
		local start_event = group.group_start_sound_event
		local stop_event = group.group_stop_sound_event

		if start_event and not group.sfx and not group.group_sound_event_started then
			group_system:start_group_sfx(scratchpad.group_id, start_event, stop_event)
		end

		scratchpad.started_patrol_sound = true
	elseif not should_start then
		local group_system = scratchpad.group_system
		local group = scratchpad.group_extension:group()

		group_system:stop_group_sfx(group)

		group.group_sound_event_started = false

		Managers.state.game_session:send_rpc_clients("rpc_stop_group_sfx", scratchpad.group_id)

		scratchpad.started_patrol_sound = false
	end
end

local ABOVE = 2
local BELOW = 2.5
local HOTIZONTAL = 2
local PATROL_OFFSET_SIDEWAYS = 0.75
local PATORL_OFFSET_BACK = 0.25
local SPEED_UP_DISTANCE = 0.5
local SLOW_DOWN_DISTANCE = 0.25
local MAX_SPEED_UP_SPEED = 0.25
local SLOW_DOWN_SPEED = 0.65
local LERP_FOLLOW_DIRECTION_SPEED = 0.5
local SPEED_LERP_SPEED = 2
local MIN_DISTANCE_SQ_TO_MOVE = 0.010000000000000002

BtAggroedPatrolAction._update_patrolling = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if scratchpad.is_patrol_leader or scratchpad.delayed_alert or scratchpad.start_move_cooldown and t < scratchpad.start_move_cooldown then
		return
	end

	local patrol_component = scratchpad.patrol_component
	local nav_world = scratchpad.nav_world
	local traverse_logic = scratchpad.traverse_logic
	local patrol_leader_unit = patrol_component.patrol_leader_unit

	if not HEALTH_ALIVE[patrol_leader_unit] then
		return
	end

	local patrol_index = patrol_component.patrol_index - 1
	local patrol_leader_locomotion_extension = ScriptUnit.extension(patrol_leader_unit, "locomotion_system")
	local current_velocity = patrol_leader_locomotion_extension:current_velocity()
	local magnitude = Vector3.length(current_velocity)
	local velocity_normalized = Vector3.normalize(current_velocity)
	local current_follow_direction = nil

	if not scratchpad.current_follow_direction then
		current_follow_direction = velocity_normalized
		scratchpad.current_follow_direction = Vector3Box(velocity_normalized)
	else
		current_follow_direction = scratchpad.current_follow_direction:unbox()
		current_follow_direction = Vector3.lerp(current_follow_direction, velocity_normalized, dt * LERP_FOLLOW_DIRECTION_SPEED)

		scratchpad.current_follow_direction:store(current_follow_direction)
	end

	local patrol_leader_nav_extension = ScriptUnit.extension(patrol_leader_unit, "navigation_system")
	local _, is_right_side, is_left_side, is_third = MinionPatrols.get_follow_index(patrol_index)
	local follow_unit_rotation = Unit.local_rotation(patrol_leader_unit, 1)
	local follow_unit_position = POSITION_LOOKUP[patrol_leader_unit]
	local follow_unit_right, follow_unit_bwd = nil
	follow_unit_right = Quaternion.right(follow_unit_rotation)
	follow_unit_bwd = -Quaternion.forward(follow_unit_rotation)
	local patrol_position = nil

	if patrol_index % 2 == 0 then
		patrol_position = follow_unit_position + follow_unit_right * PATROL_OFFSET_SIDEWAYS * patrol_index
	else
		patrol_position = follow_unit_position + -follow_unit_right * PATROL_OFFSET_SIDEWAYS * (patrol_index + 1)
	end

	patrol_position = patrol_position + follow_unit_bwd * PATORL_OFFSET_BACK * patrol_index
	local follow_unit_leader_speed = patrol_leader_nav_extension:max_speed()
	local navigation_extension = scratchpad.navigation_extension

	QuickDrawer:sphere(patrol_position, 0.2, Color.lime())

	if Vector3.distance_squared(patrol_position, scratchpad.previous_move_to_position:unbox()) <= MIN_DISTANCE_SQ_TO_MOVE then
		navigation_extension:set_max_speed(follow_unit_leader_speed)

		local variable_value = math.clamp(follow_unit_leader_speed, MIN_VARIABLE_VALUE, MAX_VARIABLE_VALUE)
		local old_variable_value = scratchpad.old_move_speed_variable

		if variable_value ~= old_variable_value then
			scratchpad.animation_extension:set_variable(ANIM_VARIABLE_NAME, variable_value)

			scratchpad.old_move_speed_variable = variable_value
		end

		return
	end

	local target_speed_away = MinionMovement.target_speed_away(unit, patrol_leader_unit)

	if target_speed_away < 0 then
		return
	end

	local position_on_navmesh = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, patrol_position, ABOVE, BELOW, HOTIZONTAL)

	if not position_on_navmesh then
		return
	end

	scratchpad.previous_move_to_position:store(patrol_position)
	navigation_extension:move_to(position_on_navmesh)

	local distance_to_patrol_position = Vector3.distance(POSITION_LOOKUP[unit], position_on_navmesh)
	local new_speed = nil

	if SPEED_UP_DISTANCE < distance_to_patrol_position then
		new_speed = follow_unit_leader_speed + math.min(distance_to_patrol_position, MAX_SPEED_UP_SPEED)
	elseif distance_to_patrol_position < SLOW_DOWN_DISTANCE then
		new_speed = SLOW_DOWN_SPEED
	else
		local locomotion_extension = scratchpad.locomotion_extension
		local current_speed = Vector3.length(locomotion_extension:current_velocity())
		local speed_diff = distance_to_patrol_position - current_speed * dt
		new_speed = follow_unit_leader_speed - speed_diff
	end

	local previous_speed = scratchpad.previous_speed
	local wanted_speed = math.lerp(previous_speed, new_speed, dt * SPEED_LERP_SPEED)

	navigation_extension:set_max_speed(wanted_speed)

	scratchpad.previous_speed = wanted_speed
	local variable_value = math.clamp(wanted_speed, MIN_VARIABLE_VALUE, MAX_VARIABLE_VALUE)
	local old_variable_value = scratchpad.old_move_speed_variable

	if variable_value ~= old_variable_value then
		scratchpad.animation_extension:set_variable(ANIM_VARIABLE_NAME, variable_value)

		scratchpad.old_move_speed_variable = variable_value
	end
end

local MAX_AIM_DURATION = 2

BtAggroedPatrolAction._start_aiming = function (self, unit, t, scratchpad, action_data)
	scratchpad.aim_component.controlled_aiming = true
	local aim_anim_events = action_data.aim_anim_events or "aim"
	local aim_event = Animation.random_event(aim_anim_events)
	local aim_duration = action_data.aim_duration[aim_event]

	if type(aim_duration) == "table" then
		local diff_aim_durations = Managers.state.difficulty:get_table_entry_by_challenge(aim_duration)
		local duration = math.random_range(diff_aim_durations[1], diff_aim_durations[2])
		scratchpad.aim_duration = duration
	else
		scratchpad.aim_duration = aim_duration
	end

	scratchpad.shoot_state = "aiming"
	scratchpad.max_aim_duration = MAX_AIM_DURATION
	local vo_event = action_data.vo_event

	if vo_event then
		local breed_name = scratchpad.breed.name

		Vo.enemy_generic_vo_event(unit, vo_event, breed_name)
	end

	MinionPerception.set_target_lock(unit, scratchpad.perception_component, true)
	self:_set_game_object_field(scratchpad, "state", STATES.aiming)
end

local AIM_TURN_DOT_THRESHOLD = 0.75
local AIM_TURN_FWD_DOT_THRESHOLD = 0.9

BtAggroedPatrolAction._update_aim_turning = function (self, unit, scratchpad, action_data, aim_dot, flat_to_target, aim_rotation_anims)
	if not aim_dot then
		return false
	end

	local animation_extension = scratchpad.animation_extension
	local current_aim_rotation_direction_name = scratchpad.current_aim_rotation_direction_name

	if aim_rotation_anims then
		if aim_dot < AIM_TURN_DOT_THRESHOLD then
			local unit_rotation = Unit.local_rotation(unit, 1)
			local unit_forward = Quaternion.forward(unit_rotation)
			local is_to_the_left = Vector3.cross(unit_forward, flat_to_target).z > 0

			if is_to_the_left and current_aim_rotation_direction_name ~= "left" then
				animation_extension:anim_event(aim_rotation_anims.left)

				scratchpad.current_aim_rotation_direction_name = "left"
			elseif not is_to_the_left and current_aim_rotation_direction_name ~= "right" then
				animation_extension:anim_event(aim_rotation_anims.right)

				scratchpad.current_aim_rotation_direction_name = "right"
			end
		elseif current_aim_rotation_direction_name ~= "fwd" and AIM_TURN_FWD_DOT_THRESHOLD < aim_dot then
			animation_extension:anim_event(aim_rotation_anims.fwd)

			scratchpad.current_aim_rotation_direction_name = "fwd"
		end
	else
		local ground_normal_rotation = action_data.ground_normal_rotation

		if ground_normal_rotation then
			local target_unit = scratchpad.perception_component.target_unit
			local direction_to_target = Vector3.normalize(POSITION_LOOKUP[target_unit] - POSITION_LOOKUP[unit])

			MinionMovement.update_ground_normal_rotation(unit, scratchpad, direction_to_target)
		else
			self:_rotate_towards_target_unit(unit, scratchpad)
		end

		return true
	end

	local is_facing_target = not aim_rotation_anims or scratchpad.current_aim_rotation_direction_name == "fwd"

	return is_facing_target
end

BtAggroedPatrolAction._rotate_towards_target_unit = function (self, unit, scratchpad)
	local target_unit = scratchpad.perception_component.target_unit
	local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

	scratchpad.locomotion_extension:set_wanted_rotation(flat_rotation)

	return flat_rotation
end

BtAggroedPatrolAction._update_aiming = function (self, unit, t, dt, scratchpad, action_data)
	local aim_pos = self:_get_from_shoot_pos(unit, scratchpad, action_data)

	scratchpad.aim_component.controlled_aim_position:store(aim_pos)
	self:_set_game_object_field(scratchpad, "aim_position", aim_pos)

	local from_position = self:_get_from_position(unit, scratchpad, action_data)

	self:_update_liquid_beam_positions(dt, scratchpad, action_data, from_position, aim_pos)

	local _, aim_dot, flat_to_target = MinionAttack.aim_at_target(unit, scratchpad, t, action_data)
	local aim_rotation_anims = action_data.aim_rotation_anims
	local is_facing_target = aim_dot and aim_dot > 0
	local target_unit = scratchpad.perception_component.target_unit
	local has_line_of_sight = scratchpad.perception_extension:last_los_position(target_unit) ~= nil

	if aim_dot and is_facing_target and has_line_of_sight then
		if not scratchpad.liquid_beam_effect_id then
			self:_start_effect_template(unit, scratchpad, action_data)
		end

		scratchpad.aim_duration = math.max(scratchpad.aim_duration - dt, 0)
	elseif not has_line_of_sight then
		scratchpad.max_aim_duration = math.max(scratchpad.max_aim_duration - dt, 0)
	end

	if is_facing_target and scratchpad.aim_duration == 0 then
		MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)
		self:_start_shooting(unit, t, scratchpad, action_data)
	elseif scratchpad.max_aim_duration == 0 then
		return true
	end

	return false
end

local FIRST_SHOOT_TIMING = 0

BtAggroedPatrolAction._start_shooting = function (self, unit, t, scratchpad, action_data)
	MinionAttack.start_shooting(unit, scratchpad, t, action_data, FIRST_SHOOT_TIMING)

	scratchpad.shoot_state = "shooting"
	local liquid_paint_id_from_component = action_data.liquid_paint_id_from_component

	if liquid_paint_id_from_component then
		local behavior_component = scratchpad.behavior_component

		if behavior_component[liquid_paint_id_from_component] == 0 then
			behavior_component[liquid_paint_id_from_component] = LiquidArea.start_paint()
		end
	elseif not action_data.skip_liquid then
		scratchpad.liquid_paint_id = LiquidArea.start_paint()
	end

	if not action_data.skip_liquid then
		local unit_position = POSITION_LOOKUP[unit]
		local shot_from, distance_to_from = self:_get_from_shoot_pos(unit, scratchpad, action_data)
		local distance = Vector3.distance(unit_position, shot_from)
		local place_liquid_timing = t + distance / action_data.place_liquid_timing_speed
		scratchpad.place_liquid_timing = place_liquid_timing
		scratchpad.distance_to_from = distance_to_from
	end

	self:_set_game_object_field(scratchpad, "state", STATES.shooting)

	if action_data.aoe_bot_threat_timing then
		scratchpad.aoe_bot_threat_timing = t + action_data.aoe_bot_threat_timing
	end
end

local AIM_DOT_THRESHOLD = 0

BtAggroedPatrolAction._update_shooting = function (self, unit, t, dt, scratchpad, action_data)
	if scratchpad.shooting_liquid_beam then
		local done = self:_update_shooting_liquid_beam(unit, t, dt, scratchpad, action_data)

		if done then
			return true
		end

		local target_position = scratchpad.to_shot_position:unbox()
		local aim_node = Unit.node(unit, scratchpad.aim_node_name)
		local unit_position = Unit.world_position(unit, aim_node)
		local to_target = target_position - unit_position
		local to_target_direction = Vector3.normalize(to_target)
		local flat_to_target_direction = Vector3.flat(to_target_direction)
		local unit_rotation = Unit.local_rotation(unit, 1)
		local unit_forward = Quaternion.forward(unit_rotation)
		local dot = Vector3.dot(unit_forward, flat_to_target_direction)

		if dot < AIM_DOT_THRESHOLD then
			local ground_normal_rotation = action_data.ground_normal_rotation

			if ground_normal_rotation then
				MinionMovement.update_ground_normal_rotation(unit, scratchpad, to_target_direction)
			else
				local wanted_rotation = Quaternion.look(flat_to_target_direction)

				scratchpad.locomotion_extension:set_wanted_rotation(wanted_rotation)
			end
		end

		if scratchpad.aoe_bot_threat_timing and scratchpad.aoe_bot_threat_timing <= t then
			local aoe_bot_threat_size = action_data.aoe_bot_threat_size:unbox()
			local aoe_bot_threat_duration = action_data.aoe_bot_threat_duration
			local aoe_bot_threat_rotation = Quaternion.look(flat_to_target_direction)
			local side_system = Managers.state.extension:system("side_system")
			local side = side_system.side_by_unit[unit]
			local enemy_sides = side:relation_sides("enemy")
			local group_system = Managers.state.extension:system("group_system")
			local bot_groups = group_system:bot_groups_from_sides(enemy_sides)
			local num_bot_groups = #bot_groups

			for i = 1, num_bot_groups do
				local bot_group = bot_groups[i]

				bot_group:aoe_threat_created(target_position, "oobb", aoe_bot_threat_size, aoe_bot_threat_rotation, aoe_bot_threat_duration)
			end

			scratchpad.aoe_bot_threat_timing = nil
		end
	elseif scratchpad.next_shoot_timing and scratchpad.next_shoot_timing <= t then
		scratchpad.shooting_liquid_beam = true
		scratchpad.shot_start_t = t
		scratchpad.next_shoot_timing = nil
		local shot_from = self:_get_from_shoot_pos(unit, scratchpad, action_data)
		local shot_to = self:_get_to_shoot_pos(unit, scratchpad, action_data)
		scratchpad.from_shot_position = Vector3Box(shot_from)
		scratchpad.to_shot_position = Vector3Box(shot_to)
		scratchpad.next_sphere_cast_t = t + action_data.sphere_cast_frequency
	end
end

local BELOW = 2
local ABOVE = 1
local RAYCAST_DOWN_LENGTH = 5

BtAggroedPatrolAction._update_shooting_liquid_beam = function (self, unit, t, dt, scratchpad, action_data)
	local from_shot_position = scratchpad.from_shot_position:unbox()
	local to_shot_position = scratchpad.to_shot_position:unbox()
	local attack_duration = action_data.attack_duration
	local shot_start_t = scratchpad.shot_start_t
	local elapsed_t = t - shot_start_t
	local lerp_t = math.min(elapsed_t / attack_duration, 1)
	local attack_finished = lerp_t >= 1
	local current_shot_position = Vector3.lerp(from_shot_position, to_shot_position, lerp_t)
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit
	local from_position = self:_get_from_position(unit, scratchpad, action_data)
	local end_position = self:_update_liquid_beam_positions(dt, scratchpad, action_data, from_position, current_shot_position)

	if not action_data.dont_follow_target and end_position and ALIVE[target_unit] and perception_component.has_line_of_sight then
		local new_to = self:_get_to_shoot_pos(unit, scratchpad, action_data)

		scratchpad.to_shot_position:store(new_to)
	elseif action_data.dont_follow_target then
		local ground_normal_rotation = action_data.ground_normal_rotation
		local to_shot_direction = Vector3.normalize(to_shot_position - from_shot_position)

		if ground_normal_rotation then
			MinionMovement.update_ground_normal_rotation(unit, scratchpad, to_shot_direction)
		else
			local rotation = Quaternion.look(Vector3.flat(to_shot_direction))

			scratchpad.locomotion_extension:set_wanted_rotation(rotation)
		end
	end

	if scratchpad.place_liquid_timing and end_position and scratchpad.place_liquid_timing < t then
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local liquid_paint_id_from_component = action_data.liquid_paint_id_from_component
		local liquid_paint_id = liquid_paint_id_from_component and scratchpad.behavior_component[liquid_paint_id_from_component] or scratchpad.liquid_paint_id
		local max_liquid_paint_distance = action_data.max_liquid_paint_distance
		local liquid_position = end_position + Vector3.up() * 0.5
		local nav_world = scratchpad.nav_world
		local liquid_area_template = action_data.liquid_area_template
		local allow_liquid_unit_creation = true
		local liquid_paint_brush_size = action_data.liquid_paint_brush_size
		local not_on_other_liquids = true
		local source_unit = unit
		local source_side = side and side:name()

		LiquidArea.paint(liquid_paint_id, max_liquid_paint_distance, liquid_position, nav_world, liquid_area_template, allow_liquid_unit_creation, liquid_paint_brush_size, not_on_other_liquids, source_unit, nil, source_side)

		if action_data.push_minions_radius then
			MinionAttack.push_friendly_minions(unit, scratchpad, action_data, t, end_position)
		end
	end

	local next_sphere_cast_t = scratchpad.next_sphere_cast_t

	if end_position and next_sphere_cast_t <= t then
		self:_shoot_sphere_cast(unit, t, end_position, scratchpad, action_data)

		scratchpad.next_sphere_cast_t = t + action_data.sphere_cast_frequency
	end

	if attack_finished then
		local attack_finished_grace_period = action_data.attack_finished_grace_period

		if attack_finished_grace_period and not scratchpad.attack_finished_grace_period then
			scratchpad.attack_finished_grace_period = t + attack_finished_grace_period
		elseif not scratchpad.attack_finished_grace_period or scratchpad.attack_finished_grace_period <= t then
			scratchpad.shooting_liquid_beam = false
			scratchpad.shot_start_t = nil
			scratchpad.next_shoot_timing = nil

			return true
		end
	end
end

local function _clamp_network_position(position)
	local network_min = NetworkConstants.min_position
	local network_max = NetworkConstants.max_position
	position[1] = math.clamp(position[1], network_min, network_max)
	position[2] = math.clamp(position[2], network_min, network_max)
	position[3] = math.clamp(position[3], network_min, network_max)

	return position
end

BtAggroedPatrolAction._update_liquid_beam_positions = function (self, dt, scratchpad, action_data, from_position, to_position)
	local segment_list, total_length = self:_try_get_trajectory(scratchpad, action_data, from_position, to_position)
	local num_segments = segment_list and #segment_list
	local end_position = nil

	if segment_list and total_length and num_segments > 1 and total_length > 1 then
		local control_points = self:_calculate_control_points(scratchpad, segment_list, total_length, dt)
		local control_point_1 = _clamp_network_position(control_points[1]:unbox())
		local control_point_2 = _clamp_network_position(control_points[2]:unbox())
		end_position = _clamp_network_position(control_points[3]:unbox())

		self:_set_game_object_field(scratchpad, "aim_position", end_position)
		self:_set_game_object_field(scratchpad, "control_point_1", control_point_1)
		self:_set_game_object_field(scratchpad, "control_point_2", control_point_2)

		local aim_pos = control_point_1

		scratchpad.aim_component.controlled_aim_position:store(aim_pos)
	end

	return end_position
end

BtAggroedPatrolAction._start_effect_template = function (self, unit, scratchpad, action_data)
	local effect_template = action_data.effect_template
	local fx_system = scratchpad.fx_system
	local liquid_beam_effect_id = fx_system:start_template_effect(effect_template, unit)
	scratchpad.liquid_beam_effect_id = liquid_beam_effect_id
end

BtAggroedPatrolAction._stop_effect_template = function (self, scratchpad)
	local liquid_beam_effect_id = scratchpad.liquid_beam_effect_id

	if liquid_beam_effect_id then
		local fx_system = scratchpad.fx_system

		fx_system:stop_template_effect(liquid_beam_effect_id)

		scratchpad.liquid_beam_effect_id = nil
	end
end

BtAggroedPatrolAction._set_game_object_field = function (self, scratchpad, key, value)
	local spawn_component = scratchpad.spawn_component
	local game_session = spawn_component.game_session
	local game_object_id = spawn_component.game_object_id

	GameSession.set_game_object_field(game_session, game_object_id, key, value)
end

BtAggroedPatrolAction._get_from_shoot_pos = function (self, unit, scratchpad, action_data)
	local nav_world = scratchpad.nav_world
	local from = POSITION_LOOKUP[unit]
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit
	local to = scratchpad.perception_extension:last_los_position(target_unit) or POSITION_LOOKUP[target_unit]
	local direction = Vector3.flat(Vector3.normalize(to - from))
	local distance = Vector3.distance(from, to)
	local range_percentage_front = action_data.range_percentage_front
	local shot_from = to - direction * distance * range_percentage_front
	local shot_from_on_navmesh = NavQueries.position_on_mesh(nav_world, shot_from, ABOVE, BELOW)
	local target_position_on_navmesh = NavQueries.position_on_mesh(nav_world, to, ABOVE, BELOW)
	local on_ground_position = nil

	if shot_from_on_navmesh and target_position_on_navmesh then
		local _, raycast_position = GwNavQueries.raycast(nav_world, target_position_on_navmesh, shot_from_on_navmesh)

		if not raycast_position then
			on_ground_position = NavQueries.position_on_mesh(nav_world, shot_from, ABOVE, BELOW)
		else
			on_ground_position = raycast_position
		end
	end

	on_ground_position = on_ground_position or self:_ray_cast(scratchpad.physics_world, shot_from + Vector3.up(), Vector3.down(), RAYCAST_DOWN_LENGTH, action_data)
	local final_position = on_ground_position or shot_from
	local distance_to_from = Vector3.distance(to, final_position)

	return final_position, distance_to_from
end

BtAggroedPatrolAction._get_to_shoot_pos = function (self, unit, scratchpad, action_data)
	local range_back = action_data.range_back
	local from = POSITION_LOOKUP[unit]
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit
	local target_position = POSITION_LOOKUP[target_unit]
	local perception_extension = scratchpad.perception_extension
	local to = perception_extension:last_los_position(target_unit)
	to.z = target_position.z
	local direction = Vector3.flat(Vector3.normalize(to - from))
	local shot_to = to + direction * range_back
	local on_ground_position = NavQueries.position_on_mesh(scratchpad.nav_world, shot_to, ABOVE, BELOW)
	on_ground_position = on_ground_position or self:_ray_cast(scratchpad.physics_world, shot_to + Vector3(0, 0, 1), Vector3.down(), RAYCAST_DOWN_LENGTH, action_data)

	if on_ground_position and target_position.z < on_ground_position.z then
		return on_ground_position
	end

	shot_to = shot_to + Vector3(0, 0, 0.2)

	return shot_to
end

BtAggroedPatrolAction._ray_cast = function (self, physics_world, from, direction, distance, action_data)
	local collision_filter = action_data.collision_filter
	local _, hit_position, hit_distance, normal, _ = PhysicsWorld.raycast(physics_world, from, direction, distance, "closest", "collision_filter", collision_filter)

	return hit_position, hit_distance, normal
end

local IMPACT_FX_DATA = {}
local INDEX_ACTOR = 4

BtAggroedPatrolAction._shoot_sphere_cast = function (self, unit, t, shoot_position, scratchpad, action_data)
	local shoot_template = action_data.shoot_template
	local from_position = self:_get_from_position(unit, scratchpad, action_data)
	local shoot_direction = Vector3.normalize(shoot_position - from_position)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local breed = unit_data_extension:breed()
	local power_level = Managers.state.difficulty:get_minion_attack_power_level(breed, "ranged")
	local charge_level = 1
	local distance = Vector3.distance(from_position, shoot_position)
	local collision_filter = action_data.collision_filter
	local physics_world = scratchpad.physics_world
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit
	local is_dodging = Dodge.is_dodging(target_unit)
	local radius = is_dodging and action_data.dodge_radius or action_data.radius
	local hits = HitScan.sphere_sweep(physics_world, from_position, shoot_direction, distance, "dynamics", collision_filter, nil, radius)
	local world = scratchpad.world

	HitScan.process_hits(true, world, physics_world, unit, shoot_template, hits, from_position, shoot_direction, power_level, charge_level, IMPACT_FX_DATA, distance, nil, nil, nil, nil, nil, nil)

	local perception_extension = scratchpad.perception_extension
	local on_hit_buff = action_data.on_hit_buff
	local side_system = Managers.state.extension:system("side_system")

	if on_hit_buff and hits then
		local hit_units = scratchpad.hit_units

		if not action_data.only_apply_buff_once then
			table.clear(hit_units)
		end

		for i = 1, #hits do
			repeat
				local hit = hits[i]
				local hit_actor = hit.actor or hit[INDEX_ACTOR]
				local hit_unit = Actor.unit(hit_actor)

				if hit_units[hit_unit] then
					break
				end

				local los_lookup = perception_extension:has_line_of_sight(hit_unit)

				if not los_lookup then
					break
				end

				hit_units[hit_unit] = true
				local is_enemy = side_system:is_enemy(unit, hit_unit)

				if is_enemy then
					local buff_extension = ScriptUnit.extension(hit_unit, "buff_system")

					buff_extension:add_internally_controlled_buff(on_hit_buff, t)
				end
			until true
		end
	end
end

local SPEED_MULTIPLIER = 2
local MIN_TRAJECTORY_SPEED = 8
local MAX_TRAJECTORY_SPEED = 18
local MAX_TIME = 1.5
local MAX_STEPS = 30

BtAggroedPatrolAction._try_get_trajectory = function (self, scratchpad, action_data, from_position, to_position)
	if to_position == nil then
		return false
	end

	local _, distance_to_from = self:_get_from_shoot_pos(scratchpad.unit, scratchpad, action_data)
	local speed_modifier = (distance_to_from or 1) * SPEED_MULTIPLIER
	local trajectory_config = action_data.trajectory_config
	local speed = math.clamp(trajectory_config.initial_speed + speed_modifier, MIN_TRAJECTORY_SPEED, MAX_TRAJECTORY_SPEED)
	local gravity = trajectory_config.gravity
	local acceptable_accuracy = 1
	local angle, estimated_position = Trajectory.angle_to_hit_moving_target(from_position, to_position, speed, Vector3.zero(), gravity, acceptable_accuracy)

	if angle == nil then
		return false
	end

	local velocity = Trajectory.get_trajectory_velocity(from_position, estimated_position, gravity, speed, angle)
	local physics_world = scratchpad.physics_world
	local collision_filter = action_data.collision_filter
	local _, segment_list, total_length = Trajectory.ballistic_raycast(physics_world, collision_filter, from_position, velocity, angle, gravity, MAX_STEPS, MAX_TIME)

	return segment_list, total_length
end

local function _get_point_on_segment(segments, num_segments, length)
	local current_length = 0

	for i = 2, num_segments do
		local prev_segment = segments[i - 1]
		local segment = segments[i]
		local to_segment = segment - prev_segment
		local distance = Vector3.length(to_segment)
		current_length = current_length + distance

		if length <= current_length then
			local diff = current_length - length
			local point = segment + Vector3.normalize(-to_segment) * diff

			return point
		end
	end
end

BtAggroedPatrolAction._get_from_position = function (self, unit, scratchpad, action_data)
	local from_position = nil
	local weapon_item = scratchpad.weapon_item

	if weapon_item then
		local fx_source_name = action_data.fx_source_name
		local attachment_unit, node = MinionVisualLoadout.attachment_unit_and_node_from_node_name(weapon_item, fx_source_name)
		from_position = Unit.world_position(attachment_unit, node)
	elseif action_data.from_node then
		local from_node_name = action_data.from_node
		local from_node = Unit.node(unit, from_node_name)
		from_position = Unit.world_position(unit, from_node)
	end

	return from_position
end

BtAggroedPatrolAction._calculate_control_points = function (self, scratchpad, segments, total_length, dt)
	local num_segments = #segments
	local last = segments[num_segments]
	local one_fourth = total_length / 4
	local one_third = total_length / 3
	local mid_1 = _get_point_on_segment(segments, num_segments, one_third)
	local mid_2 = _get_point_on_segment(segments, num_segments, total_length - one_fourth)
	local control_points = scratchpad.control_points

	if not control_points then
		scratchpad.control_points = Script.new_array(3)
		scratchpad.control_points[1] = Vector3Box(mid_1)
		scratchpad.control_points[2] = Vector3Box(mid_2)
		scratchpad.control_points[3] = Vector3Box(last)
	else
		control_points[1]:store(mid_1)
		control_points[2]:store(Vector3.lerp(control_points[2]:unbox(), mid_2, dt * 5))
		control_points[3]:store(Vector3.lerp(control_points[3]:unbox(), last, dt * 4))
	end

	return scratchpad.control_points
end

BtAggroedPatrolAction._stop_liquid_beam = function (self, unit, scratchpad, blackboard)
	self:_stop_effect_template(scratchpad)
	self:_set_game_object_field(scratchpad, "state", STATES.passive)

	local shoot_state = scratchpad.shoot_state

	if shoot_state == "aiming" then
		MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)
	elseif shoot_state == "shooting" then
		MinionAttack.stop_shooting(unit, scratchpad)
	end

	if scratchpad.liquid_paint_id then
		LiquidArea.stop_paint(scratchpad.liquid_paint_id)
	end
end

return BtAggroedPatrolAction
