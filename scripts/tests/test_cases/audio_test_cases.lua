-- chunkname: @scripts/tests/test_cases/audio_test_cases.lua

local TestifySnippets = require("scripts/tests/testify_snippets")
local VOQueryConstants = require("scripts/settings/dialogue/vo_query_constants")

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
				voice = voice
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
					sound_event = sound_event
				}
			}

			Testify:make_request("play_dialogue_event", vo_settings)
		end
	end)
end

local default_vo_look_at_distance = 15
local common_missions_look_at_tag = {
	asset_acid_clouds = "asset_acid_clouds",
	asset_water_course = "asset_water_course",
	asset_cartel_insignia = "asset_cartel_insignia"
}

AudioTestCases.vo_rules_dm_forge = function ()
	Testify:run_case(function (dt, t)
		if TestifySnippets.is_debug_stripped() or BUILD == "release" then
			TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
			TestifySnippets.load_mission("dm_forge")
		end

		Testify:make_request("wait_for_state_gameplay_reached")

		local result = {
			TestifySnippets.trigger_vo_query_mission_brief("mission_forge_briefing_a", "sergeant_a"),
			TestifySnippets.trigger_vo_query_player_look_at("mission_forge_start_banter_a", default_vo_look_at_distance, 4),
			TestifySnippets.trigger_vo_query_player_look_at("mission_forge_strategic_asset", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_forge_main_entrance", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_forge_labour_oversight", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_forge_propaganda", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_forge_call_elevator", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_generic_vo("mission_forge_stand_ground"),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_forge_use_elevator", "sergeant_a"),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_forge_elevator_conversation_one_a", 3),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_forge_elevator_conversation_two_a", 3),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_forge_elevator_conversation_three_a", 3),
			TestifySnippets.trigger_vo_query_player_look_at("mission_forge_find_smelter", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_forge_superstructure", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_forge_lifeless", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_forge_assembly_line", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_forge_smelter", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_forge_purge_infestation", "sergeant_a"),
			TestifySnippets.trigger_vo_query_player_generic_vo("mission_forge_alive"),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_forge_smelter_working", "sergeant_a"),
			TestifySnippets.trigger_vo_query_player_generic_vo("mission_forge_hellhole")
		}
		local failed_rules = result

		table.array_remove_if(failed_rules, function (value)
			return value == "success"
		end)

		if table.is_empty(failed_rules) then
			return "All VO rules were triggered"
		end

		return "The following rules were not triggered " .. table.concat(failed_rules, "\n")
	end)
end

AudioTestCases.vo_rules_dm_propaganda = function ()
	Testify:run_case(function (dt, t)
		if TestifySnippets.is_debug_stripped() or BUILD == "release" then
			TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
			TestifySnippets.load_mission("dm_propaganda")
		end

		Testify:make_request("wait_for_state_gameplay_reached")

		local result = {
			TestifySnippets.trigger_vo_query_mission_brief("mission_propaganda_briefing_a", "sergeant_a", 3),
			TestifySnippets.trigger_vo_query_player_look_at("mission_propaganda_start_banter_a", default_vo_look_at_distance, 4),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_propaganda_short_elevator_conversation_one_a", 2),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_propaganda_short_elevator_conversation_two_a", 2),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_propaganda_short_elevator_conversation_three_a", 2),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_propaganda_bypass_security", "sergeant_a"),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_propaganda_consulate", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_propaganda_view_a", default_vo_look_at_distance, 2),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_propaganda_luggable_event_start", "sergeant_a"),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_propaganda_luggable_event_end", "sergeant_a"),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_propaganda_transmission_dish", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_propaganda_cultist_town", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_propaganda_nearing_transmission_complex", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_propaganda_elevator_conversation_one_a", 3),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_propaganda_elevator_conversation_two_a", 3),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_propaganda_elevator_conversation_three_a", 3),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_propaganda_complex_heart", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_propaganda_corruptor_event_align_bridges", "sergeant_a"),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_propaganda_corruptor_event_next_bridge", "sergeant_a"),
			TestifySnippets.trigger_vo_query_player_look_at("mission_propaganda_infested_elevator", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_propaganda_corruptor_event_stop_signal_start", "sergeant_a"),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_propaganda_corruptor_event_stop_signal_end", "sergeant_a")
		}
		local failed_rules = result

		table.array_remove_if(failed_rules, function (value)
			return value == "success"
		end)

		if table.is_empty(failed_rules) then
			return "All VO rules were triggered"
		end

		return "The following rules were not triggered " .. table.concat(failed_rules, "\n")
	end)
