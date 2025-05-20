-- chunkname: @scripts/tests/test_cases/world_test_cases.lua

local TestifySnippets = require("scripts/tests/testify_snippets")
local FlythroughCoordinates = require("scripts/tests/test_cases/config/flythrough_coordinates")

WorldTestCases = {}

WorldTestCases.load_mission = function (case_settings)
	Testify:run_case(function (dt, t)
		local settings = cjson.decode(case_settings or "{}")
		local check_theme_loaded = settings.check_theme_loaded or false
		local flags = settings.flags or {
			"load_mission",
		}
		local mission_key = settings.mission_key
		local num_peers = settings.num_peers or 0

		if (TestifySnippets.is_debug_stripped() or BUILD == "release") and Testify:make_request("current_state_name") ~= "StateGameplay" then
			TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
		end

		local output = TestifySnippets.check_flags_for_mission(flags, mission_key) or TestifySnippets.mission_exists(mission_key)

		if output then
			return output
		end

		if num_peers == 0 then
			TestifySnippets.load_mission(mission_key)
		end

		if check_theme_loaded then
			Testify:make_request("check_theme_loaded")
		end

		Testify:make_request("wait_for_state_gameplay_reached")

		if num_peers > 0 then
			TestifySnippets.wait_for_peers(num_peers)
			TestifySnippets.wait_for_all_peers_reach_gameplay_state()
		end

		TestifySnippets.wait(2)
	end)
end

WorldTestCases.load_mission_circumstances = function (case_settings)
	Testify:run_case(function (dt, t)
		local settings = cjson.decode(case_settings or "{}")

		if settings.check_theme_loaded == false then
			-- Nothing
		end

		local check_theme_loaded = true
		local flags = settings.flags or {
			"load_mission",
			"circumstances",
		}
		local mission_name = settings.mission_name
		local num_peers = settings.num_peers or 0

		if (TestifySnippets.is_debug_stripped() or BUILD == "release") and Testify:make_request("current_state_name") ~= "StateGameplay" then
			TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
		end

		local output = TestifySnippets.check_flags_for_mission(flags, mission_name) or TestifySnippets.mission_exists(mission_name)

		if output then
			return output
		end

		local mission_circumstances, length = TestifySnippets.mission_circumstances(mission_name)

		for i = 1, length do
			local circumstance = mission_circumstances[i]

			TestifySnippets.load_mission(mission_name, nil, nil, circumstance)

			if check_theme_loaded then
				Testify:make_request("check_theme_loaded")
			end

			Testify:make_request("wait_for_state_gameplay_reached")

			if num_peers > 0 then
				TestifySnippets.wait_for_peers(num_peers)
				TestifySnippets.wait_for_all_peers_reach_gameplay_state()
			end

			TestifySnippets.wait(2)
		end

		TestifySnippets.wait(2)
	end)
end

WorldTestCases.load_mission_side_missions = function (case_settings)
	Testify:run_case(function (dt, t)
		local settings = cjson.decode(case_settings or "{}")
		local check_theme_loaded = settings.check_theme_loaded or true
		local flags = settings.flags or {
			"load_mission",
			"side_missions",
		}
		local mission_name = settings.mission_name
		local num_peers = settings.num_peers or 0
		local mechanism_name = Testify:make_request("mechanism_name", mission_name)

		if mechanism_name ~= "adventure" then
			return "Missions that don't have the Adventure mechanism are currently not supported and are therefore skipped."
		end

		if (TestifySnippets.is_debug_stripped() or BUILD == "release") and Testify:make_request("current_state_name") ~= "StateGameplay" then
			TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
		end

		local output = TestifySnippets.check_flags_for_mission(flags, mission_name) or TestifySnippets.mission_exists(mission_name)

		if output then
			return output
		end

		local side_missions = Testify:make_request("side_missions")

		for side_mission_name, side_mission in pairs(side_missions) do
			local is_testable = side_mission.is_testable

			if is_testable then
				TestifySnippets.load_mission(mission_name, nil, nil, nil, side_mission_name)

				if check_theme_loaded then
					Testify:make_request("check_theme_loaded")
				end

				Testify:make_request("wait_for_state_gameplay_reached")

				if num_peers > 0 then
					TestifySnippets.wait_for_peers(num_peers)
					TestifySnippets.wait_for_all_peers_reach_gameplay_state()
				end

				TestifySnippets.wait(2)
			end
		end

		TestifySnippets.wait(2)
	end)
