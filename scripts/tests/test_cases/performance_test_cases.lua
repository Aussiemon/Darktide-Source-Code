local TestifySnippets = require("scripts/tests/testify_snippets")
PerformanceTestCases = {
	measure_memory_usage_evolution = function (case_settings)
		Testify:run_case(function (dt, t)
			local settings = cjson.decode(case_settings or "{}")
			local send_to_telemetry = settings.send_to_telemetry or false
			local cached_last_mission_loaded = Testify:retrieve_cache("last_mission_loaded") or "boot"
			local cached_memory_usage_data = Testify:retrieve_cache("memory_usage_data") or {}
			local memory_usage = Testify:make_request("memory_usage")
			local memory_usage_data = {
				map = cached_last_mission_loaded,
				memory = memory_usage
			}
			local length = #cached_memory_usage_data
			cached_memory_usage_data[length + 1] = memory_usage_data

			Testify:store_cache("memory_usage_data", cached_memory_usage_data)

			if send_to_telemetry == true then
				Log.set_category_log_level("Telemetry", Log.DEBUG)
				Log.info("Testify", "Sending memory usage evolution data to telemetry..\n%s", table.tostring(cached_memory_usage_data, 2))

				local telemetry_event = "memory_usage_evolution"

				Testify:make_request("create_telemetry_event", telemetry_event, cached_memory_usage_data)
				TestifySnippets.send_telemetry_batch()
			end
		end)
	end,
	memory_tree = function (mission_name)
		Testify:run_case(function (dt, t)
			local depth = 10
			local ascii_separator = "|"
			local memory_limit = 1

			Log.set_category_log_level("Telemetry", Log.DEBUG)

			if TestifySnippets.mission_flag_of_type(mission_name, "memory_usage") == false then
				local result = mission_name .. "'s memory usage flag is set to false. The test was not run"

				return result
			end

			if (TestifySnippets.is_debug_stripped() or BUILD == "release") and Testify:make_request("current_state_name") ~= "StateGameplay" then
				TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
			end

			TestifySnippets.load_mission(mission_name)
			Testify:make_request("wait_for_state_gameplay_reached")
			TestifySnippets.wait_for_mission_intro()
			TestifySnippets.wait(1)

			local memory_tree = TestifySnippets.memory_tree(depth, ascii_separator, memory_limit)
			local telemetry_event_name = "perf_memory_tree"

			Testify:make_request("create_telemetry_event", telemetry_event_name, mission_name, memory_tree)
			TestifySnippets.send_telemetry_batch()
		end)
	end,
	performance_memory_usage = function (mission_key)
		Testify:run_case(function (dt, t)
			Log.set_category_log_level("Telemetry", Log.DEBUG)

			if TestifySnippets.mission_flag_of_type(mission_key, "memory_usage") == false then
				local result = mission_key .. "'s memory usage flag is set to false. The test was not run"

				return result
			end

			if (TestifySnippets.is_debug_stripped() or BUILD == "release") and Testify:make_request("current_state_name") ~= "StateGameplay" then
				TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
			end

			TestifySnippets.load_mission(mission_key)
			Testify:make_request("wait_for_state_gameplay_reached")
			TestifySnippets.wait_for_mission_intro()

			local memory_usage_data = Testify:make_request("memory_usage")
			local telemetry_event_name = "perf_memory"

			Testify:make_request("create_telemetry_event", telemetry_event_name, mission_key, 0, memory_usage_data)
			TestifySnippets.send_telemetry_batch()
		end)
	end,
	performance_milliseconds_per_frame = function (mission_key)
		Testify:run_case(function (dt, t)
			Log.set_category_log_level("Telemetry", Log.DEBUG)

			local measure_time = 2
			local time_before_measuring = 5
			local flag = TestifySnippets.mission_flag_of_type(mission_key, "performance")

			if flag == false then
				local result = mission_key .. "'s performance flag is set to false. The test was not run"

				return result
			end

			if (TestifySnippets.is_debug_stripped() or BUILD == "release") and Testify:make_request("current_state_name") ~= "StateGameplay" then
				TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
			end

			TestifySnippets.load_mission(mission_key)
			Testify:make_request("wait_for_state_gameplay_reached")
			TestifySnippets.wait_for_mission_intro()

			local cameras = Testify:make_request("all_cameras_of_type", "performance")
			local assert_data = {
				condition = not table.is_empty(cameras),
				message = mission_key .. "'s performance flag is set to true, but there are no performance cameras. Please set the flag to false until cameras have been added."
			}
			local performance_measurements = {}
			local telemetry_event_name = "perf_camera"
			local values_to_measure = {
				primitives_count = true,
				batchcount = true
			}

			for index, camera in pairs(cameras) do
				Testify:make_request("set_active_testify_camera", camera.unit)
				TestifySnippets.wait(time_before_measuring)
				Testify:make_request("start_measuring_performance", values_to_measure)
				TestifySnippets.wait(measure_time)

				performance_measurements = Testify:make_request("stop_measuring_performance")
				local mission_name = Testify:make_request("current_mission")

				Testify:make_request("create_telemetry_event", telemetry_event_name, mission_name, camera, performance_measurements)
			end

			Testify:make_request("deactivate_testify_camera")
			TestifySnippets.send_telemetry_batch()
		end)
	end,
	performance_milliseconds_per_frame_mission_server = function (mission_key)
		Testify:run_case(function (dt, t)
			Log.set_category_log_level("Telemetry", Log.DEBUG)

			local measure_time = 2
			local time_before_measuring = 5
			local cameras = Testify:make_request("all_cameras_of_type", "performance")
			local assert_data = {
				condition = not table.is_empty(cameras),
				message = mission_key .. "'s performance flag is set to true, but there are no performance cameras. Please set the flag to false until cameras have been added."
			}
			local performance_measurements = {}
			local telemetry_event_name = "perf_camera"
			local values_to_measure = {
				primitives_count = true,
				batchcount = true
			}

			for index, camera in pairs(cameras) do
				Testify:make_request("set_active_testify_camera", camera.unit)
				TestifySnippets.wait(time_before_measuring)
				Testify:make_request("start_measuring_performance", values_to_measure)
				TestifySnippets.wait(measure_time)

				performance_measurements = Testify:make_request("stop_measuring_performance")
				local mission_name = Testify:make_request("current_mission")

				Testify:make_request("create_telemetry_event", telemetry_event_name, mission_name, camera, performance_measurements)
			end

			Testify:make_request("deactivate_testify_camera")
			TestifySnippets.send_telemetry_batch()
		end)
	end
}
