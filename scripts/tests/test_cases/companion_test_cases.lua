-- chunkname: @scripts/tests/test_cases/companion_test_cases.lua

local TestifySnippets = require("scripts/tests/testify_snippets")

CompanionTestCases = {}

CompanionTestCases.spawn_and_despawn_dog_with_lone_wolf_talent = function (case_settings)
	Testify:run_case(function (dt, t)
		local archetype = "adamant"

		TestifySnippets.skip_splash_and_title_screen()
		TestifySnippets.wait_for_main_menu()
		Testify:make_request("delete_character_by_name", "Testify")
		TestifySnippets.create_character_from_main_menu(archetype)
		TestifySnippets.load_mission("spawn_all_enemies")
		Testify:make_request("wait_for_state_gameplay_reached")
		TestifySnippets.wait(1)

		local local_player = Testify:make_request("local_player", 1)
		local params = {
			player = local_player,
		}

		params.talents = {
			adamant_disable_companion = 1,
		}

		Testify:make_request("apply_select_talents", params)
		TestifySnippets.wait(5)

		params.talents = {
			adamant_disable_companion = nil,
		}

		Testify:make_request("apply_select_talents", params)
		TestifySnippets.wait(5)
	end)
end

CompanionTestCases.check_lone_wolf_talent_and_coherency_interaction = function (case_settings)
	Testify:run_case(function (dt, t)
		local archetype = "adamant"

		TestifySnippets.skip_splash_and_title_screen()
		TestifySnippets.wait_for_main_menu()
		Testify:make_request("delete_character_by_name", "Testify")
		TestifySnippets.create_character_from_main_menu(archetype)
		TestifySnippets.load_mission("spawn_all_enemies")
		Testify:make_request("wait_for_state_gameplay_reached")
		TestifySnippets.wait(1)

		local local_player = Testify:make_request("local_player", 1)
		local params = {
			player = local_player,
		}

		params.talents = {
			adamant_companion_coherency = nil,
			adamant_disable_companion = nil,
		}

		Testify:make_request("apply_select_talents", params)
		TestifySnippets.wait(5)

		params.talents = {
			adamant_companion_coherency = 1,
		}

		Testify:make_request("apply_select_talents", params)
		TestifySnippets.wait(5)

		params.talents = {
			adamant_companion_coherency = nil,
			adamant_disable_companion = 1,
			adamant_reload_speed_aura = 1,
		}

		Testify:make_request("apply_select_talents", params)
		TestifySnippets.wait(5)

		params.talents = {
			adamant_companion_coherency = 1,
			adamant_disable_companion = nil,
			adamant_reload_speed_aura = nil,
		}

		Testify:make_request("apply_select_talents", params)
		TestifySnippets.wait(5)
	end)
end

CompanionTestCases.adamant_target_enemy_and_attack_with_companion_dog = function (case_settings)
	Testify:run_case(function (dt, t)
		local settings = cjson.decode(case_settings or "{}")
		local archetype = "adamant"

		TestifySnippets.skip_splash_and_title_screen()
		TestifySnippets.wait_for_main_menu()
		Testify:make_request("delete_character_by_name", "Testify")
		TestifySnippets.create_character_from_main_menu(archetype)
		TestifySnippets.load_mission("spawn_all_enemies")
		Testify:make_request("wait_for_state_gameplay_reached")
		TestifySnippets.wait(1)

		local spawn_position = {
			x = 0,
			y = 10,
			z = 0,
		}
		local minion_spawn_data = {
			breed_side = 2,
			breed_name = settings.breed_name,
			spawn_position = spawn_position,
		}
		local target_unit = Testify:make_request("spawn_minion", minion_spawn_data)

		TestifySnippets.wait(1)

		local local_player = Testify:make_request("local_player", 1)
		local player_unit = local_player.player_unit

		Testify:make_request("companion_tag_enemy", player_unit, target_unit)
		TestifySnippets.wait(settings.duration)
		Testify:make_request("exit_to_main_menu")
	end)
end
