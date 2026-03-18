-- chunkname: @scripts/utilities/expeditions/expedition_pickup_distribution.lua

local ExpeditionPickupDistribution = {}
local REWARD_DISTRIBUTION = "reward"
local BONUS_REWARD_DISTRIBUTION = "bonus_reward"
local REWARD_POOL = {}

ExpeditionPickupDistribution.pre_populate_pickups_setup = function (expedition_template, location, pickup_spawners)
	local seed = 1
	local loot_settings = expedition_template.loot_settings
	local pickup_system = Managers.state.extension:system("pickup_system")

	local function _random(...)
		local value

		seed, value = math.next_random(seed, ...)

		return value
	end

	local levels_bonus_spawner_group = {}
	local levels_spawn_spots = {}
	local levels_spawner_group = {}
	local levels_chest_spots = {}

	for i = 1, #pickup_spawners do
		local spawner_extension = pickup_spawners[i]
		local spawner_unit = spawner_extension:unit()
		local level = Unit.level(spawner_unit)
		local bonus_spawn_spots = spawner_extension:free_spawner_count(BONUS_REWARD_DISTRIBUTION)

		if bonus_spawn_spots > 0 then
			local node_list = levels_bonus_spawner_group[level]

			if node_list then
				node_list[#node_list + 1] = spawner_extension
			else
				node_list = {
					spawner_extension,
				}
				levels_bonus_spawner_group[level] = node_list
			end
		end

		local spawn_spots = spawner_extension:free_spawner_count(REWARD_DISTRIBUTION)

		if spawn_spots > 0 then
			levels_spawn_spots[level] = (levels_spawn_spots[level] or 0) + spawn_spots

			if spawner_extension:is_chest() then
				levels_chest_spots[level] = (levels_chest_spots[level] or 0) + spawn_spots
			end

			local node_list = levels_spawner_group[level]

			if node_list then
				node_list[#node_list + 1] = spawner_extension
			else
				node_list = {
					spawner_extension,
				}
				levels_spawner_group[level] = node_list
			end
		end
	end

	local levels_data = location.levels_data
	local total_reward_amount = 0
	local levels_reward_amount = {}
	local levels_pool = {}
	local location_multiplier = loot_settings.reward_location_multipliers[math.min(location.index, #loot_settings.reward_location_multipliers)]
	local difficulty_multiplier = Managers.state.difficulty:get_table_entry_by_challenge(loot_settings.reward_difficulty_multipliers)

	for i = 1, #levels_data do
		local level_data = levels_data[i]
		local level = level_data.level
		local spawn_spots = levels_spawn_spots[level]

		if spawn_spots and spawn_spots > 0 then
			local loot_value = loot_settings.reward_base_budget
			local level_tags = level_data.tags
			local tag_multiplier = 1

			if level_tags then
				local tag_modifiers = loot_settings.reward_tag_budget_modifiers

				for j = 1, #level_tags do
					local tag = level_tags[j]
					local tag_modifier = tag_modifiers[tag]

					if tag_modifier then
						if tag == "type_traversal" then
							tag_multiplier = 1 + _random(tag_modifier.min * 100, tag_modifier.max * 100) / 100

							break
						end

						tag_multiplier = tag_multiplier + _random(tag_modifier.min * 100, tag_modifier.max * 100) / 100
					end
				end
			end

			local level_reward = loot_value * (tag_multiplier + location_multiplier) * difficulty_multiplier

			levels_reward_amount[level] = level_reward
			levels_pool[level] = {}
			total_reward_amount = total_reward_amount + level_reward
		end
	end

	local location_index = location.index

	if total_reward_amount > 0 then
		local type_settings = loot_settings.settings_by_type

		for type, setting in pairs(type_settings) do
			local bonus_spawn = setting.bonus_spawn_per_location

			if bonus_spawn then
				local tiers = #type_settings[type].values_per_tier
				local tier = math.min(location_index, tiers)
				local amount = _random(bonus_spawn.min, bonus_spawn.max)

				for i = 1, amount do
					local ticket = _random(1, total_reward_amount)
					local tickets_passed = 0

					for level, reward in pairs(levels_reward_amount) do
						tickets_passed = tickets_passed + reward

						if ticket <= tickets_passed then
							local pickup_name = string.format(loot_settings.pickup_name_format, type, tier)
							local pool = levels_pool[level]

							pool[pickup_name] = (pool[pickup_name] or 0) + 1

							break
						end
					end
				end
			end
		end
	end

	local small_value_by_tier = loot_settings.settings_by_type.small.values_per_tier
	local higest_small_tier = #small_value_by_tier
	local force_low_treshhold = (small_value_by_tier[1] + small_value_by_tier[2]) / 2
	local force_high_treshhold = (small_value_by_tier[higest_small_tier - 1] + small_value_by_tier[higest_small_tier]) / 2

	for level, reward in pairs(levels_reward_amount) do
		local pool = levels_pool[level]

		REWARD_POOL.pool = pool

		local bonus_spawners = levels_bonus_spawner_group[level]

		if not bonus_spawners then
			Log.error("ExpeditionPickupDistribution", "Trying to spawn bonus on %s, but there are no bonus spawners", level)
		elseif not table.is_empty(bonus_spawners) then
			seed = pickup_system:spawn_spread_pickups(bonus_spawners, BONUS_REWARD_DISTRIBUTION, REWARD_POOL, seed)
		end

		table.clear(pool)

		local pickups_to_spawn = levels_chest_spots[level] or 0
		local free_spots = levels_spawn_spots[level]
		local pickups_per_tier = {}

		for j = 1, higest_small_tier do
			pickups_per_tier[j] = 0
		end

		while free_spots > 0 and reward > 0 do
			local tier

			if pickups_to_spawn == 1 then
				tier = 1

				for j = higest_small_tier, 2, -1 do
					if reward >= small_value_by_tier[j - 1] then
						tier = j

						break
					end
				end
			else
				local highest_cost = reward / (pickups_to_spawn - 1)
				local lowest_cost = reward / free_spots

				if force_high_treshhold <= lowest_cost then
					tier = higest_small_tier
				elseif highest_cost <= force_low_treshhold then
					tier = 1
				else
					local cost = _random(lowest_cost, highest_cost)

					tier = 1

					for j = higest_small_tier, 2, -1 do
						if cost >= small_value_by_tier[j] then
							tier = j

							break
						end
					end
				end
			end

			pickups_per_tier[tier] = pickups_per_tier[tier] + 1
			pickups_to_spawn = pickups_to_spawn - 1
			free_spots = free_spots - 1
			reward = reward - small_value_by_tier[tier]
		end

		if pickups_to_spawn > 0 then
			Log.error("ExpeditionPickupDistribution", "Too many reward slots for opportunity: %s, %s empty slots", level, pickups_to_spawn)
		end

		if reward > 0 then
			Log.error("ExpeditionPickupDistribution", "Not enough reward slots for opportunity: %s, %s loot value left", level, reward)
		end

		for j = 1, #pickups_per_tier do
			pool[string.format(loot_settings.pickup_name_format, "small", j)] = pickups_per_tier[j]
		end

		local spawners = levels_spawner_group[level]

		seed = table.shuffle(spawners, seed)

		local i = #spawners

		while free_spots > 0 and i > 0 do
			if not spawners[i]:is_chest() then
				table.remove(spawners, i)

				free_spots = free_spots - 1
			end

			i = i - 1
		end

		seed = pickup_system:spawn_spread_pickups(spawners, REWARD_DISTRIBUTION, REWARD_POOL, seed)
	end
end

local function add_ambient_from_settings(return_pool, settings, location_index)
	local seed = 1

	if not settings.ambient_budgets_per_difficulty then
		return
	end

	local function _random(...)
		local value

		seed, value = math.next_random(seed, ...)

		return value
	end

	local type_settings = settings.settings_by_type
	local ambient_location_multiplier = settings.ambient_location_multipliers[location_index]
	local weight_settings = settings.ambient_distribution_weights
	local total_value = Managers.state.difficulty:get_table_entry_by_challenge(settings.ambient_budgets_per_difficulty) * _random(ambient_location_multiplier.min * 100, ambient_location_multiplier.max * 100) / 100
	local remaining_pool_value = total_value
	local loot_per_pool = {}

	local function add_pickup(type, tier, pool)
		local loot_name = string.format(settings.pickup_name_format, type, tier)

		if not return_pool[pool] then
			return_pool[pool] = {
				expedition_loot = {},
			}
		end

		local expedition_loot = return_pool[pool].expedition_loot
		local count_table = expedition_loot[loot_name]

		if not count_table then
			count_table = {
				0,
			}
			expedition_loot[loot_name] = count_table
		end

		count_table[1] = count_table[1] + 1
	end

	local function add_pickup_without_pool(type, tier)
		local rnd_val = _random(remaining_pool_value)
		local val = 0
		local selected_pool

		for pool, value in pairs(loot_per_pool) do
			val = val + value

			if rnd_val <= val then
				selected_pool = pool

				break
			end
		end

		if not selected_pool then
			Log.error("ExpeditionPickupDistribution", "Failed to find pool for %s, skipped spawning", type)

			return
		end

		add_pickup(type, tier, selected_pool)

		local type_cost_table = type_settings[type].values_per_tier
		local cost = type_cost_table[tier]

		loot_per_pool[selected_pool] = loot_per_pool[selected_pool] - cost

		if loot_per_pool[selected_pool] < 0 then
			loot_per_pool[selected_pool] = nil
		end

		remaining_pool_value = remaining_pool_value - cost
	end

	local loot_weight_per_source = weight_settings.by_source
	local pool_weights = {}
	local total_pool_weight = 0

	for pool, range in pairs(loot_weight_per_source) do
		local pool_weight = _random(range.min, range.max)

		pool_weights[pool] = pool_weight
		total_pool_weight = total_pool_weight + pool_weight
	end

	for pool, range in pairs(pool_weights) do
		loot_per_pool[pool] = total_value * (pool_weights[pool] / total_pool_weight)
	end

	remaining_pool_value = total_value

	local loot_weight_per_tier = weight_settings.by_tier
	local quality_weights = Script.new_array(#loot_weight_per_tier)
	local total_weight = 0

	for i = 1, #loot_weight_per_tier do
		local range = loot_weight_per_tier[i]
		local quality_weight = _random(range.min, range.max)

		quality_weights[i] = quality_weight
		total_weight = total_weight + quality_weight
	end

	local remaining_value_per_tier = Script.new_array(#quality_weights)

	for i = 1, #quality_weights do
		remaining_value_per_tier[i] = quality_weights[i] / total_weight * total_value
	end

	local defined_types = {}
	local pickup_type_to_distribute = {}
	local undefined_types = {}
	local types = settings.types

	for i = 1, #types do
		local type = types[i]
		local range = type_settings[type].limit_per_location

		if range then
			local amount = _random(range.min, range.max)

			if amount > 0 then
				defined_types[#defined_types + 1] = type
				pickup_type_to_distribute[type] = amount
			end
		else
			undefined_types[#undefined_types + 1] = type
		end
	end

	while true do
		local defined_types_count = #defined_types

		if defined_types_count > 0 then
			local type_index = _random(1, defined_types_count)
			local type = defined_types[type_index]
			local left_to_spawn = pickup_type_to_distribute[type]
			local tier = _random(1, #remaining_value_per_tier)
			local type_cost_table = type_settings[type].values_per_tier
			local added = false

			for i = tier, 1, -1 do
				local cost = type_cost_table[i]

				if cost <= remaining_value_per_tier[i] then
					added = true
					tier = i

					break
				end
			end

			if not added then
				Log.error("ExpeditionPickupDistribution", "Failed to add %s loot, too expensive to add", type)
			else
				remaining_value_per_tier[tier] = remaining_value_per_tier[tier] - type_cost_table[tier]

				add_pickup_without_pool(type, tier)
			end

			pickup_type_to_distribute[type] = left_to_spawn - 1

			if left_to_spawn == 1 then
				table.remove(defined_types, type_index)
			end
		elseif #undefined_types > 0 then
			local tier = 1
			local highest_value = remaining_value_per_tier[1]

			for i = 2, #remaining_value_per_tier do
				local tier_value = remaining_value_per_tier[i]

				if highest_value < tier_value then
					tier = i
					highest_value = tier_value
				end
			end

			local type_index = _random(1, #undefined_types)
			local type = undefined_types[type_index]
			local type_cost_table = type_settings[type].values_per_tier
			local added = false

			for i = tier, 1, -1 do
				local cost = type_cost_table[i]

				if cost <= remaining_value_per_tier[i] then
					added = true
					tier = i

					break
				end
			end

			if not added then
				break
			else
				remaining_value_per_tier[tier] = remaining_value_per_tier[tier] - type_cost_table[tier]

				add_pickup_without_pool(type, tier)
			end
		else
			Log.error("ExpeditionPickupDistribution", "Unable to spawn remaning loot value, there are no undefined_types")

			break
		end
	end
end

ExpeditionPickupDistribution.get_additional_pickups = function (expedition_template, location_index)
	local return_pool = {}

	add_ambient_from_settings(return_pool, expedition_template.loot_settings, location_index)
	add_ambient_from_settings(return_pool, expedition_template.scrap_settings, location_index)

	return return_pool
end

return ExpeditionPickupDistribution
