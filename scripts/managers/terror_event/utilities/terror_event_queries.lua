local TerrorEventQueries = {}

local function _count_num_alive_minions_in_spawners(spawner_queue_id)
	local num_alive_minions = 0
	local HEALTH_ALIVE = HEALTH_ALIVE

	for script, queue_ids in pairs(spawner_queue_id) do
		for i = 1, #queue_ids do
			local queue_id = queue_ids[i]
			local spawned_minions_by_queue_id = script:spawned_minions_by_queue_id(queue_id)

			if spawned_minions_by_queue_id then
				for j = 1, #spawned_minions_by_queue_id do
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

	return num_alive_minions
end

TerrorEventQueries.num_alive_minions_in_level = function ()
	local num_alive = Managers.state.minion_spawn:num_spawned_minions()

	return num_alive
end

TerrorEventQueries.num_aggroed_minions_in_level = function ()
	local num_aggroed = Managers.state.pacing:num_aggroed_minions()

	return num_aggroed
end

return TerrorEventQueries
