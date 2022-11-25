local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local CraftingFuseViewFontStyle = require("scripts/ui/views/crafting_fuse_view/crafting_fuse_view_font_style")
local title_height = 80
local edge_padding = 44
local grid_width = 640
local grid_height = 680
local grid_size = {
	grid_width - edge_padding,
	grid_height
}
local grid_spacing = {
	10,
	10
}
local mask_size = {
	grid_width + 40,
	grid_height
}
local grid_settings = {
	scrollbar_width = 7,
	grid_spacing = grid_spacing,
	grid_size = grid_size,
	mask_size = mask_size,
	title_height = title_height,
	edge_padding = edge_padding
}
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
			1
		}
	},
	grid_background = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			620,
			720
		},
		position = {
			110,
			210,
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
	grid_tab_panel = {
		vertical_alignment = "top",
		parent = "grid_background",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			-40,
			1
		}
	},
	trait_tooltip_pivot = {
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
			162
		}
	},
	trait_tooltip = {
		vertical_alignment = "top",
		parent = "trait_tooltip_pivot",
		horizontal_alignment = "left",
		size = {
			500,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	action_buttons = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			347,
			364
		},
		position = {
			-480,
			-50,
			1
		}
	},
	fuse_description = {
		vertical_alignment = "bottom",
		parent = "action_buttons",
		horizontal_alignment = "center",
		size = {
			347,
			50
		},
		position = {
			0,
			-210,
			63
		}
	},
	fuse_properties = {
		vertical_alignment = "bottom",
		parent = "action_buttons",
		horizontal_alignment = "center",
		size = {
			347,
			50
		},
		position = {
			0,
			-70,
			63
		}
	},
	fuse_tiers = {
		vertical_alignment = "bottom",
		parent = "action_buttons",
		horizontal_alignment = "center",
		size = {
			347,
			50
		},
		position = {
			0,
			-70,
			63
		}
	},
	fuse_price = {
		vertical_alignment = "bottom",
		parent = "action_buttons",
		horizontal_alignment = "center",
		size = {
			347,
			50
		},
		position = {
			0,
			0,
			63
		}
	},
	fuse_item_button = {
		vertical_alignment = "bottom",
		parent = "action_buttons",
		horizontal_alignment = "center",
		size = {
			347,
			76
		},
		position = {
			0,
			0,
			1
		}
	},
	fuse_background = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-660,
			20,
			0
		}
	},
	fuse_1_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			1100,
			400,
			2
		}
	},
	fuse_2_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			1260,
			300,
			2
		}
	},
	fuse_3_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			1420,
			400,
			2
		}
	},
	fuse_end_pivot = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			1260,
			670,
			2
		}
	},
	fuse_1 = {
		vertical_alignment = "center",
		parent = "fuse_1_pivot",
		horizontal_alignment = "center",
		size = {
			180,
			180
		},
		position = {
			0,
			0,
			0
		}
	},
	fuse_2 = {
		vertical_alignment = "center",
		parent = "fuse_2_pivot",
		horizontal_alignment = "center",
		size = {
			180,
			180
		},
		position = {
			0,
			0,
			0
		}
	},
	fuse_3 = {
		vertical_alignment = "center",
		parent = "fuse_3_pivot",
		horizontal_alignment = "center",
		size = {
			180,
			180
		},
		position = {
			0,
			0,
			0
		}
	},
	fuse_end = {
		vertical_alignment = "center",
		parent = "fuse_end_pivot",
		horizontal_alignment = "center",
		size = {
			180,
			180
		},
		position = {
			0,
			0,
			0
		}
	},
	loading_info = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			400,
			200
		},
		position = {
			0,
			0,
			1
		}
	}
}
local fuse_trait_definition = {
	{
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size = {
				180,
				180
			}
		}
	},
	{
		style_id = "trait_empty",
		value_id = "trait_empty",
		pass_type = "texture",
		value = "content/ui/materials/icons/traits/empty",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size = {
				180,
				180
			}
		},
		visibility_function = function (content)
			return content.trait == nil
		end
	},
	{
		style_id = "trait_used",
		value_id = "trait_used",
		pass_type = "texture",
		value = "content/ui/materials/icons/traits/container",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size = {
				180,
				180
			}
		},
		visibility_function = function (content)
			return content.trait ~= nil
		end
	},
	{
		pass_type = "texture",
		style_id = "highlight",
		value = "content/ui/materials/frames/hover",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = Color.ui_terminal(255, true),
			offset = {
				0,
				0,
				2
			},
			size_addition = {
				0,
				0
			},
			size = {
				180,
				180
			}
		},
		change_function = function (content, style)
			local hotspot = content.hotspot
			local progress = hotspot.anim_hover_progress
			style.color[1] = 255 * math.easeOutCubic(progress)
			local list_button_highlight_size_addition = 10
			local size_addition = list_button_highlight_size_addition * math.easeInCubic(1 - progress)
			local style_size_additon = style.size_addition
			style_size_additon[1] = size_addition * 2
			style.size_addition[2] = size_addition * 2
			local offset = style.offset
			offset[1] = -size_addition
			offset[2] = -size_addition
		end,
		visibility_function = function (content, style)
			if content.trait then
				local hotspot = content.hotspot

				return (hotspot.is_hover or hotspot.is_selected or hotspot.is_focused) and content.interactable ~= false
			else
				return false
			end
		end
	}
}
local widget_definitions = {
	fuse_description = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = Localize("loc_crafting_fuse_description"),
			style = CraftingFuseViewFontStyle.fuse_description_font_style
		}
	}, "fuse_description"),
	fuse_tiers = UIWidget.create_definition({
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = "",
			style = CraftingFuseViewFontStyle.fuse_description_font_style
		}
	}, "fuse_tiers"),
	fuse_item_button = UIWidget.create_definition(ButtonPassTemplates.default_button, "fuse_item_button", {
		text = Localize("loc_crafting_fuse_button"),
		hotspot = {
			use_is_focused = true
		}
	}),
	fuse_background = UIWidget.create_definition({
		{
			value = "content/ui/materials/effects/fuse_background",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					960,
					900
				}
			}
		}
	}, "fuse_background"),
	fuse_1 = UIWidget.create_definition(fuse_trait_definition, "fuse_1", nil, {
		180,
		180
	}),
	fuse_2 = UIWidget.create_definition(fuse_trait_definition, "fuse_2", nil, {
		180,
		180
	}),
	fuse_3 = UIWidget.create_definition(fuse_trait_definition, "fuse_3", nil, {
		180,
		180
	}),
	fuse_end = UIWidget.create_definition(fuse_trait_definition, "fuse_end", nil, {
		180,
		180
	}),
	loading_info = UIWidget.create_definition({
		{
			style_id = "loading",
			pass_type = "text",
			value = Localize("loc_crafting_loading"),
			style = CraftingFuseViewFontStyle.loading_style
		}
	}, "loading_info")
}
local price_definition = UIWidget.create_definition({
	{
		value_id = "texture",
		style_id = "texture",
		pass_type = "texture",
		value = "content/ui/materials/icons/currencies/marks_small",
		style = {
			vertical_alignment = "center",
			size = {
				33.6,
				24
			},
			offset = {
				-28,
				0,
				1
			}
		}
	},
	{
		value_id = "text",
		style_id = "text",
		pass_type = "text",
		value = "0",
		style = CraftingFuseViewFontStyle.price_text_font_style
	}
}, "fuse_price")

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	grid_settings = grid_settings,
	price_definition = price_definition
}
