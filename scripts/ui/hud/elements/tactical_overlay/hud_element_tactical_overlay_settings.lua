-- chunkname: @scripts/ui/hud/elements/tactical_overlay/hud_element_tactical_overlay_settings.lua

local hud_element_tactical_overlay_settings = {}
local styles = {}

styles.difficulty = {}

local difficulty = styles.difficulty

difficulty.difficulty_icon = {
	amount = 0,
	direction = 1,
	spacing = 8,
	vertical_alignment = "top",
	offset = {
		65,
		10,
		4,
	},
	size = {
		18,
		40,
	},
	color = {
		255,
		169,
		191,
		153,
	},
}
difficulty.diffulty_icon_background = table.clone(difficulty.difficulty_icon)

local stat_diffulty_icon_background_style = difficulty.diffulty_icon_background

stat_diffulty_icon_background_style.color = Color.terminal_background(255, true)
stat_diffulty_icon_background_style.amount = 5
difficulty.diffulty_icon_background_frame = table.clone(difficulty.difficulty_icon)

local diffulty_icon_background_frame_style = difficulty.diffulty_icon_background_frame

diffulty_icon_background_frame_style.color = {
	255,
	169,
	191,
	153,
}
diffulty_icon_background_frame_style.amount = 5
diffulty_icon_background_frame_style.offset = {
	65,
	10,
	5,
}
styles.contract_title_text_style = {}

local contract_title_text_style = styles.contract_title_text_style

contract_title_text_style.size = {
	350,
	50,
}
contract_title_text_style.text_color = {
	255,
	169,
	191,
	153,
}
contract_title_text_style.font_size = 20
contract_title_text_style.horizontal_alignment = "right"
contract_title_text_style.vertical_alignment = "top"
contract_title_text_style.text_horizontal_alignment = "left"
contract_title_text_style.text_vertical_alignment = "top"
styles.contracts_progress_bar_style = {}

local contracts_progress_bar_style = styles.contracts_progress_bar_style

contracts_progress_bar_style.color = {
	255,
	169,
	191,
	153,
}
contracts_progress_bar_style.horizontal_alignment = "right"
contracts_progress_bar_style.vertical_alignment = "top"
styles.contracts_progress_bar_background_style = {}

local contracts_progress_bar_background_style = styles.contracts_progress_bar_background_style

contracts_progress_bar_background_style.color = Color.terminal_background(255, true)
contracts_progress_bar_background_style.horizontal_alignment = "right"
contracts_progress_bar_background_style.vertical_alignment = "top"
styles.contracts_progress_bar_frame_style = {}

local contracts_progress_bar_frame_style = styles.contracts_progress_bar_frame_style

contracts_progress_bar_frame_style.color = {
	255,
	169,
	191,
	153,
}
contracts_progress_bar_frame_style.horizontal_alignment = "right"
contracts_progress_bar_frame_style.vertical_alignment = "top"
contracts_progress_bar_frame_style.size_addition = {
	2,
	2,
}
styles.contract_background_style = {}

local contract_background_style = styles.contract_background_style

contract_background_style.color = Color.terminal_background(160, true)
contract_background_style.uvs = {
	{
		1,
		0,
	},
	{
		0,
		1,
	},
}
styles.contract_type_icon_style = {}

local contract_type_icon_style = styles.contract_type_icon_style

contract_type_icon_style.color = Color.terminal_text_header(255, true)
contract_type_icon_style.size = {
	50,
	50,
}
contract_type_icon_style.horizontal_alignment = "left"
contract_type_icon_style.vertical_alignment = "top"
hud_element_tactical_overlay_settings.styles = styles
hud_element_tactical_overlay_settings.line_width = 5
hud_element_tactical_overlay_settings.buffer = 8
hud_element_tactical_overlay_settings.section_buffer = 4
hud_element_tactical_overlay_settings.internal_buffer = 2
hud_element_tactical_overlay_settings.max_penance_description_height = 64
hud_element_tactical_overlay_settings.right_grid_width = 450
hud_element_tactical_overlay_settings.right_header_height = 40
hud_element_tactical_overlay_settings.right_timer_height = 30
hud_element_tactical_overlay_settings.right_grid_spacing = {
	0,
	hud_element_tactical_overlay_settings.internal_buffer,
}
hud_element_tactical_overlay_settings.right_panel_grids = {
	achievements = {
		index = 1,
		loc_key = "loc_achievements_view_display_name",
		icon = {
			blueprint_type = "text_icon",
			value = "",
		},
	},
	contracts = {
		index = 2,
		loc_key = "loc_contracts_view_display_name",
		icon = {
			blueprint_type = "texture_icon",
			value = "content/ui/materials/hud/interactions/icons/contracts",
		},
	},
	event = {
		index = 3,
		loc_key = "loc_event_category_label",
		icon = {
			blueprint_type = "text_icon",
			value = "",
		},
		timer = {
			loc_key = "loc_event_time_left",
			func = function (t)
				return Managers.live_event:active_time_left(t)
			end,
		},
	},
}
hud_element_tactical_overlay_settings.right_panel_order = {}

for key, setting in pairs(hud_element_tactical_overlay_settings.right_panel_grids) do
	hud_element_tactical_overlay_settings.right_panel_order[setting.index] = key
end

hud_element_tactical_overlay_settings.default_context = {
	show_left_side_details = true,
	show_right_side = true,
}

return settings("HudElementTacticalOverlaySettings", hud_element_tactical_overlay_settings)
