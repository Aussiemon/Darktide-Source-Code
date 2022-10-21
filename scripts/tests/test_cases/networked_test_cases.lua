local TestifySnippets = require("scripts/tests/testify_snippets")
NetworkedTestCases = {
	join_mission_server = function (case_settings)
		Testify:run_case(function (dt, t)
			local settings = cjson.decode(case_settings or "{}")
			local mission_key = settings.mission
			local flags = settings.flags or {}
			local output = TestifySnippets.check_flags_for_mission(flags, mission_key)

			if output then
				return output, true
			end

			if TestifySnippets.is_debug_stripped() then
				Testify:make_request("skip_title_screen")
			end

			TestifySnippets.create_character_if_none()
			Testify:make_request("wait_for_main_menu_play_button_enabled")
			Testify:make_request("press_play_main_menu")
			Testify:make_request("wait_for_state_gameplay_reached")
			Testify:make_request("fail_on_not_authenticated")
			TestifySnippets.load_mission_in_mission_board(mission_key, 1, 1, "default", "default")
			Testify:make_request("accept_mission_board_vote")
			Testify:make_request("wait_for_view", "lobby_view")
			Testify:make_request("lobby_set_ready_status", true)
		end)
	end,
	join_hub_on_hub_server = function ()
		Testify:run_case(function (dt, t)
			TestifySnippets.create_character_if_none()
			Testify:make_request("wait_for_main_menu_play_button_enabled")
			Testify:make_request("press_play_main_menu")
			Testify:make_request("wait_for_state_gameplay_reached")
			Testify:make_request("fail_on_not_authenticated")
		end)
	end,
	load_mission_in_mission_board = function (mission_key)
		Testify:run_case(function (dt, t)
			TestifySnippets.load_mission_in_mission_board(mission_key, 1, 1, "default", "default")
		end)
	end,
	accept_mission_board_vote = function ()
		Testify:run_case(function (dt, t)
			Testify:make_request("accept_mission_board_vote")
		end)
	end,
	get_ready_in_lobby = function ()
		Testify:run_case(function (dt, t)
			Testify:make_request("wait_for_view", "lobby_view")
			Testify:make_request("lobby_set_ready_status", true)
		end)
	end,
	load_mission_from_mission_board = function (num_peers)
		Testify:run_case(function (dt, t)
			num_peers = num_peers or 0

			TestifySnippets.wait_for_peers(num_peers)

			local peers = Testify:peers()

			TestifySnippets.load_first_mission_from_mission_board_on_peer(peers[1])
			Testify:make_request_on_client(peers[2], "accept_mission_board_vote")
		end)
	end,
	pass_main_menu = function ()
		Testify:run_case(function (dt, t)
			Testify:make_request("press_play_main_menu")
			Testify:make_request("wait_for_state_gameplay_reached")
		end)
	end,
	start_mission_and_complete_it = function (num_peers)
		Testify:run_case(function (dt, t)
			num_peers = num_peers or 0

			TestifySnippets.wait_for_peers(num_peers)
			TestifySnippets.lobby_set_all_peers_ready_status(true)
			TestifySnippets.wait_for_all_peers_reach_gameplay_state()
			Testify:make_request("wait_for_players_spawned", 2)
			Testify:make_request("complete_game_mode")
		end)
	end,
	wait_for_peers_connected = function (num_peers)
		Testify:run_case(function (dt, t)
			num_peers = num_peers or 0

			Testify:make_request("wait_for_state_gameplay_reached")
			TestifySnippets.wait_for_peers(num_peers)
			TestifySnippets.wait_for_all_peers_reach_gameplay_state()
			TestifySnippets.wait(5)
		end)
	end
}
