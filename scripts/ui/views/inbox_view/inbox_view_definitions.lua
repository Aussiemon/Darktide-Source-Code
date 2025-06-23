-- chunkname: @scripts/ui/views/inbox_view/inbox_view_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local InboxViewSettings = require("scripts/ui/views/inbox_view/inbox_view_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local BarPassTemplates = require("scripts/ui/pass_templates/bar_pass_templates")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local ItemPassTemplates = require("scripts/ui/pass_templates/item_pass_templates")
local character_experience_bar_size = {
	280,
	10
}
local vertical_margin = 10
local scenegraph_definition = {
	screen = {
		scale = "fit",
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
	title_text = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			1000,
			50
		},
		position = {
			130,
			45,
			1
		}
	},
	title_description = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			1000,
			50
		},
		position = {
			130,
			90,
			1
		}
	},
	grid_background = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			970,
			750
		},
		position = {
			130,
			-100,
			0
		}
	},
	grid_content_pivot = {
		vertical_alignment = "top",
		parent = "grid_background",
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
	grid_scrollbar = {
		vertical_alignment = "center",
		parent = "grid_background",
		horizontal_alignment = "right",
		size = {
			10,
			750
		},
		position = {
			10,
			0,
			1
		}
	},
	grid_mask = {
		vertical_alignment = "center",
		parent = "grid_background",
		horizontal_alignment = "center",
		size = {
			990,
			770
		},
		position = {
			0,
			0,
			10
		}
	},
	grid_interaction = {
		vertical_alignment = "top",
		parent = "grid_background",
		horizontal_alignment = "left",
		size = {
			970,
			750
		},
		position = {
			0,
			0,
			0
		}
	},
	item_container = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			670,
			840
		},
		position = {
			-130,
			-100,
			0
		}
	},
	item_background = {
		vertical_alignment = "top",
		parent = "item_container",
		horizontal_alignment = "center",
		size = {
			670,
			740
		},
		position = {
			0,
			0,
			0
		}
	},
	item_content = {
		vertical_alignment = "center",
		parent = "item_background",
		horizontal_alignment = "center",
		size = {
			650,
			720
		},
		position = {
			0,
			0,
			0
		}
	},
	item_detail_intro = {
		vertical_alignment = "top",
		parent = "item_content",
		horizontal_alignment = "center",
		size = {
			650,
			50
		},
		position = {
			0,
			0,
			2
		}
	},
	item_image = {
		vertical_alignment = "top",
		parent = "item_content",
		horizontal_alignment = "left",
		size = {
			160,
			110
		},
		position = {
			0,
			50 + vertical_margin,
			2
		}
	},
	item_detail = {
		vertical_alignment = "top",
		parent = "item_content",
		horizontal_alignment = "left",
		size = {
			480,
			ItemPassTemplates.icon_size[2]
		},
		position = {
			ItemPassTemplates.icon_size[1] + 10,
			50 + vertical_margin,
			2
		}
	},
	stats_divider = {
		vertical_alignment = "top",
		parent = "item_content",
		horizontal_alignment = "center",
		size = {
			650,
			40
		},
		position = {
			0,
			50 + ItemPassTemplates.icon_size[2] + vertical_margin * 2,
			2
		}
	},
	stat_pivot = {
		vertical_alignment = "top",
		parent = "item_content",
		horizontal_alignment = "center",
		size = {
			650,
			120
		},
		position = {
			0,
			50 + ItemPassTemplates.icon_size[2] + 40 + vertical_margin * 3,
			2
		}
	},
	modifications_divider = {
		vertical_alignment = "top",
		parent = "item_content",
		horizontal_alignment = "center",
		size = {
			650,
			40
		},
		position = {
			0,
			50 + ItemPassTemplates.icon_size[2] + 40 + 120 + vertical_margin * 4,
			2
		}
	},
	blessings_divider = {
		vertical_alignment = "top",
		parent = "item_content",
		horizontal_alignment = "center",
		size = {
			650,
			40
		},
		position = {
			0,
			50 + ItemPassTemplates.icon_size[2] + 40 + 120 + 40 + vertical_margin * 5,
			2
		}
	},
	claim_button = {
		vertical_alignment = "bottom",
		parent = "item_container",
		horizontal_alignment = "center",
		size = {
			374,
			76
		},
		position = {
			0,
			0,
			0
		}
	},
	loading = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			1920,
			100
		},
		position = {
			0,
			0,
			0
		}
	},
	character_insigna = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			30,
			80
		},
		position = {
			130,
			130,
			62
		}
	},
	character_portrait = {
		vertical_alignment = "center",
		parent = "character_insigna",
		horizontal_alignment = "left",
		size = {
			70,
			80
		},
		position = {
			40,
			0,
			1
		}
	},
	character_name = {
		vertical_alignment = "top",
		parent = "character_portrait",
		horizontal_alignment = "left",
		size = {
			400,
			30
		},
		position = {
			80,
			0,
			1
		}
	},
	character_title = {
		vertical_alignment = "top",
		parent = "character_portrait",
		horizontal_alignment = "left",
		size = {
			280,
			54
		},
		position = {
			80,
			0,
			1
		}
	},
	character_level = {
		vertical_alignment = "top",
		parent = "character_title",
		horizontal_alignment = "right",
		size = {
			40,
			54
		},
		position = {
			0,
			0,
			1
		}
	},
	character_experience = {
		vertical_alignment = "bottom",
		parent = "character_portrait",
		horizontal_alignment = "left",
		size = character_experience_bar_size,
		position = {
			80,
			-10,
			1
		}
	}
}
local character_name_style = table.clone(UIFontSettings.header_3)

