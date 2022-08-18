-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local AttackIntensity = require("scripts/utilities/attack_intensity")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Block = require("scripts/utilities/attack/block")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local DialogueBreedSettings = require("scripts/settings/dialogue/dialogue_breed_settings")
local Dodge = require("scripts/extension_systems/character_state_machine/character_states/utilities/dodge")
local MinionAttack = require("scripts/utilities/minion_attack")
local MinionBackstabSettings = require("scripts/settings/minion_backstab/minion_backstab_settings")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionPerception = require("scripts/utilities/minion_perception")
local MinionShield = require("scripts/utilities/minion_shield")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local Vo = require("scripts/utilities/vo")
local attack_types = AttackSettings.attack_types
local breed_types = BreedSettings.types
local default_backstab_melee_dot = MinionBackstabSettings.melee_backstab_dot
local default_backstab_melee_event = MinionBackstabSettings.melee_backstab_event
local BtMeleeAttackAction = class("BtMeleeAttackAction", "BtNode")
local DEFAULT_DODGE_WINDOW = 0.3333333333333333

BtMeleeAttackAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")
	local perception_component = Blackboard.write_component(blackboard, "perception")
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	if breed.combat_range_data then
		behavior_component.lock_combat_range_switch = true
	end

	scratchpad.behavior_component = behavior_component
	scratchpad.perception_component = perception_component
	local slot_system = Managers.state.extension:system("slot_system")
	local is_slot_searching = slot_system:is_slot_searching(unit)
	scratchpad.was_slot_searching = is_slot_searching

	if action_data.moving_attack and not is_slot_searching then
		slot_system:do_slot_search(unit, true)
	end

	MinionPerception.set_target_lock(unit, perception_component, true)

	local spawn_component = blackboard.spawn
	scratchpad.physics_world = spawn_component.physics_world
	local assault_vo_interval_t = DialogueBreedSettings[breed.name].assault_vo_interval_t

	if action_data.vo_event and assault_vo_interval_t then
		scratchpad.assault_vo_interval_t = assault_vo_interval_t
		scratchpad.next_assault_vo_t = t + assault_vo_interval_t
	end

	local target_unit = perception_component.target_unit

	self:_start_attack_anim(unit, breed, target_unit, t, spawn_component, scratchpad, action_data)
	AttackIntensity.add_intensity(target_unit, action_data.attack_intensities)
	AttackIntensity.set_attacked(target_unit)

	local current_rotation_speed = locomotion_extension:rotation_speed()
	scratchpad.original_rotation_speed = current_rotation_speed
	local rotation_speed = action_data.rotation_speed

	if rotation_speed then
		locomotion_extension:set_rotation_speed(rotation_speed)
	end

	local is_anim_driven = action_data.anim_driven

	if is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, true)
	end
end

local DEFAULT_DOWN_Z_THRESHOLD = -2
local DEFAULT_UP_Z_THRESHOLD = 1.9
local DEFAULT_ATTACK_ANIM_EVENT = "attack"
local DEFAULT_ANIMATION_WANTED_MOVEMENTSPEED_TIMING = 0.2
local DEFAULT_BACKSTAB_TIMING = 0.6
local DEFAULT_BOT_AOE_THREAT_TIMING = 0.2

