-- chunkname: @scripts/managers/mutator/mutators/mutator_monster_spawner.lua

require("scripts/managers/mutator/mutators/mutator_base")

local NavQueries = require("scripts/utilities/nav_queries")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local LoadedDice = require("scripts/utilities/loaded_dice")
local MutatorMonsterSpawnerSettings = require("scripts/settings/mutator/mutator_monster_spawner_settings")
local MonsterInjectionTemplates = require("scripts/settings/mutator/mutator_monster_spawner_injection/mutator_monster_spawner_injection_templates")
local SpawnPointQueries = require("scripts/managers/main_path/utilities/spawn_point_queries")
local perception_aggro_states = PerceptionSettings.aggro_states
local MutatorMonsterSpawner = class("MutatorMonsterSpawner", "MutatorBase")
local NAV_MESH_ABOVE, NAV_MESH_BELOW = 5, 5
local AGGRO_STATES = {
	chaos_plague_ogryn = "aggroed",
	chaos_spawn = "aggroed",
	chaos_beast_of_nurgle = "aggroed"
}
local _calculate_positions
local TARGET_SIDE_ID = 1

MutatorMonsterSpawner.init = function (self, is_server, network_event_delegate, mutator_template, nav_world)
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate
	self._is_active = true
	self._buffs = {}
	self._template = mutator_template
	self._nav_world = nav_world

	local asset_package = self._template.spawner_template.asset_package

	if asset_package then
		local package_manager = Managers.package

		self._package_id = package_manager:load(asset_package, "MutatorMonsterSpawner", nil, nil)
	end

	if not self._is_server then
		return
	end

	local mission_name = Managers.state.mission:mission_name()
	local spawn_locations = self._template.spawner_template.spawn_locations or "default_locations"

	self._dirty_spawn_locations = MutatorMonsterSpawnerSettings[spawn_locations][mission_name]
	self._template_data = self._template.spawner_template
	self._injection_template = MonsterInjectionTemplates[self._template.spawner_template.injection_template]
	self._spawn_point_sections = {}
	self._monsters = {}
	self._valid_spawn_points = 0
	self._allowed_per_section = {}
	self._section_probabillity = {}
	self._num_to_spawn = self._template_data.num_to_spawn or self._template_data.num_to_spawn_per_mission[mission_name]
end

MutatorMonsterSpawner.destroy = function (self)
	MutatorMonsterSpawner.super.destroy()

	local package_id = self._package_id

	if package_id then
		local package_manager = Managers.package

		package_manager:release(package_id, "MutatorMonsterSpawner")
	end
end

