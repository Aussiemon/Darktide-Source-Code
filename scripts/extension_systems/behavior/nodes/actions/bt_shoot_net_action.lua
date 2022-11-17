require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Dodge = require("scripts/extension_systems/character_state_machine/character_states/utilities/dodge")
local MinionAttack = require("scripts/utilities/minion_attack")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionPerception = require("scripts/utilities/minion_perception")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local Vo = require("scripts/utilities/vo")
local BtShootNetAction = class("BtShootNetAction", "BtNode")

BtShootNetAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local spawn_component = blackboard.spawn
	scratchpad.physics_world = spawn_component.physics_world
	scratchpad.spawn_component = spawn_component
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	local perception_component = Blackboard.write_component(blackboard, "perception")
	behavior_component.move_state = "attacking"
	scratchpad.behavior_component = behavior_component
	scratchpad.perception_component = perception_component
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")
	scratchpad.target_dodged_during_attack = false
	scratchpad.target_dodged_type = nil
	scratchpad.dodged_attack = false

	MinionPerception.set_target_lock(unit, perception_component, true)

	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local weapon_item = visual_loadout_extension:slot_item(action_data.inventory_slot)
	scratchpad.weapon_item = weapon_item
	scratchpad.current_aim_position = Vector3Box()
	scratchpad.aim_target_node = breed.aim_config.target_node
	scratchpad.fx_system = Managers.state.extension:system("fx_system")
	scratchpad.fx_extension = ScriptUnit.extension(unit, "fx_system")
	local num_shots = action_data.num_shots
	scratchpad.num_shots = Managers.state.difficulty:get_table_entry_by_challenge(num_shots)
	scratchpad.num_shots_fired = 0

	self:_start_aiming(t, scratchpad, action_data)

	local vo_event = action_data.vo_event

	if vo_event then
		Vo.enemy_vo_event(unit, vo_event)
	end

	behavior_component.hit_target = false
end

BtShootNetAction.init_values = function (self, blackboard, action_data, node_data)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	behavior_component.is_dragging = false
	behavior_component.shoot_net_cooldown = 0
	behavior_component.hit_target = false
end

BtShootNetAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local behavior_component = scratchpad.behavior_component

	if scratchpad.num_shots_fired > 0 then
		local shoot_net_cooldown = action_data.shoot_net_cooldown or Managers.state.difficulty:get_table_entry_by_challenge(MinionDifficultySettings.cooldowns.shoot_net_cooldown)
		behavior_component.shoot_net_cooldown = t + shoot_net_cooldown
	end

	if behavior_component.is_dragging then
		behavior_component.is_dragging = false
		behavior_component.hit_target = true
	end

	self:_stop_effect_template(scratchpad)
	MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)
end

BtShootNetAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local internal_state = scratchpad.internal_state

	if internal_state == "aiming" then
		self:_update_aiming(unit, t, scratchpad, action_data)
	elseif internal_state == "shooting" then
		self:_update_shooting(unit, breed, dt, t, scratchpad, action_data)
	elseif internal_state == "dragging" then
		self:_update_dragging(unit, t, scratchpad, action_data)
	elseif internal_state == "shot_finished" then
		local num_shots_fired = scratchpad.num_shots_fired
		local num_shots = scratchpad.num_shots

		if num_shots_fired < num_shots then
			self:_stop_effect_template(scratchpad)
			self:_start_aiming(t, scratchpad, action_data)
		else
			internal_state = "done"
		end
	end

	if internal_state == "done" then
		return "done"
	end

	return "running"
end

BtShootNetAction._start_aiming = function (self, t, scratchpad, action_data)
	local aim_event = action_data.aim_anim_event

	scratchpad.animation_extension:anim_event(aim_event)
	self:_play_wwise_event(action_data.aim_wwise_event, scratchpad, action_data)

	local aim_duration = action_data.aim_duration
	scratchpad.shoot_t = t + aim_duration
	scratchpad.internal_state = "aiming"

	if action_data.aoe_bot_threat_timing then
		scratchpad.aoe_bot_threat_timing = t + action_data.aoe_bot_threat_timing
	end
end

BtShootNetAction._update_aiming = function (self, unit, t, scratchpad, action_data)
	local target_unit = scratchpad.perception_component.target_unit
	local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

	scratchpad.locomotion_extension:set_wanted_rotation(flat_rotation)

	local aim_target_node = scratchpad.aim_target_node
	local target_node = Unit.node(target_unit, aim_target_node)
	local aim_position = Unit.world_position(target_unit, target_node)

	scratchpad.current_aim_position:store(aim_position)

	if scratchpad.aoe_bot_threat_timing and scratchpad.aoe_bot_threat_timing <= t then
		local group_extension = ScriptUnit.extension(target_unit, "group_system")
		local bot_group = group_extension:bot_group()
		local aoe_bot_threat_size = action_data.aoe_bot_threat_size:unbox()

		bot_group:aoe_threat_created(POSITION_LOOKUP[target_unit], "oobb", aoe_bot_threat_size, flat_rotation, action_data.aoe_bot_threat_duration)

		scratchpad.aoe_bot_threat_timing = nil
	end

	if scratchpad.shoot_t < t then
		self:_start_shooting(unit, scratchpad, action_data)
	end
