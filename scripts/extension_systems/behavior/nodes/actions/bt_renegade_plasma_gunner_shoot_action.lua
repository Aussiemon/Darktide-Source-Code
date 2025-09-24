-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_renegade_plasma_gunner_shoot_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local AttackIntensity = require("scripts/utilities/attack_intensity")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Dodge = require("scripts/extension_systems/character_state_machine/character_states/utilities/dodge")
local MinionAttack = require("scripts/utilities/minion_attack")
local MinionBackstabSettings = require("scripts/settings/minion_backstab/minion_backstab_settings")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionPerception = require("scripts/utilities/minion_perception")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local Vo = require("scripts/utilities/vo")
local attack_types = AttackSettings.attack_types
local default_backstab_ranged_dot = MinionBackstabSettings.ranged_backstab_dot
local default_backstab_ranged_event = MinionBackstabSettings.ranged_backstab_event
local BtRenegadePlasmaShocktrooperShootAction = class("BtRenegadePlasmaShocktrooperShootAction", "BtNode")

BtRenegadePlasmaShocktrooperShootAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local perception_component = Blackboard.write_component(blackboard, "perception")
	local spawn_component = blackboard.spawn

	scratchpad.perception_component = perception_component
	scratchpad.spawn_component = spawn_component
	scratchpad.world = spawn_component.world
	scratchpad.physics_world = spawn_component.physics_world

	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	behavior_component.move_state = "attacking"
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.fx_extension = ScriptUnit.extension(unit, "fx_system")
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")

	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local weapon_item = visual_loadout_extension:slot_item(action_data.inventory_slot)

	scratchpad.weapon_item = weapon_item

	local aim_node_name = breed.aim_config.node
	local forward = Quaternion.forward(Unit.local_rotation(unit, 1))
	local position = Unit.world_position(unit, Unit.node(unit, aim_node_name))
	local from = position
	local to = position + forward
	local max_distance = action_data.max_distance
	local _, start_aim_position = self:_ray_cast(scratchpad, from, to, max_distance)

	scratchpad.current_aim_position = Vector3Box(start_aim_position)

	local game_session, game_object_id = spawn_component.game_session, spawn_component.game_object_id

	GameSession.set_game_object_field(game_session, game_object_id, "laser_aim_position", start_aim_position)

	scratchpad.shots_fired = 0
	scratchpad.aim_node_name = aim_node_name

	local aim_component = Blackboard.write_component(blackboard, "aim")

	scratchpad.aim_component = aim_component

	local fx_system = Managers.state.extension:system("fx_system")

	scratchpad.fx_system = fx_system
	scratchpad.hit_distance_check_timer = t + 0.5

	self:_start_aiming(unit, t, scratchpad, action_data)
end

BtRenegadePlasmaShocktrooperShootAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local aim_component = scratchpad.aim_component

	aim_component.controlled_aiming = false

	if scratchpad.global_effect_id then
		scratchpad.fx_system:stop_template_effect(scratchpad.global_effect_id)
	end

	if scratchpad.perception_component.lock_target then
		MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)
	end

	if scratchpad.before_shoot_global_effect_id then
		scratchpad.fx_system:stop_template_effect(scratchpad.before_shoot_global_effect_id)

		scratchpad.before_shoot_global_effect_id = nil
	end
end

BtRenegadePlasmaShocktrooperShootAction.init_values = function (self, blackboard, action_data, node_data)
	local perception_component = Blackboard.write_component(blackboard, "perception")

	perception_component.has_good_last_los_position = false
end

BtRenegadePlasmaShocktrooperShootAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local is_anim_rotation_driven = scratchpad.is_anim_rotation_driven

	if is_anim_rotation_driven and scratchpad.start_rotation_timing and t >= scratchpad.start_rotation_timing then
		local destination = POSITION_LOOKUP[scratchpad.perception_component.target_unit]
		local ignore_set_anim_driven = true

		MinionMovement.update_anim_driven_start_rotation(unit, scratchpad, action_data, t, destination, ignore_set_anim_driven)
		MinionMovement.set_anim_rotation(unit, scratchpad)
	elseif is_anim_rotation_driven and not scratchpad.start_rotation_timing then
		MinionMovement.set_anim_rotation_driven(scratchpad, false)
	end

	local shoot_state = scratchpad.shoot_state

	if shoot_state == "aiming" and not is_anim_rotation_driven then
		self:_update_aiming(unit, t, dt, scratchpad, action_data)
	elseif shoot_state == "shooting" then
		self:_update_shooting(unit, t, dt, scratchpad, action_data)
	elseif shoot_state == "cooldown" then
		self:_update_cooldown(unit, t, dt, scratchpad, action_data)
	end

	return "running", scratchpad.should_reevaluate
