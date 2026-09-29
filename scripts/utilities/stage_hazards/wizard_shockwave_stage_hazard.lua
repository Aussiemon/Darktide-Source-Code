-- chunkname: @scripts/utilities/stage_hazards/wizard_shockwave_stage_hazard.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local Attack = require("scripts/utilities/attack/attack")
local Catapulted = require("scripts/extension_systems/character_state_machine/character_states/utilities/catapulted")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local LevelProps = require("scripts/settings/level_prop/level_props")
local WizardTeethStageHazard = require("scripts/utilities/stage_hazards/wizard_teeth_stage_hazard")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local Stagger = require("scripts/utilities/attack/stagger")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local TeethStageHazard = require("scripts/utilities/stage_hazards/wizard_teeth_stage_hazard")
local damage_types = DamageSettings.damage_types
local action_data = BreedActions.renegade_wizard.force_push
local stagger_types = StaggerSettings.stagger_types
local WizardShockwaveStageHazard = {}
local ARENA_RADIUS = 32
local WAVE_THICKNESS = 1
local WALL_SLAM_MAX_POWER_LEVEL = 500
local PUSH_TOUGHNESS_BREAK_DISTANCE_THRESHOLD = 3
local PUSH_TOUGHNESS_DAMAGE_BY_DIFFICULTY = {
	10,
	50,
	70,
	100,
	100,
}

WizardShockwaveStageHazard.tooth_cover_settings = {
	half_width_far = 6.25,
	half_width_near = 0.625,
	length = 25,
}

local TOOTH_COVER = WizardShockwaveStageHazard.tooth_cover_settings
local _update_player_data, _update_shockwave, _update_player_hit_by_attack, _update_minion_stagger, _get_minion_stagger_and_duration, _is_protected_by_tooth, _catapult, _update_collision, _deal_push_damage, _deal_slam_damage, _query_enemy_units, _debug_draw_wave, _create_shockwave_plane_unit, _destroy_shockwave_plane_unit, _start_effect_template, _stop_effect_template, _update_shockwave_gameobject, _clear_bot_hover_targets

WizardShockwaveStageHazard.init = function (scratchpad)
	scratchpad.shockwave_hazard = {
		wave_data = {
			wave_id = 0,
		},
		player_datas = {},
		enemy_units = {},
	}

	_update_shockwave_gameobject(scratchpad.boss_unit, false)

	local old_plane = scratchpad.shockwave_plane_unit

	if old_plane and ALIVE[old_plane] then
		scratchpad.shockwave_hazard.plane_respawn_pending = true

		return
	end

	_create_shockwave_plane_unit(scratchpad)
end

WizardShockwaveStageHazard.update = function (scratchpad, t)
	local hazard_data = scratchpad.shockwave_hazard

	if hazard_data.plane_respawn_pending then
		local old_plane = scratchpad.shockwave_plane_unit

		if old_plane and ALIVE[old_plane] then
			return
		end

		_create_shockwave_plane_unit(scratchpad)

		hazard_data.plane_respawn_pending = false
	end

	hazard_data.player_datas = _update_player_data(scratchpad.boss_unit, hazard_data.player_datas)

	_update_shockwave(t, scratchpad)
end

WizardShockwaveStageHazard.respawn_plane = function (scratchpad)
	local hazard_data = scratchpad.shockwave_hazard

	if not hazard_data or hazard_data.plane_respawn_pending then
		return
	end

	_destroy_shockwave_plane_unit(scratchpad)

	local wave_data = hazard_data.wave_data

	if wave_data.wave_id < #action_data.wave_parameters then
		hazard_data.plane_respawn_pending = true
	end
end

WizardShockwaveStageHazard.exit = function (scratchpad)
	if scratchpad.shockwave_hazard then
		_stop_effect_template(scratchpad.shockwave_hazard)
		_destroy_shockwave_plane_unit(scratchpad)
		_clear_bot_hover_targets(scratchpad)
		_update_shockwave_gameobject(scratchpad.boss_unit, false)

		scratchpad.shockwave_hazard = nil

		TeethStageHazard.lower_all_teeth(scratchpad)
	end
end

