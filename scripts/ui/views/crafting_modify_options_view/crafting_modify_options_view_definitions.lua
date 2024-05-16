-- chunkname: @scripts/ui/views/crafting_modify_options_view/crafting_modify_options_view_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local CraftingModifyOptionsViewFontStyle = require("scripts/ui/views/crafting_modify_options_view/crafting_modify_options_view_font_style")
local title_height = 80
local edge_padding = 44
local grid_width = 640
local grid_height = 680
local grid_size = {
	grid_width - edge_padding,
	grid_height,
}
local grid_spacing = {
	10,
	10,
}
local mask_size = {
	grid_width + 40,
	grid_height,
}
local grid_settings = {
	scrollbar_width = 7,
	grid_spacing = grid_spacing,
	grid_size = grid_size,
	mask_size = mask_size,
	title_height = title_height,
	edge_padding = edge_padding,
}
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
			1,
		},
	},
	weapon_name_pivot = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			130,
			3,
		},
	},
	display_name = {
		horizontal_alignment = "center",
		parent = "weapon_name_pivot",
		vertical_alignment = "top",
		size = {
			1700,
			50,
		},
		position = {
			0,
			0,
			3,
		},
	},
	sub_display_name = {
		horizontal_alignment = "center",
		parent = "display_name",
		vertical_alignment = "top",
		size = {
			1700,
			50,
		},
		position = {
			0,
			35,
			4,
		},
	},
	display_name_divider = {
		horizontal_alignment = "center",
		parent = "sub_display_name",
		vertical_alignment = "top",
		size = {
			344,
			18,
		},
		position = {
			0,
			50,
			0,
		},
	},
	display_name_divider_glow = {
		horizontal_alignment = "center",
		parent = "display_name_divider",
		vertical_alignment = "top",
		size = {
			380,
			80,
		},
		position = {
			0,
			-74,
			-1,
		},
	},
	selected_trait = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = {
			150,
			150,
		},
		position = {
			0,
			0,
			4,
		},
	},
	trait_tooltip_pivot = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			162,
		},
	},
	trait_tooltip = {
		horizontal_alignment = "left",
		parent = "trait_tooltip_pivot",
		vertical_alignment = "top",
		size = {
			500,
			0,
		},
		position = {
			0,
			0,
			0,
		},
	},
	modify_title = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			470,
			76,
		},
		position = {
			0,
			-180,
			1,
		},
	},
	modify_text = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			470,
			76,
		},
		position = {
			0,
			-100,
			1,
		},
	},
	modify_pivot = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			1920,
			180,
		},
		position = {
			0,
			-300,
			1,
		},
	},
	modify_arrow_widget = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = {
			160,
			95,
		},
		position = {
			-80,
			0,
			4,
		},
	},
	upgrade_text = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			374,
			76,
		},
		position = {
			0,
			-430,
			1,
		},
	},
	upgrade_next_rarity_text = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			374,
			50,
		},
		position = {
			0,
			-390,
			1,
		},
	},
	upgrade_item_button = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			374,
			76,
		},
		position = {
			0,
			-320,
			1,
		},
	},
	action_cost = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			0,
			50,
		},
		position = {
			0,
			-270,
			1,
		},
	},
	extract_trait_pivot = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			0,
			0,
		},
		position = {
			0,
			-610,
			4,
		},
	},
	replace_trait_pivot = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "center",
		size = {
			0,
			0,
		},
		position = {
			-1075,
			0,
			4,
		},
	},
	inventory_traits_grid = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			620,
			720,
		},
		position = {
			0,
			0,
			0,
		},
	},
	inventory_traits_grid_pivot = {
		horizontal_alignment = "left",
		parent = "inventory_traits_grid",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			0,
			1,
		},
	},
	inventory_traits_tab_pivot = {
		horizontal_alignment = "center",
		parent = "inventory_traits_grid",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			-40,
			1,
		},
	},
	loading_info = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			400,
			200,
		},
		position = {
			0,
			0,
			1,
		},
	},
	corner_top_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			150,
			570,
		},
		position = {
			0,
			0,
			62,
		},
	},
	corner_top_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "top",
		size = {
			346,
			570,
		},
		position = {
			0,
			0,
			62,
		},
	},
	corner_bottom_left = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			180,
			350,
		},
		position = {
			0,
			0,
			62,
		},
	},
	corner_bottom_right = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "bottom",
		size = {
			180,
			350,
		},
		position = {
			0,
			0,
			62,
		},
	},
}
local widget_definitions = {
	modify_divider = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/horizontal_dynamic_lower",
			style = {
				horizontal_alignment = "center",
				size = {
					380,
					10,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/skull_rendered_center_01",
			style = {
				horizontal_alignment = "center",
				size = {
					140,
					18,
				},
				offset = {
					0,
					-1,
					1,
				},
			},
		},
	}, "display_name_divider"),
	modify_divider_glow = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "texture",
			value = "content/ui/materials/effects/wide_upward_glow",
		},
	}, "display_name_divider_glow"),
	modify_display_name = UIWidget.create_definition({
		{
			pass_type = "text",
			value = "",
			value_id = "text",
			style = CraftingModifyOptionsViewFontStyle.display_name_style,
		},
	}, "display_name"),
	modify_sub_display_name = UIWidget.create_definition({
		{
			pass_type = "text",
			value = "",
			value_id = "text",
			style = CraftingModifyOptionsViewFontStyle.sub_display_name_style,
		},
	}, "sub_display_name"),
	upgrade_item_button = UIWidget.create_definition(table.clone(ButtonPassTemplates.default_button), "upgrade_item_button", {
		original_text = Localize("loc_crafting_upgrade_button"),
		hotspot = {
			use_is_focused = true,
			on_pressed_sound = UISoundEvents.weapons_customize_enter,
		},
	}),
	upgrade_next_rarity_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = CraftingModifyOptionsViewFontStyle.sub_display_name_style,
		},
	}, "upgrade_next_rarity_text"),
	upgrade_unavailable_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = CraftingModifyOptionsViewFontStyle.upgrade_text_style,
		},
	}, "upgrade_item_button"),
	modify_title = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = CraftingModifyOptionsViewFontStyle.upgrade_title_style,
		},
		{
			pass_type = "texture",
			style_id = "texture",
			value = "content/ui/materials/dividers/skull_rendered_center_01",
			value_id = "texture",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					140,
					18,
				},
				offset = {
					0,
					0,
					1,
				},
			},
		},
	}, "modify_title"),
	modify_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "text",
			value = "",
			value_id = "text",
			style = CraftingModifyOptionsViewFontStyle.upgrade_text_style,
		},
	}, "modify_text"),
	modify_arrow_widget = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "arrow_style_1",
			value = "content/ui/materials/icons/traits/crafting_insert",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					0,
				},
				size = {
					54,
					94,
				},
				color = Color.ui_terminal(255, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "arrow_style_2",
			value = "content/ui/materials/icons/traits/crafting_insert",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				offset = {
					-27,
					0,
					0,
				},
				size = {
					54,
					94,
				},
				color = Color.ui_terminal(255, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "arrow_style_3",
			value = "content/ui/materials/icons/traits/crafting_insert",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				offset = {
					-54,
					0,
					0,
				},
				size = {
					54,
					94,
				},
				color = Color.ui_terminal(255, true),
			},
		},
		{
			pass_type = "texture",
			style_id = "arrow_style_4",
			value = "content/ui/materials/icons/traits/crafting_insert",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				offset = {
					-81,
					0,
					0,
				},
				size = {
					54,
					94,
				},
				color = Color.ui_terminal(255, true),
			},
		},
	}, "modify_arrow_widget"),
	extract_trait_button = UIWidget.create_definition(table.clone(ButtonPassTemplates.default_button), "upgrade_item_button", {
		original_text = Localize("loc_crafting_extract_button"),
		hotspot = {
			use_is_focused = true,
			on_pressed_sound = UISoundEvents.weapons_customize_enter,
		},
	}),
	loading_info = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "loading",
			value = Localize("loc_crafting_loading"),
			style = CraftingModifyOptionsViewFontStyle.loading_style,
		},
	}, "loading_info"),
}
local price_definition = {
	{
		pass_type = "texture",
		style_id = "texture",
		value = "content/ui/materials/icons/currencies/marks_small",
		value_id = "texture",
		style = {
			vertical_alignment = "center",
			size = {
				42,
				30,
			},
			offset = {
				0,
				0,
				1,
			},
		},
	},
	{
		pass_type = "text",
		style_id = "text",
		value = "0",
		value_id = "text",
		style = CraftingModifyOptionsViewFontStyle.price_text_font_style,
	},
}
local modify_arrow_animation = {
	init = function (self)
		local widget = self._widgets_by_name.modify_arrow_widget

		for i = 1, 4 do
			widget.style["arrow_style_" .. i].color[1] = i == 1 and 255 or 0
		end
	end,
	update = function (self, dt, current_progress)
		local widget = self._widgets_by_name.modify_arrow_widget
		local progress = current_progress + dt
		local full_animation_time = 1
		local delay_between = 2
		local start_delay = 0.5

		for i = 1, 4 do
			local pass_name = "arrow_style_" .. i
			local wave = 255 * (0.5 * (1 + math.sin(-(start_delay * (i - 1)) + 2 * math.pi * full_animation_time * progress)))

			widget.style[pass_name].color[1] = wave
		end
	end,
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	grid_settings = grid_settings,
	price_definition = price_definition,
	modify_arrow_animation = modify_arrow_animation,
}
