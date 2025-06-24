-- chunkname: @scripts/ui/views/inventory_view/inventory_view_definitions.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local InventoryViewSettings = require("scripts/ui/views/inventory_view/inventory_view_settings")
local ItemPassTemplates = require("scripts/ui/pass_templates/item_pass_templates")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local item_stats_grid_settings = InventoryViewSettings.item_stats_grid_settings
local scrollbar_width = InventoryViewSettings.scrollbar_width
local grid_size = InventoryViewSettings.grid_size
local mask_size = InventoryViewSettings.mask_size
local grid_start_offset_x = 180
local gear_icon_size = ItemPassTemplates.gear_icon_size
local weapon_item_size = ItemPassTemplates.weapon_item_size
local character_title_button_size = ItemPassTemplates.character_title_button_size
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
	grid_background = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = grid_size,
		position = {
			grid_start_offset_x,
			216,
			1,
		},
	},
	grid_content_pivot = {
		horizontal_alignment = "left",
		parent = "grid_background",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			10,
			0,
			1,
		},
	},
	grid_scrollbar = {
		horizontal_alignment = "right",
		parent = "grid_divider_top",
		vertical_alignment = "top",
		size = {
			scrollbar_width,
			grid_size[2],
		},
		position = {
			-10,
			38,
			1,
		},
	},
	grid_mask = {
		horizontal_alignment = "center",
		parent = "grid_background",
		vertical_alignment = "center",
		size = mask_size,
		position = {
			0,
			0,
			10,
		},
	},
	grid_interaction = {
		horizontal_alignment = "left",
		parent = "grid_background",
		vertical_alignment = "top",
		size = {
			1000 + scrollbar_width * 2,
			mask_size[2],
		},
		position = {
			0,
			0,
			0,
		},
	},
	grid_divider_bottom = {
		horizontal_alignment = "center",
		parent = "grid_background",
		vertical_alignment = "bottom",
		size = {
			grid_size[1] + 2,
			36,
		},
		position = {
			0,
			36,
			12,
		},
	},
	grid_divider_top = {
		horizontal_alignment = "center",
		parent = "grid_background",
		vertical_alignment = "top",
		size = {
			840,
			840,
		},
		position = {
			0,
			-50,
			12,
		},
	},
	grid_tab_panel = {
		horizontal_alignment = "center",
		parent = "grid_divider_top",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			0,
			-50,
			1,
		},
	},
	tab_menu_title_text = {
		horizontal_alignment = "left",
		parent = "grid_divider_top",
		vertical_alignment = "center",
		size = {
			960,
			50,
		},
		position = {
			10,
			-50,
			2,
		},
	},
	tab_menu_back_button = {
		horizontal_alignment = "left",
		parent = "grid_divider_top",
		vertical_alignment = "center",
		size = {
			72,
			72,
		},
		position = {
			-70,
			-50,
			3,
		},
	},
	wallet_entry = {
		horizontal_alignment = "right",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			400,
			40,
		},
		position = {
			-90,
			375,
			1,
		},
	},
	slot_character_title = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = character_title_button_size,
		position = {
			440,
			423,
			9,
		},
	},
	slot_gear_head = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = gear_icon_size,
		position = {
			-440,
			-252,
			9,
		},
	},
	slot_gear_upperbody = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = gear_icon_size,
		position = {
			-440,
			-12,
			9,
		},
	},
	slot_gear_lowerbody = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = gear_icon_size,
		position = {
			-440,
			228,
			9,
		},
	},
	slot_companion_gear_full = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = gear_icon_size,
		position = {
			-696,
			-132,
			9,
		},
	},
	slot_gear_extra_cosmetic = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = gear_icon_size,
		position = {
			440,
			-252,
			9,
		},
	},
	slot_portrait_frame = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = gear_icon_size,
		position = {
			440,
			-12,
			9,
		},
	},
	slot_insignia = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = gear_icon_size,
		position = {
			440,
			228,
			9,
		},
	},
	loadout_frame = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		size = {
			840,
			840,
		},
		position = {
			60,
			166,
			20,
		},
	},
	loadout_background_1 = {
		horizontal_alignment = "left",
		parent = "loadout_frame",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			100,
			80,
			-16,
		},
	},
	loadout_background_2 = {
		horizontal_alignment = "left",
		parent = "loadout_frame",
		vertical_alignment = "top",
		size = {
			0,
			0,
		},
		position = {
			70,
			490,
			-16,
		},
	},
	slot_primary_header = {
		horizontal_alignment = "center",
		parent = "loadout_frame",
		vertical_alignment = "top",
		size = {
			840,
			50,
		},
		position = {
			0,
			38,
			1,
		},
	},
	slot_secondary_header = {
		horizontal_alignment = "center",
		parent = "loadout_frame",
		vertical_alignment = "top",
		size = {
			840,
			50,
		},
		position = {
			0,
			243,
			1,
		},
	},
	slot_primary = {
		horizontal_alignment = "center",
		parent = "loadout_frame",
		vertical_alignment = "top",
		size = weapon_item_size,
		position = {
			0,
			110,
			-15,
		},
	},
	slot_secondary = {
		horizontal_alignment = "center",
		parent = "loadout_frame",
		vertical_alignment = "top",
		size = weapon_item_size,
		position = {
			0,
			315,
			-15,
		},
	},
	button_skin_sets = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			0,
			0,
		},
		position = {
			-620,
			-260,
			0,
		},
	},
	button_expressions = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "center",
		size = {
			0,
			0,
		},
		position = {
			620,
			282,
			0,
		},
	},
	item_stats_pivot = {
		horizontal_alignment = "center",
		parent = "canvas",
		vertical_alignment = "top",
		size = item_stats_grid_settings.grid_size,
		position = {
			210,
			166,
			3,
		},
	},
}