function _clear_bot_hover_targets(scratchpad)
	local boss_unit = scratchpad.boss_unit
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[boss_unit]

	if not side then
		return
	end

	local enemy_sides = side:relation_sides("enemy")
	local group_system = Managers.state.extension:system("group_system")
	local bot_groups = group_system:bot_groups_from_sides(enemy_sides)

	for i = 1, #bot_groups do
		bot_groups[i]:clear_hover_targets()
	end
end

local WIND_DOWN_TIME = 1

WizardShockwaveStageHazard.start_shockwave = function (scratchpad, wave_id)
	local t = Managers.time:time("gameplay")
	local hazard_data = scratchpad.shockwave_hazard
	local wave_data = hazard_data.wave_data
	local player_datas = hazard_data.player_datas
	local enemy_units = hazard_data.enemy_units

	wave_data.wave_id = math.index_wrapper(wave_data.wave_id + 1, #action_data.wave_parameters)

	local wave_parameters = action_data.wave_parameters[wave_data.wave_id]

	wave_data.start_t = t
	wave_data.end_t = t + wave_parameters.travel_time + WIND_DOWN_TIME
	wave_data.horizontal_magnitude = Managers.state.difficulty:get_table_entry_by_challenge(wave_parameters.horizontal_magnitude)
	wave_data.vertical_magnitude = Managers.state.difficulty:get_table_entry_by_challenge(wave_parameters.vertical_magnitude)
	wave_data.wall_slam_damage_modifier = Managers.state.difficulty:get_table_entry_by_challenge(wave_parameters.wall_slam_damage_modifier)
	wave_data.resolved = false
	wave_data.teeth_randomized = false

	_start_effect_template(scratchpad, hazard_data, wave_parameters.travel_time)

	for player_unit, data in pairs(player_datas) do
		data.hit_by_wave = false
		data.wall_slammed = false
	end

	local boss_unit = scratchpad.boss_unit
	local boss_position = POSITION_LOOKUP[scratchpad.boss_unit]

	table.clear(enemy_units)
	_query_enemy_units(boss_unit, boss_position, ARENA_RADIUS, enemy_units)
end

WizardShockwaveStageHazard.is_cycle_done = function (scratchpad)
	local wave_data = scratchpad.shockwave_hazard and scratchpad.shockwave_hazard.wave_data

	return wave_data and wave_data.wave_id >= #action_data.wave_parameters
end

WizardShockwaveStageHazard.is_wave_done = function (scratchpad, t)
	local wave_data = scratchpad.shockwave_hazard and scratchpad.shockwave_hazard.wave_data

	return wave_data and t > wave_data.end_t
end

WizardShockwaveStageHazard.is_initialized = function (scratchpad)
	return scratchpad.shockwave_hazard ~= nil
end

local TEMP = {}

function _update_player_data(boss_unit, player_datas)
	local players = Managers.player:players()
	local new_datas = TEMP
	local center_pos_flat = Vector3.flat(POSITION_LOOKUP[boss_unit])

	for _, player in pairs(players) do
		local player_unit = player.player_unit

		if ALIVE[player_unit] then
			local player_data = player_datas[player_unit] or {}

			player_data.buff_data = player_data.buff_data or {}
			player_data.buff_extension = player_data.buff_extension or ScriptUnit.has_extension(player_unit, "buff_system")
			player_data.unit_data_extension = player_data.unit_data_extension or ScriptUnit.has_extension(player_unit, "unit_data_system")
			player_data.locomotion_extension = player_data.locomotion_extension or ScriptUnit.has_extension(player_unit, "locomotion_system")
			player_data.position = Unit.world_position(player_unit, 1)
			player_data.player_unit = player_unit
			player_data.to_vector = Vector3.normalize(Vector3.flat(player_data.position) - center_pos_flat)
			player_data.center_distance = Vector3.distance(Vector3.flat(player_data.position), center_pos_flat)
			new_datas[player_unit] = player_data
		elseif player_datas[player_unit] then
			table.clear(player_datas[player_unit])
		end
	end

	TEMP = player_datas

	table.clear(TEMP)

	player_datas = new_datas

	return player_datas
end

local STAGGER_DURATION_PER_TYPE = {
	[stagger_types.light] = 1,
	[stagger_types.medium] = 2,
	[stagger_types.heavy] = 3,
	[stagger_types.explosion] = 4,
}

function _get_minion_stagger_and_duration(tags)
	local stagger_type

	if tags.monster or tags.captain then
		stagger_type = stagger_types.light
	elseif tags.ogryn then
		stagger_type = stagger_types.light
	elseif tags.special then
		stagger_type = stagger_types.medium
	elseif tags.elite then
		stagger_type = stagger_types.medium
	elseif tags.roamer then
		stagger_type = stagger_types.heavy
	else
		stagger_type = stagger_types.explosion
	end

	return stagger_type, STAGGER_DURATION_PER_TYPE[stagger_type]
end

function _update_minion_stagger(enemy_units, boss_unit, boss_position, shockwave_center_distance, wedge_origin_flat, teeth_positions, is_raised)
	for idx, enemy_unit in pairs(enemy_units) do
		local enemy_pos = enemy_unit and POSITION_LOOKUP[enemy_unit]

		if enemy_pos then
			local dist_from_wave = Vector3.distance(boss_position, enemy_pos) - shockwave_center_distance

			if dist_from_wave < WAVE_THICKNESS and enemy_unit ~= boss_unit then
				local unit_data_extension = ScriptUnit.has_extension(enemy_unit, "unit_data_system")

				if unit_data_extension and not _is_protected_by_tooth(wedge_origin_flat, enemy_pos, teeth_positions, is_raised) then
					local breed = unit_data_extension:breed()
					local stagger_direction = enemy_pos - boss_position
					local stagger_type, duration = _get_minion_stagger_and_duration(breed.tags)

					Stagger.force_stagger(enemy_unit, stagger_type, stagger_direction, duration, nil, duration, boss_unit)
				end

				enemy_units[idx] = nil
			end
		else
			enemy_units[idx] = nil
		end
	end
end

function _query_enemy_units(boss_unit, boss_position, radius, query_results)
	local extension_manager = Managers.state.extension
	local broadphase_system = extension_manager:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local side = ScriptUnit.extension(boss_unit, "side_system").side
	local relation_side_names = side:relation_side_names("allied")
	local num_hits = Broadphase.query(broadphase, boss_position, radius, query_results, relation_side_names)

	return num_hits
end

function _update_player_hit_by_attack(t, player_unit, player_data, wave_data, shockwave_center_distance, wedge_origin_flat, teeth_positions, is_raised)
	if player_data.hit_by_wave then
		return
	end

	if math.abs(player_data.center_distance - shockwave_center_distance) > WAVE_THICKNESS then
		return
	end

	if teeth_positions and _is_protected_by_tooth(wedge_origin_flat, player_data.position, teeth_positions, is_raised) then
		player_data.hit_by_wave = true

		return
	end

	local locomotion_extension = ScriptUnit.has_extension(player_unit, "locomotion_system")
	local player_velocity = locomotion_extension:current_velocity()
	local player_velocity_normalized = Vector3.normalize(player_velocity)

	_catapult(player_data.player_unit, player_data.to_vector, player_data.unit_data_extension, wave_data)
	_deal_push_damage(player_unit, player_velocity_normalized, player_data.center_distance, wave_data.wall_slam_damage_modifier)

	player_data.hit_by_wave = true
end

function _is_protected_by_tooth(wedge_origin_flat, unit_position, teeth_positions, is_raised)
	if not teeth_positions then
		return false
	end

	local player_pos_flat = Vector3.flat(unit_position)

	for tooth_unit, position_boxed in pairs(teeth_positions) do
		local tooth_raised = not is_raised or is_raised[tooth_unit]

		if ALIVE[tooth_unit] and tooth_raised then
			local tooth_pos_flat = Vector3.flat(position_boxed:unbox())
			local to_tooth = tooth_pos_flat - wedge_origin_flat

			if Vector3.length_squared(to_tooth) > 0 then
				local away_direction = Vector3.normalize(to_tooth)
				local tooth_to_player = player_pos_flat - tooth_pos_flat
				local dot = Vector3.dot(tooth_to_player, away_direction)

				if dot >= 0 and dot <= TOOTH_COVER.length then
					local lateral = Vector3.length(tooth_to_player - away_direction * dot)
					local half_width = math.lerp(TOOTH_COVER.half_width_near, TOOTH_COVER.half_width_far, dot / TOOTH_COVER.length)

					if lateral <= half_width then
						return true
					end
				end
			end
		end
	end

	return false
end

function _catapult(unit, to_vector, target_unit_data_extension, wave_data)
	local velocity = to_vector * wave_data.horizontal_magnitude

	velocity.z = wave_data.vertical_magnitude

	local catapulted_state_input = target_unit_data_extension:write_component("catapulted_state_input")

	Catapulted.apply(catapulted_state_input, velocity)

	local camera_extension = ScriptUnit.has_extension(unit, "camera_system")

	camera_extension:trigger_camera_shake("renegade_wizard_shockwave", false)
end

function _update_shockwave(t, scratchpad)
	local hazard_data = scratchpad.shockwave_hazard
	local wave_data = hazard_data.wave_data
	local player_datas = hazard_data.player_datas
	local boss_unit = scratchpad.boss_unit
	local enemy_units = hazard_data.enemy_units

	if wave_data.wave_id == 0 then
		return
	end

	local wave_started = t > wave_data.start_t
	local wave_ended = t > wave_data.end_t

	if wave_ended then
		if not wave_data.resolved then
			_update_shockwave_gameobject(boss_unit, false)

			wave_data.resolved = true

			if not wave_data.teeth_randomized then
				wave_data.teeth_randomized = true

				WizardTeethStageHazard.randomize_teeth(scratchpad)
			end

			WizardShockwaveStageHazard.respawn_plane(scratchpad)
		end

		return
	end

	if not wave_started then
		return
	end

	local alpha = math.ilerp(wave_data.start_t, wave_data.end_t, t)
	local shockwave_center_distance = math.lerp(0, ARENA_RADIUS, alpha)
	local boss_position = POSITION_LOOKUP[boss_unit]
	local plane_unit = scratchpad.shockwave_plane_unit
	local wedge_origin = ALIVE[plane_unit] and Unit.world_position(plane_unit, 1) or POSITION_LOOKUP[boss_unit]
	local wedge_origin_flat = Vector3.flat(wedge_origin)
	local teeth_hazard = scratchpad.teeth_hazard
	local teeth_positions = teeth_hazard and teeth_hazard.teeth_positions
	local is_raised = teeth_hazard and teeth_hazard.is_raised
	local furthest_player_distance = 0
	local has_players = false

	for player_unit, data in pairs(player_datas) do
		_update_player_hit_by_attack(t, player_unit, data, wave_data, shockwave_center_distance, wedge_origin_flat, teeth_positions, is_raised)
		_update_collision(t, data, player_unit, data.position, wave_data.wall_slam_damage_modifier)

		has_players = true

		if furthest_player_distance < data.center_distance then
			furthest_player_distance = data.center_distance
		end
	end

	_update_minion_stagger(enemy_units, boss_unit, boss_position, shockwave_center_distance, wedge_origin_flat, teeth_positions, is_raised)
end

function _update_collision(t, player_data, player_unit, unit_pos, wall_slam_damage_modifier)
	if player_data.wall_slammed then
		return
	end

	local mover = Unit.mover(player_unit)
	local side_collides = Mover.collides_sides(mover)
	local collides_down = Mover.collides_down(mover)
	local colliding = side_collides and not collides_down

	if colliding then
		local camera_extension = ScriptUnit.has_extension(player_unit, "camera_system")

		camera_extension:trigger_camera_shake("renegade_wizard_shockwave", false)

		local locomotion_extension = ScriptUnit.has_extension(player_unit, "locomotion_system")
		local player_velocity = locomotion_extension:current_velocity()
		local player_velocity_normalized = Vector3.normalize(player_velocity)

		_deal_slam_damage(player_unit, player_velocity_normalized, wall_slam_damage_modifier)

		player_data.wall_slammed = true
	end
end

function _deal_push_damage(player_unit, velocity, center_distance, wall_slam_damage_modifier)
	local toughness_extension = ScriptUnit.has_extension(player_unit, "toughness_system")
	local has_toughness = toughness_extension and toughness_extension:current_toughness_percent() > 0

	if not toughness_extension or not has_toughness then
		return
	elseif center_distance < PUSH_TOUGHNESS_BREAK_DISTANCE_THRESHOLD then
		toughness_extension:break_toughness()

		return
	end

	local max_tougness_damage = Managers.state.difficulty:get_table_entry_by_challenge(PUSH_TOUGHNESS_DAMAGE_BY_DIFFICULTY)
	local center_distance_damage_modifier = 1 - math.ilerp(0, ARENA_RADIUS, center_distance)
	local scaled_toughness_damage = max_tougness_damage * center_distance_damage_modifier

	toughness_extension:add_damage(scaled_toughness_damage)

	local has_buff_ext = ScriptUnit.has_extension(player_unit, "buff_system")

	if has_buff_ext then
		local t = Managers.time:time("gameplay")

		has_buff_ext:add_internally_controlled_buff("spillway_wizard_toughness_reduction_stacking", t)
	end
end

function _deal_slam_damage(player_unit, velocity, wall_slam_damage_modifier)
	local damage_profile = DamageProfileTemplates.spillway_wizard_shockwave_wall_slam
	local damage_type = damage_types.kinetic
	local max_power_level = WALL_SLAM_MAX_POWER_LEVEL
	local scaled_power_level = max_power_level * wall_slam_damage_modifier

	Attack.execute(player_unit, damage_profile, "attack_direction", -velocity, "power_level", scaled_power_level, "hit_zone_name", "torso", "damage_type", damage_type)
end

local sfx_name = "wwise/events/minions/play_enemy_psyker_shockwave_push"
local shockwave_effect_template = EffectTemplates.renegade_wizard_shockwave
local TRAVEL_TIME_FIELD = "shockwave_travel_time"

function _start_effect_template(scratchpad, hazard_data, travel_time)
	local unit = scratchpad.boss_unit
	local unit_position = POSITION_LOOKUP[unit]
	local fx_system = Managers.state.extension:system("fx_system")
	local game_session = Managers.state.game_session:game_session()
	local game_object_id = Managers.state.unit_spawner:game_object_id(unit)

	if game_object_id and GameSession.game_object_exists(game_session, game_object_id) then
		GameSession.set_game_object_field(game_session, game_object_id, TRAVEL_TIME_FIELD, travel_time)
		_update_shockwave_gameobject(unit, true)
	end

	_stop_effect_template(hazard_data)

	hazard_data.effect_template_id = fx_system:start_template_effect(shockwave_effect_template, unit)

	fx_system:trigger_wwise_event(sfx_name, unit_position)
end

function _stop_effect_template(hazard_data)
	local fx_system = Managers.state.extension:system("fx_system")

	if hazard_data.effect_template_id then
		fx_system:stop_template_effect(hazard_data.effect_template_id)
	end
end

local START_SHOCKWAVE = "shockwave_started"

function _update_shockwave_gameobject(unit, is_started)
	local game_session = Managers.state.game_session:game_session()
	local game_object_id = unit and Managers.state.unit_spawner:game_object_id(unit)

	if not game_object_id or not GameSession.game_object_exists(game_session, game_object_id) then
		return
	end

	GameSession.set_game_object_field(game_session, game_object_id, START_SHOCKWAVE, is_started)
end

function _create_shockwave_plane_unit(scratchpad)
	local position = scratchpad.positions.center:unbox() + Vector3(0, 0, 0.5)
	local prop_settings = LevelProps.shockwave_plane
	local name = prop_settings.unit_name
	local unit = Managers.state.unit_spawner:spawn_network_unit(name, "level_prop", position, Quaternion.identity(), nil, prop_settings)

	scratchpad.shockwave_plane_unit = unit
end

function _destroy_shockwave_plane_unit(scratchpad)
	local unit = scratchpad.shockwave_plane_unit

	if unit and ALIVE[unit] then
		Managers.state.unit_spawner:mark_for_deletion(unit)
	end
end

return WizardShockwaveStageHazard
