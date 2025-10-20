-- chunkname: @scripts/managers/pacing/monster_pacing/monster_pacing.lua

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local MinionPatrols = require("scripts/utilities/minion_patrols")
local MonsterInjectionTemplates = require("scripts/managers/pacing/monster_pacing/templates/monster_injection_templates")
local MonsterSettings = require("scripts/settings/monster/monster_settings")
local Navigation = require("scripts/extension_systems/navigation/utilities/navigation")
local NavQueries = require("scripts/utilities/nav_queries")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local SpawnPointQueries = require("scripts/managers/main_path/utilities/spawn_point_queries")
local Vo = require("scripts/utilities/vo")
local perception_aggro_states = PerceptionSettings.aggro_states
local MonsterPacing = class("MonsterPacing")
local pacing_types = table.enum("timer_based", "default")

MonsterPacing.init = function (self, nav_world)
	self._fx_system = Managers.state.extension:system("fx_system")
	self._nav_world = nav_world

	local spawn_types, max_sections = MonsterSettings.spawn_types, MonsterSettings.max_sections
	local num_spawn_types = #spawn_types
	local spawn_point_sections, num_spawn_type_sections = Script.new_map(num_spawn_types), Script.new_map(num_spawn_types)

	for i = 1, num_spawn_types do
		local spawn_type = spawn_types[i]

		spawn_point_sections[spawn_type] = Script.new_array(max_sections)
		num_spawn_type_sections[spawn_type] = 0
	end

	self._spawn_type_point_sections, self._num_spawn_type_sections = spawn_point_sections, num_spawn_type_sections
	self._health_modifier = 1
	self._aggroed_monster_units = {}
	self._main_path_sound_events = {}
end

MonsterPacing.destroy = function (self)
	return
end

MonsterPacing.on_gameplay_post_init = function (self, level, template)
	self._template = template
	self._pacing_type = self._template.pacing_type or pacing_types.default

	local pacing_type = self._pacing_type

	if pacing_type == pacing_types.default then
		local success = self:_generate_spawns(template)

		if not success then
			self._disabled = true
		end
	elseif pacing_type == pacing_types.timer_based then
		self._setup_timer_based_monsters = true
		self._alive_monsters = {}
	end
end

MonsterPacing._setup_timer_based_monster_pacing = function (self, dt, t, side_id, target_side_id)
	local template = self._template
	local monster_timer_ranges = template.monster_timer_range
	local random_monster_timer = math.random(monster_timer_ranges[1], monster_timer_ranges[2])

	self._next_monster_at_t = random_monster_timer
	self._monster_timer = 0
	self._currently_spawned_by_timer = {
		boss_patrols = {},
		monsters = {},
	}
	self._amount_allowed_by_type = {}
end

local function _sort_spawners(spawner_1, spawner_2)
	return spawner_1.spawn_travel_distance < spawner_2.spawn_travel_distance
end

local TEMP_SECTIONS_MONSTERS = {}
local TEMP_SECTIONS_WITCHES = {}
local NUM_SECTIONS = {}

