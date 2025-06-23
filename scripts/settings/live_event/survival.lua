-- chunkname: @scripts/settings/live_event/survival.lua

local survival = {
	description = "loc_survival_event_description",
	name = "loc_survival_event_name",
	stat = "game_mode_survival_score_end_of_round",
	id = "survival",
	icon = "",
	condition = "loc_survival_event_condition",
	item_rewards = {
		"content/items/2d/insignias/insignia_event_hordes"
	}
}

return survival
