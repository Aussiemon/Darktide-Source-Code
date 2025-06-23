-- chunkname: @scripts/managers/mutator/mutators/mutator_toxic_gas_twins.lua

require("scripts/managers/mutator/mutators/mutator_base")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breeds = require("scripts/settings/breed/breeds")
local Component = require("scripts/utilities/component")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local HordeCompositions = require("scripts/managers/pacing/horde_pacing/horde_compositions")
local HordeSettings = require("scripts/settings/horde/horde_settings")
local HordeTemplates = require("scripts/managers/horde/horde_templates")
local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local NavQueries = require("scripts/utilities/nav_queries")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local HORDE_TYPES = HordeSettings.horde_types
local MainPathQueries = require("scripts/utilities/main_path_queries")
local Vo = require("scripts/utilities/vo")
local aggro_states = PerceptionSettings.aggro_states
local MutatorToxicGasTwins = class("MutatorToxicGasTwins", "MutatorBase")
local TWIN_SPAWN_ORDER = {
	{
		"renegade_twin_captain_two"
	},
	{
		"renegade_twin_captain"
	},
	{
		"renegade_twin_captain_two"
	},
	{
		"renegade_twin_captain",
		"renegade_twin_captain_two"
	},
	{
		"renegade_twin_captain",
		"renegade_twin_captain_two"
	}
}
local TWIN_DESPAWN_DISTANCES = {
	115,
	385,
	590,
	700,
	false
}
local HORDE_SPAWN = {
	false,
	true,
	true,
	true,
	false
}
local SPAWN_GAS_LIST = {
	true,
	true,
	true,
	true,
	true
}
local SPECIALS_MULTIPLIER_TWINS_ACTIVE = 3
local SPECIALS_MULTIPLIER_TWINS_ACTIVE_BOSS_FIGHT = 1
local SPECIALS_MULTIPLIER_TWINS_INACTIVE = 0.2
local SPECIALS_MULTIPLIER_GAS_PHASE = 4
local TWIN_IDS = {
	renegade_twin_captain = 1,
	renegade_twin_captain_two = 2
}
local appear_ambisonics_sound_event = "wwise/events/minions/play_minion_twins_ambush_spawn_impact"
local gas_wave_ambisonics = "wwise/events/play_event_twins_arena_gas_wave_ambisonics"
local MAINPATH_SOUND_EVENTS = {
	{
		event = "wwise/events/minions/play_minion_special_twins_ambush_spawn",
		distance = 25
	},
	{
		event = "wwise/events/minions/play_minion_special_twins_ambush_spawn",
		distance = 275
	},
	{
		event = "wwise/events/minions/play_minion_special_twins_ambush_spawn",
		distance = 485
	},
	{
		event = "wwise/events/minions/play_minion_special_twins_ambush_spawn",
		distance = 500
	},
	{
		event = "wwise/events/minions/play_minion_special_twins_ambush_spawn",
		distance = 610
	}
}

MutatorToxicGasTwins.init = function (self, is_server, network_event_delegate, mutator_template, nav_world, level_seed)
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate
	self._is_active = true
	self._buffs = {}
	self._template = mutator_template
	self._nav_world = nav_world
	self._buff_affected_units = {}
	self._seed = level_seed
	self._twin_spawn_data = {}
	self._spawn_liquids = {}
	self._fx_system = Managers.state.extension:system("fx_system")
	self._spawned_twins = {}
	self._appear_explosion_template = ExplosionTemplates.twin_appear_explosion
	self._vo_started = false
	self._first_dead = false
	self._both_dead = false
	self._main_path_sound_events = table.clone(MAINPATH_SOUND_EVENTS)

	local level = Managers.state.mission:mission_level()

	self._level = level

	if is_server then
		local flag = "activate_twins"
		local has_backend_pacing_control_flag = Managers.state.pacing:get_backend_pacing_control_flag(flag)

		if has_backend_pacing_control_flag then
			Log.info("MutatorToxicGasTwins", "Found backend control flag %s, it is set to true", flag)
		elseif has_backend_pacing_control_flag == false then
			Log.info("MutatorToxicGasTwins", "Found backend control flag %s, it is set to false", flag)
		else
			Log.info("MutatorToxicGasTwins", "Backend control flag %s don't exist", flag)
		end

		self._has_backend_pacing_control_flag = has_backend_pacing_control_flag
	end
end