BtMeleeAttackAction._start_attack_anim = function (self, unit, breed, target_unit, t, spawn_component, scratchpad, action_data)
	local unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
	local attack_anim_events = action_data.attack_anim_events or DEFAULT_ATTACK_ANIM_EVENT
	local wanted_events = attack_anim_events.normal or attack_anim_events
	local unit_z = POSITION_LOOKUP[unit].z
	local target_z = POSITION_LOOKUP[target_unit].z
	local z_diff = target_z - unit_z
	local down_threshold = action_data.down_z_threshold or DEFAULT_DOWN_Z_THRESHOLD
	local up_threshold = action_data.up_z_threshold or DEFAULT_UP_Z_THRESHOLD

	if up_threshold <= z_diff and attack_anim_events.up then
		wanted_events = attack_anim_events.up
	elseif z_diff <= 0 and attack_anim_events.down then
		local character_state_component = unit_data_extension:read_component("character_state")

		if PlayerUnitStatus.is_climbing_ladder(character_state_component) then
			wanted_events = attack_anim_events.reach_down or attack_anim_events.down
		elseif z_diff < down_threshold or PlayerUnitStatus.is_knocked_down(character_state_component) then
			wanted_events = attack_anim_events.down
		end
	end

	local attack_event = Animation.random_event(wanted_events)
	local attack_anim_durations = action_data.attack_anim_durations
	local attack_duration = attack_anim_durations[attack_event]
	local attack_duration_t = t + attack_duration
	scratchpad.attack_duration = attack_duration_t

	scratchpad.animation_extension:anim_event(attack_event)

	scratchpad.attack_event = attack_event

	if action_data.set_weapon_intensity then
		local game_session = spawn_component.game_session
		local game_object_id = spawn_component.game_object_id

		GameSession.set_game_object_field(game_session, game_object_id, "weapon_intensity", 1)

		scratchpad.game_object_id = game_object_id
		scratchpad.game_session = game_session
	end

	local extra_timing = 0
	local backstab_timing = DEFAULT_BACKSTAB_TIMING or action_data.backstab_timing
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(target_unit)

	if player and player.remote then
		extra_timing = player:lag_compensation_rewind_s()
		scratchpad.lag_compensation_rewind_s = extra_timing
	end

	local attack_type = action_data.attack_type
	local wanted_attack_type = (type(attack_type) == "table" and attack_type[attack_event]) or attack_type
	scratchpad.attack_type = wanted_attack_type

	if wanted_attack_type == "sweep" then
		local attack_sweep_damage_timings = action_data.attack_sweep_damage_timings
		local attack_sweep_timings = attack_sweep_damage_timings[attack_event]
		scratchpad.attack_sweep_timings = attack_sweep_timings
		local attack_sweep_start_or_table = attack_sweep_timings[1]

		if type(attack_sweep_start_or_table) == "table" then
			scratchpad.start_sweep_t = math.min(t + attack_sweep_start_or_table[1], attack_duration_t)
			scratchpad.stop_sweep_t = math.min(t + attack_sweep_start_or_table[2], attack_duration_t)
			scratchpad.multiple_attacks = true
			scratchpad.attack_index = 1
			scratchpad.start_time = t
			local vo_event = action_data.vo_event

			if vo_event then
				Vo.player_vo_enemy_attack_event(unit, breed.name, vo_event)
			end
		else
			local attack_sweep_stop = attack_sweep_timings[2]
			scratchpad.start_sweep_t = math.min(t + attack_sweep_start_or_table, attack_duration_t)
			scratchpad.stop_sweep_t = math.min(t + attack_sweep_stop, attack_duration_t)
		end

		scratchpad.sweep_hit_units_cache = {}
		scratchpad.backstab_timing = scratchpad.start_sweep_t - backstab_timing - extra_timing

		if scratchpad.lag_compensation_rewind_s then
			scratchpad.lag_compensation_timing = scratchpad.start_sweep_t + extra_timing
		end
	else
		local attack_anim_damage_timings = action_data.attack_anim_damage_timings
		local attack_timing_or_table = attack_anim_damage_timings[attack_event]

		if type(attack_timing_or_table) == "table" then
			local first_timing = attack_timing_or_table[1]
			scratchpad.attack_timing = math.min(t + first_timing, attack_duration_t)
			scratchpad.multiple_attacks = true
			scratchpad.attack_timings = attack_timing_or_table
			scratchpad.attack_index = 1
			scratchpad.start_time = t
			local vo_event = action_data.vo_event

			if vo_event then
				Vo.player_vo_enemy_attack_event(unit, breed.name, vo_event)
			end
		else
			scratchpad.attack_timing = math.min(t + attack_timing_or_table, attack_duration_t)
		end

		scratchpad.dodge_window = scratchpad.attack_timing - (action_data.dodge_window or DEFAULT_DODGE_WINDOW)
		scratchpad.backstab_timing = scratchpad.attack_timing - backstab_timing - extra_timing
		local is_blockable = Block.attack_is_blockable(action_data.damage_profile)

		if not is_blockable then
			scratchpad.attack_timing = scratchpad.attack_timing + extra_timing * 0.5
		end

		if scratchpad.lag_compensation_rewind_s then
			scratchpad.lag_compensation_timing = scratchpad.attack_timing + extra_timing
		end

		local should_create_aoe_threat = not is_blockable and unit_data_extension:breed().breed_type == breed_types.player and (attack_type == "oobb" or attack_type == "broadphase")
		scratchpad.should_create_aoe_threat = should_create_aoe_threat

		if should_create_aoe_threat then
			local group_extension = ScriptUnit.extension(target_unit, "group_system")
			local bot_group = group_extension:bot_group()
			scratchpad.aoe_threat_bot_group = bot_group
			scratchpad.aoe_threat_window = scratchpad.dodge_window - DEFAULT_BOT_AOE_THREAT_TIMING
		end
	end

	local moving_attack = action_data.moving_attack

	if moving_attack then
		local move_start_timing = action_data.move_start_timings and action_data.move_start_timings[attack_event]
		scratchpad.move_start_timing = t + (move_start_timing or 0)
		local animation_move_speed_config = nil
		local animation_move_speed_configs = action_data.animation_move_speed_configs

		if animation_move_speed_configs then
			animation_move_speed_config = animation_move_speed_configs[attack_event]
		else
			animation_move_speed_config = action_data.animation_move_speed_config
		end

		if animation_move_speed_config then
			local max_value = animation_move_speed_config[1].value
			scratchpad.previous_move_animation_value = max_value
			scratchpad.animation_move_speed_config = animation_move_speed_config
		end

		local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

		navigation_extension:set_enabled(true, action_data.move_speed or breed.run_speed)

		local using_animation_movement_speed = not action_data.ignore_animation_movement_speed

		fassert(using_animation_movement_speed or move_start_timing == 0, "[BtMeleeAttackAction] To avoid minion from sliding away due to navigation being enabled please either allow for animation driven movement speed or change the animation to allow for move_start_timing=0.")

		scratchpad.navigation_extension = navigation_extension
		scratchpad.animation_wanted_movementspeed_timing = t + (action_data.animation_wanted_movementspeed_timing or DEFAULT_ANIMATION_WANTED_MOVEMENTSPEED_TIMING)
	end

	local effect_template_start_timing = action_data.effect_template_start_timings and action_data.effect_template_start_timings[attack_event]

	if effect_template_start_timing then
		scratchpad.effect_template_start_timing = t + effect_template_start_timing
	end

	local behavior_component = scratchpad.behavior_component
	behavior_component.move_state = "attacking"

	MinionShield.init_block_timings(scratchpad, action_data, attack_event, t)