end

local ALERT_NEARBY_ALLIES_RADIUS = 20

BtShootNetAction._start_shooting = function (self, unit, scratchpad, action_data)
	local target_unit = scratchpad.perception_component.target_unit

	scratchpad.perception_extension:alert_nearby_allies(target_unit, ALERT_NEARBY_ALLIES_RADIUS)

	local shoot_event = action_data.shoot_anim_event

	scratchpad.animation_extension:anim_event(shoot_event)

	local weapon_item = scratchpad.weapon_item
	local fx_source_name = action_data.fx_source_name
	local attachment_unit, node = MinionVisualLoadout.attachment_unit_and_node_from_node_name(weapon_item, fx_source_name)
	local from_position = Unit.world_position(attachment_unit, node)
	local to_position = scratchpad.current_aim_position:unbox()
	local direction = Vector3.normalize(to_position - from_position)
	local max_net_distance = action_data.max_net_distance
	scratchpad.shoot_data = {
		direction = Vector3Box(direction),
		sweep_position = Vector3Box(from_position),
		available_travel_distance = max_net_distance
	}
	local spawn_component = scratchpad.spawn_component
	local game_session = spawn_component.game_session
	local game_object_id = spawn_component.game_object_id

	GameSession.set_game_object_field(game_session, game_object_id, "net_sweep_position", from_position)
	self:_start_effect_template(unit, scratchpad, action_data)
	MinionAttack.trigger_shoot_sfx_and_vfx(unit, scratchpad, action_data)

	scratchpad.internal_state = "shooting"
	scratchpad.num_shots_fired = scratchpad.num_shots_fired + 1
end

BtShootNetAction._update_shooting = function (self, unit, breed, dt, t, scratchpad, action_data)
	local shoot_data = scratchpad.shoot_data
	local wanted_travel_distance = action_data.net_speed * dt
	local available_travel_distance = shoot_data.available_travel_distance
	local travel_distance = math.min(wanted_travel_distance, available_travel_distance)
	local target_unit = scratchpad.perception_component.target_unit
	local is_dodging, dodge_type = Dodge.is_dodging(target_unit)

	if is_dodging and not scratchpad.target_dodged_during_attack then
		scratchpad.target_dodged_during_attack = true
		scratchpad.target_dodged_type = dodge_type
	end

	local old_sweep_position = shoot_data.sweep_position:unbox()
	local direction = shoot_data.direction:unbox()
	local radius = action_data.net_sweep_radius
	local physics_world = scratchpad.physics_world
	local hit_geometry_ray_length = travel_distance + radius
	local hit_geometry = PhysicsWorld.raycast(physics_world, old_sweep_position, direction, hit_geometry_ray_length, "any", "types", "both", "collision_filter", "filter_minion_shooting_geometry")

	if hit_geometry then
		scratchpad.internal_state = "shot_finished"

		return
	end

	local new_available_travel_distance = available_travel_distance - travel_distance
	local new_sweep_position = old_sweep_position + direction * travel_distance
	shoot_data.available_travel_distance = new_available_travel_distance

	shoot_data.sweep_position:store(new_sweep_position)

	if not scratchpad.dodged_attack then
		local target_unit_position = POSITION_LOOKUP[target_unit]
		local to_target = target_unit_position - new_sweep_position
		local direction_to_target = Vector3.normalize(to_target)
		local dot_to_target = Vector3.dot(direction, direction_to_target)

		if dot_to_target < 0 and scratchpad.target_dodged_during_attack then
			dodge_type = scratchpad.target_dodged_type

			Dodge.sucessful_dodge(target_unit, unit, nil, dodge_type, breed)

			scratchpad.dodged_attack = true
		end
	end

	local spawn_component = scratchpad.spawn_component
	local game_session = spawn_component.game_session
	local game_object_id = spawn_component.game_object_id

	GameSession.set_game_object_field(game_session, game_object_id, "net_sweep_position", new_sweep_position)

	local hit_actors, actor_count = PhysicsWorld.immediate_overlap(physics_world, "shape", "sphere", "position", new_sweep_position, "size", radius, "types", "dynamics", "collision_filter", "filter_player_detection")

	if actor_count > 0 then
		local hit_actor = hit_actors[1]
		local hit_unit = Actor.unit(hit_actor)
		local is_valid_hit = self:_evaluate_collision(action_data, hit_unit, new_sweep_position)

		if is_valid_hit then
			self:_start_dragging(unit, t, scratchpad, action_data, hit_unit)
		end
	end

	if new_available_travel_distance <= 0 then
		scratchpad.internal_state = "shot_finished"

		return
	end
