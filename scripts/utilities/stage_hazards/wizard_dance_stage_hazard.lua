-- chunkname: @scripts/utilities/stage_hazards/wizard_dance_stage_hazard.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local LevelProps = require("scripts/settings/level_prop/level_props")
local Component = require("scripts/utilities/component")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local BossPhaseUtilities = require("scripts/utilities/phases/boss_phase_utilities")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local WizardDanceStageHazard = {}
local ACTION_DATA = BreedActions.renegade_wizard.dance
local attack_type = AttackSettings.attack_types
local KNOCKBACK_SFX = "wwise/events/minions/play_enemy_psyker_push"
local KNOCKBACK_COOLDOWN = 0.3
local _init_floor_zones, _set_new_zone, _spawn_dance_walls, _damage, _update_distance_to_players, _update_attack, _zone_from_distance, _get_downed_target_zone, _knockback

WizardDanceStageHazard.init = function (scratchpad, wants_walls)
	if scratchpad.dance_hazard then
		WizardDanceStageHazard.exit(scratchpad)
	end

	scratchpad.dance_hazard = {}
	scratchpad.dance_hazard.player_position_data = {}
	scratchpad.dance_hazard.next_allowed_knockback_t = {}
	scratchpad.dance_hazard.num_finished_attacks = 0
	scratchpad.dance_hazard.wants_walls = wants_walls or false

	local unit = scratchpad.boss_unit
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]

	scratchpad.dance_hazard.side = side
end

WizardDanceStageHazard.wants_walls = function (scratchpad)
	local dance_hazard = scratchpad.dance_hazard

	return dance_hazard ~= nil and dance_hazard.wants_walls == true
end

WizardDanceStageHazard.update = function (scratchpad, t)
	local dance_hazard = scratchpad.dance_hazard

	if not dance_hazard or not dance_hazard.active then
		return
	end

	local unit = scratchpad.boss_unit
	local blackboard = scratchpad.blackboard
	local player_position_data = dance_hazard.player_position_data

	_update_distance_to_players(unit, player_position_data, dance_hazard)
	_update_attack(unit, dance_hazard, blackboard, player_position_data, t)

	if dance_hazard.should_knockback then
		_knockback(unit, player_position_data, ACTION_DATA, dance_hazard, t)
	end
end

WizardDanceStageHazard.is_mid_attack = function (scratchpad)
	local dance_hazard = scratchpad.dance_hazard

	if not dance_hazard or not dance_hazard.active then
		return false
	end

	return dance_hazard.is_damaging == true
end

WizardDanceStageHazard.set_disallowed_zone = function (scratchpad, zone)
	local dance_hazard = scratchpad.dance_hazard

	if not dance_hazard then
		return
	end

	dance_hazard.disallowed_zone = zone
end

WizardDanceStageHazard.exit = function (scratchpad)
	local dance_hazard = scratchpad.dance_hazard

	if not dance_hazard then
		return
	end

	local side = dance_hazard.side
	local enemy_sides = side:relation_sides("enemy")
	local group_system = Managers.state.extension:system("group_system")
	local bot_groups = group_system:bot_groups_from_sides(enemy_sides)

	for i = 1, #bot_groups do
		bot_groups[i]:clear_hover_targets()
	end

	if dance_hazard.effect_template_id then
		local fx_system = Managers.state.extension:system("fx_system")

		for i = 1, #dance_hazard.effect_template_id do
			local effect_id = dance_hazard.effect_template_id[i]

			fx_system:stop_template_effect(effect_id)
		end
	end

	if dance_hazard.dance_walls_unit then
		Managers.state.unit_spawner:mark_for_deletion(dance_hazard.dance_walls_unit)
	end

	scratchpad.dance_hazard = nil
end