end

WorldTestCases.invalid_circumstances = function ()
	Testify:run_case(function (dt, t)
		local circumstance_name = "invalid_circumstances_test"

		TestifySnippets.load_mission("spawn_all_enemies", nil, nil, circumstance_name)
		Testify:make_request("wait_for_state_gameplay_reached")
		TestifySnippets.wait(2)
	end)
end

WorldTestCases.invalid_side_missions = function ()
	Testify:run_case(function (dt, t)
		local side_mission_name = "invalid_side_missions_test"

		TestifySnippets.load_mission("spawn_all_enemies", nil, nil, nil, side_mission_name)
		Testify:make_request("wait_for_state_gameplay_reached")
		TestifySnippets.wait(2)
	end)
end

WorldTestCases.screenshots_for_timelapse_videos = function (case_settings)
	Testify:run_case(function (dt, t)
		local result = ""
		local settings = cjson.decode(case_settings or "{}")
		local missions = settings.missions
		local flags = {
			"screenshot",
		}
		local wait_time = 5
		local screenshot_settings = settings.screenshot_settings or {
			filetype = "png",
			output_dir = "//filegw01.i.fatshark.se/tools/testify/screenshot_timelapse",
		}
		local output_dir = screenshot_settings.output_dir

		if not table.is_empty(missions) then
			Testify:make_request("wait_for_state_gameplay_reached")

			for _, mission in pairs(missions) do
				local output = TestifySnippets.check_flags_for_mission(flags, mission) or TestifySnippets.mission_exists(missions)

				if output then
					result = result .. "\n" .. output
				else
					TestifySnippets.load_mission(mission)
					Testify:make_request("wait_for_state_gameplay_reached")

					local cameras, length = Testify:make_request("all_cameras")

					if length ~= 0 then
						screenshot_settings.output_dir = output_dir .. "/" .. mission

						for i = 1, length do
							local camera = cameras[i]

							Testify:make_request("set_active_testify_camera", camera.unit)
							TestifySnippets.wait(wait_time)

							screenshot_settings.filename = camera.name

							Testify:make_request("take_a_screenshot", screenshot_settings)
						end

						Testify:make_request("deactivate_testify_camera")
					end
				end
			end

			if result ~= "" then
				return result
			end
		end

		result = "The test passed successfully"

		return result
	end)
end

WorldTestCases.test_triggers = function ()
	Testify:run_case(function (dt, t)
		Testify:make_request("wait_for_state_gameplay_reached")
		TestifySnippets.wait(5)

		local result = ""
		local extension_map = Testify:make_request("fetch_unit_and_extensions_from_system", "trigger_system")

		for trigger_unit, _ in pairs(extension_map) do
			local trigger_action_data = Testify:make_request("trigger_action_data", trigger_unit)
			local should_action_be_triggered_on_server = trigger_action_data.is_triggered_on_server
			local is_trigger_action_on_player_side = trigger_action_data.is_on_player_side
			local trigger_condition_name = Testify:make_request("trigger_condition_name", trigger_unit)

			Log.info("Testify", "[test_triggers][Unit %s]", trigger_unit)

			if should_action_be_triggered_on_server and is_trigger_action_on_player_side and trigger_condition_name == "at_least_one_player_inside" then
				local trigger_position = Unit.world_position(trigger_unit, 1)

				Testify:make_request("teleport_player_to_position", Vector3Box(trigger_position))
				TestifySnippets.wait(5)

				local has_trigger_been_triggered = Testify:make_request("has_trigger_been_triggered", trigger_unit)

				if not has_trigger_been_triggered then
					result = string.format("%sFail - [Unit: %s, %s]\n", result, Unit.id_string(trigger_unit), trigger_unit)
				end
			end
		end

		result = result == "" and "Success" or result

		return result
	end)
end
