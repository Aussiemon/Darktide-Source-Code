require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local AttackIntensity = require("scripts/utilities/attack_intensity")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Block = require("scripts/utilities/attack/block")
local DialogueBreedSettings = require("scripts/settings/dialogue/dialogue_breed_settings")
local Dodge = require("scripts/extension_systems/character_state_machine/character_states/utilities/dodge")
local GroundImpact = require("scripts/utilities/attack/ground_impact")
local MinionAttack = require("scripts/utilities/minion_attack")
local MinionBackstabSettings = require("scripts/settings/minion_backstab/minion_backstab_settings")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionPerception = require("scripts/utilities/minion_perception")
local MinionShield = require("scripts/utilities/minion_shield")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local Vo = require("scripts/utilities/vo")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local attack_types = AttackSettings.attack_types
local default_backstab_melee_dot = MinionBackstabSettings.melee_backstab_dot
local default_backstab_melee_event = MinionBackstabSettings.melee_backstab_event
local default_elite_backstab_melee_event = MinionBackstabSettings.melee_elite_backstab_event
local BtMeleeAttackAction = class("BtMeleeAttackAction", "BtNode")
local DEFAULT_DODGE_WINDOW = 0.5

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
	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local stat_buffs = buff_extension:stat_buffs()
	local melee_attack_speed = stat_buffs.melee_attack_speed or 1

	if melee_attack_speed > 1 then
		scratchpad.melee_attack_speed = melee_attack_speed
	end

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

	if action_data.push_enemies_damage_profile or action_data.push_enemies_push_template then
		scratchpad.broadphase_system = Managers.state.extension:system("broadphase_system")
		scratchpad.pushed_enemies = {}
		scratchpad.push_enemies_frequency = action_data.push_enemies_frequency
		scratchpad.side_system = Managers.state.extension:system("side_system")
	end

	if action_data.push_minions_damage_profile then
		scratchpad.side_system = Managers.state.extension:system("side_system")
		scratchpad.broadphase_system = Managers.state.extension:system("broadphase_system")
		scratchpad.pushed_minions = {}
	end
end

local DEFAULT_DOWN_Z_THRESHOLD = -2
local DEFAULT_UP_Z_THRESHOLD = 1.9
local DEFAULT_ATTACK_ANIM_EVENT = "attack"
local DEFAULT_BACKSTAB_TIMING = 0.6
local DEFAULT_BOT_AOE_THREAT_TIMING = 0.15
local DEFAULT_SET_ATTACKED_MELEE_TIMING = {
	0.2,
	0.5
}
local ATTACK_SPEED_THRESHOLD_FRAME_OFFSET = 0.26666666666666666

