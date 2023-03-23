local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local MinionPatrols = require("scripts/utilities/minion_patrols")
local MonsterSettings = require("scripts/settings/monster/monster_settings")
local NavQueries = require("scripts/utilities/nav_queries")
local Navigation = require("scripts/extension_systems/navigation/utilities/navigation")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local perception_aggro_states = PerceptionSettings.aggro_states
local MonsterPacing = class("MonsterPacing")

MonsterPacing.init = function (self, nav_world)
	self._nav_world = nav_world
	local spawn_types = MonsterSettings.spawn_types
	local max_sections = MonsterSettings.max_sections
	local num_spawn_types = #spawn_types
	local spawn_point_sections = Script.new_map(num_spawn_types)
	local num_spawn_type_sections = Script.new_map(num_spawn_types)

	for i = 1, num_spawn_types do
		local spawn_type = spawn_types[i]
		spawn_point_sections[spawn_type] = Script.new_array(max_sections)
		num_spawn_type_sections[spawn_type] = 0
	end

	self._num_spawn_type_sections = num_spawn_type_sections
	self._spawn_type_point_sections = spawn_point_sections
end

MonsterPacing.destroy = function (self)
	return
end

MonsterPacing.on_gameplay_post_init = function (self, level, template)
	self._template = template
	local success = self:_generate_spawns(template)

	if not success then
		self._disabled = true
	end
end

local function _sort_spawners(spawner_1, spawner_2)
	return spawner_1.spawn_travel_distance < spawner_2.spawn_travel_distance
end

local TEMP_SECTIONS = {}

