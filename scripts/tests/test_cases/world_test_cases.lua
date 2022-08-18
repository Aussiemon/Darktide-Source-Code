local TestifySnippets = require("scripts/tests/testify_snippets")
WorldTestCases = {
	load_mission = function (case_settings)
		Testify:run_case(function (dt, t)
			local settings = cjson.decode(case_settings or "{}")
			local check_theme_loaded = settings.check_theme_loaded or false
			local flags = settings.flags or {
				"load_mission"
			}
			local mission_key = settings.mission_key
			local num_peers = settings.num_peers or 0

			if TestifySnippets.is_debug_stripped() and Testify:make_request("current_state_name") ~= "StateGameplay" then
				TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
			end

			local output = TestifySnippets.check_flags_for_mission(flags, mission_key)

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
			TestifySnippets.wait_for_peers(num_peers)
			TestifySnippets.wait_for_all_peers_reach_gameplay_state()
			TestifySnippets.wait(2)
		end)
	end,
	screenshots_for_timelapse_videos = function (case_settings)
		Testify:run_case(function (dt, t)
			local result = nil
			local missions_missing_cameras = {}
			local settings = cjson.decode(case_settings or "{}")
			local missions = settings.missions
			local screenshot_settings = settings.screenshot_settings or {
				output_dir = "//filegw01.i.fatshark.se/tools/testify/screenshot_timelapse",
				filetype = "png"
			}
			local output_dir = screenshot_settings.output_dir

			if not table.is_empty(missions) then
				Testify:make_request("wait_for_state_gameplay_reached")

				for _, mission in pairs(missions) do
					local flag = TestifySnippets.mission_flag_of_type(mission, "screenshots")

					if flag then
						TestifySnippets.load_mission(mission)
						Testify:make_request("wait_for_state_gameplay_reached")

						local cameras = Testify:make_request("all_cameras_of_type", "screenshot")

						if table.is_empty(cameras) then
							table.insert(missions_missing_cameras, mission)
						else
							screenshot_settings.output_dir = output_dir .. "/" .. mission

							for index, camera in pairs(cameras) do
								Testify:make_request("set_active_testify_camera", camera.unit)
								TestifySnippets.wait(2)

								screenshot_settings.filename = mission .. "-" .. index

								Testify:make_request("take_a_screenshot", screenshot_settings)
							end

							Testify:make_request("deactivate_testify_camera")
						end
					else
						Log.info("Testify", mission .. " does not have a screenshot flag, or it is set to false. The test was not run")
					end
				end
			end

			if not table.is_empty(missions_missing_cameras) then
				result = "-These missions have flags but are missing cameras: " .. table.concat(missions_missing_cameras, ", ")

				return result
			end

			result = "The test passed successfully"

			return result
		end)
	end,
	test_triggers = function ()
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

			if result == "" then
				result = "Success"
			end

			return result
		end)
	end
}

return