end

BtMeleeAttackAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local slot_system = Managers.state.extension:system("slot_system")

	if action_data.moving_attack and scratchpad.was_slot_searching then
		slot_system:set_release_slot_lock(unit, false)
		slot_system:do_slot_search(unit, true)
		scratchpad.navigation_extension:set_enabled(false)
	elseif not scratchpad.was_slot_searching and slot_system:is_slot_searching(unit) then
		slot_system:set_release_slot_lock(unit, false)
		slot_system:do_slot_search(unit, false)
	end

	if action_data.set_weapon_intensity then
		local game_session = scratchpad.game_session
		local game_object_id = scratchpad.game_object_id

		GameSession.set_game_object_field(game_session, game_object_id, "weapon_intensity", 0)
	end

	scratchpad.locomotion_extension:set_rotation_speed(scratchpad.original_rotation_speed)

	if not scratchpad.attempting_multi_target_switch then
		MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)
	end

	local is_anim_driven = scratchpad.is_anim_driven

	if is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	if scratchpad.global_effect_id then
		scratchpad.fx_system:stop_template_effect(scratchpad.global_effect_id)
	end

	MinionShield.reset_block_timings(scratchpad, unit)

	if breed.combat_range_data then
		scratchpad.behavior_component.lock_combat_range_switch = false
	end

	if reason == "done" then
		local attack_ended_vo = action_data.attack_ended_vo

		if attack_ended_vo then
			Vo.enemy_generic_vo_event(unit, attack_ended_vo, breed.name)
		end
	end
