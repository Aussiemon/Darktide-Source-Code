local Vo = require("scripts/utilities/vo")
local dialogue_context_settings = {}

dialogue_context_settings.construct = function (self, key)
	if dialogue_context_settings[key] then
		return table.clone(dialogue_context_settings[key])
	else
		return {
			time_lived = 0,
			delta = 0,
			count = 0,
			time_to_live = 30
		}
	end
end

local killstreak_query = {}

dialogue_context_settings.number_of_kills_callback = function (dialogue_context_extension, timed_counter, t)
	if not timed_counter.has_triggered then
		timed_counter.has_triggered = true
	elseif timed_counter.time_lived - timed_counter.last_triggered_time < timed_counter.trigger_period then
		return
	end

	timed_counter.last_triggered_time = timed_counter.time_lived
	local current_unit = dialogue_context_extension._unit

	if not ScriptUnit.has_extension(current_unit, "dialogue_system") then
		Log.error("dialogue_context_settings", "trying to issue a faction dialogue query on a unit without a dialogue system extension")

		return
	end

	local dialogue_extension = ScriptUnit.extension(current_unit, "dialogue_system")
	local timeset = Managers.time:time("gameplay") + 900
	local killstreak_query = dialogue_extension:get_event_data_payload()
	killstreak_query.killer_class = dialogue_extension:vo_class_name()
	killstreak_query.number_of_kills = timed_counter.count

	dialogue_extension:trigger_faction_dialogue_query("seen_killstreak_" .. killstreak_query.killer_class, killstreak_query, nil, dialogue_extension._faction_breed_name, true)
	dialogue_extension:store_in_memory("user_memory", "last_killstreak", timeset)
	Vo.kill_spree_self_event(current_unit)
end

dialogue_context_settings.number_of_kills = {
	count = 0,
	has_triggered = false,
	time_lived = 0,
	delta = 0,
	last_triggered_time = 0,
	trigger_period = 2,
	time_to_live = 15,
	trigger_when_higher = 14,
	trigger_function = dialogue_context_settings.number_of_kills_callback
}

dialogue_context_settings.number_of_knocked_down_callback = function (dialogue_context_extension, timed_counter, t)
	if not timed_counter.has_triggered then
		timed_counter.has_triggered = true
	elseif timed_counter.time_lived - timed_counter.last_triggered_time < timed_counter.trigger_period then
		return
	end

	timed_counter.last_triggered_time = timed_counter.time_lived
	local current_unit = dialogue_context_extension._unit

	if not ScriptUnit.has_extension(current_unit, "dialogue_system") then
		Log.error("dialogue_context_settings", "trying to issue a faction dialogue query on a unit without a dialogue system extension")

		return
	end

	Vo.player_knocked_down_multiple_times_event(current_unit)
end

dialogue_context_settings.number_of_knocked_downs = {
	count = 0,
	has_triggered = false,
	time_lived = 0,
	delta = 0,
	last_triggered_time = 0,
	trigger_period = 2,
	time_to_live = 300,
	trigger_when_higher = 1,
	trigger_function = dialogue_context_settings.number_of_knocked_down_callback
}

dialogue_context_settings.number_of_head_pops_callback = function (dialogue_context_extension, timed_counter, t)
	if not timed_counter.has_triggered then
		timed_counter.has_triggered = true
	elseif timed_counter.time_lived - timed_counter.last_triggered_time < timed_counter.trigger_period then
		return
	end

	timed_counter.last_triggered_time = timed_counter.time_lived
	local current_unit = dialogue_context_extension._unit

	if not ScriptUnit.has_extension(current_unit, "dialogue_system") then
		Log.error("dialogue_context_settings", "trying to issue a faction dialogue query on a unit without a dialogue system extension")

		return
	end

	local dialogue_extension = ScriptUnit.extension(current_unit, "dialogue_system")
	local head_pops_query = dialogue_extension:get_event_data_payload()
	head_pops_query.killer_class = dialogue_extension:vo_class_name()

	dialogue_extension:trigger_dialogue_event("multiple_head_pops", head_pops_query)
