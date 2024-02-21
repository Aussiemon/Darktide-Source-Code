require("scripts/extension_systems/pickups/pickup_spawner_extension")

local Ammo = require("scripts/utilities/ammo")
local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local Health = require("scripts/utilities/health")
local Pickups = require("scripts/settings/pickup/pickups")
local PickupSettings = require("scripts/settings/pickup/pickup_settings")
local TextUtilities = require("scripts/utilities/ui/text")
local UISettings = require("scripts/settings/ui/ui_settings")
local DISTRIBUTION_TYPES = PickupSettings.distribution_types
local PICKUPS_BY_NAME = Pickups.by_name
local PICKUP_SELECTOR = PickupSettings.pickup_selector
local PickupSystem = class("PickupSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_player_collected_materials"
}

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
	self._pickup_to_owner_player = {}
	self._pickup_to_interactors = {}
	self._pickup_spawner_extensions = {}
	self._managed_spawner_extensions = {}
	self._rubberband_pool = nil
	self._rubberband_pool_start_count = {}
	self._rubberband_pool_remaining = {}
	self._rubberband_pool_special_spawned = {}
	self._rubberband_free_spots = 0

	if not is_server then
		local network_event_delegate = context.network_event_delegate
		self._network_event_delegate = network_event_delegate

		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

PickupSystem.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end
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

		self:_create_game_object()
	end
end

PickupSystem._create_game_object = function (self)
	local game_object_data_table = {
		plasteel_small = 0,
		diamantine_small = 0,
		plasteel_large = 0,
		diamantine_large = 0,
		game_object_type = NetworkLookup.game_object_types.materials_collected
	}
	local game_session = self._game_session
	self._materials_collected_game_object_id = GameSession.create_game_object(game_session, "materials_collected", game_object_data_table)
end

PickupSystem.on_game_object_created = function (self, game_object_id)
	self._materials_collected_game_object_id = game_object_id
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

