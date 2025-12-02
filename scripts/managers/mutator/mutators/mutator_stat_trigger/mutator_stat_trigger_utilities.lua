-- chunkname: @scripts/managers/mutator/mutators/mutator_stat_trigger/mutator_stat_trigger_utilities.lua

local MutatorStatTriggerUtilities = {}
local side_id, target_side_id = 2, 1

MutatorStatTriggerUtilities.on_trigger_spawn_event_enemies_as_horde = function (composition_template, horde_template_key)
	return function (mutator, for_value, delta, caused_by_player)
		if not mutator._is_server then
			return
		end

		local current_faction = Managers.state.pacing:current_faction()
		local compositions = composition_template[current_faction]

		if not compositions or #compositions < 1 then
			return
		end

		local random_index = math.random(1, #compositions)
		local chosen_compositions = compositions[random_index]
		local chosen_compositions_by_resistance = Managers.state.difficulty:get_table_entry_by_resistance(chosen_compositions)

		Managers.state.horde:horde(horde_template_key, horde_template_key, side_id, target_side_id, chosen_compositions_by_resistance)
	end
end

MutatorStatTriggerUtilities.on_trigger_force_horde = function ()
	return function (mutator, for_value, delta, caused_by_player)
		if not mutator._is_server then
			return
		end

		Managers.state.pacing:force_horde_pacing_spawn()
	end
end

MutatorStatTriggerUtilities.on_trigger_send_live_event_notification = function (notification_key)
	return function (mutator, for_value, delta, caused_by_player)
		if not mutator._is_server then
			return
		end

		Managers.live_event:send_live_event_notification(notification_key)
	end
end

return MutatorStatTriggerUtilities
