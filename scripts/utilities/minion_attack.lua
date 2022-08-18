local Attack = require("scripts/utilities/attack/attack")
local AttackIntensity = require("scripts/utilities/attack_intensity")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Block = require("scripts/utilities/attack/block")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local Dodge = require("scripts/extension_systems/character_state_machine/character_states/utilities/dodge")
local DodgeSettings = require("scripts/settings/dodge/dodge_settings")
local GroundImpact = require("scripts/utilities/attack/ground_impact")
local HitScan = require("scripts/utilities/attack/hit_scan")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local MinionBackstabSettings = require("scripts/settings/minion_backstab/minion_backstab_settings")
local MinionPerception = require("scripts/utilities/minion_perception")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local attack_results = AttackSettings.attack_results
local attack_types = AttackSettings.attack_types
local dodge_types = DodgeSettings.dodge_types
local proc_events = BuffSettings.proc_events
local default_backstab_ranged_dot = MinionBackstabSettings.ranged_backstab_dot
local default_backstab_ranged_event = MinionBackstabSettings.ranged_backstab_event
local MinionAttack = {}
local IMPACT_FX_DATA = {}
local BACKSTAB_POSITION_OFFSET_DISTANCE = 2
local AIM_DOT_THRESHOLD = 0
local DEFAULT_ENEMY_AIM_NODE = "enemy_aim_target_03"

MinionAttack.aim_at_target = function (unit, scratchpad, t, action_data)
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit
	local target_position = nil

	if perception_component.has_line_of_sight then
		target_position = Unit.world_position(target_unit, Unit.node(target_unit, DEFAULT_ENEMY_AIM_NODE))
	else
		local perception_extension = scratchpad.perception_extension
		target_position = perception_extension:last_los_position(target_unit)

		if not target_position then
			return false
		end
	end

	local aim_node = Unit.node(unit, scratchpad.aim_node_name)
	local unit_position = Unit.world_position(unit, aim_node)
	local to_target = target_position - unit_position
	local to_target_direction = Vector3.normalize(to_target)
	local flat_to_target_direction = Vector3.flat(to_target_direction)
	local unit_rotation = Unit.local_rotation(unit, 1)
	local unit_forward = Quaternion.forward(unit_rotation)
	local dot = Vector3.dot(unit_forward, flat_to_target_direction)
	local valid_angle = true

	if scratchpad.start_rotation_timing == nil and dot < AIM_DOT_THRESHOLD then
		local wanted_rotation = Quaternion.look(flat_to_target_direction)

		scratchpad.locomotion_extension:set_wanted_rotation(wanted_rotation)

		valid_angle = false
	end

	scratchpad.current_aim_position:store(target_position)
	MinionAttack.update_scope_reflection(unit, scratchpad, t, action_data)

	return valid_angle, dot, flat_to_target_direction
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

	local direction_rotation = Quaternion.look(shoot_direction, Vector3.up())
	local pitch = Quaternion(Vector3.right(), spread_angle)
	local roll = Quaternion(Vector3.forward(), math.random() * math.two_pi)
	local spread_rotation = Quaternion.multiply(Quaternion.multiply(direction_rotation, roll), pitch)
	local spread_direction = Quaternion.forward(spread_rotation)

	return spread_direction
end

