require("scripts/extension_systems/pickups/pickup_spawner_extension")

local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local Pickups = require("scripts/settings/pickup/pickups")
local PickupSettings = require("scripts/settings/pickup/pickup_settings")
local Ammo = require("scripts/utilities/ammo")
local Health = require("scripts/utilities/health")
local DISTRIBUTION_TYPES = PickupSettings.distribution_types
local PICKUPS_BY_NAME = Pickups.by_name
local PickupSystem = class("PickupSystem", "ExtensionSystemBase")

PickupSystem.init = function (self, context, system_init_data, ...)
	PickupSystem.super.init(self, context, system_init_data, ...)

	local is_server = context.is_server
	self._soft_cap_out_of_bounds_units = context.soft_cap_out_of_bounds_units
	self._mission_pool_adjustments = system_init_data.mission.pickup_settings
	self._backend_pool_adjustments = context.pickup_pool_adjustments
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
	self._rubberband_pool = nil
	self._rubberband_pool_start_count = {}
	self._rubberband_pool_remaining = {}
	self._rubberband_pool_special_spawned = {}
end

PickupSystem.destroy = function (self)
	return
end

PickupSystem._fetch_settings = function (self)
	local difficulty = Managers.state.difficulty:get_difficulty()
	local distribution_pool = PickupSettings.distribution_pool
	local selected_pools = {}
	local mission_pickup_settings = self._mission_pool_adjustments

	if mission_pickup_settings then
		selected_pools = self:_get_pickup_pool_from_difficulty(distribution_pool, difficulty)
		local pickup_settings_adjust = self:_get_pickup_pool_from_difficulty(mission_pickup_settings, difficulty)

		self:_add_to_table(selected_pools, pickup_settings_adjust)
	end

	local pickup_pool_adjustments = self._backend_pool_adjustments

	if pickup_pool_adjustments then
		local pickup_settings_adjust = self:_get_pickup_pool_from_difficulty(pickup_pool_adjustments, difficulty)

		self:_add_to_table(selected_pools, pickup_settings_adjust)
	end

	local circumstance_name = Managers.state.circumstance:circumstance_name()
	local circumstance_template = CircumstanceTemplates[circumstance_name]
	local mission_overrides = circumstance_template.mission_overrides

	if mission_overrides and mission_overrides.pickup_settings then
		local pickup_settings_adjust = self:_get_pickup_pool_from_difficulty(mission_overrides.pickup_settings, difficulty)

		self:_add_to_table(selected_pools, pickup_settings_adjust)
	end

	self:_remove_table_negative(selected_pools)

	return selected_pools
end

PickupSystem.extensions_ready = function (self, world, unit)
	self._game_session = Managers.state.game_session:game_session()

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

	for i = 1, num_spawned_pickups do
		local unit = spawned_pickups[i]

		if ALIVE[unit] then
			unit_spawner_manager:mark_for_deletion(unit)
		end
	end
end

PickupSystem.on_gameplay_post_init = function (self, level)
	for unit, extension in pairs(self._unit_to_extension_map) do
		extension:on_gameplay_post_init(level)
	end

	if self._is_server then
		self:_populate_pickups()
	end
end

PickupSystem._random = function (self, ...)
	local seed, value = math.next_random(self._seed, ...)
	self._seed = seed

	return value
end

PickupSystem._shuffle = function (self, source)
	local seed = self._seed
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

	return percentage_a < percentage_b
end

PickupSystem._remove_table_negative = function (self, table)
	for key, value in pairs(table) do
		if type(value) == "table" then
			self:_remove_table_negative(value)
		elseif value < 0 then
			table[key] = 0
		end
	end
end