end

dialogue_context_settings.number_of_head_pops = {
	count = 0,
	has_triggered = false,
	time_lived = 0,
	delta = 0,
	last_triggered_time = 0,
	trigger_period = 2,
	time_to_live = 20,
	trigger_when_higher = 2,
	trigger_function = dialogue_context_settings.number_of_head_pops_callback
}
local suppression_query = {}

dialogue_context_settings.number_of_player_suppressions_callback = function (dialogue_context_extension, timed_counter, t)
	if not timed_counter.has_triggered then
		timed_counter.has_triggered = true
	elseif timed_counter.time_lived - timed_counter.last_triggered_time < timed_counter.trigger_period then
		return
	end

	timed_counter.last_triggered_time = timed_counter.time_lived
	local current_unit = dialogue_context_extension._unit

	if not ScriptUnit.has_extension(current_unit, "dialogue_system") then
		Log.error("dialogue_context_settings", "trying to issue a faction dialogue query on a unit without a dialogue system extension")

		return
	end

	local dialogue_extension = ScriptUnit.extension(current_unit, "dialogue_system")

	table.clear(suppression_query)

	suppression_query.player_class = dialogue_extension:vo_class_name()

	dialogue_extension:trigger_faction_dialogue_query("pinned_by_enemies", suppression_query, nil, dialogue_extension._faction_breed_name, true)
end

dialogue_context_settings.number_of_player_suppressions = {
	count = 0,
	has_triggered = false,
	time_lived = 0,
	delta = 0,
	last_triggered_time = 0,
	trigger_period = 2,
	time_to_live = 15,
	trigger_when_higher = 25,
	trigger_function = dialogue_context_settings.number_of_player_suppressions_callback
}

dialogue_context_settings.number_of_armor_hits_callback = function (dialogue_context_extension, timed_counter, t)
	if not timed_counter.has_triggered then
		timed_counter.has_triggered = true
	elseif timed_counter.time_lived - timed_counter.last_triggered_time < timed_counter.trigger_period then
		return
	end

	timed_counter.last_triggered_time = timed_counter.time_lived
	local current_unit = dialogue_context_extension._unit

	if not ScriptUnit.has_extension(current_unit, "dialogue_system") then
		Log.error("dialogue_context_settings", "trying to issue a faction dialogue query on a unit without a dialogue system extension")

		return
	end

	local dialogue_extension = ScriptUnit.extension(current_unit, "dialogue_system")
	local armor_hit_query = dialogue_extension:get_event_data_payload()
	armor_hit_query.player_class = dialogue_extension:vo_class_name()

	dialogue_extension:trigger_faction_dialogue_query("player_tip_armor_hit", armor_hit_query, nil, dialogue_extension._faction_breed_name, true)
end

dialogue_context_settings.number_of_armor_hits = {
	count = 0,
	has_triggered = false,
	time_lived = 0,
	delta = 0,
	last_triggered_time = 0,
	trigger_period = 2,
	time_to_live = 5,
	trigger_when_higher = 4,
	trigger_function = dialogue_context_settings.number_of_armor_hits_callback
}

dialogue_context_settings.friendly_fire_hits_callback = function (dialogue_context_extension, timed_counter, t)
	if not timed_counter.has_triggered then
		timed_counter.has_triggered = true
	elseif timed_counter.time_lived - timed_counter.last_triggered_time < timed_counter.trigger_period then
		return
	end

	timed_counter.last_triggered_time = timed_counter.time_lived
end

dialogue_context_settings.friendly_fire_hits = {
	count = 0,
	has_triggered = false,
	time_lived = 0,
	delta = 0,
	last_triggered_time = 0,
	trigger_period = 2,
	time_to_live = 10,
	trigger_when_higher = 999,
	trigger_function = dialogue_context_settings.friendly_fire_hits_callback
}

return settings("dialogue_context_settings", dialogue_context_settings)
