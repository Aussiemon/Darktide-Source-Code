-- chunkname: @scripts/tests/test_cases/networked_test_cases.lua

local TestifySnippets = require("scripts/tests/testify_snippets")

NetworkedTestCases = {}

NetworkedTestCases.complete_mission = function ()
	Testify:run_case(function (dt, t)
		Testify:make_request("complete_game_mode")
		TestifySnippets.send_request_to_all_peers("wait_for_cutscene_to_finish", true, 3, "outro_win")
	end)
end

NetworkedTestCases.wait_for_mission_intro = function ()
	Testify:run_case(function (dt, t)
		TestifySnippets.wait_for_mission_intro()
	end)
end

NetworkedTestCases.fast_forward_end_of_round = function ()
	Testify:run_case(function (dt, t)
		Testify:make_request("fast_forward_end_of_round")
	end)
end

NetworkedTestCases.join_mission_server = function (case_settings)
	Testify:run_case(function (dt, t)
		local settings = cjson.decode(case_settings or "{}")
		local mission_key = settings.mission
		local store_mission_in_cache = settings.store_mission_in_cache == true or false
		local circumstance = settings.circumstance or "default"
		local side_mission = settings.side_mission or "default"
		local flags = settings.flags or {}
		local output = TestifySnippets.check_flags_for_mission(flags, mission_key)

		if output then
			return output, true
		end

		TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
		Testify:make_request("wait_for_state_gameplay_reached")
		Testify:make_request("fail_on_not_authenticated")
		TestifySnippets.load_mission_in_mission_board(mission_key, 1, 1, circumstance, side_mission)
		Testify:make_request("accept_mission_board_vote")
		Testify:make_request("wait_for_view", "lobby_view")
		Testify:make_request("lobby_set_ready_status", true)

		if store_mission_in_cache then
			Testify:store_cache("last_mission_loaded", mission_key)
		end
	end)
end

NetworkedTestCases.join_hub_on_hub_server = function ()
	Testify:run_case(function (dt, t)
		TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
		Testify:make_request("wait_for_state_gameplay_reached")
		Testify:make_request("fail_on_not_authenticated")
	end)
end

NetworkedTestCases.create_party_and_join_mission_on_all_clients = function (mission_key)
	Testify:run_case(function (dt, t)
		local party_id = Testify:make_request_on_client(TestifySnippets.first_peer(), "immaterium_party_id", true)
		local peers_except_first = TestifySnippets.peers_except_first()
		local first_peer = TestifySnippets.first_peer()

		for _, peer_id in pairs(peers_except_first) do
			Testify:make_request_on_client(peer_id, "immaterium_join_party", true, party_id)
			Testify:make_request_on_client(first_peer, "accept_join_party", true)
			TestifySnippets.wait(1)
		end

		TestifySnippets.load_mission_in_mission_board(mission_key, 1, 1, "default", "default", first_peer)

		for _, peer_id in pairs(peers_except_first) do
			Testify:make_request_on_client(peer_id, "accept_mission_board_vote", true)
		end

		TestifySnippets.send_request_to_all_peers("wait_for_ongoing_vote", true)
		TestifySnippets.send_request_to_all_peers("accept_vote", true)
	end)
end

NetworkedTestCases.create_party_with_all_clients = function ()
	Testify:run_case(function (dt, t)
		local party_id = Testify:make_request_on_client(TestifySnippets.first_peer(), "immaterium_party_id", true)
		local peers_except_first = TestifySnippets.peers_except_first()
		local first_peer = TestifySnippets.first_peer()

		for _, peer_id in pairs(peers_except_first) do
			Testify:make_request_on_client(peer_id, "immaterium_join_party", true, party_id)
			Testify:make_request_on_client(first_peer, "accept_join_party", true)
			TestifySnippets.wait(1)
		end
	end)
end

NetworkedTestCases.reach_gameplay_state_and_wait = function (duration)
	Testify:run_case(function (dt, t)
		Testify:make_request("wait_for_state_gameplay_reached")
		TestifySnippets.wait(duration)
	end)
end

NetworkedTestCases.reach_mission_on_all_clients = function (num_peers)
	Testify:run_case(function (dt, t)
		TestifySnippets.wait_for_peers(num_peers)
		TestifySnippets.send_request_to_all_peers("wait_for_view", true, nil, "lobby_view")
		TestifySnippets.send_request_to_all_peers("lobby_set_ready_status", true, nil, true)
		TestifySnippets.wait_for_all_peers_reach_gameplay_state()
		TestifySnippets.wait(5)
	end)
end

NetworkedTestCases.get_ready_in_lobby = function ()
	Testify:run_case(function (dt, t)
		Testify:make_request("wait_for_view", "lobby_view")
		Testify:make_request("lobby_set_ready_status", true)
	end)
end

NetworkedTestCases.wait_for_peers_connected = function (num_peers)
	Testify:run_case(function (dt, t)
		num_peers = num_peers or 0

		Testify:make_request("wait_for_state_gameplay_reached")
		TestifySnippets.wait_for_peers(num_peers)
		TestifySnippets.wait_for_all_peers_reach_gameplay_state()
		TestifySnippets.wait(5)
	end)
end

NetworkedTestCases.loop_connect_disconnect_to_the_hub = function (case_settings)
	Testify:run_case(function (dt, t)
		local settings = cjson.decode(case_settings or "{}")
		local num_iterations = settings.num_iterations or 12
		local stay_in_the_hub_time = settings.stay_in_the_hub_time or 3
		local stay_in_the_main_menu_time = settings.stay_in_the_main_menu_time or 1
		local join_party = settings.join_party or false
		local party_id

		if join_party then
			party_id = Testify:make_request("immaterium_party_id")
		end

		for i = 1, num_iterations do
			Testify:make_request("exit_to_main_menu")
			Testify:make_request("wait_for_main_menu_displayed")
			TestifySnippets.wait(stay_in_the_main_menu_time)
			Testify:make_request("press_play_main_menu")
			Testify:make_request("wait_for_state_gameplay_reached")
			TestifySnippets.wait(1)

			if join_party then
				Testify:make_request("immaterium_join_party", party_id)
			end

			TestifySnippets.wait(stay_in_the_hub_time - 1)
		end
	end)
end