WizardDanceStageHazard.on_phase_event_triggered = function (scratchpad, event_name)
	local dance_hazard = scratchpad.dance_hazard

	if not dance_hazard then
		return
	end

	local t = Managers.time:time("gameplay")
	local unit = scratchpad.boss_unit
	local blackboard = scratchpad.blackboard

	if event_name == "set_new_zone" then
		_set_new_zone(unit, dance_hazard, blackboard, t)
	elseif event_name == "spawn_dance_walls" then
		if dance_hazard.wants_walls and not ALIVE[scratchpad.dance_walls_unit] then
			_spawn_dance_walls(unit, scratchpad, dance_hazard, blackboard, t)
		end
	elseif event_name == "init_floor_zones" then
		_init_floor_zones(unit, dance_hazard)
	end
end

function _init_floor_zones(unit, dance_hazard)
	local fx_system = Managers.state.extension:system("fx_system")
	local effect_template_names = ACTION_DATA.effect_template_names
	local effect_template_name = effect_template_names.dance
	local effect_template = EffectTemplates[effect_template_name]

	dance_hazard.effect_template_id = dance_hazard.effect_template_id or {}
	dance_hazard.center_position = Vector3Box(POSITION_LOOKUP[unit])

	if fx_system:has_running_template_of_name(unit, effect_template_name) then
		return
	end

	local effect_id = fx_system:start_template_effect(effect_template, unit)

	dance_hazard.effect_template_id[#dance_hazard.effect_template_id + 1] = effect_id
end

local shape_data = {}
local TOLERANCE = 0.8
local SHOULD_DODGE = true

function _set_new_zone(unit, dance_hazard, blackboard, t)
	dance_hazard.active = true
	dance_hazard.is_damaging = true
	dance_hazard.delay, dance_hazard.attack_timing, dance_hazard.attack_duration, dance_hazard.anim_duration = BossPhaseUtilities.get_spillway_psyker_dance_variables(ACTION_DATA, t)

	local spawn_component = blackboard.spawn
	local game_session, game_object_id = spawn_component.game_session, spawn_component.game_object_id
	local last_zone = GameSession.game_object_field(game_session, game_object_id, "safe_zone")
	local num_zones = #ACTION_DATA.circle_settings
	local disallowed_zone = dance_hazard.disallowed_zone
	local chances = ACTION_DATA.target_downed_zone_chance
	local chance = Managers.state.difficulty:get_table_entry_by_challenge(chances)
	local target_zone

	if chance > 0 and chance > math.random() then
		target_zone = _get_downed_target_zone(dance_hazard, last_zone, disallowed_zone)
	end

	local random_zone

	if target_zone then
		random_zone = target_zone
	else
		repeat
			random_zone = math.random(1, num_zones)
		until random_zone ~= last_zone and random_zone ~= disallowed_zone
	end

	dance_hazard.previous_zone = last_zone

	GameSession.set_game_object_field(game_session, game_object_id, "safe_zone", random_zone)

	dance_hazard.current_zone = random_zone

	local center_position = dance_hazard.center_position:unbox()
	local circle_settings = ACTION_DATA.circle_settings[random_zone]
	local side = dance_hazard.side
	local enemy_sides = side:relation_sides("enemy")
	local group_system = Managers.state.extension:system("group_system")
	local bot_groups = group_system:bot_groups_from_sides(enemy_sides)

	table.clear(shape_data)

	shape_data.radius = math.lerp(circle_settings.inner_radius, circle_settings.outer_radius, 0.5)
	shape_data.thickness = circle_settings.outer_radius - circle_settings.inner_radius

	local radius = math.lerp(circle_settings.inner_radius, circle_settings.outer_radius, 0.5)

	for i = 1, #bot_groups do
		local bot_group = bot_groups[i]

		bot_group:set_positions_to_hover(center_position, radius, TOLERANCE, SHOULD_DODGE, dance_hazard.anim_duration)
	end
end

function _spawn_dance_walls(unit, scratchpad, dance_hazard, blackboard, t)
	local position = blackboard.abilites.ability_position:unbox()
	local is_equal = Vector3.equal(position, Vector3(0, 0, 0))

	if is_equal then
		return nil
	end

	if dance_hazard.dance_walls_unit then
		Managers.state.unit_spawner:mark_for_deletion(dance_hazard.dance_walls_unit)

		dance_hazard.dance_walls_unit = nil
		dance_hazard.start_wall_rotation = nil
	end

	local prop_settings = LevelProps.dance_walls
	local dance_unit, _ = Managers.state.unit_spawner:spawn_network_unit(prop_settings.unit_name, "level_prop", position, Quaternion.identity(), nil, prop_settings)
	local dance_wall_components = Component.get_components_by_name(dance_unit, "WizardBossDanceWalls")

	dance_wall_components[1]:set_center_position(POSITION_LOOKUP[unit])

	dance_hazard.dance_walls_unit = dance_unit
	scratchpad.dance_walls_unit = dance_unit
	dance_hazard.should_knockback = true

	local fx_system = Managers.state.extension:system("fx_system")
	local effect_template_names = ACTION_DATA.effect_template_names
	local effect_template_name = effect_template_names.knockback
	local effect_template = EffectTemplates[effect_template_name]
	local effect_id = fx_system:start_template_effect(effect_template, unit)

	dance_hazard.effect_template_id[#dance_hazard.effect_template_id + 1] = effect_id
end

function _update_attack(unit, dance_hazard, blackboard, player_position_data, t)
	local spawn_component = blackboard.spawn
	local game_session, game_object_id = spawn_component.game_session, spawn_component.game_object_id

	if dance_hazard.awaiting_next_wave then
		dance_hazard.awaiting_next_wave = nil

		_set_new_zone(unit, dance_hazard, blackboard, t)
	end

	if dance_hazard.attack_timing and t > dance_hazard.attack_timing then
		_damage(unit, dance_hazard, ACTION_DATA, player_position_data)
		GameSession.set_game_object_field(game_session, game_object_id, "should_play_damage_vfx", true)

		dance_hazard.attack_timing = 0.5 + t

		if dance_hazard.dance_walls_unit and not dance_hazard.start_wall_rotation then
			dance_hazard.start_wall_rotation = true

			local dance_wall_components = Component.get_components_by_name(dance_hazard.dance_walls_unit, "WizardBossDanceWalls")

			dance_wall_components[1]:start_rotation()
		end
	end

	if dance_hazard.anim_duration and t > dance_hazard.anim_duration then
		GameSession.set_game_object_field(game_session, game_object_id, "should_play_damage_vfx", false)

		dance_hazard.is_damaging = false
		dance_hazard.attack_timing = nil
		dance_hazard.anim_duration = nil
		dance_hazard.awaiting_next_wave = true
		dance_hazard.num_finished_attacks = dance_hazard.num_finished_attacks + 1

		if dance_hazard.dance_walls_unit then
			dance_hazard.start_wall_rotation = nil
		end
	end
end

function _update_distance_to_players(unit, player_position_data, dance_hazard)
	table.clear(player_position_data)

	local side = dance_hazard.side
	local valid_enemy_player_units = side.valid_enemy_player_units
	local num_enemies = #valid_enemy_player_units
	local position = dance_hazard.center_position:unbox()

	for i = 1, num_enemies do
		local player_unit = valid_enemy_player_units[i]
		local player_position = POSITION_LOOKUP[player_unit]
		local distance_from_target = Vector3.distance(position, player_position)

		player_position_data[#player_position_data + 1] = {
			player_unit = player_unit,
			distance = distance_from_target,
			player_position = player_position,
		}
	end
end

function _zone_from_distance(distance)
	local circle_settings = ACTION_DATA.circle_settings

	for i = 1, #circle_settings do
		local ring = circle_settings[i]

		if distance >= ring.inner_radius and distance <= ring.outer_radius then
			return i
		end
	end

	return nil
end

local downed_zone_candidates = {}

function _get_downed_target_zone(dance_hazard, last_zone, disallowed_zone)
	table.clear(downed_zone_candidates)

	local side = dance_hazard.side
	local valid_enemy_player_units = side.valid_enemy_player_units
	local center_position = dance_hazard.center_position:unbox()

	for i = 1, #valid_enemy_player_units do
		local player_unit = valid_enemy_player_units[i]
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")

		if PlayerUnitStatus.is_knocked_down(character_state_component) then
			local distance = Vector3.distance(center_position, POSITION_LOOKUP[player_unit])
			local zone = _zone_from_distance(distance)

			if zone and zone ~= last_zone and zone ~= disallowed_zone then
				downed_zone_candidates[#downed_zone_candidates + 1] = zone
			end
		end
	end

	local num_candidates = #downed_zone_candidates

	if num_candidates == 0 then
		return nil
	end

	return downed_zone_candidates[math.random(1, num_candidates)]
end

function _damage(unit, dance_hazard, action_data, player_position_data)
	local current_zone = dance_hazard.current_zone
	local current_safe_zone_range = action_data.circle_settings[current_zone]

	for i = 1, #player_position_data do
		local player_data = player_position_data[i]
		local player_distance_from_boss = player_data.distance

		if (player_distance_from_boss < current_safe_zone_range.inner_radius or player_distance_from_boss > current_safe_zone_range.outer_radius) and HEALTH_ALIVE[player_data.player_unit] then
			local damage_template = DamageProfileTemplates.spillway_wizard_dance_floor_burn
			local power_level_table = MinionDifficultySettings.power_level.chaos_engulfed_enemy_fire_attack
			local power_level = Managers.state.difficulty:get_table_entry_by_challenge(power_level_table)
			local optional_owner_unit

			Attack.execute(player_data.player_unit, damage_template, "power_level", power_level, "damage_type", "burning", "attacking_unit", optional_owner_unit)

			local buff_extension = ScriptUnit.has_extension(player_data.player_unit, "buff_system")

			if buff_extension then
				local t = Managers.time:time("gameplay")

				buff_extension:add_internally_controlled_buff("spillway_wizard_toughness_reduction_stacking", t)
			end
		end
	end
end

function _knockback(unit, player_position_data, action_data, dance_hazard, t)
	local damage_template = DamageProfileTemplates.spillway_wizard_dance_wall_knockback
	local center_position = dance_hazard.center_position:unbox()
	local center_position_flat = Vector3.flat(center_position)
	local knockback_range = action_data.knockback_range
	local next_allowed_knockback_t = dance_hazard.next_allowed_knockback_t

	for i = 1, #player_position_data do
		local player_data = player_position_data[i]
		local player_unit = player_data.player_unit
		local player_distance_from_boss = player_data.distance
		local next_allowed_t = next_allowed_knockback_t[player_unit]
		local is_on_cooldown = next_allowed_t ~= nil and t < next_allowed_t

		if not is_on_cooldown and player_distance_from_boss < knockback_range and HEALTH_ALIVE[player_unit] then
			next_allowed_knockback_t[player_unit] = t + KNOCKBACK_COOLDOWN

			local player_position_flat = Vector3.flat(player_data.player_position)
			local to_player = player_position_flat - center_position_flat
			local direction

			if Vector3.length_squared(to_player) > 0.0001 then
				direction = Vector3.normalize(to_player)
			else
				local facing_flat = Vector3.flat(Quaternion.forward(Unit.local_rotation(player_unit, 1)))

				direction = Vector3.length_squared(facing_flat) > 0.0001 and Vector3.normalize(-facing_flat) or Vector3.forward()
			end

			local head_node = Unit.node(player_unit, "j_head")
			local hit_world_position = Unit.world_position(player_unit, head_node)
			local damage_type = "minion_charge"

			Attack.execute(player_unit, damage_template, "power_level", 250, "attacking_unit", unit, "attack_type", attack_type.explosion, "attack_direction", direction, "hit_world_position", hit_world_position, "damage_type", damage_type, "hit_zone_name", action_data.hit_zone_name)

			local fx_system = Managers.state.extension:system("fx_system")

			fx_system:trigger_wwise_event(KNOCKBACK_SFX, center_position)
		end
	end
end

return WizardDanceStageHazard
