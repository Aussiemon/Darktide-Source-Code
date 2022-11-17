local PlayerProgressionUnlocks = require("scripts/settings/player/player_progression_unlocks")

local function level_at_least(x)
	return function (player_profile)
		return x <= player_profile.current_level
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
		Managers.achievements:unlock_achievement(achievement_name)
	end
end

local function on_path_of_trust_chapter_completion(achievement_name)
	return function ()
		Managers.event:trigger("event_on_path_of_trust_updated")

		if achievement_name then
			Managers.achievements:unlock_achievement(achievement_name)
		end
	end
end

local function can_start_path_of_trust(required_level)
	return function (player_profile)
		return required_level <= player_profile.current_level and Managers.narrative:is_event_complete("onboarding_step_chapel_video_viewed")
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
				name = "play_prologue",
				backend_id = 1,
				data = {
					mission_name = "prologue"
				},
				on_complete = achievement_unlocked("prologue")
			},
			{
				name = "speak_to_morrow",
				backend_id = 2,
				data = {
					mission_name = "om_hub_01"
				}
			},
			{
				name = "go_to_training",
				backend_id = 3,
				data = {
					mission_name = "om_hub_01"
				}
			},
			{
				name = "play_training",
				backend_id = 4,
				data = {
					mission_name = "om_basic_combat_01"
				},
				on_complete = achievement_unlocked("basic_training")
			},
			{
				name = "training_reward",
				backend_id = 5,
				data = {
					mission_name = "om_hub_02"
				}
			},
			{
				name = "inventory_popup",
				backend_id = 6,
				data = {
					mission_name = "om_hub_02"
				}
			},
			{
				name = "visit_chapel",
				backend_id = 7,
				data = {
					mission_name = "om_hub_02"
				},
				on_complete = set_account_has_completed_onboarding()
			}
		},
		path_of_trust = {
			{
				name = "pot_story_traitor_first",
				backend_id = 1,
				data = {
					localization_key = "loc_progression_step_01",
					vo_story_stage = "pot_1",
					level_to_reach = PlayerProgressionUnlocks.pot_story_traitor_first
				},
				requirement = can_start_path_of_trust(PlayerProgressionUnlocks.pot_story_traitor_first),
				on_complete = on_path_of_trust_chapter_completion("path_of_trust_1")
			},
			{
				name = "pot_gadgets",
				backend_id = 3,
				data = {
					localization_key = "loc_progression_step_03",
					vo_story_stage = "pot_3",
					level_to_reach = PlayerProgressionUnlocks.pot_gadgets
				},
				requirement = level_at_least(PlayerProgressionUnlocks.pot_gadgets),
				on_complete = on_path_of_trust_chapter_completion("unlock_gadgets")
			},
			{
				name = "pot_contracts",
				backend_id = 4,
				data = {
					localization_key = "loc_progression_step_04",
					vo_story_stage = "pot_4",
					level_to_reach = PlayerProgressionUnlocks.pot_contracts
				},
				requirement = level_at_least(PlayerProgressionUnlocks.pot_contracts),
				on_complete = on_path_of_trust_chapter_completion("unlock_contracts")
			},
			{
				name = "pot_story_traitor_second",
				backend_id = 5,
				data = {
					localization_key = "loc_progression_step_05",
					vo_story_stage = "pot_5",
					level_to_reach = PlayerProgressionUnlocks.pot_story_traitor_second
				},
				requirement = level_at_least(PlayerProgressionUnlocks.pot_story_traitor_second),
				on_complete = on_path_of_trust_chapter_completion("path_of_trust_2")
			},
			{
				name = "pot_story_masozi",
				backend_id = 6,
				data = {
					localization_key = "loc_progression_step_06",
					vo_story_stage = "pot_6",
					level_to_reach = PlayerProgressionUnlocks.pot_story_masozi
				},
				requirement = level_at_least(PlayerProgressionUnlocks.pot_story_masozi),
				on_complete = on_path_of_trust_chapter_completion("path_of_trust_3")
			},
			{
				name = "pot_story_hadron",
				backend_id = 7,
				data = {
					localization_key = "loc_progression_step_07",
					vo_story_stage = "pot_7",
					level_to_reach = PlayerProgressionUnlocks.pot_story_hadron
				},
				requirement = level_at_least(PlayerProgressionUnlocks.pot_story_hadron),
				on_complete = on_path_of_trust_chapter_completion("path_of_trust_4")
			},
			{
				name = "pot_story_do_or_die",
				backend_id = 8,
				data = {
					localization_key = "loc_progression_step_08",
					vo_story_stage = "pot_8",
					level_to_reach = PlayerProgressionUnlocks.pot_story_do_or_die
				},
				requirement = level_at_least(PlayerProgressionUnlocks.pot_story_do_or_die),
				on_complete = on_path_of_trust_chapter_completion("path_of_trust_5")
			},
			{
				name = "pot_story_final",
				backend_id = 9,
				data = {
					localization_key = "loc_progression_step_09",
					vo_story_stage = "pot_9",
					level_to_reach = PlayerProgressionUnlocks.pot_story_final
				},
				requirement = level_at_least(PlayerProgressionUnlocks.pot_story_final),
				on_complete = on_path_of_trust_chapter_completion("path_of_trust_6")
			}
		},
		level_unlock_popups = {
			{
				name = "level_unlock_mission_board_popup_difficulty_increased_1",
				backend_id = 2,
				requirement = level_at_least(PlayerProgressionUnlocks.mission_difficulty_3)
			},
			{
				name = "level_unlock_talent_tier_1",
				backend_id = 4,
				requirement = level_at_least(PlayerProgressionUnlocks.talent_1)
			},
			{
				name = "level_unlock_mission_board_popup_difficulty_increased_2",
				backend_id = 5,
				requirement = level_at_least(PlayerProgressionUnlocks.mission_difficulty_4)
			},
			{
				name = "level_unlock_gadget_slot_1",
				backend_id = 6,
				requirement = beyond_story_chapter("path_of_trust", "pot_gadgets")
			},
			{
				name = "level_unlock_talent_tier_2",
				backend_id = 7,
				requirement = level_at_least(PlayerProgressionUnlocks.talent_2)
			},
			{
				name = "level_unlock_contract_store_popup",
				backend_id = 8,
				requirement = beyond_story_chapter("path_of_trust", "pot_contracts")
			},
			{
				name = "level_unlock_mission_board_popup_difficulty_increased_3",
				backend_id = 9,
				requirement = level_at_least(PlayerProgressionUnlocks.mission_difficulty_5)
			},
			{
				name = "level_unlock_gadget_slot_2",
				backend_id = 10,
				requirement = level_at_least(PlayerProgressionUnlocks.gadget_slot_2)
			},
			{
				name = "level_unlock_talent_tier_3",
				backend_id = 11,
				requirement = level_at_least(PlayerProgressionUnlocks.talent_3)
			},
			{
				name = "level_unlock_talent_tier_4",
				backend_id = 12,
				requirement = level_at_least(PlayerProgressionUnlocks.talent_4)
			},
			{
				name = "level_unlock_gadget_slot_3",
				backend_id = 13,
				requirement = level_at_least(PlayerProgressionUnlocks.gadget_slot_3)
			},
			{
				name = "level_unlock_talent_tier_5",
				backend_id = 14,
				requirement = level_at_least(PlayerProgressionUnlocks.talent_5)
			},
			{
				name = "level_unlock_talent_tier_6",
				backend_id = 15,
				requirement = level_at_least(PlayerProgressionUnlocks.talent_6)
			}
		}
	},
	events = {
		mission_board = {},
		crafting_table = {},
		onboarding_step_chapel_video_viewed = {},
		onboarding_step_chapel_cutscene_played = {
			requirement = event_done("onboarding_step_chapel_video_viewed")
		},
		onboarding_step_mission_board_introduction = {
			requirement = event_done("onboarding_step_chapel_cutscene_played")
		},
		level_unlock_credits_store_visited = {
			requirement = beyond_story_chapter("path_of_trust", "pot_story_traitor_first")
		},
		level_unlock_contract_store_visited = {
			requirement = beyond_story_chapter("path_of_trust", "pot_contracts")
		},
		level_unlock_premium_store_visited = {
			requirement = level_at_least(PlayerProgressionUnlocks.premium_store)
		},
		level_unlock_barber_visited = {
			requirement = level_at_least(PlayerProgressionUnlocks.barber)
		}
	}
}

for _, chapters in pairs(narrative.stories) do
	for i = 1, #chapters do
		chapters[i].index = i
	end
end

return settings("NarrativeStories", narrative)
