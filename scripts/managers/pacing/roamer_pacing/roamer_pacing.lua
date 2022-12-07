local Breeds = require("scripts/settings/breed/breeds")
local LoadedDice = require("scripts/utilities/loaded_dice")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local MinionPatrols = require("scripts/utilities/minion_patrols")
local NavQueries = require("scripts/utilities/nav_queries")
local Navigation = require("scripts/extension_systems/navigation/utilities/navigation")
local PatrolSettings = require("scripts/settings/roamer/patrol_settings")
local RoamerPacks = require("scripts/settings/roamer/roamer_packs")
local RoamerSettings = require("scripts/settings/roamer/roamer_settings")
local RoamerSlotPlacementFunctions = require("scripts/settings/roamer/roamer_slot_placement_functions")
local SpawnPointQueries = require("scripts/managers/main_path/utilities/spawn_point_queries")
local RoamerPacing = class("RoamerPacing")

RoamerPacing.init = function (self, nav_world, level_path, seed, pacing_control)
	self._nav_world = nav_world
	self._original_seed = seed
	self._seed = seed
	local roamer_pack_probabilities = {}

	for name, packs in pairs(RoamerPacks) do
		local probabilities = {}

		for i = 1, #packs do
			local pack = packs[i]
			probabilities[i] = pack.weight
		end

		local prob, alias = LoadedDice.create(probabilities, false)
		roamer_pack_probabilities[name] = {
			prob = prob,
			alias = alias
		}
	end

	self._roamer_pack_probabilities = roamer_pack_probabilities
	self._faction_travel_distances = {}
	self._density_type_travel_distances = {}
	local faction_index = self:_random(1, #RoamerSettings.faction_types)
	local current_faction = RoamerSettings.faction_types[faction_index]
	self._current_faction = current_faction
end

local FORBIDDEN_NAV_TAG_VOLUME_TYPES = {
	"content/volume_types/nav_tag_volumes/no_spawn"
}
local NAV_TAG_LAYER_COSTS = {}
local PATROL_NAV_TAG_LAYER_COSTS = {
	jumps = 0,
	cover_vaults = 0,
	bot_damage_drops = 0,
	monster_walls = 0,
	bot_ladders = 0,
	bot_jumps = 0,
	bot_leap_of_faith = 0,
	ledges_with_fence = 0,
	doors = 1,
	teleporters = 0,
	ledges = 0,
	cover_ledges = 0,
	bot_drops = 0
}

RoamerPacing.on_gameplay_post_init = function (self, level)
	local nav_world = self._nav_world
	local traverse_logic, nav_tag_cost_table = Navigation.create_traverse_logic(nav_world, NAV_TAG_LAYER_COSTS, nil, false)
	self._nav_tag_cost_table = nav_tag_cost_table
	self._traverse_logic = traverse_logic
	local nav_mesh_manager = Managers.state.nav_mesh

	for i = 1, #FORBIDDEN_NAV_TAG_VOLUME_TYPES do
		local volume_type = FORBIDDEN_NAV_TAG_VOLUME_TYPES[i]
		local layer_ids = nav_mesh_manager:nav_tag_volume_layer_ids_by_volume_type(volume_type)

		for j = 1, #layer_ids do
			GwNavTagLayerCostTable.forbid_layer(nav_tag_cost_table, layer_ids[j])
		end
	end

	local main_path_manager = Managers.state.main_path
	local spawn_point_positions = main_path_manager:spawn_point_positions()

	if spawn_point_positions then
		Log.info("RoamerPacing", "Generating Roamers using seed %d", self._seed)

		self._spawn_point_positions = spawn_point_positions
		local nav_spawn_points = main_path_manager:nav_spawn_points()
		self._nav_spawn_points = nav_spawn_points
		self._roamer_groups = {}
		self._roamer_lookup = {}
		local patrol_data = {
			patrols = {},
			active_patrols = {},
			claimed_patrol_zone_indexes = {}
		}
		self._patrol_data = patrol_data
		local zones = self:_create_zones(spawn_point_positions)
		self._zones = zones
		local roamers = {}

		self:_generate_roamers(zones, roamers)

		self._roamers = roamers
		self._roamer_update_index = 1
		local num_roamers = #roamers
		self._num_roamers = num_roamers
		local num_zones = #zones

		if num_roamers == 0 then
			Log.warning("RoamerPacing", "No roamers got generated with %d zones, maybe increase the main path length?.", num_zones)
		end

		local patrol_traverse_logic, patrol_nav_tag_cost_table = Navigation.create_traverse_logic(nav_world, PATROL_NAV_TAG_LAYER_COSTS, nil, false)
		patrol_data.patrol_traverse_logic = patrol_traverse_logic
		patrol_data.patrol_nav_tag_cost_table = patrol_nav_tag_cost_table

		for i = 1, #FORBIDDEN_NAV_TAG_VOLUME_TYPES do
			local volume_type = FORBIDDEN_NAV_TAG_VOLUME_TYPES[i]
			local layer_ids = nav_mesh_manager:nav_tag_volume_layer_ids_by_volume_type(volume_type)

			for j = 1, #layer_ids do
				GwNavTagLayerCostTable.forbid_layer(patrol_nav_tag_cost_table, layer_ids[j])
			end
		end

		local astar = GwNavAStar.create(nav_world)
		patrol_data.astar = astar
	end
end

RoamerPacing.destroy = function (self)
	if self._nav_tag_cost_table then
		GwNavTagLayerCostTable.destroy(self._nav_tag_cost_table)
	end

	if self._traverse_logic then
		GwNavTraverseLogic.destroy(self._traverse_logic)
	end

	local patrol_data = self._patrol_data

	if patrol_data then
		if patrol_data.patrol_nav_tag_cost_table then
			GwNavTagLayerCostTable.destroy(patrol_data.patrol_nav_tag_cost_table)
		end

		if patrol_data.patrol_traverse_logic then
			GwNavTraverseLogic.destroy(patrol_data.patrol_traverse_logic)
		end

		local astar = patrol_data.astar

		if astar then
			if not GwNavAStar.processing_finished(astar) then
				GwNavAStar.cancel(astar)
			end

			GwNavAStar.destroy(astar)
		end
	end
end

RoamerPacing._create_zones = function (self, spawn_point_positions)
	self._started_group_ambience = {}

	table.clear(self._faction_travel_distances)
	table.clear(self._density_type_travel_distances)

	local num_zones = #spawn_point_positions
	local zones = Script.new_array(num_zones)
	local density_settings = Managers.state.difficulty:get_table_entry_by_resistance(RoamerSettings.density_settings)
	local density_types = RoamerSettings.density_types
	local density_type = density_types[self:_random(1, #density_types)]
	local density_setting = density_settings[density_type]
	local density_zone_range = density_setting.zone_range
	local density_zone_count = self:_random(density_zone_range[1], density_zone_range[2])
	local faction_zone_length_table = Managers.state.difficulty:get_table_entry_by_challenge(RoamerSettings.faction_zone_length)
	local faction_zone_length = self:_random(faction_zone_length_table[1], faction_zone_length_table[2])
	local faction_index = self:_random(1, #RoamerSettings.faction_types)
	local current_faction = self._override_faction or self._current_faction
	self._current_faction = current_faction
	self._current_density_type = density_type
	local empty_zone_count = 0
	local group_system = Managers.state.extension:system("group_system")
	local group_id = group_system:generate_group_id()
	local num_encampments_to_spawn = self._num_encampments_override or self:_random(RoamerSettings.num_encampments[1], RoamerSettings.num_encampments[2])
	local num_encampments = 0
	local num_encampment_blocked_zones = 0
	local chosen_packs, pack_pick = nil
	local num_spawn_point_positions = #spawn_point_positions

	for i = 1, num_spawn_point_positions do
		repeat
			if empty_zone_count > 0 then
				empty_zone_count = empty_zone_count - 1
				zones[#zones + 1] = {}
			else
				local spawn_positions = spawn_point_positions[i]
				local num_roamers_range = density_setting.num_roamers_range[current_faction]
				local num_to_spawn = self:_random(num_roamers_range[1], num_roamers_range[2])
				local sub_zones, total_roamer_slots = self:_create_sub_zones(spawn_positions, density_setting, group_id, num_to_spawn)
				local packs = density_setting.packs

				if not chosen_packs then
					pack_pick = pack_pick or self:_random(1, #packs)
					chosen_packs = packs[pack_pick][current_faction]
				end

				local ambience_sfx = RoamerSettings.ambience_sfx[density_type]
				local aggro_sfx = RoamerSettings.aggro_sfx[density_type]
				local pause_spawn_type_when_aggroed = RoamerSettings.pause_spawn_type_when_aggroed[density_type]
				local zone = {
					aggro_sfx = aggro_sfx,
					ambience_sfx = ambience_sfx,
					density_type = density_type,
					faction = current_faction,
					group_id = group_id,
					limits = density_setting.limits,
					num_to_spawn = math.min(num_to_spawn, total_roamer_slots),
					pause_spawn_type_when_aggroed = pause_spawn_type_when_aggroed,
					roamer_packs = chosen_packs,
					sub_zones = sub_zones,
					spawn_point_index = i
				}
				zones[#zones + 1] = zone
				faction_zone_length = faction_zone_length - 1

				if faction_zone_length <= 0 and density_type == "none" then
					faction_index = faction_index % #RoamerSettings.faction_types + 1
					current_faction = self._override_faction or RoamerSettings.faction_types[faction_index]
					faction_zone_length = self:_random(faction_zone_length_table[1], faction_zone_length_table[2])
				end

				density_zone_count = density_zone_count - 1
				num_encampment_blocked_zones = math.max(num_encampment_blocked_zones - 1, 0)

				if density_zone_count == 0 then
					local new_density_type = nil
					local has_randomized_encampment = self:_random() <= (self._override_chance_of_encampment or RoamerSettings.chance_of_encampment)
					local should_spawn_encampment = num_encampment_blocked_zones == 0 and num_encampments < num_encampments_to_spawn and has_randomized_encampment

					if should_spawn_encampment then
						local encampment_types = RoamerSettings.encampment_types
						new_density_type = encampment_types[self:_random(1, #encampment_types)]
						num_encampments = num_encampments + 1
						num_encampment_blocked_zones = RoamerSettings.num_encampment_blocked_zones
					elseif density_type == "low" then
						new_density_type = "high"
					elseif density_type == "none" then
						new_density_type = "low"
					else
						new_density_type = "none"
					end

					if density_type == "none" then
						local random_add_step = pack_pick + self:_random(1, #packs - 1)
						pack_pick = random_add_step > 6 and random_add_step % 6 or random_add_step
					end

					density_setting = density_settings[new_density_type]
					density_zone_range = density_setting.zone_range
					density_zone_count = self:_random(density_zone_range[1], density_zone_range[2])
					local empty_zone_range = density_setting.empty_zone_range

					if empty_zone_range then
						empty_zone_count = self:_random(empty_zone_range[1], empty_zone_range[2])
					end

					density_type = new_density_type
					chosen_packs = nil

					if i < num_spawn_point_positions then
						group_id = group_system:generate_group_id()
					end
				end
			end
		until true
	end

	return zones
end

RoamerPacing._create_sub_zones = function (self, spawn_positions, density_setting, group_id, num_to_spawn)
	local sub_zones = {}
	local total_roamer_slots = 0
	local try_fill_one_sub_zone = density_setting.try_fill_one_sub_zone
	local num_spawn_positions = #spawn_positions

	for j = 1, num_spawn_positions do
		local sub_zone_positions = spawn_positions[j]
		local num_sub_zone_positions = #sub_zone_positions

		if num_sub_zone_positions > 0 then
			local sub_zone = nil
			local num_roamer_slots = 0

			if try_fill_one_sub_zone then
				sub_zone = Script.new_array(1)
				local spawn_position = sub_zone_positions[self:_random(1, num_sub_zone_positions)]
				local sub_zone_location, new_num_roamer_slots = self:_create_sub_zone_location(spawn_position, density_setting, group_id)
				sub_zone[1] = sub_zone_location
				num_roamer_slots = num_roamer_slots + new_num_roamer_slots
			else
				sub_zone = Script.new_array(num_sub_zone_positions)

				for k = 1, num_sub_zone_positions do
					local spawn_position = sub_zone_positions[k]
					local sub_zone_location, new_num_roamer_slots = self:_create_sub_zone_location(spawn_position, density_setting, group_id)
					sub_zone[#sub_zone + 1] = sub_zone_location
					num_roamer_slots = num_roamer_slots + new_num_roamer_slots
				end
			end

			sub_zones[#sub_zones + 1] = sub_zone
			total_roamer_slots = total_roamer_slots + num_roamer_slots

			if try_fill_one_sub_zone and num_to_spawn <= num_roamer_slots then
				break
			end
		end
	end

	return sub_zones, total_roamer_slots
end

RoamerPacing._create_sub_zone_location = function (self, spawn_position, density_setting, group_id)
	local roamer_slot_placement_functions = density_setting.roamer_slot_placement_functions
	local roamer_slot_placement_function_name = roamer_slot_placement_functions[self:_random(1, #roamer_slot_placement_functions)]
	local roamer_slot_placement_settings = density_setting.roamer_slot_placement_settings[roamer_slot_placement_function_name]
	local roamer_slots = RoamerSlotPlacementFunctions[roamer_slot_placement_function_name](self._nav_world, spawn_position, roamer_slot_placement_settings, self._traverse_logic, self)
	local spawn_point_group_index = SpawnPointQueries.group_from_position(self._nav_world, self._nav_spawn_points, spawn_position:unbox())
	local sub_zone_location = {
		position = spawn_position,
		roamer_slots = roamer_slots,
		group_id = group_id,
		shared_aggro_trigger = density_setting.shared_aggro_trigger,
		spawn_point_group_index = spawn_point_group_index
	}
	local num_roamer_slots = #roamer_slots

	return sub_zone_location, num_roamer_slots
end

local ZONE_BREED_COUNT = {}
local ZONE_BREED_TAG_COUNT = {}

RoamerPacing._limit_roamer_breeds = function (self, breed_name, limit_settings, faction)
	if not limit_settings then
		return
	end

	local num_existing_breeds = ZONE_BREED_COUNT[breed_name] or 0
	local new_value = num_existing_breeds + 1
	local limit = limit_settings[breed_name]
	local replacements = limit_settings.replacements
	local replacement_breeds = replacements[breed_name] and replacements[breed_name][faction]

	if limit and limit < new_value then
		local replace_index = self:_random(1, #replacement_breeds)

		return replacement_breeds[replace_index]
	end

	local tag_limits = limit_settings.tag_limits

	if tag_limits then
		local breed = Breeds[breed_name]
		local tags = breed.tags

		for tag_name, _ in pairs(tags) do
			local tag_limit = tag_limits[tag_name]
			local current_tag_count = ZONE_BREED_TAG_COUNT[tag_name] or 0

			if tag_limit and tag_limit <= current_tag_count then
				local replace_index = self:_random(1, #replacement_breeds)

				return replacement_breeds[replace_index]
			else
				ZONE_BREED_TAG_COUNT[tag_name] = current_tag_count + 1
			end
		end
	end

	ZONE_BREED_COUNT[breed_name] = new_value
end

RoamerPacing._generate_roamers = function (self, zones, roamers)
	local num_zones = #zones
	local max_tries = 100
	local start_zone_index = 2
	local roamer_pack_probabilities = self._roamer_pack_probabilities
	local old_group_id = math.huge
	local current_faction = self._current_faction
	local current_density_type = self._current_density_type
	local patrols = self._patrol_data.patrols
	local num_patrols = PatrolSettings.num_patrols_per_zone
	local min_members_in_patrol = PatrolSettings.min_members_in_patrol
	local main_path_manager = Managers.state.main_path
	local spawn_point_positions = main_path_manager:spawn_point_positions()

	for i = start_zone_index, num_zones do
		local zone = zones[i]
		local num_to_spawn = zone.num_to_spawn

		if not num_to_spawn then
			-- Nothing
		else
			local sub_zones = zone.sub_zones
			local num_sub_zones = #sub_zones

			if num_sub_zones ~= 0 then
				local roamer_packs = zone.roamer_packs
				local roamer_packs_name = roamer_packs.name
				local roamer_pack_probability = roamer_pack_probabilities[roamer_packs_name]
				local probability = roamer_pack_probability.prob
				local alias = roamer_pack_probability.alias
				local limit_difficulty_settings = zone.limits
				local ambience_sfx = zone.ambience_sfx
				local aggro_sfx = zone.aggro_sfx
				local pause_spawn_type_when_aggroed = zone.pause_spawn_type_when_aggroed
				local faction = zone.faction
				local density_type = zone.density_type
				local spawn_point_index = zone.spawn_point_index
				local limit_settings = limit_difficulty_settings and Managers.state.difficulty:get_table_entry_by_challenge(limit_difficulty_settings)
				local tries = 0
				local roamers_per_sub_zone = num_to_spawn > 1 and math.floor(num_to_spawn / num_sub_zones) or 1
				num_to_spawn = roamers_per_sub_zone * num_sub_zones
				local sub_zone_index = 1
				local num_spawned = 0

				while num_to_spawn > 0 and sub_zone_index <= num_sub_zones and tries < max_tries do
					local sub_zone = sub_zones[sub_zone_index]
					local num_sub_zone_locations = #sub_zone

					if num_sub_zone_locations > 0 then
						local random_sub_zone_location_index = self:_random(1, num_sub_zone_locations)
						local random_sub_zone_location = sub_zone[random_sub_zone_location_index]
						local shared_aggro_trigger = random_sub_zone_location.shared_aggro_trigger
						local group_id = random_sub_zone_location.group_id

						if group_id ~= old_group_id then
							table.clear(ZONE_BREED_COUNT)
							table.clear(ZONE_BREED_TAG_COUNT)

							old_group_id = group_id
							num_patrols = PatrolSettings.num_patrols_per_zone
						end

						local roamer_slots = random_sub_zone_location.roamer_slots
						local seed, roamer_pack_index = LoadedDice.roll_seeded(probability, alias, self._seed)
						self._seed = seed
						local roamer_pack = roamer_packs[roamer_pack_index]
						local breed_names = roamer_pack.breeds
						local num_breeds = #breed_names
						local num_roamer_slots = #roamer_slots
						local num_to_spawn_in_pack = math.min(num_roamer_slots, roamers_per_sub_zone)
						local sub_zone_location_position = random_sub_zone_location.position:unbox()
						local spawn_point_group_index = random_sub_zone_location.spawn_point_group_index
						local start_index = Managers.state.main_path:node_index_by_nav_group_index(spawn_point_group_index)
						local end_index = start_index + 1
						local _, travel_distance, _, _, _ = MainPathQueries.closest_position_between_nodes(sub_zone_location_position, start_index, end_index)
						local patrol, patrol_id = nil
						local spawn_positions = spawn_point_positions[spawn_point_index]
						local num_spawn_positions = #spawn_positions

						if num_spawn_positions > 0 and num_patrols > 0 and min_members_in_patrol <= num_to_spawn and min_members_in_patrol <= num_to_spawn_in_pack then
							local num_patrollable_breeds = 0

							for j = 1, num_breeds do
								local breed_name = breed_names[j]

								if Breeds[breed_name].can_patrol then
									num_patrollable_breeds = num_patrollable_breeds + 1
								end
							end

							if min_members_in_patrol <= num_patrollable_breeds then
								patrol = {}
								num_patrols = num_patrols - 1
								patrol_id = #patrols + 1
							end
						end

						for j = 0, num_to_spawn_in_pack - 1 do
							if num_to_spawn == 0 then
								break
							end

							local breed_index = j % num_breeds + 1
							local breed_name = breed_names[breed_index]
							local replaced_breed_name = self:_limit_roamer_breeds(breed_name, limit_settings, faction)
							local roamer_slot = roamer_slots[j + 1]
							local roamer_id = #roamers + 1
							local roamer = {
								aggro_sfx = aggro_sfx,
								ambience_sfx = ambience_sfx,
								breed_name = replaced_breed_name or breed_name,
								faction = faction,
								group_id = group_id,
								patrol_id = patrol_id,
								pause_spawn_type_when_aggroed = pause_spawn_type_when_aggroed,
								position = roamer_slot.position,
								roamer_id = roamer_id,
								rotation = roamer_slot.rotation,
								shared_aggro_trigger = shared_aggro_trigger,
								zone_id = i,
								sub_zone_id = sub_zone_index,
								travel_distance = travel_distance,
								density_type = density_type
							}
							roamers[roamer_id] = roamer

							if patrol and Breeds[breed_name].can_patrol then
								patrol[#patrol + 1] = roamer_id
							end

							num_to_spawn = num_to_spawn - 1
							num_spawned = num_spawned + 1
						end

						if patrol then
							patrols[patrol_id] = patrol
						end

						if faction ~= current_faction then
							self._faction_travel_distances[#self._faction_travel_distances + 1] = {
								travel_distance = travel_distance,
								faction = faction,
								density_type = density_type
							}
							current_faction = faction
						end

						if density_type ~= current_density_type then
							self._density_type_travel_distances[#self._density_type_travel_distances + 1] = {
								travel_distance = travel_distance,
								density_type = density_type
							}
							current_density_type = density_type
						end

						table.remove(sub_zone, random_sub_zone_location_index)
					end

					if roamers_per_sub_zone <= num_spawned or num_sub_zone_locations == 0 then
						sub_zone_index = sub_zone_index + 1
						num_spawned = 0
					end

					tries = tries + 1
				end
			end
		end
	end
end

local function _roamer_is_passive(roamer_unit)
	local blackboard = BLACKBOARDS[roamer_unit]

	if blackboard then
		local perception_component = blackboard.perception
		local is_passive = perception_component.aggro_state == "passive"

		return HEALTH_ALIVE[roamer_unit] and is_passive
	end

	return false
end

local function _roamer_is_aggroed(roamer_unit)
	local blackboard = BLACKBOARDS[roamer_unit]

	if blackboard then
		local perception_component = blackboard.perception
		local is_aggroed = (perception_component.aggro_state == "aggroed" or perception_component.aggro_state == "alerted") and perception_component.target_unit ~= nil

		return HEALTH_ALIVE[roamer_unit] and is_aggroed
	end

	return false
end

local NUM_ROAMERS_UPDATE_PER_FRAME = 1

RoamerPacing.update = function (self, dt, t, side_id, target_side_id)
	if self._disabled or not self._zones then
		return
	end

	local main_path_manager = Managers.state.main_path
	local _, ahead_travel_distance = main_path_manager:ahead_unit(target_side_id)

	if not ahead_travel_distance then
		return
	end

	self:_update_faction_switch(ahead_travel_distance)
	self:_update_density_type_switch(ahead_travel_distance)

	local _, behind_travel_distance = main_path_manager:behind_unit(target_side_id)
	local roamers = self._roamers
	local spawn_distance = RoamerSettings.spawn_distance
	local num_updates = math.min(NUM_ROAMERS_UPDATE_PER_FRAME, self._num_roamers)
	local roamers_allowed = Managers.state.pacing:spawn_type_enabled("roamers")

	for i = 1, num_updates do
		local roamer_update_index = self._roamer_update_index
		local roamer = roamers[roamer_update_index]
		local roamer_got_removed = false

		if not roamer.disabled then
			local roamer_travel_distance = roamer.travel_distance
			local ahead_travel_distance_diff = math.abs(ahead_travel_distance - roamer_travel_distance)
			local behind_travel_distance_diff = math.abs(behind_travel_distance - roamer_travel_distance)
			local is_between_ahead_and_behind = roamer_travel_distance < ahead_travel_distance and behind_travel_distance < roamer_travel_distance
			local should_activate = is_between_ahead_and_behind or ahead_travel_distance_diff < spawn_distance or behind_travel_distance_diff < spawn_distance
			local is_active = roamer.active

			if should_activate and not is_active and not roamers_allowed then
				roamer_got_removed = self:_deactivate_roamer(roamer)
			elseif should_activate and not is_active then
				local activated_roamer = self:_try_activate_roamer(roamer, side_id)

				if not activated_roamer then
					roamer_got_removed = self:_deactivate_roamer(roamer)
				end
			elseif not should_activate and is_active or is_active and not HEALTH_ALIVE[roamer.spawned_unit] then
				roamer_got_removed = self:_deactivate_roamer(roamer)
			end

			if is_active and roamer.shared_aggro_trigger then
				local spawned_unit = roamer.spawned_unit

				if _roamer_is_aggroed(spawned_unit) then
					local blackboard = BLACKBOARDS[spawned_unit]
					local perception_component = blackboard.perception
					local target_unit = perception_component.target_unit

					self:_alert_roamer_group(spawned_unit, target_unit, roamer, side_id, target_side_id)
				end
			end
		end

		if not roamer_got_removed or self._num_roamers < roamer_update_index then
			self._roamer_update_index = roamer_update_index % self._num_roamers + 1
		end
	end

	local patrol_data = self._patrol_data

	MinionPatrols.update_roamer_patrols(patrol_data, roamers, self._nav_world, self._zones)
end

RoamerPacing._alert_roamer_unit = function (self, roamer_unit, target_unit, alert_delay)
	local perception_extension = ScriptUnit.extension(roamer_unit, "perception_system")
	local ignore_alerted_los = true

	perception_extension:delayed_alert(target_unit, alert_delay, ignore_alerted_los)
end

RoamerPacing._alert_roamer_group = function (self, aggroing_unit, target_unit, aggroing_roamer, side_id, target_side_id)
	local group_extension = ScriptUnit.has_extension(aggroing_unit, "group_system")
	local group = group_extension:group()
	local members = group.members
	local roamer_lookup = self._roamer_lookup
	local ALIVE = ALIVE
	local POSITION_LOOKUP = POSITION_LOOKUP
	local aggroing_unit_position = POSITION_LOOKUP[aggroing_unit]

	for i = 1, #members do
		local roamer_unit = members[i]
		local roamer = roamer_lookup[roamer_unit]

		if roamer and ALIVE[roamer_unit] then
			local roamer_position = POSITION_LOOKUP[roamer_unit]
			local distance = Vector3.distance(aggroing_unit_position, roamer_position)
			local alert_delay = distance / 15 + math.random()

			self:_alert_roamer_unit(roamer_unit, target_unit, alert_delay)

			roamer.shared_aggro_trigger = nil
		end
	end

	local group_system = Managers.state.extension:system("group_system")
	local group_id = group_extension:group_id()
	local started_group_ambience = self._started_group_ambience[group_id]

	if started_group_ambience then
		group_system:stop_group_sfx(group)
		Managers.state.game_session:send_rpc_clients("rpc_stop_group_sfx", group_id)

		self._started_group_ambience[group_id] = nil
	end

	local aggro_sfx = aggroing_roamer.aggro_sfx

	if aggro_sfx then
		local start_aggro_sfx = aggro_sfx.start
		local stop_aggro_sfx = aggro_sfx.stop

		group_system:start_group_sfx(group_id, start_aggro_sfx, stop_aggro_sfx)
	end

	local pause_spawn_type_when_aggroed = aggroing_roamer.pause_spawn_type_when_aggroed

	if pause_spawn_type_when_aggroed then
		for spawn_type, pause_duration_table in pairs(pause_spawn_type_when_aggroed) do
			local pause_duration = Managers.state.difficulty:get_table_entry_by_resistance(pause_duration_table)

			Managers.state.pacing:pause_spawn_type(spawn_type, true, "roamers_aggroed", pause_duration)
		end
	end

	local trigger_horde_when_aggroed = RoamerSettings.trigger_horde_when_aggroed[aggroing_roamer.density_type]

	if trigger_horde_when_aggroed then
		local horde_template_name = trigger_horde_when_aggroed.horde_template_name
		local composition = trigger_horde_when_aggroed.composition
		local resistance_scaled_composition = Managers.state.difficulty:get_table_entry_by_resistance(composition)

		Managers.state.horde:horde(horde_template_name, horde_template_name, side_id, target_side_id, resistance_scaled_composition)
	end
end

local NAV_ABOVE = 0.1
local NAV_BELOW = 0.1

RoamerPacing._try_activate_roamer = function (self, roamer, side_id)
	local position = roamer.position:unbox()
	local is_on_nav_mesh = NavQueries.position_on_mesh(self._nav_world, position, NAV_ABOVE, NAV_BELOW, self._traverse_logic)

	if not is_on_nav_mesh then
		return false
	end

	local breed_name = roamer.breed_name
	local rotation = roamer.rotation:unbox()
	local group_id = roamer.group_id
	local spawned_unit = self:_spawn_roamer(breed_name, position, rotation, group_id, side_id)
	roamer.spawned_unit = spawned_unit
	roamer.active = true
	self._roamer_lookup[spawned_unit] = roamer

	self:_handle_group_ambience_sfx(roamer, true)

	local patrols = self._patrol_data.patrols
	local patrol_id = roamer.patrol_id

	if patrol_id then
		local patrol_should_activate = true
		local patrol = patrols[patrol_id]

		for i = 1, #patrol do
			local roamer_id = patrol[i]
			local other_roamer = self._roamers[roamer_id]
			local other_spawned_unit = other_roamer.spawned_unit

			if not ALIVE[other_spawned_unit] then
				patrol_should_activate = false

				break
			end
		end

		if patrol_should_activate then
			local active_patrols = self._patrol_data.active_patrols
			active_patrols[patrol_id] = true
		end
	end

	return true
end

RoamerPacing._deactivate_roamer = function (self, roamer)
	local roamer_unit = roamer.spawned_unit

	self:_handle_group_ambience_sfx(roamer, false)

	if _roamer_is_passive(roamer_unit) then
		self:_despawn_roamer(roamer_unit)

		roamer.active = false
	elseif not HEALTH_ALIVE[roamer_unit] then
		local update_index = self._roamer_update_index

		table.remove(self._roamers, update_index)

		self._num_roamers = self._num_roamers - 1
		roamer.active = false
		local patrols = self._patrol_data.patrols

		for i = #patrols, 1, -1 do
			local patrol = patrols[i]

			for j = #patrol, 1, -1 do
				local roamer_id = patrol[j]

				if update_index < roamer_id then
					patrol[j] = roamer_id - 1
				elseif update_index == roamer_id then
					table.remove(patrol, j)
				end
			end
		end

		return true
	end

	self._roamer_lookup[roamer_unit] = nil
	local patrol_id = roamer.patrol_id

	if patrol_id then
		local active_patrols = self._patrol_data.active_patrols
		active_patrols[patrol_id] = nil
	end

	return false
end

RoamerPacing._spawn_roamer = function (self, breed_name, position, rotation, group_id, side_id)
	local unit = Managers.state.minion_spawn:spawn_minion(breed_name, position, rotation, side_id, nil, nil, nil, group_id)

	return unit
end

RoamerPacing._despawn_roamer = function (self, unit)
	Managers.state.minion_spawn:despawn(unit)
end

RoamerPacing._update_faction_switch = function (self, ahead_travel_distance)
	local faction_travel_distances = self._faction_travel_distances

	if #faction_travel_distances == 0 then
		return
	end

	local next_faction_distances = faction_travel_distances[1]
	local travel_distance = next_faction_distances.travel_distance

	if travel_distance <= ahead_travel_distance then
		local new_faction = self._override_faction or next_faction_distances.faction
		self._current_faction = new_faction
		self._current_density_type = next_faction_distances.density_type

		table.remove(faction_travel_distances, 1)
	end
end

RoamerPacing._update_density_type_switch = function (self, ahead_travel_distance)
	local density_type_travel_distances = self._density_type_travel_distances

	if #density_type_travel_distances == 0 then
		return
	end

	local next_density_type_distances = density_type_travel_distances[1]
	local travel_distance = next_density_type_distances.travel_distance

	if travel_distance <= ahead_travel_distance then
		self._current_density_type = next_density_type_distances.density_type

		table.remove(density_type_travel_distances, 1)
	end
end

RoamerPacing._handle_group_ambience_sfx = function (self, roamer, activated)
	local group_ambience_sfx = roamer.ambience_sfx

	if not group_ambience_sfx then
		return
	end

	local group_system = Managers.state.extension:system("group_system")
	local group_id = roamer.group_id
	local started_group_ambience = self._started_group_ambience[group_id]
	local group = group_system:group_from_id(group_id)

	if not group then
		if started_group_ambience then
			self._started_group_ambience[group_id] = nil
		end

		return
	end

	local num_members = #group.members
	local min_members = group_ambience_sfx.min_members

	if activated and min_members <= num_members and not started_group_ambience then
		local start_event = group_ambience_sfx.start
		local stop_event = group_ambience_sfx.stop

		group_system:start_group_sfx(group_id, start_event, stop_event, min_members)

		self._started_group_ambience[group_id] = true
	elseif not activated and num_members < min_members then
		self._started_group_ambience[group_id] = nil
	end
end

RoamerPacing._random = function (self, ...)
	local seed, value = math.next_random(self._seed, ...)
	self._seed = seed

	return value
end

RoamerPacing.aggro_zone_range = function (self, target_unit, range)
	local from_position = POSITION_LOOKUP[target_unit]
	local group_index = SpawnPointQueries.group_from_position(self._nav_world, self._nav_spawn_points, from_position)

	if not group_index then
		local position_on_main_path = MainPathQueries.closest_position(from_position)
		group_index = SpawnPointQueries.group_from_position(self._nav_world, self._nav_spawn_points, position_on_main_path)
	end

	if not group_index then
		Log.info("RoamerPacing", "Failed to aggro roamer zones at position from_position, found no group near player.")

		return
	end

	local zones = self._zones
	local num_zones = #self._zones
	local start_range = math.max(group_index - range, 1)
	local end_range = math.min(group_index + range, num_zones)
	local group_system = Managers.state.extension:system("group_system")
	local ALIVE = ALIVE

	for i = start_range, end_range do
		local zone = zones[i]
		local group_id = zone.group_id
		local group = group_system:group_from_id(group_id)

		if group then
			local members = group.members

			for j = 1, #members do
				local member = members[j]

				if ALIVE[member] then
					self:_alert_roamer_unit(member, target_unit, 0)
				end
			end
		end
	end
end

RoamerPacing.allow_nav_tag_layer = function (self, layer_name, layer_allowed)
	local layer_id = Managers.state.nav_mesh:nav_tag_layer_id(layer_name)
	local nav_tag_cost_table = self._nav_tag_cost_table

	if layer_allowed then
		GwNavTagLayerCostTable.allow_layer(nav_tag_cost_table, layer_id)
	else
		GwNavTagLayerCostTable.forbid_layer(nav_tag_cost_table, layer_id)
	end
end

RoamerPacing.is_traverse_logic_initialized = function (self)
	return self._traverse_logic ~= nil
end

RoamerPacing.traverse_logic = function (self)
	return self._traverse_logic
end

RoamerPacing.override_faction = function (self, faction)
	self._override_faction = faction
end

RoamerPacing.num_encampments_override = function (self, value, chance)
	self._num_encampments_override = value
	self._override_chance_of_encampment = chance
end

RoamerPacing.current_faction = function (self)
	return self._current_faction
end

RoamerPacing.current_density_type = function (self)
	return self._current_density_type
end

return RoamerPacing
