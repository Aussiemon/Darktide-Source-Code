-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_companion_target_pounced_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local proc_events = BuffSettings.proc_events
local BtCompanionTargetPouncedAction = class("BtCompanionTargetPouncedAction", "BtNode")

BtCompanionTargetPouncedAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	behavior_component.move_state = "attacking"

	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	scratchpad.animation_extension = animation_extension

	local fx_system = Managers.state.extension:system("fx_system")

	scratchpad.fx_system = fx_system
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.start_position_boxed = Vector3Box(POSITION_LOOKUP[unit])
	scratchpad.lerp_position_duration = t + action_data.lerp_position_time

	local pounce_component = Blackboard.write_component(blackboard, "pounce")
	local pounce_target = pounce_component.pounce_target

	scratchpad.pounce_component = pounce_component

	local target_unit_data_extension = ScriptUnit.extension(pounce_target, "unit_data_system")
	local target_unit_breed = target_unit_data_extension:breed()
	local companion_pounce_setting = target_unit_breed.companion_pounce_setting

	scratchpad.companion_pounce_setting = companion_pounce_setting

	local pounce_anim_event = companion_pounce_setting.pounce_anim_event

	animation_extension:anim_event(pounce_anim_event)

	local perception_component = blackboard.perception

	scratchpad.perception_component = perception_component
	scratchpad.attempting_pounce = true

	local damage_dealt, attack_result, damage_efficiency, _, _ = self:_damage_target(unit, pounce_target, action_data, companion_pounce_setting.initial_damage_profile)
	local explosion_template = action_data.enter_explosion_template

	if explosion_template then
		local power_level, charge_level = action_data.explosion_power_level, 1
		local explosion_attack_type = AttackSettings.attack_types.explosion
		local up = Quaternion.up(Unit.local_rotation(unit, 1))
		local explosion_position = POSITION_LOOKUP[unit] + up * 0.1
		local spawn_component = blackboard.spawn
		local world, physics_world = spawn_component.world, spawn_component.physics_world

		Explosion.create_explosion(world, physics_world, explosion_position, up, unit, explosion_template, power_level, charge_level, explosion_attack_type)
	end

	local target_blackboard = BLACKBOARDS[pounce_target]

	scratchpad.target_blackboard = target_blackboard
	scratchpad.target_death_component = target_blackboard.death
	scratchpad.target_disable_component = Blackboard.write_component(target_blackboard, "disable")

	if action_data.effect_template then
		local global_effect_id = fx_system:start_template_effect(action_data.effect_template, unit)

		scratchpad.global_effect_id = global_effect_id
	end

	local attack_direction = Vector3.normalize(Quaternion.forward(Unit.local_rotation(unit, 1)))
	local hit_position = Unit.world_position(unit, Unit.node(unit, pounce_component.leap_node))

	ImpactEffect.play(pounce_target, nil, damage_dealt, "companion_dog_pin", pounce_component.target_hit_zone_name, attack_result, hit_position, nil, attack_direction, unit, nil, nil, nil, damage_efficiency, companion_pounce_setting.initial_damage_profile)
	self:_handle_pounce_enemy_stats(unit, breed, pounce_target, target_unit_breed)
	self:_trigger_pounce_enemy_proc_event(unit, breed, pounce_target, target_unit_breed)
end

BtCompanionTargetPouncedAction.init_values = function (self, blackboard)
	local pounce_component = Blackboard.write_component(blackboard, "pounce")

	pounce_component.pounce_target = nil
	pounce_component.pounce_cooldown = 0
	pounce_component.started_leap = false
	pounce_component.has_pounce_target = false
	pounce_component.use_fast_jump = false
end

BtCompanionTargetPouncedAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local pounce_component = scratchpad.pounce_component
	local pounce_target = pounce_component.pounce_target

	if pounce_target and HEALTH_ALIVE[pounce_target] then
		local token_extension = ScriptUnit.has_extension(pounce_target, "token_system")

		if token_extension then
			local required_token = scratchpad.companion_pounce_setting.required_token

			if token_extension:is_token_free_or_mine(unit, required_token.name) then
				token_extension:free_token(required_token.name)
			end
		end

		if scratchpad.target_disable_component then
			scratchpad.target_disable_component.attacker_unit = nil
		end
	end

	local target_unit_data_extension = ScriptUnit.has_extension(pounce_target, "unit_data_system")
	local target_unit_breed = target_unit_data_extension and target_unit_data_extension:breed()

	self:_trigger_pounce_enemy_finish_proc_event(unit, breed, pounce_target, target_unit_breed, reason)

	pounce_component.pounce_target = nil

	scratchpad.locomotion_extension:set_movement_type("snap_to_navmesh")

	if action_data.effect_template then
		local fx_system = scratchpad.fx_system

		fx_system:stop_template_effect(scratchpad.global_effect_id)
	end
end

BtCompanionTargetPouncedAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local pounce_target = scratchpad.pounce_component.pounce_target

	if scratchpad.attempting_pounce then
		scratchpad.attempting_pounce = false
		scratchpad.target_disable_component.type = "pounced"
		scratchpad.target_disable_component.is_disabled = true
		scratchpad.target_disable_component.attacker_unit = unit
		scratchpad.next_damage_t = t + action_data.damage_start_time
	end

	if t > scratchpad.next_damage_t then
		local companion_pounce_setting = scratchpad.companion_pounce_setting

		self:_damage_target(unit, pounce_target, action_data, companion_pounce_setting.damage_profile)

		scratchpad.next_damage_t = t + action_data.damage_frequency
	end

	self:_position_companion(unit, scratchpad, action_data, t, pounce_target)

	local target_is_dead = scratchpad.target_death_component.is_dead

	if target_is_dead then
		scratchpad.pounce_component.has_pounce_target = false

		return "done"
	end

	local target_unit = scratchpad.perception_component.target_unit

	if t > scratchpad.lerp_position_duration and pounce_target ~= target_unit then
		scratchpad.target_disable_component.attacker_unit = nil
		scratchpad.pounce_component.has_pounce_target = false

		return "done"
	end

	return "running"
end

local POWER_LEVEL = 500

BtCompanionTargetPouncedAction._damage_target = function (self, unit, pounce_target, action_data, damage_profile)
	local jaw_node = Unit.node(unit, action_data.hit_position_node)
	local hit_position = Unit.world_position(unit, jaw_node)
	local attack_type = AttackSettings.attack_types.companion_dog
	local damage_type = action_data.damage_type

	return Attack.execute(pounce_target, damage_profile, "power_level", POWER_LEVEL, "hit_world_position", hit_position, "attack_type", attack_type, "attacking_unit", unit, "damage_type", damage_type, "attack_direction", -Vector3.up())
end

BtCompanionTargetPouncedAction._position_companion = function (self, unit, scratchpad, action_data, t, pounce_target)
	local pounce_target_position = POSITION_LOOKUP[pounce_target]

	if t < scratchpad.lerp_position_duration then
		local lerp_position_time = action_data.lerp_position_time
		local start_position = scratchpad.start_position_boxed:unbox()
		local time_left = scratchpad.lerp_position_duration - t
		local percentage = 1 - time_left / lerp_position_time
		local new_position = Vector3.lerp(start_position, pounce_target_position, percentage)

		Unit.set_local_position(unit, 1, new_position)
	else
		Unit.set_local_position(unit, 1, pounce_target_position)
	end
end

BtCompanionTargetPouncedAction._trigger_pounce_enemy_proc_event = function (self, companion_unit, companion_breed, pounced_unit, pounced_unit_breed)
	local player_owner = Managers.state.player_unit_spawn:owner(companion_unit)
	local player_unit_buff_extension = player_owner.player_unit and ScriptUnit.has_extension(player_owner.player_unit, "buff_system")
	local proc_event_param_table = player_unit_buff_extension and player_unit_buff_extension:request_proc_event_param_table()

	if proc_event_param_table then
		proc_event_param_table.owner_unit = player_owner.player_unit
		proc_event_param_table.companion_breed = companion_breed.name
		proc_event_param_table.companion_unit = companion_unit
		proc_event_param_table.target_unit_breed_name = pounced_unit_breed.name
		proc_event_param_table.pounced_unit = pounced_unit

		player_unit_buff_extension:add_proc_event(proc_events.on_player_companion_pounce, proc_event_param_table)
	end
end

BtCompanionTargetPouncedAction._trigger_pounce_enemy_finish_proc_event = function (self, companion_unit, companion_breed, pounced_unit, pounced_unit_breed, reason)
	local player_owner = Managers.state.player_unit_spawn:owner(companion_unit)
	local player_unit_buff_extension = player_owner.player_unit and ScriptUnit.has_extension(player_owner.player_unit, "buff_system")
	local proc_event_param_table = player_unit_buff_extension and player_unit_buff_extension:request_proc_event_param_table()

	if proc_event_param_table then
		proc_event_param_table.owner_unit = player_owner.player_unit
		proc_event_param_table.companion_breed = companion_breed.name
		proc_event_param_table.companion_unit = companion_unit
		proc_event_param_table.target_unit_breed_name = pounced_unit_breed and pounced_unit_breed.name or "none"
		proc_event_param_table.reason = reason
		proc_event_param_table.pounced_unit = pounced_unit

		player_unit_buff_extension:add_proc_event(proc_events.on_player_companion_pounce_finish, proc_event_param_table)
	end
end

BtCompanionTargetPouncedAction._handle_pounce_enemy_stats = function (self, companion_unit, companion_breed, pounced_unit, pounced_unit_breed)
	local pounced_unit_behaviour_extension = ScriptUnit.has_extension(pounced_unit, "behavior_system")
	local previously_pounced = pounced_unit_behaviour_extension and pounced_unit_behaviour_extension.pounced_by_companion_before and pounced_unit_behaviour_extension:pounced_by_companion_before(companion_unit)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player_owner = player_unit_spawn_manager:owner(companion_unit)
	local companion_breed_name = companion_breed.name
	local pounced_unit_breed_name = pounced_unit_breed.name

	if player_owner then
		Managers.stats:record_private("hook_adamant_companion_pounce_enemy", player_owner, companion_unit, companion_breed_name, pounced_unit, pounced_unit_breed_name, previously_pounced)
	end
end

return BtCompanionTargetPouncedAction
