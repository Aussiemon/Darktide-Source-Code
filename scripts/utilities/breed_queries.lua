-- chunkname: @scripts/utilities/breed_queries.lua

local Breed = require("scripts/utilities/breed")
local Breeds = require("scripts/settings/breed/breeds")
local minion_list = {}
local minion_list_by_name = {}

for name, breed in pairs(Breeds) do
	if Breed.is_minion(breed) then
		minion_list[#minion_list + 1] = breed
		minion_list_by_name[name] = breed
	end
end

local BreedQueries = {}

BreedQueries.match_minions_by_tags = function (template_breed_tags, optional_excluded_breed_tags, wanted_sub_faction)
	local best_breeds = {}
	local num_template_breed_tags = #template_breed_tags

	for i = 1, #minion_list do
		repeat
			local breed = minion_list[i]
			local sub_faction = breed.sub_faction_name

			if not breed.can_be_used_for_all_factions and sub_faction ~= wanted_sub_faction then
				break
			end

			local minion_breed_tags = breed.tags

			if optional_excluded_breed_tags then
				local is_excluded = false

				for h = 1, #optional_excluded_breed_tags do
					local excluded_tag = optional_excluded_breed_tags[h]

					if minion_breed_tags[excluded_tag] then
						is_excluded = true

						break
					end
				end

				if is_excluded then
					break
				end
			end

			for j = 1, num_template_breed_tags do
				local tags = template_breed_tags[j]
				local has_all_tags = true

				for k = 1, #tags do
					local tag = tags[k]

					if not minion_breed_tags[tag] then
						has_all_tags = false

						break
					end
				end

				if has_all_tags then
					best_breeds[#best_breeds + 1] = breed
				end
			end
		until true
	end

	return best_breeds
end

local affordable_breeds = {}

BreedQueries.pick_random_minion_by_points = function (minion_breeds, points)
	table.clear_array(affordable_breeds, #affordable_breeds)

	for i = 1, #minion_breeds do
		local breed = minion_breeds[i]
		local cost = breed.point_cost

		if cost and cost <= points then
			affordable_breeds[#affordable_breeds + 1] = breed
		end
	end

	if #affordable_breeds > 0 then
		local breed_index = math.random(#affordable_breeds)
		local breed = affordable_breeds[breed_index]
		local cost = breed.point_cost
		local amount = math.round(points / cost)

		return breed, amount
	end
end

BreedQueries.add_spawns_single_breed = function (spawners, breed_name, breed_amount, spawn_side_id, target_side_id, spawned_minion_data, optional_mission_objective_id, optional_attack_selection_template_name, optional_aggro_state, optional_group_id, optional_max_health_modifier, optional_spawn_delay)
	local num_spawners = #spawners
	local breed_lists = {}
	local breed_index = 1

	while breed_index <= breed_amount do
		local spawner_index = (breed_index - 1) % num_spawners + 1
		local breed_list = breed_lists[spawner_index]

		if breed_list then
			breed_list[#breed_list + 1] = breed_name
		else
			breed_lists[spawner_index] = {
				breed_name,
			}
		end

		breed_index = breed_index + 1
	end

	local spawner_queue_id = spawned_minion_data.spawner_queue_id

	if not spawner_queue_id then
		spawner_queue_id = Script.new_map(num_spawners)
		spawned_minion_data.spawner_queue_id = spawner_queue_id
	end

	for i = 1, #breed_lists do
		local spawner = spawners[i]
		local param_table = spawner:request_param_table()

		param_table.target_side_id = target_side_id
		param_table.spawn_delay = optional_spawn_delay
		param_table.mission_objective_id = optional_mission_objective_id
		param_table.group_id = optional_group_id
		param_table.attack_selection_template_name = optional_attack_selection_template_name
		param_table.aggro_state = optional_aggro_state
		param_table.max_health_modifier = optional_max_health_modifier

		local queue_id = spawner:add_spawns(breed_lists[i], spawn_side_id, param_table)
		local queue_ids = spawner_queue_id[spawner]

		if queue_ids then
			queue_ids[#queue_ids + 1] = queue_id
		else
			spawner_queue_id[spawner] = {
				queue_id,
			}
		end
	end
end

BreedQueries.minion_breeds = function ()
	return minion_list_by_name
end

return BreedQueries
