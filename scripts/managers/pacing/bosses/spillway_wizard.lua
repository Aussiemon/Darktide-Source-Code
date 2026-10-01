-- chunkname: @scripts/managers/pacing/bosses/spillway_wizard.lua

local Attack = require("scripts/utilities/attack/attack")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BossPhaseUtilities = require("scripts/utilities/phases/boss_phase_utilities")
local Component = require("scripts/utilities/component")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local Vo = require("scripts/utilities/vo")
local LevelProps = require("scripts/settings/level_prop/level_props")
local boss_template = {
	name = "psyker_boss",
}
local phase_condition_check_args = {}
local SHOCKWAVE_STATES = table.enum("force_push", "exhausted")
local DANCE_STATES = table.enum("dance", "exhausted")
local DanceStageHazard = require("scripts/utilities/stage_hazards/wizard_dance_stage_hazard")
local ShockwaveStageHazard = require("scripts/utilities/stage_hazards/wizard_shockwave_stage_hazard")
local TeethStageHazard = require("scripts/utilities/stage_hazards/wizard_teeth_stage_hazard")
local _clear_room, _kill_all_enemies, _on_intro_cinematic_started, _on_end_cinematic_started, _try_initial_teleport, _stop_tier_trickles, _try_start_phase_trickle, _try_start_retreat_burst, _start_named_event, _try_start_hard_mode, _update_queued_teleports, _set_toughness_shield_state, _start_music_objective, _set_music_progression, _end_music_objective, _index_against_challenge, _is_havoc, _try_spawn_havoc_twin
local WIPE_PHASE_INDEX = 99
local MUSIC_OBJECTIVE_NAME = "objective_spillway_endevent_boss_music"
local MUSIC_PROGRESSION_ONE = 0
local MUSIC_PROGRESSION_TWO = 0.5
local SETTINGS = {
	breed_name = "renegade_wizard",
	spawn_position = "narrative_01",
	ability_position_lookup = {
		dance = "center",
		default = "any",
	},
	fight_terror_events = {
		boss_dead = "spillway_wizard_boss_dead",
		end_level = "spillway_wizard_boss_end_level",
		fight_start = "spillway_wizard_fight_start",
		hard_mode = "spillway_wizard_hard_mode_trickle",
		trickle_stoppers = {
			tier_1 = "spillway_wizard_stop_trickle_tier_1",
			tier_2 = "spillway_wizard_stop_trickle_tier_2",
			tier_3 = "spillway_wizard_stop_trickle_tier_3",
			tier_final = "spillway_wizard_stop_trickle_final",
		},
		fight_trickles = {
			tier_1 = {
				"spillway_wizard_elite_trickle_1",
				"spillway_wizard_elite_trickle_2",
				"spillway_wizard_elite_trickle_3",
			},
			tier_2 = {
				"spillway_wizard_elite_trickle_phase_2_1",
				"spillway_wizard_elite_trickle_phase_2_2",
				"spillway_wizard_elite_trickle_phase_2_3",
			},
			tier_3 = {
				"spillway_wizard_elite_trickle_phase_3_1",
				"spillway_wizard_elite_trickle_phase_3_2",
				"spillway_wizard_elite_trickle_phase_3_3",
			},
			tier_final = {
				"spillway_wizard_elite_trickle_final",
			},
		},
		wave_events = {
			tier_1 = {
				"spillway_wizard_wave_phase_1_west",
				"spillway_wizard_wave_phase_1_east",
				"spillway_wizard_wave_phase_1_south",
			},
			tier_2 = {
				"spillway_wizard_wave_phase_2_west",
				"spillway_wizard_wave_phase_2_east",
				"spillway_wizard_wave_phase_2_south",
			},
			tier_3 = {
				"spillway_wizard_wave_phase_3_west",
				"spillway_wizard_wave_phase_3_east",
				"spillway_wizard_wave_phase_3_south",
			},
		},
	},
}

local function _get_component_by_name(unit, component_name)
	if not ALIVE[unit] then
		return nil
	end

	local components = Component.get_components_by_name(unit, component_name)

	return components and components[1]
end

local HAVOC_TWIN_CHANCE = 1
local HAVOC_TWIN_BREED_NAME = "renegade_twin_captain_two"
local HAVOC_TWIN_SPAWNER_GROUP = "spawner_spillway_boss_event_all"
local HAVOC_DANCE_SPECIALS_BONUS_MULTIPLIER = 0.35

boss_template.setup = function (self)
	if Managers.event then
		Managers.event:register(self, "intro_cinematic_started", "on_cinematic_started")
	end
end

boss_template.teardown = function (self)
	if Managers.event then
		Managers.event:unregister(self, "intro_cinematic_started")
	end
end

boss_template._update_phase_data = function (self, scratchpad, t)
	if not scratchpad.current_phase_action_data then
		scratchpad.current_phase_action_data = {}
		scratchpad.phase_start_t = t
	end

	local current_phase = scratchpad.phase
	local previous_phase = scratchpad.previous_phase

	if previous_phase and previous_phase < current_phase then
		scratchpad.current_phase_action_data = {}
		scratchpad.phase_start_t = t
	end

	previous_phase = current_phase
	scratchpad.previous_phase = previous_phase
end

local teleport_types = table.enum("cover", "flood", "predefined")
local required_positions = {
	"center",
	"narrative_01",
	"narrative_02",
}
local PHASE_ORDER = {
	{
		"introduction",
	},
	{
		"dance_01",
		1,
	},
	{
		"exhausted_01",
		0.57,
	},
	{
		"intermission_01",
		0.56,
	},
	{
		"spawn_teeth",
		0.55,
	},
	{
		"force_push",
		0.55,
	},
	{
		"exhausted_02",
		0.34,
	},
	{
		"intermission_02",
		0.32,
	},
	{
		"dance_02",
		0.33,
	},
	{
		"defeat",
		0,
	},
}
local PHASE_LOOKUP = {}
local VO_ORDER = {
	{
		"mission_spillway_boss_fight_04_a",
		0.44,
	},
	{
		"mission_spillway_boss_fight_05_a",
		0.24,
	},
	{
		"mission_spillway_boss_fight_06_a",
		0.13,
	},
}

