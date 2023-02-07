local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	canvas = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	purchase_button = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			374,
			76
		},
		position = {
			857,
			-90,
			1
		}
	},
	price_text = {
		vertical_alignment = "top",
		parent = "purchase_button",
		horizontal_alignment = "center",
		size = {
			1000,
			50
		},
		position = {
			0,
			-50,
			3
		}
	},
	price_icon = {
		vertical_alignment = "center",
		parent = "price_text",
		horizontal_alignment = "center",
		size = {
			52,
			44
		},
		position = {
			0,
			0,
			1
		}
	},
	purchase_confirmation = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			450,
			50
		},
		position = {
			0,
			0,
			1
		}
	}
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
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "0",
			style = price_text_style
		}
	}, "price_text"),
	price_icon = UIWidget.create_definition({
		{
			value = "content/ui/materials/icons/currencies/marks_big",
			style_id = "texture",
			pass_type = "texture",
			value_id = "texture"
		}
	}, "price_icon"),
	purchase_button = UIWidget.create_definition(table.clone(ButtonPassTemplates.default_button), "purchase_button", {
		gamepad_action = "confirm_pressed",
		text = Utf8.upper(Localize("loc_vendor_purchase_button")),
		hotspot = {
			on_pressed_sound = UISoundEvents.credits_vendor_on_purchase
		}
	})
}
local anim_start_delay = 0
local animations = {
	on_enter = {
		{
			name = "init",
			end_time = 0,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent._alpha_multiplier = 0
			end
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
			end
		}
	},
	grid_entry = {
		{
			name = "fade_in",
			end_time = 0.5,
			start_time = 0,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				for i = 1, #widgets do
					widgets[i].alpha_multiplier = anim_progress
				end
			end
		}
	}
}

return {
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