end

BtRenegadePlasmaShocktrooperShootAction._start_aiming = function (self, unit, t, scratchpad, action_data)
	local shoot_turn_anims = action_data.shoot_turn_anims
	local rotation = Unit.local_rotation(unit, 1)
	local forward = Quaternion.forward(rotation)
	local right = Quaternion.right(rotation)
	local position = POSITION_LOOKUP[unit]
	local target_position = POSITION_LOOKUP[scratchpad.perception_component.target_unit]
	local direction = Vector3.flat(Vector3.normalize(target_position - position))
	local relative_direction_name = MinionMovement.get_relative_direction_name(right, forward, direction)
	local turn_anim_events = shoot_turn_anims[relative_direction_name]
	local triggered_turn_anim = false

	if turn_anim_events then
		local turn_anim_event = Animation.random_event(turn_anim_events)
		local start_move_rotation_timings = action_data.start_move_rotation_timings
		local start_rotation_timing = start_move_rotation_timings[turn_anim_event]

		scratchpad.start_rotation_timing = t + start_rotation_timing
		scratchpad.move_start_anim_event_name = turn_anim_event
		scratchpad.current_aim_anim_event = turn_anim_event

		MinionMovement.set_anim_rotation_driven(scratchpad, true)
		scratchpad.animation_extension:anim_event(turn_anim_event)

		triggered_turn_anim = true
	end

	if not triggered_turn_anim then
		local aim_anim_events = action_data.aim_anim_events
		local aim_event = Animation.random_event(aim_anim_events)

		if scratchpad.current_aim_anim_event ~= aim_event then
			scratchpad.animation_extension:anim_event(aim_event)

			scratchpad.current_aim_anim_event = aim_event
		end
	end

	local aim_durations = action_data.aim_duration[scratchpad.current_aim_anim_event]
	local aim_duration = math.random_range(aim_durations[1], aim_durations[2])

	scratchpad.shoot_state = "aiming"
	scratchpad.aim_duration = t + aim_duration

	local perception_component = scratchpad.perception_component
	local has_line_of_sight = perception_component.has_line_of_sight

	if has_line_of_sight then
		local target_unit = scratchpad.perception_component.target_unit

		AttackIntensity.add_intensity(target_unit, action_data.attack_intensities)
		AttackIntensity.set_attacked(target_unit)
	end
end

BtRenegadePlasmaShocktrooperShootAction._update_aiming = function (self, unit, t, dt, scratchpad, action_data)
	local target_is_in_sight, aim_position = self:_aim(unit, t, dt, scratchpad, action_data)

	if scratchpad.shoot_at_t then
		if t >= scratchpad.shoot_at_t then
			self:_start_shooting(unit, t, scratchpad, action_data)

			if scratchpad.before_shoot_global_effect_id then
				scratchpad.fx_system:stop_template_effect(scratchpad.before_shoot_global_effect_id)

				scratchpad.before_shoot_global_effect_id = nil
			end

			if scratchpad.global_effect_id then
				scratchpad.fx_system:stop_template_effect(scratchpad.global_effect_id)

				scratchpad.global_effect_id = nil
			end

			scratchpad.shoot_at_t = nil
		elseif scratchpad.next_threat_timing and t > scratchpad.next_threat_timing then
			local perception_component = scratchpad.perception_component

			self:_create_bot_threat(unit, perception_component.target_unit)

			scratchpad.next_threat_timing = nil
		end
	elseif target_is_in_sight then
		local fx_system = scratchpad.fx_system
		local scope_reflection_timing_effect_template = action_data.scope_reflection_timing_effect_template
		local target_unit = scratchpad.perception_component.target_unit

		if scope_reflection_timing_effect_template then
			scratchpad.before_shoot_global_effect_id = fx_system:start_template_effect(scope_reflection_timing_effect_template, unit)
		end

		if not scratchpad.global_effect_id then
			scratchpad.global_effect_id = fx_system:start_template_effect(action_data.effect_template, unit)
		end

		MinionPerception.set_target_lock(unit, scratchpad.perception_component, true)

		local ignore_attack_intensity = true
		local wwise_event = action_data.backstab_event or default_backstab_ranged_event
		local dot_threshold = action_data.backstab_dot or default_backstab_ranged_dot

		MinionAttack.check_and_trigger_backstab_sound(unit, action_data, target_unit, wwise_event, dot_threshold, ignore_attack_intensity)

		scratchpad.scope_reflection_timing = nil

		local extra_timing = 0
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local player = player_unit_spawn_manager:owner(target_unit)

		if player and player.remote then
			extra_timing = player:lag_compensation_rewind_s()
		end

		scratchpad.dodge_window = t + action_data.scope_reflection_timing_before_shooting + extra_timing
		scratchpad.shoot_at_t = scratchpad.dodge_window
		scratchpad.next_threat_timing = scratchpad.shoot_at_t - 0.4
		scratchpad.aim_component.controlled_aiming = true

		scratchpad.aim_component.controlled_aim_position:store(aim_position)
	end
