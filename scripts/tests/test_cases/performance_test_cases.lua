﻿-- chunkname: @scripts/tests/test_cases/performance_test_cases.lua

local TestifySnippets = require("scripts/tests/testify_snippets")

PerformanceTestCases = {}

PerformanceTestCases.measure_memory_usage_evolution = function (case_settings)
	Testify:run_case(function (dt, t)
		local settings = cjson.decode(case_settings or "{}")
		local send_to_telemetry = settings.send_to_telemetry or false
		local depth = 10
		local ascii_separator = "|"
		local memory_limit = 1
		local monitor_resources_memory_usage = settings.monitor_resources_memory_usage or false

		TestifySnippets.wait(1)

		local is_application_bundled = Application.bundled()

		Log.info("Testify", "is_application_bundled: ")
		Log.info("Testify", is_application_bundled)

		local cached_last_mission_loaded = Testify:retrieve_cache("last_mission_loaded") or "boot"
		local cached_memory_usage_data = Testify:retrieve_cache("memory_usage_data") or {}
		local memory_usage = Testify:make_request("memory_usage")
		local memory_tree = TestifySnippets.memory_tree(depth, ascii_separator, memory_limit)
		local memory_usage_data = {
			map = cached_last_mission_loaded,
			memory = memory_usage,
			memory_tree = memory_tree,
			is_bundled = is_application_bundled
		}

		if monitor_resources_memory_usage and not is_application_bundled then
			local memory_resources_all = TestifySnippets.memory_resources_all(true)

			memory_usage_data.resources_memory_usage = memory_resources_all
		end

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
end

PerformanceTestCases.memory_tree = function (mission_name)
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
end

PerformanceTestCases.performance_memory_usage = function (mission_key)
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
end

PerformanceTestCases.performance_milliseconds_per_frame = function (mission_key, circumstance)
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

		TestifySnippets.load_mission(mission_key, nil, nil, circumstance)
		Testify:make_request("wait_for_state_gameplay_reached")
		TestifySnippets.wait_for_mission_intro()

		local cameras = Testify:make_request("all_cameras_of_type", "performance")

		Testify.expect:is_false("performance_cameras_assert", table.is_empty(cameras), mission_key .. "'s performance flag is set to true, but there are no performance cameras. Please set the flag to false until cameras have been added.")

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

			if circumstance then
				mission_name = mission_name .. "_" .. circumstance
			end

			Testify:make_request("create_telemetry_event", telemetry_event_name, mission_name, camera, performance_measurements)
		end

		Testify:make_request("deactivate_testify_camera")
		TestifySnippets.send_telemetry_batch()
	end)
end

PerformanceTestCases.performance_milliseconds_per_frame_mission_server = function (mission_key, circumstance)
	Testify:run_case(function (dt, t)
		Log.set_category_log_level("Telemetry", Log.DEBUG)

		local measure_time = 2
		local time_before_measuring = 5
		local cameras = Testify:make_request("all_cameras_of_type", "performance")

		Testify.expect:is_false("performance_cameras_assert", table.is_empty(cameras), mission_key .. "'s performance flag is set to true, but there are no performance cameras. Please set the flag to false until cameras have been added.")

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

			if circumstance then
				mission_name = mission_name .. "_" .. circumstance
			end

			Testify:make_request("create_telemetry_event", telemetry_event_name, mission_name, camera, performance_measurements)
		end

		Testify:make_request("deactivate_testify_camera")
		TestifySnippets.send_telemetry_batch()
	end)
end

PerformanceTestCases.meat_grind_stress = function (case_settings)
	Testify:run_case(function (dt, t)
		local settings = cjson.decode(case_settings or "{}")
		local num_iterations = settings.num_iterations or 10
		local wait_time_in_hub = settings.wait_time_in_hub or 1
		local wait_time_in_psychanium = settings.wait_time_in_psychanium or 1

		TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
		Testify:make_request("wait_for_in_hub")
		Testify:make_request("fail_on_not_authenticated")

		local training_grounds_view_name = "training_grounds_view"
		local training_grounds_view_data = {
			view_name = training_grounds_view_name
		}
		local system_view_name = "system_view"
		local system_view_data = {
			view_name = system_view_name
		}

		for i = 1, num_iterations do
			Testify:make_request("open_view", training_grounds_view_data)
			Testify:make_request("wait_for_view", training_grounds_view_name)

			local meat_grinder_button_widget_name = "option_button_3"

			Testify:make_request("trigger_widget_callback", meat_grinder_button_widget_name)
			Testify:make_request("wait_for_view", "training_grounds_options_view")
			TestifySnippets.wait(0.5)

			local play_button_widget_name = "play_button"

			Testify:make_request("trigger_widget_callback", play_button_widget_name)
			Testify:make_request("wait_for_in_psychanium")
			TestifySnippets.wait(wait_time_in_psychanium)

			local memory_usage = Testify:make_request("memory_usage")

			Log.info("Testify", string.format("In the Psychanium\nIteration %i - Memory: %s", i, table.tostring(memory_usage, 4)))
			Testify:make_request("open_view", system_view_data)
			Testify:make_request("wait_for_view", system_view_name)
			TestifySnippets.wait(0.5)

			local exit_psychanium_button_widget_name = "grid_content_pivot_widget_18"

			Testify:make_request("trigger_widget_callback", exit_psychanium_button_widget_name)
			TestifySnippets.wait(0.5)

			local confirm_exit_psychanium_popup_widget_name = "popup_widget_1"

			Testify:make_request("select_popup_option", confirm_exit_psychanium_popup_widget_name)
			Testify:make_request("wait_for_in_hub")
			TestifySnippets.wait(wait_time_in_hub)

			local memory_usage = Testify:make_request("memory_usage")

			Log.info("Testify", string.format("In the hub\nIteration %i - Memory: %s", i, table.tostring(memory_usage, 4)))
		end
	end)
end

PerformanceTestCases.purchase_item = function (case_settings)
	Testify:run_case(function (dt, t)
		local settings = cjson.decode(case_settings or "{}")
		local num_iterations = settings.num_iterations or 10

		TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
		Testify:make_request("wait_for_in_hub")
		Testify:make_request("fail_on_not_authenticated")

		local credits_vendor_background_view_name = "credits_vendor_background_view"
		local credits_vendor_background_view_data = {
			view_name = credits_vendor_background_view_name
		}

		Testify:make_request("open_view", credits_vendor_background_view_data)
		Testify:make_request("wait_for_view", credits_vendor_background_view_name)
		TestifySnippets.wait(0.5)

		local credits_vendor_background_view_button_widget_name = "option_button_3"

		Testify:make_request("trigger_widget_callback", credits_vendor_background_view_button_widget_name)
		Testify:make_request("wait_for_view", "debug_vendor_view")
		TestifySnippets.wait(0.5)

		for i = 1, num_iterations do
			TestifySnippets.wait(0.5)
			Testify:make_request("purchase_first_debug_vendor_item")
			TestifySnippets.wait(1.5)
			TestifySnippets.wait(0.5)

			local memory_usage = Testify:make_request("memory_usage")

			Log.info("Testify", string.format("After item purchase\nIteration %i - Memory: %s", i, table.tostring(memory_usage, 4)))
		end
	end)
end