scenegraph_definition.slot_attachments_header = {
	horizontal_alignment = "center",
	parent = "loadout_frame",
	vertical_alignment = "top",
	size = {
		840,
		50,
	},
	position = {
		0,
		450,
		1,
	},
}
scenegraph_definition.slot_attachment_1 = {
	horizontal_alignment = "center",
	parent = "loadout_frame",
	vertical_alignment = "bottom",
	size = ItemPassTemplates.gear_icon_size,
	position = {
		-33 - (ItemPassTemplates.gear_icon_size[1] + 102),
		-187,
		-15,
	},
}
scenegraph_definition.slot_attachment_2 = {
	horizontal_alignment = "center",
	parent = "loadout_frame",
	vertical_alignment = "bottom",
	size = ItemPassTemplates.gear_icon_size,
	position = {
		-33,
		-187,
		-15,
	},
}
scenegraph_definition.slot_attachment_3 = {
	horizontal_alignment = "center",
	parent = "loadout_frame",
	vertical_alignment = "bottom",
	size = ItemPassTemplates.gear_icon_size,
	position = {
		-33 + (ItemPassTemplates.gear_icon_size[1] + 102),
		-187,
		-15,
	},
}
scenegraph_definition.button_emote_1 = {
	horizontal_alignment = "center",
	parent = "canvas",
	vertical_alignment = "center",
	size = {
		0,
		0,
	},
	position = {
		620,
		-338,
		0,
	},
}
scenegraph_definition.button_emote_2 = {
	horizontal_alignment = "center",
	parent = "canvas",
	vertical_alignment = "center",
	size = {
		0,
		0,
	},
	position = {
		620,
		-214,
		0,
	},
}
scenegraph_definition.button_emote_3 = {
	horizontal_alignment = "center",
	parent = "canvas",
	vertical_alignment = "center",
	size = {
		0,
		0,
	},
	position = {
		620,
		-90,
		0,
	},
}
scenegraph_definition.button_emote_4 = {
	horizontal_alignment = "center",
	parent = "canvas",
	vertical_alignment = "center",
	size = {
		0,
		0,
	},
	position = {
		620,
		34,
		0,
	},
}
scenegraph_definition.button_emote_5 = {
	horizontal_alignment = "center",
	parent = "canvas",
	vertical_alignment = "center",
	size = {
		0,
		0,
	},
	position = {
		620,
		158,
		0,
	},
}

local tab_menu_title_text_font_style = table.clone(UIFontSettings.header_1)

tab_menu_title_text_font_style.offset = {
	0,
	0,
	3,
}
tab_menu_title_text_font_style.text_horizontal_alignment = "left"
tab_menu_title_text_font_style.text_vertical_alignment = "center"
tab_menu_title_text_font_style.hover_text_color = Color.ui_brown_super_light(255, true)

local wallet_text_font_style = table.clone(UIFontSettings.body)

wallet_text_font_style.offset = {
	-60,
	0,
	3,
}
wallet_text_font_style.text_horizontal_alignment = "right"
wallet_text_font_style.text_vertical_alignment = "center"