end

AudioTestCases.vo_rules_dm_stockpile = function ()
	Testify:run_case(function (dt, t)
		if TestifySnippets.is_debug_stripped() or BUILD == "release" then
			TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
			TestifySnippets.load_mission("dm_stockpile")
		end

		Testify:make_request("wait_for_state_gameplay_reached")

		local result = {
			TestifySnippets.trigger_vo_query_mission_brief("mission_stockpile_briefing_a", "sergeant_a"),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_stockpile_tarp_town", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_stockpile_cartel_hq", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_stockpile_main_access", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_stockpile_cartel_habs", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_stockpile_bridge", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_stockpile_survive_event_start", "sergeant_a"),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_stockpile_survive_event_end", "sergeant_a"),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_stockpile_elevator_conversation_one_a", 3),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_stockpile_elevator_conversation_two_a", 3),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_stockpile_elevator_conversation_three_a", 3),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_stockpile_bazaar", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_stockpile_holo_statue", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_stockpile_ruined_hab", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_stockpile_through_to_silo", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_stockpile_end_event_start", "sergeant_a"),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_stockpile_clean_water", "sergeant_a")
		}
		local failed_rules = result

		table.array_remove_if(failed_rules, function (value)
			return value == "success"
		end)

		if table.is_empty(failed_rules) then
			return "All VO rules were triggered"
		end

		return "The following rules were not triggered " .. table.concat(failed_rules, "\n")
	end)
end

AudioTestCases.vo_rules_event_kill = function ()
	Testify:run_case(function (dt, t)
		if TestifySnippets.is_debug_stripped() or BUILD == "release" then
			TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
			TestifySnippets.load_mission("km_station")
		end

		Testify:make_request("wait_for_state_gameplay_reached")

		local result = {
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("event_kill_kill_the_target", "explicator_a"),
			TestifySnippets.trigger_vo_query_player_generic_vo("event_kill_target_damaged"),
			TestifySnippets.trigger_vo_query_player_generic_vo("event_kill_target_destroyed_a"),
			TestifySnippets.trigger_vo_query_player_generic_vo("event_kill_target_heavy_damage_a")
		}
		local failed_rules = result

		table.array_remove_if(failed_rules, function (value)
			return value == "success"
		end)

		if table.is_empty(failed_rules) then
			return "All VO rules were triggered"
		end

		return "The following rules were not triggered " .. table.concat(failed_rules, "\n")
	end)
end

AudioTestCases.vo_rules_fm_cargo = function ()
	Testify:run_case(function (dt, t)
		if TestifySnippets.is_debug_stripped() or BUILD == "release" then
			TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
			TestifySnippets.load_mission("fm_cargo")
		end

		Testify:make_request("wait_for_state_gameplay_reached")

		local result = {
			TestifySnippets.trigger_vo_query_mission_brief("mission_cargo_briefing_a", "sergeant_a"),
			TestifySnippets.trigger_vo_query_player_look_at("mission_cargo_start_banter_a", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_cargo_hab_feed_lines", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_cargo_labyrinth", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_cargo_worker_cloister", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_cargo_something_big", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_cargo_production_line", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_cargo_mid_event_start", "sergeant_a"),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_cargo_mid_event_end", "sergeant_a"),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_cargo_coolant_control"),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_cargo_end_event_conversation_one_a"),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_cargo_end_event_conversation_two_a"),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_cargo_end_event_conversation_three_a"),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_cargo_consignment_yard", "sergeant_a"),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_cargo_reinforcements", "sergeant_a")
		}
		local failed_rules = result

		table.array_remove_if(failed_rules, function (value)
			return value == "success"
		end)

		if table.is_empty(failed_rules) then
			return "All VO rules were triggered"
		end

		return "The following rules were not triggered " .. table.concat(failed_rules, "\n")
	end)
end

