local BotSpawning = require("scripts/managers/bot/bot_spawning")
local BreedQueries = require("scripts/utilities/breed_queries")
local Breeds = require("scripts/settings/breed/breeds")
local MinionAttackSelection = require("scripts/utilities/minion_attack_selection/minion_attack_selection")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local TerrorEventNodes = {
	debug_print = {
		init = function (node, event, t)
			event.scratchpad.ends_at = t + node.duration
		end,
		update = function (node, scratchpad, t, dt)
			if t > scratchpad.ends_at then
				return true
			end
		end,
		debug_text = function (node, is_completed, is_running, scratchpad, t, dt)
			return not is_completed and string.format("(%.1f sec)", is_running and scratchpad.ends_at - t or node.duration)
		end
	},
	delay = {
		init = function (node, event, t)
			event.scratchpad.ends_at = t + node.duration
		end,
		update = function (node, scratchpad, t, dt)
			if scratchpad.ends_at < t then
				return true
			end
		end,
		debug_text = function (node, is_completed, is_running, scratchpad, t, dt)
			return not is_completed and string.format("(%.1f sec)", is_running and scratchpad.ends_at - t or node.duration)
		end
	},
	continue_when = {
		init = function (node, event, t)
			if node.duration then
				event.scratchpad.ends_at = t + node.duration
			end
		end,
		update = function (node, scratchpad, t, dt)
			local ends_at = scratchpad.ends_at

			if ends_at and ends_at < t then
				return true
			end

			return node.condition()
		end,
		debug_text = function (node, is_completed, is_running, scratchpad, t, dt)
			if node.duration then
				return not is_completed and string.format("(%.1f sec)", is_running and scratchpad.ends_at - t or node.duration)
			end
		end
	},
	start_terror_event = {
		init = function (node, event, t)
			local terror_event_manager = Managers.state.terror_event
			local start_event_name = node.start_event_name
			local seed = nil

			terror_event_manager:start_event(start_event_name, seed)
		end,
		update = function (node, scratchpad, t, dt)
			return true
		end,
		debug_text = function (node, is_completed, is_running, scratchpad, t, dt)
			return string.format("%q", node.start_event_name)
		end
	},
	start_random_terror_event = {
		init = function (node, event, t)
			local terror_event_manager = Managers.state.terror_event
			local start_event_name = node.start_event_name

			terror_event_manager:start_random_event(start_event_name)
		end,
		update = function (node, scratchpad, t, dt)
			return true
		end,
		debug_text = function (node, is_completed, is_running, scratchpad, t, dt)
			return string.format("random event: %q", node.start_event_name)
		end
	},
	stop_terror_event = {
		init = function (node, event, t)
			local terror_event_manager = Managers.state.terror_event
			local stop_event_name = node.stop_event_name

			terror_event_manager:stop_event(stop_event_name)
		end,
		update = function (node, scratchpad, t, dt)
			return true
		end,
		debug_text = function (node, is_completed, is_running, scratchpad, t, dt)
			return string.format("%q", node.stop_event_name)
		end
	},
	flow_event = {
		init = function (node, event, t)
			local flow_event_name = node.flow_event_name

			Managers.state.terror_event:trigger_network_synced_level_flow(flow_event_name)
		end,
		update = function (node, scratchpad, t, dt)
			return true
		end,
		debug_text = function (node, is_completed, is_running, scratchpad, t, dt)
			return string.format("%q", node.flow_event_name)
		end
	},
	play_2d_sound = {
		init = function (node, event, t)
			local sound_event_name = node.sound_event_name
			local fx_system = Managers.state.extension:system("fx_system")

			fx_system:trigger_wwise_event(sound_event_name)
		end,
		update = function (node, scratchpad, t, dt)
			return true
		end,
		debug_text = function (node, is_completed, is_running, scratchpad, t, dt)
			return string.format("%q", node.sound_event_name)
		end
	},
	control_pacing_spawns = {
		init = function (node, event, t)
			local pacing_manager = Managers.state.pacing
			local spawn_types = node.spawn_types
			local enabled = node.enabled

			for i = 1, #spawn_types do
				local spawn_type = spawn_types[i]

				pacing_manager:pause_spawn_type(spawn_type, not enabled, "terror_event")
			end
		end,
		update = function (node, scratchpad, t, dt)
			return true
		end,
		debug_text = function (node, is_completed, is_running, scratchpad, t, dt)
			local spawn_types = node.spawn_types
			local enabled = node.enabled
			local names = ""

			for i = 1, #spawn_types do
				local spawn_type = spawn_types[i]
				names = names .. spawn_type .. " "
			end

			return string.format("Controlling pacing spawn: %s => %s", names, enabled and "true" or "false")
		end
	},
	freeze_specials_pacing = {
		init = function (node, event, t)
			local pacing_manager = Managers.state.pacing
			local enabled = node.enabled

			pacing_manager:freeze_specials_pacing(enabled)
		end,
		update = function (node, scratchpad, t, dt)
			return true
		end,
		debug_text = function (node, is_completed, is_running, scratchpad, t, dt)
			local enabled = node.enabled

			return string.format("Freezing specials pacing => %s", enabled and "true" or "false")
		end
	},
	set_pacing_enabled = {
		init = function (node, event, t)
			local pacing_manager = Managers.state.pacing
			local enabled = node.enabled

			pacing_manager:set_enabled(enabled)
		end,
		update = function (node, scratchpad, t, dt)
			return true
		end,
		debug_text = function (node, is_completed, is_running, scratchpad, t, dt)
			return string.format("Set pacing enabled: %s", node.enabled and "true" or "false")
		end
	}
}
local TEMP_SPAWN_SIDE_NAME = "villains"
local TEMP_TARGET_SIDE_NAME = "heroes"
TerrorEventNodes.spawn_by_points = {
	init = function (node, event, t)
		event.scratchpad.spawned_minion_data = event.spawned_minion_data
	end,
	update = function (node, scratchpad, t, dt)
		local terror_events_allowed = Managers.state.pacing:spawn_type_allowed("terror_events")

		if not terror_events_allowed then
			return false
		end

		if not scratchpad.started_spawn then
			scratchpad.started_spawn = true
			local breed_tags = node.breed_tags
			local difficulty_scale = Managers.state.difficulty:get_table_entry_by_resistance(MinionDifficultySettings.terror_event_point_costs)
			local points = node.points * difficulty_scale
			local spawner_group = node.spawner_group
			local limit_spawners = node.limit_spawners
			local delay_until_all_spawned = node.delay_until_all_spawned
			local mission_objective_id = node.mission_objective_id
			local spawn_side_name = TEMP_SPAWN_SIDE_NAME
			local target_side_name = TEMP_TARGET_SIDE_NAME
			local breed_pool = BreedQueries.match_minions_by_tags(breed_tags)
			local breed, breed_amount = BreedQueries.pick_random_minion_by_points(breed_pool, points)
			local breed_name = breed.name

			if node.max_breed_amount then
				breed_amount = math.min(node.max_breed_amount, breed_amount)
			end

			local side_system = Managers.state.extension:system("side_system")
			local spawn_side = side_system:get_side_from_name(spawn_side_name)
			local spawn_side_id = spawn_side.side_id
			local target_side = side_system:get_side_from_name(target_side_name)
			local target_side_id = target_side.side_id
			local minion_spawn_system = Managers.state.extension:system("minion_spawner_system")
			local spawners = nil

			if spawner_group then
				spawners = minion_spawn_system:spawners_in_group(spawner_group)

				fassert(#spawners ~= 0, "[TerrorEventNodes.spawn_by_points.init] there are no available spawners with spawner group name \"%s\", the spawner group has probably changed name!", spawner_group)
			end

			table.shuffle(spawners)

			if limit_spawners then
				for i = limit_spawners + 1, #spawners do
					spawners[i] = nil
				end
			end

			local attack_selection_template_tag = node.attack_selection_template_tag
			local attack_selection_template_name_or_nil = nil

			if attack_selection_template_tag then
				if type(attack_selection_template_tag) == "table" then
					attack_selection_template_tag = attack_selection_template_tag[math.random(1, #attack_selection_template_tag)]
				end

				local attack_selection_templates = breed.attack_selection_templates
				attack_selection_template_name_or_nil = MinionAttackSelection.match_template_by_tag(attack_selection_templates, attack_selection_template_tag)
			end

			local spawned_minion_data = scratchpad.spawned_minion_data

			BreedQueries.add_spawns_single_breed(spawners, breed_name, breed_amount, spawn_side_id, target_side_id, spawned_minion_data, mission_objective_id, attack_selection_template_name_or_nil)

			if delay_until_all_spawned ~= false then
				scratchpad.wait_for_spawners = spawners
			end
		end

		local wait_for_spawners = scratchpad.wait_for_spawners

		if wait_for_spawners then
			for i = 1, #wait_for_spawners do
				if wait_for_spawners[i]:is_spawning() then
					return false
				end
			end
		end

		return true
	end
}
TerrorEventNodes.spawn_by_breed_name = {
	init = function (node, event, t)
		local breed_name = node.breed_name
		local breed_amount = node.breed_amount
		local spawner_group = node.spawner_group
		local limit_spawners = node.limit_spawners
		local delay_until_all_spawned = node.delay_until_all_spawned
		local mission_objective_id = node.mission_objective_id
		local spawn_side_name = TEMP_SPAWN_SIDE_NAME
		local target_side_name = TEMP_TARGET_SIDE_NAME
		local side_system = Managers.state.extension:system("side_system")
		local spawn_side = side_system:get_side_from_name(spawn_side_name)
		local spawn_side_id = spawn_side.side_id
		local target_side = side_system:get_side_from_name(target_side_name)
		local target_side_id = target_side.side_id
		local minion_spawn_system = Managers.state.extension:system("minion_spawner_system")
		local spawners = nil

		if spawner_group then
			spawners = minion_spawn_system:spawners_in_group(spawner_group)

			fassert(#spawners ~= 0, "[TerrorEventNodes.spawn_by_breed_name.init] there are no available spawners with spawner group name \"%s\", the spawner group has probably changed name!", spawner_group)
		end

		table.shuffle(spawners)

		if limit_spawners then
			for i = limit_spawners + 1, #spawners do
				spawners[i] = nil
			end
		end

		local attack_selection_template_tag = node.attack_selection_template_tag
		local attack_selection_template_name_or_nil = nil

		if attack_selection_template_tag then
			if type(attack_selection_template_tag) == "table" then
				attack_selection_template_tag = attack_selection_template_tag[math.random(1, #attack_selection_template_tag)]
			end

			local breed = Breeds[breed_name]
			local attack_selection_templates = breed.attack_selection_templates
			attack_selection_template_name_or_nil = MinionAttackSelection.match_template_by_tag(attack_selection_templates, attack_selection_template_tag)
		end

		BreedQueries.add_spawns_single_breed(spawners, breed_name, breed_amount, spawn_side_id, target_side_id, event.spawned_minion_data, mission_objective_id, attack_selection_template_name_or_nil)

		if delay_until_all_spawned ~= false then
			event.scratchpad.wait_for_spawners = spawners
		end
	end,
	update = function (node, scratchpad, t, dt)
		local wait_for_spawners = scratchpad.wait_for_spawners

		if wait_for_spawners then
			for i = 1, #wait_for_spawners do
				if wait_for_spawners[i]:is_spawning() then
					return false
				end
			end
		end

		return true
	end
}
TerrorEventNodes.try_inject_special_minion = {
	init = function (node, event, t)
		local breed_tags = node.breed_tags
		local difficulty_scale = Managers.state.difficulty:get_table_entry_by_resistance(MinionDifficultySettings.terror_event_point_costs)
		local points = node.points * difficulty_scale
		local breed_pool = BreedQueries.match_minions_by_tags(breed_tags)
		local breed, breed_amount = BreedQueries.pick_random_minion_by_points(breed_pool, points)
		local breed_name = breed.name

		if node.max_breed_amount then
			breed_amount = math.min(node.max_breed_amount, breed_amount)
		end

		local spawner_group = node.spawner_group

		for i = 1, breed_amount do
			Managers.state.pacing:try_inject_special(breed_name, nil, nil, spawner_group)
		end
	end,
	update = function (node, scratchpad, t, dt)
		return true
	end
}
TerrorEventNodes.start_terror_trickle = {
	init = function (node, event, t)
		local spawner_group = node.spawner_group
		local template_name = node.template_name
		local use_occluded_positions = node.use_occluded_positions
		local delay = node.delay

		Managers.state.terror_event:start_terror_trickle(template_name, spawner_group, delay, use_occluded_positions)
	end,
	update = function (node, scratchpad, t, dt)
		return true
	end
}
TerrorEventNodes.stop_terror_trickle = {
	init = function (node, event, t)
		Managers.state.terror_event:stop_terror_trickle()
	end,
	update = function (node, scratchpad, t, dt)
		return true
	end
}
TerrorEventNodes.spawn_bot_character = {
	init = function (node, event, t)
		local profile_name = node.profile_name

		BotSpawning.spawn_bot_character(profile_name)
	end,
	update = function (node, scratchpad, t, dt)
		return true
	end
}

return TerrorEventNodes