MonsterPacing._generate_spawns = function (self, template)
	local main_path_available = Managers.state.main_path:is_main_path_available()

	if not main_path_available then
		return false
	end

	local spawn_type_point_sections = self._spawn_type_point_sections
	local num_spawn_type_sections = self._num_spawn_type_sections
	local _, num_sections = next(num_spawn_type_sections)
	local valid_spawn_types = table.clone(MonsterSettings.used_spawn_types)

	for spawn_type, spawn_point_sections in pairs(spawn_type_point_sections) do
		local current_num_sections = num_spawn_type_sections[spawn_type]

		if current_num_sections == 0 then
			local index = table.find(valid_spawn_types, spawn_type)

			table.remove(valid_spawn_types, index)
			Log.warning("MonsterPacing", "Removed %s monster spawn type since found no spawners.", spawn_type)
		else
			for i = 1, current_num_sections do
			end
		end

		for i = 1, #spawn_point_sections do
			local sections = spawn_point_sections[i]

			table.sort(sections, _sort_spawners)
		end
	end

	local num_valid_spawn_types = #valid_spawn_types

	if num_valid_spawn_types == 0 then
		Log.warning("MonsterPacing", "Failed generating monster spawns, found no spawners.")

		return false
	end

	for i = 1, num_sections do
		TEMP_SECTIONS[i] = i
	end

	local monsters = {}
	local breed_names = table.clone(template.breed_names)
	local boss_patrols = nil

	for i = 1, num_valid_spawn_types do
		local spawn_type = valid_spawn_types[i]
		local num_spawns = template.num_spawns[spawn_type]
		local num_to_spawn = math.min(num_sections, type(num_spawns) == "table" and num_spawns[math.random(1, #num_spawns)] or num_spawns)

		for j = 1, num_to_spawn do
			local spawn_point_sections = spawn_type_point_sections[spawn_type]
			local temp_section_index = math.random(#TEMP_SECTIONS)
			local section_index = TEMP_SECTIONS[temp_section_index]
			local section = spawn_point_sections[section_index]
			local spawn_point = section[math.random(#section)]
			local travel_distance = spawn_point.spawn_travel_distance
			local spawn_type_breed_names = breed_names[spawn_type]

			if #spawn_type_breed_names > 0 then
				local breed_name = spawn_type_breed_names[math.random(#spawn_type_breed_names)]
				local position = spawn_point.position
				local despawn_distance_when_passive = template.despawn_distance_when_passive and template.despawn_distance_when_passive[breed_name]
				local monster = {
					travel_distance = travel_distance,
					breed_name = breed_name,
					position = position,
					section = section_index,
					despawn_distance_when_passive = despawn_distance_when_passive
				}
				monsters[#monsters + 1] = monster

				table.swap_delete(TEMP_SECTIONS, temp_section_index)

				num_sections = num_sections - 1
			end
		end

		local boss_patrol_settings = template.boss_patrols

		if boss_patrol_settings and spawn_type == "monsters" and num_to_spawn == 0 and math.random() <= boss_patrol_settings.chance_to_fill_empty_monster_with_patrol then
			boss_patrols = {}
			local spawn_point_sections = spawn_type_point_sections.monsters
			local temp_section_index = math.random(#TEMP_SECTIONS)
			local section_index = TEMP_SECTIONS[temp_section_index]
			local section = spawn_point_sections[section_index]
			local spawn_point = section[math.random(#section)]
			local travel_distance = spawn_point.spawn_travel_distance - MonsterSettings.boss_patrol_extra_spawn_distance
			local breed_list = boss_patrol_settings.breed_lists
			local spawn_point_travel_distance = spawn_point.spawn_point_travel_distance
			local sound_events = boss_patrol_settings.sound_events
			local boss_patrol = {
				travel_distance = travel_distance,
				breed_list = breed_list,
				section = section_index,
				spawn_point_travel_distance = spawn_point_travel_distance,
				sound_events = sound_events
			}
			boss_patrols[#boss_patrols + 1] = boss_patrol

			table.swap_delete(TEMP_SECTIONS, temp_section_index)

			num_sections = num_sections - 1
		end
	end

	table.clear_array(TEMP_SECTIONS, #TEMP_SECTIONS)

	self._monsters = monsters
	self._boss_patrols = boss_patrols
	self._alive_monsters = {}

	return true
end

MonsterPacing.fill_spawns_by_travel_distance = function (self, breed_name, spawn_type, monster_per_travel_distance)
	if type(monster_per_travel_distance) == "table" then
		monster_per_travel_distance = math.random_range(monster_per_travel_distance[1], monster_per_travel_distance[2])
	end

	if not self._monsters then
		return
	end

	local monsters = self._monsters
	local spawn_point_sections = self._spawn_type_point_sections[spawn_type]

	table.clear_array(monsters, #monsters)

	local current_travel_distance = monster_per_travel_distance
	local num_spawn_points = 0
	local matching_spawn_points = {}

	for i = 1, #spawn_point_sections do
		local section = spawn_point_sections[i]
		num_spawn_points = num_spawn_points + #section

		for j = 1, #section do
			table.clear(matching_spawn_points)

			for h = 1, #section do
				local spawn_point = section[h]
				local travel_distance = spawn_point.spawn_travel_distance

				if current_travel_distance <= travel_distance then
					matching_spawn_points[#matching_spawn_points + 1] = spawn_point
				end
			end

			local spawn_point = #matching_spawn_points > 0 and matching_spawn_points[math.random(1, #matching_spawn_points)]

			if spawn_point then
				local travel_distance = spawn_point.spawn_travel_distance

				if current_travel_distance <= travel_distance then
					if type(monster_per_travel_distance) == "table" then
						monster_per_travel_distance = math.random_range(monster_per_travel_distance[1], monster_per_travel_distance[2])
					end

					current_travel_distance = travel_distance + monster_per_travel_distance
					local position = spawn_point.position
					local monster_breed_name = breed_name

					if type(breed_name) == "table" then
						monster_breed_name = breed_name[math.random(1, #breed_name)]
					end

					local monster = {
						travel_distance = travel_distance,
						breed_name = monster_breed_name,
						position = position,
						section = i
					}
					monsters[#monsters + 1] = monster
				end
			end
		end
	end
end

MonsterPacing.add_spawn_point = function (self, unit, position, path_position, travel_distance, section_index, spawn_type)
	local above = 1
	local below = 1
	local horizontal = 1
	local nav_world = self._nav_world
	local position_on_navmesh = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, position, above, below, horizontal)

	if not position_on_navmesh then
		Log.warning("MonsterPacing", "Monster spawner at position(%.2f, %.2f, %.2f) is not on navmesh!", position[1], position[2], position[3])

		return false
	end

	local spawn_distance = MonsterSettings.spawn_distance
	local wanted_distance = travel_distance - spawn_distance
	local spawn_point_sections = self._spawn_type_point_sections[spawn_type]
	local spawn_point_section = spawn_point_sections[section_index]
	local spawn_point = {
		position = Vector3Box(position_on_navmesh),
		spawn_travel_distance = wanted_distance,
		spawn_type = spawn_type,
		spawn_point_travel_distance = travel_distance
	}

	if spawn_point_section then
		spawn_point_section[#spawn_point_section + 1] = spawn_point
	else
		spawn_point_sections[section_index] = {
			spawn_point
		}
		self._num_spawn_type_sections[spawn_type] = self._num_spawn_type_sections[spawn_type] + 1
	end

	return true
end

MonsterPacing.update = function (self, dt, t, side_id, target_side_id)
	local disabled = self._disabled

	if disabled then
		return
	end

	local ahead_target_unit, ahead_travel_distance = Managers.state.main_path:ahead_unit(target_side_id)

	if not ahead_target_unit then
		return
	end

	local monsters_allowed = Managers.state.pacing:spawn_type_enabled("monsters")

	if monsters_allowed then
		local monsters = self._monsters
		local num_monsters = #monsters

		for i = 1, num_monsters do
			local monster = monsters[i]
			local spawn_travel_distance = monster.travel_distance

			if spawn_travel_distance <= ahead_travel_distance then
				self:_spawn_monster(monster, ahead_target_unit, side_id)
				table.remove(monsters, i)

				break
			end
		end

		local boss_patrols = self._boss_patrols

		if boss_patrols then
			local num_boss_patrols = #boss_patrols

			for i = 1, num_boss_patrols do
				local boss_patrol = boss_patrols[i]
				local spawn_travel_distance = boss_patrol.travel_distance

				if spawn_travel_distance <= ahead_travel_distance then
					self:_spawn_boss_patrol(boss_patrol, ahead_travel_distance, side_id)
					table.remove(boss_patrols, i)

					break
				end
			end
		end
	end

	local alive_monsters = self._alive_monsters
	local _, behind_travel_distance = Managers.state.main_path:behind_unit(target_side_id)

	for i = 1, #alive_monsters do
		local monster = alive_monsters[i]
		local spawned_unit = monster.spawned_unit

		if not HEALTH_ALIVE[spawned_unit] then
			table.remove(alive_monsters, i)

			break
		end

		local despawn_distance_when_passive = monster.despawn_distance_when_passive

		if despawn_distance_when_passive then
			local blackboard = BLACKBOARDS[spawned_unit]
			local perception_component = blackboard.perception
			local aggro_state = perception_component.aggro_state
			local is_passive = aggro_state == perception_aggro_states.passive

			if is_passive then
				local spawn_travel_distance = monster.travel_distance + MonsterSettings.spawn_distance
				local travel_distance_diff = behind_travel_distance - spawn_travel_distance

				if despawn_distance_when_passive <= travel_distance_diff then
					local minion_spawn_manager = Managers.state.minion_spawn

					minion_spawn_manager:despawn(spawned_unit)
					table.remove(alive_monsters, i)

					break
				end
			end
		end
	end
end

MonsterPacing._spawn_monster = function (self, monster, ahead_target_unit, side_id)
	local template = self._template
	local breed_name = monster.breed_name
	local spawn_position = monster.position:unbox()
	local aggro_states = template.aggro_states
	local aggro_state = aggro_states[breed_name]
	local spawned_unit = nil

	if aggro_state then
		spawned_unit = Managers.state.minion_spawn:spawn_minion(breed_name, spawn_position, Quaternion.identity(), side_id, aggro_state, ahead_target_unit)
	else
		spawned_unit = Managers.state.minion_spawn:spawn_minion(breed_name, spawn_position, Quaternion.identity(), side_id)
	end

	local pause_pacing_on_spawn_settings = template.pause_pacing_on_spawn
	local pause_pacing_on_spawn = pause_pacing_on_spawn_settings[breed_name]

	if pause_pacing_on_spawn then
		for spawn_type, duration in pairs(pause_pacing_on_spawn) do
			Managers.state.pacing:pause_spawn_type(spawn_type, true, "monster_spawned", duration)
		end
	end

	Log.info("MonsterPacing", "Spawned monster %s successfully.", breed_name)

	monster.spawned_unit = spawned_unit
	self._alive_monsters[#self._alive_monsters + 1] = monster
end

MonsterPacing._spawn_boss_patrol = function (self, boss_patrol, ahead_travel_distance, side_id)
	local breed_list = boss_patrol.breed_list
	local current_faction = Managers.state.pacing:current_faction()
	local boss_patrol_challenge_templates = breed_list[current_faction].challenge_templates
	local boss_patrol_challenge_breed_list = Managers.state.difficulty:get_table_entry_by_challenge(boss_patrol_challenge_templates)
	local spawn_list = boss_patrol_challenge_breed_list[math.random(1, #boss_patrol_challenge_breed_list)]
	local num_to_spawn = #spawn_list
	local nav_world = self._nav_world
	local spawn_point_travel_distance = boss_patrol.spawn_point_travel_distance
	local spawn_point_main_path_position = MainPathQueries.position_from_distance(spawn_point_travel_distance)
	local target_main_path_position = MainPathQueries.position_from_distance(ahead_travel_distance)
	local minion_spawn_manager = Managers.state.minion_spawn
	local flood_fill_positions = {}
	local below = 2
	local above = 2
	local num_positions = GwNavQueries.flood_fill_from_position(nav_world, spawn_point_main_path_position, above, below, num_to_spawn, flood_fill_positions)

	for i = 1, num_positions do
		local position = flood_fill_positions[i]
		flood_fill_positions[#flood_fill_positions + 1] = position
	end

	local group_system = Managers.state.extension:system("group_system")
	local group_id = group_system:generate_group_id()
	local spawned_minions = {}

	for i = 1, num_positions do
		local breed_name = spawn_list[i]
		local spawn_position = flood_fill_positions[i]
		local unit = minion_spawn_manager:spawn_minion(breed_name, spawn_position, Quaternion.identity(), side_id, perception_aggro_states.passive, nil, nil, group_id, nil, nil, "trickle_horde")
		local blackboard = BLACKBOARDS[unit]
		local patrol_component = Blackboard.write_component(blackboard, "patrol")

		if i == 1 then
			patrol_component.walk_position:store(target_main_path_position)

			patrol_component.should_patrol = true
			patrol_component.patrol_index = i
			patrol_component.auto_patrol = true
		else
			local follow_index = MinionPatrols.get_follow_index(i)
			local follow_unit = spawned_minions[follow_index]
			patrol_component.patrol_leader_unit = follow_unit
			patrol_component.patrol_index = i
			patrol_component.should_patrol = true
		end

		spawned_minions[i] = unit
	end

	local sound_events = boss_patrol.sound_events and boss_patrol.sound_events[current_faction]

	if sound_events then
		local group = group_system:group_from_id(group_id)
		local start_event = sound_events.start
		local stop_event = sound_events.stop
		group.group_start_sound_event = start_event
		group.group_stop_sound_event = stop_event
	end
end

return MonsterPacing
