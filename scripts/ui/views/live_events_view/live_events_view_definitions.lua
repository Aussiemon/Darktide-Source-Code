-- chunkname: @scripts/ui/views/live_events_view/live_events_view_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local Styles = require("scripts/ui/views/live_events_view/live_events_view_styles")
local Settings = require("scripts/ui/views/live_events_view/live_events_view_settings")
local WalletSettings = require("scripts/settings/wallet_settings")
local BarPassTemplates = require("scripts/ui/pass_templates/bar_pass_templates")
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
			1420,
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
}
local entry_base = UIWidget.create_definition({
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
		pass_type = "text",
		style_id = "event_name",
		value = "event_name",
		value_id = "event_name",
		style = Styles.texts.event_name,
	},
	{
		pass_type = "texture",
		style_id = "event_name_divider",
		value = "content/ui/materials/dividers/skull_center_02",
		value_id = "event_name_divider",
		style = Styles.texts.event_name_divider,
	},
	{
		pass_type = "text",
		style_id = "event_lore",
		value = "event_lore",
		value_id = "event_lore",
		style = Styles.texts.event_lore,
	},
	{
		pass_type = "text",
		style_id = "event_context",
		value = "event_context",
		value_id = "event_context",
		style = Styles.texts.event_context,
	},
	{
		pass_type = "text",
		style_id = "event_description",
		value = "event_description",
		value_id = "event_description",
		style = Styles.texts.event_description,
	},
	{
		pass_type = "text",
		style_id = "rewards_track_text",
		value_id = "rewards_track_text",
		style = Styles.texts.rewards_track_text,
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
}, "entries_anchor")

local function create_reward_widget(scenegraph_id, reward, tier_index, reward_index)
	local reward_type = reward.type
	local amount = reward.amount
	local currency = reward.currency
	local currency_settings = currency and WalletSettings[currency]
	local currency_icon = currency_settings and currency_settings.icon_texture_big
	local id = reward.id
	local passes = {}
	local reward_frame_pass = {
		pass_type = "texture",
		style_id = "frame",
		value = "content/ui/materials/frames/frame_tile_2px",
		value_id = "frame",
		style = Styles.reward.frame,
	}
	local reward_background_pass = {
		pass_type = "texture",
		style_id = "background",
		value = "content/ui/materials/backgrounds/terminal_basic",
		value_id = "background",
		style = Styles.reward.background,
	}

	passes[#passes + 1] = reward_frame_pass
	passes[#passes + 1] = reward_background_pass

	if reward_type == "currency" then
		local reward_icon_pass = {
			pass_type = "texture",
			style_id = "icon",
			value_id = "icon",
			value = currency_icon,
			style = Styles.reward.currency_icon,
		}
		local amount_text_pass = {
			pass_type = "text",
			style_id = "amount",
			value_id = "amount",
			value = tostring(amount),
			style = Styles.reward.amount,
		}

		passes[#passes + 1] = reward_icon_pass
		passes[#passes + 1] = amount_text_pass
	elseif reward_type == "item" then
		local reward_icon_pass = {
			pass_type = "texture",
			style_id = "icon",
			value = "content/ui/materials/icons/items/containers/item_container_landscape",
			value_id = "icon",
			style = Styles.reward.icon,
		}

		passes[#passes + 1] = reward_icon_pass
	end

	local widget_definition = UIWidget.create_definition(passes, scenegraph_id)

	return widget_definition
end

local event_progress_bar_content_override = {
	progress = 0,
	bar_length = scenegraph_definition.event_progress_bar.size[1],
}
local event_progress_bar = UIWidget.create_definition(BarPassTemplates.experience_bar, "event_progress_bar", event_progress_bar_content_override)
local widget_definitions = {
	entry_base = entry_base,
	event_progress_bar = event_progress_bar,
	progress_text = UIWidget.create_definition({
		{
			pass_type = "text",
			style_id = "progress_text",
			value_id = "progress_text",
			style = Styles.event_progress_bar.progress_text,
		},
	}, "event_progress_bar"),
}

return {
	create_reward_widget = create_reward_widget,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
}
