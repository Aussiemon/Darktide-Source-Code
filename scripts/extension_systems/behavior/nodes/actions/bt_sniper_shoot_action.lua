require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local AttackIntensity = require("scripts/utilities/attack_intensity")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Dodge = require("scripts/extension_systems/character_state_machine/character_states/utilities/dodge")
local MinionAttack = require("scripts/utilities/minion_attack")
local MinionBackstabSettings = require("scripts/settings/minion_backstab/minion_backstab_settings")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local MinionPerception = require("scripts/utilities/minion_perception")
local Vo = require("scripts/utilities/vo")
local attack_types = AttackSettings.attack_types
local default_backstab_ranged_dot = MinionBackstabSettings.ranged_backstab_dot
local default_backstab_ranged_event = MinionBackstabSettings.ranged_backstab_event
local BtSniperShootAction = class("BtSniperShootAction", "BtNode")

BtSniperShootAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
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
	local game_session = spawn_component.game_session
	local game_object_id = spawn_component.game_object_id

	GameSession.set_game_object_field(game_session, game_object_id, "laser_aim_position", start_aim_position)

	scratchpad.shots_fired = 0
	scratchpad.aim_node_name = aim_node_name
	local aim_component = Blackboard.write_component(blackboard, "aim")
	scratchpad.aim_component = aim_component
	aim_component.controlled_aiming = true

	aim_component.controlled_aim_position:store(start_aim_position)

	local fx_system = Managers.state.extension:system("fx_system")
	scratchpad.fx_system = fx_system
	scratchpad.global_effect_id = fx_system:start_template_effect(action_data.effect_template, unit)
	scratchpad.hit_distance_check_timer = t + 0.5

	self:_start_aiming(unit, t, scratchpad, action_data)
end

BtSniperShootAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local aim_component = scratchpad.aim_component
	aim_component.controlled_aiming = false

	scratchpad.fx_system:stop_template_effect(scratchpad.global_effect_id)

	if scratchpad.perception_component.lock_target then
		MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)
	end
end

BtSniperShootAction.init_values = function (self, blackboard, action_data, node_data)
	local perception_component = Blackboard.write_component(blackboard, "perception")
	perception_component.has_good_last_los_position = false
end

BtSniperShootAction._calculate_aim_animation_type = function (self, unit, scratchpad, action_data)
	local perception_extension = scratchpad.perception_extension
	local target_unit = scratchpad.perception_component.target_unit
	local last_los_position = perception_extension:last_los_position(target_unit) or POSITION_LOOKUP[target_unit]
	local position = Unit.world_position(unit, Unit.node(unit, scratchpad.aim_node_name)) - Vector3.up() * 0.5
	local forward = Vector3.normalize(last_los_position - position)
	local from = position
	local to = position + forward
	local max_distance = action_data.max_distance
	local target_is_in_sight = self:_ray_cast(scratchpad, from, to, max_distance)

	if target_is_in_sight then
		return "crouching"
	else
		return "standing"
	end
end

BtSniperShootAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local perception_component = scratchpad.perception_component
	local has_line_of_sight = perception_component.has_line_of_sight
	local should_reevaluate = false

	if not has_line_of_sight then
		if not scratchpad.reconsider_position_duration then
			local reconsider_position_duration = action_data.reconsider_position_duration
			scratchpad.reconsider_position_duration = t + reconsider_position_duration
		else
			local reconsider_position_duration = scratchpad.reconsider_position_duration

			if reconsider_position_duration < t then
				scratchpad.reconsider_position_duration = nil
				should_reevaluate = true
			end
		end

		local lost_los_timer = scratchpad.lost_los_timer

		if lost_los_timer then
			scratchpad.lost_los_timer = lost_los_timer + dt

			if action_data.lost_los_fail_duration <= scratchpad.lost_los_timer then
				return "done"
			end
		else
			scratchpad.lost_los_timer = 0
		end
	end

	local shoot_state = scratchpad.shoot_state

	if shoot_state == "aiming" then
		self:_update_aiming(unit, t, dt, scratchpad, action_data)
	elseif shoot_state == "shooting" then
		self:_update_shooting(unit, t, dt, scratchpad, action_data)
	elseif shoot_state == "cooldown" then
		self:_update_cooldown(unit, t, dt, scratchpad, action_data)
	end

	return "running", should_reevaluate or scratchpad.should_reevaluate
end

