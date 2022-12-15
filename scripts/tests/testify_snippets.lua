local TestifySnippets = {
	create_new_character = function ()
		Testify:make_request("wait_for_view_to_close", "main_menu_background_view")
		Testify:make_request("create_new_character")
	end,
	create_character_if_none = function ()
		local is_any_character_created = Testify:make_request("is_any_character_created")

		if not is_any_character_created then
			Testify:make_request("create_random_character")
		end
	end
}

TestifySnippets.skip_title_and_main_menu_and_create_character_if_none = function ()
	if not DEDICATED_SERVER then
		TestifySnippets.skip_splash_and_title_screen()

		local is_any_character_created = Testify:make_request("is_any_character_created")

		if not is_any_character_created then
			Testify:make_request("create_random_character")
		else
			Testify:make_request("wait_for_main_menu_play_button_enabled")
			Testify:make_request("press_play_main_menu")
		end
	end
end

TestifySnippets.skip_splash_and_title_screen = function ()
	Testify:make_request("skip_splash_screen")
	Testify:make_request("skip_title_screen")
	Testify:make_request("skip_privacy_policy_popup_if_displayed")
end

TestifySnippets.load_mission = function (mission_key)
	Testify:make_request("wait_for_state_gameplay_reached")
	Testify:make_request("load_mission", mission_key)
end

TestifySnippets.load_mission_in_mission_board = function (level_key, challenge, resistance, circumstance_name, side_mission, peer_id)
	challenge = challenge or 1
	resistance = resistance or 1
	circumstance_name = circumstance_name or "default"
	side_mission = side_mission or "default"
	local params = {
		map = level_key,
		challenge = challenge,
		resistance = resistance,
		circumstance_name = circumstance_name,
		side_mission = side_mission
	}

	if peer_id == nil then
		Testify:make_request("load_mission_in_mission_board", params)
	else
		Testify:make_request_on_client(peer_id, "load_mission_in_mission_board", true, params)
	end
end

TestifySnippets.reload_current_mission = function ()
	local current_mission = Testify:make_request("current_mission")

	TestifySnippets.load_mission(current_mission)
end

TestifySnippets.lobby_set_all_peers_ready_status = function (is_ready)
	TestifySnippets.send_request_to_all_peers("lobby_set_ready_status", true, nil, is_ready)
end

TestifySnippets.wait_for_all_peers_reach_gameplay_state = function ()
	TestifySnippets.send_request_to_all_peers("wait_for_state_gameplay_reached", true, 3)
end

TestifySnippets.set_force_spectate = function (value)
	if DEDICATED_SERVER then
		TestifySnippets.send_request_to_all_peers("set_force_spectate", nil, nil, value)
	else
		Testify:make_request("set_force_spectate", value)
	end
end

TestifySnippets.enter_free_flight = function ()
	if DEDICATED_SERVER then
		TestifySnippets.send_request_to_all_peers("enter_free_flight")
	else
		Testify:make_request("enter_free_flight")
	end
end

TestifySnippets.set_free_flight_camera_position = function (camera_data)
	if DEDICATED_SERVER then
		TestifySnippets.send_request_to_all_peers("set_free_flight_camera_position", nil, nil, camera_data)
	else
		Testify:make_request("set_free_flight_camera_position", camera_data)
	end
end

TestifySnippets.wait_for_cinematic_to_be_over = function ()
	if DEDICATED_SERVER then
		TestifySnippets.send_request_to_all_peers("wait_for_cinematic_to_be_over", true)
	else
		Testify:make_request("wait_for_cinematic_to_be_over")
	end
end

TestifySnippets.spawn_bot = function ()
	Testify:make_request("wait_for_master_items_data")
	Testify:make_request("spawn_bot")
	Testify:make_request("wait_for_bot_synchronizer_ready")
end

TestifySnippets.set_difficulty = function (difficulty)
	local resistance = {
		name = "resistance",
		value = difficulty.resistance
	}

	Testify:make_request("change_dev_parameter", resistance)

	local challenge = {
		name = "challenge",
		value = difficulty.challenge
	}

	Testify:make_request("change_dev_parameter", challenge)
end

TestifySnippets.is_host = function ()
	return Testify:make_request("is_host")
end

TestifySnippets.wait_for_peers = function (num_peers)
	while Testify:num_peers() ~= num_peers do
		coroutine.yield()
	end
end

TestifySnippets.send_request_to_all_peers = function (request_name, wait_for_response, num_retries, ...)
	local peer_ids = Testify:peers()
	num_retries = num_retries or 1
	local retry_time = 30

	for _, peer_id in ipairs(peer_ids) do
		local request_sent = false

		while num_retries > 0 and request_sent == false do
			if TestifySnippets.peer_exists(peer_id) then
				Testify:make_request_on_client(peer_id, request_name, wait_for_response, ...)

				request_sent = true
			else
				Log.info("Testify", "The peer %s is not connected to the server, retrying", peer_id)
				TestifySnippets.wait(retry_time)

				num_retries = num_retries - 1
			end
		end
	end
