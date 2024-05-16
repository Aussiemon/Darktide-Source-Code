-- chunkname: @scripts/ui/views/account_profile_overview_view/account_profile_overview_view_styles.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ColorUtilities = require("scripts/utilities/ui/colors")
local account_profile_overview_styles = {}

account_profile_overview_styles.progress_bar_size = {
	1385,
	48,
}
account_profile_overview_styles.reward_icon_outer_size = 138
account_profile_overview_styles.reward_icon_inner_size = 128
account_profile_overview_styles.column_width = 450
account_profile_overview_styles.column_height = 536
account_profile_overview_styles.grid_mask_expansion = 24
account_profile_overview_styles.background = {
	offset = {
		0,
		0,
		-50,
	},
}
account_profile_overview_styles.header_background = {
	color = Color.black(64, true),
}

local player_name = {
	drop_shadow = false,
	font_size = 58,
	font_type = "proxima_nova_bold",
	text_vertical_alignment = "top",
	text_color = Color.ui_brown_light(255, true),
}

account_profile_overview_styles.player_name = player_name

local account_rank = {}
local account_rank_text = table.clone(UIFontSettings.header_3)

account_rank_text.text_color = Color.ui_grey_medium(255, true)
account_rank_text.drop_shadow = false
account_rank.account_rank = account_rank_text
account_rank.progress_bar_background = {
	offset = {
		0,
		0,
		0,
	},
}
account_rank.progress_bar_frame = {
	offset = {
		0,
		0,
		3,
	},
}
account_rank.progress_bar = {
	offset = {
		22,
		15,
		1,
	},
	size = {
		100,
		18,
	},
	color = Color.ui_terminal(255, true),
}
account_profile_overview_styles.account_rank = account_rank
account_profile_overview_styles.progression_reward = {}

local progression_reward = account_profile_overview_styles.progression_reward
local icon_inner_size = account_profile_overview_styles.reward_icon_inner_size
local icon_inner_offset = (account_profile_overview_styles.reward_icon_outer_size - icon_inner_size) / 2

progression_reward.icon_background = {
	offset = {
		icon_inner_offset,
		icon_inner_offset,
		1,
	},
	size = {
		icon_inner_size,
		icon_inner_size,
	},
}
progression_reward.rarity = {
	offset = {
		0,
		0,
		3,
	},
}
progression_reward.variant = {
	offset = {
		0,
		0,
		5,
	},
}
progression_reward.icon = {
	offset = {
		icon_inner_offset,
		icon_inner_offset,
		4,
	},
	size = {
		icon_inner_size,
		icon_inner_size,
	},
	color = Color.ui_terminal(255, true),
}
progression_reward.label = table.clone(UIFontSettings.header_3)

local progression_reward_label = progression_reward.label

progression_reward_label.text_horizontal_alignment = "center"

local column_style = {}

column_style.headline = table.clone(UIFontSettings.header_3)
column_style.headline.offset = {
	6,
	0,
	3,
}
column_style.headline_divider = {
	offset = {
		6,
		28,
		10,
	},
	size = {
		account_profile_overview_styles.column_width + 20,
		18,
	},
	color = Color.ui_brown_super_light(255, true),
}
column_style.num_contracts_tasks = table.clone(column_style.headline)
column_style.num_contracts_tasks.text_horizontal_alignment = "right"
column_style.num_contracts_tasks.offset = {
	-3,
	3,
	3,
}
account_profile_overview_styles.column_style = column_style

local list_item_margin = 4
local list_item_width = account_profile_overview_styles.column_width - 2 * list_item_margin
local list_item_height = 70
local list_item_style = {}

list_item_style.size = {
	list_item_width,
	list_item_height,
}

local highlight_width = list_item_width + 2 * list_item_margin
local highlight_height = list_item_height + 2 * list_item_margin
local list_item_label_style = table.clone(UIFontSettings.body)

list_item_label_style.default_color = table.clone(list_item_label_style.text_color)
list_item_label_style.hover_color = Color.ui_brown_super_light(255, true)
list_item_label_style.offset = {
	2 * list_item_margin,
	list_item_margin,
	2,
}
list_item_label_style.text_horizontal_alignment = "left"
list_item_label_style.text_vertical_alignment = "center"
list_item_style.label = list_item_label_style

local list_item_value_style = table.clone(UIFontSettings.body)

list_item_value_style.default_color = table.clone(list_item_label_style.text_color)
list_item_value_style.hover_color = Color.ui_brown_super_light(255, true)
list_item_value_style.text_horizontal_alignment = "right"
list_item_value_style.text_vertical_alignment = "center"
list_item_value_style.offset = {
	-2 * list_item_margin,
	list_item_margin,
	2,
}
list_item_style.value = list_item_value_style
list_item_style.highlight = {
	color = Color.ui_terminal(255, true),
	offset = {
		0,
		0,
		5,
	},
	size = {
		highlight_width,
		highlight_height,
	},
	size_addition = {
		0,
		0,
	},
}
account_profile_overview_styles.list_item = list_item_style

local list_item_with_icon_style = table.clone(list_item_style)

list_item_with_icon_style.icon_background = {
	color = Color.ui_grey_medium(255, true),
	offset = {
		list_item_margin,
		list_item_margin,
		1,
	},
	size = {
		list_item_height,
		list_item_height,
	},
}

local list_item_icon = table.clone(list_item_with_icon_style.icon_background)

list_item_icon.offset[3] = 2
list_item_icon.color = nil
list_item_with_icon_style.icon = list_item_icon
list_item_with_icon_style.label.offset = {
	list_item_height + 16,
	nil,
	2,
}
account_profile_overview_styles.list_item_with_icon = list_item_with_icon_style

return settings("AccountProfileOverviewStyles", account_profile_overview_styles)
