-- chunkname: @scripts/ui/constant_elements/elements/mission_lobby_status/constant_element_mission_lobby_status_definitions.lua

local ConstantMissionLobbyStatusSettings = require("scripts/ui/constant_elements/elements/mission_lobby_status/constant_element_mission_lobby_status_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ready_slot_size = ConstantMissionLobbyStatusSettings.ready_slot_size
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	top_panel = UIWorkspaceSettings.top_panel,
	pivot = {
		vertical_alignment = "top",
		parent = "top_panel",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-70,
			65,
			900
		}
	},
	timer_background = {
		vertical_alignment = "top",
		parent = "pivot",
		horizontal_alignment = "right",
		size = {
			234,
			90
		},
		position = {
			0,
			0,
			1
		}
	},
	timer_text = {
		vertical_alignment = "top",
		parent = "pivot",
		horizontal_alignment = "right",
		size = {
			110,
			90
		},
		position = {
			-5,
			0,
			2
		}
	},
	team_status_text = {
		vertical_alignment = "top",
		parent = "pivot",
		horizontal_alignment = "right",
		size = {
			600,
			35
		},
		position = {
			-117,
			0,
			2
		}
	},
	team_status = {
		vertical_alignment = "top",
		parent = "pivot",
		horizontal_alignment = "right",
		size = ready_slot_size,
		position = {
			-117,
			35,
			2
		}
	}
}
local team_status_text_style = table.clone(UIFontSettings.header_4)

team_status_text_style.text_vertical_alignment = "center"
team_status_text_style.text_horizontal_alignment = "right"
team_status_text_style.offset = {
	-5,
	0,
	0
}

local timer_new_text_style = table.clone(UIFontSettings.body)

timer_new_text_style.text_color = Color.ui_terminal(25.5, true)
timer_new_text_style.font_size = 94
timer_new_text_style.font_type = "proxima_nova_medium"
timer_new_text_style.text_vertical_alignment = "center"
timer_new_text_style.text_horizontal_alignment = "center"

local timer_active_new_text_style = table.clone(UIFontSettings.body)

timer_active_new_text_style.text_color = Color.ui_terminal(255, true)
timer_active_new_text_style.color = Color.ui_terminal(255, true)
timer_active_new_text_style.font_size = 94
timer_active_new_text_style.font_type = "proxima_nova_medium"
timer_active_new_text_style.text_vertical_alignment = "center"
timer_active_new_text_style.text_horizontal_alignment = "right"
timer_active_new_text_style.offset = {
	-13,
	0,
	0
}

local widget_definitions = {
	timer_background = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/lobby_timer/background",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					234,
					90
				},
				color = Color.black(76.5, true)
			}
		},
		{
			value = "content/ui/materials/backgrounds/lobby_timer/frame",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				hdr = true,
				horizontal_alignment = "center",
				size = {
					234,
					90
				},
				offset = {
					0,
					0,
					1
				},
				color = Color.ui_terminal(127.5, true)
			}
		}
	}, "timer_background"),
	team_status_text = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			value = Managers.localization:localize("loc_lobby_timer_description"),
			style = team_status_text_style
		}
	}, "team_status_text"),
	timer_text = UIWidget.create_definition({
		{
			value_id = "text_background",
			style_id = "text_background",
			pass_type = "text",
			value = "",
			style = timer_new_text_style
		},
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = timer_active_new_text_style
		}
	}, "timer_text")
}
local ready_status_definition = UIWidget.create_definition({
	{
		value = "content/ui/materials/backgrounds/lobby_timer/ready_line",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			hdr = true,
			horizontal_alignment = "center",
			size = {
				22,
				46
			},
			offset = {
				0,
				0,
				2
			},
			color = Color.ui_terminal(76.5, true)
		},
		visibility_function = function (content, style)
			return content.occupied
		end
	},
	{
		value = "content/ui/materials/backgrounds/lobby_timer/ready_fill",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			hdr = true,
			horizontal_alignment = "center",
			size = {
				22,
				46
			},
			offset = {
				0,
				0,
				2
			},
			color = Color.ui_terminal(255, true)
		},
		visibility_function = function (content, style)
			return content.selected and content.occupied
		end
	},
	{
		value = "content/ui/materials/backgrounds/lobby_timer/not_ready",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size = {
				22,
				46
			},
			offset = {
				0,
				0,
				2
			},
			color = Color.ui_red_light(127.5, true)
		},
		visibility_function = function (content, style)
			return not content.occupied
		end
	}
}, "team_status")

return {
	ready_status_definition = ready_status_definition,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
