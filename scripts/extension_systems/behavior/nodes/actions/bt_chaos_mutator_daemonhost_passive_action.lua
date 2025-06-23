-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_chaos_mutator_daemonhost_passive_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Attack = require("scripts/utilities/attack/attack")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local ChaosDaemonhostSettings = require("scripts/settings/monster/chaos_daemonhost_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionPerception = require("scripts/utilities/minion_perception")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local NavQueries = require("scripts/utilities/nav_queries")
local Suppression = require("scripts/utilities/attack/suppression")
local Threat = require("scripts/utilities/threat")
local Vo = require("scripts/utilities/vo")
local STAGES = ChaosDaemonhostSettings.stages
local BtChaosMutatorDaemonhostPassiveAction = class("BtChaosMutatorDaemonhostPassiveAction", "BtNode")
local NAV_MESH_ABOVE, NAV_MESH_BELOW = 5, 5
local _setup_progress_bar, _closets_aggro_target

BtChaosMutatorDaemonhostPassiveAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]

	scratchpad.side = side

	local spawn_component = blackboard.spawn

	scratchpad.spawn_component = spawn_component
	scratchpad.suppression_component = Blackboard.write_component(blackboard, "suppression")
	scratchpad.fx_system = Managers.state.extension:system("fx_system")
	scratchpad.physics_world = spawn_component.physics_world

	local aim_component = Blackboard.write_component(blackboard, "aim")

	scratchpad.aim_component = aim_component
	aim_component.controlled_aiming = true

	local animation_extension = ScriptUnit.extension(unit, "animation_system")
	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	scratchpad.animation_extension = animation_extension
	scratchpad.buff_extension = buff_extension
	scratchpad.health_extension = ScriptUnit.extension(unit, "health_system")

	scratchpad.health_extension:set_invulnerable(true)

	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")

	local current_rotation_speed = locomotion_extension:rotation_speed()

	scratchpad.original_rotation_speed = current_rotation_speed
	scratchpad.ritual_timings = Managers.state.difficulty:get_table_entry_by_challenge(action_data.ritual_timings)
	scratchpad.next_flashed_fx_t = 0
	scratchpad.next_anger_t = 0
	scratchpad.anger = 0
	scratchpad.anger_tick = 0
	scratchpad.flashing_units = {}
	scratchpad.distance_threat_units = {}
	scratchpad.next_vo_trigger_t = 0

	Threat.set_threat_decay_enabled(unit, false)

	local spawn_anim_events = action_data.spawn_anim_events
	local spawn_anim = Animation.random_event(spawn_anim_events)

	animation_extension:anim_event(spawn_anim)

	scratchpad.spawn_anim = spawn_anim

	self:_switch_stage(unit, breed, scratchpad, action_data, STAGES.passive)

	local radius = action_data.nav_cost_map_sphere_radius
	local cost = action_data.nav_cost_map_sphere_cost
	local nav_cost_map_name = action_data.nav_cost_map_name
	local nav_cost_map_id = Managers.state.nav_mesh:nav_cost_map_id(nav_cost_map_name)
	local nav_cost_map_volume_id = Managers.state.nav_mesh:add_nav_cost_map_sphere_volume(POSITION_LOOKUP[unit], radius, cost, nav_cost_map_id)

	scratchpad.nav_cost_map_volume_id = nav_cost_map_volume_id
	scratchpad.nav_cost_map_id = nav_cost_map_id

	local on_enter_buff_names = action_data.on_enter_buff_names
	local num_on_enter_buff_names = #on_enter_buff_names
	local on_enter_buffs = Script.new_array(num_on_enter_buff_names)

	for i = 1, num_on_enter_buff_names do
		local buff_name = on_enter_buff_names[i]
		local _, buff_id = buff_extension:add_externally_controlled_buff(buff_name, t)

		on_enter_buffs[i] = buff_id
	end

	scratchpad.on_enter_buffs = on_enter_buffs
	scratchpad.old_anger = 0
	scratchpad.old_flashlight_flat = 0
	scratchpad.old_distance_flat = 0
	scratchpad.old_health_flat = 0
	scratchpad.old_suppression_flat = 0
	scratchpad.old_distance_tick = 0
	scratchpad.old_flashlight_tick = 0
	scratchpad.move_stage = 1
	scratchpad.t_until_next_stage = self:_get_time_until_next_stage(scratchpad)
	scratchpad.delay = 10
	scratchpad.timer = 0

	self:_populate_cultists(scratchpad, action_data, unit)

	scratchpad.multiplier = self:_get_alive_cultists(scratchpad)

	local fx_system = Managers.state.extension:system("fx_system")

	scratchpad.fx_system = fx_system

	if not scratchpad.chanting_effect_id then
		local chanting_effect_id = fx_system:start_template_effect(action_data.effect_template, unit)

		scratchpad.chanting_effect_id = chanting_effect_id
	end
