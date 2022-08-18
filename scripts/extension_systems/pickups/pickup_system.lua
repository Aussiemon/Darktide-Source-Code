require("scripts/extension_systems/pickups/pickup_spawner_extension")

local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local Pickups = require("scripts/settings/pickup/pickups")
local PickupSettings = require("scripts/settings/pickup/pickup_settings")
local DISTRIBUTION_TYPES = PickupSettings.distribution_types
local PICKUPS_BY_NAME = Pickups.by_name
local PICKUPS_BY_GROUP = Pickups.by_group
local PICKUPS_DATA = Pickups.data
local PickupSystem = class("PickupSystem", "ExtensionSystemBase")

PickupSystem.init = function (self, context, system_init_data, ...)
	PickupSystem.super.init(self, context, system_init_data, ...)

	local is_server = context.is_server
	self._soft_cap_out_of_bounds_units = context.soft_cap_out_of_bounds_units
	self._mission_pickup_settings = self:_fetch_settings(system_init_data.mission, context.circumstance_name)
	self._seed = system_init_data.level_seed
	self._is_server = is_server
	self._material_collected = {}
	self._spawned_pickups = {}
	self._guaranteed_spawned_pickups = {}
	self._pickup_to_spawner = {}
	self._pickup_to_owner = {}
	self._pickup_to_interactors = {}
	self._pickup_spawner_extensions = {}
	self._managed_spawner_extensions = {}
end

PickupSystem._fetch_settings = function (self, mission, circumstance_name)
	local original_settings = mission.pickup_settings
	local circumstance_template = CircumstanceTemplates[circumstance_name]
	local mission_overrides = circumstance_template.mission_overrides
	local circumstance_settings = (mission_overrides and mission_overrides.pickup_settings) or nil

	return circumstance_settings or original_settings
end

PickupSystem.extensions_ready = function (self, world, unit)
	if self._is_server then
		local extension = self._unit_to_extension_map[unit]

		self:_pickup_spawner_spawned(unit, extension)

		self._managed_spawner_extensions[unit] = extension
	end
end

PickupSystem.delete_units = function (self)
	local unit_spawner_manager = Managers.state.unit_spawner
	local spawned_pickups = self._spawned_pickups
	local num_spawned_pickups = #spawned_pickups
	local ALIVE = ALIVE

	for i = 1, num_spawned_pickups, 1 do
		local unit = spawned_pickups[i]

		if ALIVE[unit] then
			unit_spawner_manager:mark_for_deletion(unit)
		end
	end
end

PickupSystem.on_gameplay_post_init = function (self, level)
	Profiler.start("populate_pickups")

	if self._is_server then
		self:_populate_pickups()
	end

	Profiler.stop("populate_pickups")
end

PickupSystem._random = function (self, ...)
	local seed, value = math.next_random(self._seed, ...)
	self._seed = seed

	return value
end

PickupSystem._shuffle = function (self, source)
	local seed = self._seed

	fassert(seed and type(seed) == "number", "Bad seed input!")

	self._seed = table.shuffle(source, seed)
end

PickupSystem._check_main_path = function (self, unit)
	local main_path_manager = Managers.state.main_path

	if not main_path_manager:is_main_path_available() then
		return false
	end

	local crossroads_id = Unit.get_data(unit, "crossroads_id")
	local road_id = Unit.get_data(unit, "road_id")

	if crossroads_id and road_id and not main_path_manager:is_crossroad_segment_available(crossroads_id, road_id) then
		return false
	end

	return true
end

