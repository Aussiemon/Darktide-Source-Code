-- chunkname: @scripts/ui/view_elements/view_element_mission_board_objectives_info/view_element_mission_board_objectives_info_settings.lua

local Settings = {}

Settings.default_tab_size = {
	68,
	34,
}
Settings.panel_height = 68
Settings.sidebar_tabs = {
	"story",
	"circumstance",
	"main_objective",
	"side_objective",
	circumstance = 2,
	main_objective = 3,
	side_objective = 4,
	story = 1,
}
Settings.currency_icons = {
	credits = "content/ui/materials/mission_board/currencies/credits_small_digital",
	diamantine = "content/ui/materials/mission_board/currencies/diamantine_small_digital",
	plasteel = "content/ui/materials/mission_board/currencies/plasteel_small_digital",
	xp = "content/ui/materials/mission_board/currencies/experience_small_digital",
}
Settings.currency_order = {
	"credits",
	"xp",
	"plasteel",
	"diamantine",
}

return settings("ViewElementMissionBoardObjectivesInfoSettings", Settings)