end

BtChaosMutatorDaemonhostPassiveAction.init_values = function (self, blackboard, action_data, node_data)
	local statistics_component = Blackboard.write_component(blackboard, "statistics")

	statistics_component.player_deaths = 0
end

BtChaosMutatorDaemonhostPassiveAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local locomotion_extension = scratchpad.locomotion_extension
	local original_rotation_speed = scratchpad.original_rotation_speed

	locomotion_extension:set_rotation_speed(original_rotation_speed)
	scratchpad.health_extension:set_invulnerable(false)

	if scratchpad.chanting_effect_id then
		scratchpad.fx_system:stop_template_effect(scratchpad.chanting_effect_id)

		scratchpad.chanting_effect_id = nil
	end

	local cultists = scratchpad.chanting_units

	for _, cultist in pairs(cultists) do
		if HEALTH_ALIVE[cultist] then
			Attack.execute(cultist, DamageProfileTemplates.default, "power_level", 2000, "attack_direction", Vector3.up(), "instakill", true)
		end
	end

	if HEALTH_ALIVE[unit] then
		if scratchpad.heal_needed_per_t then
			scratchpad.health_extension:add_heal(scratchpad.heal_needed_per_t)
		end

		local stagger_component = blackboard.stagger
		local num_triggered_staggers = stagger_component.num_triggered_staggers
		local perception_extension = scratchpad.perception_extension

		perception_extension:set_use_action_controlled_alert(false)

		local target_player = _closets_aggro_target(unit, breed, blackboard, scratchpad, action_data, t)

		if HEALTH_ALIVE[target_player] then
			Threat.add_flat_threat(unit, target_player, math.huge)
			perception_extension:alert(target_player)
		end

		MinionPerception.attempt_aggro(perception_extension)
		self:_switch_stage(unit, breed, scratchpad, action_data, STAGES.aggroed)

		local buff_extension, on_enter_buffs = scratchpad.buff_extension, scratchpad.on_enter_buffs

		for i = 1, #on_enter_buffs do
			local buff_id = on_enter_buffs[i]

			buff_extension:remove_externally_controlled_buff(buff_id)
		end

		local on_leave_buff_name = action_data.on_leave_buff_name

		buff_extension:add_internally_controlled_buff(on_leave_buff_name, t)
	end

	Threat.set_threat_decay_enabled(unit, true)

	local nav_cost_map_volume_id = scratchpad.nav_cost_map_volume_id
	local nav_cost_map_id = scratchpad.nav_cost_map_id

	Managers.state.nav_mesh:remove_nav_cost_map_volume(nav_cost_map_volume_id, nav_cost_map_id)

	local statistics_component = Blackboard.write_component(blackboard, "statistics")

	Managers.state.pacing:set_minion_listening_for_player_deaths(unit, statistics_component, true)

	local aim_component = scratchpad.aim_component

	aim_component.controlled_aiming = true
end

