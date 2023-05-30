local InventoryViewSettings = require("scripts/ui/views/inventory_view/inventory_view_settings")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local ItemPassTemplates = require("scripts/ui/pass_templates/item_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local item_stats_grid_settings = nil
local padding = 12
local width = 530
local height = 920
item_stats_grid_settings = {
	scrollbar_width = 7,
	ignore_blur = true,
	title_height = 70,
	grid_spacing = {
		0,
		0
	},
	grid_size = {
		width - padding,
		height
	},
	mask_size = {
		width + 40,
		height
	},
	edge_padding = padding
}
local scrollbar_width = InventoryViewSettings.scrollbar_width
local grid_size = InventoryViewSettings.grid_size
local mask_size = InventoryViewSettings.mask_size
local grid_start_offset_x = 180
local gear_icon_size = ItemPassTemplates.gear_icon_size
local weapon_item_size = ItemPassTemplates.weapon_item_size
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
	grid_background = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "left",
		size = grid_size,
		position = {
			grid_start_offset_x,
			0,
			1
		}
	},
	grid_background = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = grid_size,
		position = {
			grid_start_offset_x,
			216,
			1
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
			10,
			0,
			1
		}
	},
	grid_scrollbar = {
		vertical_alignment = "top",
		parent = "grid_divider_top",
		horizontal_alignment = "right",
		size = {
			scrollbar_width,
			grid_size[2]
		},
		position = {
			-10,
			38,
			1
		}
	},
	grid_mask = {
		vertical_alignment = "center",
		parent = "grid_background",
		horizontal_alignment = "center",
		size = mask_size,
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
			1000 + scrollbar_width * 2,
			mask_size[2]
		},
		position = {
			0,
			0,
			0
		}
	},
	grid_divider_bottom = {
		vertical_alignment = "bottom",
		parent = "grid_background",
		horizontal_alignment = "center",
		size = {
			grid_size[1] + 2,
			36
		},
		position = {
			0,
			36,
			12
		}
	},
	grid_divider_top = {
		vertical_alignment = "top",
		parent = "grid_background",
		horizontal_alignment = "center",
		size = {
			840,
			840
		},
		position = {
			0,
			-50,
			12
		}
	},
	grid_tab_panel = {
		vertical_alignment = "top",
		parent = "grid_divider_top",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			-50,
			1
		}
	},
	tab_menu_title_text = {
		vertical_alignment = "center",
		parent = "grid_divider_top",
		horizontal_alignment = "left",
		size = {
			960,
			50
		},
		position = {
			10,
			-50,
			2
		}
	},
	tab_menu_back_button = {
		vertical_alignment = "center",
		parent = "grid_divider_top",
		horizontal_alignment = "left",
		size = {
			72,
			72
		},
		position = {
			-70,
			-50,
			3
		}
	},
	wallet_entry = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			400,
			40
		},
		position = {
			-90,
			375,
			1
		}
	},
	slot_gear_head = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = gear_icon_size,
		position = {
			-420,
			-230,
			9
		}
	},
	slot_gear_upperbody = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = gear_icon_size,
		position = {
			-420,
			30,
			9
		}
	},
	slot_gear_lowerbody = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = gear_icon_size,
		position = {
			-420,
			290,
			9
		}
	},
	slot_gear_extra_cosmetic = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = gear_icon_size,
		position = {
			420,
			-230,
			9
		}
	},
	slot_portrait_frame = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = gear_icon_size,
		position = {
			420,
			30,
			9
		}
	},
	slot_insignia = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = gear_icon_size,
		position = {
			420,
			290,
			9
		}
	},
	loadout_frame = {
		vertical_alignment = "top",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			840,
			840
		},
		position = {
			60,
			166,
			20
		}
	},
	loadout_background_1 = {
		vertical_alignment = "top",
		parent = "loadout_frame",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			100,
			80,
			-16
		}
	},
	loadout_background_2 = {
		vertical_alignment = "top",
		parent = "loadout_frame",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			70,
			490,
			-16
		}
	},
	slot_primary_header = {
		vertical_alignment = "top",
		parent = "loadout_frame",
		horizontal_alignment = "center",
		size = {
			840,
			50
		},
		position = {
			0,
			38,
			1
		}
	},
	slot_secondary_header = {
		vertical_alignment = "top",
		parent = "loadout_frame",
		horizontal_alignment = "center",
		size = {
			840,
			50
		},
		position = {
			0,
			243,
			1
		}
	},
	slot_primary = {
		vertical_alignment = "top",
		parent = "loadout_frame",
		horizontal_alignment = "center",
		size = weapon_item_size,
		position = {
			0,
			110,
			-15
		}
	},
	slot_secondary = {
		vertical_alignment = "top",
		parent = "loadout_frame",
		horizontal_alignment = "center",
		size = weapon_item_size,
		position = {
			0,
			315,
			-15
		}
	},
	button_skin_sets = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-620,
			-230,
			0
		}
	},
	button_expressions = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			600,
			320,
			0
		}
	},
	item_stats_pivot = {
		vertical_alignment = "top",
		parent = "loadout_frame",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			840,
			0,
			3
		}
	},
	slot_attachments_header = {
		vertical_alignment = "top",
		parent = "loadout_frame",
		horizontal_alignment = "center",
		size = {
			840,
			50
		},
		position = {
			0,
			450,
			1
		}
	},
	slot_attachment_1 = {
		vertical_alignment = "bottom",
		parent = "loadout_frame",
		horizontal_alignment = "center",
		size = ItemPassTemplates.gear_icon_size,
		position = {
			-33 - (ItemPassTemplates.gear_icon_size[1] + 102),
			-187,
			-15
		}
	},
	slot_attachment_2 = {
		vertical_alignment = "bottom",
		parent = "loadout_frame",
		horizontal_alignment = "center",
		size = ItemPassTemplates.gear_icon_size,
		position = {
			-33,
			-187,
			-15
		}
	},
	slot_attachment_3 = {
		vertical_alignment = "bottom",
		parent = "loadout_frame",
		horizontal_alignment = "center",
		size = ItemPassTemplates.gear_icon_size,
		position = {
			-33 + ItemPassTemplates.gear_icon_size[1] + 102,
			-187,
			-15
		}
	},
	button_emote_1 = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			600,
			-330,
			0
		}
	},
	button_emote_2 = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			600,
			-200,
			0
		}
	},
	button_emote_3 = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			600,
			-70,
			0
		}
	},
	button_emote_4 = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			600,
			60,
			0
		}
	},
	button_emote_5 = {
		vertical_alignment = "center",
		parent = "canvas",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			600,
			190,
			0
		}
	}
}
local tab_menu_title_text_font_style = table.clone(UIFontSettings.header_1)
tab_menu_title_text_font_style.offset = {
	0,
	0,
	3
}
tab_menu_title_text_font_style.text_horizontal_alignment = "left"
tab_menu_title_text_font_style.text_vertical_alignment = "center"
tab_menu_title_text_font_style.hover_text_color = Color.ui_brown_super_light(255, true)
local wallet_text_font_style = table.clone(UIFontSettings.body)
wallet_text_font_style.offset = {
	-60,
	0,
	3
}
wallet_text_font_style.text_horizontal_alignment = "right"
wallet_text_font_style.text_vertical_alignment = "center"
local widget_definitions = {
	tab_menu_title_text = UIWidget.create_definition({
		{
			value_id = "text",
			pass_type = "text",
			style = tab_menu_title_text_font_style
		}
	}, "tab_menu_title_text"),
	tab_menu_back_button = UIWidget.create_definition(ButtonPassTemplates.title_back_button, "tab_menu_back_button"),
	grid_background = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				size_addition = {
					20,
					70
				},
				color = Color.terminal_grid_background(255, true)
			}
		},
		{
			value = "content/ui/materials/frames/loadout_main",
			pass_type = "texture",
			style = {
				scenegraph_id = "grid_divider_top"
			}
		},
		{
			value = "content/ui/materials/dividers/horizontal_frame_big_lower",
			pass_type = "texture",
			style = {
				scenegraph_id = "grid_divider_bottom"
			}
		}
	}, "grid_background"),
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
				},
				offset = {
					0,
					0,
					3
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
local wallet_entry_definition = UIWidget.create_definition({
	{
		value = "",
		value_id = "text",
		pass_type = "text",
		style = wallet_text_font_style
	},
	{
		value_id = "icon",
		pass_type = "texture",
		style = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			color = {
				255,
				255,
				255,
				255
			},
			size = {
				56,
				40
			},
			offset = {
				0,
				0,
				0
			}
		}
	}
}, "wallet_entry")
local animations = {
	wallet_on_enter = {
		{
			name = "reset",
			end_time = 0.1,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				parent.loadout_alpha_multiplier = 0

				for i = 1, #widgets do
					local widget = widgets[i]
					widget.alpha_multiplier = 0
					local offset = widget.offset

					if not widget.default_offset then
						widget.default_offset = table.clone(offset)
					end
				end
			end
		},
		{
			name = "fade_in",
			end_time = 1,
			start_time = 0.2,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				local anim_progress = math.easeCubic(progress)

				for i = #widgets, 1, -1 do
					local widget = widgets[i]
					widget.alpha_multiplier = math.clamp(anim_progress * (1 + (i - 1) * 0.4), 0, 1)
				end
			end
		},
		{
			name = "move",
			end_time = 1,
			start_time = 0.2,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				local anim_progress = math.easeOutCubic(progress)
				local x_anim_distance_max = 0
				local x_anim_distance = x_anim_distance_max - x_anim_distance_max * anim_progress
				local extra_amount = math.clamp(20 - 20 * anim_progress * 1.2, 0, 20)

				for i = #widgets, 1, -1 do
					local widget = widgets[i]
					local default_offset = widget.default_offset
					local offset = widget.offset
					offset[1] = default_offset[1] + x_anim_distance + extra_amount * (i + 1)
				end
			end
		}
	},
	wallet_on_exit = {
		{
			name = "fade_out",
			end_time = 0.4,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				local anim_progress = math.easeInCubic(1 - progress)

				for i = #widgets, 1, -1 do
					local widget = widgets[i]
					widget.alpha_multiplier = math.min(math.clamp(anim_progress * (1 + (i - 1) * 0.4), 0, 1), widget.alpha_multiplier or 0)
				end
			end
		}
	},
	cosmetics_on_enter = {
		{
			name = "fade_in",
			end_time = 0.6,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				parent.loadout_alpha_multiplier = 0

				for i = 1, #widgets do
					local widget = widgets[i]
					widget.alpha_multiplier = 0
				end

				local loadout_widgets = parent._loadout_widgets

				if loadout_widgets then
					for i = 1, #loadout_widgets do
						local widget = loadout_widgets[i]
						widget.alpha_multiplier = 0
					end
				end
			end
		},
		{
			name = "move",
			end_time = 0.8,
			start_time = 0.35,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				local anim_progress = math.easeOutCubic(progress)
				local loadout_widgets = parent._loadout_widgets

				for i = 1, #loadout_widgets do
					local widget = loadout_widgets[i]
					widget.alpha_multiplier = anim_progress
				end

				for i = 1, #widgets do
					local widget = widgets[i]
					widget.alpha_multiplier = anim_progress
				end

				local x_anim_distance_max = 50
				local x_anim_distance = x_anim_distance_max - x_anim_distance_max * anim_progress
				local extra_amount = math.clamp(15 - 15 * anim_progress * 1.2, 0, 15)

				parent:_set_scenegraph_position("slot_gear_head", scenegraph_definition.slot_gear_head.position[1] - x_anim_distance)
				parent:_set_scenegraph_position("slot_gear_upperbody", scenegraph_definition.slot_gear_upperbody.position[1] - x_anim_distance - extra_amount)
				parent:_set_scenegraph_position("slot_gear_lowerbody", scenegraph_definition.slot_gear_lowerbody.position[1] - x_anim_distance - extra_amount - extra_amount - extra_amount)
				parent:_set_scenegraph_position("slot_gear_extra_cosmetic", scenegraph_definition.slot_gear_extra_cosmetic.position[1] + x_anim_distance)
				parent:_set_scenegraph_position("slot_portrait_frame", scenegraph_definition.slot_portrait_frame.position[1] + x_anim_distance + extra_amount)
				parent:_set_scenegraph_position("slot_insignia", scenegraph_definition.slot_insignia.position[1] + x_anim_distance + extra_amount + extra_amount + extra_amount)
				parent:_set_scenegraph_position("button_emote_1", scenegraph_definition.button_emote_1.position[1] + x_anim_distance)
				parent:_set_scenegraph_position("button_emote_2", scenegraph_definition.button_emote_2.position[1] + x_anim_distance + extra_amount)
				parent:_set_scenegraph_position("button_emote_3", scenegraph_definition.button_emote_3.position[1] + x_anim_distance + extra_amount + extra_amount + extra_amount)
				parent:_set_scenegraph_position("button_emote_4", scenegraph_definition.button_emote_4.position[1] + x_anim_distance + extra_amount + extra_amount + extra_amount + extra_amount)
				parent:_set_scenegraph_position("button_emote_5", scenegraph_definition.button_emote_5.position[1] + x_anim_distance + extra_amount + extra_amount + extra_amount + extra_amount + extra_amount)
				parent:_set_scenegraph_position("button_skin_sets", scenegraph_definition.button_skin_sets.position[1] + x_anim_distance + extra_amount * 2)
				parent:_set_scenegraph_position("button_expressions", scenegraph_definition.button_expressions.position[1] + x_anim_distance + extra_amount * 4)
			end
		}
	},
	loadout_on_enter = {
		{
			name = "fade_in",
			end_time = 0.6,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				parent.loadout_alpha_multiplier = 0

				for i = 1, #widgets do
					local widget = widgets[i]
					widget.alpha_multiplier = 0
				end

				local loadout_widgets = parent._loadout_widgets

				if loadout_widgets then
					for i = 1, #loadout_widgets do
						local widget = loadout_widgets[i]
						widget.alpha_multiplier = 0
					end
				end
			end
		},
		{
			name = "move",
			end_time = 0.8,
			start_time = 0.35,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				local anim_progress = math.easeOutCubic(progress)
				local loadout_widgets = parent._loadout_widgets

				for i = 1, #loadout_widgets do
					local widget = loadout_widgets[i]
					widget.alpha_multiplier = anim_progress
				end

				for i = 1, #widgets do
					local widget = widgets[i]
					widget.alpha_multiplier = anim_progress
				end

				local x_anim_distance_max = 50
				local x_anim_distance = x_anim_distance_max - x_anim_distance_max * anim_progress
				local extra_amount = math.clamp(15 - 15 * anim_progress * 1.2, 0, 15)

				parent:_set_scenegraph_position("loadout_frame", scenegraph_definition.loadout_frame.position[1] - x_anim_distance)
			end
		}
	}
}

return {
	animations = animations,
	item_stats_grid_settings = item_stats_grid_settings,
	wallet_entry_definition = wallet_entry_definition,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
