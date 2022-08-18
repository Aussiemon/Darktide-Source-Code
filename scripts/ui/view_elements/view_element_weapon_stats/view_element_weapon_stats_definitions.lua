local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")

local function create_definitions(settings)
	local stats_size = settings.stats_size
	local info_box_size = settings.info_box_size
	local scenegraph_definition = {
		screen = UIWorkspaceSettings.screen,
		pivot = {
			vertical_alignment = "top",
			parent = "screen",
			horizontal_alignment = "left",
			size = {
				0,
				0
			},
			position = {
				0,
				0,
				1
			}
		},
		info_box = {
			vertical_alignment = "top",
			parent = "pivot",
			horizontal_alignment = "left",
			size = info_box_size,
			position = {
				0,
				0,
				3
			}
		},
		resource_title = {
			vertical_alignment = "top",
			parent = "info_box",
			horizontal_alignment = "left",
			size = {
				200,
				20
			},
			position = {
				0,
				60,
				3
			}
		},
		resource_value = {
			vertical_alignment = "top",
			parent = "resource_title",
			horizontal_alignment = "left",
			size = {
				200,
				20
			},
			position = {
				0,
				20,
				3
			}
		},
		action_divider = {
			vertical_alignment = "bottom",
			parent = "info_box",
			horizontal_alignment = "right",
			size = {
				500,
				2
			},
			position = {
				0,
				-120,
				0
			}
		},
		action_text_pivot = {
			vertical_alignment = "top",
			parent = "action_divider",
			horizontal_alignment = "left",
			size = {
				250,
				30
			},
			position = {
				0,
				8,
				3
			}
		},
		trait_pivot = {
			vertical_alignment = "bottom",
			parent = "action_divider",
			horizontal_alignment = "center",
			size = {
				0,
				0
			},
			position = {
				0,
				-45,
				0
			}
		},
		trait_tooltip = {
			vertical_alignment = "bottom",
			parent = "trait_pivot",
			horizontal_alignment = "center",
			size = {
				500,
				100
			},
			position = {
				0,
				-40,
				3
			}
		},
		stat_divider = {
			vertical_alignment = "bottom",
			parent = "info_box",
			horizontal_alignment = "left",
			size = {
				500,
				2
			},
			position = {
				0,
				-120,
				0
			}
		},
		stat_pivot = {
			vertical_alignment = "bottom",
			parent = "stat_divider",
			horizontal_alignment = "left",
			size = stats_size,
			position = {
				0,
				16,
				0
			}
		},
		keyword_pivot = {
			vertical_alignment = "bottom",
			parent = "stat_divider",
			horizontal_alignment = "right",
			size = {
				250,
				25
			},
			position = {
				0,
				-8,
				3
			}
		}
	}
	local resource_title_style = table.clone(UIFontSettings.body_small)
	resource_title_style.text_horizontal_alignment = "left"
	resource_title_style.text_vertical_alignment = "top"
	local resource_value_style = table.clone(UIFontSettings.item_info_small)
	resource_value_style.text_horizontal_alignment = "left"
	resource_value_style.text_vertical_alignment = "top"
	local trait_tooltip_text_style = table.clone(UIFontSettings.body_small)
	trait_tooltip_text_style.horizontal_alignment = "center"
	trait_tooltip_text_style.vertical_alignment = "center"
	trait_tooltip_text_style.text_horizontal_alignment = "left"
	trait_tooltip_text_style.text_vertical_alignment = "top"
	trait_tooltip_text_style.size_addition = {
		-10,
		-10
	}
	trait_tooltip_text_style.offset = {
		0,
		0,
		3
	}
	trait_tooltip_text_style.text_color = Color.ui_grey_medium(255, true)
	local widget_definitions = {
		trait_tooltip = UIWidget.create_definition({
			{
				pass_type = "rect",
				style = {
					color = {
						160,
						0,
						0,
						0
					}
				}
			}
		}, "trait_tooltip"),
		trait_tooltip_text = UIWidget.create_definition({
			{
				value_id = "text",
				style_id = "text",
				pass_type = "text",
				value = "",
				style = trait_tooltip_text_style
			}
		}, "trait_tooltip"),
		stat_divider = UIWidget.create_definition({
			{
				pass_type = "rect",
				style = {
					color = {
						51,
						255,
						255,
						255
					}
				}
			}
		}, "stat_divider"),
		action_divider = UIWidget.create_definition({
			{
				pass_type = "rect",
				style = {
					color = {
						51,
						255,
						255,
						255
					}
				}
			}
		}, "action_divider"),
		resource_title = UIWidget.create_definition({
			{
				value_id = "text",
				pass_type = "text",
				value = Localize("loc_weapon_stat_title_ammo"),
				style = resource_title_style
			}
		}, "resource_title"),
		resource_value = UIWidget.create_definition({
			{
				value = "0/0",
				value_id = "text",
				pass_type = "text",
				style = resource_value_style
			}
		}, "resource_value")
	}

	return {
		widget_definitions = widget_definitions,
		scenegraph_definition = scenegraph_definition
	}
end

return create_definitions