BtChaosMutatorDaemonhostPassiveAction._switch_stage = function (self, unit, breed, scratchpad, action_data, stage, t)
	local previous_stage = scratchpad.stage
	local stage_settings = action_data.stage_settings[stage]

	if stage_settings then
		local anim_events

		if previous_stage == STAGES.passive then
			anim_events = action_data.exit_passive.on_finished_anim_events
		else
			anim_events = stage_settings.anim_events
		end

		if anim_events then
			local animation_extension = scratchpad.animation_extension
			local anim_event

			if anim_events.damaged ~= nil then
				local health_extension = scratchpad.health_extension
				local current_health_percent = health_extension:current_health_percent()
				local damaged_health_percent = stage_settings.damaged_health_percent

				if current_health_percent < damaged_health_percent then
					anim_event = Animation.random_event(anim_events.damaged)
				else
					anim_event = Animation.random_event(anim_events.default)
				end
			else
				anim_event = Animation.random_event(anim_events)
			end

			animation_extension:anim_event(anim_event)

			local durations = stage_settings.durations

			if durations then
				local duration = durations[anim_event]

				scratchpad.duration = t + duration
			end
		end

		local sfx_event = stage_settings.sfx_event

		if sfx_event then
			local fx_system = scratchpad.fx_system

			fx_system:trigger_wwise_event(sfx_event, nil, unit)
		end

		local suppression_settings = stage_settings.suppression

		if suppression_settings then
			local from_position = POSITION_LOOKUP[unit]
			local relation = "allied"

			Suppression.apply_area_minion_suppression(unit, suppression_settings, from_position, relation)
		end

		local vo_settings = stage_settings.vo

		if vo_settings then
			local on_enter_vo_settings = vo_settings.on_enter

			if on_enter_vo_settings then
				local player_vo = on_enter_vo_settings.player

				if player_vo then
					local vo_event = player_vo.vo_event
					local non_threatening_player = player_vo.is_non_threatening_player

					Vo.random_player_enemy_alert_event(unit, breed, vo_event, non_threatening_player)

					if vo_event == "aggroed" then
						Vo.set_dynamic_smart_tag(unit, vo_event)
					end
				end

				local daemonhost_vo = on_enter_vo_settings.daemonhost

				if daemonhost_vo then
					local vo_event = daemonhost_vo.vo_event

					Vo.enemy_generic_vo_event(unit, vo_event, breed.name)
				end
			end
		end

		local trigger_health_bar = stage_settings.trigger_health_bar and not scratchpad.triggered_health_bar

		if trigger_health_bar then
			local boss_extension = ScriptUnit.extension(unit, "boss_system")

			boss_extension:start_boss_encounter()

			local spawn_component = scratchpad.spawn_component
			local game_object_id = spawn_component.game_object_id

			Managers.state.game_session:send_rpc_clients("rpc_start_boss_encounter", game_object_id)

			scratchpad.triggered_health_bar = true
		end

		if stage_settings.reset_suppression then
			scratchpad.suppression_component.suppress_value = 0
			scratchpad.suppression_component.is_suppressed = false
		end

		if stage_settings.set_aggro_target and scratchpad.wanted_aggro_target then
			Threat.add_flat_threat(unit, scratchpad.wanted_aggro_target, math.huge)
		end
	end

	local spawn_component = scratchpad.spawn_component
	local game_session, game_object_id = spawn_component.game_session, spawn_component.game_object_id

	GameSession.set_game_object_field(game_session, game_object_id, "stage", stage)

	scratchpad.stage = stage
end

