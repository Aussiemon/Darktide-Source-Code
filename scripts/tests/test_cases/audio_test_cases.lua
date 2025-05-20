-- chunkname: @scripts/tests/test_cases/audio_test_cases.lua

local TestifySnippets = require("scripts/tests/testify_snippets")

AudioTestCases = {}

AudioTestCases.play_all_vo_lines = function ()
	Testify:run_case(function (dt, t)
		if TestifySnippets.is_debug_stripped() or BUILD == "release" then
			TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
			TestifySnippets.load_mission("spawn_all_enemies")
		end

		Testify:make_request("wait_for_state_gameplay_reached")

		local player_unit = Testify:make_request("player_unit")
		local dialogue_extension = Testify:make_request("dialogue_extension", player_unit)
		local voices = Testify:make_request("all_wwise_voices")

		for _, voice in pairs(voices) do
			local vo_settings = {
				dialogue_extension = dialogue_extension,
				voice = voice,
			}

			Testify:make_request("set_vo_profile", vo_settings)
		end

		local wwise_route = dialogue_extension._dialogue_system._wwise_route_default
		local event_type = "vorbis_external"
		local sound_events = Testify:make_request("all_dialogue_sound_events", dialogue_extension)

		for _, sound_event in pairs(sound_events) do
			local vo_settings = {
				dialogue_extension = dialogue_extension,
				event = {
					type = event_type,
					wwise_route = wwise_route,
					sound_event = sound_event,
				},
			}

			Testify:make_request("play_dialogue_event", vo_settings)
		end
	end)
end
