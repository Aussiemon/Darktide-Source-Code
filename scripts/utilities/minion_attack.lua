-- chunkname: @scripts/utilities/minion_attack.lua

local Action = require("scripts/utilities/action/action")
local Attack = require("scripts/utilities/attack/attack")
local AttackIntensity = require("scripts/utilities/attack_intensity")
local AttackIntensitySettings = require("scripts/settings/attack_intensity/attack_intensity_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Block = require("scripts/utilities/attack/block")
local Breed = require("scripts/utilities/breed")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local Dodge = require("scripts/extension_systems/character_state_machine/character_states/utilities/dodge")
local GroundImpact = require("scripts/utilities/attack/ground_impact")
local HitScan = require("scripts/utilities/attack/hit_scan")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local MinionBackstabSettings = require("scripts/settings/minion_backstab/minion_backstab_settings")
local MinionPerception = require("scripts/utilities/minion_perception")
local MinionPushFx = require("scripts/utilities/minion_push_fx")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local Push = require("scripts/extension_systems/character_state_machine/character_states/utilities/push")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local attack_results = AttackSettings.attack_results
local attack_types = AttackSettings.attack_types
local default_backstab_ranged_dot = MinionBackstabSettings.ranged_backstab_dot
local default_backstab_ranged_event = MinionBackstabSettings.ranged_backstab_event
local MINION_BREED_TYPE = BreedSettings.types.minion
local MinionAttack = {}
local IMPACT_FX_DATA = {}
local BACKSTAB_POSITION_OFFSET_DISTANCE = 2
local AIM_DOT_THRESHOLD = 0
local DEFAULT_ENEMY_AIM_NODE = "enemy_aim_target_03"

MinionAttack.get_aim_position = function (unit, scratchpad, optional_line_of_sight_id, optional_aim_node_name)
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit
	local target_position

	if optional_line_of_sight_id then
		if scratchpad.perception_extension:has_line_of_sight_by_id(target_unit, optional_line_of_sight_id) then
			target_position = Unit.world_position(target_unit, Unit.node(target_unit, optional_aim_node_name or DEFAULT_ENEMY_AIM_NODE))
		elseif perception_component.has_last_los_position then
			target_position = perception_component.last_los_position:unbox()
		elseif scratchpad.perception_extension:last_los_position(target_unit) ~= nil then
			target_position = scratchpad.perception_extension:last_los_position(target_unit)
		end
	elseif perception_component.has_line_of_sight then
		target_position = Unit.world_position(target_unit, Unit.node(target_unit, optional_aim_node_name or DEFAULT_ENEMY_AIM_NODE))
	elseif perception_component.has_last_los_position then
		target_position = perception_component.last_los_position:unbox()
	elseif scratchpad.perception_extension:last_los_position(target_unit) ~= nil then
		target_position = scratchpad.perception_extension:last_los_position(target_unit)
	end

	return target_position
end

MinionAttack.aim_at_target = function (unit, scratchpad, t, action_data)
	local target_position = MinionAttack.get_aim_position(unit, scratchpad)

	if not target_position then
		return false
	end

	local valid_angle, dot, flat_to_target_direction = MinionAttack.aim_at_position(unit, scratchpad, t, action_data, target_position)

	return valid_angle, dot, flat_to_target_direction
end

MinionAttack.aim_at_position = function (unit, scratchpad, t, action_data, target_position)
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit

	if scratchpad.perception_extension:has_forced_aim(target_unit) then
		scratchpad.perception_extension:reset_forced_aim(target_unit)

		return false
	end

	local aim_node = Unit.node(unit, scratchpad.aim_node_name)
	local unit_position = Unit.world_position(unit, aim_node)
	local to_target = target_position - unit_position
	local flat_to_target = Vector3.flat(to_target)
	local to_target_direction = Vector3.normalize(flat_to_target)
	local unit_rotation = Unit.local_rotation(unit, 1)
	local unit_forward = Quaternion.forward(unit_rotation)
	local dot = Vector3.dot(unit_forward, to_target_direction)
	local valid_angle = true

	if scratchpad.start_rotation_timing == nil and dot < AIM_DOT_THRESHOLD then
		local wanted_rotation = Quaternion.look(to_target_direction)

		scratchpad.locomotion_extension:set_wanted_rotation(wanted_rotation)

		valid_angle = false
	end

	scratchpad.current_aim_position:store(target_position)
	MinionAttack.update_scope_reflection(unit, scratchpad, t, action_data)

	return valid_angle, dot, to_target_direction
end

MinionAttack.update_scope_reflection = function (unit, scratchpad, t, action_data)
	local attack_delay = MinionAttack.get_attack_delay(unit)
	local scope_reflection_timing = scratchpad.scope_reflection_timing and scratchpad.scope_reflection_timing + attack_delay

	if not scope_reflection_timing or t < scope_reflection_timing then
		return
	end

	local target_unit = scratchpad.perception_component.target_unit
	local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
	local target_breed = target_unit_data_extension:breed()

	if Breed.is_minion(target_breed) then
		return
	end

	local shoot_template = action_data.shoot_template
	local scope_reflection_vfx_name = shoot_template.scope_reflection_vfx_name
	local weapon_item = scratchpad.weapon_item
	local fx_source_name = action_data.fx_source_name
	local attachment_unit, node = MinionVisualLoadout.attachment_unit_and_node_from_node_name(weapon_item, fx_source_name)
	local source_position = Unit.world_position(attachment_unit, node)
	local source_rotation = Unit.world_rotation(attachment_unit, node)
	local fx_extension = ScriptUnit.extension(target_unit, "fx_system")

	fx_extension:spawn_exclusive_particle(scope_reflection_vfx_name, source_position, source_rotation)

	scratchpad.scope_reflection_timing = nil

	local is_dodging = Dodge.is_dodging(target_unit, attack_types.ranged)

	if is_dodging then
		scratchpad.target_dodged_too_early = true
	end
end

MinionAttack.trigger_shoot_sfx_and_vfx = function (unit, scratchpad, action_data, optional_end_position)
	local fx_extension = scratchpad.fx_extension
	local inventory_slot_name = action_data.inventory_slot
	local fx_source_name = action_data.fx_source_name
	local shoot_template = action_data.shoot_template
	local line_effect = shoot_template.line_effect

	if line_effect and optional_end_position then
		fx_extension:trigger_unit_line_fx(line_effect, inventory_slot_name, fx_source_name, optional_end_position)
	end

	local trigger_shoot_sound_event_once = action_data.trigger_shoot_sound_event_once

	if trigger_shoot_sound_event_once and scratchpad.sound_event_triggered then
		return
	end

	local shoot_event_name = shoot_template.shoot_sound_event

	if shoot_event_name then
		if type(shoot_event_name) == "table" then
			shoot_event_name = shoot_event_name[math.random(1, #shoot_event_name)]
		end

		local target_unit = scratchpad.perception_component.target_unit
		local is_ranged_attack = true

		fx_extension:trigger_inventory_wwise_event(shoot_event_name, inventory_slot_name, fx_source_name, target_unit, is_ranged_attack)
	end

	local shoot_vfx_name = shoot_template.shoot_vfx_name

	if shoot_vfx_name then
		fx_extension:trigger_inventory_vfx(shoot_vfx_name, inventory_slot_name, fx_source_name)
	end

	local current_aim_anim_event = scratchpad.current_aim_anim_event
	local aim_stance = scratchpad.aim_stance or action_data.aim_stances and action_data.aim_stances[current_aim_anim_event]

	if aim_stance then
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local breed = unit_data_extension:breed()
		local shoot_offset_anim_event = breed.shoot_offset_anim_event
		local offset_anim_event = shoot_offset_anim_event and shoot_offset_anim_event[aim_stance]

		if offset_anim_event then
			scratchpad.animation_extension:anim_event(offset_anim_event)
		end
	end

	if trigger_shoot_sound_event_once then
		scratchpad.sound_event_triggered = true
	end
end

local MAX_SUPPRESS_VALUE_SPREAD = 60

local function _spread_direction(target_unit, minion_unit, shoot_direction, spread, optional_spread_multiplier)
	local spread_multiplier = optional_spread_multiplier or 1
	local spread_angle = math.random() * spread * spread_multiplier
	local buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

	if buff_extension then
		local stat_buffs = buff_extension:stat_buffs()

		if stat_buffs and stat_buffs.elusiveness_modifier then
			spread_angle = spread_angle * stat_buffs.elusiveness_modifier
		end
	end

	local minion_buff_extension = ScriptUnit.has_extension(minion_unit, "buff_system")

	if minion_buff_extension then
		local stat_buffs = minion_buff_extension:stat_buffs()

		if stat_buffs and stat_buffs.minion_accuracy_modifier then
			spread_angle = spread_angle * stat_buffs.minion_accuracy_modifier
		end
	end

	local suppression_extension = ScriptUnit.has_extension(minion_unit, "suppression_system")

	if suppression_extension then
		local suppress_value = suppression_extension:suppress_value()

		if suppress_value > 1 then
			spread_angle = spread_angle * math.min(suppress_value * 3, MAX_SUPPRESS_VALUE_SPREAD)
		end
	end

	local direction_rotation = Quaternion.look(shoot_direction, Vector3.up())
	local pitch = Quaternion(Vector3.right(), spread_angle)
	local roll = Quaternion(Vector3.forward(), math.random() * math.two_pi)
	local spread_rotation = Quaternion.multiply(Quaternion.multiply(direction_rotation, roll), pitch)
	local spread_direction = Quaternion.forward(spread_rotation)

	return spread_direction
end

local DEFAULT_DAMAGE_FALLOFF = {
	falloff_range = 15,
	max_power_reduction = 0.6,
	max_range = 15,
}

MinionAttack.shoot_hit_scan = function (world, physics_world, unit, target_unit, weapon_item, fx_source_name, shoot_position, shoot_template, optional_spread_multiplier, perception_component)
	local toughness_broken_grace_settings = AttackIntensitySettings.toughness_broken_grace
	local diff_toughness_broken_grace_settings = Managers.state.difficulty:get_table_entry_by_challenge(toughness_broken_grace_settings)
	local toughness_extension = ScriptUnit.has_extension(target_unit, "toughness_system")
	local toughness_broken_grace, toughness_broken_grace_spread_multiplier = diff_toughness_broken_grace_settings.duration, diff_toughness_broken_grace_settings.spread_multiplier
	local should_hit = true

	if not shoot_template.shotgun_blast and toughness_extension and toughness_broken_grace > toughness_extension:time_since_toughness_broken() then
		should_hit = false
	end

	local attachment_unit, node = MinionVisualLoadout.attachment_unit_and_node_from_node_name(weapon_item, fx_source_name)
	local from_position = Unit.world_position(attachment_unit, node)
	local shoot_direction = Vector3.normalize(shoot_position - from_position)
	local spread = should_hit and shoot_template.spread or shoot_template.spread * toughness_broken_grace_spread_multiplier
	local spread_direction = _spread_direction(target_unit, unit, shoot_direction, spread, optional_spread_multiplier)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local breed = unit_data_extension:breed()
	local power_level = Managers.state.difficulty:get_minion_attack_power_level(breed, "ranged")
	local damage_falloff = shoot_template.damage_falloff or DEFAULT_DAMAGE_FALLOFF
	local distance = perception_component.target_distance
	local max_range = damage_falloff.max_range

	if max_range < distance then
		local falloff_range = damage_falloff.falloff_range
		local falloff_distance = math.min(distance - max_range, falloff_range)
		local max_power_reduction = damage_falloff.max_power_reduction
		local percentage = math.min(falloff_distance / falloff_range, 1)
		local power_percentage_reduction = 1 - max_power_reduction * percentage

		power_level = power_level * power_percentage_reduction
	end

	local charge_level = 1
	local hit_scan_template = shoot_template.hit_scan_template
	local range, collision_filter = hit_scan_template.range, shoot_template.collision_filter

	if shoot_template.bot_power_level_modifier then
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local target_unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")
		local target_breed_or_nil = unit_data_extension and target_unit_data_extension:breed()
		local is_player_character = Breed.is_player(target_breed_or_nil)

		if is_player_character and not player_unit_spawn_manager:owner(target_unit):is_human_controlled() then
			power_level = power_level * shoot_template.bot_power_level_modifier
		end
	end

	local hits = HitScan.raycast(physics_world, from_position, spread_direction, range, nil, collision_filter)
	local is_server = true
	local end_position

	if should_hit then
		end_position = HitScan.process_hits(is_server, world, physics_world, unit, shoot_template, hits, from_position, spread_direction, power_level, charge_level, IMPACT_FX_DATA, range, nil, nil, nil, nil, nil, nil)
	elseif hits then
		local diff_toughness_broken_grace_power_multiplier = Managers.state.difficulty:get_table_entry_by_challenge(AttackIntensitySettings.toughness_broken_grace_power_multiplier)

		end_position = HitScan.process_hits(is_server, world, physics_world, unit, shoot_template, hits, from_position, spread_direction, power_level * diff_toughness_broken_grace_power_multiplier, charge_level, IMPACT_FX_DATA, range, nil, nil, nil, nil, nil, nil)
	end

	end_position = end_position or from_position + spread_direction * range

	local out_of_bounds_manager = Managers.state.out_of_bounds

	end_position = out_of_bounds_manager:limit_line_end_position_to_soft_cap_extents(from_position, end_position)

	return end_position
end

MinionAttack.init_scratchpad_shooting_variables = function (unit, scratchpad, action_data, blackboard, breed)
	local spawn_component = blackboard.spawn

	scratchpad.world = spawn_component.world
	scratchpad.physics_world = spawn_component.physics_world

	local inventory_slot = action_data.inventory_slot

	if inventory_slot then
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local weapon_item = visual_loadout_extension:slot_item(inventory_slot)

		scratchpad.weapon_item = weapon_item
	end

	scratchpad.current_aim_position = Vector3Box()
	scratchpad.aim_node_name = breed.aim_config.node
	scratchpad.fx_system = Managers.state.extension:system("fx_system")
	scratchpad.fx_extension = ScriptUnit.extension(unit, "fx_system")

	local perception_component = scratchpad.perception_component
	local has_line_of_sight = perception_component.has_line_of_sight

	if has_line_of_sight and action_data.attack_intensity_type then
		local target_unit = perception_component.target_unit
		local attack_allowed = ALIVE[target_unit] and AttackIntensity.minion_can_attack(unit, action_data.attack_intensity_type, target_unit)

		if attack_allowed then
			local ignore_attack_intensity = false
			local wwise_event = action_data.backstab_event or default_backstab_ranged_event
			local dot_threshold = action_data.backstab_dot or default_backstab_ranged_dot

			MinionAttack.check_and_trigger_backstab_sound(unit, action_data, target_unit, wwise_event, dot_threshold, ignore_attack_intensity)
		end
	end
end

MinionAttack.check_and_start_scope_reflection_timing = function (scratchpad, action_data, aim_duration)
	local shoot_template = action_data.shoot_template
	local scope_reflection_distance = shoot_template.scope_reflection_distance

	if scope_reflection_distance then
		local perception_component = scratchpad.perception_component
		local distance = perception_component.target_distance

		if scope_reflection_distance <= distance then
			local scope_reflection_timing = shoot_template.scope_reflection_timing

			scratchpad.scope_reflection_timing = aim_duration - scope_reflection_timing
		end
	end
end

local function _set_shoot_dodge_window(unit, scratchpad, target_unit, dodge_window)
	local extra_timing = 0
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(target_unit)

	if player and player.remote then
		extra_timing = player:lag_compensation_rewind_s()
	end

	local diff_dodge_window = Managers.state.difficulty:get_table_entry_by_challenge(dodge_window)
	local timing = math.random_range(diff_dodge_window[1], diff_dodge_window[2]) + extra_timing

	scratchpad.dodge_window = scratchpad.next_shoot_timing - timing
end

local DEFAULT_SHOOT_ALERT_ALLIES_RADIUS = 12
local DEFAULT_FIRST_SHOOT_TIMING = 0.5

MinionAttack.start_shooting = function (unit, scratchpad, t, action_data, optional_shoot_timing, optional_ignore_add_intensity)
	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local stat_buffs = buff_extension:stat_buffs()
	local ranged_attack_speed = stat_buffs.ranged_attack_speed or 1

	scratchpad.shots_fired = 0

	local first_shoot_timing = optional_shoot_timing or DEFAULT_FIRST_SHOOT_TIMING

	scratchpad.next_shoot_timing = t + first_shoot_timing / ranged_attack_speed

	local num_shots = action_data.num_shots
	local combat_range_shoot_difficulty_settings = action_data.combat_range_shoot_difficulty_settings

	if combat_range_shoot_difficulty_settings then
		local behavior_component = scratchpad.behavior_component
		local combat_range = behavior_component.combat_range

		num_shots = combat_range_shoot_difficulty_settings[combat_range].num_shots
	end

	if num_shots then
		local diff_num_shots = Managers.state.difficulty:get_table_entry_by_challenge(num_shots)
		local shoot_template = action_data.shoot_template
		local minion_num_shots_modifier = shoot_template.shotgun_blast and 1 or stat_buffs.minion_num_shots_modifier or 1

		scratchpad.num_shots = math.random(diff_num_shots[1], diff_num_shots[2]) * minion_num_shots_modifier
	end

	scratchpad.shooting = true

	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit
	local perception_extension = scratchpad.perception_extension

	perception_extension:alert_nearby_allies(target_unit, action_data.alert_allies_radius or DEFAULT_SHOOT_ALERT_ALLIES_RADIUS)

	if not optional_ignore_add_intensity and action_data.attack_intensities then
		AttackIntensity.add_intensity(target_unit, action_data.attack_intensities)
		AttackIntensity.set_attacked(target_unit)
	end

	MinionPerception.set_target_lock(unit, perception_component, true)

	if not scratchpad.scope_reflection_timing then
		MinionAttack.check_and_start_scope_reflection_timing(scratchpad, action_data, scratchpad.next_shoot_timing)
	end

	local dodge_window = action_data.dodge_window

	if dodge_window then
		_set_shoot_dodge_window(unit, scratchpad, target_unit, dodge_window)
	end

	local before_shoot_effect_template_timing = action_data.before_shoot_effect_template_timing

	if before_shoot_effect_template_timing and not scratchpad.before_shoot_effect_template_timing then
		scratchpad.before_shoot_effect_template_timing = t + first_shoot_timing - before_shoot_effect_template_timing
	end

	scratchpad.shoot_attack_speed = ranged_attack_speed
end

local function _handle_shoot_dodge(unit, scratchpad, t, action_data, fx_system)
	local dodge_window = scratchpad.dodge_window

	if dodge_window and dodge_window < t then
		local is_ranged_attack = true
		local fx_source_name = action_data.fx_source_name
		local perception_component = scratchpad.perception_component
		local target_unit = perception_component.target_unit
		local dodge_tell_sfx = action_data.dodge_tell_sfx

		if dodge_tell_sfx and not scratchpad.triggered_dodge_tell_sfx then
			local dodge_tell_sfx_delay = action_data.dodge_tell_sfx_delay

			if dodge_tell_sfx_delay then
				scratchpad.dodge_tell_sfx_delay = t + dodge_tell_sfx_delay
			else
				scratchpad.fx_extension:trigger_inventory_wwise_event(action_data.dodge_tell_sfx, action_data.inventory_slot, fx_source_name, target_unit, is_ranged_attack)
			end

			scratchpad.triggered_dodge_tell_sfx = true

			local dodge_tell_animation = action_data.dodge_tell_animation

			if dodge_tell_animation then
				scratchpad.animation_extension:anim_event(dodge_tell_animation)
			end
		end

		if scratchpad.dodge_tell_sfx_delay and t >= scratchpad.dodge_tell_sfx_delay then
			scratchpad.fx_extension:trigger_inventory_wwise_event(action_data.dodge_tell_sfx, action_data.inventory_slot, fx_source_name, target_unit, is_ranged_attack)

			scratchpad.dodge_tell_sfx_delay = nil
		end

		if not scratchpad.target_dodged_too_early and not scratchpad.scope_reflection_timing then
			local is_dodging, dodge_type = Dodge.is_dodging(target_unit, attack_types.ranged)

			if is_dodging and not scratchpad.dodge_position then
				local aim_pos = scratchpad.current_aim_position:unbox()

				scratchpad.dodge_position = Vector3Box(aim_pos)

				if not scratchpad.successful_dodge then
					local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
					local breed = unit_data_extension:breed()

					if not scratchpad.successful_dodge then
						Dodge.sucessful_dodge(target_unit, unit, attack_types.melee, dodge_type, breed)

						scratchpad.successful_dodge = true
					end
				end
			end
		end
	end
end

MinionAttack.update_shooting = function (unit, scratchpad, t, action_data)
	local current_shoot_timing = math.max(scratchpad.next_shoot_timing - t, 0)
	local attack_delay = MinionAttack.get_attack_delay(unit)
	local global_effect_id = scratchpad.global_effect_id
	local shoot_template = action_data.shoot_template
	local effect_template = shoot_template.effect_template
	local fx_system = scratchpad.fx_system
	local time_left_to_shoot = current_shoot_timing + attack_delay

	if global_effect_id and attack_delay > 0 then
		fx_system:stop_template_effect(global_effect_id)

		scratchpad.global_effect_id = nil
	elseif effect_template and not global_effect_id and time_left_to_shoot == 0 then
		global_effect_id = fx_system:start_template_effect(effect_template, unit)
		scratchpad.global_effect_id = global_effect_id
	end

	local before_shoot_effect_template_timing = scratchpad.before_shoot_effect_template_timing

	if before_shoot_effect_template_timing and before_shoot_effect_template_timing < t then
		local before_shoot_effect_template = action_data.before_shoot_effect_template

		scratchpad.before_shoot_effect_id = fx_system:start_template_effect(before_shoot_effect_template, unit)
		scratchpad.before_shoot_effect_template_timing = nil
	end

	_handle_shoot_dodge(unit, scratchpad, t, action_data, fx_system)

	if time_left_to_shoot == 0 then
		local time_per_shot = action_data.time_per_shot
		local combat_range_shoot_difficulty_settings = action_data.combat_range_shoot_difficulty_settings

		if combat_range_shoot_difficulty_settings then
			local behavior_component = scratchpad.behavior_component
			local combat_range = behavior_component.combat_range

			time_per_shot = combat_range_shoot_difficulty_settings[combat_range].time_per_shot
		end

		local diff_time_per_shot = Managers.state.difficulty:get_table_entry_by_challenge(time_per_shot)

		time_per_shot = math.random_range(diff_time_per_shot[1], diff_time_per_shot[2])
		time_per_shot = time_per_shot / scratchpad.shoot_attack_speed
		scratchpad.shots_fired = scratchpad.shots_fired + 1
		scratchpad.next_shoot_timing = t + time_per_shot

		MinionAttack.shoot(unit, scratchpad, action_data)

		local before_shoot_effect_id = scratchpad.before_shoot_effect_id

		if before_shoot_effect_id then
			fx_system:stop_template_effect(before_shoot_effect_id)

			scratchpad.before_shoot_effect_id = nil
		end

		if scratchpad.shots_fired >= scratchpad.num_shots then
			scratchpad.shots_fired = 0

			MinionAttack.stop_shooting(unit, scratchpad)

			scratchpad.dodge_window = nil
			scratchpad.dodge_position = nil
			scratchpad.triggered_dodge_tell_sfx = nil
			scratchpad.target_dodged_too_early = nil
			scratchpad.successful_dodge = nil
			scratchpad.scope_reflection_timing = nil

			return true, true
		else
			local new_before_shoot_effect_template_timing = action_data.before_shoot_effect_template_timing

			if new_before_shoot_effect_template_timing then
				scratchpad.before_shoot_effect_template_timing = scratchpad.next_shoot_timing - new_before_shoot_effect_template_timing
			end
		end

		return true, false
	end

	return false, false
end

local DEFAULT_SPREAD_MULTIPLIER = 1

MinionAttack.shoot = function (unit, scratchpad, action_data)
	local perception_component = scratchpad.perception_component
	local use_suppressive_fire = action_data.suppressive_fire
	local has_line_of_sight = perception_component.has_line_of_sight

	if not has_line_of_sight and not use_suppressive_fire then
		return
	end

	local extra_spread_multiplier = scratchpad.extra_spread_multiplier or 1
	local spread_multiplier = (action_data.spread_multiplier or DEFAULT_SPREAD_MULTIPLIER) * extra_spread_multiplier

	if not has_line_of_sight then
		spread_multiplier = action_data.suppressive_fire_spread_multiplier
	end

	local target_unit = perception_component.target_unit
	local shoot_position_boxed = scratchpad.dodge_position or scratchpad.current_aim_position
	local weapon_item = scratchpad.weapon_item
	local shoot_position = shoot_position_boxed:unbox()
	local shoot_template = action_data.shoot_template
	local fx_source_name = action_data.fx_source_name
	local world = scratchpad.world
	local physics_world = scratchpad.physics_world
	local end_position = MinionAttack.shoot_hit_scan(world, physics_world, unit, target_unit, weapon_item, fx_source_name, shoot_position, shoot_template, spread_multiplier, perception_component)

	MinionAttack.trigger_shoot_sfx_and_vfx(unit, scratchpad, action_data, end_position)

	if action_data.reset_dodge_check_after_each_shot then
		scratchpad.dodge_position = nil
		scratchpad.successful_dodge = nil
		scratchpad.target_dodged_too_early = nil
		scratchpad.scope_reflection_timing = nil

		_set_shoot_dodge_window(unit, scratchpad, target_unit, action_data.dodge_window)
	end
end

MinionAttack.stop_shooting = function (unit, scratchpad)
	local global_effect_id = scratchpad.global_effect_id

	if global_effect_id then
		local fx_system = scratchpad.fx_system

		fx_system:stop_template_effect(global_effect_id)

		scratchpad.global_effect_id = nil
	end

	local before_shoot_effect_id = scratchpad.before_shoot_effect_id

	if before_shoot_effect_id then
		scratchpad.fx_system:stop_template_effect(before_shoot_effect_id)

		scratchpad.before_shoot_effect_id = nil
	end

	scratchpad.sound_event_triggered = nil
	scratchpad.shooting = nil
	scratchpad.multi_target_changed_t = nil
	scratchpad.num_multi_target_switches = nil

	if not scratchpad.attempting_multi_target_switch then
		MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)
	end
end

MinionAttack.get_attack_delay = function (unit)
	local suppression_extension = ScriptUnit.has_extension(unit, "suppression_system")

	if not suppression_extension then
		return 0
	end

	return suppression_extension:attack_delay()
end

MinionAttack.check_and_trigger_backstab_sound = function (attacking_unit, action_data, target_unit, wwise_event, dot_threshold, ignore_attack_intensity)
	local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
	local target_breed = target_unit_data_extension:breed()

	if action_data.ignore_backstab_sfx or Breed.is_minion(target_breed) then
		return false
	end

	if not ignore_attack_intensity and action_data.attack_intensity_type then
		local attack_allowed = AttackIntensity.minion_can_attack(attacking_unit, action_data.attack_intensity_type, target_unit)

		if not attack_allowed then
			return false
		end
	end

	local first_person_component = target_unit_data_extension:read_component("first_person")
	local look_rotation = first_person_component.rotation
	local look_direction = Vector3.normalize(Vector3.flat(Quaternion.forward(look_rotation)))
	local attacking_unit_position = POSITION_LOOKUP[attacking_unit]
	local player_unit_position = POSITION_LOOKUP[target_unit]
	local to_attacker = Vector3.normalize(Vector3.flat(attacking_unit_position - player_unit_position))
	local dot = Vector3.dot(to_attacker, look_direction)
	local is_behind = dot < dot_threshold

	if not is_behind then
		return false
	end

	local fx_extension = ScriptUnit.extension(target_unit, "fx_system")
	local position = player_unit_position + to_attacker * BACKSTAB_POSITION_OFFSET_DISTANCE

	fx_extension:trigger_exclusive_wwise_event(wwise_event, position)

	return true
end

local ENEMY_BROADPHASE_RESULTS = {}

MinionAttack.push_nearby_enemies = function (unit, scratchpad, action_data, ignored_unit, optional_only_ahead_targets, optional_ignored_breeds)
	table.clear(ENEMY_BROADPHASE_RESULTS)

	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local push_radius = action_data.push_enemies_radius
	local from_position = POSITION_LOOKUP[unit]
	local num_results = broadphase.query(broadphase, from_position, push_radius, ENEMY_BROADPHASE_RESULTS, enemy_side_names)

	if num_results < 1 then
		return
	end

	local pushed_enemies = scratchpad.pushed_enemies
	local from = POSITION_LOOKUP[unit]
	local damage_profile = action_data.push_enemies_damage_profile
	local power_level = action_data.push_enemies_power_level
	local unit_fwd = optional_only_ahead_targets and Quaternion.forward(Unit.local_rotation(unit, 1))

	for i = 1, num_results do
		repeat
			local hit_unit = ENEMY_BROADPHASE_RESULTS[i]
			local should_ignore = not action_data.push_enemies_include_target_unit and ignored_unit == hit_unit

			if hit_unit ~= unit and not pushed_enemies[hit_unit] and not should_ignore then
				local to = POSITION_LOOKUP[hit_unit]
				local direction = Vector3.normalize(Vector3.flat(to - from))

				if Vector3.length_squared(direction) == 0 then
					local current_rotation = Unit.local_rotation(unit, 1)

					direction = Quaternion.forward(current_rotation)
				end

				if optional_only_ahead_targets and Vector3.dot(unit_fwd, direction) < 0 then
					break
				end

				pushed_enemies[hit_unit] = true

				local unit_data_extension = ScriptUnit.has_extension(hit_unit, "unit_data_system")
				local breed_or_nil = unit_data_extension and unit_data_extension:breed()
				local breed_name = breed_or_nil and breed_or_nil.name

				if breed_name and optional_ignored_breeds and optional_ignored_breeds[breed_name] then
					break
				end

				local is_player_character = Breed.is_player(breed_or_nil)

				if is_player_character and action_data.push_enemies_push_template then
					do
						local locomotion_push_component = unit_data_extension:write_component("locomotion_push")

						Push.add(hit_unit, locomotion_push_component, direction, action_data.push_enemies_push_template, "attack")
					end

					break
				end

				if damage_profile then
					Attack.execute(hit_unit, damage_profile, "power_level", power_level, "attacking_unit", unit, "attack_direction", direction, "hit_zone_name", "torso")
				end
			end
		until true
	end
end

local FRIENDLY_BROADPHASE_RESULTS = {}

MinionAttack.push_friendly_minions = function (unit, scratchpad, action_data, t, optional_from_position)
	table.clear(FRIENDLY_BROADPHASE_RESULTS)

	local broadphase_system = scratchpad.broadphase_system
	local broadphase = broadphase_system.broadphase
	local side_system = scratchpad.side_system
	local side = side_system.side_by_unit[unit]
	local broadphase_relation = action_data.push_minions_side_relation
	local target_side_names = side:relation_side_names(broadphase_relation)
	local radius = action_data.push_minions_radius
	local from = optional_from_position or POSITION_LOOKUP[unit]
	local num_results = broadphase.query(broadphase, from, radius, FRIENDLY_BROADPHASE_RESULTS, target_side_names, MINION_BREED_TYPE)

	if num_results < 1 then
		return
	end

	local power_level = action_data.push_minions_power_level
	local damage_profile = action_data.push_minions_damage_profile
	local damage_type = action_data.push_minions_damage_type
	local pushed_minions = scratchpad.pushed_minions
	local push_minions_fx_template = action_data.push_minions_fx_template

	for i = 1, num_results do
		local hit_unit = FRIENDLY_BROADPHASE_RESULTS[i]

		if hit_unit ~= unit and not pushed_minions[hit_unit] then
			local to = POSITION_LOOKUP[hit_unit]
			local direction = Vector3.normalize(to - from)

			if Vector3.length_squared(direction) == 0 then
				local current_rotation = Unit.local_rotation(unit, 1)

				direction = Quaternion.forward(current_rotation)
			end

			local unit_data_extension = ScriptUnit.extension(hit_unit, "unit_data_system")
			local breed = unit_data_extension:breed()
			local tags = breed.tags

			if not tags.monster then
				pushed_minions[hit_unit] = true

				Attack.execute(hit_unit, damage_profile, "power_level", power_level, "attacking_unit", unit, "attack_direction", direction, "hit_zone_name", "torso", "damage_type", damage_type)

				if push_minions_fx_template and (not scratchpad.push_minions_fx_cooldown or t >= scratchpad.push_minions_fx_cooldown) then
					MinionPushFx.play_fx(unit, hit_unit, push_minions_fx_template)

					scratchpad.push_minions_fx_cooldown = t + math.random_range(action_data.push_minions_fx_cooldown[1], action_data.push_minions_fx_cooldown[2])
				end
			end
		end
	end
end

local _check_max_z_diff, _check_weapon_reach, _get_weapon_reach, _melee_hit, _melee_with_broadphase, _melee_with_oobb, _melee_with_weapon_reach
local DEFAULT_DODGE_REACH = 2.4

MinionAttack.sweep = function (unit, breed, sweep_node, scratchpad, blackboard, target_unit, action_data, physics_world, sweep_hit_units_cache, override_damage_profile_or_nil, override_damage_type_or_nil, attack_event, optional_ignore_target_unit)
	local node = Unit.node(unit, sweep_node)
	local position = Unit.world_position(unit, node)
	local radius = _get_weapon_reach(action_data, attack_event)
	local collision_filter = action_data.collision_filter
	local shape = action_data.sweep_shape or "sphere"
	local actors, actor_count, extents

	if shape == "oobb" then
		local sweep_length = action_data.sweep_length
		local sweep_height = action_data.sweep_height
		local sweep_width = action_data.sweep_width
		local rotation = Unit.world_rotation(unit, node)

		extents = Vector3(sweep_width, sweep_length, sweep_height)
		actors, actor_count = PhysicsWorld.immediate_overlap(physics_world, "shape", shape, "position", position, "rotation", rotation, "size", extents, "types", "both", "collision_filter", collision_filter)
	else
		actors, actor_count = PhysicsWorld.immediate_overlap(physics_world, "shape", shape, "position", position, "size", radius, "types", "both", "collision_filter", collision_filter)
	end

	local hit = false
	local hits_one_target = action_data.hits_one_target
	local HEALTH_ALIVE = HEALTH_ALIVE

	for i = 1, actor_count do
		local hit_actor = actors[i]
		local hit_unit = Actor.unit(hit_actor)
		local target_ignore_override = optional_ignore_target_unit and hit_unit == target_unit

		if HEALTH_ALIVE[hit_unit] and not sweep_hit_units_cache[hit_unit] and hit_unit ~= unit and not target_ignore_override then
			local actor_position = Actor.position(hit_actor)
			local is_dodging, dodge_type = Dodge.is_dodging(hit_unit, attack_types.melee)

			is_dodging = not action_data.ignore_dodge and is_dodging

			local in_reach = _check_weapon_reach(position, actor_position, action_data, is_dodging, nil, attack_event)

			if in_reach then
				sweep_hit_units_cache[hit_unit] = true
				hit = true

				local offtarget_hit = hit_unit ~= target_unit

				_melee_hit(unit, breed, scratchpad, blackboard, hit_unit, actor_position, action_data, override_damage_profile_or_nil, override_damage_type_or_nil, offtarget_hit)

				if hits_one_target then
					break
				end
			end

			if not hit and is_dodging and not scratchpad.successful_dodge then
				Dodge.sucessful_dodge(hit_unit, unit, attack_types.melee, dodge_type, breed)

				sweep_hit_units_cache[hit_unit] = true
				scratchpad.successful_dodge = true
			end
		end
	end

	return hit
end

MinionAttack.melee = function (unit, breed, scratchpad, blackboard, target_unit, action_data, physics_world, override_damage_profile_or_nil, override_damage_type_or_nil, attack_event)
	local hit
	local attack_type = action_data.attack_type

	if attack_type == "oobb" then
		hit = _melee_with_oobb(unit, breed, scratchpad, blackboard, target_unit, action_data, physics_world, override_damage_profile_or_nil, override_damage_type_or_nil)
	elseif attack_type == "broadphase" then
		hit = _melee_with_broadphase(unit, breed, scratchpad, action_data, blackboard, target_unit, override_damage_profile_or_nil, override_damage_type_or_nil, attack_event)
	else
		hit = _melee_with_weapon_reach(unit, breed, scratchpad, blackboard, target_unit, action_data, override_damage_profile_or_nil, override_damage_type_or_nil, attack_event)
	end

	local ground_impact_fx_template = action_data.ground_impact_fx_template

	if ground_impact_fx_template then
		GroundImpact.play(unit, physics_world, ground_impact_fx_template)
	end

	return hit
end

local DEFAULT_DODGE_REACH_LAG_COMPENSATION = 2.25
local DEFAULT_REACH_CONE = 0.75
local DEFAULT_DODGE_REACH_CONE = 0.94
local NUM_LAG_COMPENSATION_CHECKS = 10

MinionAttack.update_lag_compensation_melee = function (unit, breed, scratchpad, blackboard, t, action_data)
	if not scratchpad.lag_compensation_timing or not scratchpad.lag_compensation_attacking then
		return
	end

	if t < scratchpad.lag_compensation_timing and not scratchpad.next_lag_compensation_check_t then
		local check_frequency = scratchpad.lag_compensation_rewind_s / NUM_LAG_COMPENSATION_CHECKS

		scratchpad.next_lag_compensation_check_t = t + check_frequency
	end

	if scratchpad.next_lag_compensation_check_t and t >= scratchpad.next_lag_compensation_check_t then
		local hit_position = scratchpad.lag_compensation_hit_position:unbox()
		local target_unit = scratchpad.lag_compensation_target_unit
		local damage_profile = scratchpad.lag_compensation_damage_profile
		local damage_type = scratchpad.lag_compensation_damage_type
		local hit = _melee_hit(unit, breed, scratchpad, blackboard, target_unit, hit_position, action_data, damage_profile, damage_type)

		scratchpad.next_lag_compensation_check_t = nil

		if hit then
			scratchpad.lag_compensation_attacking = nil
			scratchpad.lag_compensation_timing = nil
		end
	elseif t >= scratchpad.lag_compensation_timing then
		scratchpad.lag_compensation_attacking = nil
		scratchpad.lag_compensation_timing = nil
		scratchpad.next_lag_compensation_check_t = nil

		local hit_position = scratchpad.lag_compensation_hit_position:unbox()
		local target_unit = scratchpad.lag_compensation_target_unit
		local damage_profile = scratchpad.lag_compensation_damage_profile
		local damage_type = scratchpad.lag_compensation_damage_type
		local is_dodging = scratchpad.lag_compensation_dodging

		if is_dodging then
			local unit_position = POSITION_LOOKUP[unit]
			local target_position = POSITION_LOOKUP[target_unit]
			local unit_rotation = Unit.local_rotation(unit, 1)
			local forward = Quaternion.forward(unit_rotation)
			local to_target = Vector3.flat(target_position - unit_position)
			local dot = Vector3.dot(Vector3.normalize(to_target), forward)
			local reach_cone = is_dodging and (action_data.dodge_reach_cone or DEFAULT_DODGE_REACH_CONE) or action_data.weapon_reach_cone or DEFAULT_REACH_CONE

			if dot < reach_cone then
				return
			end

			local dodge_check_position = Vector3(unit_position.x, unit_position.y, target_position.z)
			local distance = Vector3.distance(dodge_check_position, target_position)

			if distance >= DEFAULT_DODGE_REACH_LAG_COMPENSATION then
				return
			end
		end

		_melee_hit(unit, breed, scratchpad, blackboard, target_unit, hit_position, action_data, damage_profile, damage_type)
	end
end

MinionAttack.melee_oobb_extents = function (unit, action_data)
	local width, range, height = action_data.width, action_data.range, action_data.height
	local half_width, half_range, half_height = width * 0.5, range * 0.5, height * 0.5
	local hit_size = Vector3(half_width, half_range, half_height)
	local dodge_width, dodge_range, dodge_height = action_data.dodge_width or width, action_data.dodge_range or range, action_data.dodge_height or height
	local half_dodge_width, half_dodge_range, half_dodge_height = dodge_width * 0.5, dodge_range * 0.5, dodge_height * 0.5
	local dodge_hit_size = Vector3(half_dodge_width, half_dodge_range, half_dodge_height)
	local node = action_data.oobb_node and Unit.node(unit, action_data.oobb_node) or 1
	local self_position = Unit.world_position(unit, node)
	local rotation = action_data.oobb_use_unit_rotation and Unit.local_rotation(unit, 1) or Unit.local_rotation(unit, node)
	local forward = Quaternion.forward(rotation)
	local position = self_position + forward * half_range
	local offset_bwd = action_data.offset_bwd

	if offset_bwd then
		position = position - forward * offset_bwd
	end

	return position, rotation, hit_size, dodge_hit_size
end

MinionAttack.melee_broadphase_extents = function (unit, action_data)
	local from_position
	local node_name = action_data.broadphase_node

	if node_name then
		local node = Unit.node(unit, node_name)
		local node_position = Unit.world_position(unit, node)

		from_position = node_position
	else
		from_position = POSITION_LOOKUP[unit]
	end

	local broadphase_radius = action_data.weapon_reach

	return from_position, broadphase_radius
end

local MELEE_DOGPILE_POWER_LEVEL_MODIFIER = {
	1,
	1,
	0.9,
	0.85,
	0.7,
	0.65,
	0.5,
}

function _melee_hit(unit, breed, scratchpad, blackboard, target_unit, hit_position, action_data, override_damage_profile_or_nil, override_damage_type_or_nil, offtarget_hit_or_nil)
	local side_system = Managers.state.extension:system("side_system")
	local is_ally = side_system:is_ally(unit, target_unit)
	local friendly_fire_damage_profile = action_data.friendly_fire_damage_profile
	local offtarget_damage_profile = action_data.offtarget_damage_profile
	local damage_profile = override_damage_profile_or_nil or is_ally and friendly_fire_damage_profile or offtarget_hit_or_nil and offtarget_damage_profile or action_data.damage_profile
	local attack_type = attack_types.melee
	local target_weapon_template, target_buff_extension
	local unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")
	local breed_or_nil = unit_data_extension and unit_data_extension:breed()
	local is_player_character = Breed.is_player(breed_or_nil)

	if not offtarget_hit_or_nil and is_player_character and scratchpad.lag_compensation_timing then
		local weapon_action_component = unit_data_extension:read_component("weapon_action")

		target_weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
		target_buff_extension = ScriptUnit.extension(target_unit, "buff_system")

		local is_blockable = Block.attack_is_blockable(damage_profile, target_unit, target_weapon_template, target_buff_extension)
		local is_blocking = Block.is_blocking(target_unit, unit, attack_type, target_weapon_template, true)
		local is_dodging = Dodge.is_dodging(target_unit, attack_type)

		if not is_blocking and is_blockable or is_dodging or scratchpad.target_dodged_during_attack then
			if not scratchpad.lag_compensation_attacking then
				scratchpad.lag_compensation_hit_position = Vector3Box(hit_position)
				scratchpad.lag_compensation_target_unit = target_unit
				scratchpad.lag_compensation_damage_profile = damage_profile
				scratchpad.lag_compensation_damage_type = override_damage_type_or_nil or action_data.damage_type
			end

			if not scratchpad.lag_compensation_dodging then
				scratchpad.lag_compensation_dodging = is_dodging
			end

			scratchpad.lag_compensation_attacking = true

			return false
		end
	end

	local power_level = Managers.state.difficulty:get_minion_attack_power_level(breed, action_data.power_level_type or "melee")
	local unit_position = POSITION_LOOKUP[unit]
	local target_position = POSITION_LOOKUP[target_unit]
	local attack_direction = Vector3.normalize(target_position - unit_position)

	if Vector3.length_squared(attack_direction) == 0 then
		local rotation = Unit.local_rotation(unit, 1)

		attack_direction = Quaternion.forward(rotation)
	end

	local player_unit_spawn_manager = Managers.state.player_unit_spawn

	if action_data.bot_power_level_modifier and is_player_character and not player_unit_spawn_manager:owner(target_unit):is_human_controlled() then
		power_level = power_level * action_data.bot_power_level_modifier
	end

	local power_level_modifier = Managers.state.havoc:get_power_level_modifier(attack_type)

	power_level = power_level * power_level_modifier

	if is_player_character then
		local slot_extension = ScriptUnit.extension(target_unit, "slot_system")
		local num_occupied_slots = slot_extension.num_occupied_slots

		if num_occupied_slots > 0 then
			local dogpile_power_level_modifier = MELEE_DOGPILE_POWER_LEVEL_MODIFIER[math.min(num_occupied_slots, #MELEE_DOGPILE_POWER_LEVEL_MODIFIER)]

			power_level = power_level * dogpile_power_level_modifier
		end
	end

	local damage_type = override_damage_type_or_nil or action_data.damage_type
	local damage, result, damage_efficiency = Attack.execute(target_unit, damage_profile, "power_level", power_level, "attacking_unit", unit, "hit_world_position", hit_position, "attack_direction", attack_direction, "attack_type", attack_type, "damage_type", damage_type, "hit_zone_name", action_data.hit_zone_name)

	ImpactEffect.play(target_unit, nil, damage, damage_type, nil, result, hit_position, nil, attack_direction, unit, nil, nil, nil, damage_efficiency, damage_profile)

	if result == attack_results.blocked and not action_data.ignore_blocked and not damage_profile.unblockable then
		if is_player_character then
			local weapon_action_component = unit_data_extension:read_component("weapon_action")
			local weapon_template = weapon_action_component and WeaponTemplate.current_weapon_template(weapon_action_component)

			if weapon_template then
				local _, action_setting = Action.current_action(weapon_action_component, weapon_template)

				if action_setting and action_setting.ignore_setting_blocked_on_minions then
					return result
				end
			end
		end

		local blocked_component = Blackboard.write_component(blackboard, "blocked")

		blocked_component.is_blocked = true
	end

	return result
end

function _get_weapon_reach(action_data, attack_event)
	local weapon_reach = type(action_data.weapon_reach) == "table" and (action_data.weapon_reach[attack_event] or action_data.weapon_reach.default) or action_data.weapon_reach

	return weapon_reach
end

function _check_weapon_reach(attack_position, target_position, action_data, is_dodging, optional_ignore_z, attack_event)
	local to_target = target_position - attack_position

	if optional_ignore_z then
		to_target = Vector3.flat(to_target)
	end

	local distance = Vector3.length(to_target)
	local reach = _get_weapon_reach(action_data, attack_event)

	if is_dodging then
		reach = action_data.dodge_weapon_reach or math.min(DEFAULT_DODGE_REACH, reach)
	end

	return distance <= reach
end

local DEFAULT_MAX_Z_DIFF = 2.2

function _check_max_z_diff(attack_position, target_position, action_data)
	local z_diff = math.abs(target_position.z - attack_position.z)

	return z_diff < (action_data.max_z_diff or DEFAULT_MAX_Z_DIFF)
end

function _melee_with_weapon_reach(unit, breed, scratchpad, blackboard, target_unit, action_data, override_damage_profile_or_nil, override_damage_type_or_nil, attack_event)
	local perception_component = blackboard.perception
	local has_line_of_sight = perception_component.has_line_of_sight

	if not has_line_of_sight then
		return
	end

	local hit = false
	local target_position = POSITION_LOOKUP[target_unit]
	local unit_position = POSITION_LOOKUP[unit]
	local is_dodging, dodge_type = Dodge.is_dodging(target_unit, attack_types.melee)

	is_dodging = not action_data.ignore_dodge and (scratchpad.target_dodged_during_attack or is_dodging)

	local ignore_z = true
	local in_reach = _check_weapon_reach(unit_position, target_position, action_data, is_dodging, ignore_z, attack_event)
	local in_height = _check_max_z_diff(unit_position, target_position, action_data)

	if in_reach and in_height then
		local unit_rotation = Unit.local_rotation(unit, 1)
		local forward = Quaternion.forward(unit_rotation)
		local to_target = Vector3.flat(target_position - unit_position)
		local dot = Vector3.dot(Vector3.normalize(to_target), forward)
		local reach_cone = is_dodging and (action_data.dodge_reach_cone or DEFAULT_DODGE_REACH_CONE) or action_data.weapon_reach_cone or DEFAULT_REACH_CONE

		if reach_cone < dot then
			local hit_node_index = Unit.node(target_unit, "enemy_aim_target_01")
			local hit_position = Unit.world_position(target_unit, hit_node_index)

			_melee_hit(unit, breed, scratchpad, blackboard, target_unit, hit_position, action_data, override_damage_profile_or_nil, override_damage_type_or_nil)

			hit = true
		end
	end

	if not hit and is_dodging and not scratchpad.successful_dodge then
		Dodge.sucessful_dodge(target_unit, unit, attack_types.melee, dodge_type, breed)

		scratchpad.successful_dodge = true
	end

	return hit
end

local CHECKED_OOBB_UNITS = {}

function _melee_with_oobb(unit, breed, scratchpad, blackboard, target_unit, action_data, physics_world, override_damage_profile_or_nil, override_damage_type_or_nil)
	local position, rotation, hit_size, dodge_hit_size = MinionAttack.melee_oobb_extents(unit, action_data)
	local dodge_hit_pose = Matrix4x4.from_quaternion_position(rotation, position)
	local collision_filter = action_data.collision_filter
	local actors, actor_count = PhysicsWorld.immediate_overlap(physics_world, "position", position, "rotation", rotation, "size", hit_size, "shape", "oobb", "types", "dynamics", "collision_filter", collision_filter)
	local hit = false
	local point_in_box = math.point_in_box
	local hits_one_target = action_data.hits_one_target
	local hit_target_unit = false

	table.clear(CHECKED_OOBB_UNITS)

	local HEALTH_ALIVE = HEALTH_ALIVE

	for i = 1, actor_count do
		local actor = actors[i]
		local hit_unit = Actor.unit(actor)

		if HEALTH_ALIVE[hit_unit] and not CHECKED_OOBB_UNITS[hit_unit] and hit_unit ~= unit then
			CHECKED_OOBB_UNITS[hit_unit] = true

			local hit_unit_position = POSITION_LOOKUP[hit_unit]
			local is_dodging, dodge_type = Dodge.is_dodging(hit_unit, attack_types.melee)

			is_dodging = not action_data.ignore_dodge and (is_dodging or hit_unit == target_unit and scratchpad.target_dodged_during_attack)

			local in_reach = true

			if is_dodging then
				in_reach = point_in_box(hit_unit_position, dodge_hit_pose, dodge_hit_size)
			end

			if not scratchpad.successful_dodge and not in_reach and (is_dodging or scratchpad.target_dodged_during_attack) then
				Dodge.sucessful_dodge(hit_unit, unit, attack_types.melee, dodge_type, breed)

				if hit_unit == target_unit then
					scratchpad.successful_dodge = true
				end
			end

			if in_reach then
				local offtarget_hit = hit_unit ~= target_unit

				hit = true

				_melee_hit(unit, breed, scratchpad, blackboard, hit_unit, hit_unit_position, action_data, override_damage_profile_or_nil, override_damage_type_or_nil, offtarget_hit)

				if hit_unit == hit_target_unit then
					hit_target_unit = true
				end

				if hits_one_target then
					break
				end
			end
		end
	end

	if not hit_target_unit and not scratchpad.successful_dodge and scratchpad.target_dodged_during_attack then
		Dodge.sucessful_dodge(target_unit, unit, attack_types.melee, nil, breed)

		scratchpad.successful_dodge = true
	end

	return hit
end

local ATTACK_BROADPHASE_RESULTS = {}

function _melee_with_broadphase(unit, breed, scratchpad, action_data, blackboard, target_unit, override_damage_profile_or_nil, override_damage_type_or_nil, attack_event)
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]
	local relation = action_data.broadphase_relation or "enemy"
	local target_side_names = side:relation_side_names(relation)
	local from_position, broadphase_radius = MinionAttack.melee_broadphase_extents(unit, action_data)
	local hit = false
	local hits_one_target = action_data.hits_one_target

	table.clear(ATTACK_BROADPHASE_RESULTS)

	local num_results = broadphase.query(broadphase, from_position, broadphase_radius, ATTACK_BROADPHASE_RESULTS, target_side_names)

	for i = 1, num_results do
		local hit_unit = ATTACK_BROADPHASE_RESULTS[i]

		if hit_unit ~= unit then
			local hit_unit_position = POSITION_LOOKUP[hit_unit]
			local is_dodging, dodge_type = Dodge.is_dodging(hit_unit, attack_types.melee)
			local in_reach = _check_weapon_reach(from_position, hit_unit_position, action_data, is_dodging, nil, attack_event)

			if in_reach then
				local offtarget_hit = hit_unit ~= target_unit

				hit = true

				_melee_hit(unit, breed, scratchpad, blackboard, hit_unit, hit_unit_position, action_data, override_damage_profile_or_nil, override_damage_type_or_nil, offtarget_hit)

				if hits_one_target then
					break
				end
			end

			if not hit and is_dodging and not scratchpad.successful_dodge then
				Dodge.sucessful_dodge(hit_unit, unit, attack_types.melee, dodge_type, breed)

				scratchpad.successful_dodge = true
			end
		end
	end

	return hit
end

return MinionAttack