BtChaosMutatorDaemonhostPassiveAction._update = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local stage = scratchpad.stage
	local side = scratchpad.side
	local valid_enemy_player_units = side.valid_enemy_player_units
	local position = POSITION_LOOKUP[unit]

	scratchpad.multiplier = self:_get_alive_cultists(scratchpad)

	local multiplier = scratchpad.multiplier

	if not scratchpad.activated then
		scratchpad.activated = self:_get_closest_player(unit, position, valid_enemy_player_units, scratchpad, action_data)
	end

	local currently_chanting = scratchpad.currently_chanting

	if not currently_chanting then
		self:_start_chanting(unit, scratchpad)
	end

	if scratchpad.speed then
		if multiplier == 0 and HEALTH_ALIVE[unit] then
			self:_kill(scratchpad, action_data, unit)
		end

		if Managers.state.terror_event:num_active_events() > 0 then
			return
		end

		_setup_progress_bar(unit, breed, blackboard, scratchpad, action_data, t)

		local half_time_multiplier = action_data.half_time_multiplier
		local dt = Managers.time:delta_time("gameplay")
		local current_speed = scratchpad.speed

		if current_speed == "half" then
			scratchpad.timer = scratchpad.timer + dt * (multiplier / half_time_multiplier)
		elseif current_speed == "full" then
			scratchpad.timer = scratchpad.timer + dt * multiplier
		end

		if scratchpad.timer > scratchpad.t_until_next_stage then
			scratchpad.timer = 0
			scratchpad.move_stage = scratchpad.move_stage + 1

			self:_switch_stage(unit, breed, scratchpad, action_data, scratchpad.move_stage, t)

			scratchpad.t_until_next_stage = self:_get_time_until_next_stage(scratchpad)
		end

		self:_update_looping_vo(unit, breed, scratchpad, action_data, stage, t)
	end
end

BtChaosMutatorDaemonhostPassiveAction._kill = function (self, scratchpad, action_data, unit)
	if scratchpad.chanting_effect_id then
		scratchpad.fx_system:stop_template_effect(scratchpad.chanting_effect_id)

		scratchpad.chanting_effect_id = nil
	end

	scratchpad.health_extension:set_invulnerable(false)
	Attack.execute(unit, DamageProfileTemplates.default, "power_level", 2000, "attack_direction", Vector3.up(), "instakill", true)

	local mutator_death_stinger = action_data.death_stinger
	local fx_system = scratchpad.fx_system

	fx_system:trigger_wwise_event(mutator_death_stinger, nil, unit)
end

BtChaosMutatorDaemonhostPassiveAction._populate_cultists = function (self, scratchpad, action_data, unit)
	scratchpad.chanting_units = {}

	local rotational_values = action_data.ritualist_settings.rotational_values
	local amount = action_data.ritualist_settings.amount
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	local nav_world = navigation_extension:nav_world()
	local traverse_logic = navigation_extension:traverse_logic()
	local side_extension = ScriptUnit.extension(unit, "side_system")
	local side_id = side_extension.side_id

	for i = 1, amount do
		local position = Unit.world_position(unit, 1)
		local rotation = Unit.local_rotation(unit, 1)
		local offsets = rotational_values[i]

		position[1] = position[1] + offsets[1]
		position[2] = position[2] + offsets[2]

		local pos_on_nav = NavQueries.position_on_mesh(nav_world, position, NAV_MESH_ABOVE, NAV_MESH_BELOW, traverse_logic)

		if pos_on_nav then
			local minion_spawn_manager = Managers.state.minion_spawn
			local param_table = minion_spawn_manager:request_param_table()

			param_table.optional_target_unit = unit

			local cultist_unit = minion_spawn_manager:spawn_minion("chaos_mutator_ritualist", pos_on_nav, rotation, side_id, param_table)

			table.insert(scratchpad.chanting_units, cultist_unit)
		end
	end
end

BtChaosMutatorDaemonhostPassiveAction._get_alive_cultists = function (self, scratchpad)
	local cultist_units = scratchpad.chanting_units
	local alive = 0

	for amount, cultist in pairs(cultist_units) do
		if HEALTH_ALIVE[cultist] then
			local blackboard = BLACKBOARDS[cultist]
			local behavior_component = Blackboard.write_component(blackboard, "behavior")

			if behavior_component.move_state == "chanting" or behavior_component.move_state == "" then
				alive = alive + 1
			end
		end
	end

	scratchpad.alive_cultists = alive

	return alive * 0.1
end

BtChaosMutatorDaemonhostPassiveAction._check_damage = function (self, scratchpad)
	local cultist_units = scratchpad.chanting_units

	for amount, cultist in pairs(cultist_units) do
		if HEALTH_ALIVE[cultist] then
			local health_extension = ScriptUnit.extension(cultist, "health_system")
			local current_health_percent = health_extension:current_health_percent()

			if current_health_percent <= 0.95 then
				return true
			end
		end
	end

	return false
end