end

BtRenegadePlasmaShocktrooperShootAction._aim = function (self, unit, t, dt, scratchpad, action_data)
	local target_unit = scratchpad.perception_component.target_unit
	local perception_extension = scratchpad.perception_extension
	local has_line_of_sight = scratchpad.perception_component.has_line_of_sight
	local shoot_node_position = Unit.world_position(target_unit, Unit.node(target_unit, scratchpad.aim_node_name))
	local stored_target_position = scratchpad.stored_target_position and scratchpad.stored_target_position:unbox()
	local last_los_position = stored_target_position or has_line_of_sight and shoot_node_position or perception_extension:last_los_position(target_unit)

	if not last_los_position then
		return
	end

	if scratchpad.dodge_window and t < scratchpad.dodge_window then
		local is_dodging = Dodge.is_dodging(target_unit, attack_types.ranged)

		if is_dodging then
			scratchpad.stored_target_position = Vector3Box(last_los_position)
			scratchpad.dodge_window = nil
		end
	end

	local weapon_item = scratchpad.weapon_item
	local fx_source_name = action_data.fx_source_name
	local attachment_unit, node = MinionVisualLoadout.attachment_unit_and_node_from_node_name(weapon_item, fx_source_name)
	local unit_position = Unit.world_position(attachment_unit, node)
	local to_target = last_los_position - unit_position
	local to_target_direction = Vector3.normalize(to_target)
	local flat_to_target_direction = Vector3.flat(to_target_direction)
	local unit_rotation = Unit.local_rotation(unit, 1)
	local unit_forward = Quaternion.forward(unit_rotation)
	local dot = Vector3.dot(unit_forward, flat_to_target_direction)

	if dot < 0 then
		local wanted_rotation = Quaternion.look(flat_to_target_direction)

		scratchpad.locomotion_extension:set_wanted_rotation(wanted_rotation)
	end

	local current_aim_position = scratchpad.current_aim_position:unbox()
	local aim_to_target_distance = Vector3.distance(last_los_position, current_aim_position)
	local lock_to_target_distance = action_data.lock_to_target_distance
	local locked_to_target = aim_to_target_distance < lock_to_target_distance

	if locked_to_target and not scratchpad.locked_to_target then
		scratchpad.locked_to_target = true
	elseif scratchpad.locked_to_target then
		local leave_locked_distance = action_data.leave_locked_distance

		if leave_locked_distance < aim_to_target_distance then
			scratchpad.locked_to_target = false
		end
	end

	local lock_to_target_lerp_speed = action_data.lock_to_target_lerp_speed
	local default_lerp_speed = action_data.default_lerp_speed
	local lerp_speed = scratchpad.locked_to_target and lock_to_target_lerp_speed or default_lerp_speed
	local aim_position = Vector3.lerp(current_aim_position, last_los_position, dt * lerp_speed)

	scratchpad.current_aim_position:store(aim_position)
	scratchpad.aim_component.controlled_aim_position:store(aim_position)

	local from = unit_position
	local to = unit_position + Vector3.normalize(aim_position - from)
	local max_distance = action_data.max_distance
	local raycast_hit_target, laser_aim_position, _, hit_distance = self:_ray_cast(scratchpad, from, to, max_distance)

	if hit_distance < 2 and t >= scratchpad.hit_distance_check_timer then
		scratchpad.should_reevaluate = true
	end

	local network_min, network_max = NetworkConstants.min_position, NetworkConstants.max_position

	laser_aim_position[1] = math.clamp(laser_aim_position[1], network_min, network_max)
	laser_aim_position[2] = math.clamp(laser_aim_position[2], network_min, network_max)
	laser_aim_position[3] = math.clamp(laser_aim_position[3], network_min, network_max)

	local spawn_component = scratchpad.spawn_component
	local game_session, game_object_id = spawn_component.game_session, spawn_component.game_object_id

	GameSession.set_game_object_field(game_session, game_object_id, "laser_aim_position", laser_aim_position)

	local target_is_in_sight = has_line_of_sight

	return target_is_in_sight, laser_aim_position
end

