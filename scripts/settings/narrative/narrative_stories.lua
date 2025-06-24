-- chunkname: @scripts/settings/narrative/narrative_stories.lua

local PlayerProgressionUnlocks = require("scripts/settings/player/player_progression_unlocks")

local function level_at_least(x)
	return function (player_profile)
		return player_profile.current_level >= x
	end
end

local function facility_unlocked(facility)
	return function ()
		local progression_data = Managers.data_service.mission_board:get_hub_facilities_progression_data()
		local progression_mission = progression_data and progression_data[facility]
		local locked = progression_mission and not progression_mission.unlocked or not progression_mission

		return not locked
	end
end

local function game_mode_unlocked(game_mode)
	return function ()
		local game_mode_data = Managers.data_service.mission_board:get_game_modes_progression_data()
		local game_mode_progression = game_mode_data and game_mode_data[game_mode]
		local locked = game_mode_progression and not game_mode_progression.unlocked or not game_mode_progression

		return not locked
	end
end

local function journey_mission_completed(mission)
	return function ()
		local mission_data = Managers.data_service.mission_board:get_filtered_missions_data()
		local story_missions = mission_data.story
		local mission_completed = story_missions and story_missions[mission] and story_missions[mission].completed

		return mission_completed
	end
end

local function last_completed_chapter_is(story_name, chapter_name)
	return function ()
		local completed_chapter = Managers.narrative:last_completed_chapter(story_name)

		if completed_chapter then
			local completed_chapter_name = completed_chapter.name

			return completed_chapter_name == chapter_name
		end
	end
end

local function journey_skipped()
	return function ()
		local character_campaign_data = Managers.data_service.mission_board:get_filtered_campaigns_data()
		local player_journey_data = character_campaign_data.player_journey and character_campaign_data.player_journey
		local has_completed_player_journey = player_journey_data and player_journey_data.completed or false

		if has_completed_player_journey then
			return true
		end
	end
end

local function event_done(event_name)
	return function (player_profile)
		return Managers.narrative:is_event_complete(event_name)
	end
end

local function events_done(event_names)
	return function ()
		local narrative_manager = Managers.narrative

		for i = 1, #event_names do
			local event_name = event_names[i]

			if not narrative_manager:is_event_complete(event_name) then
				return false
			end
		end

		return true
	end
end

local function beyond_story_chapter(story_name, chapter_name)
	return function ()
		return Managers.narrative:is_chapter_complete(story_name, chapter_name)
	end
end

local function is_story_complete(story_name)
	return function ()
		return Managers.narrative:is_story_complete(story_name)
	end
end

local function on_story_chapter(story_name, chapter_name)
	return function ()
		local narrative_manager = Managers.narrative
		local my_chapter = narrative_manager:chapter_by_name(story_name, chapter_name)

		if my_chapter then
			local current_chapter = narrative_manager:current_chapter(story_name)

			if current_chapter then
				return my_chapter.index == current_chapter.index
			else
				return true
			end
		end

		return false
	end
end

local function complete_current_story_chapter(story_name)
	return function ()
		Managers.narrative:complete_current_chapter(story_name)
	end
end

local function last_completed_chapter(story_name)
	return function ()
		Managers.narrative:last_completed_chapter(story_name)
	end
end

local function _player_profile()
	local local_player_id = 1
	local player = Managers.player:local_player(local_player_id)
	local profile = player:profile()

	return profile
end

local function _should_archetype_skip_onboarding_chapter(chapter, archetype)
	local chapter_name = chapter.name
	local archetype_chapters_to_skip = archetype.skip_onboarding_chapters

	return archetype_chapters_to_skip and archetype_chapters_to_skip[chapter_name] or false
end

local function _get_archetype_onboarding_intro_video_template_name(player_profile)
	local archetype = player_profile.archetype

	return archetype.onboarding_intro_video_template_name or nil
end

local function _archetype_has_onboarding_intro_video(player_profile)
	local onboarding_intro_video_template_name = _get_archetype_onboarding_intro_video_template_name(player_profile)

	return onboarding_intro_video_template_name ~= nil
end

local function achievement_unlocked(achievement_name)
	return function ()
		local player = Managers.player:local_player(1)

		Managers.achievements:unlock_achievement(player, achievement_name)
	end
end

local function on_path_of_trust_chapter_completion(achievement_name)
	return function ()
		Managers.event:trigger("event_on_path_of_trust_updated")

		if achievement_name then
			local player = Managers.player:local_player(1)

			Managers.achievements:unlock_achievement(player, achievement_name, true)
		end
	end
end

