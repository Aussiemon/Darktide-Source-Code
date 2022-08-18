local TerrorEventQueries = {}

local function _count_num_alive_minions_in_spawners(spawner_queue_id)
	local num_alive_minions = 0

	for script, queue_ids in pairs(spawner_queue_id) do
		for i = 1, #queue_ids, 1 do
			local queue_id = queue_ids[i]
			local spawned_minions_by_queue_id = script:spawned_minions_by_queue_id(queue_id)

			if spawned_minions_by_queue_id then
				for j = 1, #spawned_minions_by_queue_id, 1 do
					if HEALTH_ALIVE[spawned_minions_by_queue_id[j]] then
						num_alive_minions = num_alive_minions + 1
					end
				end
			end
		end
	end

	return num_alive_minions
end

TerrorEventQueries.num_alive_minions = function ()
	local terror_event_manager = Managers.state.terror_event
	local current_event = terror_event_manager:current_event()
	local spawner_queue_id = current_event.spawned_minion_data.spawner_queue_id
	local num_alive_minions = 0

	if spawner_queue_id then
		num_alive_minions = _count_num_alive_minions_in_spawners(spawner_queue_id)
	end

	if num_alive_minions == 0 then
		table.clear(current_event.spawned_minion_data)
	end

	local terror_trickle_data = terror_event_manager:get_terror_trickle_data()
	local trickle_spawner_queue_id = terror_trickle_data.spawned_minion_data.spawner_queue_id

	if trickle_spawner_queue_id then
		local num_alive_terror_trickle_minions = _count_num_alive_minions_in_spawners(trickle_spawner_queue_id)

		if num_alive_terror_trickle_minions == 0 then
			table.clear(terror_trickle_data.spawned_minion_data)
		end

		num_alive_minions = num_alive_minions + num_alive_terror_trickle_minions
	end

	return num_alive_minions
end

TerrorEventQueries.num_alive_minions_in_level = function ()
	local side_system = Managers.state.extension:system("side_system")
	local side_name = side_system:get_default_player_side_name()
	local side = side_system:get_side_from_name(side_name)
	local alive_minions = side:alive_units_by_tag("enemy", "minion")
	local num_alive = alive_minions.size

	return num_alive
end

TerrorEventQueries.num_aggroed_minions_in_level = function ()
	local side_system = Managers.state.extension:system("side_system")
	local side_name = side_system:get_default_player_side_name()
	local side = side_system:get_side_from_name(side_name)
	local alive_minions = side:alive_units_by_tag("enemy", "minion")
	local blackboards = BLACKBOARDS
	local num_aggroed = 0

	for i = 1, alive_minions.size, 1 do
		local minion_unit = alive_minions[i]
		local blackboard = blackboards[minion_unit]
		local perception_component = blackboard.perception
		local aggro_state = perception_component.aggro_state

		if aggro_state == "aggroed" then
			num_aggroed = num_aggroed + 1
		end
	end

	return num_aggroed
end

return TerrorEventQueries