BtChaosMutatorDaemonhostPassiveAction._get_closest_player = function (self, unit, position, valid_enemy_player_units, scratchpad, action_data)
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	local nav_world = navigation_extension:nav_world()
	local in_safe_zone = Managers.state.pacing:get_in_safe_zone()

	if in_safe_zone then
		return
	end

	local ahead_unit, ahead_travel_distance = Managers.state.main_path:ahead_unit(1)

	if not ahead_travel_distance then
		return false
	end

	if Managers.state.extension:system("perception_system"):is_untargetable(ahead_unit) then
		return false
	end

	local nav_mesh_position = NavQueries.position_on_mesh(nav_world, POSITION_LOOKUP[unit], NAV_MESH_ABOVE, NAV_MESH_BELOW)
	local _, travel_distance = MainPathQueries.closest_position(nav_mesh_position)
	local damage_override = self:_check_damage(scratchpad)
	local close_distance_offset, far_distance_offset = action_data.close_distance_offset, action_data.far_distance_offset
	local close_distance = travel_distance - close_distance_offset
	local far_distance = travel_distance - far_distance_offset

	if close_distance < ahead_travel_distance or damage_override then
		scratchpad.speed = "full"

		return true
	end

	if far_distance < ahead_travel_distance then
		scratchpad.speed = "half"
	end

	return false
end

BtChaosMutatorDaemonhostPassiveAction._get_players_los = function (self, valid_enemy_player_units, scratchpad)
	local perception_extension = scratchpad.perception_extension
	local num_enemies = #valid_enemy_player_units

	for i = 1, num_enemies do
		local target_unit = valid_enemy_player_units[i]
		local has_line_of_sight = perception_extension:has_line_of_sight(target_unit)

		if has_line_of_sight then
			scratchpad.player_in_los = true
		end
	end
end

BtChaosMutatorDaemonhostPassiveAction._get_time_until_next_stage = function (self, scratchpad)
	local ritual_timings = scratchpad.ritual_timings

	if not scratchpad.fixed_timings then
		scratchpad.total_t_to_spawn = 0
		scratchpad.fixed_timings = {}

		for i = 1, #ritual_timings do
			local timings = ritual_timings[i]
			local time_per_stage = math.random_range(timings[1], timings[2])

			scratchpad.total_t_to_spawn = scratchpad.total_t_to_spawn + time_per_stage
			scratchpad.fixed_timings[i] = time_per_stage
		end
	end

	local next_stage_at = scratchpad.fixed_timings[scratchpad.stage]

	return math.round(next_stage_at)
end

BtChaosMutatorDaemonhostPassiveAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local stage_settings = action_data.stage_settings[scratchpad.stage]
	local wanted_target = scratchpad.wanted_aggro_target or scratchpad.closest_flashlight_target or scratchpad.closest_target_unit

	if stage_settings and stage_settings.rotate_towards_target and HEALTH_ALIVE[wanted_target] then
		local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, wanted_target)

		scratchpad.locomotion_extension:set_wanted_rotation(flat_rotation)
	end

	if wanted_target and HEALTH_ALIVE[wanted_target] then
		local aim_pos = Unit.world_position(wanted_target, Unit.node(wanted_target, "j_head"))

		scratchpad.aim_component.controlled_aim_position:store(aim_pos)
	end

	local duration = scratchpad.duration

	if duration then
		if t > scratchpad.duration then
			return "done"
		end
	else
		self:_update(unit, breed, blackboard, scratchpad, action_data, t)
	end

	return "running"
end

