-- chunkname: @scripts/ui/view_elements/view_element_expedition_view_mission_info/view_element_expedition_view_mission_info_settings.lua

local Settings = {}

Settings.tabs = {
	"unlock_info",
	"minor_modifiers",
	"major_modifiers_start",
	major_modifiers_start = 3,
	minor_modifiers = 2,
	unlock_info = 1,
}
Settings.dimensions = {
	divider_center_text_portion = 0.2,
	divider_left_line_portion = 0.4,
	divider_right_line_portion = 0.4,
	tab_size = {
		68,
		34,
	},
	tab_hover_growth_factor = {
		1.5,
		1.5,
	},
	tab_select_growth_factor = {
		2,
		2,
	},
	tab_icon_size = {
		36,
		36,
	},
	page_min_size = {
		483,
		250,
	},
	page_max_size = {
		483,
		435,
	},
	loot_icon_size = {
		30,
		30,
	},
	quickplay_icon_size = {
		48,
		48,
	},
}
Settings.loot_icon = "content/ui/materials/hud/interactions/icons/expeditions_loot"
Settings.colors = {
	text_light = {
		255,
		167,
		190,
		151,
	},
	text_dark = {
		255,
		101,
		145,
		102,
	},
	unlocked_text = {
		0,
		255,
		255,
		255,
	},
	unlockable_text = {
		255,
		255,
		183,
		44,
	},
	locked_text = {
		255,
		227,
		56,
		56,
	},
	terminal = {
		255,
		167,
		190,
		151,
	},
	terminal_frame = {
		255,
		101,
		145,
		102,
	},
	tab_unselected = {
		255,
		0,
		0,
		0,
	},
	tab_selected = {
		255,
		50,
		72,
		51,
	},
}
Settings.tabs_anim_select_speed = 8
Settings.default_tab_icon = "content/ui/materials/icons/circumstances/placeholder"
Settings.loot_icon = "content/ui/materials/hud/interactions/icons/expeditions_loot"
Settings.unlock_requirements_tab_icon = "content/ui/materials/icons/mission_types_pj/mission_type_deadside_locked"
Settings.minor_modifiers_tab_icon = "content/ui/materials/icons/mission_types_pj/mission_type_expeditions"
Settings.checkbox_border = "content/ui/materials/frames/frame_tile_2px"
Settings.checkbox_filling = "content/ui/materials/buttons/checkbox_filled"

return settings("ViewElementExpeditionViewMissionInfoSettings", Settings)