end

TestifySnippets.peer_exists = function (peer_id)
	local peer_ids = Testify:peers()

	Log.info("Testify", "checking peer %s existence: %s", peer_id, table.contains(peer_ids, peer_id))

	return table.contains(peer_ids, peer_id)
end

TestifySnippets.check_flags_for_mission = function (flags, mission_key)
	for i = 1, #flags do
		local flag = flags[i]
		local flag_value = TestifySnippets.mission_flag_of_type(mission_key, flags[i])

		if flag_value == false then
			local output = string.format("%s's %s flag is set to false. The test was not run", mission_key, flag)

			return output
		end
	end
end

TestifySnippets.all_mission_flags = function (mission)
	local flags = Testify:make_request("all_mission_flags", mission)

	return flags ~= "" and flags or nil
end

TestifySnippets.all_missions_with_flag_of_type = function (flag_type)
	local missions = Testify:make_request("all_missions_with_flag_of_type", flag_type)

	if missions == "" then
		return nil
	end

	return missions
end

TestifySnippets.mission_flag_of_type = function (mission, flag_type)
	local flags = TestifySnippets.all_mission_flags(mission)

	if flags and not table.is_empty(flags) then
		for type, flag in pairs(flags) do
			if type == flag_type then
				return flag
			end
		end

		return nil
	else
		return nil
	end
end

TestifySnippets.send_telemetry_batch = function ()
	Testify:make_request("send_telemetry_batch")
	TestifySnippets.wait(3)
end

TestifySnippets.lua_trace_statistics = function ()
	Application.console_command("lua", "trace")
	TestifySnippets.wait(1)

	local lua_trace_statistics = Testify:make_request_to_runner("lua_trace_statistics")
	lua_trace_statistics = cjson.decode(lua_trace_statistics)

	return lua_trace_statistics
end

TestifySnippets.trigger_vo_query_player_look_at = function (look_at_tag, distance, num_dialogues)
	local look_at_data = {
		look_at_tag = look_at_tag,
		distance = distance
	}

	Testify:make_request("trigger_vo_query_player_look_at", look_at_data)

	return TestifySnippets.wait_for_end_of_dialogue(num_dialogues or 1) and "success" or look_at_tag
end

TestifySnippets.trigger_vo_query_faction_look_at = function (faction, look_at_tag, distance, num_dialogues)
	local look_at_data = {
		faction = faction,
		look_at_tag = look_at_tag,
		distance = distance
	}

	Testify:make_request("trigger_vo_query_faction_look_at", look_at_data)

	return TestifySnippets.wait_for_end_of_dialogue(num_dialogues or 1) and "success" or look_at_tag
end

TestifySnippets.trigger_vo_query_mission_brief = function (mission_brief_starter_line, voice_profile, num_dialogues)
	local mission_brief_data = {
		mission_brief_starter_line = mission_brief_starter_line,
		voice_profile = voice_profile
	}

	Testify:make_request("trigger_vo_query_mission_brief", mission_brief_data)

	return TestifySnippets.wait_for_end_of_dialogue(num_dialogues or 1) and "success" or mission_brief_starter_line
end

TestifySnippets.trigger_vo_query_mission_giver_mission_info = function (trigger_id, voice_profile, num_dialogues)
	local mission_giver_data = {
		trigger_id = trigger_id,
		voice_profile = voice_profile
	}

	Testify:make_request("trigger_vo_query_mission_giver_mission_info", mission_giver_data)

	return TestifySnippets.wait_for_end_of_dialogue(num_dialogues or 1) and "success" or trigger_id
end

TestifySnippets.trigger_vo_query_player_generic_vo = function (trigger_id, num_dialogues)
	local player_generic_vo_data = {
		trigger_id = trigger_id
	}

	Testify:make_request("trigger_vo_query_player_generic_vo", player_generic_vo_data)

	return TestifySnippets.wait_for_end_of_dialogue(num_dialogues or 1) and "success" or trigger_id
end

TestifySnippets.trigger_vo_query_player_environmental_story_vo = function (trigger_id, num_dialogues)
	local player_environmental_story_vo_data = {
		trigger_id = trigger_id
	}

	Testify:make_request("trigger_vo_query_player_environmental_story_vo", player_environmental_story_vo_data)

	return TestifySnippets.wait_for_end_of_dialogue(num_dialogues or 1) and "success" or trigger_id
end