character_name_style.text_horizontal_alignment = "left"
character_name_style.text_vertical_alignment = "bottom"

local character_title_style = table.clone(UIFontSettings.body_small)

character_title_style.text_horizontal_alignment = "left"
character_title_style.text_vertical_alignment = "bottom"

local character_level_style = table.clone(UIFontSettings.body_small)

character_level_style.text_horizontal_alignment = "right"
character_level_style.text_vertical_alignment = "bottom"

local loading_style = table.clone(UIFontSettings.header_1)

loading_style.text_horizontal_alignment = "center"
loading_style.text_vertical_alignment = "center"

local reward_type_style = table.clone(UIFontSettings.body)

reward_type_style.text_horizontal_alignment = "left"
reward_type_style.text_vertical_alignment = "top"

local reward_time_style = table.clone(UIFontSettings.body)

reward_time_style.text_horizontal_alignment = "right"
reward_time_style.text_vertical_alignment = "top"

local item_name_style = table.clone(UIFontSettings.header_2)

item_name_style.text_horizontal_alignment = "left"
item_name_style.text_vertical_alignment = "top"

local item_type_style = table.clone(UIFontSettings.body)

item_type_style.text_horizontal_alignment = "left"
item_type_style.text_vertical_alignment = "center"

local reward_reason_style = table.clone(UIFontSettings.body)

reward_reason_style.text_horizontal_alignment = "left"
reward_reason_style.text_vertical_alignment = "bottom"

local divider_text_style = table.clone(UIFontSettings.header_3)

divider_text_style.text_horizontal_alignment = "left"
divider_text_style.text_vertical_alignment = "top"

