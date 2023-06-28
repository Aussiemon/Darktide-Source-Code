require("scripts/managers/mutator/mutators/mutator_base")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breeds = require("scripts/settings/breed/breeds")
local Component = require("scripts/utilities/component")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local NavQueries = require("scripts/utilities/nav_queries")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local aggro_states = PerceptionSettings.aggro_states
local MutatorToxicGasTwins = class("MutatorToxicGasTwins", "MutatorBase")

MutatorToxicGasTwins.init = function (self, is_server, network_event_delegate, mutator_template, nav_world, level_seed)
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate
	self._is_active = true
	self._buffs = {}
	self._template = mutator_template
	self._gas_clouds = {}
	self._nav_world = nav_world
	self._buff_affected_units = {}
	self._seed = level_seed
	self._twin_spawn_data = {}
	self._spawned_twins = {}
	self._appear_explosion_template = ExplosionTemplates.twin_disappear_explosion
end

MutatorToxicGasTwins._activate_cloud = function (self, cloud, is_other_cloud)
	if cloud.active then
		return
	end

	local section_id = cloud.section_id
	self._current_section_id = section_id
	local liquid_area_template = LiquidAreaTemplates.toxic_gas
	local max_liquid = cloud.max_liquid
	local unit = LiquidArea.try_create(cloud.position:unbox(), Vector3(0, 0, 1), self._nav_world, liquid_area_template, nil, max_liquid)
	cloud.active = true
	cloud.liquid_unit = unit

	cloud.fog_component:set_volume_enabled(true)

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
				self:_activate_cloud(other_cloud, true)
			end
		end
	end
end

MutatorToxicGasTwins._deactivate_cloud = function (self, cloud)
	if ALIVE[cloud.liquid_unit] then
		Managers.state.unit_spawner:mark_for_deletion(cloud.liquid_unit)
	end

	cloud.active = false
	cloud.liquid_unit = nil

	cloud.fog_component:set_volume_enabled(false)

	cloud.deactivated = true
end

local TARGET_SIDE_ID = 1
local TWIN_TRAVERSAL_SPAWN_HEALTH_MODIFIER = 0.25