MonsterPacing._generate_spawns = function (self, template)
	table.clear(self._main_path_sound_events)

	local main_path_available = Managers.state.main_path:is_main_path_available()

	if not main_path_available then
		return false
	end

	local spawn_type_point_sections, num_spawn_type_sections = self._spawn_type_point_sections, self._num_spawn_type_sections
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
				-- Nothing
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
		TEMP_SECTIONS_MONSTERS[i] = i
		TEMP_SECTIONS_WITCHES[i] = i
	end

	NUM_SECTIONS.monsters = num_sections
	NUM_SECTIONS.witches = num_sections

	local monsters, breed_names = {}, table.clone(template.breed_names)
	local boss_injections = {}

	for injection_name, injection_data in pairs(MonsterInjectionTemplates) do
		local correct_difficulty = Managers.state.difficulty:get_table_entry_by_challenge(injection_data.difficulties)
		local inject_requested = injection_data.should_inject()

		if correct_difficulty and inject_requested then
			boss_injections[#boss_injections + 1] = injection_name
		end
	end

	local allow_witches_spawned_with_monsters = template.allow_witches_spawned_with_monsters
	local boss_patrols

	for i = 1, num_valid_spawn_types do
		local spawn_type = valid_spawn_types[i]
		local num_spawns = template.num_spawns[spawn_type] or 0
		local current_num_sections = allow_witches_spawned_with_monsters and NUM_SECTIONS[spawn_type] or num_sections
		local num_to_spawn = type(num_spawns) == "table" and math.random(num_spawns[1], num_spawns[2]) or num_spawns
		local is_monster = spawn_type == "monsters"

		if is_monster and self._num_monsters_override then
			num_to_spawn = self._num_monsters_override
		elseif spawn_type == "witches" and self._num_witches_override then
			num_to_spawn = self._num_witches_override
		end

		num_to_spawn = math.max(num_to_spawn, #boss_injections)

		if is_monster then
			local havoc_extension = Managers.state.game_mode:game_mode():extension("havoc")

			if havoc_extension then
				local add_num_monsters = havoc_extension:get_modifier_value("add_num_monsters")

				if add_num_monsters then
					num_to_spawn = num_to_spawn + add_num_monsters
				end
			end
		end

		if current_num_sections < num_to_spawn then
			Log.warning("MonsterPacing", "Requested %s spawns for type %s but only had %s sections. Clamped.", num_to_spawn, spawn_type, current_num_sections)

			num_to_spawn = current_num_sections
		end

		local temp_sections_table = is_monster and TEMP_SECTIONS_MONSTERS or TEMP_SECTIONS_WITCHES

		for _ = 1, num_to_spawn do
			local sound_data
			local spawn_point_sections = spawn_type_point_sections[spawn_type]
			local temp_section_index = math.random(#temp_sections_table)
			local section_index = temp_sections_table[temp_section_index]
			local section = spawn_point_sections[section_index]
			local spawn_point = section[math.random(#section)]
			local travel_distance = spawn_point.spawn_travel_distance
			local spawn_type_breed_names = breed_names[spawn_type]

			if #spawn_type_breed_names > 0 then
				local breed_name = spawn_type_breed_names[math.random(#spawn_type_breed_names)]
				local position = spawn_point.position
				local injection_index = #boss_injections
				local injection_name = boss_injections[injection_index]
				local injection_template = MonsterInjectionTemplates[injection_name]

				if injection_template then
					boss_injections[injection_index] = nil
					sound_data = injection_template.sound_data

					local injection_breed_names = injection_template.breed_names
					local injection_breed_index = math.random(#injection_breed_names)

					breed_name = injection_breed_names[injection_breed_index]
				end

				local despawn_distance_when_passive = template.despawn_distance_when_passive and template.despawn_distance_when_passive[breed_name]
				local monster = {
					travel_distance = travel_distance,
					breed_name = breed_name,
					position = position,
					section = section_index,
					despawn_distance_when_passive = despawn_distance_when_passive,
					spawn_type = spawn_type,
				}

				monsters[#monsters + 1] = monster

				if injection_template and injection_template.add_overrides then
					injection_template.add_overrides(monster)
				end

				local stinger = self._template.spawn_stingers and self._template.spawn_stingers[breed_name]

				if stinger then
					monster.stinger = stinger
				end

				table.swap_delete(temp_sections_table, temp_section_index)

				if allow_witches_spawned_with_monsters then
					NUM_SECTIONS[spawn_type] = NUM_SECTIONS[spawn_type] - 1
				else
					num_sections = num_sections - 1
				end
			end

			if sound_data then
				local sound_events = self._main_path_sound_events

				sound_events[#sound_events + 1] = {
					event = sound_data.event,
					distance = travel_distance - sound_data.distance,
					vo_event = sound_data.vo_event,
					voice_profile = sound_data.voice_profile,
					breed_name = sound_data.breed_name,
				}
			end
		end
	end

	local boss_patrol_settings = template.boss_patrols

	if boss_patrol_settings then
		local monster_num_sections = allow_witches_spawned_with_monsters and NUM_SECTIONS.monsters or num_sections
		local num_boss_patrols_range = boss_patrol_settings.num_boss_patrols_range
		local num_sections_left = #TEMP_SECTIONS_MONSTERS
		local max_boss_patrols = num_boss_patrols_range[2]
		local min_boss_patrols = math.min(math.max(num_boss_patrols_range[1], num_sections_left), max_boss_patrols)
		local num_boss_patrols = math.min(math.random(min_boss_patrols, max_boss_patrols), monster_num_sections)

		if self._num_boss_patrol_override then
			num_boss_patrols = self._num_boss_patrol_override
		end

		boss_patrols = {}

		local spawn_point_sections = spawn_type_point_sections.monsters

		for i = 1, num_boss_patrols do
			local temp_section_index = math.random(#TEMP_SECTIONS_MONSTERS)
			local section_index = TEMP_SECTIONS_MONSTERS[temp_section_index]
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
				sound_events = sound_events,
			}

			boss_patrols[#boss_patrols + 1] = boss_patrol

			table.swap_delete(TEMP_SECTIONS_MONSTERS, temp_section_index)

			if allow_witches_spawned_with_monsters then
				NUM_SECTIONS.monsters = NUM_SECTIONS.monsters - 1
			else
				num_sections = num_sections - 1
			end
		end
	end

	table.clear_array(TEMP_SECTIONS_MONSTERS, #TEMP_SECTIONS_MONSTERS)
	table.clear_array(TEMP_SECTIONS_WITCHES, #TEMP_SECTIONS_WITCHES)
	table.clear(NUM_SECTIONS)

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

	local monsters, spawn_point_sections = self._monsters, self._spawn_type_point_sections[spawn_type]

	for i = #monsters, 1, -1 do
		local monster = monsters[i]

		if monster.spawn_type == spawn_type then
			table.remove(monsters, i)
		end
	end

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
						section = i,
						spawn_type = spawn_type,
					}

					monsters[#monsters + 1] = monster
				end
			end
		end
	end
end

MonsterPacing.fill_boss_patrols_by_travel_distance = function (self, per_travel_distance)
	if type(per_travel_distance) == "table" then
		per_travel_distance = math.random_range(per_travel_distance[1], per_travel_distance[2])
	end

	if not self._boss_patrols then
		return
	end

	local boss_patrols, spawn_point_sections = self._boss_patrols, self._spawn_type_point_sections.monsters

	table.clear(boss_patrols)

	local current_travel_distance = per_travel_distance
	local num_spawn_points = 0
	local matching_spawn_points = {}
	local boss_patrol_settings = self._template.boss_patrols

	if not boss_patrol_settings then
		return
	end

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
					if type(per_travel_distance) == "table" then
						per_travel_distance = math.random_range(per_travel_distance[1], per_travel_distance[2])
					end

					current_travel_distance = travel_distance + per_travel_distance

					local breed_list = boss_patrol_settings.breed_lists
					local spawn_point_travel_distance = spawn_point.spawn_point_travel_distance
					local sound_events = boss_patrol_settings.sound_events
					local boss_patrol = {
						travel_distance = travel_distance - MonsterSettings.boss_patrol_extra_spawn_distance,
						breed_list = breed_list,
						section = i,
						spawn_point_travel_distance = spawn_point_travel_distance,
						sound_events = sound_events,
					}

					boss_patrols[#boss_patrols + 1] = boss_patrol
				end
			end
		end
	end

	self._boss_patrols = boss_patrols
end

local monster_types = {
	"boss_patrols",
	"monsters",
}

MonsterPacing._fill_spawns_by_timer = function (self, dt, t, side_id, target_side_id)
	local template = self._template
	local side_system = Managers.state.extension:system("side_system")
	local player_side = side_system:get_side(side_id)
	local valid_player_positions = player_side.valid_enemy_human_units_positions
	local possible_spawns_by_type = {}

	for i = 1, #monster_types do
		local monster_type = monster_types[i]
		local allowed_for_type = self._amount_allowed_by_type[monster_type]

		for ii = 1, allowed_for_type do
			possible_spawns_by_type[#possible_spawns_by_type + 1] = monster_type
		end
	end

	table.shuffle(possible_spawns_by_type)

	local random_index = math.random(1, #possible_spawns_by_type)
	local type_to_spawn = possible_spawns_by_type[random_index]
	local spawn_position = self:_get_furthest_pos_from_all_players(side_id)
	local main_path_manager = Managers.state.main_path
	local nav_spawn_points, nav_world = main_path_manager:nav_spawn_points(), self._nav_world
	local position_on_navmesh = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, spawn_position, 5, 5, 5)

	if not position_on_navmesh then
		return false
	end

	local random_occluded_position = SpawnPointQueries.get_random_occluded_position(nav_world, nav_spawn_points, position_on_navmesh, player_side, 10, 1, 50)

	if not random_occluded_position then
		return
	end

	if type_to_spawn == "monsters" then
		local possible_breeds = self._template.breed_names.monsters
		local random = math.random(1, #possible_breeds)
		local choosen_breed = possible_breeds[random]
		local monster = {
			breed_name = choosen_breed,
			position = Vector3Box(random_occluded_position),
		}

		self:_spawn_monster(monster, nil, side_id)
	elseif type_to_spawn == "boss_patrols" then
		local boss_patrol_settings = template.boss_patrols

		if boss_patrol_settings then
			local enemy_side_id = 1
			local _, _, ahead_position = main_path_manager:ahead_unit(enemy_side_id)
			local breed_list = boss_patrol_settings.breed_lists
			local boss_patrol = {
				breed_list = breed_list,
				spawn_position = Vector3Box(random_occluded_position),
			}

			self:_spawn_boss_patrol(boss_patrol, ahead_position, side_id)
		end
	end

	local monster_timer_ranges = template.monster_timer_range
	local random_monster_timer = math.random(monster_timer_ranges[1], monster_timer_ranges[2])

	self._next_monster_at_t = random_monster_timer
	self._monster_timer = 0
end

MonsterPacing.set_health_modifier = function (self, modifier)
	self._health_modifier = modifier
end

MonsterPacing.add_spawn_point = function (self, unit, position, path_position, travel_distance, section_index, spawn_type)
	local above, below, horizontal, nav_world = 1, 1, 1, self._nav_world
	local position_on_navmesh = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, position, above, below, 5)

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
		spawn_point_travel_distance = travel_distance,
	}

	if spawn_point_section then
		spawn_point_section[#spawn_point_section + 1] = spawn_point
	else
		spawn_point_sections[section_index] = {
			spawn_point,
		}
		self._num_spawn_type_sections[spawn_type] = self._num_spawn_type_sections[spawn_type] + 1
	end

	if spawn_type == "monsters" then
		self:add_spawn_point(unit, position, path_position, travel_distance, section_index, "captains")
	end

	return true
end

local captain_breeds = {
	cultist = "cultist_captain",
	renegade = "renegade_captain",
}

MonsterPacing._get_captain_faction = function (self, monster)
	if monster.breed_name ~= "MUTATOR_CAPTAIN" then
		return monster
	end

	local current_faction = Managers.state.pacing:current_faction()
	local correct_captain = captain_breeds[current_faction]

	monster.breed_name = correct_captain
	monster.stinger = self._template.spawn_stingers[correct_captain]

	return monster
end

MonsterPacing._update_timer = function (self, dt, t, side_id, target_side_id)
	self._monster_timer = self._monster_timer + dt
end

local names = {
	"monsters",
	"boss_patrols",
}

MonsterPacing._check_alive = function (self)
	for i = 1, #names do
		local name = names[i]
		local spawned_type = self._currently_spawned_by_timer[name]

		for ii = 1, #spawned_type do
			if name == "monsters" then
				local monster_unit = spawned_type[ii]

				if not HEALTH_ALIVE[monster_unit] then
					spawned_type[ii] = nil
				end
			elseif name == "boss_patrols" then
				local group_id = spawned_type[ii]
				local group_system = Managers.state.extension:system("group_system")
				local group = group_system:group_from_id(group_id)

				if group and #group.members == 0 or not group then
					spawned_type[ii] = nil
				end
			end
		end
	end
end

MonsterPacing._update_allowance = function (self, dt, t, side_id, target_side_id)
	local template = self._template
	local max_allowed_by_current_heat_level = Managers.state.pacing:get_table_entry_by_heat_stage(template.max_allowed_by_heat)

	self:_check_alive()

	local total_allowed = 0

	for name, template_amount in pairs(max_allowed_by_current_heat_level) do
		local amount = template_amount - #self._currently_spawned_by_timer[name]

		total_allowed = total_allowed + amount
		self._amount_allowed_by_type[name] = amount
	end

	self._amount_allowed_by_type.total = total_allowed

	if total_allowed > 0 then
		return true
	end

	return false
end

local location_positions = {}

MonsterPacing._get_furthest_pos_from_all_players = function (self, side_id)
	local side_system = Managers.state.extension:system("side_system")
	local player_side = side_system:get_side(side_id)
	local valid_player_positions = player_side.valid_player_units_positions
	local main_path_manager = Managers.state.main_path
	local spawn_point_positions = main_path_manager:spawn_point_positions()

	if #location_positions == 0 then
		for i = 1, #spawn_point_positions do
			local spawn_group_positions = spawn_point_positions[i]

			for ii = 1, #spawn_group_positions do
				local triangle_group = spawn_group_positions[ii]

				for k = 1, #triangle_group do
					local position = triangle_group[k]

					location_positions[#location_positions + 1] = position
				end
			end
		end
	end

	local player_positions = {}

	for i = 1, #valid_player_positions do
		local player_position = valid_player_positions[i]

		player_positions[#player_positions + 1] = player_position
	end

	local vector3_distance_squared = Vector3.distance_squared
	local furthestPosition
	local maxTotalDistance = -math.huge

	for i = 1, #location_positions do
		local pos = location_positions[i]:unbox()
		local totalDistance = 0

		for ii = 1, #player_positions do
			local player_pos = player_positions[ii]
			local distance_sq = vector3_distance_squared(pos, player_pos)

			totalDistance = totalDistance + distance_sq
		end

		if maxTotalDistance < totalDistance then
			maxTotalDistance = totalDistance
			furthestPosition = pos
		end
	end

	return furthestPosition
end

MonsterPacing.update = function (self, dt, t, side_id, target_side_id)
	if self._setup_timer_based_monsters then
		self._setup_timer_based_monsters = false

		self:_setup_timer_based_monster_pacing(dt, t, side_id, target_side_id)
	end

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
		local pacing_type = self._pacing_type

		if pacing_type == pacing_types.default then
			local monsters = self._monsters
			local num_monsters = #monsters

			for i = 1, num_monsters do
				local monster = monsters[i]
				local spawn_travel_distance = monster.travel_distance

				if spawn_travel_distance <= ahead_travel_distance then
					monster = self:_get_captain_faction(monster)

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

			if self._main_path_sound_events and #self._main_path_sound_events > 0 then
				local next_mainpath_event = self._main_path_sound_events[1]

				if ahead_travel_distance >= next_mainpath_event.distance then
					local optional_ambisonics = true

					self._fx_system:trigger_wwise_event(next_mainpath_event.event, nil, nil, nil, nil, nil, optional_ambisonics)
					table.remove(self._main_path_sound_events, 1)
				end
			end
		elseif pacing_type == pacing_types.timer_based then
			local allowed = self:_update_allowance(dt, t, side_id, target_side_id)

			if allowed then
				self:_update_timer(dt, t, side_id, target_side_id)

				if self._monster_timer >= self._next_monster_at_t then
					self:_fill_spawns_by_timer(dt, t, side_id, target_side_id)
				end
			end
		end
	end

	local alive_monsters = self._alive_monsters

	if not alive_monsters then
		return
	end

	local aggroed_monster_units = self._aggroed_monster_units
	local _, behind_travel_distance = Managers.state.main_path:behind_unit(target_side_id)

	for i = 1, #alive_monsters do
		local monster = alive_monsters[i]
		local spawned_unit = monster.spawned_unit

		if not HEALTH_ALIVE[spawned_unit] then
			table.remove(alive_monsters, i)

			if monster.objective then
				local mission_objective_system = Managers.state.extension:system("mission_objective_system")

				mission_objective_system:end_mission_objective(monster.objective)
			end

			local aggroed_index = table.find(aggroed_monster_units, spawned_unit)

			if aggroed_index then
				table.remove(aggroed_monster_units, aggroed_index)
			end

			break
		end

		if monster.is_twin then
			local health_extension = ScriptUnit.extension(spawned_unit, "health_system")
			local current_health_percent = health_extension:current_health_percent()

			if not monster.triggered_escape_vo and current_health_percent <= 0.35 then
				local breed_name = ScriptUnit.extension(spawned_unit, "unit_data_system"):breed().name

				Vo.enemy_generic_vo_event(spawned_unit, "escape", breed_name)

				monster.triggered_escape_vo = true
			end

			if not monster.escaped and current_health_percent <= 0.25 then
				local blackboard = BLACKBOARDS[spawned_unit]
				local behavior_component = Blackboard.write_component(blackboard, "behavior")

				behavior_component.should_disappear = true

				health_extension:set_invulnerable(true)

				local liquid_area_template = LiquidAreaTemplates.ambush_disappear_toxic_gas

				LiquidArea.try_create(POSITION_LOOKUP[spawned_unit], Vector3(0, 0, 1), self._nav_world, liquid_area_template, nil, 2)

				monster.escaped = true
			end
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

					minion_spawn_manager:despawn_minion(spawned_unit)
					table.remove(alive_monsters, i)

					local aggroed_index = table.find(aggroed_monster_units, spawned_unit)

					if aggroed_index then
						table.remove(aggroed_monster_units, aggroed_index)
					end

					break
				end
			end
		end
	end
end

MonsterPacing.num_aggroed_monsters = function (self)
	local aggroed_monster_units = self._aggroed_monster_units

	return #aggroed_monster_units
end

MonsterPacing.set_num_monsters_override = function (self, override)
	self._num_monsters_override = override
end

MonsterPacing.set_num_witches_override = function (self, override)
	self._num_witches_override = override
end

MonsterPacing.set_num_boss_patrol_override = function (self, override)
	self._num_boss_patrol_override = override
end

MonsterPacing._spawn_monster = function (self, monster, ahead_target_unit, side_id)
	local template = self._template
	local breed_name = monster.breed_name
	local spawn_position = monster.position:unbox()
	local aggro_states = template.aggro_states
	local aggro_state = aggro_states[breed_name]
	local spawned_unit
	local spawn_max_health_modifier = self._health_modifier
	local minion_spawn_manager = Managers.state.minion_spawn
	local param_table = minion_spawn_manager:request_param_table()
	local pacing_type = self._pacing_type
	local should_patrol = aggro_state == perception_aggro_states.passive and pacing_type == pacing_types.timer_based

	if should_patrol then
		local group_system = Managers.state.extension:system("group_system")
		local group_id = group_system:generate_group_id()

		param_table.optional_group_id = group_id
	end

	param_table.optional_health_modifier = spawn_max_health_modifier

	if aggro_state then
		param_table.optional_aggro_state = aggro_state
		param_table.optional_target_unit = ahead_target_unit
		spawned_unit = minion_spawn_manager:spawn_minion(breed_name, spawn_position, Quaternion.identity(), side_id, param_table)

		if aggro_state == perception_aggro_states.aggroed then
			self._aggroed_monster_units[#self._aggroed_monster_units + 1] = spawned_unit
		end
	else
		spawned_unit = minion_spawn_manager:spawn_minion(breed_name, spawn_position, Quaternion.identity(), side_id, param_table)
	end

	local force_horde_on_spawn = template.force_horde

	if force_horde_on_spawn then
		local has_forced_horde_condition = template.force_horde_condition

		if not has_forced_horde_condition or has_forced_horde_condition() then
			Managers.state.pacing:force_horde_pacing_spawn()
		end
	end

	if monster.set_enraged then
		local t = Managers.time:time("gameplay")
		local buff_extension = ScriptUnit.extension(spawned_unit, "buff_system")

		buff_extension:add_internally_controlled_buff("empowered_twin", t)
	end

	if monster.stinger and not pacing_type == pacing_types.timer_based then
		local fx_system = Managers.state.extension:system("fx_system")

		fx_system:trigger_wwise_event(monster.stinger, spawn_position)
	end

	if monster.objective then
		local mission_objective_system = Managers.state.extension:system("mission_objective_system")

		mission_objective_system:start_mission_objective(monster.objective)
	end

	local pause_pacing_on_spawn_settings = template.pause_pacing_on_spawn
	local pause_pacing_on_spawn = pause_pacing_on_spawn_settings[breed_name]

	if pause_pacing_on_spawn then
		for spawn_type, duration in pairs(pause_pacing_on_spawn) do
			Managers.state.pacing:pause_spawn_type(spawn_type, true, "monster_spawned", duration)
		end
	end

	if should_patrol then
		local main_path_manager = Managers.state.main_path
		local enemy_side_id = 1
		local _, _, ahead_position = main_path_manager:ahead_unit(enemy_side_id)
		local blackboard = BLACKBOARDS[spawned_unit]
		local patrol_component = Blackboard.write_component(blackboard, "patrol")

		patrol_component.walk_position:store(ahead_position)

		patrol_component.should_patrol = true
		patrol_component.patrol_index = 1
		patrol_component.auto_patrol = true
	end

	Log.info("MonsterPacing", "Spawned monster %s successfully.", breed_name)

	monster.spawned_unit = spawned_unit

	if pacing_type == pacing_types.default then
		self._alive_monsters[#self._alive_monsters + 1] = monster
	end

	if pacing_type == pacing_types.timer_based then
		self._currently_spawned_by_timer.monsters[#self._currently_spawned_by_timer.monsters + 1] = spawned_unit
	end
end

MonsterPacing._spawn_boss_patrol = function (self, boss_patrol, ahead_travel_distance, side_id)
	local breed_list = boss_patrol.breed_list
	local current_faction = Managers.state.pacing:current_faction()
	local boss_patrol_challenge_templates = breed_list[current_faction].challenge_templates
	local boss_patrol_challenge_breed_list = Managers.state.difficulty:get_table_entry_by_challenge(boss_patrol_challenge_templates)
	local spawn_list = boss_patrol_challenge_breed_list[math.random(1, #boss_patrol_challenge_breed_list)]
	local num_to_spawn = #spawn_list
	local nav_world = self._nav_world
	local flood_fill_positions = {}
	local minion_spawn_manager = Managers.state.minion_spawn
	local num_positions, walk_position
	local below, above = 2, 2
	local pacing_type = self._pacing_type

	if pacing_type == pacing_types.default then
		local spawn_point_travel_distance = boss_patrol.spawn_point_travel_distance
		local spawn_point_main_path_position = MainPathQueries.position_from_distance(spawn_point_travel_distance)

		walk_position = MainPathQueries.position_from_distance(ahead_travel_distance)
		num_positions = GwNavQueries.flood_fill_from_position(nav_world, spawn_point_main_path_position, above, below, num_to_spawn, flood_fill_positions)

		for i = 1, num_positions do
			local position = flood_fill_positions[i]

			flood_fill_positions[#flood_fill_positions + 1] = position
		end
	elseif pacing_type == pacing_types.timer_based then
		local spawn_position = boss_patrol.spawn_position:unbox()

		walk_position = ahead_travel_distance
		num_positions = GwNavQueries.flood_fill_from_position(nav_world, spawn_position, above, below, num_to_spawn, flood_fill_positions)
	end

	local group_system = Managers.state.extension:system("group_system")
	local group_id = group_system:generate_group_id()
	local spawned_minions = {}

	if pacing_type == pacing_types.timer_based then
		self._currently_spawned_by_timer.boss_patrols[#self._currently_spawned_by_timer.boss_patrols + 1] = group_id
	end

	for i = 1, num_positions do
		local breed_name = spawn_list[i]
		local spawn_position = flood_fill_positions[i]
		local param_table = minion_spawn_manager:request_param_table()

		param_table.optional_aggro_state = perception_aggro_states.passive
		param_table.optional_group_id = group_id

		local unit = minion_spawn_manager:spawn_minion(breed_name, spawn_position, Quaternion.identity(), side_id, param_table)
		local blackboard = BLACKBOARDS[unit]
		local patrol_component = Blackboard.write_component(blackboard, "patrol")

		if i == 1 then
			patrol_component.walk_position:store(walk_position)

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
		local start_event, stop_event = sound_events.start, sound_events.stop

		group.group_start_sound_event = start_event
		group.group_stop_sound_event = stop_event
	end
end

MonsterPacing.remove_monsters_behind_pos = function (self, position)
	local main_path_manager = Managers.state.main_path
	local main_path_available = main_path_manager:is_main_path_available()

	if not main_path_available then
		return false
	end

	local target_navmesh_position = NavQueries.position_on_mesh_with_outside_position(self._nav_world, nil, position, 1, 1, 1)

	if target_navmesh_position then
		local distance = main_path_manager:travel_distance_from_position(target_navmesh_position)
		local monsters = self._monsters

		if monsters then
			for i = #monsters, 1, -1 do
				local monster = monsters[i]

				if distance >= monster.travel_distance then
					table.remove(monsters, i)
				end
			end
		end

		local boss_patrols = self._boss_patrols

		if boss_patrols then
			for i = #boss_patrols, 1, -1 do
				local boss_patrol = boss_patrols[i]

				if distance >= boss_patrol.travel_distance then
					table.remove(boss_patrols, i)
				end
			end
		end
	end
end

return MonsterPacing
