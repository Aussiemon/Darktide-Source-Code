-- chunkname: @scripts/ui/hud/elements/player_buffs/hud_element_player_buffs_definitions.lua

local HudElementPlayerBuffsSettings = require("scripts/ui/hud/elements/player_buffs/hud_element_player_buffs_settings")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local MAX_BUFFS = HudElementPlayerBuffsSettings.max_buffs
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	background = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			1125,
			80,
		},
		position = {
			550,
			-50,
			1,
		},
	},
	buff = {
		horizontal_alignment = "left",
		parent = "background",
		vertical_alignment = "bottom",
		size = {
			38,
			38,
		},
		position = {
			0,
			0,
			1,
		},
	},
}
local text_style = table.clone(UIFontSettings.hud_body)

text_style.horizontal_alignment = "right"
text_style.vertical_alignment = "bottom"
text_style.text_horizontal_alignment = "center"
text_style.text_vertical_alignment = "bottom"
text_style.size = {
	0,
	38,
}
text_style.offset = {
	-2,
	2,
	7,
}
text_style.drop_shadow = true

local widget_definitions = {}
local buff_widget_definition = UIWidget.create_definition({
	{
		pass_type = "text",
		style_id = "text",
		value = "",
		value_id = "text",
		style = text_style,
		visibility_function = function (content, style)
			local text = content.text

			return text ~= nil
		end,
	},
	{
		pass_type = "rect",
		style_id = "text_background",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "bottom",
			size = {
				0,
				19,
			},
			color = {
				150,
				0,
				0,
				0,
			},
			offset = {
				-1,
				-1,
				5,
			},
		},
		visibility_function = function (content, style)
			local text = content.text

			return text ~= nil
		end,
	},
	{
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/icons/buffs/hud/buff_frame_with_opacity",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			material_values = {
				opacity = 1,
			},
			size = {
				59,
				59,
			},
			offset = {
				0,
				0,
				1,
			},
			color = {
				150,
				0,
				0,
				0,
			},
		},
		change_function = function (content, style)
			local opacity = content.opacity

			style.material_values.opacity = opacity or 1
		end,
	},
	{
		pass_type = "texture",
		style_id = "icon",
		value = "content/ui/materials/icons/buffs/hud/buff_container_with_background",
		style = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			material_values = {
				opacity = 1,
				progress = 1,
			},
			size = {
				38,
				38,
			},
			offset = {
				0,
				0,
				0,
			},
			color = {
				150,
				102,
				102,
				102,
			},
		},
		change_function = function (content, style)
			local duration_progress = content.duration_progress

			style.material_values.progress = duration_progress or 1

			local opacity = content.opacity

			style.material_values.opacity = opacity or 1
		end,
	},
}, "buff")

for i = 1, MAX_BUFFS do
	local name = "buff_" .. i

	widget_definitions[name] = buff_widget_definition
end

local animations = {}

return {
	animations = animations,
	buff_widget_definition = buff_widget_definition,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
