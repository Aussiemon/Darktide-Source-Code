require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Dodge = require("scripts/extension_systems/character_state_machine/character_states/utilities/dodge")
local HitScan = require("scripts/utilities/attack/hit_scan")
local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local MinionAttack = require("scripts/utilities/minion_attack")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionPerception = require("scripts/utilities/minion_perception")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local NavQueries = require("scripts/utilities/nav_queries")
local Trajectory = require("scripts/utilities/trajectory")
local Vo = require("scripts/utilities/vo")
local BtShootLiquidBeamAction = class("BtShootLiquidBeamAction", "BtNode")
local STATES = table.index_lookup_table("passive", "aiming", "shooting")

BtShootLiquidBeamAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	behavior_component.move_state = "attacking"
	scratchpad.behavior_component = behavior_component
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	local nav_world = navigation_extension:nav_world()
	scratchpad.nav_world = nav_world
	scratchpad.navigation_extension = navigation_extension
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")
	scratchpad.perception_component = Blackboard.write_component(blackboard, "perception")
	local aim_component = Blackboard.write_component(blackboard, "aim")
	scratchpad.aim_component = aim_component

	MinionAttack.init_scratchpad_shooting_variables(unit, scratchpad, action_data, blackboard, breed)

	local rotation_speed = action_data.rotation_speed

	if rotation_speed then
		local current_rotation_speed = locomotion_extension:rotation_speed()
		scratchpad.original_rotation_speed = current_rotation_speed

		locomotion_extension:set_rotation_speed(rotation_speed)
	end

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

BtShootLiquidBeamAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	self:_stop_liquid_beam(unit, scratchpad, blackboard)

	local aim_component = scratchpad.aim_component
	aim_component.controlled_aiming = false
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	behavior_component.move_state = "idle"
	local is_anim_driven = scratchpad.is_anim_driven

	if is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	if scratchpad.original_rotation_speed then
		scratchpad.locomotion_extension:set_rotation_speed(scratchpad.original_rotation_speed)
	end
end

BtShootLiquidBeamAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit
	local shoot_state = scratchpad.shoot_state

	if shoot_state == "aiming" then
		local done = self:_update_aiming(unit, t, dt, scratchpad, action_data)

		if done then
			return "done"
		end
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

				return "running"
			else
				return "done"
			end
		end
	elseif shoot_state == "ending" then
		if scratchpad.end_duration <= t then
			return "done"
		else
			return "running"
		end
	end

	local target_position = POSITION_LOOKUP[target_unit]
	local self_position = POSITION_LOOKUP[unit]
	local distance_to_target = Vector3.distance(self_position, target_position)

	if action_data.range < distance_to_target or distance_to_target < action_data.min_range then
		return "done"
	end

	return "running"
end

local MAX_AIM_DURATION = 2

BtShootLiquidBeamAction._start_aiming = function (self, unit, t, scratchpad, action_data)
	scratchpad.aim_component.controlled_aiming = true
	local aim_anim_events = action_data.aim_anim_events or "aim"
	local aim_event = Animation.random_event(aim_anim_events)

	scratchpad.animation_extension:anim_event(aim_event)

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

	if action_data.aim_rotation_anims then
		MinionMovement.set_anim_driven(scratchpad, true)

		scratchpad.current_aim_rotation_direction_name = "fwd"
	end

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

BtShootLiquidBeamAction._update_aim_turning = function (self, unit, scratchpad, action_data, aim_dot, flat_to_target, aim_rotation_anims)
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

BtShootLiquidBeamAction._rotate_towards_target_unit = function (self, unit, scratchpad)
	local target_unit = scratchpad.perception_component.target_unit
	local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

	scratchpad.locomotion_extension:set_wanted_rotation(flat_rotation)

	return flat_rotation
end

BtShootLiquidBeamAction._update_aiming = function (self, unit, t, dt, scratchpad, action_data)
	local aim_pos = self:_get_from_shoot_pos(unit, scratchpad, action_data)

	scratchpad.aim_component.controlled_aim_position:store(aim_pos)
	self:_set_game_object_field(scratchpad, "aim_position", aim_pos)

	local from_position = self:_get_from_position(unit, scratchpad, action_data)

	self:_update_liquid_beam_positions(dt, scratchpad, action_data, from_position, aim_pos)

	local _, aim_dot, flat_to_target = MinionAttack.aim_at_target(unit, scratchpad, t, action_data)
	local aim_rotation_anims = action_data.aim_rotation_anims
	local is_facing_target = self:_update_aim_turning(unit, scratchpad, action_data, aim_dot, flat_to_target, aim_rotation_anims)
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