TestifySnippets.trigger_mission_giver_conversation_starter = function (trigger_id, voice_profile, num_dialogues)
	local mission_giver_conversation_starter_vo_data = {
		trigger_id = trigger_id,
		voice_profile = voice_profile
	}

	Testify:make_request("trigger_mission_giver_conversation_starter", mission_giver_conversation_starter_vo_data)

	return TestifySnippets.wait_for_end_of_dialogue(num_dialogues or 1) and "success" or trigger_id
end

TestifySnippets.trigger_vo_query_player_start_banter = function (trigger_id, num_dialogues)
	local player_start_banter_vo_data = {
		trigger_id = trigger_id
	}

	Testify:make_request("trigger_vo_query_player_start_banter", player_start_banter_vo_data)

	return TestifySnippets.wait_for_end_of_dialogue(num_dialogues or 1) and "success" or trigger_id
end

TestifySnippets.trigger_vo_on_demand = function (vo_concept, trigger_id, num_dialogues)
	local player_vo_on_demand_starter_data = {
		vo_concept = vo_concept,
		trigger_id = trigger_id
	}

	Testify:make_request("trigger_vo_on_demand", player_vo_on_demand_starter_data)

	return TestifySnippets.wait_for_end_of_dialogue(num_dialogues or 1) and "success" or trigger_id
end

TestifySnippets.wait_for_end_of_dialogue = function (num_dialogues)
	local has_played = true
	local SOUND_MINIMUM_TIME = 0.1

	for i = 1, num_dialogues do
		if num_dialogues > 1 then
			Log.info("Testify", "Playing dialogue %s of %s.", i, num_dialogues)
		end

		local time = os.clock()
		local has_dialogue_started = Testify:make_request("wait_for_dialogue_playing", time)

		if has_dialogue_started then
			time = os.clock()

			Testify:make_request("wait_for_dialogue_played")

			if SOUND_MINIMUM_TIME > os.clock() - time then
				Log.error("Testify", "The dialogue took %ss to play, which is less than %ss. It looks like there is a problem with it.", os.clock() - time, SOUND_MINIMUM_TIME)

				has_played = false
			end
		else
			has_played = false
		end
	end

	return has_played
end

TestifySnippets.equip_all_traits_support_snippet = function (player, slot_name, traits, has_placeholder_profile, weapon_name, units_to_spawn)
	local weapon = Testify:make_request("get_weapon", weapon_name)
	local data = {
		player = player,
		slot = slot_name,
		item = weapon
	}
	local trait_params = {
		player = player,
		slot_name = slot_name,
		traits = traits
	}
	units_to_spawn = units_to_spawn or 1
	local breed_name = "chaos_ogryn_executor"
	local minion = {
		breed_side = 2,
		breed_name = breed_name,
		spawn_position = Vector3Box(Vector3.zero())
	}

	if not has_placeholder_profile then
		Testify:make_request("equip_item_backend", data)
	else
		Testify:make_request("equip_item", data)
	end

	Testify:make_request("wait_for_item_equipped", data)
	Log.info("Testify", "Applying Traits")
	Testify:make_request("apply_select_traits", trait_params)
	TestifySnippets.wait(0.5)
	Testify:make_request("wield_slot", data)
	Log.info("Testify", "Spawning chaos_ogryn_executor")

	for i = 1, units_to_spawn do
		minion.unit = Testify:make_request("spawn_minion", minion)
	end

	TestifySnippets.wait(0.5)

	return minion
end

TestifySnippets.reset_weapon_traits = function (player, slot_name)
	Log.info("Testify", "Reseting Traits")

	local empty_trait_params = {
		player = player,
		slot_name = slot_name,
		traits = {}
	}

	Testify:make_request("apply_select_traits", empty_trait_params)
end

TestifySnippets.wait_for_gameplay_ready = function ()
	if not DEDICATED_SERVER then
		Testify:make_request("wait_for_view_to_close", "loading_view")
	end

	Testify:make_request("wait_for_state_gameplay_reached")
end

TestifySnippets.connection_statistics = function ()
	local statistics = Testify:make_request_to_runner("get_connection_statistics")

	return cjson.decode(statistics)
end

TestifySnippets.wait = function (seconds)
	local now = os.clock()

	while seconds > os.clock() - now do
		coroutine.yield()
	end
end

TestifySnippets.wait_frames = function (num_frames)
	for i = 1, num_frames do
		coroutine.yield()
	end
end

TestifySnippets.is_debug_stripped = function ()
	local is_debug_stripped = true

	return is_debug_stripped
end

TestifySnippets.peers_sorted = function ()
	local peers = Testify:peers()

	table.sort(peers)

	return peers
end

TestifySnippets.first_peer = function ()
	local peers = TestifySnippets.peers_sorted()

	return peers[1]
end

TestifySnippets.peers_except_first = function ()
	local peers = TestifySnippets.peers_sorted()

	table.remove(peers, 1)

	return peers
end

return TestifySnippets