end

BtMeleeAttackAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if scratchpad.attempting_multi_target_switch then
		scratchpad.attempting_multi_target_switch = false
		local perception_component = scratchpad.perception_component

		if perception_component.target_changed then
			MinionPerception.switched_multi_target_unit(scratchpad, t, action_data.multi_target_config)
		end

		MinionPerception.set_target_lock(unit, perception_component, true)
	end

	local vo_event = action_data.vo_event
	local next_assault_vo_t = scratchpad.next_assault_vo_t

	if vo_event and next_assault_vo_t and next_assault_vo_t < t then
		Vo.enemy_generic_vo_event(unit, vo_event, breed.name)

		scratchpad.next_assault_vo_t = t + scratchpad.assault_vo_interval_t
	end

	local backstab_timing = scratchpad.backstab_timing

	if backstab_timing and backstab_timing <= t then
		local ignore_attack_intensity = true
		local wwise_event = action_data.backstab_event or default_backstab_melee_event
		local dot_threshold = action_data.backstab_dot or default_backstab_melee_dot
		local target_unit = scratchpad.perception_component.target_unit
		local triggered_backstab_sound = MinionAttack.check_and_trigger_backstab_sound(unit, action_data, target_unit, wwise_event, dot_threshold, ignore_attack_intensity)

		if triggered_backstab_sound then
			scratchpad.backstab_timing = nil
		end
	end

	local attack_type = scratchpad.attack_type

	if attack_type == "sweep" then
		local start_sweep_t = scratchpad.start_sweep_t
		local stop_sweep_t = scratchpad.stop_sweep_t
		local has_started_sweep = start_sweep_t < t

		if not has_started_sweep and not scratchpad.is_moving_attack then
			self:_rotate_towards_target_unit(unit, scratchpad)
		end
	else
		local attack_timing = scratchpad.attack_timing

		if attack_timing and attack_timing < t then
			self:_attack(unit, breed, blackboard, scratchpad, action_data)

			if scratchpad.multiple_attacks then
				local attack_timings = scratchpad.attack_timings
				local attack_index = scratchpad.attack_index + 1

				if attack_index <= #attack_timings then
					scratchpad.attack_index = attack_index
					scratchpad.attack_timing = scratchpad.start_time + attack_timings[attack_index]
					scratchpad.target_dodged_during_attack = false
					local multi_target_config = action_data.multi_target_config

					if multi_target_config then
						local is_target_locked = true

						MinionPerception.evaluate_multi_target_switch(unit, scratchpad, t, multi_target_config, is_target_locked)
					end
				else
					self:_finished_attacks(unit, scratchpad, action_data)
				end
			else
				self:_finished_attacks(unit, scratchpad, action_data)
			end
		elseif attack_timing then
			if scratchpad.should_create_aoe_threat and scratchpad.aoe_threat_window < t then
				local duration = attack_timing - t

				self:_create_bot_aoe_threat(unit, scratchpad.aoe_threat_bot_group, action_data, duration)

				scratchpad.aoe_threat_bot_group = nil
				scratchpad.should_create_aoe_threat = false
			end

			if scratchpad.target_dodged_during_attack then
				scratchpad.locomotion_extension:set_wanted_rotation(scratchpad.stored_dodge_rotation:unbox())
			else
				local rotation = self:_rotate_towards_target_unit(unit, scratchpad)

				if scratchpad.dodge_window < t then
					local target_unit = scratchpad.perception_component.target_unit
					local is_dodging = Dodge.is_dodging(target_unit, attack_types.melee)

					if is_dodging and not scratchpad.target_dodged_during_attack then
						scratchpad.target_dodged_during_attack = true
						scratchpad.stored_dodge_rotation = QuaternionBox(rotation)
					end
				end
			end
		end
	end

	MinionShield.update_block_timings(scratchpad, unit, t)
	MinionAttack.update_lag_compensation_melee(unit, breed, scratchpad, blackboard, t, action_data)

	if scratchpad.effect_template_start_timing and scratchpad.effect_template_start_timing <= t then
		local effect_template = action_data.effect_template
		local fx_system = Managers.state.extension:system("fx_system")
		scratchpad.global_effect_id = fx_system:start_template_effect(effect_template, unit)
		scratchpad.fx_system = fx_system
		scratchpad.effect_template_start_timing = nil
	end

	local attack_duration = scratchpad.attack_duration

	if attack_duration < t then
		return "done"
	end

	local is_moving_attack = action_data.moving_attack

	if is_moving_attack then
		self:_update_moving_attack(unit, dt, t, action_data, scratchpad)
	end

	return "running"