boss_template.init = function (self, scratchpad, boss_handler)
	local positions = scratchpad.positions

	for i = 1, #required_positions do
		local required_position_name = required_positions[i]
	end

	local minion_spawn_manager = Managers.state.minion_spawn
	local param_table = minion_spawn_manager:request_param_table()
	local spawned_unit = minion_spawn_manager:spawn_minion(SETTINGS.breed_name, positions[SETTINGS.spawn_position]:unbox(), Quaternion.identity(), 2, param_table)

	scratchpad.boss_unit = spawned_unit
	scratchpad.phase = 1

	local locomotion_extension = ScriptUnit.extension(spawned_unit, "locomotion_system")

	locomotion_extension:set_movement_type("script_driven")

	local blackboard = BLACKBOARDS[spawned_unit]

	scratchpad.blackboard = BLACKBOARDS[scratchpad.boss_unit]

	local spawn_component = blackboard.spawn
	local world = spawn_component.world

	scratchpad.world = world

	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[spawned_unit]

	scratchpad.side = side

	table.clear(PHASE_LOOKUP)

	for i = 1, #PHASE_ORDER do
		local current_order_identifier = PHASE_ORDER[i][1]

		PHASE_LOOKUP[current_order_identifier] = i
		PHASE_LOOKUP[i] = current_order_identifier

		local next_phase = PHASE_ORDER[i + 1]
		local next_phase_health_threshold = i == 1 and 1 or next_phase and next_phase[2] or 0
		local current_phase_settings = boss_template.phases[current_order_identifier].phase_settings

		current_phase_settings.next_phase_health_percentage = next_phase_health_threshold
	end

	scratchpad.phase_lookup = PHASE_LOOKUP
	scratchpad.phase_order = PHASE_ORDER
	scratchpad.vo_order = table.clone(VO_ORDER)
	scratchpad.vf_effect_ids = {}

	local wipe_index = WIPE_PHASE_INDEX

	PHASE_LOOKUP.all_players_dead = wipe_index
	PHASE_LOOKUP[wipe_index] = "all_players_dead"

	local boss_extension = ScriptUnit.extension(spawned_unit, "boss_system")
	local game_session, game_object_id = spawn_component.game_session, spawn_component.game_object_id

	GameSession.set_game_object_field(game_session, game_object_id, "center_position", positions.center:unbox())

	return boss_extension
end

boss_template.cleanup = function (self, scratchpad)
	return
end

local function _check_conditions(scratchpad, phase_data, current_phase_settings, t, check_health, check_time, is_forced)
	table.clear(phase_condition_check_args)

	phase_condition_check_args.health = check_health or false
	phase_condition_check_args.time = check_time or false

	return BossPhaseUtilities.check_for_next_phase_conditions_met(scratchpad, phase_data, current_phase_settings, t, phase_condition_check_args, nil, is_forced)
end

boss_template.update = function (self, scratchpad, unit, dt, t)
	if scratchpad.teeth_hazard then
		TeethStageHazard.update(scratchpad, t)
	end

	local current_phase_index = scratchpad.phase
	local boss_unit = scratchpad.boss_unit
	local phase_lookup = scratchpad.phase_lookup
	local phase_indentifier = phase_lookup[current_phase_index]
	local current_phase = boss_template.phases[phase_indentifier]

	scratchpad.current_phase = current_phase

	if not scratchpad.init_blackboard_write_access then
		local teleport_component = Blackboard.write_component(scratchpad.blackboard, "teleport")

		scratchpad.teleport_component = teleport_component

		local abilities_component = Blackboard.write_component(scratchpad.blackboard, "abilites")

		scratchpad.abilities_component = abilities_component
	end

	boss_template:_update_phase_data(scratchpad, t)

	local health_extension = ScriptUnit.has_extension(boss_unit, "health_system")

	if not health_extension then
		return
	end

	local current_health_percent = health_extension:current_health_percent()
	local next_vo = scratchpad.vo_order[1]
	local next_threshold = next_vo and next_vo[2]

	if next_threshold and current_health_percent <= next_threshold then
		local trigger_id = next_vo[1]

		Vo.mission_giver_mission_info_vo("rule_based", nil, trigger_id)
		table.remove(scratchpad.vo_order, 1)
	end

	if current_phase then
		local phase_data = scratchpad.current_phase_action_data

		if not phase_data then
			return
		end

		local current_phase_settings = current_phase.phase_settings
		local health_condition = current_phase_settings.use_health or false
		local time_condition = current_phase_settings.use_time or false

		BossPhaseUtilities.update_overdamage_protection(scratchpad, current_phase_settings)

		local wanted_trickle = current_phase_settings.wanted_trickle

		if wanted_trickle then
			_try_start_phase_trickle(scratchpad, phase_data, wanted_trickle)
		end

		if current_phase.init and not phase_data.initialized then
			current_phase.init(scratchpad, current_phase_settings, phase_data, t)

			phase_data.initialized = true
		end

		current_phase.update(scratchpad, current_phase_settings, phase_data, t)
		_update_queued_teleports(scratchpad, phase_data, current_phase_settings, t)

		local is_forced

		if phase_data and phase_data.is_forced then
			is_forced = true
		end

		local teleport_component = scratchpad.teleport_component

		if teleport_component and not teleport_component.teleport_allowed then
			local is_done = _check_conditions(scratchpad, phase_data, current_phase_settings, t, health_condition, time_condition, is_forced)

			if is_done and current_phase.exit and not phase_data.exit_init then
				phase_data.exit_init = true

				current_phase.exit(scratchpad, current_phase_settings, t)
			end
		end
	end
end

boss_template._current_phase_settings = function (self, scratchpad)
	local current_phase = scratchpad.phase
	local phase_lookup = scratchpad.phase_lookup
	local phase_indentifier = phase_lookup[current_phase]
	local current_phase_settings = boss_template.phases[phase_indentifier].phase_settings

	return current_phase_settings
end

boss_template.on_phase_event_triggered = function (self, scratchpad, event_name, optional_args_table)
	local current_phase = scratchpad.phase
	local phase_lookup = scratchpad.phase_lookup
	local phase_indentifier = phase_lookup[current_phase]
	local on_phase_event_triggered_func = boss_template.phases[phase_indentifier].on_phase_event_triggered

	if on_phase_event_triggered_func then
		on_phase_event_triggered_func(scratchpad, event_name, optional_args_table)
	end
end

