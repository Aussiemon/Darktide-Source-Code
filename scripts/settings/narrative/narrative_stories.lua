-- chunkname: @scripts/settings/narrative/narrative_stories.lua

local PlayerProgressionUnlocks = require("scripts/settings/player/player_progression_unlocks")

local function level_at_least(x)
	return function (player_profile)
		return player_profile.current_level >= x
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
		main_story = {},
		onboarding = {
			{
				backend_id = 1,
				name = "play_prologue",
				data = {
					mission_name = "prologue",
				},
				on_complete = achievement_unlocked("prologue"),
			},
			{
				backend_id = 2,
				name = "speak_to_morrow",
				data = {
					mission_name = "om_hub_01",
				},
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
			},
			{
				backend_id = 6,
				name = "inventory_popup",
				data = {
					mission_name = "om_hub_02",
				},
			},
			{
				backend_id = 7,
				name = "visit_chapel",
				data = {
					mission_name = "om_hub_02",
				},
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
				requirement = level_at_least(PlayerProgressionUnlocks.pot_contracts),
				on_complete = on_path_of_trust_chapter_completion("unlock_contracts"),
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
				requirement = level_at_least(PlayerProgressionUnlocks.talent_1),
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
				requirement = level_at_least(PlayerProgressionUnlocks.talent_2),
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
				requirement = level_at_least(PlayerProgressionUnlocks.talent_3),
			},
			{
				backend_id = 12,
				name = "level_unlock_talent_tier_4",
				requirement = level_at_least(PlayerProgressionUnlocks.talent_4),
			},
			{
				backend_id = 13,
				name = "level_unlock_gadget_slot_3",
				requirement = level_at_least(PlayerProgressionUnlocks.gadget_slot_3),
			},
			{
				backend_id = 14,
				name = "level_unlock_talent_tier_5",
				requirement = level_at_least(PlayerProgressionUnlocks.talent_5),
			},
			{
				backend_id = 15,
				name = "level_unlock_talent_tier_6",
				requirement = level_at_least(PlayerProgressionUnlocks.talent_6),
			},
		},
	},
	events = {
		mission_board = {},
		crafting_table = {},
		onboarding_step_chapel_video_viewed = {},
		onboarding_step_chapel_cutscene_played = {
			requirement = event_done("onboarding_step_chapel_video_viewed"),
		},
		onboarding_step_mission_board_introduction = {
			requirement = event_done("onboarding_step_chapel_cutscene_played"),
		},
		level_unlock_credits_store_visited = {
			requirement = beyond_story_chapter("path_of_trust", "pot_story_traitor_first"),
		},
		level_unlock_crafting_station_visited = {
			requirement = beyond_story_chapter("path_of_trust", "pot_crafting"),
		},
		level_unlock_contract_store_visited = {
			requirement = beyond_story_chapter("path_of_trust", "pot_contracts"),
		},
		level_unlock_premium_store_visited = {
			requirement = level_at_least(PlayerProgressionUnlocks.premium_store),
		},
		level_unlock_barber_visited = {
			requirement = level_at_least(PlayerProgressionUnlocks.barber),
		},
		level_unlock_cosmetic_store_visited = {
			requirement = level_at_least(PlayerProgressionUnlocks.cosmetics_vendor),
		},
		level_unlock_cosmetic_store_popup = {
			requirement = level_at_least(PlayerProgressionUnlocks.cosmetics_vendor),
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