AudioTestCases.vo_rules_hm_cartel = function ()
	Testify:run_case(function (dt, t)
		if TestifySnippets.is_debug_stripped() or BUILD == "release" then
			TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
			TestifySnippets.load_mission("hm_cartel")
		end

		Testify:make_request("wait_for_state_gameplay_reached")

		local result = {
			TestifySnippets.trigger_vo_query_mission_brief("mission_cartel_brief_one", "sergeant_a"),
			TestifySnippets.trigger_vo_query_player_look_at("mission_cartel_shanty", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_cartel_mudlark", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_cartel_keep_moving", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at(common_missions_look_at_tag.asset_water_course, default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_cartel_pillar", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_cartel_checkpoint", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_cartel_find_bazaar", "sergeant_a"),
			TestifySnippets.trigger_vo_query_player_look_at("mission_cartel_old_hab", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_cartel_town_centre", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at(common_missions_look_at_tag.asset_cartel_insignia, default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at(common_missions_look_at_tag.asset_acid_clouds, default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_generic_vo("mission_cartel_reach_bazaar"),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_cartel_get_passcodes", "sergeant_a"),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_cartel_elevator_access", "sergeant_a"),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_cartel_keep_moving", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_cartel_use_passcode", "sergeant_a"),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_cartel_disable_security", "sergeant_a"),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_cartel_upload", "sergeant_a")
		}
		local failed_rules = result

		table.array_remove_if(failed_rules, function (value)
			return value == ""
		end)

		if table.is_empty(failed_rules) then
			return "All VO rules were triggered"
		end

		return "The following rules were not triggered " .. table.concat(failed_rules, "\n")
	end)
end

AudioTestCases.vo_rules_hm_strain = function ()
	Testify:run_case(function (dt, t)
		if TestifySnippets.is_debug_stripped() or BUILD == "release" then
			TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
			TestifySnippets.load_mission("hm_strain")
		end

		Testify:make_request("wait_for_state_gameplay_reached")

		local result = {
			TestifySnippets.trigger_vo_query_mission_brief("mission_strain_briefing_a", "sergeant_a"),
			TestifySnippets.trigger_vo_query_player_look_at("mission_strain_start_banter_a", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_strain_atmosphere_shield", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_strain_reach_hangar", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_strain_elevator_found", default_vo_look_at_distance),
			TestifySnippets.trigger_mission_giver_conversation_starter("mission_strain_mid_elevator_conversation_one_a", "sergeant_a"),
			TestifySnippets.trigger_mission_giver_conversation_starter("mission_strain_mid_elevator_conversation_two_a", "sergeant_a"),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_strain_mid_elevator_conversation_three_a"),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_strain_cross_hangar", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_strain_crossroads", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_strain_follow_pipes", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_strain_reach_flow_control", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_strain_mid_event_start", "sergeant_a"),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_strain_mid_event_complete", "sergeant_a"),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_strain_mid_event_conversation_one_a"),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_strain_mid_event_conversation_two_a"),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_strain_mid_event_conversation_three_a"),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_strain_keep_following_pipes", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_strain_inert_tanks", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_strain_daemonic_overgrowth_a", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_strain_end_event_start", "sergeant_a"),
			TestifySnippets.trigger_vo_query_player_look_at("asset_foul_smoke", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_strain_job_done", "sergeant_a"),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_strain_demolish_door", "sergeant_a")
		}
		local failed_rules = result

		table.array_remove_if(failed_rules, function (value)
			return value == "success"
		end)

		if table.is_empty(failed_rules) then
			return "All VO rules were triggered"
		end

		return "The following rules were not triggered " .. table.concat(failed_rules, "\n")
	end)
end

AudioTestCases.vo_rules_km_enforcer = function ()
	Testify:run_case(function (dt, t)
		if TestifySnippets.is_debug_stripped() or BUILD == "release" then
			TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
			TestifySnippets.load_mission("km_enforcer")
		end

		Testify:make_request("wait_for_state_gameplay_reached")

		local result = {
			TestifySnippets.trigger_vo_query_mission_brief("mission_enforcer_briefing_a", "sergeant_a", 3),
			TestifySnippets.trigger_vo_query_player_look_at("mission_enforcer_start_banter_a", default_vo_look_at_distance, 4),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_enforcer_maintenance_area", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_enforcer_infrastructure", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_enforcer_hab_support", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_enforcer_activate_stair", "sergeant_a"),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_enforcer_event_survive", "sergeant_a"),
			TestifySnippets.trigger_vo_query_player_generic_vo("event_survive_keep_coming_a"),
			TestifySnippets.trigger_vo_query_player_generic_vo("event_survive_almost_done"),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_enforcer_stairs_arrived", "sergeant_a"),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_enforcer_through_hab", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_enforcer_wonky_hab", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_enforcer_traders_row", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_enforcer_enforcer_station", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_enforcer_courtroom_waypoint", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_enforcer_courtroom", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_enforcer_reach_cells", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "access_elevator", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_enforcer_end_event_conversation_one_a", 3),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_enforcer_end_event_conversation_two_a", 3),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_enforcer_end_event_conversation_three_a", 3)
		}
		local failed_rules = result

		table.array_remove_if(failed_rules, function (value)
			return value == "success"
		end)

		if table.is_empty(failed_rules) then
			return "All VO rules were triggered"
		end

		return "The following rules were not triggered " .. table.concat(failed_rules, "\n")
	end)
