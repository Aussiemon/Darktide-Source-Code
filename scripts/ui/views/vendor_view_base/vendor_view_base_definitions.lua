-- chunkname: @scripts/ui/views/vendor_view_base/vendor_view_base_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	canvas = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			0,
		},
	},
	purchase_button = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			374,
			76,
		},
		position = {
			857,
			-90,
			1,
		},
	},
	price_text = {
		horizontal_alignment = "center",
		parent = "purchase_button",
		vertical_alignment = "top",
		size = {
			1000,
			50,
		},
		position = {
			0,
			-50,
			3,
		},
	},
	price_icon = {
		horizontal_alignment = "center",
		parent = "price_text",
		vertical_alignment = "center",
		size = {
			52,
			44,
		},
		position = {
			0,
			0,
			1,
		},
	},
	purchase_confirmation = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = {
			450,
			50,
		},
		position = {
			0,
			0,
			1,
		},
	},
}
local display_name_style = table.clone(UIFontSettings.header_2)

display_name_style.text_horizontal_alignment = "left"
display_name_style.text_vertical_alignment = "center"

local sub_display_name_style = table.clone(UIFontSettings.body)

sub_display_name_style.text_horizontal_alignment = "left"
sub_display_name_style.text_vertical_alignment = "center"

local price_text_style = table.clone(UIFontSettings.currency_title)
local widget_definitions = {
	price_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = price_text_style,
		},
	}, "price_text"),
	price_icon = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "texture",
			value = "content/ui/materials/icons/currencies/marks_big",
			value_id = "texture",
		},
	}, "price_icon"),
	purchase_button = UIWidget.create_definition(table.clone(ButtonPassTemplates.default_button), "purchase_button", {
		gamepad_action = "confirm_pressed",
		original_text = Utf8.upper(Localize("loc_vendor_purchase_button")),
		hotspot = {
			on_pressed_sound = UISoundEvents.default_click,
		},
		purchase_sound = UISoundEvents.credits_vendor_on_purchase,
	}),
}
local anim_start_delay = 0
local animations = {
	on_enter = {
		{
			end_time = 0,
			name = "init",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent._alpha_multiplier = 0
			end,
		},
		{
			name = "fade_in",
			start_time = anim_start_delay + 1.5,
			end_time = anim_start_delay + 2,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				parent._alpha_multiplier = anim_progress
			end,
			on_complete = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				return
			end,
		},
	},
	grid_entry = {
		{
			end_time = 0.5,
			name = "fade_in",
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				for i = 1, #widgets do
					widgets[i].alpha_multiplier = anim_progress
				end
			end,
		},
	},
}

return {
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
