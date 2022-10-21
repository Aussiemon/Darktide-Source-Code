local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local PatrolSettings = require("scripts/settings/roamer/patrol_settings")
local MinionPatrols = {
	get_follow_index = function (index)
		local is_right_side = (index + 1) % 3 == 0
		local is_left_side = index % 3 == 0
		local is_third = (index - 1) % 3 == 0
		local follow_index = is_right_side and index - 1 or is_left_side and index - 2 or is_third and index - 3

		return follow_index, is_right_side, is_left_side, is_third
	end
}

MinionPatrols.update_roamer_patrols = function (patrol_data, roamers, nav_world, zones)
	local patrols = patrol_data.patrols
	local active_patrols = patrol_data.active_patrols
	local claimed_patrol_zone_indexes = patrol_data.claimed_patrol_zone_indexes

	if patrol_data.astar_roamer_unit then
		local astar = patrol_data.astar
		local astar_roamer = patrol_data.astar_roamer
		local astar_roamer_unit = patrol_data.astar_roamer_unit
		local done = GwNavAStar.processing_finished(astar)

		if not done then
			return
		end

		local leader_blackboard = BLACKBOARDS[astar_roamer_unit]

		if not HEALTH_ALIVE[astar_roamer_unit] or not leader_blackboard then
			patrol_data.astar_roamer_unit = nil

			MinionPatrols.release_patrol_zone_location(claimed_patrol_zone_indexes, astar_roamer)

			return
		end

		local patrol_component = Blackboard.write_component(leader_blackboard, "patrol")
		local path_found = GwNavAStar.path_found(astar)

		if not path_found then
			patrol_data.astar_roamer_unit = nil
			patrol_data.num_failed_atar_times = patrol_data.num_failed_atar_times and patrol_data.num_failed_atar_times + 1 or 1

			if PatrolSettings.max_num_failed_astar_queries < patrol_data.num_failed_atar_times then
				local patrol_id = patrol_component.patrol_id
				active_patrols[patrol_id] = nil
				patrol_data.num_failed_atar_times = 0

				MinionPatrols.release_patrol_zone_location(claimed_patrol_zone_indexes, astar_roamer)
			end

			return
		end

		local patrol_to_position = patrol_data.astar_roamer_position:unbox()

		patrol_component.walk_position:store(patrol_to_position)

		patrol_component.should_patrol = true
		local patrol_id = patrol_component.patrol_id
		local patrol = patrols[patrol_id]

		for i = 1, #patrol do
			local roamer_id = patrol[i]
			local patrol_roamer = roamers[roamer_id]
			local patrol_spawned_unit = patrol_roamer.spawned_unit
			local other_blackboard = BLACKBOARDS[patrol_spawned_unit]

			if not other_blackboard then
				patrol_data.astar_roamer_unit = nil
				patrol_component.should_patrol = false

				return
			end

			local other_patrol_component = Blackboard.write_component(other_blackboard, "patrol")

			if i == 1 then
				other_patrol_component.patrol_leader_unit = patrol_spawned_unit
				other_patrol_component.patrol_index = i
				other_patrol_component.should_patrol = true
			else
				local follow_index = MinionPatrols.get_follow_index(i)
				local follow_roamer_id = patrol[follow_index]
				local follow_patrol_roamer = roamers[follow_roamer_id]
				local follow_patrol_spawned_unit = follow_patrol_roamer.spawned_unit
				other_patrol_component.patrol_leader_unit = follow_patrol_spawned_unit
				other_patrol_component.patrol_index = i
				other_patrol_component.should_patrol = true
			end
		end

		patrol_data.astar_roamer_unit = nil
		patrol_data.num_failed_atar_times = 0

		return
	end

	local current_patrol_unit, current_patrol_roamer, current_patrol_id = nil

	for patrol_id, _ in pairs(active_patrols) do
		local patrol = patrols[patrol_id]
		local first_patroller_roamer_id = patrol[1]
		local first_patroller_roamer = roamers[first_patroller_roamer_id]
		local spawned_unit = first_patroller_roamer and first_patroller_roamer.spawned_unit

		if HEALTH_ALIVE[spawned_unit] then
			local blackboard = BLACKBOARDS[spawned_unit]
			local patrol_component = Blackboard.write_component(blackboard, "patrol")
			local patrol_leader_unit = patrol_component.patrol_leader_unit

			if not patrol_leader_unit then
				current_patrol_unit = spawned_unit
				current_patrol_roamer = first_patroller_roamer
				current_patrol_id = patrol_id
				patrol_component.patrol_id = patrol_id
				patrol_component.patrol_leader_unit = spawned_unit
			elseif patrol_leader_unit == spawned_unit and not patrol_component.should_patrol then
				current_patrol_unit = spawned_unit
				current_patrol_roamer = first_patroller_roamer
				current_patrol_id = patrol_id

				MinionPatrols.release_patrol_zone_location(claimed_patrol_zone_indexes, current_patrol_roamer)
			end
		else
			active_patrols[patrol_id] = nil

			if first_patroller_roamer then
				MinionPatrols.release_patrol_zone_location(claimed_patrol_zone_indexes, first_patroller_roamer)
			end

			return
		end
	end

	if not current_patrol_unit then
		return
	end

	local zone_id = current_patrol_roamer.zone_id
	local zone = zones[zone_id]
	local sub_zones = zone.sub_zones
	local sub_zone_id = current_patrol_roamer.sub_zone_id
	local sub_zone = sub_zones[sub_zone_id]
	local num_sub_zone_locations = #sub_zone

	if num_sub_zone_locations == 0 then
		active_patrols[current_patrol_id] = nil

		return
	end

	if not claimed_patrol_zone_indexes[zone_id] then
		claimed_patrol_zone_indexes[zone_id] = {}
	end

	local claimed_zone_indixes = claimed_patrol_zone_indexes[zone_id]

	if not claimed_zone_indixes[sub_zone_id] then
		claimed_zone_indixes[sub_zone_id] = {}
	end

	local claimed_sub_zone_indexes = claimed_zone_indixes[sub_zone_id]
	local from_position = POSITION_LOOKUP[current_patrol_unit]
	local min_patrol_distance = PatrolSettings.min_patrol_distance
	local wanted_position, wanted_location_index = nil
	local random_start_location_index = math.random(1, math.max(num_sub_zone_locations - 1, 1))

	for i = random_start_location_index, num_sub_zone_locations do
		local claimed_unit = claimed_sub_zone_indexes[i]

		if claimed_unit and claimed_unit ~= current_patrol_unit then
			-- Nothing
		else
			local location_position = sub_zone[i].position:unbox()
			local distance = Vector3.distance(location_position, from_position)

			if min_patrol_distance <= distance then
				wanted_position = location_position
				wanted_location_index = i
			end
		end
	end

	if not wanted_position then
		local furthest_away_distance = 0

		for i = 1, num_sub_zone_locations do
			repeat
				local claimed_unit = claimed_sub_zone_indexes[i]

				if claimed_unit and claimed_unit ~= current_patrol_unit then
					break
				end

				local location_position = sub_zone[i].position:unbox()
				local distance = Vector3.distance(location_position, from_position)

				if furthest_away_distance < distance then
					furthest_away_distance = distance
					wanted_position = location_position
					wanted_location_index = i
				end
			until true
		end

		if not wanted_position then
			return
		end
	end

	claimed_sub_zone_indexes[wanted_location_index] = current_patrol_unit
	current_patrol_roamer.claimed_patrol_location_index = wanted_location_index
	local traverse_logic = patrol_data.patrol_traverse_logic
	local astar = patrol_data.astar

	GwNavAStar.start(astar, nav_world, from_position, wanted_position, traverse_logic)

	patrol_data.astar_roamer_unit = current_patrol_unit
	patrol_data.astar_roamer_position = Vector3Box(wanted_position)
	patrol_data.astar_roamer = current_patrol_roamer
end

MinionPatrols.release_patrol_zone_location = function (claimed_patrol_zone_indexes, patrol_roamer)
	local zone_id = patrol_roamer.zone_id
	local claimed_zone_indixes = claimed_patrol_zone_indexes[zone_id]

	if claimed_zone_indixes then
		local sub_zone_id = patrol_roamer.sub_zone_id
		local claimed_sub_zone_indexes = claimed_zone_indixes[sub_zone_id]

		if claimed_sub_zone_indexes then
			local claimed_index = patrol_roamer.claimed_patrol_location_index

			if claimed_index then
				claimed_sub_zone_indexes[claimed_index] = nil
			end
		end
	end

	patrol_roamer.claimed_patrol_location_index = nil
end

return MinionPatrols