end

AudioTestCases.vo_rules_km_station = function ()
	Testify:run_case(function (dt, t)
		if TestifySnippets.is_debug_stripped() or BUILD == "release" then
			TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
			TestifySnippets.load_mission("km_station")
		end

		Testify:make_request("wait_for_state_gameplay_reached")

		local result = {
			TestifySnippets.trigger_vo_query_mission_brief("mission_station_briefing_a", "explicator_a"),
			TestifySnippets.trigger_vo_query_player_look_at("mission_station_start_banter_a", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_station_tanks", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_station_the_bridge", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_station_head_to_market", "explicator_a"),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_station_interrogate_splice_point", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_station_upload_schedule", "explicator_a"),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("info_mission_station_second_objective", "explicator_a"),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_station_mid_event_conversation_one_a"),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_station_mid_event_conversation_two_a"),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_station_mid_event_conversation_three_a"),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_station_maintenance_bay", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_station_approach", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_station_interrogation_bay_a", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_station_enter_station", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_station_station_hall", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_station_contrabrand_lockers", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_station_cross_station", default_vo_look_at_distance),
			TestifySnippets.trigger_mission_giver_conversation_starter("mission_station_end_event_conversation_one_a", "explicator_a"),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_station_end_event_conversation_two_a"),
			TestifySnippets.trigger_mission_giver_conversation_starter("mission_station_end_event_conversation_three_a", "sergeant_a")
		}
		local failed_rules = result

		table.array_remove_if(failed_rules, function (value)
			return value == "success"
		end)

		if table.is_empty(failed_rules) then
			return "All VO rules were triggered"
		end

		return "The following rules were not triggered " .. table.concat(failed_rules, "\n")
	end)
end

AudioTestCases.vo_rules_lm_rails = function ()
	Testify:run_case(function (dt, t)
		if TestifySnippets.is_debug_stripped() or BUILD == "release" then
			TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
			TestifySnippets.load_mission("lm_rails")
		end

		Testify:make_request("wait_for_state_gameplay_reached")

		local result = {
			TestifySnippets.trigger_vo_query_mission_brief("mission_rails_briefing_a", "sergeant_a", 3),
			TestifySnippets.trigger_vo_query_player_look_at("mission_rails_start_banter_a", default_vo_look_at_distance, 4),
			TestifySnippets.trigger_vo_query_player_look_at("mission_rails_hab_block_dreyko", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_player_look_at("mission_rails_district_gate", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_rails_refectory", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_rails_station_approach", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_faction_look_at("npc", "mission_rails_descend_shaft", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_rails_hack_access_door", "sergeant_a"),
			TestifySnippets.trigger_vo_query_player_look_at("asset_unnatural_dark_a", default_vo_look_at_distance, 2),
			TestifySnippets.trigger_vo_query_player_look_at("mission_rails_trains", default_vo_look_at_distance),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_rails_maintenance_bay", "sergeant_a"),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_rails_lower_track", "sergeant_a"),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_rails_set_charge", "sergeant_a"),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_rails_logistratum", "sergeant_a"),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_rails_end_event_conversation_one_a", 3),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_rails_end_event_conversation_two_a", 3),
			TestifySnippets.trigger_vo_query_player_environmental_story_vo("mission_rails_end_event_conversation_three_a", 3),
			TestifySnippets.trigger_vo_query_player_generic_vo("mission_rails_disable_skyfire_a", 2),
			TestifySnippets.trigger_vo_query_mission_giver_mission_info("mission_rails_event_grab_supplies", "sergeant_a")
		}
		local failed_rules = result

		table.array_remove_if(failed_rules, function (value)
			return value == "success"
		end)

		if table.is_empty(failed_rules) then
			return "All VO rules were triggered"
		end

		return "The following rules were not triggered " .. table.concat(failed_rules, "\n")
	end)
end