BtChaosMutatorDaemonhostPassiveAction._update_looping_vo = function (self, unit, breed, scratchpad, action_data, stage, t)
	local stage_settings = action_data.stage_settings[stage]

	if stage_settings and stage_settings.vo and stage_settings.vo.looping then
		local next_vo_trigger_t = scratchpad.next_vo_trigger_t

		if next_vo_trigger_t < t then
			local vo_settings = stage_settings.vo.looping
			local vo_event = vo_settings.vo_event

			if type(vo_event) == "table" then
				vo_event = math.random_array_entry(vo_event)
			end

			Vo.enemy_generic_vo_event(unit, vo_event, "chaos_daemonhost")

			local cooldown_duration = vo_settings.cooldown_duration

			if type(cooldown_duration) == "table" then
				cooldown_duration = math.random_range(cooldown_duration[1], cooldown_duration[2])
			end

			scratchpad.next_vo_trigger_t = t + cooldown_duration
		end
	end

	if not scratchpad.awakened_stinger then
		local fx_system = scratchpad.fx_system
		local mutator_awakened_stinger = "wwise/events/minions/play_daemonhost_mutator_awakened_stinger"

		fx_system:trigger_wwise_event(mutator_awakened_stinger, nil, unit)

		scratchpad.awakened_stinger = true
	end
end

BtChaosMutatorDaemonhostPassiveAction._start_chanting = function (self, unit, scratchpad)
	local cultist_units = scratchpad.chanting_units
	local fx_system = scratchpad.fx_system
	local wwise_event = "wwise/events/minions/play_mutator_daemonhost_cult_chant"

	for i = 1, #cultist_units do
		local cultist_unit = cultist_units[i]

		fx_system:trigger_wwise_event(wwise_event, nil, cultist_unit)
	end

	scratchpad.currently_chanting = true
end

function _setup_progress_bar(unit, breed, blackboard, scratchpad, action_data, t)
	scratchpad.health_extension = ScriptUnit.extension(unit, "health_system")

	if not scratchpad.triggered_health_bar then
		local boss_extension = ScriptUnit.extension(unit, "boss_system")

		boss_extension:start_boss_encounter()

		local spawn_component = scratchpad.spawn_component
		local game_object_id = spawn_component.game_object_id

		Managers.state.game_session:send_rpc_clients("rpc_start_boss_encounter", game_object_id)

		scratchpad.max_health = scratchpad.health_extension:max_health()
		scratchpad.to_damage = scratchpad.max_health - scratchpad.max_health * 0.01
		scratchpad.heal_needed_per_t = scratchpad.max_health / scratchpad.total_t_to_spawn

		scratchpad.health_extension:add_damage(scratchpad.to_damage, nil, nil, nil, nil, nil, nil)

		scratchpad.triggered_health_bar = true
		scratchpad._health_timer = 0
	elseif scratchpad.triggered_health_bar then
		local half_time_multiplier = action_data.half_time_multiplier
		local dt = Managers.time:delta_time("gameplay")
		local current_speed = scratchpad.speed
		local multiplier = scratchpad.multiplier

		if not scratchpad._health_timer_threshold then
			scratchpad._health_timer_threshold = dt
		end

		if current_speed == "half" then
			scratchpad._health_timer = scratchpad._health_timer + dt * (multiplier / half_time_multiplier)
		elseif current_speed == "full" then
			scratchpad._health_timer = scratchpad._health_timer + dt * multiplier
		end

		if scratchpad._health_timer >= scratchpad._health_timer_threshold then
			scratchpad._health_timer = 0
			scratchpad._health_timer_threshold = dt + 1

			scratchpad.health_extension:add_heal(scratchpad.heal_needed_per_t)
		end
	end
end

function _closets_aggro_target(unit, breed, blackboard, scratchpad, action_data, t)
	local side = scratchpad.side
	local valid_enemy_player_units = side.valid_enemy_player_units
	local num_enemies = #valid_enemy_player_units
	local position = POSITION_LOOKUP[unit]
	local distance_to_all_players = {}

	for i = 1, num_enemies do
		local target_unit = valid_enemy_player_units[i]
		local target_position = POSITION_LOOKUP[target_unit]
		local distance_to_target_sq = Vector3.distance_squared(position, target_position)

		distance_to_all_players[i] = {
			distance_to_target_sq,
			target_unit
		}
	end

	local min = 1000
	local target_player

	for i = 1, #distance_to_all_players do
		local player_data = distance_to_all_players[i]

		if min < player_data[1] and min then
			min = player_data[1]
			target_player = player_data[2]
		end
	end

	return target_player
end

return BtChaosMutatorDaemonhostPassiveAction