MinionAttack.shoot_hit_scan = function (world, physics_world, unit, target_unit, weapon_item, fx_source_name, shoot_position, shoot_template, optional_spread_multiplier)
	local attachment_unit, node = MinionVisualLoadout.attachment_unit_and_node_from_node_name(weapon_item, fx_source_name)
	local from_position = Unit.world_position(attachment_unit, node)
	local shoot_direction = Vector3.normalize(shoot_position - from_position)
	local spread_direction = _spread_direction(target_unit, unit, shoot_direction, shoot_template.spread, optional_spread_multiplier)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local breed = unit_data_extension:breed()
	local power_level = Managers.state.difficulty:get_minion_attack_power_level(breed, "ranged")
	local charge_level = 1
	local hit_scan_template = shoot_template.hit_scan_template
	local range = hit_scan_template.range
	local collision_filter = shoot_template.collision_filter
	local hits = HitScan.raycast(physics_world, from_position, spread_direction, range, nil, collision_filter)
	local is_server = true
	local end_position = HitScan.process_hits(is_server, world, physics_world, unit, shoot_template, hits, from_position, spread_direction, power_level, charge_level, IMPACT_FX_DATA, range, nil, nil, nil, nil, nil)
	end_position = end_position or from_position + spread_direction * range
	local min_position = NetworkConstants.min_position
	local max_position = NetworkConstants.max_position
	local network_position_extent = math.min((max_position - min_position) * 0.5, math.abs(min_position), max_position)
	local hard_cap_extents = Vector3(network_position_extent, network_position_extent, network_position_extent)
	local soft_cap_extents = hard_cap_extents * 0.9
	local distance_along_ray = Intersect.ray_box(end_position, from_position - end_position, Matrix4x4.identity(), soft_cap_extents)

	if distance_along_ray and distance_along_ray > 0 then
		end_position = from_position + (end_position - from_position) * (1 - distance_along_ray)
	end

	return end_position
end

MinionAttack.init_scratchpad_shooting_variables = function (unit, scratchpad, action_data, blackboard, breed)
	local spawn_component = blackboard.spawn
	scratchpad.world = spawn_component.world
	scratchpad.physics_world = spawn_component.physics_world
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local weapon_item = visual_loadout_extension:slot_item(action_data.inventory_slot)
	scratchpad.weapon_item = weapon_item
	scratchpad.current_aim_position = Vector3Box()
	scratchpad.aim_node_name = breed.aim_config.node
	scratchpad.fx_system = Managers.state.extension:system("fx_system")
	scratchpad.fx_extension = ScriptUnit.extension(unit, "fx_system")
	local perception_component = scratchpad.perception_component
	local has_line_of_sight = perception_component.has_line_of_sight

	if has_line_of_sight and action_data.attack_intensity_type then
		local target_unit = perception_component.target_unit
		local attack_allowed = AttackIntensity.minion_can_attack(unit, action_data.attack_intensity_type, target_unit)

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

	local is_dodging = Dodge.is_dodging(target_unit, attack_types.ranged)

	if is_dodging then
		scratchpad.target_dodged_too_early = true
	end

	local diff_dodge_window = Managers.state.difficulty:get_table_entry_by_challenge(dodge_window)
	local timing = math.random_range(diff_dodge_window[1], diff_dodge_window[2]) + extra_timing
	scratchpad.dodge_window = scratchpad.next_shoot_timing - timing
end

local DEFAULT_SHOOT_ALERT_ALLIES_RADIUS = 20
local DEFAULT_FIRST_SHOOT_TIMING = 0.5