local widget_definitions = {
	background = UIWidget.create_definition({
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
	}, "screen"),
	title_text = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = Localize("loc_inbox_view_display_name"),
			style = table.clone(UIFontSettings.header_1)
		}
	}, "title_text"),
	title_description = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "Redeem any excess item",
			style = table.clone(UIFontSettings.body)
		}
	}, "title_description"),
	inventory_grid = UIWidget.create_definition({
		{
			style_id = "background",
			pass_type = "rect",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				color = {
					178.5,
					0,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/frames/line_medium",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				color = {
					255,
					0,
					0,
					0
				}
			}
		}
	}, "grid_background"),
	item_background = UIWidget.create_definition({
		{
			style_id = "background",
			pass_type = "rect",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				color = {
					178.5,
					0,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/frames/line_medium",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				color = {
					255,
					0,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/dividers/horizontal_frame_big_upper",
			pass_type = "texture",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				size = {
					nil,
					36
				},
				offset = {
					0,
					-18,
					1
				}
			}
		},
		{
			value = "content/ui/materials/dividers/horizontal_frame_big_lower",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				size = {
					nil,
					36
				},
				offset = {
					0,
					18,
					1
				}
			}
		}
	}, "item_background"),
	item_detail_intro = UIWidget.create_definition({
		{
			value_id = "reward_type",
			style_id = "reward_type",
			pass_type = "text",
			value = "Mission Reward",
			style = reward_type_style
		},
		{
			value_id = " reward_time",
			style_id = " reward_time",
			pass_type = "text",
			value = "2 days ago",
			style = reward_time_style
		}
	}, "item_detail_intro"),
	item_image = UIWidget.create_definition(ItemPassTemplates.item, "item_image", nil, ItemPassTemplates.icon_size),
	item_detail = UIWidget.create_definition({
		{
			value = "Double Battery Shotgun",
			value_id = "name",
			pass_type = "text",
			style = item_name_style
		},
		{
			value = "Relic Shotgun - Side Arm",
			value_id = "item_type",
			pass_type = "text",
			style = item_type_style
		},
		{
			value = "Disconnected",
			value_id = "reward_type",
			pass_type = "text",
			style = reward_reason_style
		}
	}, "item_detail"),
	stats_divider = UIWidget.create_definition({
		{
			value = "Stats",
			value_id = "name",
			pass_type = "text",
			style = divider_text_style
		},
		{
			value = "content/ui/materials/dividers/horizontal_dynamic_lower",
			style_id = "text",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				size = {
					nil,
					10
				}
			}
		}
	}, "stats_divider"),
	modifications_divider = UIWidget.create_definition({
		{
			value = "Modifications",
			value_id = "name",
			pass_type = "text",
			style = divider_text_style
		},
		{
			value = "content/ui/materials/dividers/horizontal_dynamic_lower",
			style_id = "text",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				size = {
					nil,
					10
				}
			}
		}
	}, "modifications_divider"),
	blessings_divider = UIWidget.create_definition({
		{
			value = "Blessings",
			value_id = "name",
			pass_type = "text",
			style = divider_text_style
		},
		{
			value = "content/ui/materials/dividers/horizontal_dynamic_lower",
			style_id = "text",
			pass_type = "texture",
			style = {
				vertical_alignment = "bottom",
				size = {
					nil,
					10
				}
			}
		}
	}, "blessings_divider"),
	loading = UIWidget.create_definition({
		{
			value = "Fetching items",
			value_id = "text",
			pass_type = "text",
			style = loading_style
		}
	}, "loading"),
	claim_button = UIWidget.create_definition(ButtonPassTemplates.default_button, "claim_button", {
		original_text = "Claim"
	}),
	character_portrait = UIWidget.create_definition({
		{
			value_id = "texture",
			style_id = "texture",
			pass_type = "texture",
			value = "content/ui/materials/base/ui_portrait_frame_base",
			style = {
				material_values = {
					texture_frame = "content/ui/textures/icons/items/frames/default",
					use_placeholder_texture = 1
				}
			}
		}
	}, "character_portrait"),
	character_insigna = UIWidget.create_definition({
		{
			value = "content/ui/materials/icons/insignias/insignia_01",
			pass_type = "texture",
			style = {}
		}
	}, "character_insigna"),
	character_name = UIWidget.create_definition({
		{
			value = "text",
			value_id = "text",
			pass_type = "text",
			style = character_name_style
		}
	}, "character_name"),
	character_title = UIWidget.create_definition({
		{
			value = "text",
			value_id = "text",
			pass_type = "text",
			style = character_title_style
		}
	}, "character_title"),
	character_level = UIWidget.create_definition({
		{
			value = "text",
			value_id = "text",
			pass_type = "text",
			style = character_level_style
		}
	}, "character_level"),
	character_experience = UIWidget.create_definition(BarPassTemplates.character_menu_experience_bar, "character_experience", {
		bar_length = character_experience_bar_size[1]
	}, character_experience_bar_size),
	grid_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.default_scrollbar, "grid_scrollbar"),
	grid_mask = UIWidget.create_definition({
		{
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur",
			pass_type = "texture",
			style = {
				color = {
					255,
					255,
					255,
					255
				}
			}
		}
	}, "grid_mask"),
	grid_interaction = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		}
	}, "grid_interaction")
}
local item_definitions = {
	start = UIWidget.create_definition({
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			pass_type = "rect",
			style = {
				color = {
					255,
					0,
					255,
					0
				}
			}
		},
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/frames/hover",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				hdr = true,
				color = Color.ui_terminal(255, true),
				offset = {
					0,
					0,
					2
				},
				size_addition = {
					15,
					15
				}
			},
			change_function = function (content, style, _, dt)
				local hotspot = content.hotspot
				local anim_progress = hotspot.anim_hover_progress

				style.color[1] = anim_progress * 255
				style.hdr = anim_progress == 1
			end
		},
		{
			value = "content/ui/materials/frames/line_light",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					3
				},
				color = Color.ui_terminal(255, true),
				size_addition = {
					2,
					2
				}
			},
			visibility_function = function (content, style)
				return content.is_selected
			end
		}
	}, "grid_content_pivot"),
	background = UIWidget.create_definition(ItemPassTemplates.item_slot, "grid_content_pivot", nil, {
		140,
		100
	})
}
local legend_inputs = {
	{
		input_action = "back",
		on_pressed_callback = "_on_back_pressed",
		display_name = "loc_class_selection_button_back",
		alignment = "left_alignment"
	}
}

return {
	widget_definitions = widget_definitions,
	item_definitions = item_definitions,
	scenegraph_definition = scenegraph_definition,
	legend_inputs = legend_inputs
}