BtSniperShootAction._start_aiming = function (self, unit, t, scratchpad, action_data)
	local aim_type = self:_calculate_aim_animation_type(unit, scratchpad, action_data)
	local aim_anim_events = action_data.aim_anim_events[aim_type]
	local aim_event = Animation.random_event(aim_anim_events)

	if scratchpad.current_aim_anim_event ~= aim_event then
		scratchpad.animation_extension:anim_event(aim_event)

		scratchpad.current_aim_anim_event = aim_event
	end

	local aim_durations = action_data.aim_duration[scratchpad.current_aim_anim_event]
	local aim_duration = math.random_range(aim_durations[1], aim_durations[2])
	scratchpad.shoot_state = "aiming"
	scratchpad.aim_duration = t + aim_duration
	scratchpad.target_is_in_sight_duration = 0
	local scope_reflection_timing_before_shooting = action_data.scope_reflection_timing_before_shooting

	if scope_reflection_timing_before_shooting then
		scratchpad.scope_reflection_timing = scratchpad.aim_duration - scope_reflection_timing_before_shooting
	end

	local perception_component = scratchpad.perception_component
	local has_line_of_sight = perception_component.has_line_of_sight

	if has_line_of_sight then
		local target_unit = scratchpad.perception_component.target_unit

		AttackIntensity.add_intensity(target_unit, action_data.attack_intensities)
		AttackIntensity.set_attacked(target_unit)
		Vo.player_enemy_alert_event(target_unit, "renegade_sniper", "sniper_aiming")
	end
end

BtSniperShootAction._update_aiming = function (self, unit, t, dt, scratchpad, action_data)
	local target_is_in_sight = self:_aim(unit, t, dt, scratchpad, action_data)

	if scratchpad.scope_reflection_timing and t < scratchpad.scope_reflection_timing then
		return
	end

	local target_is_in_sight_duration = scratchpad.target_is_in_sight_duration
	local spawn_component = scratchpad.spawn_component
	local game_session = spawn_component.game_session
	local game_object_id = spawn_component.game_object_id
	local in_sight_duration = math.clamp(scratchpad.target_is_in_sight_duration, 0, 1)

	GameSession.set_game_object_field(game_session, game_object_id, "in_sight_duration", in_sight_duration)

	if scratchpad.shoot_at_t then
		if scratchpad.shoot_at_t <= t then
			self:_start_shooting(unit, t, scratchpad, action_data)

			scratchpad.shoot_at_t = nil
		elseif scratchpad.next_threat_timing and scratchpad.next_threat_timing < t then
			local perception_component = scratchpad.perception_component

			self:_create_bot_threat(unit, perception_component.target_unit)

			scratchpad.next_threat_timing = nil
		end
	elseif target_is_in_sight then
		if not target_is_in_sight_duration then
			scratchpad.target_is_in_sight_duration = 0
		else
			scratchpad.target_is_in_sight_duration = target_is_in_sight_duration + dt
			local in_sight_duration_shoot_requirement = Managers.state.difficulty:get_table_entry_by_challenge(action_data.in_sight_duration_shoot_requirement)

			if scratchpad.target_is_in_sight_duration < in_sight_duration_shoot_requirement then
				return
			end

			local shoot_template = action_data.shoot_template
			local scope_reflection_vfx_name = shoot_template.scope_reflection_vfx_name
			local fx_system = scratchpad.fx_system
			local weapon_item = scratchpad.weapon_item
			local fx_source_name = action_data.fx_source_name
			local attachment_unit, node = MinionVisualLoadout.attachment_unit_and_node_from_node_name(weapon_item, fx_source_name)
			local source_position = Unit.world_position(attachment_unit, node)
			local source_rotation = Unit.world_rotation(attachment_unit, node)

			fx_system:trigger_vfx(scope_reflection_vfx_name, source_position, source_rotation)

			local scope_reflection_timing_sfx = action_data.scope_reflection_timing_sfx
			local target_unit = scratchpad.perception_component.target_unit

			if scope_reflection_timing_sfx then
				local is_ranged_attack = true

				scratchpad.fx_extension:trigger_inventory_wwise_event(scope_reflection_timing_sfx, action_data.inventory_slot, fx_source_name, target_unit, is_ranged_attack)
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
		end
	elseif target_is_in_sight_duration then
		scratchpad.target_is_in_sight_duration = 0
	end
end