BtShootLiquidBeamAction._start_shooting = function (self, unit, t, scratchpad, action_data)
	MinionAttack.start_shooting(unit, scratchpad, t, action_data, FIRST_SHOOT_TIMING)

	scratchpad.shoot_state = "shooting"
	local liquid_paint_id_from_component = action_data.liquid_paint_id_from_component

	if liquid_paint_id_from_component then
		local behavior_component = scratchpad.behavior_component

		if behavior_component[liquid_paint_id_from_component] == 0 then
			behavior_component[liquid_paint_id_from_component] = LiquidArea.start_paint()
		end
	else
		scratchpad.liquid_paint_id = LiquidArea.start_paint()
	end

	local unit_position = POSITION_LOOKUP[unit]
	local shot_from, distance_to_from = self:_get_from_shoot_pos(unit, scratchpad, action_data)
	local distance = Vector3.distance(unit_position, shot_from)
	local place_liquid_timing = t + distance / action_data.place_liquid_timing_speed
	scratchpad.place_liquid_timing = place_liquid_timing
	scratchpad.distance_to_from = distance_to_from

	self:_set_game_object_field(scratchpad, "state", STATES.shooting)

	if action_data.aoe_bot_threat_timing then
		scratchpad.aoe_bot_threat_timing = t + action_data.aoe_bot_threat_timing
	end
end

local AIM_DOT_THRESHOLD = 0

BtShootLiquidBeamAction._update_shooting = function (self, unit, t, dt, scratchpad, action_data)
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
			local perception_component = scratchpad.perception_component
			local target_unit = perception_component.target_unit
			local group_extension = ScriptUnit.extension(target_unit, "group_system")
			local bot_group = group_extension:bot_group()
			local aoe_bot_threat_size = action_data.aoe_bot_threat_size:unbox()

			bot_group:aoe_threat_created(target_position, "oobb", aoe_bot_threat_size, Quaternion.look(flat_to_target_direction), action_data.aoe_bot_threat_duration)

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

BtShootLiquidBeamAction._update_shooting_liquid_beam = function (self, unit, t, dt, scratchpad, action_data)
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

	if end_position and scratchpad.place_liquid_timing < t then
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

		LiquidArea.paint(liquid_paint_id, max_liquid_paint_distance, liquid_position, nav_world, liquid_area_template, allow_liquid_unit_creation, liquid_paint_brush_size, not_on_other_liquids, source_unit)

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

BtShootLiquidBeamAction._update_liquid_beam_positions = function (self, dt, scratchpad, action_data, from_position, to_position)
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

BtShootLiquidBeamAction._start_effect_template = function (self, unit, scratchpad, action_data)
	local effect_template = action_data.effect_template
	local fx_system = scratchpad.fx_system
	local liquid_beam_effect_id = fx_system:start_template_effect(effect_template, unit)
	scratchpad.liquid_beam_effect_id = liquid_beam_effect_id
end

BtShootLiquidBeamAction._stop_effect_template = function (self, scratchpad)
	local liquid_beam_effect_id = scratchpad.liquid_beam_effect_id

	if liquid_beam_effect_id then
		local fx_system = scratchpad.fx_system

		fx_system:stop_template_effect(liquid_beam_effect_id)

		scratchpad.liquid_beam_effect_id = nil
	end
end

BtShootLiquidBeamAction._set_game_object_field = function (self, scratchpad, key, value)
	local spawn_component = scratchpad.spawn_component
	local game_session = spawn_component.game_session
	local game_object_id = spawn_component.game_object_id

	GameSession.set_game_object_field(game_session, game_object_id, key, value)
end

BtShootLiquidBeamAction._get_from_shoot_pos = function (self, unit, scratchpad, action_data)
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

BtShootLiquidBeamAction._get_to_shoot_pos = function (self, unit, scratchpad, action_data)
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

BtShootLiquidBeamAction._ray_cast = function (self, physics_world, from, direction, distance, action_data)
	local collision_filter = action_data.collision_filter
	local _, hit_position, hit_distance, normal, _ = PhysicsWorld.raycast(physics_world, from, direction, distance, "closest", "collision_filter", collision_filter)

	return hit_position, hit_distance, normal
end

local IMPACT_FX_DATA = {}
local INDEX_ACTOR = 4

BtShootLiquidBeamAction._shoot_sphere_cast = function (self, unit, t, shoot_position, scratchpad, action_data)
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

BtShootLiquidBeamAction._try_get_trajectory = function (self, scratchpad, action_data, from_position, to_position)
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

BtShootLiquidBeamAction._get_from_position = function (self, unit, scratchpad, action_data)
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

BtShootLiquidBeamAction._calculate_control_points = function (self, scratchpad, segments, total_length, dt)
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

BtShootLiquidBeamAction._stop_liquid_beam = function (self, unit, scratchpad, blackboard)
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

return BtShootLiquidBeamAction