MutatorToxicGasTwins._activate_cloud = function (self, cloud, is_other_cloud, delay)
	if cloud.active then
		return
	end

	local section_id = cloud.section_id

	self._current_section_id = section_id

	local is_last_spawn = false

	if section_id == self._num_sections then
		is_last_spawn = true
	end

	self._is_last_spawn = is_last_spawn

	if not cloud.dont_trigger_this_cloud and (not delay or delay == 0) then
		self:_spawn_volume_and_liquid(cloud)
	else
		cloud.delay = delay
	end

	cloud.active = true

	if not self._active_gas_clouds[section_id] then
		self._active_gas_clouds[section_id] = {
			cloud
		}
	else
		self._active_gas_clouds[section_id][#self._active_gas_clouds[section_id] + 1] = cloud
	end

	if #self._spawned_twins > 0 then
		return
	end

	local id = cloud.id
	local twin_spawn_data = self._twin_spawn_data[section_id] and self._twin_spawn_data[section_id][id]

	if self._twin_spawn_data[section_id] and self._twin_spawn_data[section_id][id] then
		self:_spawn_twins(twin_spawn_data, section_id)
	end

	if not is_other_cloud then
		local wanted_section_id = cloud.section_id
		local gas_clouds = self._gas_clouds_to_activate

		for i = 1, #gas_clouds do
			local other_cloud = gas_clouds[i]

			if other_cloud.section_id == wanted_section_id then
				self:_activate_cloud(other_cloud, true, delay)
			end
		end
	end
end

MutatorToxicGasTwins._update_delayed_cloud = function (self, cloud, dt)
	cloud.delay = cloud.delay - dt

	if cloud.delay <= 0 then
		if not cloud.dont_trigger_this_cloud then
			self:_spawn_volume_and_liquid(cloud)
		end

		cloud.delay = nil
	end
end

MutatorToxicGasTwins._spawn_volume_and_liquid = function (self, cloud, optional_buildup_liquid_delay)
	if not SPAWN_GAS_LIST[self._current_section_id] then
		Log.info("MutatorToxicGasTwins", "Blocked spawning of %d because SPAWN_GAS_LIST says so", self._current_section_id or cloud.section_id)

		return
	end

	local liquid_area_template

	if optional_buildup_liquid_delay then
		if not self._first_gas_phase_started then
			liquid_area_template = LiquidAreaTemplates.buildup_twin_toxic_gas_slow
		else
			liquid_area_template = LiquidAreaTemplates.buildup_twin_toxic_gas
		end

		cloud.delay = optional_buildup_liquid_delay
	elseif self._boss_fight_started then
		liquid_area_template = LiquidAreaTemplates.twin_gas_phase_toxic_gas
	else
		liquid_area_template = LiquidAreaTemplates.twin_toxic_gas
	end

	local max_liquid = cloud.max_liquid
	local unit = LiquidArea.try_create(cloud.position:unbox(), Vector3(0, 0, 1), self._nav_world, liquid_area_template, nil, max_liquid)

	cloud.liquid_unit = unit

	cloud.fog_component:set_volume_enabled(true)

	cloud.deactivated = false

	Log.info("MutatorToxicGasTwins", "Spawned gas with section_id %d and id %d ", cloud.section_id, cloud.id)

	local position = cloud.position:unbox()
	local attacking_unit = self._spawned_twins[1]

	if ALIVE[attacking_unit] then
		local blackboard = BLACKBOARDS[attacking_unit]
		local spawn_component = blackboard.spawn
		local world, physics_world = spawn_component.world, spawn_component.physics_world
		local impact_normal, charge_level, attack_type = Vector3.up(), 1
		local power_level = 5
		local explosion_template = self._appear_explosion_template

		Explosion.create_explosion(world, physics_world, position, impact_normal, attacking_unit, explosion_template, power_level, charge_level, attack_type)
	end
end

MutatorToxicGasTwins._deactivate_cloud = function (self, cloud)
	if ALIVE[cloud.liquid_unit] then
		Managers.state.unit_spawner:mark_for_deletion(cloud.liquid_unit)
	end

	if not cloud.deactivated then
		cloud.active = false
		cloud.liquid_unit = nil

		cloud.fog_component:set_volume_enabled(false)

		cloud.deactivated = true
	end
end

local TARGET_SIDE_ID = 1
local TWIN_TRAVERSAL_SPAWN_HEALTH_MODIFIER = 0.8

MutatorToxicGasTwins._spawn_twins = function (self, twin_spawn_data, section_id)
	local main_path_manager = Managers.state.main_path
	local ahead_unit = main_path_manager:ahead_unit(TARGET_SIDE_ID)
	local twin_spawn_order = TWIN_SPAWN_ORDER[section_id]
	local should_spawn_horde = HORDE_SPAWN[section_id]

	if should_spawn_horde then
		self:_spawn_horde(HORDE_TYPES.far_vector_horde, HordeTemplates.far_vector_horde, HordeCompositions.renegade_large)
	end

	self:_trigger_level_event("twins_spawned_" .. section_id)

	for i = 1, #twin_spawn_order do
		local breed_name = twin_spawn_order[i]
		local twin_id = TWIN_IDS[breed_name]
		local data = twin_spawn_data[twin_id]

		if not data.has_spawned then
			local twin_spawn_position = data.spawn_position:unbox()
			local twin_spawn_rotation = data.spawn_rotation:unbox()
			local minion_spawn_manager = Managers.state.minion_spawn
			local param_table = minion_spawn_manager:request_param_table()

			param_table.optional_aggro_state = aggro_states.aggroed
			param_table.optional_target_unit = ahead_unit
			param_table.optional_health_modifier = not self._is_last_spawn and TWIN_TRAVERSAL_SPAWN_HEALTH_MODIFIER

			local twin_unit = minion_spawn_manager:spawn_minion(breed_name, twin_spawn_position, twin_spawn_rotation, 2, param_table)

			data.has_spawned = true
			data.spawned_twin_unit = twin_unit
			self._spawned_twins[#self._spawned_twins + 1] = twin_unit

			local position = POSITION_LOOKUP[twin_unit]
			local blackboard = BLACKBOARDS[twin_unit]
			local spawn_component = blackboard.spawn
			local world, physics_world = spawn_component.world, spawn_component.physics_world
			local impact_normal, charge_level, attack_type = Vector3.up(), 1
			local power_level = 5
			local explosion_template = self._appear_explosion_template

			Explosion.create_explosion(world, physics_world, position, impact_normal, twin_unit, explosion_template, power_level, charge_level, attack_type)

			local optional_ambisonics = true

			self._fx_system:trigger_wwise_event(appear_ambisonics_sound_event, nil, nil, nil, nil, nil, optional_ambisonics)

			local move_to_position = twin_spawn_position + Quaternion.forward(twin_spawn_rotation) * 2
			local position_on_navmesh = NavQueries.position_on_mesh_with_outside_position(self._nav_world, nil, move_to_position, 1, 1, 1)

			if position_on_navmesh then
				local behavior_component = Blackboard.write_component(blackboard, "behavior")

				behavior_component.move_to_position:store(move_to_position)

				behavior_component.has_move_to_position = true
			end
		end
	end

	local multiplier = self._boss_fight_started and SPECIALS_MULTIPLIER_TWINS_ACTIVE_BOSS_FIGHT or SPECIALS_MULTIPLIER_TWINS_ACTIVE

	Managers.state.pacing:set_specials_timing_multiplier(multiplier)
	Managers.state.pacing:set_specials_force_move_timer(true)

	local mission_objective_system = Managers.state.extension:system("mission_objective_system")
	local objective_name = "objective_km_enforcer_twins_ambush"

	mission_objective_system:start_mission_objective(objective_name)

	self._objective_started = true
end

local TWIN_CLOUDS = {}

MutatorToxicGasTwins._despawn_twin = function (self, twin_unit)
	local blackboard = BLACKBOARDS[twin_unit]
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	behavior_component.should_disappear = true

	local health_extension = ScriptUnit.has_extension(twin_unit, "health_system")

	health_extension:set_invulnerable(true)
end

MutatorToxicGasTwins._despawn_twins = function (self)
	for i = 1, #self._spawned_twins do
		local twin_unit = self._spawned_twins[i]
		local blackboard = BLACKBOARDS[twin_unit]
		local behavior_component = Blackboard.write_component(blackboard, "behavior")

		behavior_component.should_disappear = true
	end
end

MutatorToxicGasTwins.on_gameplay_post_init = function (self, level, themes)
	if level then
		Level.trigger_event(level, "toxic_gas_twins")
	end

	if not self._is_server then
		return
	else
		Managers.event:register(self, "intro_cinematic_started", "_event_intro_cinematic_started")
		Managers.event:register(self, "players_teleported", "_event_players_teleported")
	end

	local gas_clouds = {}
	local component_system = Managers.state.extension:system("component_system")
	local fog_units = component_system:get_units_from_component_name("ToxicGasFog")

	if #fog_units == 0 then
		return
	end

	local twin_spawn_data = self._twin_spawn_data
	local twin_captain_spawners = component_system:get_units_from_component_name("TwinCaptainSpawner")

	for i = 1, #twin_captain_spawners do
		local twin_captain_spawner = twin_captain_spawners[i]
		local components = Component.get_components_by_name(twin_captain_spawner, "TwinCaptainSpawner")

		for _, twin_captain_spawner_component in ipairs(components) do
			local id = twin_captain_spawner_component:get_data(twin_captain_spawner, "id")
			local section_id = twin_captain_spawner_component:get_data(twin_captain_spawner, "section")
			local twin_id = twin_captain_spawner_component:get_data(twin_captain_spawner, "twin_id")

			if not twin_spawn_data[section_id] then
				twin_spawn_data[section_id] = {}
			end

			if not twin_spawn_data[section_id][id] then
				twin_spawn_data[section_id][id] = {}
			end

			if not twin_spawn_data[section_id][id][twin_id] then
				local world_position = Unit.world_position(twin_captain_spawner, 1)
				local position_on_navmesh = NavQueries.position_on_mesh_with_outside_position(self._nav_world, nil, world_position, 1, 1, 1)

				twin_spawn_data[section_id][id][twin_id] = {
					has_spawned = false,
					spawn_position = Vector3Box(position_on_navmesh),
					spawn_rotation = QuaternionBox(Unit.local_rotation(twin_captain_spawner, 1))
				}
			end
		end
	end

	local num_sections = 0

	for i = 1, #fog_units do
		local fog_unit = fog_units[i]
		local components = Component.get_components_by_name(fog_unit, "ToxicGasFog")

		for _, fog_component in ipairs(components) do
			local id = fog_component:get_data(fog_unit, "id")
			local section_id = fog_component:get_data(fog_unit, "section")
			local max_liquid = fog_component:get_data(fog_unit, "max_liquid")
			local trigger_clouds = fog_component:get_data(fog_unit, "trigger_clouds")
			local dont_trigger_this_cloud = fog_component:get_data(fog_unit, "dont_trigger_this_cloud")

			if not gas_clouds[section_id] then
				gas_clouds[section_id] = {}
			end

			if not gas_clouds[section_id][id] then
				gas_clouds[section_id][id] = {}
			end

			if num_sections < section_id then
				num_sections = section_id
			end

			Log.info("MutatorToxicGasTwins", "Added gas section %d id %d", section_id, id)

			local position = Unit.local_position(fog_unit, 1)
			local _, travel_distance = MainPathQueries.closest_position(position)
			local boxed_position = Vector3Box(position)
			local entry = {
				fog_unit = fog_unit,
				max_liquid = max_liquid,
				id = id,
				section_id = section_id,
				trigger_clouds = trigger_clouds,
				position = boxed_position,
				travel_distance = travel_distance,
				fog_component = fog_component,
				dont_trigger_this_cloud = dont_trigger_this_cloud
			}

			table.insert(gas_clouds[section_id][id], entry)
		end
	end

	self._gas_clouds = table.clone_instance(gas_clouds)

	local gas_clouds_to_activate = {}

	for i = 1, num_sections do
		local max_section_id = #gas_clouds
		local random_section_id = self:_random(1, max_section_id)
		local section_entry = gas_clouds[random_section_id]
		local random_id = self:_random(1, #section_entry)
		local clouds = section_entry[random_id]

		for j = 1, #clouds do
			local cloud = clouds[j]
			local cloud_unit = cloud.fog_unit
			local max_liquid = cloud.max_liquid
			local id = cloud.id
			local section_id = cloud.section_id
			local trigger_clouds = cloud.trigger_clouds
			local fog_component = cloud.fog_component
			local dont_trigger_this_cloud = cloud.dont_trigger_this_cloud
			local position = Unit.local_position(cloud_unit, 1)
			local _, travel_distance = MainPathQueries.closest_position(position)
			local boxed_position = Vector3Box(position)

			gas_clouds_to_activate[#gas_clouds_to_activate + 1] = {
				cloud_unit = cloud_unit,
				travel_distance = travel_distance,
				position = boxed_position,
				max_liquid = max_liquid,
				fog_component = fog_component,
				id = id,
				section_id = section_id,
				trigger_clouds = trigger_clouds,
				dont_trigger_this_cloud = dont_trigger_this_cloud
			}
		end

		table.remove(gas_clouds, random_section_id)
	end

	self._num_sections = num_sections
	self._gas_clouds_to_activate = gas_clouds_to_activate
	self._active_gas_clouds = {}

	Managers.state.pacing:set_specials_timing_multiplier(SPECIALS_MULTIPLIER_TWINS_INACTIVE)
	Managers.state.pacing:set_specials_force_move_timer(false)
	Managers.state.pacing:set_ramp_up_enabled(false)
end

MutatorToxicGasTwins.destroy = function (self)
	Managers.event:unregister(self, "intro_cinematic_started")
	Managers.event:unregister(self, "players_teleported")
end

MutatorToxicGasTwins._event_intro_cinematic_started = function (self, cinematic_name)
	if not self._triggered_start_level_flow_event then
		Level.trigger_event(self._level, "toxic_gas_twins_server")

		self._triggered_start_level_flow_event = true
	end
end

MutatorToxicGasTwins._event_players_teleported = function (self)
	self._current_section_id = #TWIN_SPAWN_ORDER

	Managers.state.pacing:set_specials_timing_multiplier(0)
	Managers.state.pacing:set_specials_force_move_timer(false)
	Managers.state.pacing:set_travel_distance_spawning_override(false)
	Managers.state.pacing:pause_spawn_type("roamers", true, "teleported")
	table.clear(self._gas_clouds_to_activate)
end

MutatorToxicGasTwins._random = function (self, ...)
	local seed, value = math.next_random(self._seed, ...)

	self._seed = seed

	return value
end

local DISABLE_SPECIALS_DURATIONS = {
	17,
	31.4,
	27,
	24.3
}

MutatorToxicGasTwins._update_twins = function (self, dt, t, ahead_travel_distance)
	if self._force_disappear_t and not self._vo_started then
		self._force_disappear_t = self._force_disappear_t - dt

		if self._force_disappear_t <= 0 then
			for i = #self._spawned_twins, 1, -1 do
				local twin_unit = self._spawned_twins[i]

				self:_despawn_twin(twin_unit)
			end

			self._force_disappear_t = nil
		end
	end

	if not self._spawned_twins or #self._spawned_twins == 0 then
		if not self._boss_fight_started then
			Managers.state.pacing:set_specials_timing_multiplier(SPECIALS_MULTIPLIER_TWINS_INACTIVE)
			Managers.state.pacing:set_specials_force_move_timer(false)

			self._force_disappear_t = nil
		end

		local active_clouds = self._current_section_id and self._active_gas_clouds[self._current_section_id]

		if active_clouds then
			for i = 1, #active_clouds do
				self:_deactivate_cloud(active_clouds[i])
			end

			Level.trigger_event(self._level, "twins_despawned_" .. self._current_section_id)

			self._current_section_id = nil

			if DISABLE_SPECIALS_DURATIONS[self._current_section_id] then
				self._disable_specials_duration = t + DISABLE_SPECIALS_DURATIONS[self._current_section_id]

				Managers.state.pacing:set_specials_timing_multiplier(0)
				Managers.state.pacing:set_specials_force_move_timer(false)
				Managers.state.pacing:set_travel_distance_spawning_override(false)
			end

			for i = #self._spawn_liquids, 1, -1 do
				local liquid = self._spawn_liquids[i]

				Managers.state.unit_spawner:mark_for_deletion(liquid)

				self._spawn_liquids[i] = nil
			end
		end

		if self._objective_started then
			local mission_objective_system = Managers.state.extension:system("mission_objective_system")
			local objective_name = "objective_km_enforcer_twins_ambush"

			mission_objective_system:end_mission_objective(objective_name)

			self._objective_started = false
		end

		return
	end

	if not self._boss_fight_started then
		local despawn_distance = TWIN_DESPAWN_DISTANCES[self._current_section_id]

		for i = #self._spawned_twins, 1, -1 do
			local twin_unit = self._spawned_twins[i]

			if not HEALTH_ALIVE[twin_unit] then
				table.remove(self._spawned_twins, i)

				if TWIN_CLOUDS[twin_unit] then
					Managers.state.unit_spawner:mark_for_deletion(TWIN_CLOUDS[twin_unit])

					TWIN_CLOUDS[twin_unit] = nil
				end

				break
			end

			local health_extension = ScriptUnit.extension(twin_unit, "health_system")
			local current_health_percent = health_extension:current_health_percent()

			if current_health_percent < 0.25 or ahead_travel_distance and despawn_distance and despawn_distance <= ahead_travel_distance then
				self:_ready_to_escape(twin_unit)
			end
		end
	end

	if self._current_section_id == 4 and #self._spawned_twins == 0 then
		Vo.mission_giver_mission_info_vo("selected_voice", "interrogator_a", "mission_twins_exchange_03_a")
	end
end

local CLOUD_SPAWN_DISTANCE = 8
local CLOUD_DESPAWN_DISTANCE = 50
local CLOUD_ACTIVE_DELAY = 0

MutatorToxicGasTwins.update = function (self, dt, t)
	if not self._is_server then
		return
	end

	local is_main_path_available = Managers.state.main_path:is_main_path_available()

	if not is_main_path_available then
		return
	end

	local should_use = self._has_backend_pacing_control_flag

	if not should_use then
		return
	end

	local main_path_manager = Managers.state.main_path
	local _, ahead_travel_distance = main_path_manager:ahead_unit(TARGET_SIDE_ID)

	self:_update_twins(dt, t, ahead_travel_distance)

	if not ahead_travel_distance then
		return
	end

	if self._main_path_sound_events and #self._main_path_sound_events > 0 then
		local next_mainpath_event = self._main_path_sound_events[1]

		if ahead_travel_distance >= next_mainpath_event.distance then
			local optional_ambisonics = true

			self._fx_system:trigger_wwise_event(next_mainpath_event.event, nil, nil, nil, nil, nil, optional_ambisonics)
			table.remove(self._main_path_sound_events, 1)
		end
	end

	if self._boss_fight_started then
		self:_update_boss_fight(dt, t)

		local gas_clouds = self._boss_fight_clouds

		for i = 1, #gas_clouds do
			repeat
				local gas_cloud = gas_clouds[i]

				if gas_cloud.delay then
					self:_update_delayed_cloud(gas_cloud, dt)
				end
			until true
		end

		return
	end

	if self._disable_specials_duration and t >= self._disable_specials_duration then
		Managers.state.pacing:set_specials_timing_multiplier(SPECIALS_MULTIPLIER_TWINS_INACTIVE)
		Managers.state.pacing:set_specials_force_move_timer(false)
		Managers.state.pacing:set_travel_distance_spawning_override(true)

		self._disable_specials_duration = nil
	end

	for i = 1, #self._active_gas_clouds do
		local section = self._active_gas_clouds[i]

		for j = 1, #section do
			local cloud = section[j]

			if cloud.duration then
				cloud.duration = cloud.duration - dt

				if cloud.duration <= 0 then
					self:_deactivate_cloud(cloud)
				end
			end
		end
	end

	local _, behind_travel_distance = main_path_manager:behind_unit(TARGET_SIDE_ID)
	local gas_clouds = self._gas_clouds_to_activate

	for i = 1, #gas_clouds do
		repeat
			local gas_cloud = gas_clouds[i]

			if gas_cloud.delay then
				self:_update_delayed_cloud(gas_cloud, dt)
			end

			if not gas_cloud.trigger_clouds or gas_cloud.deactivated then
				break
			end

			local cloud_travel_distance = gas_cloud.travel_distance
			local ahead_travel_distance_diff = math.abs(ahead_travel_distance - cloud_travel_distance)
			local behind_travel_distance_diff = math.abs(behind_travel_distance - cloud_travel_distance)
			local is_between_ahead_and_behind = cloud_travel_distance < ahead_travel_distance and behind_travel_distance < cloud_travel_distance
			local is_active = gas_cloud.active
			local dist_check = is_active and CLOUD_DESPAWN_DISTANCE or CLOUD_SPAWN_DISTANCE
			local should_activate = is_between_ahead_and_behind or ahead_travel_distance_diff < dist_check or behind_travel_distance_diff < dist_check

			if should_activate and not is_active then
				self:_activate_cloud(gas_cloud, nil, CLOUD_ACTIVE_DELAY)
			end
		until true
	end
end

MutatorToxicGasTwins.start_boss_fight = function (self)
	self._boss_fight_started = true
	self._first_gas_phase_started = false

	Managers.stats:record_team("hook_mission_twins_boss_started_mine_intialized")
	Log.info("MutatorToxicGasTwins", "START BOSS FIGHT")

	self._boss_health = {}

	self:spawn_boss_fight_twins()

	local pacing_manager = Managers.state.pacing
	local spawn_types = {
		"hordes",
		"monsters",
		"trickle_hordes"
	}
	local enabled = false

	for i = 1, #spawn_types do
		local spawn_type = spawn_types[i]

		pacing_manager:pause_spawn_type(spawn_type, not enabled, "boss_fight")
	end

	self._boss_phase = 1
	self._current_section_id = #TWIN_SPAWN_ORDER
	self._boss_fight_clouds = {}

	if self:_has_hard_mode() then
		local terror_event_manager = Managers.state.terror_event

		terror_event_manager:start_event("hard_mode_terror_trickle")
	end
end

MutatorToxicGasTwins.spawn_boss_fight_twins = function (self)
	table.clear(self._spawned_twins)

	local minion_spawn_system = Managers.state.extension:system("minion_spawner_system")
	local spawner_1_position = minion_spawn_system:spawners_in_group("watertown_twins_end_twin_1")[1]:position()
	local spawner_2_position = minion_spawn_system:spawners_in_group("watertown_twins_end_twin_2")[1]:position()
	local spawner_1_rotation = minion_spawn_system:spawners_in_group("watertown_twins_end_twin_1")[1]:rotation()
	local spawner_2_rotation = minion_spawn_system:spawners_in_group("watertown_twins_end_twin_2")[1]:rotation()
	local main_path_manager = Managers.state.main_path
	local ahead_unit = main_path_manager:ahead_unit(TARGET_SIDE_ID)
	local id = TWIN_IDS.renegade_twin_captain
	local health_modifier = 1 - (self._boss_health[id] or 1)
	local param_table_twin_01 = Managers.state.minion_spawn:request_param_table()

	param_table_twin_01.optional_aggro_state = aggro_states.aggroed
	param_table_twin_01.optional_target_unit = ahead_unit

	local twin_unit = Managers.state.minion_spawn:spawn_minion("renegade_twin_captain", spawner_1_position, spawner_1_rotation, 2, param_table_twin_01)
	local reactivation_override = true
	local spawned_unit_health_extension = ScriptUnit.extension(twin_unit, "health_system")
	local spawned_unit_toughness_extension = ScriptUnit.extension(twin_unit, "toughness_system")

	spawned_unit_toughness_extension:set_toughness_damage(0, reactivation_override)

	local max_health = spawned_unit_health_extension:max_health()

	spawned_unit_health_extension:add_damage(max_health * health_modifier)

	self._spawned_twins[id] = twin_unit

	local id_2 = TWIN_IDS.renegade_twin_captain_two
	local health_modifier_2 = 1 - (self._boss_health[id_2] or 1)
	local param_table_twin_02 = Managers.state.minion_spawn:request_param_table()

	param_table_twin_02.optional_aggro_state = aggro_states.aggroed
	param_table_twin_02.optional_target_unit = ahead_unit

	local twin_unit_2 = Managers.state.minion_spawn:spawn_minion("renegade_twin_captain_two", spawner_2_position, spawner_2_rotation, 2, param_table_twin_02)
	local spawned_unit_health_extension_2 = ScriptUnit.extension(twin_unit_2, "health_system")
	local spawned_unit_toughness_extension_2 = ScriptUnit.extension(twin_unit_2, "toughness_system")

	spawned_unit_toughness_extension_2:set_toughness_damage(0, reactivation_override)

	local max_health_2 = spawned_unit_health_extension_2:max_health()

	spawned_unit_health_extension_2:add_damage(max_health_2 * health_modifier_2)

	self._spawned_twins[id_2] = twin_unit_2

	local blackboard = BLACKBOARDS[twin_unit]
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	behavior_component.other_twin_unit = twin_unit_2

	local move_to_position = spawner_1_position + Quaternion.forward(spawner_1_rotation) * 2
	local position_on_navmesh = NavQueries.position_on_mesh_with_outside_position(self._nav_world, nil, move_to_position, 1, 1, 1)

	if position_on_navmesh then
		behavior_component.move_to_position:store(position_on_navmesh)

		behavior_component.has_move_to_position = true
	end

	blackboard = BLACKBOARDS[twin_unit_2]
	behavior_component = Blackboard.write_component(blackboard, "behavior")
	behavior_component.other_twin_unit = twin_unit
	move_to_position = spawner_2_position + Quaternion.forward(spawner_2_rotation) * 2
	position_on_navmesh = NavQueries.position_on_mesh_with_outside_position(self._nav_world, nil, move_to_position, 1, 1, 1)

	if position_on_navmesh then
		behavior_component.move_to_position:store(position_on_navmesh)

		behavior_component.has_move_to_position = true
	end

	local pacing_manager = Managers.state.pacing
	local multiplier = self._boss_fight_started and SPECIALS_MULTIPLIER_TWINS_ACTIVE_BOSS_FIGHT or SPECIALS_MULTIPLIER_TWINS_ACTIVE

	pacing_manager:set_specials_timing_multiplier(multiplier)
	pacing_manager:set_specials_force_move_timer(true)

	if self:_has_hard_mode() then
		local t = Managers.time:time("gameplay")
		local buff_extension = ScriptUnit.extension(twin_unit, "buff_system")

		buff_extension:add_internally_controlled_buff("empowered_twin", t)

		local buff_extension_2 = ScriptUnit.extension(twin_unit_2, "buff_system")

		buff_extension_2:add_internally_controlled_buff("empowered_twin", t)
	end
end

local GAS_TERROR_EVENTS = {
	{
		{
			"km_enforcer_twins_gas_phase_west",
			"km_enforcer_twins_gas_phase_north",
			"km_enforcer_twins_gas_phase_middle"
		},
		{
			"km_enforcer_twins_gas_phase_east",
			"km_enforcer_twins_gas_phase_north",
			"km_enforcer_twins_gas_phase_middle"
		}
	},
	{
		{
			"km_enforcer_twins_gas_phase_2_west",
			"km_enforcer_twins_gas_phase_2_north",
			"km_enforcer_twins_gas_phase_2_middle"
		},
		{
			"km_enforcer_twins_gas_phase_2_east",
			"km_enforcer_twins_gas_phase_2_north",
			"km_enforcer_twins_gas_phase_2_middle"
		}
	},
	{
		{
			"km_enforcer_twins_gas_phase_3_west",
			"km_enforcer_twins_gas_phase_3_north",
			"km_enforcer_twins_gas_phase_3_middle"
		},
		{
			"km_enforcer_twins_gas_phase_3_east",
			"km_enforcer_twins_gas_phase_3_north",
			"km_enforcer_twins_gas_phase_3_middle"
		}
	}
}
local FIGHT_TERROR_EVENTS = {
	"km_enforcer_twins_elite_trickle_1",
	"km_enforcer_twins_elite_trickle_2",
	"km_enforcer_twins_elite_trickle_3"
}
local LAST_PHASTE_TERROR_EVENTS = {
	"km_enforcer_twins_last_phase_trickle"
}
local GAS_EVENT_DURATION = {
	30,
	40,
	50
}
local GAS_ALARM_DURATION = 5

MutatorToxicGasTwins._update_boss_fight = function (self, dt, t)
	for i = #self._spawned_twins, 1, -1 do
		local twin_unit = self._spawned_twins[i]

		if not HEALTH_ALIVE[twin_unit] then
			table.remove(self._spawned_twins, i)

			break
		end

		local id = TWIN_IDS[ScriptUnit.extension(twin_unit, "unit_data_system"):breed().name]
		local health_extension = ScriptUnit.extension(twin_unit, "health_system")
		local current_health_percent = health_extension:current_health_percent()

		self._boss_health[id] = current_health_percent
	end

	if self._gas_phase then
		self:_update_gas_phase(dt, t)
	end

	local phase = self._boss_phase

	if phase == 1 then
		local health_threshold = 0.8
		local gas_index = 1

		self:_update_boss_fight_twins_alive(dt, t, health_threshold, gas_index)
	elseif phase == 2 then
		if self._phase_duration then
			self._phase_duration = self._phase_duration - dt

			if self._phase_duration <= 0 then
				self._boss_phase = self._boss_phase + 1

				self:_stop_gas_phase()
				self:spawn_boss_fight_twins()

				local terror_event_manager = Managers.state.terror_event
				local random_trickle_terror_event = FIGHT_TERROR_EVENTS[math.random(1, #FIGHT_TERROR_EVENTS)]

				terror_event_manager:start_event(random_trickle_terror_event)
			end
		end
	elseif phase == 3 then
		local health_threshold = 0.5
		local gas_index = 2

		self:_update_boss_fight_twins_alive(dt, t, health_threshold, gas_index)
	elseif phase == 4 then
		if self._phase_duration then
			self._phase_duration = self._phase_duration - dt

			if self._phase_duration <= 0 then
				self._boss_phase = self._boss_phase + 1

				self:_stop_gas_phase()
				self:spawn_boss_fight_twins()

				local terror_event_manager = Managers.state.terror_event
				local random_trickle_terror_event = FIGHT_TERROR_EVENTS[math.random(1, #FIGHT_TERROR_EVENTS)]

				terror_event_manager:start_event(random_trickle_terror_event)
			end
		end
	elseif phase == 5 then
		local health_threshold = 0.2
		local gas_index = 3

		self:_update_boss_fight_twins_alive(dt, t, health_threshold, gas_index)
	elseif phase == 6 then
		if self._phase_duration then
			self._phase_duration = self._phase_duration - dt

			if self._phase_duration <= 0 then
				self._boss_phase = self._boss_phase + 1

				self:_stop_gas_phase()
				self:spawn_boss_fight_twins()

				local terror_event_manager = Managers.state.terror_event
				local random_trickle_terror_event = LAST_PHASTE_TERROR_EVENTS[math.random(1, #LAST_PHASTE_TERROR_EVENTS)]

				terror_event_manager:start_event(random_trickle_terror_event)
			end
		end
	elseif phase == 7 then
		if not self._first_dead then
			if #self._spawned_twins < 2 then
				local twin_unit = self._spawned_twins[1]

				if ALIVE[twin_unit] then
					local breed_name = ScriptUnit.extension(twin_unit, "unit_data_system"):breed().name

					Vo.stop_currently_playing_vo(twin_unit)
					Vo.enemy_generic_vo_event(twin_unit, "twin_dead", breed_name)

					self._first_dead = true

					local buff_extension = ScriptUnit.has_extension(twin_unit, "buff_system")

					if buff_extension and not buff_extension:has_keyword("empowered") then
						buff_extension:add_internally_controlled_buff("empowered_twin", t)
					end
				end
			end
		elseif not self._both_dead and #self._spawned_twins == 0 then
			self:_trigger_level_event("twins_dead")

			self._both_dead = true
		end
	end
end

MutatorToxicGasTwins._update_boss_fight_twins_alive = function (self, dt, t, health_threshold, gas_index)
	if self._alarm_duration then
		if t >= self._alarm_duration then
			local gas_phase_index = gas_index

			self:_start_gas_phase(gas_phase_index)

			self._boss_phase = self._boss_phase + 1
			self._phase_duration = GAS_EVENT_DURATION[gas_phase_index]
			self._alarm_duration = nil
		end
	else
		for i = 1, #self._boss_health do
			local health = self._boss_health[i]

			if health < health_threshold then
				self:_despawn_twins()

				self._alarm_duration = t + GAS_ALARM_DURATION

				self:_trigger_level_event("twins_gas_alarm")
			end
		end
	end
end

local ALTERNATING_GAS_BY_CHALLENGE = {
	false,
	false,
	true,
	true,
	true
}
local FIRST_ALTERNATING_GAS_DURATION_RANGES = {
	{
		600,
		600
	},
	{
		600,
		600
	},
	{
		600,
		600
	},
	{
		35,
		40
	},
	{
		20,
		25
	}
}
local ALTERNATING_GAS_DURATION_RANGES = {
	{
		40,
		45
	},
	{
		40,
		45
	},
	{
		18,
		25
	},
	{
		16,
		24
	},
	{
		15,
		22
	}
}
local HARD_MODE_GAS_DURATION_RANGES = {
	{
		20,
		30
	},
	{
		20,
		30
	},
	{
		15,
		20
	},
	{
		14,
		20
	},
	{
		14,
		18
	}
}
local GAS_PHASE_BUILDUP_DELAY = 7
local FIRST_GAS_PHASE_BUILDUP_DELAY = 12

MutatorToxicGasTwins._start_gas_phase = function (self, gas_phase_index)
	local section_id = self._current_section_id
	local random_id = math.random(1, 2)
	local section_clouds = self._gas_clouds[section_id]
	local gas_clouds = section_clouds[random_id]

	self:_spawn_gas_phase_gas(random_id)
	Log.info("MutatorToxicGasTwins", "Started gas with section_id %d and id %d ", section_id, random_id)
	self:_trigger_level_event("twins_boss_fight_gas_" .. random_id)

	local terror_event = GAS_TERROR_EVENTS[gas_phase_index][random_id][math.random(1, #GAS_TERROR_EVENTS[gas_phase_index][random_id])]
	local terror_event_manager = Managers.state.terror_event

	terror_event_manager:start_event(terror_event)
	Managers.state.pacing:set_specials_timing_multiplier(SPECIALS_MULTIPLIER_GAS_PHASE)

	self._current_random_id = random_id
	self._gas_phase = true
	self._alternating_gas = Managers.state.difficulty:get_table_entry_by_challenge(ALTERNATING_GAS_BY_CHALLENGE)

	local has_hard_mode = self:_has_hard_mode()

	if self._alternating_gas then
		local t = Managers.time:time("gameplay")
		local random_gas_alternation_range

		if not self._first_gas_phase_started then
			random_gas_alternation_range = Managers.state.difficulty:get_table_entry_by_challenge(has_hard_mode and HARD_MODE_GAS_DURATION_RANGES or FIRST_ALTERNATING_GAS_DURATION_RANGES)
			self._first_gas_phase_started = true
		else
			random_gas_alternation_range = Managers.state.difficulty:get_table_entry_by_challenge(has_hard_mode and HARD_MODE_GAS_DURATION_RANGES or ALTERNATING_GAS_DURATION_RANGES)
		end

		self._alternate_gas_at_t = t + math.random_range(random_gas_alternation_range[1], random_gas_alternation_range[2])
	end

	Log.info("MutatorToxicGasTwins", "Triggered " .. terror_event .. " terror event")
end

MutatorToxicGasTwins._spawn_gas_phase_gas = function (self, gas_id)
	local section_id = self._current_section_id
	local section_clouds = self._gas_clouds[section_id]
	local gas_clouds = section_clouds[gas_id]
	local delay = not self._first_gas_phase_started and FIRST_GAS_PHASE_BUILDUP_DELAY or GAS_PHASE_BUILDUP_DELAY

	for i = 1, #gas_clouds do
		local cloud = gas_clouds[i]

		if cloud.section_id == section_id and cloud.id == gas_id then
			self:_spawn_volume_and_liquid(cloud, delay)

			self._boss_fight_clouds[#self._boss_fight_clouds + 1] = cloud
		end
	end

	self._gas_ambisonics_delay = delay
	self._gas_vo_delay = delay - 2
end

local ALTERNATING_GAS_ALARM_TIMING = 4
local ALTERNATING_GAS_ALARM_TIMING_HARD = 2.5

MutatorToxicGasTwins._update_gas_phase = function (self, dt, t)
	if self._gas_ambisonics_delay then
		self._gas_ambisonics_delay = self._gas_ambisonics_delay - dt

		if self._gas_ambisonics_delay <= 0 then
			local optional_ambisonics = true

			self._fx_system:trigger_wwise_event(gas_wave_ambisonics, nil, nil, nil, nil, nil, optional_ambisonics)

			self._gas_ambisonics_delay = nil
		end
	end

	if self._gas_vo_delay then
		self._gas_vo_delay = self._gas_vo_delay - dt

		if self._gas_vo_delay <= 0 then
			self:_trigger_level_event("twins_gas_vo")

			self._gas_vo_delay = nil
		end
	end

	if not self._alternating_gas then
		return
	end

	local has_hard_mode = self:_has_hard_mode()
	local timing = has_hard_mode and ALTERNATING_GAS_ALARM_TIMING_HARD or ALTERNATING_GAS_ALARM_TIMING

	if t >= self._alternate_gas_at_t - timing and not self._triggered_alternating_gas_alarm then
		self:_trigger_level_event("twins_gas_alarm")

		self._triggered_alternating_gas_alarm = true
	end

	if t >= self._alternate_gas_at_t then
		local current_gas_phase_id = self._current_random_id
		local random_gas_alternation_range = Managers.state.difficulty:get_table_entry_by_challenge(has_hard_mode and HARD_MODE_GAS_DURATION_RANGES or ALTERNATING_GAS_DURATION_RANGES)

		self._alternate_gas_at_t = t + math.random_range(random_gas_alternation_range[1], random_gas_alternation_range[2])

		self:_remove_gas_phase_gas()
		self:_trigger_level_event("stop_twins_boss_fight_gas_" .. current_gas_phase_id)

		local new_gas_id = current_gas_phase_id == 1 and 2 or 1

		self:_spawn_gas_phase_gas(new_gas_id)

		self._current_random_id = new_gas_id

		self:_trigger_level_event("twins_boss_fight_gas_" .. new_gas_id)

		self._triggered_alternating_gas_alarm = nil

		self:_trigger_level_event("stop_twins_gas_alarm")
	end
end

MutatorToxicGasTwins._remove_gas_phase_gas = function (self)
	for i = #self._boss_fight_clouds, 1, -1 do
		local cloud = self._boss_fight_clouds[i]

		self:_deactivate_cloud(cloud)
		table.remove(self._boss_fight_clouds, i)
	end
end

MutatorToxicGasTwins._stop_gas_phase = function (self)
	self:_remove_gas_phase_gas()

	self._gas_phase = false

	Managers.state.pacing:set_specials_timing_multiplier(SPECIALS_MULTIPLIER_TWINS_ACTIVE)

	if self._current_random_id then
		self:_trigger_level_event("stop_twins_boss_fight_gas_" .. self._current_random_id)
	end
end

MutatorToxicGasTwins._trigger_level_event = function (self, event_name)
	Level.trigger_event(self._level, event_name)
	Log.info("MutatorToxicGasTwins", "Triggered " .. event_name .. " flow level event")
end

local FORCE_DISAPPEAR_DURATION = 15
local DISAPPEAR_INDICES = {
	1,
	1,
	2,
	2
}

MutatorToxicGasTwins._ready_to_escape = function (self, unit)
	local blackboard = BLACKBOARDS[unit]
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	local should_disappear = behavior_component.should_disappear or behavior_component.should_disappear_instant

	if should_disappear then
		return true
	end

	local dialogue_extension = ScriptUnit.extension(unit, "dialogue_system")
	local is_vo_playing = dialogue_extension:is_currently_playing_dialogue()
	local health_extension = ScriptUnit.has_extension(unit, "health_system")
	local is_invulnerable = health_extension:is_invulnerable()

	if is_vo_playing and is_invulnerable and self._force_disappear_t then
		self._vo_started = true

		return false
	elseif is_invulnerable and self._vo_started then
		self._vo_started = false

		return true
	end

	if self._current_section_id == 4 then
		local breed_name = ScriptUnit.extension(unit, "unit_data_system"):breed().name

		if breed_name == "renegade_twin_captain_two" then
			behavior_component.should_disappear = true

			return true
		end
	end

	if not self._force_disappear_t then
		health_extension:set_invulnerable(true)

		if not is_vo_playing then
			local reactivation_override = true
			local toughness_extension = ScriptUnit.has_extension(unit, "toughness_system")

			toughness_extension:set_toughness_damage(toughness_extension:max_toughness() * 0.125, reactivation_override)
			toughness_extension:set_invulnerable(true)
			toughness_extension:set_override_regen_speed(nil)

			local spawn_component = blackboard.spawn
			local game_session, game_object_id = spawn_component.game_session, spawn_component.game_object_id

			GameSession.set_game_object_field(game_session, game_object_id, "is_toughness_invulnerable", true)

			self._force_disappear_t = FORCE_DISAPPEAR_DURATION
			behavior_component.disappear_idle = true

			local disappear_index = DISAPPEAR_INDICES[self._current_section_id]

			if disappear_index then
				behavior_component.disappear_index = disappear_index
			end
		end
	end

	return false
end

MutatorToxicGasTwins._spawn_horde = function (self, horde_type, horde_template, composition)
	local horde_manager = Managers.state.horde
	local towards_combat_vector = true

	composition = Managers.state.difficulty:get_table_entry_by_challenge(composition)

	local success, horde_position, target_unit, group_id = horde_manager:horde(horde_type, horde_template.name, 2, 1, composition, towards_combat_vector)

	return success, horde_position, target_unit, group_id
end

local HARD_MODE_AVAILABLE = {
	false,
	false,
	false,
	false,
	true
}

MutatorToxicGasTwins._has_hard_mode = function (self)
	local correct_difficulty = Managers.state.difficulty:get_table_entry_by_challenge(HARD_MODE_AVAILABLE)

	if not correct_difficulty then
		return false
	end

	return Managers.state.pacing:has_hard_mode()
end

return MutatorToxicGasTwins