PickupSystem._pickup_spawner_spawned = function (self, unit, pickup_spawner_extension)
	if self:_check_main_path(unit) then
		pickup_spawner_extension:calculate_percentage_through_level()

		self._pickup_spawner_extensions[#self._pickup_spawner_extensions + 1] = pickup_spawner_extension
	end
end

local function _compare_absolute_spawner_position(a, b)
	local percentage_a = a:percentage_through_level()
	local percentage_b = b:percentage_through_level()

	fassert(percentage_a and percentage_b, "You need to rebuild paths (pickup spawners broke)")

	return percentage_a < percentage_b
end

PickupSystem._override_table = function (self, original, override)
	for key, value in pairs(override) do
		if type(value) == "table" then
			self:_override_table(original[key], value)
		else
			original[key] = override[key]
		end
	end
end

PickupSystem._get_pickup_pool_from_difficulty = function (self, distribution_settings, difficulty)
	local pool = {}

	for distribution_type, groups in pairs(distribution_settings) do
		local type = {}

		for pickup_type, pickups in pairs(groups) do
			local pickup = {}

			for pickup_name, count in pairs(pickups) do
				pickup[pickup_name] = count[difficulty]
			end

			type[pickup_type] = pickup
		end

		pool[distribution_type] = type
	end

	return pool
end

PickupSystem._populate_pickups = function (self)
	local mission_pickup_settings = self._mission_pickup_settings
	local num_spawners = #self._pickup_spawner_extensions
	local pickup_spawners = self._pickup_spawner_extensions

	table.sort(pickup_spawners, _compare_absolute_spawner_position)

	for i = 1, num_spawners, 1 do
		pickup_spawners[i]:spawn_guaranteed()
	end

	if mission_pickup_settings then
		local pickup_settings = nil

		if mission_pickup_settings.default then
			pickup_settings = mission_pickup_settings.default
		else
			local difficulty_manager = Managers.state.difficulty
			local difficulty = math.floor((difficulty_manager:get_challenge() + difficulty_manager:get_resistance()) / 2)
			local distribution_pool = PickupSettings.distribution_pool
			pickup_settings = self:_get_pickup_pool_from_difficulty(distribution_pool, difficulty)
			local pickup_settings_override = self:_get_pickup_pool_from_difficulty(mission_pickup_settings, difficulty)

			self:_override_table(pickup_settings, pickup_settings_override)
		end

		local primary_pickup_settings = pickup_settings.primary or pickup_settings

		self:_spawn_spread_pickups(DISTRIBUTION_TYPES.primary, primary_pickup_settings)

		local secondary_pickup_settings = pickup_settings.secondary

		if secondary_pickup_settings then
			self:_spawn_spread_pickups(DISTRIBUTION_TYPES.secondary, secondary_pickup_settings)
		end
	end

	local mission_manager = Managers.state.mission
	local side_mission = mission_manager:side_mission()

	if side_mission and mission_manager:side_mission_is_pickup() then
		local unit_name = side_mission.unit_name
		local side_settings = {}
		local pickup = PICKUPS_BY_NAME[unit_name]
		side_settings[pickup.group] = {
			[unit_name] = side_mission.collect_amount
		}

		self:_spawn_spread_pickups(DISTRIBUTION_TYPES.side_mission, side_settings)
	end
end

local pickup_options_weight = {}

PickupSystem.get_pickup_choice = function (self, distribution_type, pickup_options)
	table.clear(pickup_options_weight)
	fassert(distribution_type == DISTRIBUTION_TYPES.guaranteed, "[PickupSystem] get_pickup_choice() does not handle distribution type: %s", distribution_type)

	local guaranteed_spawned_pickups = self._guaranteed_spawned_pickups
	local num_options = #pickup_options
	local total_weight = 1

	for i = 1, num_options, 1 do
		local pickup_name = pickup_options[i]
		local already_spawned = guaranteed_spawned_pickups[pickup_name]
		local pickup_weight = nil

		if already_spawned and PickupSettings.pickup_pool_value[pickup_name] then
			pickup_weight = 1 / (already_spawned * PickupSettings.pickup_pool_value[pickup_name])
		else
			pickup_weight = 1
		end

		total_weight = total_weight + pickup_weight
		pickup_options_weight[i] = total_weight
	end

	local new_seed, random_index = math.next_random(self._seed, 1, total_weight * 1000)
	self._seed = new_seed
	random_index = math.round(random_index / 1000)
	local pickup_index = 1

	while random_index <= pickup_options_weight[pickup_index] do
		if pickup_index == num_options then
			break
		end

		pickup_index = pickup_index + 1
	end

	local selected_name = pickup_options[pickup_index]
	guaranteed_spawned_pickups[selected_name] = (guaranteed_spawned_pickups[selected_name] or 0) + 1

	return selected_name
end

local pickups_to_spawn = {}
local section_spawners = {}
local used_spawners = {}
local usable_spawners = {}

PickupSystem._spawn_spread_pickups = function (self, distribution_type, pickup_settings)
	local num_spawners = #self._pickup_spawner_extensions
	local pickup_spawners = self._pickup_spawner_extensions

	table.clear(usable_spawners)

	for i = 1, num_spawners, 1 do
		pickup_spawners[i]:register_spawn_locations(usable_spawners, distribution_type, pickup_settings)
	end

	for pickup_type, value in pairs(pickup_settings) do
		table.clear(pickups_to_spawn)

		if type(value) == "table" then
			for pickup_name, amount in pairs(value) do
				for i = 1, amount, 1 do
					pickups_to_spawn[#pickups_to_spawn + 1] = pickup_name
				end
			end

			self:_shuffle(pickups_to_spawn)
		else
			local pickups = PICKUPS_BY_GROUP[pickup_type]

			for i = 1, value, 1 do
				local spawn_value = self:_random()
				local spawn_weighting_total = 0
				local selected_pickup = false

				for pickup_name, settings in pairs(pickups) do
					spawn_weighting_total = spawn_weighting_total + settings.spawn_weighting

					if spawn_value <= spawn_weighting_total then
						pickups_to_spawn[#pickups_to_spawn + 1] = pickup_name
						selected_pickup = true

						break
					end
				end

				fassert(selected_pickup, "[PickupSystem] Problem selecting a pickup to spawn, spawn_weighting_total = %s, spawn_value = %s", spawn_weighting_total, spawn_value)
			end
		end

		local num_sections = #pickups_to_spawn
		local section_size = 1 / num_sections
		local section_start_point = 0
		local section_end_point = nil
		local spawn_debt = 0

		if #usable_spawners >= 2 then
			local first_spawner_percentage_through_level = usable_spawners[1].extension:percentage_through_level()
			local last_spawner_percentage_through_level = usable_spawners[#usable_spawners].extension:percentage_through_level()
			local section_scale = 1 - first_spawner_percentage_through_level - (1 - last_spawner_percentage_through_level)
			local section_start_point_offset = first_spawner_percentage_through_level
			section_size = section_scale / num_sections
			section_start_point = section_start_point_offset
		end

		for i = 1, num_sections, 1 do
			table.clear(section_spawners)
			table.clear(used_spawners)

			section_end_point = section_start_point + section_size
			local num_pickup_spawners = #usable_spawners

			for j = 1, num_pickup_spawners, 1 do
				local spawner = usable_spawners[j]
				local spawner_extension = spawner.extension
				local percentage_through_level = spawner_extension:percentage_through_level()

				if (section_start_point <= percentage_through_level and percentage_through_level < section_end_point) or (num_sections == i and percentage_through_level == 1) then
					section_spawners[#section_spawners + 1] = spawner
				end
			end

			section_start_point = section_end_point
			local num_section_spawners = #section_spawners

			if num_section_spawners > 0 and spawn_debt >= 0 then
				local remaining_sections = num_sections - i + 1
				local pickups_in_section = math.min(1 + math.ceil(spawn_debt / remaining_sections), num_section_spawners)
				local rnd = self:_random()
				local near_pickup_spawn_chance = PICKUPS_DATA.near_pickup_spawn_chance[pickup_type]
				local bonus_spawn = remaining_sections ~= 1 and pickups_in_section == 1 and rnd < near_pickup_spawn_chance
				pickups_in_section = pickups_in_section + ((bonus_spawn and 1) or 0)

				self:_shuffle(section_spawners)

				local num_spawned_pickups_in_section = 0
				local previously_selected_spawner = nil

				for j = 1, pickups_in_section, 1 do
					local num_available_section_spawners = #section_spawners
					local selected_spawner, pickup_index = nil

					if previously_selected_spawner then
						local percentage_through_level = previously_selected_spawner.extension:percentage_through_level()

						local function _compare_relative_spawner_position(a, b)
							local percentage_a = a.extension:percentage_through_level()
							local percentage_b = b.extension:percentage_through_level()

							fassert(percentage_a and percentage_b, "You need to rebuild paths (pickup spawners broke)")

							return math.abs(percentage_through_level - percentage_a) < math.abs(percentage_through_level - percentage_b)
						end

						table.sort(section_spawners, _compare_relative_spawner_position)
					end

					for k = 1, num_available_section_spawners, 1 do
						local index = nil
						selected_spawner, index = self:_check_spawn(section_spawners[k], pickups_to_spawn, pickup_type)

						if selected_spawner then
							pickup_index = index
							used_spawners[#used_spawners + 1] = selected_spawner
							num_spawned_pickups_in_section = num_spawned_pickups_in_section + 1

							break
						end
					end

					if selected_spawner then
						local index = table.find(section_spawners, selected_spawner)

						table.remove(section_spawners, index)
						table.remove(pickups_to_spawn, pickup_index)

						previously_selected_spawner = selected_spawner
					end
				end

				spawn_debt = spawn_debt - (num_spawned_pickups_in_section - 1)
			else
				spawn_debt = spawn_debt + 1
			end

			local num_used_spawners = #used_spawners

			for j = 1, num_used_spawners, 1 do
				local spawner_unit = used_spawners[j]
				local index = table.find(usable_spawners, spawner_unit)

				table.remove(usable_spawners, index)
			end
		end

		if spawn_debt > 0 then
			local num_pickups_to_spawn = #pickups_to_spawn

			fassert(spawn_debt == num_pickups_to_spawn, "The spawn debt (%d) does not match pickups left in pickups_to_spawn (%d)", spawn_debt, num_pickups_to_spawn)

			if #usable_spawners > 0 then
				self:_shuffle(usable_spawners)

				for i = 1, num_pickups_to_spawn, 1 do
					local num_pickup_spawners = #usable_spawners

					for j = 1, num_pickup_spawners, 1 do
						local spawner, pickup_index = self:_check_spawn(usable_spawners[j], pickup_type)

						if spawner then
							table.remove(usable_spawners, j)
							table.remove(pickups_to_spawn, pickup_index)

							num_pickups_to_spawn = num_pickups_to_spawn - 1

							break
						end
					end
				end

				Log.warning("PickupSystem", "Spawned (%d) pickups outside of regular system to avoid unspawned pickups", spawn_debt - num_pickups_to_spawn)
			end

			if num_pickups_to_spawn > 0 then
			end
		end
	end
end

PickupSystem._check_spawn = function (self, spawner, pickup_type)
	local num_pickups_to_spawn = #pickups_to_spawn
	local spawner_extension = spawner.extension
	local component_index = spawner.index

	for i = 1, num_pickups_to_spawn, 1 do
		local pickup_name = pickups_to_spawn[i]
		local can_spawn = spawner_extension:can_spawn_pickup(component_index, pickup_name)

		if can_spawn then
			local check_reserve = true
			local pickup_unit, _ = spawner_extension:spawn_specific_item(component_index, pickup_name, check_reserve)

			return spawner, i
		end
	end
end

PickupSystem.update = function (self, system_context, dt, t)
	if self._is_server then
		local spawned_pickups = self._spawned_pickups
		local soft_cap_out_of_bounds_units = self._soft_cap_out_of_bounds_units

		for i = #spawned_pickups, 1, -1 do
			local unit = spawned_pickups[i]

			if soft_cap_out_of_bounds_units[unit] then
				Log.info("PickupSystem", "%s is out-of-bounds, despawning (%s).", unit, tostring(POSITION_LOOKUP[unit]))
				self:despawn_pickup(unit)
			end
		end
	end
end

PickupSystem.get_owner = function (self, pickup_unit)
	return self._pickup_to_owner[pickup_unit]
end

PickupSystem.has_interacted = function (self, pickup_unit, player_session_id)
	local interactors = self._pickup_to_interactors[pickup_unit]

	return table.array_contains(interactors, player_session_id)
end

PickupSystem.spawn_pickup = function (self, pickup_name, position, rotation, pickup_spawner, placed_on_unit, spawn_interaction_cooldown)
	fassert(self._is_server, "Only server should spawn pickup units")

	local pickup_settings = PICKUPS_BY_NAME[pickup_name]
	local unit_template_name = pickup_settings.unit_template_name

	fassert(unit_template_name, "[PickupSystem] must specify unit_template_name for pickup %s ", pickup_name)

	local unit_name = pickup_settings.unit_name

	if pickup_settings.spawn_offset then
		local spawn_offset = pickup_settings.spawn_offset:unbox()
		position = position + Quaternion.rotate(rotation, spawn_offset)
	end

	local pickup_unit, pickup_unit_go_id = Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template_name, position, rotation, nil, pickup_settings, placed_on_unit, spawn_interaction_cooldown)
	self._spawned_pickups[#self._spawned_pickups + 1] = pickup_unit
	self._pickup_to_interactors[pickup_unit] = {}

	if pickup_spawner then
		self._pickup_to_spawner[pickup_unit] = pickup_spawner
	end

	return pickup_unit, pickup_unit_go_id
end

PickupSystem.player_spawn_pickup = function (self, pickup_name, position, rotation, player_session_id, placed_on_unit)
	local pickup_unit, pickup_unit_go_id = self:spawn_pickup(pickup_name, position, rotation, nil, placed_on_unit)
	self._pickup_to_owner[pickup_unit] = player_session_id

	return pickup_unit, pickup_unit_go_id
end

PickupSystem.despawn_pickup = function (self, pickup_unit)
	local unit_spawner_manager = Managers.state.unit_spawner
	local spawned_pickups = self._spawned_pickups
	local num_spawned_pickups = #spawned_pickups
	self._pickup_to_spawner[pickup_unit] = nil
	self._pickup_to_owner[pickup_unit] = nil
	self._pickup_to_interactors[pickup_unit] = nil
	local deleted_index = nil
	local ALIVE = ALIVE

	for i = 1, num_spawned_pickups, 1 do
		local unit = spawned_pickups[i]

		if ALIVE[unit] and unit == pickup_unit then
			unit_spawner_manager:mark_for_deletion(unit)

			deleted_index = i

			break
		end
	end

	fassert(deleted_index ~= nil, "[PickupSystem][despawn_pickup] Unit(%s) not managed by this spawner.", tostring(pickup_unit))
	table.swap_delete(self._spawned_pickups, deleted_index)
end

PickupSystem.interact_with = function (self, pickup_unit, player_session_id)
	if player_session_id and not self:has_interacted(pickup_unit, player_session_id) then
		local interactors = self._pickup_to_interactors[pickup_unit]
		interactors[#interactors + 1] = player_session_id
	end
end

PickupSystem.picked_up = function (self, pickup_unit, player_session_id)
	local spawner = self._pickup_to_spawner[pickup_unit]

	if spawner then
		spawner:spawned_item_picked_up(pickup_unit)
	end

	self:interact_with(pickup_unit, player_session_id)
end

PickupSystem.register_material_collected = function (self, pickup_unit, interactor_unit, type, size)
	local type_list = self._material_collected[type]

	if not type_list then
		type_list = {}
		self._material_collected[type] = type_list
	end

	if not type_list[size] then
		type_list[size] = 1
	else
		type_list[size] = type_list[size] + 1
	end

	if DEDICATED_SERVER then
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local owning_player = player_unit_spawn_manager:owner(interactor_unit)

		if owning_player and owning_player:is_human_controlled() then
			Managers.stats:record_collect_material(owning_player, type, size)
		end
	end
end

PickupSystem.get_collected_materials = function (self)
	return self._material_collected
end

return PickupSystem