end

BtMeleeAttackAction._attack_sweep = function (self, unit, breed, blackboard, scratchpad, action_data)
	local physics_world = scratchpad.physics_world
	local sweep_hit_units_cache = scratchpad.sweep_hit_units_cache
	local override_damage_profile_or_nil, override_damage_type_or_nil = self:_extract_override_damage_data(scratchpad, action_data)
	local attack_event = scratchpad.attack_event
	local target_unit = scratchpad.perception_component.target_unit

	MinionAttack.sweep(unit, breed, scratchpad, blackboard, target_unit, action_data, physics_world, sweep_hit_units_cache, override_damage_profile_or_nil, override_damage_type_or_nil, attack_event)

	if not scratchpad.inital_sweep_rotation then
		scratchpad.initial_sweep_rotation = QuaternionBox(Unit.local_rotation(unit, 1))
	end
end

BtMeleeAttackAction._attack = function (self, unit, breed, blackboard, scratchpad, action_data)
	local override_damage_profile_or_nil, override_damage_type_or_nil = self:_extract_override_damage_data(scratchpad, action_data)
	local target_unit = scratchpad.perception_component.target_unit
	local physics_world = scratchpad.physics_world
	local attack_event = scratchpad.attack_event

	MinionAttack.melee(unit, breed, scratchpad, blackboard, target_unit, action_data, physics_world, override_damage_profile_or_nil, override_damage_type_or_nil, attack_event)
end

BtMeleeAttackAction._finished_attacks = function (self, unit, scratchpad, action_data)
	if action_data.set_weapon_intensity then
		local game_session = scratchpad.game_session
		local game_object_id = scratchpad.game_object_id

		GameSession.set_game_object_field(game_session, game_object_id, "weapon_intensity", 0)
	end

	scratchpad.locomotion_extension:set_rotation_speed(0)

	scratchpad.attack_timing = nil

	if scratchpad.global_effect_id then
		scratchpad.fx_system:stop_template_effect(scratchpad.global_effect_id)
	end

	if action_data.moving_attack then
		local slot_system = Managers.state.extension:system("slot_system")

		slot_system:do_slot_search(unit, false)
	end
end