BtRenegadePlasmaShocktrooperShootAction._ray_cast = function (self, scratchpad, from, to, distance)
	local target_unit = scratchpad.perception_component.target_unit
	local physics_world = scratchpad.physics_world
	local collision_filter = "filter_minion_shooting_no_friendly_fire"
	local to_target = to - from
	local direction = Vector3.normalize(to_target)
	local from_offset = -direction * 0.75

	from = from + from_offset

	local hit, hit_position, _, _, hit_actor = PhysicsWorld.raycast(physics_world, from, direction, distance, "closest", "collision_filter", collision_filter)
	local target_is_in_sight = false

	if not hit_position then
		hit_position = from + direction * distance
	elseif hit_actor then
		local hit_target = Actor.unit(hit_actor)

		if hit_target == target_unit then
			target_is_in_sight = true
		end
	end

	local hit_distance = Vector3.length(hit_position - from)

	return target_is_in_sight, hit_position, hit, hit_distance
end

BtRenegadePlasmaShocktrooperShootAction._start_shooting = function (self, unit, t, scratchpad, action_data)
	scratchpad.shoot_state = "shooting"
	scratchpad.next_shoot_timing = t

	local num_shots = action_data.num_shots

	scratchpad.num_shots = type(num_shots) == "table" and math.random(num_shots[1], num_shots[2]) or num_shots

	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit
	local perception_extension = scratchpad.perception_extension

	perception_extension:alert_nearby_allies(target_unit, 20)
end

BtRenegadePlasmaShocktrooperShootAction._update_shooting = function (self, unit, t, dt, scratchpad, action_data)
	self:_aim(unit, t, dt, scratchpad, action_data)

	if t > scratchpad.next_shoot_timing then
		local time_per_shot = action_data.time_per_shot

		time_per_shot = type(time_per_shot) == "table" and math.random_range(time_per_shot[1], time_per_shot[2]) or time_per_shot

		MinionAttack.shoot(unit, scratchpad, action_data)

		scratchpad.shots_fired = scratchpad.shots_fired + 1
		scratchpad.dodge_window = nil
		scratchpad.stored_target_position = nil

		if scratchpad.shots_fired >= scratchpad.num_shots then
			scratchpad.shots_fired = 0

			self:_start_cooldown(unit, t, scratchpad, action_data)

			scratchpad.sound_event_triggered = nil
		end

		scratchpad.next_shoot_timing = t + time_per_shot
	end
end

BtRenegadePlasmaShocktrooperShootAction._start_cooldown = function (self, unit, t, scratchpad, action_data)
	MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)

	local cooldown_range = action_data.shoot_cooldown
	local cooldown = math.random_range(cooldown_range[1], cooldown_range[2])

	scratchpad.cooldown = t + cooldown
	scratchpad.shoot_state = "cooldown"
end

BtRenegadePlasmaShocktrooperShootAction._update_cooldown = function (self, unit, t, dt, scratchpad, action_data)
	self:_aim(unit, t, dt, scratchpad, action_data)

	if t > scratchpad.cooldown then
		self:_start_aiming(unit, t, scratchpad, action_data)

		local perception_component = scratchpad.perception_component
		local has_line_of_sight = perception_component.has_line_of_sight

		if has_line_of_sight then
			local target_distance = perception_component.target_distance

			scratchpad.should_reevaluate = target_distance <= action_data.after_shoot_reevaluate_distance
		end
	end
end

local BOT_THREAT_WIDTH = 3
local BOT_THREAT_RANGE = 4
local BOT_THREAT_HEIGHT = 2
local BOT_THREAT_DURATION = 1.5

BtRenegadePlasmaShocktrooperShootAction._create_bot_threat = function (self, unit, target_unit)
	local target_position = POSITION_LOOKUP[target_unit]
	local width, range, height = BOT_THREAT_WIDTH, BOT_THREAT_RANGE, BOT_THREAT_HEIGHT
	local half_width, half_range, half_height = width * 0.5, range * 0.5, height * 0.5
	local hit_size = Vector3(half_width, half_range, half_height)
	local to_target_position = Vector3.normalize(target_position - POSITION_LOOKUP[unit])
	local rotation = Quaternion.look(to_target_position)
	local up = Quaternion.up(rotation)
	local position = target_position + up * half_height
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]
	local enemy_sides = side:relation_sides("enemy")
	local group_system = Managers.state.extension:system("group_system")
	local bot_groups = group_system:bot_groups_from_sides(enemy_sides)
	local num_bot_groups = #bot_groups

	for i = 1, num_bot_groups do
		local bot_group = bot_groups[i]

		bot_group:aoe_threat_created(position, "oobb", hit_size, rotation, BOT_THREAT_DURATION)
	end
end

return BtRenegadePlasmaShocktrooperShootAction