MinionAttack.start_shooting = function (unit, scratchpad, t, action_data, optional_shoot_timing, optional_ignore_add_intensity)
	scratchpad.shots_fired = 0
	local first_shoot_timing = optional_shoot_timing or DEFAULT_FIRST_SHOOT_TIMING
	scratchpad.next_shoot_timing = t + first_shoot_timing
	local num_shots = action_data.num_shots
	local diff_num_shots = Managers.state.difficulty:get_table_entry_by_challenge(num_shots)
	scratchpad.num_shots = math.random(diff_num_shots[1], diff_num_shots[2])
	scratchpad.shooting = true
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit
	local perception_extension = scratchpad.perception_extension

	perception_extension:alert_nearby_allies(target_unit, action_data.alert_allies_radius or DEFAULT_SHOOT_ALERT_ALLIES_RADIUS)

	if not optional_ignore_add_intensity then
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

		if scratchpad.dodge_tell_sfx_delay and scratchpad.dodge_tell_sfx_delay <= t then
			scratchpad.fx_extension:trigger_inventory_wwise_event(action_data.dodge_tell_sfx, action_data.inventory_slot, fx_source_name, target_unit, is_ranged_attack)

			scratchpad.dodge_tell_sfx_delay = nil
		end

		if not scratchpad.target_dodged_too_early and not scratchpad.scope_reflection_timing then
			local is_dodging = Dodge.is_dodging(target_unit, attack_types.ranged)

			if is_dodging and not scratchpad.dodge_position then
				local aim_pos = scratchpad.current_aim_position:unbox()
				scratchpad.dodge_position = Vector3Box(aim_pos)
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
		local diff_time_per_shot = Managers.state.difficulty:get_table_entry_by_challenge(time_per_shot)
		time_per_shot = math.random_range(diff_time_per_shot[1], diff_time_per_shot[2])
		scratchpad.shots_fired = scratchpad.shots_fired + 1
		scratchpad.next_shoot_timing = t + time_per_shot

		MinionAttack.shoot(unit, scratchpad, action_data)

		local before_shoot_effect_id = scratchpad.before_shoot_effect_id

		if before_shoot_effect_id then
			fx_system:stop_template_effect(before_shoot_effect_id)

			scratchpad.before_shoot_effect_id = nil
		end

		if scratchpad.num_shots <= scratchpad.shots_fired then
			scratchpad.shots_fired = 0

			MinionAttack.stop_shooting(unit, scratchpad)

			scratchpad.dodge_window = nil
			scratchpad.dodge_position = nil
			scratchpad.triggered_dodge_tell_sfx = nil
			scratchpad.target_dodged_too_early = nil

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

	local spread_multiplier = action_data.spread_multiplier or DEFAULT_SPREAD_MULTIPLIER

	if not has_line_of_sight then
		spread_multiplier = action_data.suppressive_fire_spread_multiplier
	end

	local target_unit = scratchpad.perception_component.target_unit
	local shoot_position_boxed = scratchpad.dodge_position or scratchpad.current_aim_position
	local weapon_item = scratchpad.weapon_item
	local shoot_position = shoot_position_boxed:unbox()
	local shoot_template = action_data.shoot_template
	local fx_source_name = action_data.fx_source_name
	local world = scratchpad.world
	local physics_world = scratchpad.physics_world
	local end_position = MinionAttack.shoot_hit_scan(world, physics_world, unit, target_unit, weapon_item, fx_source_name, shoot_position, shoot_template, spread_multiplier)

	MinionAttack.trigger_shoot_sfx_and_vfx(unit, scratchpad, action_data, end_position)

	if action_data.reset_dodge_check_after_each_shot then
		scratchpad.dodge_position = nil

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
	local look_direction = Vector3.flat(Quaternion.forward(look_rotation))
	local attacking_unit_position = POSITION_LOOKUP[attacking_unit]
	local player_unit_position = POSITION_LOOKUP[target_unit]
	local to_target = Vector3.normalize(Vector3.flat(attacking_unit_position - player_unit_position))
	local dot = Vector3.dot(to_target, look_direction)
	local is_behind = dot < dot_threshold

	if not is_behind then
		return false
	end

	local fx_extension = ScriptUnit.extension(target_unit, "fx_system")
	local position = player_unit_position + to_target * BACKSTAB_POSITION_OFFSET_DISTANCE

	fx_extension:trigger_exclusive_wwise_event(wwise_event, position)

	return true
end

local ENEMY_BROADPHASE_RESULTS = {}