MutatorToxicGasTwins._spawn_twins = function (self, twin_spawn_data, section_id)
	local is_last_spawn = false

	if section_id == self._num_sections then
		is_last_spawn = true
	end

	local main_path_manager = Managers.state.main_path
	local ahead_unit = main_path_manager:ahead_unit(TARGET_SIDE_ID)

	for twin_id = 1, 2 do
		local breed_name = twin_id == 1 and "renegade_twin_captain" or "renegade_twin_captain_two"
		local data = twin_spawn_data[twin_id]

		if not data.has_spawned then
			local twin_spawn_position = data.spawn_position:unbox()
			local twin_unit = Managers.state.minion_spawn:spawn_minion(breed_name, twin_spawn_position, Quaternion.identity(), 2, aggro_states.aggroed, ahead_unit, nil, nil, nil, nil, not is_last_spawn and TWIN_TRAVERSAL_SPAWN_HEALTH_MODIFIER)
			local buff_extension = ScriptUnit.extension(twin_unit, "buff_system")
			local t = Managers.time:time("gameplay")

			buff_extension:add_internally_controlled_buff("mutator_stimmed_minion_yellow", t)

			data.has_spawned = true
			data.spawned_twin_unit = twin_unit
			self._is_last_spawn = is_last_spawn
			self._spawned_twins[#self._spawned_twins + 1] = twin_unit
			local position = POSITION_LOOKUP[twin_unit]
			local blackboard = BLACKBOARDS[twin_unit]
			local spawn_component = blackboard.spawn
			local world = spawn_component.world
			local physics_world = spawn_component.physics_world
			local impact_normal = Vector3.up()
			local charge_level = 1
			local attack_type = nil
			local power_level = 5
			local explosion_template = self._appear_explosion_template

			Explosion.create_explosion(world, physics_world, position, impact_normal, twin_unit, explosion_template, power_level, charge_level, attack_type)
		end
	end

	Managers.state.pacing:set_specials_timing_multiplier(10)
	Managers.state.pacing:set_specials_force_move_timer(true)
end

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

	Managers.state.pacing:set_specials_timing_multiplier(1)
	Managers.state.pacing:set_specials_force_move_timer(false)
end

MutatorToxicGasTwins.on_gameplay_post_init = function (self, level, themes)
	Level.trigger_event(level, "toxic_gas_twins")

	local gas_clouds = self._gas_clouds
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
					spawn_position = Vector3Box(position_on_navmesh)
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

			if not gas_clouds[section_id] then
				gas_clouds[section_id] = {}
			end

			if not gas_clouds[section_id][id] then
				gas_clouds[section_id][id] = {}
			end

			if num_sections < section_id then
				num_sections = section_id
			end

			local entry = {
				fog_unit = fog_unit,
				max_liquid = max_liquid,
				id = id,
				section_id = section_id,
				trigger_clouds = trigger_clouds
			}

			table.insert(gas_clouds[section_id][id], entry)
		end
	end

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
			local fog_components = Component.get_components_by_name(cloud_unit, "ToxicGasFog")
			local wanted_fog_component = nil

			for _, fog_component in ipairs(fog_components) do
				wanted_fog_component = fog_component
			end

			local position = Unit.local_position(cloud_unit, 1)
			local _, travel_distance = MainPathQueries.closest_position(position)
			local boxed_position = Vector3Box(position)
			gas_clouds_to_activate[#gas_clouds_to_activate + 1] = {
				cloud_unit = cloud_unit,
				travel_distance = travel_distance,
				position = boxed_position,
				max_liquid = max_liquid,
				fog_component = wanted_fog_component,
				id = id,
				section_id = section_id,
				trigger_clouds = trigger_clouds
			}
		end

		table.remove(gas_clouds, random_section_id)
	end

	self._num_sections = num_sections
	self._gas_clouds_to_activate = gas_clouds_to_activate
	self._active_gas_clouds = {}
end

MutatorToxicGasTwins._random = function (self, ...)
	local seed, value = math.next_random(self._seed, ...)
	self._seed = seed

	return value
end

MutatorToxicGasTwins._update_twins = function (self)
	if not self._spawned_twins or #self._spawned_twins == 0 then
		Managers.state.pacing:set_specials_timing_multiplier(1)
		Managers.state.pacing:set_specials_force_move_timer(false)

		local active_clouds = self._current_section_id and self._active_gas_clouds[self._current_section_id]

		if active_clouds then
			for i = 1, #active_clouds do
				self:_deactivate_cloud(active_clouds[i])
			end

			self._current_section_id = nil
		end

		return
	end

	if not self._is_last_spawn then
		for i = #self._spawned_twins, 1, -1 do
			local twin_unit = self._spawned_twins[i]

			if not HEALTH_ALIVE[twin_unit] then
				table.remove(self._spawned_twins, i)

				break
			end

			local health_extension = ScriptUnit.extension(twin_unit, "health_system")

			if health_extension:current_health_percent() < 0.15 then
				self:_despawn_twin(twin_unit)
			end
		end
	end
end

local CLOUD_SPAWN_DISTANCE = 5
local CLOUD_DESPAWN_DISTANCE = 50

MutatorToxicGasTwins.update = function (self, dt, t)
	if not self._is_server then
		return
	end

	local is_main_path_available = Managers.state.main_path:is_main_path_available()

	if not is_main_path_available then
		return
	end

	local main_path_manager = Managers.state.main_path
	local _, ahead_travel_distance = main_path_manager:ahead_unit(TARGET_SIDE_ID)

	if not ahead_travel_distance then
		return
	end

	local _, behind_travel_distance = main_path_manager:behind_unit(TARGET_SIDE_ID)
	local gas_clouds = self._gas_clouds_to_activate

	for i = 1, #gas_clouds do
		repeat
			local gas_cloud = gas_clouds[i]

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
				self:_activate_cloud(gas_cloud)
			end
		until true
	end

	self:_update_twins()

	if self._current_section_id then
		Debug:text("CURRENT GAS SECTION " .. self._current_section_id)
	end
end

return MutatorToxicGasTwins