BtMeleeAttackAction._start_attack_anim = function (self, unit, breed, target_unit, t, spawn_component, scratchpad, action_data)
	local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
	local target_player = Managers.state.player_unit_spawn:owner(target_unit)
	local attack_anim_events = action_data.attack_anim_events or DEFAULT_ATTACK_ANIM_EVENT
	local wanted_events, should_be_anim_driven = nil

	if attack_anim_events.directional then
		local target_position = POSITION_LOOKUP[target_unit]
		local direction_name = MinionMovement.get_change_target_direction(unit, target_position)
		wanted_events = attack_anim_events.directional[direction_name]

		if direction_name ~= "fwd" then
			should_be_anim_driven = true
		end
	else
		wanted_events = attack_anim_events.normal or attack_anim_events
		local unit_z = POSITION_LOOKUP[unit].z
		local target_z = POSITION_LOOKUP[target_unit].z
		local z_diff = target_z - unit_z
		local down_threshold = action_data.down_z_threshold or DEFAULT_DOWN_Z_THRESHOLD
		local up_threshold = action_data.up_z_threshold or DEFAULT_UP_Z_THRESHOLD

		if up_threshold <= z_diff and attack_anim_events.up then
			wanted_events = attack_anim_events.up
		elseif z_diff <= 0 and attack_anim_events.down then
			local is_climbing_ladder = false
			local is_knocked_down = false

			if target_player then
				local target_character_state_component = target_unit_data_extension:read_component("character_state")
				is_climbing_ladder = PlayerUnitStatus.is_climbing_ladder(target_character_state_component)
				is_knocked_down = PlayerUnitStatus.is_knocked_down(target_character_state_component)
			end

			if is_climbing_ladder then
				wanted_events = attack_anim_events.reach_down or attack_anim_events.down
			elseif z_diff < down_threshold or is_knocked_down then
				wanted_events = attack_anim_events.down
			end
		end
	end

	local attack_event = Animation.random_event(wanted_events)

	scratchpad.animation_extension:anim_event(attack_event)

	scratchpad.attack_event = attack_event
	local attack_anim_durations = action_data.attack_anim_durations
	local attack_duration = attack_anim_durations[attack_event]
	local attack_duration_t = t + attack_duration
	scratchpad.attack_duration = attack_duration_t

	if action_data.set_weapon_intensity then
		local game_session = spawn_component.game_session
		local game_object_id = spawn_component.game_object_id

		GameSession.set_game_object_field(game_session, game_object_id, "weapon_intensity", 1)

		scratchpad.game_object_id = game_object_id
		scratchpad.game_session = game_session
	end

	local extra_timing = 0
	local backstab_timing = DEFAULT_BACKSTAB_TIMING or action_data.backstab_timing

	if target_player and target_player.remote then
		extra_timing = target_player:lag_compensation_rewind_s()
		scratchpad.lag_compensation_rewind_s = extra_timing
	end

	local attack_type = action_data.attack_type
	local wanted_attack_type = type(attack_type) == "table" and attack_type[attack_event] or attack_type
	scratchpad.attack_type = wanted_attack_type

	if wanted_attack_type == "sweep" then
		local attack_sweep_damage_timings = action_data.attack_sweep_damage_timings
		local attack_sweep_timings = attack_sweep_damage_timings[attack_event]
		scratchpad.attack_sweep_timings = attack_sweep_timings
		local frame_timing = nil
		local attack_sweep_start_or_table = attack_sweep_timings[1]

		if type(attack_sweep_start_or_table) == "table" then
			frame_timing = attack_sweep_start_or_table[2]
			scratchpad.start_sweep_t = math.min(t + attack_sweep_start_or_table[1], attack_duration_t)
			scratchpad.stop_sweep_t = math.min(t + frame_timing, attack_duration_t)
			scratchpad.multiple_attacks = true
			scratchpad.attack_index = 1
			scratchpad.start_time = t
			local vo_event = action_data.vo_event

			if vo_event then
				Vo.player_vo_enemy_attack_event(unit, breed.name, vo_event)
			end
		else
			frame_timing = attack_sweep_start_or_table
			local attack_sweep_stop = attack_sweep_timings[2]
			scratchpad.start_sweep_t = math.min(t + frame_timing, attack_duration_t)
			scratchpad.stop_sweep_t = math.min(t + attack_sweep_stop, attack_duration_t)
		end

		scratchpad.sweep_hit_units_cache = {}
		scratchpad.backstab_timing = scratchpad.start_sweep_t - backstab_timing - extra_timing

		if scratchpad.lag_compensation_rewind_s then
			scratchpad.lag_compensation_timing = scratchpad.start_sweep_t + extra_timing
		end

		local sweep_ground_impact_fx_templates = action_data.sweep_ground_impact_fx_templates

		if sweep_ground_impact_fx_templates then
			local ground_impact_fx_timings = action_data.sweep_ground_impact_fx_timing[attack_event]
			local ground_impact_fx_timing = ground_impact_fx_timings[1]
			scratchpad.sweep_ground_impact_at_t = t + ground_impact_fx_timing
			scratchpad.ground_impact_index = 1
		end

		local sweep_ground_impact_fx_template = action_data.sweep_ground_impact_fx_template

		if sweep_ground_impact_fx_template then
			scratchpad.sweep_ground_impact_at_t = t + action_data.sweep_ground_impact_fx_timing
		end

		scratchpad.set_attacked_melee_timing = scratchpad.start_sweep_t - math.random_range(DEFAULT_SET_ATTACKED_MELEE_TIMING[1], DEFAULT_SET_ATTACKED_MELEE_TIMING[2])

		if action_data.aoe_threat_timing then
			local aoe_threat_timing = action_data.aoe_threat_timing
			scratchpad.aoe_threat_window = (scratchpad.start_time or scratchpad.start_sweep_t) - aoe_threat_timing
			scratchpad.should_create_aoe_threat = true
		end

		local melee_attack_speed = scratchpad.melee_attack_speed

		if melee_attack_speed then
			local timing = frame_timing

			if type(attack_sweep_start_or_table) == "table" then
				timing = attack_sweep_start_or_table[2]
			end

			local new_duration = math.max(attack_duration / melee_attack_speed, timing + ATTACK_SPEED_THRESHOLD_FRAME_OFFSET)
			scratchpad.attack_duration = t + new_duration
		end
	else
		local attack_anim_damage_timings = action_data.attack_anim_damage_timings
		local attack_timing_or_table = attack_anim_damage_timings[attack_event]
		local frame_timing = nil

		if type(attack_timing_or_table) == "table" then
			frame_timing = attack_timing_or_table[1]
			scratchpad.attack_timing = math.min(t + frame_timing, attack_duration_t)
			scratchpad.multiple_attacks = true
			scratchpad.attack_timings = attack_timing_or_table
			scratchpad.attack_index = 1
			scratchpad.start_time = t
			local vo_event = action_data.vo_event

			if vo_event then
				Vo.player_vo_enemy_attack_event(unit, breed.name, vo_event)
			end
		else
			frame_timing = attack_timing_or_table
			scratchpad.attack_timing = math.min(t + frame_timing, attack_duration_t)
		end

		local dodge_window = (action_data.dodge_window or DEFAULT_DODGE_WINDOW) + extra_timing
		scratchpad.dodge_window = scratchpad.attack_timing - dodge_window
		scratchpad.backstab_timing = scratchpad.attack_timing - backstab_timing - extra_timing
		local target_weapon_template = nil

		if target_player then
			local target_weapon_action_component = target_unit_data_extension:read_component("weapon_action")
			target_weapon_template = WeaponTemplate.current_weapon_template(target_weapon_action_component)
		end

		local is_blockable = Block.attack_is_blockable(action_data.damage_profile, target_unit, target_weapon_template)

		if not is_blockable then
			scratchpad.attack_timing = scratchpad.attack_timing + extra_timing * 0.5
		end

		if scratchpad.lag_compensation_rewind_s then
			scratchpad.lag_compensation_timing = scratchpad.attack_timing + extra_timing
		end

		local aoe_threat_timing = action_data.aoe_threat_timing
		local should_create_aoe_threat = not is_blockable and (attack_type == "oobb" or attack_type == "broadphase")
		scratchpad.should_create_aoe_threat = should_create_aoe_threat

		if should_create_aoe_threat then
			scratchpad.aoe_threat_window = scratchpad.dodge_window - (aoe_threat_timing or DEFAULT_BOT_AOE_THREAT_TIMING)
		elseif aoe_threat_timing then
			scratchpad.aoe_threat_window = scratchpad.dodge_window - aoe_threat_timing
			scratchpad.should_create_aoe_threat = true
		end

		scratchpad.set_attacked_melee_timing = scratchpad.attack_timing - math.random_range(DEFAULT_SET_ATTACKED_MELEE_TIMING[1], DEFAULT_SET_ATTACKED_MELEE_TIMING[2])
		local melee_attack_speed = scratchpad.melee_attack_speed

		if melee_attack_speed then
			local timing = frame_timing

			if type(attack_timing_or_table) == "table" then
				timing = attack_timing_or_table[#attack_timing_or_table]
			end

			local new_duration = math.max(attack_duration / melee_attack_speed, timing + ATTACK_SPEED_THRESHOLD_FRAME_OFFSET)
			scratchpad.attack_duration = t + new_duration
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
		scratchpad.navigation_extension = navigation_extension
		scratchpad.set_animation_wanted_movement_speed = true
		local melee_attack_rotation_durations = action_data.melee_attack_rotation_durations

		if should_be_anim_driven and melee_attack_rotation_durations and melee_attack_rotation_durations[scratchpad.attack_event] then
			local melee_attack_rotation_duration = melee_attack_rotation_durations[scratchpad.attack_event]

			MinionMovement.set_anim_driven(scratchpad, true)

			scratchpad.melee_attack_rotation_duration = t + melee_attack_rotation_duration
		end
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

	local target_unit = scratchpad.perception_component.target_unit

	if scratchpad.set_attacked_melee then
		AttackIntensity.remove_attacked_melee(target_unit)
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

	if scratchpad.melee_attack_rotation_duration then
		local is_anim_driven = scratchpad.is_anim_driven

		if is_anim_driven then
			local target_position = POSITION_LOOKUP[unit]

			MinionMovement.update_anim_driven_melee_attack_rotation(unit, scratchpad, action_data, t, target_position)
		end
	end

	local vo_event = action_data.vo_event
	local next_assault_vo_t = scratchpad.next_assault_vo_t

	if vo_event and next_assault_vo_t and next_assault_vo_t < t then
		Vo.enemy_generic_vo_event(unit, vo_event, breed.name)

		scratchpad.next_assault_vo_t = t + scratchpad.assault_vo_interval_t
	end

	local target_unit = scratchpad.perception_component.target_unit
	local backstab_timing = scratchpad.backstab_timing

	if backstab_timing and backstab_timing <= t then
		local attack_timing = scratchpad.attack_timing

		if (not attack_timing or t < attack_timing) and not scratchpad.finished_attack then
			local ignore_attack_intensity = true
			local elite_event = breed.tags and breed.tags.elite
			local wwise_event = action_data.backstab_event or elite_event and default_elite_backstab_melee_event or default_backstab_melee_event
			local dot_threshold = action_data.backstab_dot or default_backstab_melee_dot
			local triggered_backstab_sound = MinionAttack.check_and_trigger_backstab_sound(unit, action_data, target_unit, wwise_event, dot_threshold, ignore_attack_intensity)

			if triggered_backstab_sound then
				scratchpad.backstab_timing = nil
			end
		end
	end

	local attack_timing = scratchpad.attack_timing

	if scratchpad.should_create_aoe_threat and scratchpad.aoe_threat_window <= t then
		local duration = action_data.aoe_threat_duration or (scratchpad.start_sweep_t or attack_timing) - t

		self:_create_bot_aoe_threat(unit, action_data, duration)

		scratchpad.should_create_aoe_threat = false
	end

	if scratchpad.set_attacked_melee_timing and scratchpad.set_attacked_melee_timing <= t then
		AttackIntensity.set_attacked_melee(target_unit)

		scratchpad.set_attacked_melee = true
		scratchpad.set_attacked_melee_timing = nil
	end

	local attack_type = scratchpad.attack_type

	if attack_type == "sweep" then
		local start_sweep_t = scratchpad.start_sweep_t
		local stop_sweep_t = scratchpad.stop_sweep_t
		local has_started_sweep = start_sweep_t < t

		if not has_started_sweep and not scratchpad.is_moving_attack then
			self:_rotate_towards_target_unit(unit, scratchpad, action_data)
		elseif has_started_sweep then
			local initial_sweep_rotation = scratchpad.initial_sweep_rotation and scratchpad.initial_sweep_rotation:unbox()

			if initial_sweep_rotation then
				scratchpad.locomotion_extension:set_wanted_rotation(initial_sweep_rotation)
			end
		end

		local is_sweeping = has_started_sweep and t < scratchpad.stop_sweep_t

		if is_sweeping then
			self:_attack_sweep(unit, breed, blackboard, scratchpad, action_data)
		elseif stop_sweep_t < t then
			if scratchpad.multiple_attacks then
				local attack_sweep_timings = scratchpad.attack_sweep_timings
				local attack_index = scratchpad.attack_index + 1

				if attack_index <= #attack_sweep_timings then
					scratchpad.attack_index = attack_index
					local current_attack_sweep_timing = attack_sweep_timings[attack_index]
					scratchpad.start_sweep_t = scratchpad.start_time + current_attack_sweep_timing[1]
					scratchpad.stop_sweep_t = scratchpad.start_time + current_attack_sweep_timing[2]
					scratchpad.override_sweep_node = current_attack_sweep_timing[3]

					table.clear(scratchpad.sweep_hit_units_cache)

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
		end

		if scratchpad.sweep_ground_impact_at_t and scratchpad.sweep_ground_impact_at_t <= t then
			local sweep_ground_impact_fx_templates = action_data.sweep_ground_impact_fx_templates

			if sweep_ground_impact_fx_templates then
				local ground_impact_fx_template = sweep_ground_impact_fx_templates[scratchpad.attack_event][scratchpad.ground_impact_index]

				if ground_impact_fx_template then
					GroundImpact.play(unit, scratchpad.physics_world, ground_impact_fx_template)
				end

				local ground_impact_fx_timings = action_data.sweep_ground_impact_fx_timing[scratchpad.attack_event]
				local ground_impact_index = scratchpad.ground_impact_index + 1

				if ground_impact_index <= #ground_impact_fx_timings then
					scratchpad.ground_impact_index = ground_impact_index
					local ground_impact_fx_timing = ground_impact_fx_timings[ground_impact_index]
					scratchpad.sweep_ground_impact_at_t = scratchpad.start_time + ground_impact_fx_timing
				else
					scratchpad.sweep_ground_impact_at_t = nil
				end
			elseif action_data.sweep_ground_impact_fx_template then
				GroundImpact.play(unit, scratchpad.physics_world, action_data.sweep_ground_impact_fx_template)

				scratchpad.sweep_ground_impact_at_t = nil
			end
		end
	elseif attack_timing and attack_timing < t then
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

			scratchpad.finished_attack = true
		end
	elseif attack_timing then
		if scratchpad.target_dodged_during_attack and not action_data.dont_rotate_towards_target then
			scratchpad.locomotion_extension:set_wanted_rotation(scratchpad.stored_dodge_rotation:unbox())
		else
			local rotation = self:_rotate_towards_target_unit(unit, scratchpad, action_data)
			local is_dodging = Dodge.is_dodging(target_unit, attack_types.melee)

			if scratchpad.dodge_window and not action_data.ignore_dodge and scratchpad.dodge_window <= t then
				local too_early = false

				if not scratchpad.entered_dodge_window then
					if is_dodging then
						too_early = true
						scratchpad.dodge_window = nil
					end

					scratchpad.entered_dodge_window = true
				end

				if not too_early and is_dodging and not scratchpad.target_dodged_during_attack then
					scratchpad.target_dodged_during_attack = true
					scratchpad.stored_dodge_rotation = QuaternionBox(rotation)
				end
			end
		end
	end

	if not scratchpad.finished_attack then
		if scratchpad.push_enemies_frequency then
			scratchpad.push_enemies_frequency = scratchpad.push_enemies_frequency - dt

			if scratchpad.push_enemies_frequency <= 0 then
				table.clear(scratchpad.pushed_enemies)

				scratchpad.push_enemies_frequency = action_data.push_enemies_frequency
			end

			local optional_only_ahead_targets = true

			MinionAttack.push_nearby_enemies(unit, scratchpad, action_data, target_unit, optional_only_ahead_targets)
		end

		if action_data.push_minions_damage_profile then
			MinionAttack.push_friendly_minions(unit, scratchpad, action_data, t)
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
	local sweep_node = scratchpad.override_sweep_node or action_data.sweep_node

	MinionAttack.sweep(unit, breed, sweep_node, scratchpad, blackboard, target_unit, action_data, physics_world, sweep_hit_units_cache, override_damage_profile_or_nil, override_damage_type_or_nil, attack_event)

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

	if not action_data.rotate_towards_velocity_after_attack then
		scratchpad.locomotion_extension:set_rotation_speed(0)
	end

	scratchpad.attack_timing = nil

	if scratchpad.global_effect_id then
		scratchpad.fx_system:stop_template_effect(scratchpad.global_effect_id)
	end

	if action_data.moving_attack and not action_data.dont_lock_slot_system then
		local slot_system = Managers.state.extension:system("slot_system")

		slot_system:do_slot_search(unit, false)
	end

	if scratchpad.set_attacked_melee then
		local target_unit = scratchpad.perception_component.target_unit

		AttackIntensity.remove_attacked_melee(target_unit)

		scratchpad.set_attacked_melee = nil
	end
end

BtMeleeAttackAction._rotate_towards_target_unit = function (self, unit, scratchpad, action_data)
	local target_unit = scratchpad.perception_component.target_unit
	local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

	if not action_data.dont_rotate_towards_target then
		scratchpad.locomotion_extension:set_wanted_rotation(flat_rotation)
	end

	return flat_rotation
end

local MAX_CATCH_UP_SPEED = 5
local MIN_APPLIED_MOVEMENTSPEED_FOR_CATCHUP = 1

BtMeleeAttackAction._update_moving_attack = function (self, unit, dt, t, action_data, scratchpad)
	local move_start_timing = scratchpad.move_start_timing

	if move_start_timing and move_start_timing <= t then
		local slot_system = Managers.state.extension:system("slot_system")

		slot_system:set_release_slot_lock(unit, true)

		scratchpad.move_start_timing = nil
	end

	local target_unit = scratchpad.perception_component.target_unit
	local navigation_extension = scratchpad.navigation_extension
	local animation_move_speed_config = scratchpad.animation_move_speed_config
	local self_position = POSITION_LOOKUP[unit]
	local destination = navigation_extension:destination()
	local target_position, target_velocity = MinionMovement.target_position_with_velocity(unit, target_unit, destination)

	if animation_move_speed_config then
		local max_distance = animation_move_speed_config[1].distance
		local max_value = animation_move_speed_config[1].value
		local distance_to_target = math.min(Vector3.distance(self_position, target_position), max_distance)
		local wanted_value = max_value
		local num_configs = #animation_move_speed_config

		for i = 1, num_configs do
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

	local applied_movement_speed = nil

	if not action_data.ignore_animation_movement_speed and scratchpad.start_animation_wanted_movement_speed then
		applied_movement_speed = MinionMovement.apply_animation_wanted_movement_speed(unit, navigation_extension, dt)
	end

	if action_data.catch_up_movementspeed and applied_movement_speed and MIN_APPLIED_MOVEMENTSPEED_FOR_CATCHUP < applied_movement_speed and scratchpad.attack_timing then
		local fwd = Quaternion.forward(Unit.local_rotation(unit, 1))
		local dot = Vector3.dot(fwd, target_velocity)

		if dot > 0 then
			local new_speed = math.min(Vector3.length(target_velocity) + 0.1, MAX_CATCH_UP_SPEED)

			if applied_movement_speed < new_speed then
				navigation_extension:set_max_speed(new_speed)
			end
		end
	end

	if scratchpad.set_animation_wanted_movement_speed then
		scratchpad.set_animation_wanted_movement_speed = nil
		scratchpad.start_animation_wanted_movement_speed = true
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

local SWEEP_AOE_THREAT_RADIUS = 4

BtMeleeAttackAction._create_bot_aoe_threat = function (self, unit, action_data, duration)
	local position, shape, size, rotation = nil
	local attack_type = action_data.attack_type

	if attack_type == "oobb" then
		position, rotation, size = MinionAttack.melee_oobb_extents(unit, action_data)

		if action_data.aoe_bot_threat_oobb_size then
			size = action_data.aoe_bot_threat_oobb_size:unbox()
		end

		shape = "oobb"
	elseif attack_type == "broadphase" then
		position, size = MinionAttack.melee_broadphase_extents(unit, action_data)

		if action_data.aoe_bot_threat_broadphase_size then
			size = action_data.aoe_bot_threat_broadphase_size
		end

		rotation = Unit.world_rotation(unit, 1)
		shape = "sphere"
	elseif attack_type == "sweep" then
		size = action_data.aoe_bot_threat_sweep_reach or SWEEP_AOE_THREAT_RADIUS
		position = POSITION_LOOKUP[unit]
		rotation = Unit.world_rotation(unit, 1)
		shape = "sphere"
	else
		size = action_data.aoe_bot_threat_reach or action_data.weapon_reach or 1
		position = POSITION_LOOKUP[unit]

		if type(size) == "table" then
			size = size.default
		end

		rotation = Unit.world_rotation(unit, 1)
		shape = "sphere"
	end

	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]
	local enemy_sides = side:relation_sides("enemy")
	local group_system = Managers.state.extension:system("group_system")
	local bot_groups = group_system:bot_groups_from_sides(enemy_sides)
	local num_bot_groups = #bot_groups

	for i = 1, num_bot_groups do
		local bot_group = bot_groups[i]

		bot_group:aoe_threat_created(position, shape, size, rotation, duration)
	end
end

return BtMeleeAttackAction