end

BtShootNetAction._evaluate_collision = function (self, action_data, hit_unit, new_sweep_position)
	local is_dodging = Dodge.is_dodging(hit_unit)

	if is_dodging then
		local net_dodge_sweep_radius = action_data.net_dodge_sweep_radius
		local hit_unit_position = POSITION_LOOKUP[hit_unit]
		local flat_position = Vector3(hit_unit_position.x, hit_unit_position.y, new_sweep_position.z)
		local distance = Vector3.distance(flat_position, new_sweep_position)

		if net_dodge_sweep_radius < distance then
			return false
		end
	end

	local target_unit_data_extension = ScriptUnit.extension(hit_unit, "unit_data_system")
	local character_state_component = target_unit_data_extension:read_component("character_state")
	local is_disabled = PlayerUnitStatus.is_disabled(character_state_component)

	return not is_disabled
end

BtShootNetAction._start_dragging = function (self, unit, t, scratchpad, action_data, hit_unit)
	local hit_unit_data_extension = ScriptUnit.extension(hit_unit, "unit_data_system")
	local disabled_state_input = hit_unit_data_extension:write_component("disabled_state_input")
	disabled_state_input.wants_disable = true
	disabled_state_input.disabling_unit = unit
	disabled_state_input.disabling_type = "netted"
	local disabled_character_state_component = hit_unit_data_extension:read_component("disabled_character_state")
	scratchpad.hit_unit_disabled_character_state_component = disabled_character_state_component
	local lag_t = self:_get_lag_compensation(hit_unit)
	scratchpad.drag_anim_delay_t = t - lag_t + action_data.drag_anim_delay
	scratchpad.behavior_component.is_dragging = true

	self:_stop_effect_template(scratchpad)

	scratchpad.internal_state = "dragging"
	scratchpad.hit_unit = hit_unit
	local drag_event = action_data.drag_anim_event

	scratchpad.animation_extension:anim_event(drag_event)
end

BtShootNetAction._update_dragging = function (self, unit, t, scratchpad, action_data)
	local disabled_character_state_component = scratchpad.hit_unit_disabled_character_state_component
	local is_netted, netting_unit = PlayerUnitStatus.is_netted(disabled_character_state_component)
	scratchpad.was_netted = scratchpad.was_netted or is_netted

	if netting_unit ~= unit or scratchpad.was_netted and not is_netted then
		scratchpad.internal_state = "shot_finished"

		return
	end

	local drag_anim_exit_t = scratchpad.drag_anim_exit_t

	if drag_anim_exit_t then
		if drag_anim_exit_t < t then
			scratchpad.internal_state = "shot_finished"
			local vo_event = action_data.captured_vo_event

			if vo_event then
				Vo.enemy_vo_event(unit, vo_event)
			end
		end
	elseif scratchpad.drag_anim_delay_t < t then
		scratchpad.drag_anim_exit_t = t + action_data.drag_anim_exit_delay

		self:_play_wwise_event(action_data.drag_wwise_event, scratchpad, action_data)
	end
end

BtShootNetAction._play_wwise_event = function (self, event, scratchpad, action_data)
	local inventory_slot_name = action_data.inventory_slot
	local fx_source_name = action_data.fx_source_name
	local target_unit = scratchpad.perception_component.target_unit
	local is_ranged_attack = true

	scratchpad.fx_extension:trigger_inventory_wwise_event(event, inventory_slot_name, fx_source_name, target_unit, is_ranged_attack)
end

BtShootNetAction._start_effect_template = function (self, unit, scratchpad, action_data)
	local effect_template = action_data.effect_template
	local global_effect_id = scratchpad.fx_system:start_template_effect(effect_template, unit)
	scratchpad.global_effect_id = global_effect_id
end

BtShootNetAction._stop_effect_template = function (self, scratchpad)
	local global_effect_id = scratchpad.global_effect_id

	if global_effect_id then
		scratchpad.fx_system:stop_template_effect(global_effect_id)

		scratchpad.global_effect_id = nil
	end
end

BtShootNetAction._get_lag_compensation = function (self, hit_unit)
	local lag_t = 0
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(hit_unit)

	if player and player.remote then
		lag_t = player:lag_compensation_rewind_s()
	end

	return lag_t
end

return BtShootNetAction