local widget_definitions = {
	tab_menu_title_text = UIWidget.create_definition({
		{
			pass_type = "text",
			value_id = "text",
			style = tab_menu_title_text_font_style,
		},
	}, "tab_menu_title_text"),
	tab_menu_back_button = UIWidget.create_definition(ButtonPassTemplates.title_back_button, "tab_menu_back_button"),
	grid_background = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/backgrounds/terminal_basic",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "center",
				size_addition = {
					20,
					70,
				},
				color = Color.terminal_grid_background(255, true),
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/frames/loadout_main",
			style = {
				scenegraph_id = "grid_divider_top",
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/horizontal_frame_big_lower",
			style = {
				scenegraph_id = "grid_divider_bottom",
			},
		},
	}, "grid_background"),
	grid_scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.default_scrollbar, "grid_scrollbar"),
	grid_mask = UIWidget.create_definition({
		{
			pass_type = "texture",
			value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur",
			style = {
				color = {
					255,
					255,
					255,
					255,
				},
				offset = {
					0,
					0,
					3,
				},
			},
		},
	}, "grid_mask"),
	grid_interaction = UIWidget.create_definition({
		{
			content_id = "hotspot",
			pass_type = "hotspot",
		},
	}, "grid_interaction"),
}
local wallet_entry_definition = UIWidget.create_definition({
	{
		pass_type = "text",
		value = "",
		value_id = "text",
		style = wallet_text_font_style,
	},
	{
		pass_type = "texture",
		value_id = "icon",
		style = {
			horizontal_alignment = "right",
			vertical_alignment = "center",
			color = {
				255,
				255,
				255,
				255,
			},
			size = {
				56,
				40,
			},
			offset = {
				0,
				0,
				0,
			},
		},
	},
}, "wallet_entry")
local animations = {
	wallet_on_enter = {
		{
			end_time = 0.1,
			name = "reset",
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
			end,
		},
		{
			end_time = 1,
			name = "fade_in",
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
			end,
		},
		{
			end_time = 1,
			name = "move",
			start_time = 0.2,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				local anim_progress = math.easeOutCubic(progress)
				local x_anim_distance_max = 0
				local x_anim_distance = x_anim_distance_max - x_anim_distance_max * anim_progress
				local extra_amount = math.clamp(20 - 20 * (anim_progress * 1.2), 0, 20)

				for i = #widgets, 1, -1 do
					local widget = widgets[i]
					local default_offset = widget.default_offset
					local offset = widget.offset

					offset[1] = default_offset[1] + x_anim_distance + extra_amount * (i + 1)
				end
			end,
		},
	},
	wallet_on_exit = {
		{
			end_time = 0.4,
			name = "fade_out",
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
			end,
		},
	},
	cosmetics_on_enter = {
		{
			end_time = 0.6,
			name = "fade_in",
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
			end,
		},
		{
			end_time = 0.8,
			name = "move",
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

				parent.loadout_alpha_multiplier = anim_progress

				local x_anim_distance_max = 50
				local x_anim_distance = x_anim_distance_max - x_anim_distance_max * anim_progress
				local extra_amount = math.clamp(15 - 15 * (anim_progress * 1.2), 0, 15)

				parent:_set_scenegraph_position("slot_gear_head", scenegraph_definition.slot_gear_head.position[1] - x_anim_distance)
				parent:_set_scenegraph_position("slot_gear_upperbody", scenegraph_definition.slot_gear_upperbody.position[1] - x_anim_distance - extra_amount)
				parent:_set_scenegraph_position("slot_gear_lowerbody", scenegraph_definition.slot_gear_lowerbody.position[1] - x_anim_distance - extra_amount * 3)
				parent:_set_scenegraph_position("slot_companion_gear_full", scenegraph_definition.slot_companion_gear_full.position[1] - x_anim_distance - extra_amount * 4)
				parent:_set_scenegraph_position("slot_gear_extra_cosmetic", scenegraph_definition.slot_gear_extra_cosmetic.position[1] + x_anim_distance)
				parent:_set_scenegraph_position("slot_portrait_frame", scenegraph_definition.slot_portrait_frame.position[1] + x_anim_distance + extra_amount)
				parent:_set_scenegraph_position("slot_insignia", scenegraph_definition.slot_insignia.position[1] + x_anim_distance + extra_amount * 3)
				parent:_set_scenegraph_position("button_emote_1", scenegraph_definition.button_emote_1.position[1] + x_anim_distance)
				parent:_set_scenegraph_position("button_emote_2", scenegraph_definition.button_emote_2.position[1] + x_anim_distance + extra_amount)
				parent:_set_scenegraph_position("button_emote_3", scenegraph_definition.button_emote_3.position[1] + x_anim_distance + extra_amount * 3)
				parent:_set_scenegraph_position("button_emote_4", scenegraph_definition.button_emote_4.position[1] + x_anim_distance + extra_amount * 4)
				parent:_set_scenegraph_position("button_emote_5", scenegraph_definition.button_emote_5.position[1] + x_anim_distance + extra_amount * 5)
				parent:_set_scenegraph_position("button_skin_sets", scenegraph_definition.button_skin_sets.position[1] + x_anim_distance + extra_amount * 2)
				parent:_set_scenegraph_position("button_expressions", scenegraph_definition.button_expressions.position[1] + x_anim_distance + extra_amount * 4)
			end,
		},
	},
	loadout_on_enter = {
		{
			end_time = 0.6,
			name = "fade_in",
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
			end,
		},
		{
			end_time = 0.8,
			name = "move",
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

				parent.loadout_alpha_multiplier = anim_progress

				local x_anim_distance_max = 50
				local x_anim_distance = x_anim_distance_max - x_anim_distance_max * anim_progress

				parent:_set_scenegraph_position("loadout_frame", scenegraph_definition.loadout_frame.position[1] - x_anim_distance)
			end,
		},
	},
}

return {
	animations = animations,
	item_stats_grid_settings = item_stats_grid_settings,
	wallet_entry_definition = wallet_entry_definition,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