MinionAttack.push_nearby_enemies = function (unit, scratchpad, action_data, ignored_unit)
	table.clear(ENEMY_BROADPHASE_RESULTS)

	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local push_radius = action_data.push_enemies_radius
	local from_position = POSITION_LOOKUP[unit]
	local num_results = broadphase:query(from_position, push_radius, ENEMY_BROADPHASE_RESULTS, enemy_side_names)

	if num_results < 1 then
		return
	end

	local ALIVE = ALIVE
	local pushed_enemies = scratchpad.pushed_enemies
	local from = POSITION_LOOKUP[unit]
	local damage_profile = action_data.push_enemies_damage_profile
	local power_level = action_data.push_enemies_power_level

	for i = 1, num_results do
		local hit_unit = ENEMY_BROADPHASE_RESULTS[i]

		if ALIVE[hit_unit] and hit_unit ~= unit and not pushed_enemies[hit_unit] and hit_unit ~= ignored_unit then
			local to = POSITION_LOOKUP[hit_unit]
			local direction = Vector3.normalize(to - from)

			if Vector3.length_squared(direction) == 0 then
				local current_rotation = Unit.local_rotation(unit, 1)
				direction = Quaternion.forward(current_rotation)
			end

			pushed_enemies[hit_unit] = true

			Attack.execute(hit_unit, damage_profile, "power_level", power_level, "attacking_unit", unit, "attack_direction", direction, "hit_zone_name", "torso")
		end
	end
end

local FRIENDLY_BROADPHASE_RESULTS = {}

MinionAttack.push_friendly_minions = function (unit, scratchpad, action_data)
	table.clear(FRIENDLY_BROADPHASE_RESULTS)

	local broadphase_system = scratchpad.broadphase_system
	local broadphase = broadphase_system.broadphase
	local side_system = scratchpad.side_system
	local side = side_system.side_by_unit[unit]
	local broadphase_relation = action_data.push_minions_side_relation
	local target_side_names = side:relation_side_names(broadphase_relation)
	local radius = action_data.push_minions_radius
	local from = POSITION_LOOKUP[unit]
	local num_results = broadphase:query(from, radius, FRIENDLY_BROADPHASE_RESULTS, target_side_names)

	if num_results < 1 then
		return
	end

	local power_level = action_data.push_minions_power_level
	local damage_profile = action_data.push_minions_damage_profile
	local damage_type = action_data.push_minions_damage_type
	local pushed_minions = scratchpad.pushed_minions

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

			if Breed.is_minion(breed) then
				local tags = breed.tags

				if not tags.monster then
					pushed_minions[hit_unit] = true

					Attack.execute(hit_unit, damage_profile, "power_level", power_level, "attacking_unit", unit, "attack_direction", direction, "hit_zone_name", "torso", "damage_type", damage_type)
				end
			end
		end
	end
end

local _check_max_z_diff, _check_weapon_reach, _get_weapon_reach, _melee_hit, _melee_with_broadphase, _melee_with_oobb, _melee_with_weapon_reach, _sucessfull_dodge = nil
local DEFAULT_DODGE_REACH = 2.75

MinionAttack.sweep = function (unit, breed, scratchpad, blackboard, target_unit, action_data, physics_world, sweep_hit_units_cache, override_damage_profile_or_nil, override_damage_type_or_nil, attack_event)
	local node_name = action_data.sweep_node
	local node = Unit.node(unit, node_name)
	local position = Unit.world_position(unit, node)
	local radius = _get_weapon_reach(action_data, attack_event)
	local collision_filter = action_data.collision_filter
	local actors, actor_count = PhysicsWorld.immediate_overlap(physics_world, "shape", "sphere", "position", position, "size", radius, "types", "both", "collision_filter", collision_filter)
	local hit = false
	local hits_one_target = action_data.hits_one_target
	local HEALTH_ALIVE = HEALTH_ALIVE

	for i = 1, actor_count do
		local hit_actor = actors[i]
		local hit_unit = Actor.unit(hit_actor)

		if HEALTH_ALIVE[hit_unit] and not sweep_hit_units_cache[hit_unit] and hit_unit ~= unit then
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

			if not hit and is_dodging then
				_sucessfull_dodge(hit_unit, unit, attack_types.melee, dodge_type, breed)

				sweep_hit_units_cache[hit_unit] = true
			end
		end
	end

	return hit
end