BtSniperShootAction._aim = function (self, unit, t, dt, scratchpad, action_data)
	local target_unit = scratchpad.perception_component.target_unit
	local perception_extension = scratchpad.perception_extension
	local has_line_of_sight = scratchpad.perception_component.has_line_of_sight
	local shoot_node_position = Unit.world_position(target_unit, Unit.node(target_unit, scratchpad.aim_node_name))
	local stored_target_position = scratchpad.stored_target_position and scratchpad.stored_target_position:unbox()
	local last_los_position = stored_target_position or has_line_of_sight and shoot_node_position or perception_extension:last_los_position(target_unit)

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

	if hit_distance < 2 and scratchpad.hit_distance_check_timer <= t then
		scratchpad.should_reevaluate = true
	end

	local network_min = NetworkConstants.min_position
	local network_max = NetworkConstants.max_position
	laser_aim_position[1] = math.clamp(laser_aim_position[1], network_min, network_max)
	laser_aim_position[2] = math.clamp(laser_aim_position[2], network_min, network_max)
	laser_aim_position[3] = math.clamp(laser_aim_position[3], network_min, network_max)
	local spawn_component = scratchpad.spawn_component
	local game_session = spawn_component.game_session
	local game_object_id = spawn_component.game_object_id

	GameSession.set_game_object_field(game_session, game_object_id, "laser_aim_position", laser_aim_position)

	local target_is_in_sight = has_line_of_sight and (raycast_hit_target or locked_to_target)

	return target_is_in_sight
end

BtSniperShootAction._ray_cast = function (self, scratchpad, from, to, distance)
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

BtSniperShootAction._start_shooting = function (self, unit, t, scratchpad, action_data)
	scratchpad.shoot_state = "shooting"
	scratchpad.next_shoot_timing = t
	local num_shots = action_data.num_shots
	scratchpad.num_shots = type(num_shots) == "table" and math.random(num_shots[1], num_shots[2]) or num_shots
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit
	local perception_extension = scratchpad.perception_extension

	perception_extension:alert_nearby_allies(target_unit, 20)

	scratchpad.target_is_in_sight_duration = 0
	local spawn_component = scratchpad.spawn_component
	local game_session = spawn_component.game_session
	local game_object_id = spawn_component.game_object_id

	GameSession.set_game_object_field(game_session, game_object_id, "in_sight_duration", 0)
end

BtSniperShootAction._update_shooting = function (self, unit, t, dt, scratchpad, action_data)
	self:_aim(unit, t, dt, scratchpad, action_data)

	if scratchpad.next_shoot_timing < t then
		local time_per_shot = action_data.time_per_shot

		if type(time_per_shot) == "table" then
			time_per_shot = math.random_range(time_per_shot[1], time_per_shot[2]) or time_per_shot
		end

		MinionAttack.shoot(unit, scratchpad, action_data)

		scratchpad.shots_fired = scratchpad.shots_fired + 1
		scratchpad.dodge_window = nil
		scratchpad.stored_target_position = nil

		if scratchpad.num_shots <= scratchpad.shots_fired then
			scratchpad.shots_fired = 0

			self:_start_cooldown(unit, t, scratchpad, action_data)

			scratchpad.sound_event_triggered = nil
		end

		scratchpad.next_shoot_timing = t + time_per_shot
	end
end

BtSniperShootAction._start_cooldown = function (self, unit, t, scratchpad, action_data)
	MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)

	local cooldown_range = action_data.shoot_cooldown
	local cooldown = math.random_range(cooldown_range[1], cooldown_range[2])
	scratchpad.cooldown = t + cooldown
	scratchpad.shoot_state = "cooldown"
end

BtSniperShootAction._update_cooldown = function (self, unit, t, dt, scratchpad, action_data)
	self:_aim(unit, t, dt, scratchpad, action_data)

	if scratchpad.cooldown < t then
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

BtSniperShootAction._create_bot_threat = function (self, unit, target_unit)
	local target_position = POSITION_LOOKUP[target_unit]
	local width = BOT_THREAT_WIDTH
	local range = BOT_THREAT_RANGE
	local height = BOT_THREAT_HEIGHT
	local half_width = width * 0.5
	local half_range = range * 0.5
	local half_height = height * 0.5
	local hit_size = Vector3(half_width, half_range, half_height)
	local to_target_position = Vector3.normalize(target_position - POSITION_LOOKUP[unit])
	local rotation = Quaternion.look(to_target_position)
	local up = Quaternion.up(rotation)
	local position = target_position + up * half_height
	local group_extension = ScriptUnit.extension(target_unit, "group_system")
	local bot_group = group_extension:bot_group()

	bot_group:aoe_threat_created(position, "oobb", hit_size, rotation, BOT_THREAT_DURATION)
end

return BtSniperShootAction