PickupSystem._add_to_table = function (self, original, addition)
	for key, value in pairs(addition) do
		if type(value) == "table" then
			if not original[key] then
				original[key] = table.clone(value)
			else
				self:_add_to_table(original[key], value)
			end
		elseif original[key] then
			original[key] = original[key] + addition[key]
		else
			original[key] = addition[key]
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
	local mission_pickup_settings = self:_fetch_settings()
	local num_spawners = #self._pickup_spawner_extensions
	local pickup_spawners = self._pickup_spawner_extensions

	table.sort(pickup_spawners, _compare_absolute_spawner_position)

	for i = 1, num_spawners do
		pickup_spawners[i]:spawn_guaranteed()
	end

	if mission_pickup_settings then
		if mission_pickup_settings.rubberband_pool then
			local rubberband_pool = mission_pickup_settings.rubberband_pool
			local start_count = {}
			local spawned = {}

			for type, pickup_table in pairs(rubberband_pool) do
				local type_size = 0

				for pickup, value in pairs(pickup_table) do
					type_size = type_size + value
				end

				start_count[type] = type_size
				spawned[type] = type_size
			end

			self._rubberband_pool = rubberband_pool
			self._rubberband_pool_start_count = start_count
			self._rubberband_pool_remaining = spawned
			mission_pickup_settings.rubberband_pool = nil
		end

		for distribution_type, pickup_settings in pairs(mission_pickup_settings) do
			self:_spawn_spread_pickups(distribution_type, pickup_settings)
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

local function current_grenade_percentage(player_unit)
	local ABILITY_TYPE = "grenade_ability"
	local ability_extension = ScriptUnit.has_extension(player_unit, "ability_system")

	if not ability_extension then
		return 1
	end

	local ability_equipped = ability_extension:ability_is_equipped(ABILITY_TYPE)

	if not ability_equipped then
		return 1
	end

	local max_grenade_charges = ability_extension:max_ability_charges(ABILITY_TYPE)
	local remaining_grenade_charges = ability_extension:remaining_ability_charges(ABILITY_TYPE)

	return remaining_grenade_charges / max_grenade_charges
end

local function lerp(a, b, t)
	return a + (b - a) * t
end

local weights = {}

PickupSystem.get_rubberband_pickup = function (self, distribution_type, percentage_through_level)
	local AMMO = 1
	local GRENADE = 2
	local HEALTH = 3
	local RubberbandSettings = PickupSettings.rubberband
	local pool = self._rubberband_pool
	local start_count = self._rubberband_pool_start_count
	local remaining = self._rubberband_pool_remaining
	local special_spawned = self._rubberband_pool_special_spawned

	if not pool or not RubberbandSettings.status_weight[distribution_type] then
		return
	end

	local players = Managers.player:players()
	local player_count = 0
	local total_ammo = 0
	local total_grenades = 0
	local total_health = 0

	for _, player in pairs(players) do
		local player_unit = player.player_unit

		if player_unit then
			player_count = player_count + 1
			total_ammo = total_ammo + 1 - Ammo.current_total_percentage(player_unit)
			total_grenades = total_grenades + 1 - current_grenade_percentage(player_unit)
			total_health = total_health + 1 - Health.current_health_percent(player_unit)
		end
	end

	local min, max = unpack(RubberbandSettings.status_weight[distribution_type])
	local block_distance = RubberbandSettings.special_block_distance

	table.clear(weights)

	if remaining.ammo > 0 then
		weights[AMMO] = remaining.ammo / start_count.ammo * (RubberbandSettings.distribution_type_weight.ammo[distribution_type] or 1) * lerp(min, max, total_ammo / player_count) * RubberbandSettings.base_spawn_rate
	else
		weights[AMMO] = 0
	end

	if remaining.grenade > 0 then
		weights[GRENADE] = remaining.grenade / start_count.grenade * (RubberbandSettings.distribution_type_weight.grenade[distribution_type] or 1) * lerp(min, max, total_grenades / player_count) * RubberbandSettings.base_spawn_rate
	else
		weights[GRENADE] = 0
	end

	local health_special_spawned = special_spawned.medical_crate_pocketable

	if remaining.health > 0 and (not health_special_spawned or percentage_through_level >= health_special_spawned + block_distance) then
		weights[HEALTH] = remaining.health / start_count.health * (RubberbandSettings.distribution_type_weight.health[distribution_type] or 1) * lerp(min, max, total_health / player_count) * RubberbandSettings.base_spawn_rate
	else
		weights[HEALTH] = 0
	end

	self._rubberband_info = string.format("Rubberband request (%s): Ammo: %s, Grenade %s, Health: %s", distribution_type, math.round_with_precision(weights[AMMO] * 100, 2), math.round_with_precision(weights[GRENADE] * 10, 2), math.round_with_precision(weights[HEALTH] * 100, 2))
	local total_weight = 0

	for i = 1, #weights do
		total_weight = total_weight + weights[i]
		weights[i] = total_weight
	end

	local new_seed, rnd = math.next_random(self._seed)
	self._seed = new_seed
	rnd = rnd * math.max(total_weight, 1)
	self._rubberband_info = self._rubberband_info .. string.format(" (%s/%s)", math.round_with_precision(rnd * 100, 2), math.round_with_precision(total_weight * 100, 2))

	if rnd <= weights[AMMO] then
		pool = pool.ammo
		local SMALL_CLIP = 1
		local LARGE_CLIP = 2
		local AMMO_CACHE = 3

		table.clear(weights)

		weights[SMALL_CLIP] = pool.small_clip / (total_ammo + 0.01)
		weights[LARGE_CLIP] = pool.large_clip
		local ammo_special_spawned = special_spawned.ammo_cache_pocketable

		if not ammo_special_spawned or percentage_through_level >= ammo_special_spawned + block_distance then
			weights[AMMO_CACHE] = pool.ammo_cache_pocketable * total_ammo
		end

		total_weight = 0

		for i = 1, #weights do
			total_weight = total_weight + weights[i]
			weights[i] = total_weight
		end

		if total_weight <= 0 then
			self._rubberband_info = self._rubberband_info .. ", picked ammo, spawned: nothing"

			return nil
		end

		self._seed, rnd = math.next_random(self._seed)
		rnd = rnd * total_weight
		remaining.ammo = remaining.ammo - 1

		if rnd <= weights[SMALL_CLIP] then
			self._rubberband_info = self._rubberband_info .. ", spawned: small clip"
			pool.small_clip = pool.small_clip - 1

			return "small_clip"
		elseif rnd <= weights[LARGE_CLIP] then
			self._rubberband_info = self._rubberband_info .. ", spawned: large clip"
			pool.large_clip = pool.large_clip - 1

			return "large_clip"
		else
			self._rubberband_info = self._rubberband_info .. ", spawned: ammo cache"
			pool.ammo_cache_pocketable = pool.ammo_cache_pocketable - 1
			special_spawned.ammo_cache_pocketable = percentage_through_level

			return "ammo_cache_pocketable"
		end
	elseif rnd <= weights[GRENADE] then
		self._rubberband_info = self._rubberband_info .. ", spawned: small grenade"
		remaining.grenade = remaining.grenade - 1
		pool.grenade.small_grenade = pool.grenade.small_grenade - 1

		return "small_grenade"
	elseif rnd <= weights[HEALTH] then
		self._rubberband_info = self._rubberband_info .. ", spawned: medical crate"
		remaining.health = remaining.health - 1
		pool.health.medical_crate_pocketable = pool.health.medical_crate_pocketable - 1
		special_spawned.medical_crate_pocketable = percentage_through_level

		return "medical_crate_pocketable"
	else
		self._rubberband_info = self._rubberband_info .. ", spawned: nothing"

		return nil
	end