MinionAttack.melee = function (unit, breed, scratchpad, blackboard, target_unit, action_data, physics_world, override_damage_profile_or_nil, override_damage_type_or_nil, attack_event)
	local hit = nil
	local attack_type = action_data.attack_type

	if attack_type == "oobb" then
		hit = _melee_with_oobb(unit, breed, scratchpad, blackboard, target_unit, action_data, physics_world, override_damage_profile_or_nil, override_damage_type_or_nil)
	elseif attack_type == "broadphase" then
		hit = _melee_with_broadphase(unit, breed, scratchpad, action_data, blackboard, target_unit, override_damage_profile_or_nil, override_damage_type_or_nil, attack_event)
	else
		hit = _melee_with_weapon_reach(unit, breed, scratchpad, blackboard, target_unit, action_data, override_damage_profile_or_nil, override_damage_type_or_nil, attack_event)
	end

	if not hit then
		local ground_impact_fx_template = action_data.ground_impact_fx_template

		if ground_impact_fx_template then
			GroundImpact.play(unit, physics_world, ground_impact_fx_template)
		end
	end

	return hit
end

local DEFAULT_DODGE_REACH_LAG_COMPENSATION = 2.25
local DEFAULT_REACH_CONE = 0.75
local DEFAULT_DODGE_REACH_CONE = 0.93
local NUM_LAG_COMPENSATION_CHECKS = 10

MinionAttack.update_lag_compensation_melee = function (unit, breed, scratchpad, blackboard, t, action_data)
	if not scratchpad.lag_compensation_timing or not scratchpad.lag_compensation_attacking then
		return
	end

	if t < scratchpad.lag_compensation_timing and not scratchpad.next_lag_compensation_check_t then
		local check_frequency = scratchpad.lag_compensation_rewind_s / NUM_LAG_COMPENSATION_CHECKS
		scratchpad.next_lag_compensation_check_t = t + check_frequency
	end

	if scratchpad.next_lag_compensation_check_t and scratchpad.next_lag_compensation_check_t <= t then
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
	elseif scratchpad.lag_compensation_timing <= t then
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

			if DEFAULT_DODGE_REACH_LAG_COMPENSATION <= distance then
				return
			end
		end

		_melee_hit(unit, breed, scratchpad, blackboard, target_unit, hit_position, action_data, damage_profile, damage_type)
	end
end

MinionAttack.melee_oobb_extents = function (unit, action_data)
	local width = action_data.width
	local range = action_data.range
	local height = action_data.height
	local half_width = width * 0.5
	local half_range = range * 0.5
	local half_height = height * 0.5
	local hit_size = Vector3(half_width, half_range, half_height)
	local dodge_width = action_data.dodge_width or width
	local dodge_range = action_data.dodge_range or range
	local dodge_height = action_data.dodge_height or height
	local half_dodge_width = dodge_width * 0.5
	local half_dodge_range = dodge_range * 0.5
	local half_dodge_height = dodge_height * 0.5
	local dodge_hit_size = Vector3(half_dodge_width, half_dodge_range, half_dodge_height)
	local rotation = Unit.local_rotation(unit, 1)
	local forward = Quaternion.forward(rotation)
	local self_position = POSITION_LOOKUP[unit]
	local position = self_position + forward * half_range

	return position, rotation, hit_size, dodge_hit_size
end

MinionAttack.melee_broadphase_extents = function (unit, action_data)
	local from_position = nil
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

function _melee_hit(unit, breed, scratchpad, blackboard, target_unit, hit_position, action_data, override_damage_profile_or_nil, override_damage_type_or_nil, offtarget_hit_or_nil)
	local damage_profile = override_damage_profile_or_nil or offtarget_hit_or_nil and action_data.offtarget_damage_profile or action_data.damage_profile
	local attack_type = attack_types.melee
	local target_weapon_template = nil
	local unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")
	local breed_or_nil = unit_data_extension and unit_data_extension:breed()
	local is_player_character = Breed.is_player(breed_or_nil)

	if not offtarget_hit_or_nil and is_player_character and scratchpad.lag_compensation_timing then
		local weapon_action_component = unit_data_extension:read_component("weapon_action")
		target_weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
		local is_blockable = Block.attack_is_blockable(damage_profile)
		local is_blocking = Block.is_blocking(target_unit, attack_type, target_weapon_template, true)
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
	local damage_type = override_damage_type_or_nil or action_data.damage_type
	local damage, result, damage_efficiency = Attack.execute(target_unit, damage_profile, "power_level", power_level, "attacking_unit", unit, "hit_world_position", hit_position, "attack_direction", attack_direction, "attack_type", attack_type, "damage_type", damage_type, "hit_zone_name", action_data.hit_zone_name)

	ImpactEffect.play(target_unit, nil, damage, damage_type, nil, result, hit_position, nil, attack_direction, unit, nil, nil, nil, damage_efficiency, damage_profile)

	if result == attack_results.blocked and not action_data.ignore_blocked then
		local blocked_component = Blackboard.write_component(blackboard, "blocked")
		blocked_component.is_blocked = true
	end

	return result