BtMeleeAttackAction._rotate_towards_target_unit = function (self, unit, scratchpad)
	local target_unit = scratchpad.perception_component.target_unit
	local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

	scratchpad.locomotion_extension:set_wanted_rotation(flat_rotation)

	return flat_rotation
end

BtMeleeAttackAction._update_moving_attack = function (self, unit, dt, t, action_data, scratchpad)
	local move_start_timing = scratchpad.move_start_timing

	if move_start_timing and move_start_timing <= t then
		local slot_system = Managers.state.extension:system("slot_system")

		slot_system:set_release_slot_lock(unit, true)

		scratchpad.move_start_timing = nil
	end

	local navigation_extension = scratchpad.navigation_extension
	local animation_move_speed_config = scratchpad.animation_move_speed_config

	if animation_move_speed_config then
		local self_position = POSITION_LOOKUP[unit]
		local destination = navigation_extension:destination()
		local target_unit = scratchpad.perception_component.target_unit
		local target_position = MinionMovement.target_position_with_velocity(unit, target_unit, destination)
		local max_distance = animation_move_speed_config[1].distance
		local max_value = animation_move_speed_config[1].value
		local distance_to_target = math.min(Vector3.distance(self_position, target_position), max_distance)
		local wanted_value = max_value
		local num_configs = #animation_move_speed_config

		for i = 1, num_configs, 1 do
			local config = animation_move_speed_config[i]
			local distance = config.distance
			local value = config.value

			if i < num_configs then
				local next_config = animation_move_speed_config[i + 1]
				local next_distance = next_config.distance
				local next_value = next_config.value

				if next_distance < distance_to_target then
					local distance_range = distance - next_distance
					local target_distance_diff = distance - distance_to_target
					local value_range = value - next_value
					local distance_percentage = 1 - target_distance_diff / distance_range
					wanted_value = next_value + distance_percentage * value_range

					break
				end
			else
				wanted_value = value
			end
		end

		local lerp_t = math.min(dt * action_data.move_speed_variable_lerp_speed, 1)
		local final_value = math.lerp(scratchpad.previous_move_animation_value, wanted_value, lerp_t)
		local variable_name = action_data.move_speed_variable_name

		scratchpad.animation_extension:set_variable(variable_name, final_value)

		scratchpad.previous_move_animation_value = final_value
	end

	if not action_data.ignore_animation_movement_speed and scratchpad.animation_wanted_movementspeed_timing < t then
		MinionMovement.apply_animation_wanted_movement_speed(unit, navigation_extension, dt)
	end
end

BtMeleeAttackAction._extract_override_damage_data = function (self, scratchpad, action_data)
	local override_damage_profile_or_nil, override_damage_type_or_nil = nil

	if scratchpad.multiple_attacks then
		local override_damage_data = action_data.attack_override_damage_data

		if override_damage_data then
			local attack_event = scratchpad.attack_event
			local override_event_data = override_damage_data[attack_event]

			if override_event_data then
				local attack_index = scratchpad.attack_index

				if override_event_data[attack_index] then
					override_damage_profile_or_nil = override_event_data[attack_index].override_damage_profile
					override_damage_type_or_nil = override_event_data[attack_index].override_damage_type
				end
			end
		end
	end

	return override_damage_profile_or_nil, override_damage_type_or_nil
end

BtMeleeAttackAction._create_bot_aoe_threat = function (self, unit, bot_group, action_data, duration)
	local position, shape, size, rotation = nil
	local attack_type = action_data.attack_type

	if attack_type == "oobb" then
		position, rotation, size = MinionAttack.melee_oobb_extents(unit, action_data)
		shape = "oobb"
	elseif attack_type == "broadphase" then
		position, size = MinionAttack.melee_broadphase_extents(unit, action_data)
		rotation = Unit.world_rotation(unit, 1)
		shape = "sphere"
	end

	bot_group:aoe_threat_created(position, shape, size, rotation, duration)
end

return BtMeleeAttackAction
