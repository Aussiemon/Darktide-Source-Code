local PlayerProgressionUnlocks = require("scripts/settings/player/player_progression_unlocks")

local function level_at_least(x)
	return function (player_profile)
		return x <= player_profile.current_level
	end
end

local function event_done(event_name)
	return function (player_profile)
		return Managers.narrative:event_is_complete(event_name)
	end
end

local function events_done(event_names)
	return function ()
		local narrative_manager = Managers.narrative

		for i = 1, #event_names do
			local event_name = event_names[i]

			if not narrative_manager:event_is_complete(event_name) then
				return false
			end
		end

		return true
	end
end

local function on_or_beyond_story_chapter(story_name, chapter_name)
	return function ()
		local narrative_manager = Managers.narrative
		local my_chapter = narrative_manager:chapter_by_name(story_name, chapter_name)

		if my_chapter then
			local current_chapter = narrative_manager:current_chapter(story_name)

			if current_chapter then
				return my_chapter.index <= current_chapter.index
			else
				return true
			end
		end

		return false
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
		Managers.narrative:complete_current_chapter("player_progression_journey")
		Managers.event:trigger("event_on_path_of_trust_updated")

		if achievement_name then
			Managers.achievements:unlock_achievement(achievement_name)
		end
	end
end

local function can_start_path_of_trust(required_level)
	return function (player_profile)
		return required_level <= player_profile.current_level and Managers.narrative:event_is_complete("onboarding_step_chapel_video_viewed")
	end
end

local narrative = {
	stories = {
		main_story = {},
		onboarding = {
			{
				name = "play_training",
				backend_id = 4,
				data = {
					mission_name = "om_basic_combat_01"
				},
				on_complete = achievement_unlocked("basic_training")
			}
		},
		level_unlock_popups = {
			{
				name = "level_unlock_credits_store_popup",
				backend_id = 1,
				requirement = level_at_least(PlayerProgressionUnlocks.credits_vendor)
			},
			{
				name = "level_unlock_talent_tier_1",
				backend_id = 3,
				requirement = level_at_least(PlayerProgressionUnlocks.talent_1)
			},
			{
				name = "level_unlock_mission_board_popup_difficulty_increased_1",
				backend_id = 4,
				requirement = level_at_least(PlayerProgressionUnlocks.mission_difficulty_4)
			},
			{
				name = "level_unlock_talent_tier_2",
				backend_id = 6,
				requirement = level_at_least(PlayerProgressionUnlocks.talent_2)
			},
			{
				name = "level_unlock_contract_store_popup",
				backend_id = 7,
				requirement = level_at_least(PlayerProgressionUnlocks.contracts)
			},
			{
				name = "level_unlock_mission_board_popup_difficulty_increased_2",
				backend_id = 8,
				requirement = level_at_least(PlayerProgressionUnlocks.mission_difficulty_5)
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
		onboarding_step_mission_board_introduction = {},
		level_unlock_credits_store_visited = {
			requirement = level_at_least(PlayerProgressionUnlocks.credits_vendor)
		},
		level_unlock_contract_store_visited = {
			requirement = level_at_least(PlayerProgressionUnlocks.contracts)
		}
	}
}

for _, chapters in pairs(narrative.stories) do
	for i = 1, #chapters do
		chapters[i].index = i
	end
end

return settings("NarrativeStories", narrative)