end

local pickup_options_weight = {}

PickupSystem.get_guaranteed_pickup = function (self, pickup_options)
	table.clear(pickup_options_weight)

	local guaranteed_spawned_pickups = self._guaranteed_spawned_pickups
	local num_options = #pickup_options
	local total_weight = 0

	for i = 1, num_options do
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

	local new_seed, rnd = math.next_random(self._seed)
	self._seed = new_seed
	rnd = rnd * total_weight
	local pickup_index = 1

	while pickup_options_weight[pickup_index] < rnd do
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

PickupSystem._spawn_spread_pickups = function (self, distribution_type, pickup_pool)
	local num_spawners = #self._pickup_spawner_extensions
	local pickup_spawners = self._pickup_spawner_extensions

	table.clear(usable_spawners)

	for i = 1, num_spawners do
		pickup_spawners[i]:register_spawn_locations(usable_spawners, distribution_type, pickup_pool)
	end

	local pickup_count = 0

	for pickup_type, value in pairs(pickup_pool) do
		for pickup_name, amount in pairs(value) do
			pickup_count = pickup_count + amount
		end
	end

	local spawn_ratio = pickup_count / #usable_spawners
	local min_chest_spawner_ratio = PickupSettings.min_chest_spawner_ratio[distribution_type] or 0

	if spawn_ratio < min_chest_spawner_ratio then
		local chest_spawners = 0

		for i = 1, #usable_spawners do
			if usable_spawners[i].chest then
				chest_spawners = chest_spawners + 1
			end
		end

		if chest_spawners > 0 then
			local initial_usable_spawners = #usable_spawners
			local spawners_allowed = math.floor(pickup_count / min_chest_spawner_ratio)
			local max_removable = initial_usable_spawners - pickup_count
			local direct_spawners_to_remove = math.min(initial_usable_spawners - spawners_allowed, max_removable)
			local removal_options = {}

			for i = 1, initial_usable_spawners do
				if not usable_spawners[i].chest then
					removal_options[#removal_options + 1] = i
				end
			end

			self:_shuffle(removal_options)

			for i = direct_spawners_to_remove + 1, initial_usable_spawners do
				removal_options[i] = nil
			end

			table.sort(removal_options)

			for i = #removal_options, 1, -1 do
				table.remove(usable_spawners, removal_options[i])
			end
		end
	end

	for pickup_type, value in pairs(pickup_pool) do
		table.clear(pickups_to_spawn)

		for pickup_name, amount in pairs(value) do
			for i = 1, amount do
				pickups_to_spawn[#pickups_to_spawn + 1] = pickup_name
			end
		end

		self:_shuffle(pickups_to_spawn)

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

		for i = 1, num_sections do
			table.clear(section_spawners)
			table.clear(used_spawners)

			section_end_point = section_start_point + section_size
			local num_pickup_spawners = #usable_spawners

			for j = 1, num_pickup_spawners do
				local spawner = usable_spawners[j]
				local spawner_extension = spawner.extension
				local percentage_through_level = spawner_extension:percentage_through_level()

				if section_start_point <= percentage_through_level and percentage_through_level < section_end_point or num_sections == i and percentage_through_level == 1 then
					section_spawners[#section_spawners + 1] = spawner
				end
			end

			section_start_point = section_end_point
			local num_section_spawners = #section_spawners

			if num_section_spawners > 0 and spawn_debt >= 0 then
				local remaining_sections = num_sections - i + 1
				local pickups_in_section = math.min(1 + math.ceil(spawn_debt / remaining_sections), num_section_spawners)

				self:_shuffle(section_spawners)

				local num_spawned_pickups_in_section = 0
				local previously_selected_spawner = nil

				for j = 1, pickups_in_section do
					local num_available_section_spawners = #section_spawners
					local selected_spawner, pickup_index = nil

					if previously_selected_spawner then
						local percentage_through_level = previously_selected_spawner.extension:percentage_through_level()

						local function _compare_relative_spawner_position(a, b)
							local percentage_a = a.extension:percentage_through_level()
							local percentage_b = b.extension:percentage_through_level()

							return math.abs(percentage_through_level - percentage_a) < math.abs(percentage_through_level - percentage_b)
						end

						table.sort(section_spawners, _compare_relative_spawner_position)
					end

					for k = 1, num_available_section_spawners do
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

			for j = 1, num_used_spawners do
				local spawner_unit = used_spawners[j]
				local index = table.find(usable_spawners, spawner_unit)

				table.remove(usable_spawners, index)
			end
		end

		if spawn_debt > 0 then
			local num_pickups_to_spawn = #pickups_to_spawn

			if #usable_spawners > 0 then
				self:_shuffle(usable_spawners)

				for i = 1, num_pickups_to_spawn do
					local num_pickup_spawners = #usable_spawners

					for j = 1, num_pickup_spawners do
						local spawner, pickup_index = self:_check_spawn(usable_spawners[j], pickup_type)

						if spawner then
							table.remove(usable_spawners, j)
							table.remove(pickups_to_spawn, pickup_index)

							num_pickups_to_spawn = num_pickups_to_spawn - 1

							break
						end
					end
				end
			end
		end
	end
end

PickupSystem._check_spawn = function (self, spawner, pickup_type)
	local num_pickups_to_spawn = #pickups_to_spawn
	local spawner_extension = spawner.extension
	local component_index = spawner.index

	for i = 1, num_pickups_to_spawn do
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
	local pickup_settings = PICKUPS_BY_NAME[pickup_name]
	local unit_template_name = pickup_settings.unit_template_name
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

	for i = 1, num_spawned_pickups do
		local unit = spawned_pickups[i]

		if ALIVE[unit] and unit == pickup_unit then
			unit_spawner_manager:mark_for_deletion(unit)

			deleted_index = i

			break
		end
	end

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
end

PickupSystem.get_collected_materials = function (self)
	return self._material_collected
end

return PickupSystem