MutatorMonsterSpawner.on_spawn_points_generated = function (self, level, themes)
	local trigger_distance = self._template_data.trigger_distance
	local spawn_locations = self._dirty_spawn_locations
	local nav_world = self._nav_world

	for i = 1, #spawn_locations do
		local dirty_spawn_data = spawn_locations[i]
		local nav_mesh_position = NavQueries.position_on_mesh(nav_world, dirty_spawn_data.position:unbox(), NAV_MESH_ABOVE, NAV_MESH_BELOW)

		if nav_mesh_position then
			local main_path_manager = Managers.state.main_path
			local nav_spawn_points = main_path_manager:nav_spawn_points()
			local spawn_point_group_index = SpawnPointQueries.group_from_position(nav_world, nav_spawn_points, nav_mesh_position)
			local start_index = Managers.state.main_path:node_index_by_nav_group_index(spawn_point_group_index)
			local end_index = start_index + 1
			local position, _, travel_distance = _calculate_positions(nav_mesh_position, start_index, end_index)
			local wanted_distance = travel_distance - trigger_distance
			local spawn_point = {
				position = Vector3Box(position),
				spawn_travel_distance = wanted_distance,
				spawn_point_travel_distance = travel_distance
			}
			local section = dirty_spawn_data.section
			local spawn_point_sections = self._spawn_point_sections
			local spawn_point_section = spawn_point_sections[section]

			if spawn_point_section then
				spawn_point_section[#spawn_point_section + 1] = spawn_point
				self._allowed_per_section[section] = self._allowed_per_section[section] + 1
			else
				spawn_point_sections[section] = {
					spawn_point
				}
				self._section_probabillity[section] = 0
				self._allowed_per_section[section] = 1
			end

			self._valid_spawn_points = self._valid_spawn_points + 1
		end
	end

	if self._num_to_spawn > self._valid_spawn_points then
		Log.warning("[MutatorMonsterSpawner]", "Requested %s spawns but we only have %s possible spawn points. Clamped.", self._num_to_spawn, self._valid_spawn_points)

		self._num_to_spawn = self._valid_spawn_points
	end

	self:_calculate_probabillity(nil, nil)
	self:_add_clean_spawn()
end

MutatorMonsterSpawner.update = function (self, dt, t)
	if not self._is_server then
		return
	end

	local ahead_target_unit, ahead_travel_distance = Managers.state.main_path:ahead_unit(TARGET_SIDE_ID)

	if not ahead_target_unit then
		return
	end

	local monsters = self._monsters
	local num_monsters = #monsters

	for i = 1, num_monsters do
		local monster = monsters[i]
		local spawn_travel_distance = monster.travel_distance

		if spawn_travel_distance <= ahead_travel_distance then
			if self._injection_template then
				self._injection_template.spawn(self._template_data, monster, ahead_target_unit, 2)
				table.remove(monsters, i)

				break
			else
				self:_spawn_monster(monster, ahead_target_unit, 2)
				table.remove(monsters, i)

				break
			end
		end
	end
end

function _calculate_positions(position_on_mesh, start_index, end_index)
	local path_position, travel_distance = MainPathQueries.closest_position_between_nodes(position_on_mesh, start_index, end_index)

	return position_on_mesh, path_position, travel_distance
end

MutatorMonsterSpawner._calculate_probabillity = function (self, optional_probabillity_reroll, remove_chance)
	if not self._chance_initialized then
		self._chance_initialized = true

		local weights = self._section_probabillity
		local num = 0
		local initial_chance = 1

		for i = 1, #weights do
			num = num + 1
		end

		initial_chance = initial_chance / num

		for ii = 1, #weights do
			weights[ii] = math.floor(initial_chance * 100) / 100
		end

		local prob, alias = LoadedDice.create(weights, false)

		self._section_probabillity = {
			probability = prob,
			alias = alias
		}
	else
		local weights = self._section_probabillity
		local add_to_other_probabillites
		local current_value = weights.probability[optional_probabillity_reroll]

		current_value = current_value / 2

		if remove_chance then
			add_to_other_probabillites = current_value
			current_value = 0
		else
			add_to_other_probabillites = current_value / 2
		end

		for i = 1, #weights.probability do
			if i == optional_probabillity_reroll then
				weights.probability[i] = current_value
			elseif self._allowed_per_section[i] == 0 then
				add_to_other_probabillites = add_to_other_probabillites + add_to_other_probabillites
			else
				weights.probability[i] = weights.probability[i] + add_to_other_probabillites
			end
		end

		local prob, alias = LoadedDice.create(weights.probability, false)

		self._section_probabillity = {
			probability = prob,
			alias = alias
		}
	end
end

MutatorMonsterSpawner._add_clean_spawn = function (self)
	local monsters = {}
	local spawn_point_sections = self._spawn_point_sections
	local num_to_spawn = self._num_to_spawn

	for i = 1, num_to_spawn do
		local weights = self._section_probabillity
		local temp_section_index = LoadedDice.roll(weights.probability, weights.alias)
		local section = spawn_point_sections[temp_section_index]
		local spawn_point_index = math.random(#section)
		local spawn_point = section[spawn_point_index]
		local travel_distance = spawn_point.spawn_travel_distance
		local possible_breed_names = self._template_data.monster_breed_name
		local breed_name = possible_breed_names[math.random(#possible_breed_names)]
		local position = spawn_point.position
		local section_index = temp_section_index
		local monster = {
			travel_distance = travel_distance,
			breed_name = breed_name,
			position = position,
			section = section_index
		}

		monsters[#monsters + 1] = monster
		self._allowed_per_section[temp_section_index] = self._allowed_per_section[temp_section_index] - 1

		if self._allowed_per_section[temp_section_index] == 0 then
			self:_calculate_probabillity(temp_section_index, true)
		else
			self:_calculate_probabillity(temp_section_index, false)
		end

		table.swap_delete(section, spawn_point_index)
	end

	self._monsters = monsters
	self._alive_monsters = {}
end

MutatorMonsterSpawner._spawn_monster = function (self, monster, ahead_target_unit, side_id)
	local breed_name = monster.breed_name
	local spawn_position = monster.position:unbox()
	local aggro_states = AGGRO_STATES
	local aggro_state = aggro_states[breed_name]
	local spawned_unit
	local spawn_max_health_modifier = self._health_modifier
	local minion_spawn_manager = Managers.state.minion_spawn
	local param_table = minion_spawn_manager:request_param_table()

	if aggro_state then
		param_table.optional_aggro_state = aggro_state
		param_table.optional_target_unit = ahead_target_unit
		param_table.optional_health_modifier = spawn_max_health_modifier
		spawned_unit = minion_spawn_manager:spawn_minion(breed_name, spawn_position, Quaternion.identity(), side_id, param_table)

		if aggro_state == perception_aggro_states.aggroed then
			self._aggroed_monster_units[#self._aggroed_monster_units + 1] = spawned_unit
		end
	else
		param_table.optional_health_modifier = spawn_max_health_modifier
		spawned_unit = minion_spawn_manager:spawn_minion(breed_name, spawn_position, Quaternion.identity(), side_id, param_table)
	end

	local force_horde_on_spawn = self._template_data.force_horde_on_spawn

	if force_horde_on_spawn then
		Managers.state.pacing:force_horde_pacing_spawn()
	end

	Log.info("MonsterPacing", "Spawned monster %s successfully.", breed_name)

	monster.spawned_unit = spawned_unit
	self._alive_monsters[#self._alive_monsters + 1] = monster
end

return MutatorMonsterSpawner
