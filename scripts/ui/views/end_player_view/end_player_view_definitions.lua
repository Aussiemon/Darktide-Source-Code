local BarPassTemplates = require("scripts/ui/pass_templates/bar_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewAnimations = require("scripts/ui/views/end_player_view/end_player_view_animations")
local ViewBlueprints = require("scripts/ui/views/end_player_view/end_player_view_blueprints")
local ViewStyles = require("scripts/ui/views/end_player_view/end_player_view_styles")
local WalletSettings = require("scripts/settings/wallet_settings")
local card_folded_size = {
	ViewStyles.card_width,
	ViewStyles.card_folded_height
}
local wallet_panel_size = ViewStyles.wallet_panel_size
local wallet_spacing = ViewStyles.wallet_spacing
local wallet_bar_size = {
	wallet_panel_size[1] * 4 + wallet_spacing * 3,
	wallet_panel_size[2]
}
local progress_bar_content_extra = {
	progress = 0,
	bar_length = ViewStyles.progress_bar.size[1]
}
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	card_carousel = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = card_folded_size,
		position = {
			0,
			367,
			0
		}
	},
	progress_bar = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = ViewStyles.progress_bar.size,
		position = {
			0,
			-235,
			3
		}
	},
	current_level_text = {
		vertical_alignment = "center",
		parent = "progress_bar",
		horizontal_alignment = "left",
		size = {
			100,
			40
		},
		position = {
			-150,
			0,
			6
		}
	},
	next_level_text = {
		vertical_alignment = "center",
		parent = "progress_bar",
		horizontal_alignment = "right",
		size = {
			100,
			40
		},
		position = {
			150,
			0,
			6
		}
	},
	character_progress_text = {
		vertical_alignment = "top",
		parent = "progress_bar",
		horizontal_alignment = "right",
		size = {
			400,
			25
		},
		position = {
			0,
			-40,
			6
		}
	},
	wallet_bar = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = wallet_bar_size,
		position = {
			0,
			-155,
			2
		}
	},
	wallet_panel_credits = {
		vertical_alignment = "top",
		parent = "wallet_bar",
		horizontal_alignment = "left",
		size = wallet_panel_size,
		position = {
			wallet_panel_size[1] + wallet_spacing,
			0,
			0
		}
	},
	wallet_panel_marks = {
		vertical_alignment = "top",
		parent = "wallet_bar",
		horizontal_alignment = "right",
		size = wallet_panel_size,
		position = {
			-wallet_panel_size[1] - wallet_spacing,
			0,
			0
		}
	}
}
local widget_definitions = {
	progress_bar = UIWidget.create_definition(BarPassTemplates.experience_bar, "progress_bar", progress_bar_content_extra),
	current_level_text = UIWidget.create_definition({
		{
			value = "00",
			value_id = "text",
			pass_type = "text",
			style = ViewStyles.progress_bar.current_level_text
		}
	}, "current_level_text"),
	next_level_text = UIWidget.create_definition({
		{
			value = "00",
			value_id = "text",
			pass_type = "text",
			style = ViewStyles.progress_bar.next_level_text
		}
	}, "next_level_text"),
	character_progress_text = UIWidget.create_definition({
		{
			value = "",
			value_id = "text",
			pass_type = "text",
			style = ViewStyles.progress_bar.character_progress_text
		}
	}, "character_progress_text"),
	credits_wallet = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "background"
		},
		{
			value = "content/ui/materials/frames/end_of_round/currency_holder",
			style_id = "frame",
			pass_type = "texture"
		},
		{
			style_id = "currency_icon",
			pass_type = "texture",
			value = WalletSettings.credits.icon_texture_big
		},
		{
			style_id = "text",
			pass_type = "text",
			value_id = "text",
			value = "0",
			change_function = ViewAnimations.wallet_change_function
		}
	}, "wallet_panel_credits", nil, nil, ViewStyles.wallet_panel),
	marks_wallet = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "background"
		},
		{
			value = "content/ui/materials/frames/end_of_round/currency_holder",
			style_id = "frame",
			pass_type = "texture"
		},
		{
			style_id = "currency_icon",
			pass_type = "texture",
			value = WalletSettings.marks.icon_texture_big
		},
		{
			value = "0",
			value_id = "text",
			pass_type = "text",
			style_id = "text"
		}
	}, "wallet_panel_marks", nil, nil, ViewStyles.wallet_panel),
	experience_gain = UIWidget.create_definition({
		{
			style_id = "rect",
			pass_type = "rect",
			change_function = ViewAnimations.experience_gain_change_function
		},
		{
			style_id = "text",
			pass_type = "text",
			value_id = "text",
			value = "",
			change_function = ViewAnimations.experience_gain_change_function
		}
	}, "progress_bar", progress_bar_content_extra, ViewStyles.experience_gain.size, ViewStyles.experience_gain),
	credits_gain = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "rect"
		},
		{
			value = "+0",
			value_id = "text",
			pass_type = "text",
			style_id = "text"
		}
	}, "wallet_panel_credits", nil, ViewStyles.currency_gain.size, ViewStyles.currency_gain)
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	blueprints = ViewBlueprints,
	animations = ViewAnimations
}
