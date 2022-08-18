local MainPathQueries = require("scripts/utilities/main_path_queries")
local MonsterSettings = require("scripts/settings/monster/monster_settings")
local Navigation = require("scripts/extension_systems/navigation/utilities/navigation")
local NavQueries = require("scripts/utilities/nav_queries")
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
				fassert(spawn_point_sections[i], "[MonsterPacing] %s monster spawn type is missing valid spawners for section index %d.", spawn_type, i)
			end

			fassert(num_sections == current_num_sections, "[MonsterPacing] Different amount of sections for %s (%d|%d). Ensure all monster spawn types have the same amount of sections.", spawn_type, current_num_sections, num_sections)
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
	local breed_names = template.breed_names
	local total_num_spawns = math.min(num_sections, template.num_spawns)

	for i = 1, total_num_spawns do
		local spawn_type = valid_spawn_types[math.random(num_valid_spawn_types)]
		local spawn_point_sections = spawn_type_point_sections[spawn_type]
		local section_index = TEMP_SECTIONS[math.random(#TEMP_SECTIONS)]
		local section = spawn_point_sections[section_index]
		local spawn_point = section[math.random(#section)]
		local travel_distance = spawn_point.spawn_travel_distance
		local spawn_type_breed_names = breed_names[spawn_type]
		local breed_name = spawn_type_breed_names[math.random(#spawn_type_breed_names)]
		local position = spawn_point.position
		local monster = {
			travel_distance = travel_distance,
			breed_name = breed_name,
			position = position,
			section = section_index
		}
		monsters[#monsters + 1] = monster

		table.swap_delete(TEMP_SECTIONS, section_index)
	end

	table.clear_array(TEMP_SECTIONS, #TEMP_SECTIONS)

	self._monsters = monsters

	return true
end

MonsterPacing.fill_spawns_by_travel_distance = function (self, breed_name, spawn_type, monster_per_travel_distance)
	local monsters = self._monsters
	local spawn_point_sections = self._spawn_type_point_sections[spawn_type]

	table.clear_array(monsters, #monsters)

	local current_travel_distance = 0

	for i = 1, #spawn_point_sections do
		local section = spawn_point_sections[i]

		for j = 1, #section do
			local spawn_point = section[j]
			local travel_distance = spawn_point.spawn_travel_distance

			if current_travel_distance <= travel_distance then
				if current_travel_distance == 0 then
					current_travel_distance = travel_distance + monster_per_travel_distance
				else
					current_travel_distance = current_travel_distance + monster_per_travel_distance
				end

				local position = spawn_point.position
				local monster = {
					travel_distance = travel_distance,
					breed_name = breed_name,
					position = position,
					section = i
				}
				monsters[#monsters + 1] = monster
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
		spawn_type = spawn_type
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
	end
end

MonsterPacing._spawn_monster = function (self, monster, ahead_target_unit, side_id)
	local template = self._template
	local breed_name = monster.breed_name
	local spawn_position = monster.position:unbox()
	local aggro_states = template.aggro_states
	local aggro_state = aggro_states[breed_name]

	if aggro_state then
		Managers.state.minion_spawn:spawn_minion(breed_name, spawn_position, Quaternion.identity(), side_id, aggro_state, ahead_target_unit)
	else
		Managers.state.minion_spawn:spawn_minion(breed_name, spawn_position, Quaternion.identity(), side_id)
	end

	local pause_pacing_on_spawn_settings = template.pause_pacing_on_spawn
	local pause_pacing_on_spawn = pause_pacing_on_spawn_settings[breed_name]

	if pause_pacing_on_spawn then
		for spawn_type, duration in pairs(pause_pacing_on_spawn) do
			Managers.state.pacing:pause_spawn_type(spawn_type, true, "monster_spawned", duration)
		end
	end

	Log.info("MonsterPacing", "Spawned monster %s successfully.", breed_name)
end

return MonsterPacing