PickupSystem._shuffle = function (self, source, seed)
	return table.shuffle(source, seed)
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
				pickup[pickup_name] = count[difficulty] or count[#count]
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
			self._seed = self:_spawn_spread_pickups(distribution_type, pickup_settings, self._seed)
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
		local time = Managers.backend:get_server_time(0) / 1000
		local seed = os.date("%Y", time) * 55 + os.date("%V", time)

		self:_spawn_spread_pickups(DISTRIBUTION_TYPES.side_mission, side_settings, seed)
	end
end

local function _current_grenade_percentage(player_unit)
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

	if max_grenade_charges <= 0 then
		return 1
	end

	local remaining_grenade_charges = ability_extension:remaining_ability_charges(ABILITY_TYPE)

	return remaining_grenade_charges / max_grenade_charges
end

local function lerp(a, b, t)
	return a + (b - a) * t
end

local weights = {}
local SLOT_POCKETABLE = "slot_pocketable"
local SLOT_POCKETABLE_SMALL = "slot_pocketable_small"

PickupSystem.get_rubberband_pickup = function (self, distribution_type, percentage_through_level)
	local AMMO = 1
	local GRENADE = 2
	local HEALTH = 3
	local WOUNDS = 4
	local STIMM = 5
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
	local total_permanent_health = 0
	local pocketables_space = 0
	local pocketables_small_space = 0
	local pool_size = 0

	for _, player in pairs(players) do
		local player_unit = player.player_unit

		if player_unit then
			player_count = player_count + 1
			total_ammo = total_ammo + 1 - Ammo.current_total_percentage(player_unit)
			total_grenades = total_grenades + 1 - _current_grenade_percentage(player_unit)
			total_health = total_health + 1 - Health.current_health_percent(player_unit)
			total_permanent_health = total_permanent_health + Health.permanent_damage_taken_percent(player_unit)
			local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
			local inventory_component = unit_data_extension:read_component("inventory")
			local item_name = inventory_component[SLOT_POCKETABLE]

			if item_name == "not_equipped" then
				pocketables_space = pocketables_space + 1
			end

			local item_small_name = inventory_component[SLOT_POCKETABLE_SMALL]

			if item_small_name == "not_equipped" then
				pocketables_small_space = pocketables_small_space + 1
			end
		end
	end

	local pocketable_weight = lerp(RubberbandSettings.pocketable_weight.min, RubberbandSettings.pocketable_weight.max, pocketables_space / 4)
	local pocketable_small_weight = lerp(RubberbandSettings.pocketable_small_weight.min, RubberbandSettings.pocketable_small_weight.max, pocketables_small_space / 4)
	local min, max = unpack(RubberbandSettings.status_weight[distribution_type])
	local block_distance = RubberbandSettings.special_block_distance
	local block_distance_short = RubberbandSettings.special_block_distance_short

	table.clear(weights)

	local remaining_ammo = remaining.ammo or 0

	if remaining_ammo > 0 then
		pool_size = remaining_ammo
		weights[AMMO] = remaining_ammo / start_count.ammo * (RubberbandSettings.distribution_type_weight.ammo[distribution_type] or 1) * lerp(min, max, total_ammo / player_count)
	else
		weights[AMMO] = 0
	end

	local remaining_grenade = remaining.grenade or 0
	local grenade_special_spawned = special_spawned.small_grenade

	if remaining_grenade > 0 and (not grenade_special_spawned or percentage_through_level >= grenade_special_spawned + block_distance) then
		pool_size = pool_size + remaining_grenade
		weights[GRENADE] = remaining_grenade / start_count.grenade * (RubberbandSettings.distribution_type_weight.grenade[distribution_type] or 1) * lerp(min, max, total_grenades / player_count)
	else
		weights[GRENADE] = 0
	end

	local remaining_health = remaining.health or 0
	local health_special_spawned = special_spawned.medical_crate_pocketable
	local syringe_coruption_special_spawned = special_spawned.syringe_corruption_pocketable
	local medcrate_blocked_by_distance = health_special_spawned and percentage_through_level < health_special_spawned + block_distance or syringe_coruption_special_spawned and percentage_through_level < syringe_coruption_special_spawned + block_distance_short

	if remaining_health > 0 and not medcrate_blocked_by_distance then
		pool_size = pool_size + remaining_health
		weights[HEALTH] = remaining_health / start_count.health * (RubberbandSettings.distribution_type_weight.health[distribution_type] or 1) * lerp(min, max, total_health / player_count) * pocketable_weight
	else
		weights[HEALTH] = 0
	end

	local remaining_wounds = remaining.wounds or 0
	local syringe_blocked_by_distance = syringe_coruption_special_spawned and percentage_through_level < syringe_coruption_special_spawned + block_distance or health_special_spawned and percentage_through_level < health_special_spawned + block_distance_short

	if remaining_wounds > 0 and not syringe_blocked_by_distance then
		pool_size = pool_size + remaining_wounds
		local syringe_wounds_lerp = total_permanent_health / player_count
		weights[WOUNDS] = remaining_wounds / start_count.wounds * (RubberbandSettings.distribution_type_weight.wounds[distribution_type] or 1) * lerp(min, max, syringe_wounds_lerp) * pocketable_small_weight
	else
		weights[WOUNDS] = 0
	end

	local remaining_stimms = remaining.stimms or 0
	local syringe_stimm_special_spawned = special_spawned.syringe_stimm_pocketable

	if remaining_stimms > 0 and (not syringe_stimm_special_spawned or percentage_through_level >= syringe_stimm_special_spawned + block_distance * 0.5) then
		pool_size = pool_size + remaining_stimms
		local syring_stimms_lerp_value = 0.5
		weights[STIMM] = remaining_stimms / start_count.stimms * (RubberbandSettings.distribution_type_weight.stimms[distribution_type] or 1) * lerp(min, max, syring_stimms_lerp_value) * pocketable_small_weight
	else
		weights[STIMM] = 0
	end

	if pool_size <= 0 then
		return nil
	end

	local total_weight = 0

	for i = 1, #weights do
		total_weight = total_weight + weights[i]
		weights[i] = total_weight
	end

	total_weight = self._rubberband_free_spots / pool_size / RubberbandSettings.base_spawn_rate
	self._rubberband_free_spots = self._rubberband_free_spots - 1
	local new_seed, rnd = math.next_random(self._seed)
	self._seed = new_seed
	rnd = rnd * math.max(total_weight, 1)

	if rnd <= weights[AMMO] then
		pool = pool.ammo
		local SMALL_CLIP = 1
		local LARGE_CLIP = 2
		local AMMO_CACHE = 3

		table.clear(weights)

		weights[SMALL_CLIP] = math.sqrt(pool.small_clip) / (total_ammo + 0.01)
		weights[LARGE_CLIP] = math.sqrt(pool.large_clip)
		local ammo_special_spawned = special_spawned.ammo_cache_pocketable

		if not ammo_special_spawned or percentage_through_level >= ammo_special_spawned + block_distance then
			weights[AMMO_CACHE] = math.sqrt(pool.ammo_cache_pocketable) * total_ammo * pocketable_weight
		end

		total_weight = 0

		for i = 1, #weights do
			total_weight = total_weight + weights[i]
			weights[i] = total_weight
		end

		if total_weight <= 0 then
			return nil
		end

		self._seed, rnd = math.next_random(self._seed)
		rnd = rnd * total_weight
		remaining.ammo = remaining.ammo - 1

		if rnd <= weights[SMALL_CLIP] then
			pool.small_clip = pool.small_clip - 1

			return "small_clip"
		elseif rnd <= weights[LARGE_CLIP] then
			pool.large_clip = pool.large_clip - 1

			return "large_clip"
		else
			pool.ammo_cache_pocketable = pool.ammo_cache_pocketable - 1
			special_spawned.ammo_cache_pocketable = percentage_through_level

			return "ammo_cache_pocketable"
		end
	elseif rnd <= weights[GRENADE] then
		remaining.grenade = remaining.grenade - 1
		pool.grenade.small_grenade = pool.grenade.small_grenade - 1
		special_spawned.small_grenade = percentage_through_level

		return "small_grenade"
	elseif rnd <= weights[HEALTH] then
		remaining.health = remaining.health - 1
		pool.health.medical_crate_pocketable = pool.health.medical_crate_pocketable - 1
		special_spawned.medical_crate_pocketable = percentage_through_level

		return "medical_crate_pocketable"
	elseif rnd <= weights[WOUNDS] then
		remaining.wounds = remaining.wounds - 1
		pool.wounds.syringe_corruption_pocketable = pool.wounds.syringe_corruption_pocketable - 1
		special_spawned.syringe_corruption_pocketable = percentage_through_level

		return "syringe_corruption_pocketable"
	elseif rnd <= weights[STIMM] then
		local syringe_stimm_select_func = PICKUP_SELECTOR.syringe_generic_pocketable
		local selected_stimm_syringe_name, new_seed = syringe_stimm_select_func(self._seed)
		self._seed = new_seed
		remaining.stimms = remaining.stimms - 1
		pool.stimms.syringe_generic_pocketable = pool.stimms.syringe_generic_pocketable - 1
		special_spawned.syringe_stimm_pocketable = percentage_through_level

		return selected_stimm_syringe_name
	else
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

PickupSystem._spawn_spread_pickups = function (self, distribution_type, pickup_pool, seed)
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

			seed = self:_shuffle(removal_options, seed)

			for i = direct_spawners_to_remove + 1, initial_usable_spawners do
				removal_options[i] = nil
			end

			table.sort(removal_options)

			for i = #removal_options, 1, -1 do
				table.remove(usable_spawners, removal_options[i])
			end
		end
	end

	local spawners_after_chest_remove = #usable_spawners

	for pickup_type, value in pairs(pickup_pool) do
		table.clear(pickups_to_spawn)

		for pickup_name, amount in pairs(value) do
			for i = 1, amount do
				local selected_pickup_name = pickup_name
				local selector_func = PICKUP_SELECTOR[pickup_name]

				if selector_func then
					selected_pickup_name, seed = selector_func(seed)
				end

				pickups_to_spawn[#pickups_to_spawn + 1] = selected_pickup_name
			end
		end

		seed = self:_shuffle(pickups_to_spawn, seed)
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
				seed = self:_shuffle(section_spawners, seed)
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
				seed = self:_shuffle(usable_spawners, seed)

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

	for i = 1, #usable_spawners do
		if usable_spawners[i].chest then
			self._rubberband_free_spots = self._rubberband_free_spots + 1
		end
	end

	return seed
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
	return self._pickup_to_owner[pickup_unit], self._pickup_to_owner_player[pickup_unit]
end

PickupSystem.has_interacted = function (self, pickup_unit, player_session_id)
	local interactors = self._pickup_to_interactors[pickup_unit]

	return table.array_contains(interactors, player_session_id)
end

PickupSystem.spawn_pickup = function (self, pickup_name, position, rotation, optional_pickup_spawner, optional_placed_on_unit, optional_spawn_interaction_cooldown, optional_origin_player)
	local pickup_settings = PICKUPS_BY_NAME[pickup_name]
	local unit_template_name = pickup_settings.unit_template_name
	local unit_name = pickup_settings.unit_name

	if pickup_settings.spawn_offset then
		local spawn_offset = pickup_settings.spawn_offset:unbox()
		position = position + Quaternion.rotate(rotation, spawn_offset)
	end

	local pickup_unit, pickup_unit_go_id = Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template_name, position, rotation, nil, pickup_settings, optional_placed_on_unit, optional_spawn_interaction_cooldown, optional_origin_player)
	self._spawned_pickups[#self._spawned_pickups + 1] = pickup_unit
	self._pickup_to_interactors[pickup_unit] = {}

	if optional_pickup_spawner then
		self._pickup_to_spawner[pickup_unit] = optional_pickup_spawner
	end

	return pickup_unit, pickup_unit_go_id
end

PickupSystem.player_spawn_pickup = function (self, pickup_name, position, rotation, player, player_session_id, placed_on_unit)
	local pickup_unit, pickup_unit_go_id = self:spawn_pickup(pickup_name, position, rotation, nil, placed_on_unit, nil, player)
	self._pickup_to_owner[pickup_unit] = player_session_id
	self._pickup_to_owner_player[pickup_unit] = player

	return pickup_unit, pickup_unit_go_id
end

PickupSystem.despawn_pickup = function (self, pickup_unit)
	local unit_spawner_manager = Managers.state.unit_spawner
	local spawned_pickups = self._spawned_pickups
	local num_spawned_pickups = #spawned_pickups
	self._pickup_to_spawner[pickup_unit] = nil
	self._pickup_to_owner[pickup_unit] = nil
	self._pickup_to_owner_player[pickup_unit] = nil
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

	local player = Managers.player:player_by_unit(interactor_unit)

	if player then
		local amount = Managers.backend:session_setting("craftingMaterials", type, size, "value")

		Managers.stats:record_private("hook_collect_material", player, type, amount)
	end

	local player = Managers.state.player_unit_spawn:owner(interactor_unit)

	if player then
		local peer_id = player:peer_id()
		local material_type_lookup = NetworkLookup.material_type_lookup[type]
		local material_size_lookup = NetworkLookup.material_size_lookup[size]

		Managers.state.game_session:send_rpc_clients("rpc_player_collected_materials", peer_id, material_type_lookup, material_size_lookup)

		if not DEDICATED_SERVER then
			self:_show_collected_materials_notification(peer_id, type, size)
		end
	end

	local game_session = self._game_session
	local game_object_id = self._materials_collected_game_object_id
	local game_object_field = type .. "_" .. size

	if GameSession.has_game_object_field(game_session, game_object_id, game_object_field) then
		local value = type_list[size]

		GameSession.set_game_object_field(game_session, game_object_id, game_object_field, value)
		Log.info("PickupSystem", "register_material_collected %s %s", game_object_field, value)
	else
		Log.error("PickupSystem", "Unknown game_object_field %s in materials_collected", game_object_field)
	end
end

PickupSystem.rpc_player_collected_materials = function (self, channel_id, peer_id, material_type_lookup, material_size_lookup)
	local material_type = NetworkLookup.material_type_lookup[material_type_lookup]
	local material_size = NetworkLookup.material_size_lookup[material_size_lookup]

	self:_show_collected_materials_notification(peer_id, material_type, material_size)
end

PickupSystem._show_collected_materials_notification = function (self, peer_id, material_type, material_size)
	local player_manager = Managers.player
	local local_player_id = 1
	local player = player_manager:player(peer_id, local_player_id)
	local player_name = player and player:name()
	local player_slot = player and player.slot and player:slot()
	local player_slot_colors = UISettings.player_slot_colors
	local player_slot_color = player_slot and player_slot_colors[player_slot]

	if player_name and player_slot_color then
		player_name = TextUtilities.apply_color_to_text(player_name, player_slot_color)
	end

	local optional_localization_key = "loc_tactical_overlay_crafting_mat_notification"

	Managers.event:trigger("event_add_notification_message", "currency", {
		currency = material_type,
		amount_size = material_size,
		player_name = player_name,
		optional_localization_key = optional_localization_key
	})
end

PickupSystem.get_collected_materials = function (self)
	if not self._is_server then
		local game_session = self._game_session
		local game_object_id = self._materials_collected_game_object_id
		local diamantine_small = GameSession.game_object_field(game_session, game_object_id, "diamantine_small")
		local diamantine_large = GameSession.game_object_field(game_session, game_object_id, "diamantine_large")
		local plasteel_small = GameSession.game_object_field(game_session, game_object_id, "plasteel_small")
		local plasteel_large = GameSession.game_object_field(game_session, game_object_id, "plasteel_large")
		self._material_collected.diamantine = {
			small = diamantine_small,
			large = diamantine_large
		}
		self._material_collected.plasteel = {
			small = plasteel_small,
			large = plasteel_large
		}
	end

	return self._material_collected
end

return PickupSystem
