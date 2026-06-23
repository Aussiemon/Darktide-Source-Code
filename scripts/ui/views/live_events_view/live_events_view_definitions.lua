-- chunkname: @scripts/ui/views/live_events_view/live_events_view_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local Styles = require("scripts/ui/views/live_events_view/live_events_view_styles")
local Settings = require("scripts/ui/views/live_events_view/live_events_view_settings")
local WalletSettings = require("scripts/settings/wallet_settings")
local BarPassTemplates = require("scripts/ui/pass_templates/bar_pass_templates")
local InputDevice = require("scripts/managers/input/input_device")
local default_entry_width = Settings.default_entry_width
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	canvas = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		position = {
			0,
			0,
			1,
		},
		size = {
			1920,
			1080,
		},
	},
	left_panel = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "top",
		position = {
			0,
			0,
			1,
		},
		size = {
			400,
			1080,
		},
	},
	button_list_anchor = {
		horizontal_alignment = "center",
		parent = "left_panel",
		vertical_alignment = "top",
		position = {
			40,
			100,
			1,
		},
		size = {
			380,
			1,
		},
	},
	right_panel = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "top",
		position = {
			0,
			0,
			1,
		},
		size = {
			1520,
			1080,
		},
	},
	entries_anchor = {
		horizontal_alignment = "center",
		parent = "right_panel",
		vertical_alignment = "top",
		position = {
			0,
			100,
			1,
		},
		size = {
			default_entry_width,
			1,
		},
	},
	navigation_arrow_left = {
		horizontal_alignment = "left",
		parent = "entries_anchor",
		vertical_alignment = "center",
		position = {
			10,
			0,
			10,
		},
		size = {
			48,
			48,
		},
	},
	navigation_arrow_right = {
		horizontal_alignment = "right",
		parent = "entries_anchor",
		vertical_alignment = "center",
		position = {
			-10,
			0,
			10,
		},
		size = {
			48,
			48,
		},
	},
	entries = {
		horizontal_alignment = "center",
		parent = "entries_anchor",
		vertical_alignment = "center",
		position = {
			0,
			0,
			1,
		},
		size = {
			default_entry_width,
			1,
		},
	},
	entries_mask = {
		horizontal_alignment = "center",
		parent = "entries_anchor",
		vertical_alignment = "center",
		position = {
			0,
			0,
			1,
		},
		size = {
			default_entry_width,
			1,
		},
	},
	rewards_anchor = {
		horizontal_alignment = "center",
		parent = "entries_anchor",
		vertical_alignment = "bottom",
		position = {
			0,
			-160,
			1,
		},
		size = {
			0,
			0,
		},
	},
	event_progress_bar = {
		horizontal_alignment = "center",
		parent = "entries_anchor",
		vertical_alignment = "bottom",
		position = {
			0,
			-60,
			2,
		},
		size = {
			1200,
			20,
		},
	},
	rewards_box = {
		horizontal_alignment = "center",
		parent = "event_progress_bar",
		vertical_alignment = "bottom",
		position = {
			0,
			-116,
			2,
		},
		size = {
			1200 - (Styles.sizes.reward_icon_size[1] - 20),
			Styles.sizes.reward_icon_size[2],
		},
	},
	reward_tooltip = {
		horizontal_alignment = "left",
		parent = "screen",
		vertical_alignment = "top",
		position = {
			0,
			0,
			100,
		},
		size = {
			1,
			1,
		},
	},
}
local reward_info_tooltip = UIWidget.create_definition({
	{
		pass_type = "texture",
		style_id = "item_info_upper",
		value = "content/ui/materials/frames/item_info_upper",
		value_id = "item_info_upper",
		style = Styles.tooltip.item_info_upper,
	},
	{
		pass_type = "texture",
		style_id = "item_info_lower",
		value = "content/ui/materials/frames/item_info_lower",
		value_id = "item_info_lower",
		style = Styles.tooltip.item_info_lower,
	},
	{
		pass_type = "text",
		style_id = "reward_tooltip_type",
		value_id = "reward_tooltip_type",
		style = Styles.tooltip.reward_tooltip_type,
	},
	{
		pass_type = "text",
		style_id = "reward_tooltip_info",
		value_id = "reward_tooltip_info",
		style = Styles.tooltip.reward_tooltip_info,
	},
	{
		pass_type = "text",
		style_id = "reward_tooltip_rarity",
		value_id = "reward_tooltip_rarity",
		style = Styles.tooltip.reward_tooltip_rarity,
	},
	{
		pass_type = "text",
		style_id = "reward_tooltip_target_xp",
		value_id = "reward_tooltip_target_xp",
		style = Styles.tooltip.reward_tooltip_target_xp,
	},
	{
		pass_type = "rect",
		style_id = "background_rect",
		style = Styles.tooltip.background_rect,
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/terminal_basic",
		value_id = "background",
		style = Styles.tooltip.reward_tooltip_background,
	},
}, "reward_tooltip")
local background_masked = UIWidget.create_definition({
	{
		pass_type = "texture",
		style_id = "top_detail",
		value = "content/ui/materials/dividers/horizontal_frame_big_upper",
		value_id = "top_detail",
		style = Styles.entry.top_detail,
	},
	{
		pass_type = "texture",
		style_id = "top_center_detail",
		value = "content/ui/materials/frames/end_of_round/reward_levelup_upper_skull_gray",
		value_id = "top_center_detail",
		style = Styles.entry.top_center_detail,
	},
	{
		pass_type = "texture",
		style_id = "bottom_detail",
		value = "content/ui/materials/dividers/horizontal_frame_big_lower",
		value_id = "bottom_detail",
		style = Styles.entry.bottom_detail,
	},
	{
		pass_type = "rect",
		style_id = "background_rect",
		style = Styles.entry.background_rect,
	},
	{
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/terminal_basic",
		value_id = "background",
		style = Styles.entry.background,
	},
	{
		pass_type = "texture",
		scenegraph_id = "entries_mask",
		value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur",
	},
}, "entries_anchor")
local navigation_arrow_left = UIWidget.create_definition({
	{
		content_id = "hotspot",
		pass_type = "hotspot",
	},
	{
		pass_type = "texture_uv",
		style_id = "arrow",
		value = "content/ui/materials/buttons/premium_store_button_next_page",
		value_id = "arrow",
		style = {
			uvs = {
				{
					1,
					0,
				},
				{
					0,
					1,
				},
			},
		},
		visibility_function = function (content, style)
			local hotspot = content.hotspot

			return not hotspot.is_selected and not hotspot.is_hover and not hotspot.is_focused
		end,
	},
	{
		pass_type = "texture_uv",
		style_id = "arrow_active",
		value = "content/ui/materials/buttons/premium_store_button_next_page_hover",
		value_id = "arrow_active",
		style = {
			uvs = {
				{
					1,
					0,
				},
				{
					0,
					1,
				},
			},
		},
		visibility_function = function (content, style)
			local hotspot = content.hotspot

			return hotspot.is_selected or hotspot.is_hover or hotspot.is_focused
		end,
	},
}, "navigation_arrow_left")
local navigation_arrow_right = UIWidget.create_definition({
	{
		content_id = "hotspot",
		pass_type = "hotspot",
	},
	{
		pass_type = "texture",
		style_id = "arrow",
		value = "content/ui/materials/buttons/premium_store_button_next_page",
		value_id = "arrow",
		visibility_function = function (content, style)
			local hotspot = content.hotspot

			return not hotspot.is_selected and not hotspot.is_hover and not hotspot.is_focused
		end,
	},
	{
		pass_type = "texture",
		style_id = "arrow_active",
		value = "content/ui/materials/buttons/premium_store_button_next_page_hover",
		value_id = "arrow_active",
		visibility_function = function (content, style)
			local hotspot = content.hotspot

			return hotspot.is_selected or hotspot.is_hover or hotspot.is_focused
		end,
	},
}, "navigation_arrow_right")
local widget_definitions = {
	background_masked = background_masked,
	reward_info_tooltip = reward_info_tooltip,
	navigation_arrow_left = navigation_arrow_left,
	navigation_arrow_right = navigation_arrow_right,
}
local animations = {}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	animations = animations,
}