function _try_initial_teleport(scratchpad, phase_data, position_name, teleport_type, invulnerable, should_fly, allow_short_teleport)
	if phase_data.teleport_done then
		return false
	end

	local should_teleport = true

	if position_name ~= "random" and not allow_short_teleport then
		local current_pos = POSITION_LOOKUP[scratchpad.boss_unit]
		local target_pos = scratchpad.positions[position_name] and scratchpad.positions[position_name]:unbox()

		if current_pos and target_pos and Vector3.distance_squared(current_pos, target_pos) < 1 then
			should_teleport = false
		end
	end

	if should_teleport then
		if scratchpad._queued_teleports then
			table.clear(scratchpad._queued_teleports)
		end

		BossPhaseUtilities.teleport(scratchpad, position_name, teleport_type, should_fly, true)
	end

	if invulnerable ~= nil then
		BossPhaseUtilities.set_boss_invulnerability(scratchpad.boss_unit, invulnerable)
	end

	phase_data.teleport_done = true

	return true
end

function _update_queued_teleports(scratchpad, phase_data, current_phase_settings, t)
	if not scratchpad._queued_teleports then
		scratchpad._queued_teleports = {}
	end

	for i = 1, #scratchpad._queued_teleports do
		local queue_object = scratchpad._queued_teleports[i]
		local position_or_nil = queue_object.position_or_nil
		local teleport_state = queue_object.teleport_state
		local should_fly = queue_object.should_fly
		local teleport_sucess = BossPhaseUtilities.teleport(scratchpad, position_or_nil, teleport_state, should_fly, nil, true)

		if teleport_sucess then
			table.swap_delete(scratchpad._queued_teleports, i)
		end
	end
end

function _stop_tier_trickles(scratchpad, tier_key)
	tier_key = tier_key or scratchpad.active_trickle_tier

	local stopper = tier_key and SETTINGS.fight_terror_events.trickle_stoppers[tier_key]

	if stopper then
		BossPhaseUtilities.start_terror_event(stopper)
	end

	scratchpad.active_trickle_tier = nil
end