AudioTestCases.vo_rules_smart_tag_com_wheel = function ()
	Testify:run_case(function (dt, t)
		if TestifySnippets.is_debug_stripped() or BUILD == "release" then
			TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
			TestifySnippets.load_mission("spawn_all_enemies")
		end

		Testify:make_request("wait_for_state_gameplay_reached")

		local concept_com_wheel = VOQueryConstants.concepts.on_demand_com_wheel
		local concept_item_tag = VOQueryConstants.concepts.on_demand_vo_tag_item
		local concept_enemy_tag = VOQueryConstants.concepts.on_demand_vo_tag_enemy
		local result = {
			TestifySnippets.trigger_vo_on_demand(concept_com_wheel, "com_need_ammo", 1),
			TestifySnippets.trigger_vo_on_demand(concept_com_wheel, "com_need_health", 1),
			TestifySnippets.trigger_vo_on_demand(concept_com_wheel, "com_thank_you", 1),
			TestifySnippets.trigger_vo_on_demand(concept_com_wheel, "location_over_here", 1),
			TestifySnippets.trigger_vo_on_demand(concept_com_wheel, "location_this_way", 1),
			TestifySnippets.trigger_vo_on_demand(concept_com_wheel, "location_enemy_there", 1),
			TestifySnippets.trigger_vo_on_demand(concept_com_wheel, "answer_yes", 1),
			TestifySnippets.trigger_vo_on_demand(concept_com_wheel, "answer_no", 1),
			TestifySnippets.trigger_vo_on_demand(concept_com_wheel, "answer_following", 1),
			TestifySnippets.trigger_vo_on_demand(concept_com_wheel, "answer_need", 1),
			TestifySnippets.trigger_vo_on_demand(concept_com_wheel, "com_cheer", 1),
			TestifySnippets.trigger_vo_on_demand(concept_item_tag, "pup_ammo", 1),
			TestifySnippets.trigger_vo_on_demand(concept_item_tag, "pup_wound_recovery", 1),
			TestifySnippets.trigger_vo_on_demand(concept_item_tag, "pup_health_kit", 1),
			TestifySnippets.trigger_vo_on_demand(concept_item_tag, "pup_melta_bomb", 1),
			TestifySnippets.trigger_vo_on_demand(concept_item_tag, "pup_syringe", 1),
			TestifySnippets.trigger_vo_on_demand(concept_item_tag, "pup_collectible_a", 1),
			TestifySnippets.trigger_vo_on_demand(concept_item_tag, "pup_collectible_b", 1),
			TestifySnippets.trigger_vo_on_demand(concept_item_tag, "station_health", 1),
			TestifySnippets.trigger_vo_on_demand(concept_item_tag, "station_revive", 1),
			TestifySnippets.trigger_vo_on_demand(concept_enemy_tag, "renegade_sniper", 1),
			TestifySnippets.trigger_vo_on_demand(concept_enemy_tag, "renegade_netgunner", 1),
			TestifySnippets.trigger_vo_on_demand(concept_enemy_tag, "renegade_grenadier", 1),
			TestifySnippets.trigger_vo_on_demand(concept_enemy_tag, "cultist_grenadier", 1),
			TestifySnippets.trigger_vo_on_demand(concept_enemy_tag, "renegade_flamer", 1),
			TestifySnippets.trigger_vo_on_demand(concept_enemy_tag, "chaos_daemonhost", 1),
			TestifySnippets.trigger_vo_on_demand(concept_enemy_tag, "chaos_plague_ogryn", 1),
			TestifySnippets.trigger_vo_on_demand(concept_enemy_tag, "renegade_gunner", 1),
			TestifySnippets.trigger_vo_on_demand(concept_enemy_tag, "chaos_ogryn_heavy_gunner", 1),
			TestifySnippets.trigger_vo_on_demand(concept_enemy_tag, "renegade_shocktrooper", 1),
			TestifySnippets.trigger_vo_on_demand(concept_enemy_tag, "chaos_ogryn_armored_executor", 1),
			TestifySnippets.trigger_vo_on_demand(concept_enemy_tag, "chaos_ogryn_bulwark", 1),
			TestifySnippets.trigger_vo_on_demand(concept_enemy_tag, "chaos_poxwalker_bomber", 1),
			TestifySnippets.trigger_vo_on_demand(concept_enemy_tag, "chaos_hound", 1),
			TestifySnippets.trigger_vo_on_demand(concept_enemy_tag, "chaos_mutant_charger", 1),
			TestifySnippets.trigger_vo_on_demand(concept_enemy_tag, "cultist_holy_stubber_gunner", 1),
			TestifySnippets.trigger_vo_on_demand(concept_enemy_tag, "cultist_shocktrooper", 1)
		}
		local failed_rules = result

		table.array_remove_if(failed_rules, function (value)
			return value == "success"
		end)

		if table.is_empty(failed_rules) then
			return "All VO rules were triggered"
		end

		return "The following rules were not triggered " .. table.concat(failed_rules, "\n")
	end)
end
