local TestifySnippets = require("scripts/tests/testify_snippets")
PerformanceTestCases = {
	performance_memory_usage = function (mission_key)
		Testify:run_case(function (dt, t)
			Log.set_category_log_level("Telemetry", Log.DEBUG)

			if TestifySnippets.mission_flag_of_type(mission_key, "memory_usage") == false then
				local result = mission_key .. "'s memory usage flag is set to false. The test was not run"

				return result
			end

			if TestifySnippets.is_debug_stripped() and Testify:make_request("current_state_name") ~= "StateGameplay" then
				TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
			end

			TestifySnippets.load_mission(mission_key)
			Testify:make_request("wait_for_state_gameplay_reached")
			TestifySnippets.wait_for_cinematic_to_be_over()

			while not Testify:make_request("is_party_full") do
				TestifySnippets.spawn_bot()
			end

			Testify:make_request("memory_usage", 0)
			TestifySnippets.send_telemetry_batch()
		end)
	end,
	performance_milliseconds_per_frame = function (mission_key)
		Testify:run_case(function (dt, t)
			Log.set_category_log_level("Telemetry", Log.DEBUG)

			local measure_time = 2
			local flag = TestifySnippets.mission_flag_of_type(mission_key, "performance")

			if not flag then
				local result = mission_key .. "'s performance flag is not set to true. The test was not run"

				return result
			end

			if TestifySnippets.is_debug_stripped() and Testify:make_request("current_state_name") ~= "StateGameplay" then
				TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
			end

			TestifySnippets.load_mission(mission_key)
			Testify:make_request("wait_for_state_gameplay_reached")
			TestifySnippets.wait_for_cinematic_to_be_over()

			local cameras = Testify:make_request("all_cameras_of_type", "performance")
			local assert_data = {
				assert = "performance_cameras_assert",
				condition = not table.is_empty(cameras),
				message = mission_key .. "'s performance flag is set to true, but there are no performance cameras. Please remove the flag until cameras have been added."
			}

			Testify:make_request("performance_cameras_assert", assert_data)

			for index, camera in pairs(cameras) do
				Testify:make_request("set_active_testify_camera", camera.unit)
				TestifySnippets.wait(2)
				Testify:make_request("start_measuring_performance")
				TestifySnippets.wait(measure_time)
				Testify:make_request("stop_measuring_performance", camera)
			end

			Testify:make_request("deactivate_testify_camera")
			TestifySnippets.send_telemetry_batch()
		end)
	end
}