function _try_start_phase_trickle(scratchpad, phase_data, tier_key)
	if phase_data.terror_event_started then
		return
	end

	phase_data.terror_event_started = true

	if scratchpad.active_trickle_tier == tier_key then
		return
	end

	if scratchpad.active_trickle_tier then
		_stop_tier_trickles(scratchpad)
	end

	local pool = SETTINGS.fight_terror_events.fight_trickles[tier_key]

	if pool then
		local chosen_event = pool[math.random(1, #pool)]

		BossPhaseUtilities.start_terror_event(chosen_event)

		scratchpad.active_trickle_tier = tier_key
	end
end

function _start_named_event(scratchpad, phase_data, settings_key, flag_name)
	flag_name = flag_name or "terror_event_started"

	if phase_data[flag_name] then
		return
	end

	local event_name = SETTINGS.fight_terror_events[settings_key]

	if event_name then
		BossPhaseUtilities.start_terror_event(event_name)
	end

	phase_data[flag_name] = true
end

local RETREAT_BURST_COOLDOWN = 25
local BURST_EVENT_SEPARATOR = "|"

function _try_start_retreat_burst(scratchpad, t, events, override_cooldown)
	if scratchpad.retreat_burst_cooldown_t and t < scratchpad.retreat_burst_cooldown_t then
		return
	end

	if not events then
		return
	end

	local current_challenge = Managers.state.difficulty:get_challenge()
	local best_event, best_required

	for i = 1, #events, 2 do
		local event_name = events[i]
		local required_challenge = events[i + 1]
		local is_available = required_challenge <= current_challenge
		local is_better = not best_required or best_required < required_challenge

		if is_available and is_better then
			best_event = event_name
			best_required = required_challenge
		end
	end

	if not best_event then
		return
	end

	local split_events = string.split(best_event, BURST_EVENT_SEPARATOR)
	local chosen_event = split_events[math.random(1, #split_events)]

	scratchpad.retreat_burst_cooldown_t = t + RETREAT_BURST_COOLDOWN

	Managers.state.terror_event:start_random_event(chosen_event)
end

function _try_start_hard_mode(scratchpad, phase_data)
	if phase_data.hard_mode_checked then
		return
	end

	phase_data.hard_mode_checked = true

	if scratchpad.has_hard_mode then
		BossPhaseUtilities.start_terror_event(SETTINGS.fight_terror_events.hard_mode)
	end
end

function _start_music_objective()
	local mission_objective_system = Managers.state.extension:system("mission_objective_system")

	mission_objective_system:start_mission_objective(MUSIC_OBJECTIVE_NAME)
end

function _set_music_progression(progression)
	local mission_objective_system = Managers.state.extension:system("mission_objective_system")
	local group_id = mission_objective_system:get_override_group_id_from_objective(MUSIC_OBJECTIVE_NAME)
	local objective = mission_objective_system:active_objective(MUSIC_OBJECTIVE_NAME, group_id)

	if not objective then
		return
	end

	objective:set_progression(progression)
	mission_objective_system:external_update_mission_objective(MUSIC_OBJECTIVE_NAME, group_id, 0, 0)
end

function _end_music_objective()
	local mission_objective_system = Managers.state.extension:system("mission_objective_system")
	local group_id = mission_objective_system:get_override_group_id_from_objective(MUSIC_OBJECTIVE_NAME)

	if not mission_objective_system:is_current_active_objective(MUSIC_OBJECTIVE_NAME, group_id) then
		return
	end

	mission_objective_system:end_mission_objective(MUSIC_OBJECTIVE_NAME, group_id)
end

local PACING_TYPES = {
	"hordes",
	"roamers",
	"monsters",
	"trickle_hordes",
}

function _clear_room()
	local pacing_manager = Managers.state.pacing

	for i = 1, #PACING_TYPES do
		local pacing_type = PACING_TYPES[i]

		pacing_manager:pause_spawn_type(pacing_type, true, "spillway_wizard")
	end

	local minion_spawn_manager = Managers.state.minion_spawn

	minion_spawn_manager:despawn_all_minions()
end

function _kill_all_enemies(boss_unit)
	local boss_dead_event = SETTINGS.fight_terror_events.boss_dead

	BossPhaseUtilities.start_terror_event(boss_dead_event)

	local pacing_manager = Managers.state.pacing

	pacing_manager:pause_spawn_type("specials", true, "spillway_wizard")

	local side_system = Managers.state.extension:system("side_system")
	local boss_side = side_system.side_by_unit[boss_unit]
	local fx_system = Managers.state.extension:system("fx_system")
	local warp_gib_vfx = "content/fx/particles/enemies/renegade_wizard/wizard_head_explosion"
	local hostile_minions = boss_side and boss_side:alive_units_by_tag("allied", "minion")

	for i = hostile_minions and hostile_minions.size or 0, 1, -1 do
		local enemy_unit = hostile_minions[i]

		if ALIVE[enemy_unit] and enemy_unit ~= boss_unit then
			local blackboard = BLACKBOARDS[enemy_unit]
			local has_gib_override = blackboard and Blackboard.has_component(blackboard, "gib_override")

			if has_gib_override then
				local gib_override = Blackboard.write_component(blackboard, "gib_override")

				gib_override.should_override = true
				gib_override.target_template = "havoc_self_gib"
				gib_override.override_hit_zone_name = "head"
			end

			local hit_position = Unit.world_position(enemy_unit, 1)

			Attack.execute(enemy_unit, DamageProfileTemplates.default, "power_level", 2000, "attack_direction", Vector3.up(), "hit_world_position", hit_position, "instakill", true)

			local node = Unit.has_node(enemy_unit, "j_neck") and Unit.node(enemy_unit, "j_neck") or 1
			local world_pose = Unit.world_pose(enemy_unit, node)
			local position = Matrix4x4.translation(world_pose)
			local rotation = Matrix4x4.rotation(world_pose)

			fx_system:trigger_vfx(warp_gib_vfx, position, rotation)
		end
	end
end

boss_template.on_cinematic_started = function (self, cinematic_name)
	if cinematic_name == "spillway_wizard_intro" then
		_on_intro_cinematic_started()
	elseif cinematic_name == "outro_win" then
		_on_end_cinematic_started()
	end
end

function _on_intro_cinematic_started()
	_clear_room()
	_start_music_objective()
	_set_music_progression(MUSIC_PROGRESSION_ONE)
end

function _on_end_cinematic_started()
	BossPhaseUtilities.start_terror_event(SETTINGS.fight_terror_events.boss_dead)
end

function _set_toughness_shield_state(scratchpad, state)
	local phase_data = scratchpad.current_phase_action_data

	if phase_data and phase_data.shield_state == state then
		return
	end

	if phase_data then
		phase_data.shield_state = state
	end

	local unit = scratchpad.boss_unit
	local toughness_extension = ScriptUnit.extension(unit, "toughness_system")
	local blackboard = scratchpad.blackboard
	local spawn_component = blackboard.spawn
	local game_session, game_object_id = spawn_component.game_session, spawn_component.game_object_id

	if state then
		toughness_extension:activate_shield()
		toughness_extension:set_invulnerable(true)
		GameSession.set_game_object_field(game_session, game_object_id, "is_toughness_invulnerable", true)
	else
		toughness_extension:destroy_shield()
		toughness_extension:set_invulnerable(false)
		GameSession.set_game_object_field(game_session, game_object_id, "is_toughness_invulnerable", false)
	end
end

function _index_against_challenge(t)
	local v = Managers.state.difficulty:get_table_entry_by_challenge(t)

	return v
end

function _is_havoc()
	local havoc_extension = Managers.state.game_mode:game_mode():extension("havoc")

	if havoc_extension then
		return havoc_extension:get_current_rank()
	else
		return false
	end
end

function _try_spawn_havoc_twin()
	local minion_spawn_system = Managers.state.extension:system("minion_spawner_system")
	local spawners = minion_spawn_system:spawners_in_group(HAVOC_TWIN_SPAWNER_GROUP)

	if not spawners or #spawners == 0 then
		return
	end

	local spawner = spawners[math.random(1, #spawners)]
	local minion_spawn_manager = Managers.state.minion_spawn
	local param_table = minion_spawn_manager:request_param_table()

	minion_spawn_manager:spawn_minion(HAVOC_TWIN_BREED_NAME, spawner:position(), spawner:rotation(), 2, param_table)
end

boss_template.phases = {
	introduction = {
		phase_settings = {
			intro_length_t = 0.1,
			use_health = false,
			use_time = true,
			wait_t = 10,
			wait_timings_until_force_phase_change = 45,
		},
		init = function (scratchpad, current_phase_settings, phase_data, t)
			_start_music_objective()
			_set_music_progression(MUSIC_PROGRESSION_ONE)

			local prop_settings = LevelProps.spillway_boss_wall
			local spawn_position = Vector3(-362, 90, -8)
			local center_position = scratchpad.positions.center:unbox()
			local to_center = center_position - spawn_position
			local look_direction = Vector3.normalize(Vector3(Vector3.x(to_center), Vector3.y(to_center), 0))
			local rotation = Quaternion.look(look_direction, Vector3.up())

			Managers.state.unit_spawner:spawn_network_unit(prop_settings.unit_name, "level_prop", spawn_position, rotation, nil, prop_settings)
		end,
		update = function (scratchpad, current_phase_settings, phase_data, t)
			if not phase_data.default_look_at_position_setup then
				local abilities_component = scratchpad.abilities_component
				local positions = scratchpad.positions

				abilities_component.default_look_at_position:store(positions.center:unbox())
			end

			_set_toughness_shield_state(scratchpad, true)

			if not phase_data.intro_length_t then
				phase_data.intro_length_t = current_phase_settings.intro_length_t + t
			elseif phase_data.intro_length_t and t > phase_data.intro_length_t and not phase_data.terror_event_started then
				_start_named_event(scratchpad, phase_data, "fight_start")
				_try_start_hard_mode(scratchpad, phase_data)
				BossPhaseUtilities.set_boss_invulnerability(scratchpad.boss_unit, false)

				local unit = scratchpad.boss_unit
				local blackboard = scratchpad.blackboard
				local spawn_component = blackboard.spawn
				local boss_extension = ScriptUnit.extension(unit, "boss_system")
				local _, game_object_id = spawn_component.game_session, spawn_component.game_object_id

				boss_extension:start_boss_encounter()
				Managers.state.game_session:send_rpc_clients("rpc_start_boss_encounter", game_object_id)
			end

			if not phase_data.wait_t then
				phase_data.wait_t = t + current_phase_settings.intro_length_t
			end

			if t > phase_data.wait_t then
				phase_data.wait_t = t + current_phase_settings.wait_t

				BossPhaseUtilities.teleport(scratchpad, "random", teleport_types.predefined, true)
			end
		end,
		exit = function (scratchpad, current_phase_settings, t)
			BossPhaseUtilities.start_terror_event("spillway_wizard_stop_introduction_trickle")
		end,
	},
	dance_01 = {
		phase_settings = {
			dance_min_time = 3,
			delayed_escape_timer = 10,
			exhaust_duration = 10,
			inital_state = "dance",
			minimum_time_required_in_phase = 35,
			use_health = true,
			wait_t = 5,
			wanted_trickle = "tier_1",
			t_for_each_loop = {
				35,
				25,
			},
			dance_escape_step = {
				{
					0.1,
					0.1,
				},
				{
					0.1,
					0.1,
				},
				{
					0.1,
					0.07,
				},
				{
					0.1,
					0.05,
				},
				{
					0.1,
					0.05,
				},
			},
			burst_events = {
				"spillway_wizard_retreat_burst",
				1,
				"spillway_wizard_retreat_burst_elite|spillway_wizard_retreat_burst_elite_ogryn_melee",
				5,
			},
			special_breed_override = {
				cultist_flamer = "chaos_hound",
				cultist_grenadier = "chaos_poxwalker_bomber",
				cultist_mutant = "renegade_netgunner",
				renegade_flamer = "renegade_sniper",
				renegade_grenadier = "chaos_hound",
			},
		},
		init = function (scratchpad, current_phase_settings, phase_data, t)
			phase_data.state = current_phase_settings.inital_state
			phase_data.indexed_escape_times = _index_against_challenge(current_phase_settings.dance_escape_step)
			phase_data.t_til_switch = t + current_phase_settings.t_for_each_loop[1]

			local minion_spawn_manager = Managers.state.minion_spawn

			minion_spawn_manager:inject_replacement_breeds(current_phase_settings.special_breed_override)

			if _is_havoc() then
				Managers.state.pacing:set_specials_max_alive_bonus_multiplier(HAVOC_DANCE_SPECIALS_BONUS_MULTIPLIER)
			end
		end,
		update = function (scratchpad, current_phase_settings, phase_data, t)
			local indexed_escape_times = phase_data.indexed_escape_times

			if phase_data.state == DANCE_STATES.dance then
				local abilities_component = scratchpad.abilities_component

				if not phase_data.dive_bomb_completed then
					phase_data.dive_bomb_completed = true

					local spawn_comp = BLACKBOARDS[scratchpad.boss_unit].spawn

					GameSession.set_game_object_field(spawn_comp.game_session, spawn_comp.game_object_id, "want_to_dive_bomb", true)
				end

				if _try_initial_teleport(scratchpad, phase_data, "center", teleport_types.predefined, false, false) then
					return
				end

				local teleport_component = scratchpad.teleport_component
				local teleport_in_flight = teleport_component and teleport_component.teleport_allowed
				local has_queued_teleport = scratchpad._queued_teleports and #scratchpad._queued_teleports > 0
				local teleport_busy = teleport_in_flight or has_queued_teleport

				if teleport_busy and not phase_data.dance_started then
					return
				end

				_set_toughness_shield_state(scratchpad, false)

				if not phase_data.dance_started then
					abilities_component.current_ability = "dance"
					phase_data.dance_started = true
					phase_data.dance_start_health, phase_data.dance_min_t = BossPhaseUtilities.begin_health_escape(scratchpad, t, current_phase_settings.dance_min_time)

					DanceStageHazard.init(scratchpad)
				end

				DanceStageHazard.update(scratchpad, t)

				local timer_expired = t > phase_data.t_til_switch
				local is_mid_attack = DanceStageHazard.is_mid_attack(scratchpad, t)
				local health_triggered = BossPhaseUtilities.health_escape_triggered(scratchpad, phase_data.dance_start_health, phase_data.dance_min_t, indexed_escape_times[1], t)

				if (timer_expired or health_triggered) and not is_mid_attack then
					DanceStageHazard.exit(scratchpad)

					phase_data.teleport_done = nil
					phase_data.dance_started = nil
					phase_data.dive_bomb_completed = nil
					phase_data.state = DANCE_STATES.exhausted
					abilities_component.exhaust_duration = current_phase_settings.exhaust_duration
					abilities_component.current_ability = "exhausted"
					phase_data.t_til_switch = t + current_phase_settings.t_for_each_loop[2]
					phase_data.delayed_escape_teleport = t + current_phase_settings.delayed_escape_timer
					phase_data.dance_start_health, phase_data.dance_min_t = BossPhaseUtilities.begin_health_escape(scratchpad, t, current_phase_settings.dance_min_time)
				end
			elseif phase_data.state == DANCE_STATES.exhausted then
				local health_triggered = BossPhaseUtilities.health_escape_triggered(scratchpad, phase_data.dance_start_health, phase_data.dance_min_t, indexed_escape_times[2], t)
				local timer_expired = t > phase_data.delayed_escape_teleport

				if timer_expired or health_triggered then
					_try_initial_teleport(scratchpad, phase_data, "narrative_01", teleport_types.predefined, false, false)
					_set_toughness_shield_state(scratchpad, true)
				end

				if t > phase_data.t_til_switch then
					phase_data.teleport_done = nil
					phase_data.state = DANCE_STATES.dance
					phase_data.t_til_switch = t + current_phase_settings.t_for_each_loop[1]
				end

				_try_start_retreat_burst(scratchpad, t, current_phase_settings.burst_events)
			end
		end,
		exit = function (scratchpad, current_phase_settings, t)
			DanceStageHazard.exit(scratchpad)

			local minion_spawn_manager = Managers.state.minion_spawn

			minion_spawn_manager:remove_injected_breeds(current_phase_settings.special_breed_override)

			if _is_havoc() then
				Managers.state.pacing:set_specials_max_alive_bonus_multiplier(1)
			end
		end,
		on_phase_event_triggered = function (scratchpad, event_name)
			DanceStageHazard.on_phase_event_triggered(scratchpad, event_name)
		end,
	},
	exhausted_01 = {
		phase_settings = {
			minimum_time_required_in_phase = 5,
			use_health = false,
			use_time = true,
			wait_timings_until_force_phase_change = 7,
		},
		update = function (scratchpad, current_phase_settings, phase_data, t)
			if _try_initial_teleport(scratchpad, phase_data, "narrative_01", teleport_types.predefined, false) then
				return
			end

			_set_toughness_shield_state(scratchpad, true)

			local abilities_component = scratchpad.abilities_component

			if abilities_component.current_ability ~= "exhausted" then
				abilities_component.exhaust_duration = current_phase_settings.wait_timings_until_force_phase_change + 1
				abilities_component.current_ability = "exhausted"
			end
		end,
	},
	spawn_teeth = {
		phase_settings = {
			wait_timings_until_force_phase_change = 90,
			wanted_trickle = "tier_2",
		},
		update = function (scratchpad, current_phase_settings, phase_data, t)
			if _try_initial_teleport(scratchpad, phase_data, "narrative_01", teleport_types.predefined, false) then
				return
			end

			if not phase_data.teeth_spawning_started then
				phase_data.teeth_spawning_started = true

				local abilities_component = scratchpad.abilities_component

				abilities_component.ability_position:store(scratchpad.positions.center:unbox())

				abilities_component.current_ability = "teeth"

				TeethStageHazard.init(scratchpad)
			end

			if phase_data.all_teeth_spawned and not TeethStageHazard.has_pending_spawns(scratchpad) then
				phase_data.is_forced = true

				TeethStageHazard.exit(scratchpad)
			end
		end,
		on_phase_event_triggered = function (scratchpad, event_name, optional_args_table)
			if event_name == "spawn_tooth" then
				TeethStageHazard.spawn_tooth(scratchpad, optional_args_table.tooth_position)
			elseif event_name == "all_teeth_spawned" then
				scratchpad.current_phase_action_data.all_teeth_spawned = true
			end
		end,
	},
	force_push = {
		phase_settings = {
			exhaust_duration = 10,
			exhaust_min_time = 3,
			inital_state = "force_push",
			required_num_pushes = 6,
			use_health = true,
			wanted_trickle = "tier_2",
			exhaust_escape_step = {
				0.1,
				0.1,
				0.1,
				0.1,
				0.1,
			},
			burst_events = {
				"spillway_wizard_trickle_elite_ogryn_melee",
				5,
			},
		},
		init = function (scratchpad, current_phase_settings, phase_data, t)
			phase_data.current_state = current_phase_settings.inital_state

			scratchpad.abilities_component.ability_position:store(scratchpad.positions.center:unbox())

			local spawn_comp = BLACKBOARDS[scratchpad.boss_unit].spawn
			local abilities_component = scratchpad.abilities_component
			local old_t_remain = abilities_component.t_to_next_base_attack

			phase_data.old_t_remain = old_t_remain
			abilities_component.t_to_next_base_attack = 99
			abilities_component.current_ability = "force_push"

			_set_toughness_shield_state(scratchpad, false)
			GameSession.set_game_object_field(spawn_comp.game_session, spawn_comp.game_object_id, "want_to_dive_bomb", true)
			ShockwaveStageHazard.init(scratchpad)

			local is_havoc = _is_havoc()

			if is_havoc and is_havoc == 40 and HAVOC_TWIN_CHANCE > math.random() then
				_try_spawn_havoc_twin()
			end

			phase_data.indexed_escape_times = _index_against_challenge(current_phase_settings.exhaust_escape_step)

			_try_start_retreat_burst(scratchpad, t, current_phase_settings.burst_events, 60)
		end,
		update = function (scratchpad, current_phase_settings, phase_data, t)
			if _try_initial_teleport(scratchpad, phase_data, "center", teleport_types.predefined, false) then
				return
			end

			local abilities_component = scratchpad.abilities_component

			if phase_data.force_push_pending then
				phase_data.force_push_pending = nil
				abilities_component.current_ability = "force_push"

				TeethStageHazard.randomize_teeth(scratchpad)
				ShockwaveStageHazard.init(scratchpad)
			end

			local is_last_wave_played_out = ShockwaveStageHazard.is_cycle_done(scratchpad) and ShockwaveStageHazard.is_wave_done(scratchpad, t)
			local is_shockwave_initialized = ShockwaveStageHazard.is_initialized(scratchpad)

			if is_shockwave_initialized and not is_last_wave_played_out then
				ShockwaveStageHazard.update(scratchpad, t)
			elseif is_shockwave_initialized and is_last_wave_played_out then
				abilities_component.current_ability = ""
				phase_data.current_state = SHOCKWAVE_STATES.exhausted

				ShockwaveStageHazard.exit(scratchpad)
			end

			if phase_data.current_state == SHOCKWAVE_STATES.exhausted then
				if not phase_data.exhausted_started then
					abilities_component.exhaust_duration = current_phase_settings.exhaust_duration
					abilities_component.current_ability = "exhausted"
					phase_data.exhausted_started = true
					phase_data.exhaust_start_health, phase_data.exhaust_min_t = BossPhaseUtilities.begin_health_escape(scratchpad, t, current_phase_settings.exhaust_min_time)
				end

				local exhaust_escape_step = phase_data.indexed_escape_times
				local is_exhaust_finished = abilities_component.current_ability ~= "exhausted"
				local is_health_threshold_reached = BossPhaseUtilities.health_escape_triggered(scratchpad, phase_data.exhaust_start_health, phase_data.exhaust_min_t, exhaust_escape_step, t)

				if is_health_threshold_reached then
					abilities_component.current_ability = ""
					abilities_component.exhaust_duration = 0
				end

				if is_exhaust_finished or is_health_threshold_reached then
					phase_data.exhausted_started = nil
					phase_data.exhaust_start_health = nil
					phase_data.exhaust_min_t = nil
					phase_data.delay_shockwave_exit = nil
					phase_data.current_state = SHOCKWAVE_STATES.force_push
					phase_data.force_push_pending = true
				end
			end
		end,
		exit = function (scratchpad, current_phase_settings, t)
			ShockwaveStageHazard.exit(scratchpad)
			TeethStageHazard.despawn(scratchpad)
			_set_music_progression(MUSIC_PROGRESSION_TWO)

			local unit = scratchpad.boss_unit
			local phase_data = scratchpad.current_phase_action_data
			local abilities_component = scratchpad.abilities_component

			abilities_component.t_to_next_base_attack = phase_data.old_t_remain

			Vo.enemy_generic_vo_event(unit, "psyker_boss_spillway_taunt_03_a", "renegade_wizard")
		end,
		on_phase_event_triggered = function (scratchpad, event_name, optional_args_table)
			if event_name == "start_shockwave" then
				local wave_id = optional_args_table.wave_id

				ShockwaveStageHazard.start_shockwave(scratchpad, wave_id)
			end
		end,
	},
	dance_02 = {
		phase_settings = {
			dance_min_time = 3,
			delayed_escape_timer = 10,
			enrage_threshold = 0.125,
			exhaust_duration = 10,
			inital_state = "dance",
			use_health = true,
			wait_t = 5,
			wanted_trickle = "tier_3",
			t_for_each_loop = {
				999,
				25,
			},
			dance_escape_step = {
				{
					0.1,
					0.1,
				},
				{
					0.1,
					0.1,
				},
				{
					0.1,
					0.07,
				},
				{
					0.1,
					0.05,
				},
				{
					0.1,
					0.08,
				},
			},
			burst_events = {
				"spillway_wizard_retreat_burst",
				1,
				"spillway_wizard_retreat_burst_elite|spillway_wizard_retreat_burst_elite_ogryn_melee",
				5,
			},
			events = {
				"init_floor_zones",
				"set_new_zone",
				"spawn_dance_walls",
			},
			special_breed_override = {
				cultist_flamer = "chaos_hound",
				cultist_grenadier = "chaos_poxwalker_bomber",
				cultist_mutant = "renegade_netgunner",
				renegade_flamer = "renegade_sniper",
				renegade_grenadier = "chaos_hound",
			},
		},
		init = function (scratchpad, current_phase_settings, phase_data, t)
			phase_data.state = current_phase_settings.inital_state
			phase_data.indexed_escape_times = _index_against_challenge(current_phase_settings.dance_escape_step)
			phase_data.t_til_switch = t + current_phase_settings.t_for_each_loop[1]

			local minion_spawn_manager = Managers.state.minion_spawn

			minion_spawn_manager:inject_replacement_breeds(current_phase_settings.special_breed_override)

			if _is_havoc() then
				Managers.state.pacing:set_specials_max_alive_bonus_multiplier(HAVOC_DANCE_SPECIALS_BONUS_MULTIPLIER)
			end

			local health_extension = ScriptUnit.has_extension(scratchpad.boss_unit, "health_system")

			if health_extension then
				health_extension:set_unkillable(true)
			end
		end,
		update = function (scratchpad, current_phase_settings, phase_data, t)
			local indexed_escape_times = phase_data.indexed_escape_times

			if phase_data.state == DANCE_STATES.dance then
				local abilities_component = scratchpad.abilities_component

				if not phase_data.dive_bomb_completed then
					phase_data.dive_bomb_completed = true

					local spawn_comp = BLACKBOARDS[scratchpad.boss_unit].spawn

					GameSession.set_game_object_field(spawn_comp.game_session, spawn_comp.game_object_id, "want_to_dive_bomb", true)
				end

				if _try_initial_teleport(scratchpad, phase_data, "center", teleport_types.predefined, false, false) then
					return
				end

				local teleport_component = scratchpad.teleport_component
				local teleport_in_flight = teleport_component and teleport_component.teleport_allowed
				local has_queued_teleport = scratchpad._queued_teleports and #scratchpad._queued_teleports > 0
				local teleport_busy = teleport_in_flight or has_queued_teleport

				if teleport_busy and not phase_data.dance_started then
					return
				end

				_set_toughness_shield_state(scratchpad, false)

				if not phase_data.dance_started then
					abilities_component.ability_position:store(scratchpad.positions.center:unbox())

					abilities_component.current_ability = not scratchpad.enraged and "dance" or ""
					phase_data.dance_started = true
					phase_data.dance_start_health, phase_data.dance_min_t = BossPhaseUtilities.begin_health_escape(scratchpad, t, current_phase_settings.dance_min_time)

					DanceStageHazard.init(scratchpad, true)
					DanceStageHazard.set_disallowed_zone(scratchpad, 1)

					if abilities_component.current_ability == "" then
						for i = 1, #current_phase_settings.events do
							local event_name = current_phase_settings.events[i]

							if i == 2 then
								scratchpad.dance_hazard.center_position = scratchpad.positions.center
							end

							DanceStageHazard.on_phase_event_triggered(scratchpad, event_name)
						end
					end

					return
				end

				local dance_walls = _get_component_by_name(scratchpad.dance_hazard.dance_walls_unit, "WizardBossDanceWalls")

				DanceStageHazard.update(scratchpad, t)

				if not scratchpad.enraged then
					local health_extension = ScriptUnit.has_extension(scratchpad.boss_unit, "health_system")

					if health_extension and health_extension:current_health_percent() < current_phase_settings.enrage_threshold then
						scratchpad.enraged = true
						abilities_component.is_enraged = true
					end
				end

				if scratchpad.enraged then
					abilities_component.current_ability = ""
				end

				local timer_expired = t > phase_data.t_til_switch
				local is_mid_attack = DanceStageHazard.is_mid_attack(scratchpad, t)
				local health_triggered = BossPhaseUtilities.health_escape_triggered(scratchpad, phase_data.dance_start_health, phase_data.dance_min_t, indexed_escape_times[1], t)
				local rotation_complete = dance_walls and dance_walls:has_completed_full_rotation()

				if (rotation_complete or timer_expired or health_triggered) and not is_mid_attack and not teleport_in_flight then
					DanceStageHazard.exit(scratchpad)

					if scratchpad.enraged then
						table.clear(scratchpad._queued_teleports)
						BossPhaseUtilities.teleport(scratchpad, "center", teleport_types.predefined, false, true)
					end

					phase_data.teleport_done = nil
					phase_data.dive_bomb_completed = nil
					phase_data.enraged_teleport_t = nil
					phase_data.dance_started = nil
					phase_data.state = DANCE_STATES.exhausted
					abilities_component.exhaust_duration = current_phase_settings.exhaust_duration
					abilities_component.current_ability = "exhausted"
					phase_data.t_til_switch = t + current_phase_settings.t_for_each_loop[2]
					phase_data.delayed_escape_teleport = t + current_phase_settings.delayed_escape_timer
					phase_data.dance_start_health, phase_data.dance_min_t = BossPhaseUtilities.begin_health_escape(scratchpad, t, current_phase_settings.dance_min_time)
				elseif scratchpad.enraged and (not phase_data.enraged_teleport_t or t > phase_data.enraged_teleport_t) then
					BossPhaseUtilities.teleport(scratchpad, "random", teleport_types.predefined, true, false)

					phase_data.enraged_teleport_t = t + 10
				end
			elseif phase_data.state == DANCE_STATES.exhausted then
				local health_triggered = BossPhaseUtilities.health_escape_triggered(scratchpad, phase_data.dance_start_health, phase_data.dance_min_t, indexed_escape_times[2], t)
				local timer_expired = t > phase_data.delayed_escape_teleport

				if timer_expired or health_triggered then
					_try_initial_teleport(scratchpad, phase_data, "narrative_01", teleport_types.predefined, false, false)
					_set_toughness_shield_state(scratchpad, true)
				end

				if t > phase_data.t_til_switch then
					phase_data.exhausted_started = nil
					phase_data.teleport_done = nil
					phase_data.state = DANCE_STATES.dance
					phase_data.t_til_switch = t + current_phase_settings.t_for_each_loop[1]
				end

				_try_start_retreat_burst(scratchpad, t, current_phase_settings.burst_events)
			end
		end,
		exit = function (scratchpad, current_phase_settings, t)
			DanceStageHazard.exit(scratchpad)

			local minion_spawn_manager = Managers.state.minion_spawn

			minion_spawn_manager:remove_injected_breeds(current_phase_settings.special_breed_override)

			if _is_havoc() then
				Managers.state.pacing:set_specials_max_alive_bonus_multiplier(1)
			end
		end,
		on_phase_event_triggered = function (scratchpad, event_name)
			DanceStageHazard.on_phase_event_triggered(scratchpad, event_name)
		end,
	},
	all_players_dead = {
		phase_settings = {},
		update = function (scratchpad, current_phase_settings, phase_data, t)
			if not phase_data.all_players_dead_mocking_vo then
				-- Nothing
			end

			if not phase_data.cancel_all_abilities then
				local abilities_component = scratchpad.abilities_component

				abilities_component.current_ability = ""

				abilities_component.ability_position:store(0, 0, 0)
			end

			if not phase_data.wait_t then
				phase_data.wait_t = t + 2
			elseif phase_data.wait_t and t > phase_data.wait_t and not phase_data.teleport_done then
				BossPhaseUtilities.teleport(scratchpad, "narrative_01", teleport_types.predefined)

				phase_data.teleport_done = true
			end
		end,
	},
	intermission_01 = {
		phase_settings = {
			basic_attack_multiplier = 0.5,
			inital_wait_t = 2,
			minimum_time_required_in_phase = 15,
			use_health = true,
			use_time = true,
			wait_t = 9,
			wait_timings_until_force_phase_change = 45,
			wanted_trickle = "tier_1",
			wave_cleared_event = "catch_terror_event_done",
			wave_event = "spillway_wizard_finite_tracked_wave",
		},
		update = function (scratchpad, current_phase_settings, phase_data, t)
			local abilities_component = scratchpad.abilities_component

			abilities_component.basic_attack_multiplier = current_phase_settings.basic_attack_multiplier

			if _try_initial_teleport(scratchpad, phase_data, "narrative_01", teleport_types.predefined, false) then
				return
			end

			_set_toughness_shield_state(scratchpad, true)

			if current_phase_settings.wave_event and not phase_data.event_registered then
				phase_data.event_registered = true
				scratchpad.spillway_wave_cleared = false

				Managers.event:register_with_parameters(scratchpad.current_phase, current_phase_settings.wave_cleared_event, "event_catcher", scratchpad)
				BossPhaseUtilities.start_terror_event(current_phase_settings.wave_event)
			end

			if scratchpad.spillway_wave_cleared then
				phase_data.is_forced = true
			end

			if not phase_data.wait_t then
				phase_data.wait_t = t + current_phase_settings.inital_wait_t
			elseif t > phase_data.wait_t then
				phase_data.wait_t = t + current_phase_settings.wait_t

				local should_fly = math.random() < 0.8

				BossPhaseUtilities.teleport(scratchpad, "random", teleport_types.predefined, should_fly)
			end
		end,
		exit = function (scratchpad, current_phase_settings, t)
			local abilities_component = scratchpad.abilities_component

			abilities_component.basic_attack_multiplier = 1

			if current_phase_settings.wave_event then
				Managers.event:unregister(scratchpad.current_phase, current_phase_settings.wave_cleared_event)
				BossPhaseUtilities.stop_terror_event(scratchpad, current_phase_settings.wave_event)

				scratchpad.spillway_wave_cleared = nil
			end
		end,
		event_catcher = function (self, scratchpad)
			scratchpad.spillway_wave_cleared = true
		end,
	},
	defeat = {
		phase_settings = {
			exhaust_duration = 99,
			use_health = false,
			use_time = false,
			voiceline_delay_t = 4,
		},
		init = function (scratchpad, current_phase_settings, phase_data, t)
			local unit = scratchpad.boss_unit
			local toughness_extension = ScriptUnit.extension(unit, "toughness_system")

			toughness_extension:destroy_shield()
			toughness_extension:set_invulnerable(true)
			BossPhaseUtilities.set_boss_invulnerability(scratchpad.boss_unit, true)

			local abilities_component = scratchpad.abilities_component

			abilities_component.in_basic_attack = false
			abilities_component.current_ability = "exhausted"
			abilities_component.exhaust_duration = current_phase_settings.exhaust_duration

			_kill_all_enemies(unit)

			phase_data.voiceline_delay_t = current_phase_settings.voiceline_delay_t + t
		end,
		update = function (scratchpad, current_phase_settings, phase_data, t)
			local abilities_component = scratchpad.abilities_component

			if abilities_component.current_ability ~= "exhausted" then
				abilities_component.current_ability = "exhausted"
			end

			if _try_initial_teleport(scratchpad, phase_data, "center", teleport_types.predefined, true, true, true) then
				phase_data.voiceline_delay_t = current_phase_settings.voiceline_delay_t + t

				return
			end

			if phase_data.voiceline_delay_t and t < phase_data.voiceline_delay_t then
				return
			elseif not phase_data.vo_played then
				Vo.mission_giver_mission_info_vo("rule_based", nil, "mission_spillway_boss_dead_a")

				phase_data.vo_played = true

				_end_music_objective()
			end
		end,
		exit = function (scratchpad, current_phase_settings, t)
			return
		end,
	},
}
boss_template.phases.intermission_02 = table.clone(boss_template.phases.intermission_01)
boss_template.phases.intermission_02.phase_settings.wanted_trickle = "tier_2"
boss_template.phases.exhausted_02 = table.clone(boss_template.phases.exhausted_01)

return boss_template