end

local _sucessfull_dodge_parameters = {}

function _sucessfull_dodge(dodging_unit, attacking_unit, attack_type, dodge_type, attacking_breed)
	local dodging_unit_fx_extension = ScriptUnit.has_extension(dodging_unit, "fx_system")

	if dodging_unit_fx_extension then
		local optional_position = nil
		local optional_except_sender = false
		local is_elite = attacking_breed and attacking_breed.tags and attacking_breed.tags.elite
		local is_special = attacking_breed and attacking_breed.tags and attacking_breed.tags.special
		local is_monster = attacking_breed and attacking_breed.tags and attacking_breed.tags.monster

		table.clear(_sucessfull_dodge_parameters)

		_sucessfull_dodge_parameters.enemy_type = is_monster and "monster" or is_special and "special" or is_elite and "elite" or nil

		dodging_unit_fx_extension:trigger_exclusive_gear_wwise_event("dodge_success_melee", _sucessfull_dodge_parameters, optional_position, optional_except_sender)
	end

	local dodging_unit_buff_extension = ScriptUnit.has_extension(dodging_unit, "buff_system")

	if dodging_unit_buff_extension then
		local param_table = dodging_unit_buff_extension:request_proc_event_param_table()
		param_table.dodging_unit = dodging_unit
		param_table.attacking_unit = attacking_unit
		param_table.attack_type = attack_type

		dodging_unit_buff_extension:add_proc_event(proc_events.on_successful_dodge, param_table)
	end

	if DEDICATED_SERVER then
		local breed_name = attacking_breed.name
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local dodging_player = player_unit_spawn_manager:owner(dodging_unit)
		local is_human = dodging_player and dodging_player:is_human_controlled()

		if is_human then
			dodge_type = dodge_type or dodge_types.dodge

			Managers.stats:record_dodge(dodging_player, breed_name, attack_type, dodge_type)
		end
	end
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

	if not action_data.ignore_dodge then
		if not scratchpad.target_dodged_during_attack then
			-- Nothing
		end
	else
		is_dodging = false
	end

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

	if not hit and is_dodging then
		_sucessfull_dodge(target_unit, unit, attack_types.melee, dodge_type, breed)
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

			if in_reach then
				local offtarget_hit = hit_unit ~= target_unit
				hit = true

				_melee_hit(unit, breed, scratchpad, blackboard, hit_unit, hit_unit_position, action_data, override_damage_profile_or_nil, override_damage_type_or_nil, offtarget_hit)

				if hits_one_target then
					break
				end
			end

			if not hit and is_dodging then
				_sucessfull_dodge(hit_unit, unit, attack_types.melee, dodge_type, breed)
			end
		end
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

	local num_results = broadphase:query(from_position, broadphase_radius, ATTACK_BROADPHASE_RESULTS, target_side_names)
	local ALIVE = ALIVE

	for i = 1, num_results do
		local hit_unit = ATTACK_BROADPHASE_RESULTS[i]

		if ALIVE[hit_unit] and hit_unit ~= unit then
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

			if not hit and is_dodging then
				_sucessfull_dodge(hit_unit, unit, attack_types.melee, dodge_type, breed)
			end
		end
	end

	return hit
end

return MinionAttack