local function can_start_path_of_trust(required_level)
	return function (player_profile)
		return player_profile.current_level >= required_level and Managers.narrative:is_event_complete("onboarding_step_chapel_video_viewed")
	end
end

local function set_account_has_completed_onboarding()
	return function ()
		Managers.data_service.account:set_has_completed_onboarding()
	end
end

local narrative = {
	stories = {
		main_story = {
			{
				backend_id = 1,
				name = "km_station",
				requirement = journey_mission_completed("km_station"),
			},
			{
				backend_id = 2,
				name = "dm_stockpile",
				requirement = journey_mission_completed("dm_stockpile"),
			},
			{
				backend_id = 3,
				name = "hm_cartel",
				requirement = journey_mission_completed("hm_cartel"),
			},
			{
				backend_id = 4,
				name = "km_enforcer",
				requirement = journey_mission_completed("km_enforcer"),
			},
			{
				backend_id = 5,
				name = "cm_habs",
				requirement = journey_mission_completed("cm_habs"),
			},
			{
				backend_id = 6,
				name = "dm_propaganda_1_0",
				requirement = on_story_chapter("main_story", "km_enforcer") and journey_mission_completed("dm_propaganda"),
			},
			{
				backend_id = 7,
				name = "fm_cargo_0_1",
				requirement = on_story_chapter("main_story", "km_enforcer") and journey_mission_completed("fm_cargo"),
			},
			{
				backend_id = 8,
				name = "fm_cargo_1_1",
				requirement = last_completed_chapter_is("main_story", "dm_propaganda_1_0") and journey_mission_completed("fm_cargo"),
			},
			{
				backend_id = 9,
				name = "hm_strain_2_0",
				requirement = last_completed_chapter_is("main_story", "dm_propaganda_1_0") and journey_mission_completed("hm_strain"),
			},
			{
				backend_id = 10,
				name = "dm_propaganda_1_1",
				requirement = last_completed_chapter_is("main_story", "fm_cargo_0_1") and journey_mission_completed("dm_propaganda"),
			},
			{
				backend_id = 11,
				name = "core_research_0_2",
				requirement = last_completed_chapter_is("main_story", "fm_cargo_0_1") and journey_mission_completed("core_research"),
			},
			{
				backend_id = 12,
				name = "hm_strain_2_1",
				requirement = (last_completed_chapter_is("main_story", "fm_cargo_1_1") or last_completed_chapter_is("main_story", "dm_propaganda_1_1")) and journey_mission_completed("hm_strain"),
			},
			{
				backend_id = 13,
				name = "core_research_1_2",
				requirement = (last_completed_chapter_is("main_story", "fm_cargo_1_1") or last_completed_chapter_is("main_story", "dm_propaganda_1_1")) and journey_mission_completed("core_research"),
			},
			{
				backend_id = 14,
				name = "fm_cargo_2_1",
				requirement = last_completed_chapter_is("main_story", "hm_strain_2_0") and journey_mission_completed("fm_cargo"),
			},
			{
				backend_id = 15,
				name = "dm_propaganda_1_2",
				requirement = last_completed_chapter_is("main_story", "core_research_0_2") and journey_mission_completed("dm_propaganda"),
			},
			{
				backend_id = 16,
				name = "core_research_2_2",
				requirement = (last_completed_chapter_is("main_story", "fm_cargo_2_1") or last_completed_chapter_is("main_story", "hm_strain_2_1")) and journey_mission_completed("core_research"),
			},
			{
				backend_id = 17,
				name = "hm_strain_2_2",
				requirement = (last_completed_chapter_is("main_story", "core_research_1_2") or last_completed_chapter_is("main_story", "dm_propaganda_1_2")) and journey_mission_completed("hm_strain"),
			},
			{
				backend_id = 18,
				name = "fm_armoury",
				requirement = journey_mission_completed("fm_armoury"),
			},
			{
				backend_id = 19,
				name = "cm_raid",
				requirement = journey_mission_completed("cm_raid"),
			},
			{
				backend_id = 20,
				name = "km_enforcer_twins",
				requirement = journey_mission_completed("km_enforcer_twins"),
			},
			{
				backend_id = 21,
				name = "fm_resurgence_1_0",
				requirement = journey_mission_completed("fm_resurgence"),
			},
			{
				backend_id = 22,
				name = "dm_rise_0_1",
				requirement = journey_mission_completed("dm_rise"),
			},
			{
				backend_id = 23,
				name = "cm_archives_2_0",
				requirement = last_completed_chapter_is("main_story", "fm_resurgence_1_0") and journey_mission_completed("cm_archives"),
			},
			{
				backend_id = 24,
				name = "dm_rise_1_1",
				requirement = last_completed_chapter_is("main_story", "fm_resurgence_1_0") and journey_mission_completed("fm_resurgence"),
			},
			{
				backend_id = 25,
				name = "fm_resurgence_1_1",
				requirement = last_completed_chapter_is("main_story", "dm_rise_0_1") and journey_mission_completed("fm_resurgence"),
			},
			{
				backend_id = 26,
				name = "hm_complex_3_0",
				requirement = last_completed_chapter_is("main_story", "cm_archives_2_0") and journey_mission_completed("hm_complex"),
			},
			{
				backend_id = 27,
				name = "dm_rise_2_1",
				requirement = last_completed_chapter_is("main_story", "cm_archives_2_0") and journey_mission_completed("dm_rise"),
			},
			{
				backend_id = 28,
				name = "cm_archives_2_1",
				requirement = (last_completed_chapter_is("main_story", "dm_rise_1_1") or last_completed_chapter_is("main_story", "fm_resurgence_1_1")) and journey_mission_completed("cm_archives"),
			},
			{
				backend_id = 29,
				name = "dm_rise_3_1",
				requirement = (last_completed_chapter_is("main_story", "hm_complex_3_0") or last_completed_chapter_is("main_story", "cm_archives_2_1")) and journey_mission_completed("dm_rise"),
			},
			{
				backend_id = 30,
				name = "hm_complex_3_1",
				requirement = (last_completed_chapter_is("main_story", "dm_rise_2_1") or last_completed_chapter_is("main_story", "cm_archives_2_1")) and journey_mission_completed("hm_complex"),
			},
			{
				backend_id = 31,
				name = "km_heresy",
				requirement = journey_mission_completed("km_heresy") or journey_skipped(),
			},
		},
		onboarding = {
			{
				backend_id = 1,
				name = "play_prologue",
				data = {
					mission_name = "prologue",
				},
				archetype_skip_func = _should_archetype_skip_onboarding_chapter,
				on_complete = achievement_unlocked("prologue"),
			},
			{
				backend_id = 2,
				name = "speak_to_morrow",
				data = {
					mission_name = "om_hub_01",
				},
				archetype_skip_func = _should_archetype_skip_onboarding_chapter,
				on_skip = function ()
					local player_profile = _player_profile()
					local archetype_custom_intro_video = _get_archetype_onboarding_intro_video_template_name(player_profile)

					if archetype_custom_intro_video ~= nil then
						Managers.narrative:complete_event("onboarding_step_archetype_intro_video_viewed")
						Managers.video:queue_video(archetype_custom_intro_video)
					end
				end,
			},
			{
				backend_id = 3,
				name = "go_to_training",
				data = {
					mission_name = "om_hub_01",
				},
			},
			{
				backend_id = 4,
				name = "play_training",
				data = {
					mission_name = "om_basic_combat_01",
				},
				on_complete = achievement_unlocked("basic_training"),
			},
			{
				backend_id = 5,
				name = "training_reward",
				data = {
					mission_name = "om_hub_02",
				},
				archetype_skip_func = _should_archetype_skip_onboarding_chapter,
			},
			{
				backend_id = 6,
				name = "inventory_popup",
				data = {
					mission_name = "om_hub_02",
				},
				archetype_skip_func = _should_archetype_skip_onboarding_chapter,
			},
			{
				backend_id = 7,
				name = "visit_chapel",
				data = {
					mission_name = "om_hub_02",
				},
				archetype_skip_func = _should_archetype_skip_onboarding_chapter,
				on_complete = set_account_has_completed_onboarding(),
			},
		},
		path_of_trust = {
			{
				backend_id = 1,
				name = "pot_story_traitor_first",
				data = {
					localization_key = "loc_progression_step_01",
					vo_story_stage = "pot_1",
					level_to_reach = PlayerProgressionUnlocks.pot_story_traitor_first,
				},
				requirement = can_start_path_of_trust(PlayerProgressionUnlocks.pot_story_traitor_first),
				on_complete = on_path_of_trust_chapter_completion("path_of_trust_1"),
			},
			{
				backend_id = 2,
				name = "pot_crafting",
				data = {
					localization_key = "loc_progression_step_02",
					vo_story_stage = "pot_2",
					level_to_reach = PlayerProgressionUnlocks.pot_crafting,
				},
				requirement = level_at_least(PlayerProgressionUnlocks.pot_crafting),
				on_complete = on_path_of_trust_chapter_completion("unlock_crafting"),
			},
			{
				backend_id = 3,
				name = "pot_gadgets",
				data = {
					localization_key = "loc_progression_step_03",
					vo_story_stage = "pot_3",
					level_to_reach = PlayerProgressionUnlocks.pot_gadgets,
				},
				requirement = level_at_least(PlayerProgressionUnlocks.pot_gadgets),
				on_complete = on_path_of_trust_chapter_completion("unlock_gadgets"),
			},
			{
				backend_id = 4,
				name = "pot_contracts",
				data = {
					localization_key = "loc_progression_step_04",
					vo_story_stage = "pot_4",
					level_to_reach = PlayerProgressionUnlocks.pot_contracts,
				},
				requirement = level_at_least(PlayerProgressionUnlocks.pot_gadgets),
			},
			{
				backend_id = 5,
				name = "pot_story_traitor_second",
				data = {
					localization_key = "loc_progression_step_05",
					vo_story_stage = "pot_5",
					level_to_reach = PlayerProgressionUnlocks.pot_story_traitor_second,
				},
				requirement = level_at_least(PlayerProgressionUnlocks.pot_story_traitor_second),
				on_complete = on_path_of_trust_chapter_completion("path_of_trust_2"),
			},
			{
				backend_id = 6,
				name = "pot_story_masozi",
				data = {
					localization_key = "loc_progression_step_06",
					vo_story_stage = "pot_6",
					level_to_reach = PlayerProgressionUnlocks.pot_story_masozi,
				},
				requirement = level_at_least(PlayerProgressionUnlocks.pot_story_masozi),
				on_complete = on_path_of_trust_chapter_completion("path_of_trust_3"),
			},
			{
				backend_id = 7,
				name = "pot_story_hadron",
				data = {
					localization_key = "loc_progression_step_07",
					vo_story_stage = "pot_7",
					level_to_reach = PlayerProgressionUnlocks.pot_story_hadron,
				},
				requirement = level_at_least(PlayerProgressionUnlocks.pot_story_hadron),
				on_complete = on_path_of_trust_chapter_completion("path_of_trust_4"),
			},
			{
				backend_id = 8,
				name = "pot_story_do_or_die",
				data = {
					localization_key = "loc_progression_step_08",
					vo_story_stage = "pot_8",
					level_to_reach = PlayerProgressionUnlocks.pot_story_do_or_die,
				},
				requirement = level_at_least(PlayerProgressionUnlocks.pot_story_do_or_die),
				on_complete = on_path_of_trust_chapter_completion("path_of_trust_5"),
			},
			{
				backend_id = 9,
				name = "pot_story_final",
				data = {
					localization_key = "loc_progression_step_09",
					vo_story_stage = "pot_9",
					level_to_reach = PlayerProgressionUnlocks.pot_story_final,
				},
				requirement = level_at_least(PlayerProgressionUnlocks.pot_story_final),
				on_complete = on_path_of_trust_chapter_completion("path_of_trust_6"),
			},
		},
		s1_twins = {
			{
				backend_id = 1,
				name = "s1_twins_prologue",
				requirement = event_done("onboarding_step_mission_board_introduction"),
				narrative_mission_requirement = {
					1,
					1,
					1,
				},
			},
			{
				backend_id = 2,
				name = "s1_twins_mission",
				requirement = beyond_story_chapter("s1_twins", "s1_twins_prologue"),
			},
			{
				backend_id = 3,
				name = "s1_twins_epilogue_1",
				requirement = beyond_story_chapter("s1_twins", "s1_twins_mission"),
			},
			{
				backend_id = 4,
				name = "s1_twins_epilogue_2",
				requirement = beyond_story_chapter("s1_twins", "s1_twins_epilogue_1"),
			},
			{
				backend_id = 5,
				name = "s1_twins_epilogue_3",
				requirement = beyond_story_chapter("s1_twins", "s1_twins_epilogue_2"),
			},
		},
		s1_q3 = {
			{
				backend_id = 1,
				name = "itemization_intro",
				requirement = event_done("onboarding_step_mission_board_introduction"),
			},
			{
				backend_id = 2,
				name = "commissar_intro",
				requirement = beyond_story_chapter("s1_q3", "itemization_intro"),
			},
		},
		s1_q4 = {
			{
				backend_id = 1,
				name = "heresy_intro",
				requirement = event_done("onboarding_step_mission_board_introduction"),
			},
		},
		horde_intro = {
			{
				backend_id = 1,
				name = "horde_intro",
				requirement = game_mode_unlocked(PlayerProgressionUnlocks.horde_progression),
			},
		},
		level_unlock_popups = {
			{
				backend_id = 1,
				name = "level_unlock_credits_store_popup",
				requirement = beyond_story_chapter("path_of_trust", "pot_story_traitor_first"),
			},
			{
				backend_id = 2,
				name = "level_unlock_mission_board_popup_difficulty_increased_1",
				requirement = level_at_least(PlayerProgressionUnlocks.mission_difficulty_unlocks.normal[3]),
			},
			{
				backend_id = 3,
				name = "level_unlock_crafting_station_popup",
				requirement = beyond_story_chapter("path_of_trust", "pot_crafting"),
			},
			{
				backend_id = 4,
				name = "level_unlock_talent_tier_1",
			},
			{
				backend_id = 5,
				name = "level_unlock_gadget_slot_1",
				requirement = beyond_story_chapter("path_of_trust", "pot_gadgets"),
			},
			{
				backend_id = 6,
				name = "level_unlock_mission_board_popup_difficulty_increased_2",
				requirement = level_at_least(PlayerProgressionUnlocks.mission_difficulty_unlocks.normal[4]),
			},
			{
				backend_id = 7,
				name = "level_unlock_talent_tier_2",
			},
			{
				backend_id = 8,
				name = "level_unlock_contract_store_popup",
				requirement = beyond_story_chapter("path_of_trust", "pot_contracts"),
			},
			{
				backend_id = 9,
				name = "level_unlock_mission_board_popup_difficulty_increased_3",
				requirement = level_at_least(PlayerProgressionUnlocks.mission_difficulty_unlocks.normal[5]),
			},
			{
				backend_id = 10,
				name = "level_unlock_gadget_slot_2",
				requirement = level_at_least(PlayerProgressionUnlocks.gadget_slot_2),
			},
			{
				backend_id = 11,
				name = "level_unlock_talent_tier_3",
			},
			{
				backend_id = 12,
				name = "level_unlock_talent_tier_4",
			},
			{
				backend_id = 13,
				name = "level_unlock_gadget_slot_3",
				requirement = level_at_least(PlayerProgressionUnlocks.gadget_slot_3),
			},
			{
				backend_id = 14,
				name = "level_unlock_talent_tier_5",
			},
			{
				backend_id = 15,
				name = "level_unlock_talent_tier_6",
			},
		},
		unlock_havoc = {
			{
				backend_id = 1,
				name = "unlock_havoc_1",
				requirement = is_story_complete("path_of_trust"),
			},
			{
				backend_id = 2,
				name = "unlock_havoc_2",
				requirement = beyond_story_chapter("unlock_havoc", "unlock_havoc_1"),
			},
			{
				backend_id = 3,
				name = "unlock_havoc_3",
				requirement = beyond_story_chapter("unlock_havoc", "unlock_havoc_2"),
			},
		},
	},
	events = {
		mission_board = {},
		crafting_table = {},
		onboarding_step_archetype_intro_video_viewed = {
			requirement = _archetype_has_onboarding_intro_video,
		},
		onboarding_step_chapel_video_viewed = {},
		onboarding_step_chapel_cutscene_played = {
			requirement = event_done("onboarding_step_chapel_video_viewed"),
		},
		onboarding_step_mission_board_introduction = {
			requirement = event_done("onboarding_step_chapel_cutscene_played"),
		},
		level_unlock_credits_store_visited = {
			requirement = facility_unlocked(PlayerProgressionUnlocks.credits_vendor),
		},
		level_unlock_crafting_station_visited = {
			requirement = facility_unlocked(PlayerProgressionUnlocks.crafting),
		},
		level_unlock_contract_store_visited = {
			requirement = facility_unlocked(PlayerProgressionUnlocks.contracts),
		},
		level_unlock_cosmetic_store_visited = {
			requirement = facility_unlocked(PlayerProgressionUnlocks.cosmetics_vendor),
		},
		level_unlock_cosmetic_store_popup = {
			requirement = facility_unlocked(PlayerProgressionUnlocks.cosmetics_vendor),
		},
		level_unlock_premium_store_visited = {
			requirement = level_at_least(PlayerProgressionUnlocks.premium_store),
		},
		level_unlock_barber_visited = {
			requirement = level_at_least(PlayerProgressionUnlocks.barber),
		},
		hli_mission_board_viewed = {},
		hli_barbershop_viewed = {},
		hli_contracts_viewed = {},
		hli_crafting_station_underground_viewed = {},
		hli_gun_shop_viewed = {},
		hli_penances_viewed = {},
		s1_intro_viewed = {},
		core_research_intro_viewed = {},
	},
}

for _, chapters in pairs(narrative.stories) do
	for i = 1, #chapters do
		chapters[i].index = i
	end
end

return settings("NarrativeStories", narrative)
