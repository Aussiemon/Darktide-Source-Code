-- chunkname: @scripts/tests/test_cases/ui_test_cases.lua

local TestifySnippets = require("scripts/tests/testify_snippets")

UITestCases = {}

UITestCases.change_render_settings = function ()
	Testify:run_case(function (dt, t)
		TestifySnippets.skip_splash_and_title_screen()
		Testify:make_request("wait_for_profile_synchronization")
		TestifySnippets.wait(1)

		local render_settings = Testify:make_request("display_and_graphics_presets_settings")

		for i = 1, #render_settings do
			local setting = render_settings[i]
			local setting_display_name = setting.display_name
			local options = setting.options

			if options then
				for j = 1, #options do
					local old_value = Testify:make_request("setting_value", setting)
					local new_value = setting_display_name == "loc_setting_resolution" and j or options[j].id

					if new_value ~= old_value then
						local option_data = {
							setting = setting,
							old_value = old_value,
							new_value = new_value,
						}

						Testify:make_request("setting_on_activated", option_data)
					end
				end
			elseif setting_display_name == "loc_vsync" then
				local old_value = Testify:make_request("setting_value", setting)
				local new_value = not old_value
				local option_data = {
					setting = setting,
					old_value = old_value,
					new_value = new_value,
				}

				Testify:make_request("setting_on_activated", option_data)
			end
		end
	end)
end

UITestCases.create_characters = function ()
	Testify:run_case(function (dt, t)
		local NUM_ARCHETYPES = 4

		TestifySnippets.skip_splash_and_title_screen()
		Testify:make_request("wait_for_profile_synchronization")
		Testify:make_request("delete_all_characters")
		Testify:make_request("wait_for_profile_synchronization")

		for i = 1, NUM_ARCHETYPES do
			Testify:make_request("navigate_to_create_character_from_main_menu")
			Testify:make_request("class_selection_view_select_archetype", i)
			TestifySnippets.create_new_character()
			Testify:make_request("wait_for_state_gameplay_reached")
			Testify:make_request("exit_to_main_menu")
			Testify:make_request("wait_for_profile_synchronization")
		end

		Testify:make_request("delete_all_characters")
		Testify:make_request("wait_for_profile_synchronization")
	end)
end
