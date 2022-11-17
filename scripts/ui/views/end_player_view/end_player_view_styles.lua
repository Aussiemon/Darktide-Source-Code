local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ViewSettings = require("scripts/ui/views/end_player_view/end_player_view_settings")
local card_width = 530
local card_folded_height = 65
local card_fully_expanded_height = 515
local card_normal_height = 375
local icon_background_width = 170
local content_margin = 40
local wallet_panel_frame_size = {
	216,
	44
}
local currency_icon_size = {
	52,
	44
}
local start_color = {
	0,
	128,
	128,
	128
}
local dimmed_out_color = {
	255,
	128,
	128,
	128
}
local in_focus_color = {
	255,
	255,
	255,
	255
}
local end_player_view_styles = {
	wallet_spacing = 25,
	card_fully_expanded_offset_y = -95,
	card_content_empty_row_height = 40,
	card_content_text_offset_y = 170,
	card_width = card_width,
	card_folded_height = card_folded_height,
	card_fully_expanded_height = card_fully_expanded_height,
	card_normal_height = card_normal_height,
	card_offset_x = card_width + 70,
	wallet_panel_size = wallet_panel_frame_size,
	item_insignia_size = {
		30,
		80
	},
	item_portrait_frame_size = {
		60,
		70
	},
	progress_bar = {}
}
local progress_bar_style = end_player_view_styles.progress_bar
progress_bar_style.size = {
	1300,
	18
}
progress_bar_style.current_level_text = table.clone(UIFontSettings.header_1)
local current_level_text_style = progress_bar_style.current_level_text
current_level_text_style.text_horizontal_alignment = "right"
progress_bar_style.next_level_text = table.clone(current_level_text_style)
local next_level_text_style = progress_bar_style.next_level_text
next_level_text_style.text_horizontal_alignment = "left"
progress_bar_style.character_progress_text = table.clone(UIFontSettings.body_small)
local character_progress_text_style = progress_bar_style.character_progress_text
character_progress_text_style.text_horizontal_alignment = "right"
end_player_view_styles.experience_gain = {}
local experience_gain_style = end_player_view_styles.experience_gain
experience_gain_style.rect = {}
local experience_gain_rect_style = experience_gain_style.rect
experience_gain_rect_style.size = {
	2,
	35
}
experience_gain_rect_style.vertical_alignment = "bottom"
experience_gain_rect_style.offset = {
	0,
	30,
	0
}
experience_gain_rect_style.internal_offset_x = 0
experience_gain_rect_style.color = Color.ui_terminal(255, true)
experience_gain_style.text = table.clone(UIFontSettings.body_small)
local experience_gain_text_style = experience_gain_style.text
experience_gain_text_style.size = {
	100,
	18
}
experience_gain_text_style.text_horizontal_alignment = "right"
experience_gain_text_style.vertical_alignment = "bottom"
experience_gain_text_style.offset = {
	0,
	28,
	0
}
experience_gain_text_style.internal_offset_x = -8
experience_gain_text_style.text_color = Color.ui_terminal(255, true)
end_player_view_styles.wallet_panel = {}
local wallet_panel_style = end_player_view_styles.wallet_panel
wallet_panel_style.background = {}
local wallet_panel_background_style = wallet_panel_style.background
wallet_panel_background_style.vertical_alignment = "center"
wallet_panel_background_style.horizontal_alignment = "center"
wallet_panel_background_style.size = {
	185,
	35
}
wallet_panel_background_style.color = Color.black(128, true)
wallet_panel_style.frame = {}
local wallet_panel_frame_style = wallet_panel_style.frame
wallet_panel_frame_style.offset = {
	0,
	0,
	1
}
wallet_panel_style.currency_icon = {}
local wallet_panel_currency_icon_style = wallet_panel_style.currency_icon
wallet_panel_currency_icon_style.size = currency_icon_size
wallet_panel_currency_icon_style.vertical_alignment = "center"
wallet_panel_currency_icon_style.offset = {
	25,
	0,
	2
}
wallet_panel_style.text = table.clone(UIFontSettings.body)
local wallet_panel_text_style = wallet_panel_style.text
wallet_panel_text_style.text_horizontal_alignment = "right"
wallet_panel_text_style.text_vertical_alignment = "center"
wallet_panel_text_style.offset = {
	-28,
	0,
	3
}
wallet_panel_text_style.highlighted_color = Color.ui_terminal(255, true)
wallet_panel_text_style.highlighted_size = 26
wallet_panel_text_style.default_size = wallet_panel_text_style.font_size
wallet_panel_text_style.animation_time = 0.3
end_player_view_styles.currency_gain = {}
local currency_gain_style = end_player_view_styles.currency_gain
currency_gain_style.size = {
	end_player_view_styles.wallet_panel_size[1],
	34
}
currency_gain_style.rect = {}
local currency_gain_rect_style = currency_gain_style.rect
currency_gain_rect_style.size = {
	2,
	31
}
currency_gain_rect_style.horizontal_alignment = "right"
currency_gain_rect_style.vertical_alignment = "bottom"
currency_gain_rect_style.offset = {
	-10,
	32,
	0
}
currency_gain_rect_style.color = Color.ui_terminal(255, true)
currency_gain_style.text = table.clone(UIFontSettings.body_small)
local currency_gain_text_style = currency_gain_style.text
currency_gain_text_style.size = {
	nil,
	18
}
currency_gain_text_style.text_horizontal_alignment = "right"
currency_gain_text_style.vertical_alignment = "bottom"
currency_gain_text_style.offset = {
	-28,
	28,
	0
}
currency_gain_text_style.text_color = Color.ui_terminal(255, true)
end_player_view_styles.blueprints = {}
local blueprint_styles = end_player_view_styles.blueprints
blueprint_styles.pass_styles = {}
local blueprint_pass_styles = blueprint_styles.pass_styles
blueprint_pass_styles.item_icon_landscape = {}
local item_icon_landscape_style = blueprint_pass_styles.item_icon_landscape
item_icon_landscape_style.size = {
	400,
	200
}
item_icon_landscape_style.material_values = {
	use_placeholder_texture = 1
}
item_icon_landscape_style.hdr = false
item_icon_landscape_style.horizontal_alignment = "center"
item_icon_landscape_style.offset = {
	0,
	32,
	5
}
item_icon_landscape_style.offset_original = table.clone(item_icon_landscape_style.offset)
item_icon_landscape_style.offset_compressed = {
	0,
	16,
	2
}
item_icon_landscape_style.color = start_color
item_icon_landscape_style.sound_event_on_show = ViewSettings.item_rarity_sounds[1]
blueprint_pass_styles.item_icon_square = table.clone(item_icon_landscape_style)
local item_icon_square_style = blueprint_pass_styles.item_icon_square
item_icon_square_style.size = {
	128,
	128
}
blueprint_styles.card_content = {}
local card_content_styles = blueprint_styles.card_content
card_content_styles.text_normal = table.clone(UIFontSettings.body)
local card_content_normal_text_style = card_content_styles.text_normal
card_content_normal_text_style.offset = {
	content_margin,
	nil,
	2
}
card_content_normal_text_style.size = {
	card_width - content_margin * 2,
	30
}
card_content_normal_text_style.text_color = start_color
card_content_styles.text_small = table.clone(UIFontSettings.body_small)
local card_content_small_text_style = card_content_styles.text_small
card_content_small_text_style.offset = {
	content_margin,
	nil,
	2
}
card_content_small_text_style.size = {
	card_width - content_margin * 2,
	25
}
card_content_small_text_style.text_color = start_color
local level_up_content_label_style = table.clone(UIFontSettings.header_3)
level_up_content_label_style.text_horizontal_alignment = "center"
level_up_content_label_style.offset = {
	0,
	36,
	34
}
level_up_content_label_style.text_color = start_color
local level_up_content_label_divider_style = {
	size = {
		468,
		22
	},
	offset = {
		0,
		76,
		4
	},
	horizontal_alignment = "center",
	color = start_color,
	in_focus_color = Color.terminal_frame(255, true),
	dimmed_out_color = Color.terminal_frame(128, true)
}
local card_frame_style = {
	card_folded_height = card_folded_height,
	card_fully_expanded_height = card_fully_expanded_height,
	start_color = start_color,
	dimmed_out_color = dimmed_out_color,
	in_focus_color = in_focus_color,
	default_frame_dimmed_out_color = dimmed_out_color,
	default_frame_in_focus_color = in_focus_color,
	dimmed_out_text_color = Color.terminal_text_body_dark(255, true),
	dimmed_out_gradiented_text_color = {
		255,
		192,
		192,
		192
	},
	in_focus_text_color = Color.terminal_text_header(255, true),
	expand_sound = UISoundEvents.end_screen_summary_card_expand,
	folded_size = end_player_view_styles.card_folded_size,
	background_rect = {}
}
local card_background_rect_style = card_frame_style.background_rect
card_background_rect_style.offset = {
	15,
	0,
	0
}
card_background_rect_style.size_addition = {
	-(card_background_rect_style.offset[1] * 2),
	-(card_background_rect_style.offset[2] + 20)
}
card_background_rect_style.color = Color.terminal_background(150, true)
card_background_rect_style.vertical_alignment = "top"
card_frame_style.background = table.clone(card_background_rect_style)
local card_background_style = card_frame_style.background
card_background_style.offset = {
	3,
	-12,
	1
}
card_background_style.size_addition = {
	-(card_background_style.offset[1] * 2),
	-(card_background_style.offset[2] + 4)
}
card_background_style.scale_to_material = true
card_background_style.color = Color.terminal_grid_background(nil, true)
card_frame_style.frame_default_top = {}
local card_frame_default_top_style = card_frame_style.frame_default_top
card_frame_default_top_style.size = {
	530,
	200
}
card_frame_default_top_style.offset = {
	0,
	-180,
	3
}
card_frame_style.frame_default_middle = {}
local card_frame_default_middle_style = card_frame_style.frame_default_middle
card_frame_default_middle_style.size = {
	530
}
card_frame_default_middle_style.size_addition = {
	0,
	-20
}
card_frame_default_middle_style.vertical_alignment = "bottom"
card_frame_default_middle_style.offset = {
	0,
	-40,
	2
}
card_frame_style.frame_default_bottom = {}
local card_frame_default_bottom_style = card_frame_style.frame_default_bottom
card_frame_default_bottom_style.size = {
	530,
	53
}
card_frame_default_bottom_style.vertical_alignment = "bottom"
card_frame_default_bottom_style.offset = {
	0,
	0,
	3
}
card_frame_style.label = table.clone(UIFontSettings.header_1)
local card_label_style = card_frame_style.label
card_label_style.font_size = 36
card_label_style.size = {
	476,
	85
}
card_label_style.horizontal_alignment = "center"
card_label_style.offset = {
	0,
	-101,
	4
}
card_label_style.text_color = start_color
card_label_style.text_horizontal_alignment = "center"
card_label_style.color = {
	64,
	255,
	0,
	255
}
local level_up_card_frame_style = table.clone(card_frame_style)
level_up_card_frame_style.expand_sound = UISoundEvents.end_screen_level_up_card_expand
level_up_card_frame_style.frame_levelup_top = table.clone(level_up_card_frame_style.frame_default_top)
local level_up_frame_top_style = level_up_card_frame_style.frame_levelup_top
level_up_frame_top_style.offset[3] = 4
level_up_card_frame_style.frame_levelup_bottom = table.clone(level_up_card_frame_style.frame_default_bottom)
local level_up_frame_bottom_style = level_up_card_frame_style.frame_levelup_bottom
level_up_frame_bottom_style.offset[3] = 4
local level_up_label_style = level_up_card_frame_style.label
level_up_label_style.offset[3] = 5
level_up_card_frame_style.spires = table.clone(level_up_frame_top_style)
local level_up_spires_style = level_up_card_frame_style.spires
level_up_spires_style.offset = {
	0,
	-100,
	2
}
level_up_spires_style.start_offset_y = level_up_spires_style.offset[2]
level_up_spires_style.target_offset_y = card_frame_default_top_style.offset[2]
level_up_card_frame_style.frame_detail = table.clone(level_up_frame_top_style)
local level_up_frame_detail_style = level_up_card_frame_style.frame_detail
level_up_frame_detail_style.offset[3] = 2
level_up_frame_detail_style.start_offset_y = level_up_frame_detail_style.offset[2]
level_up_frame_detail_style.target_offset_y = -200
level_up_card_frame_style.frame_levelup_effect = {}
local level_up_card_frame_effect_style = level_up_card_frame_style.frame_levelup_effect
level_up_card_frame_effect_style.size_addition = {
	110,
	249 - level_up_frame_top_style.offset[2]
}
level_up_card_frame_effect_style.offset = {
	-55,
	-44 + level_up_frame_top_style.offset[2],
	2
}
level_up_card_frame_effect_style.color = start_color
blueprint_styles.experience_card = table.clone(card_frame_style)
local xp_card_style = blueprint_styles.experience_card
xp_card_style.experience_icon_background = {}
local xp_icon_bg_style = xp_card_style.experience_icon_background
xp_icon_bg_style.start_width = 0
xp_icon_bg_style.target_width = icon_background_width
xp_icon_bg_style.size = {
	xp_icon_bg_style.start_width,
	xp_icon_bg_style.start_width
}
xp_icon_bg_style.horizontal_alignment = "center"
xp_icon_bg_style.offset = {
	0,
	0,
	3
}
xp_icon_bg_style.color = start_color
xp_card_style.experience_icon = {}
local xp_icon_style = xp_card_style.experience_icon
xp_icon_style.horizontal_alignment = "center"
xp_icon_style.size = currency_icon_size
xp_icon_style.offset = {
	0,
	(icon_background_width - xp_icon_style.size[2]) / 2,
	4
}
xp_icon_style.color = start_color
blueprint_styles.salary_card = table.clone(card_frame_style)
local salary_card_styles = blueprint_styles.salary_card
salary_card_styles.credits_icon_background = table.clone(xp_icon_bg_style)
salary_card_styles.credits_icon = table.clone(xp_icon_style)
blueprint_styles.level_up_card = table.clone(level_up_card_frame_style)
local level_up_card_style = blueprint_styles.level_up_card
level_up_card_style.level_up_label = table.clone(level_up_label_style)
level_up_card_style.item_icon_base_offset_y = 72
level_up_card_style.item_display_name = table.clone(UIFontSettings.grid_title)
local level_up_item_name_style = level_up_card_style.item_display_name
level_up_item_name_style.text_horizontal_alignment = "center"
level_up_item_name_style.text_vertical_alignment = "bottom"
level_up_item_name_style.offset = {
	content_margin,
	8,
	4
}
level_up_item_name_style.size = {
	card_width - content_margin * 2,
	60
}
level_up_item_name_style.text_color = start_color
level_up_card_style.item_sub_display_name = table.clone(UIFontSettings.body)
local level_up_item_sub_name_style = level_up_card_style.item_sub_display_name
level_up_item_sub_name_style.text_horizontal_alignment = "center"
level_up_item_sub_name_style.offset = {
	content_margin,
	192 + level_up_card_style.item_icon_base_offset_y,
	4
}
level_up_item_sub_name_style.offset_original = table.clone(level_up_item_sub_name_style.offset)
level_up_item_sub_name_style.offset_compressed = {
	content_margin,
	level_up_item_sub_name_style.offset[2] - 96,
	2
}
level_up_item_sub_name_style.size = {
	card_width - content_margin * 2,
	60
}
level_up_item_sub_name_style.text_color = start_color
level_up_card_style.item_icon = {}
local level_up_item_icon_style = level_up_card_style.item_icon
level_up_item_icon_style.size = {
	nil,
	128
}
level_up_item_icon_style.material_values = {
	use_placeholder_texture = 1
}
level_up_item_icon_style.hdr = false
level_up_item_icon_style.horizontal_alignment = "center"
level_up_item_icon_style.offset = {
	0,
	32,
	5
}
level_up_item_icon_style.offset_original = table.clone(item_icon_landscape_style.offset)
level_up_item_icon_style.offset_compressed = {
	0,
	16,
	4
}
level_up_item_icon_style.color = start_color
level_up_item_icon_style.sound_event_on_show = ViewSettings.item_rarity_sounds[1]
blueprint_styles.weapon_unlock = table.clone(level_up_card_frame_style)
local weapon_unlock_card_style = blueprint_styles.weapon_unlock
weapon_unlock_card_style.level_up_label = table.clone(level_up_content_label_style)
weapon_unlock_card_style.level_up_label_divider = table.clone(level_up_content_label_divider_style)
weapon_unlock_card_style.item_icon = {}
local weapon_unlock_item_icon_style = weapon_unlock_card_style.item_icon
weapon_unlock_item_icon_style.size = {
	400,
	180
}
weapon_unlock_item_icon_style.material_values = {
	use_placeholder_texture = 1
}
weapon_unlock_item_icon_style.hdr = false
weapon_unlock_item_icon_style.horizontal_alignment = "center"
weapon_unlock_item_icon_style.offset = {
	0,
	120,
	5
}
weapon_unlock_item_icon_style.offset_original = table.clone(weapon_unlock_item_icon_style.offset)
weapon_unlock_item_icon_style.offset_compressed = {
	0,
	110,
	5
}
weapon_unlock_item_icon_style.color = start_color
weapon_unlock_item_icon_style.sound_event_on_show = ViewSettings.item_rarity_sounds[1]
weapon_unlock_item_icon_style.can_compress = true
weapon_unlock_card_style.item_icon_background = {}
local weapon_unlock_item_background_style = weapon_unlock_card_style.item_icon_background
weapon_unlock_item_background_style.size = {
	418,
	180
}
weapon_unlock_item_background_style.offset = {
	0,
	120,
	3
}
weapon_unlock_item_background_style.offset_original = table.clone(weapon_unlock_item_background_style.offset)
weapon_unlock_item_background_style.offset_compressed = {
	0,
	110,
	3
}
weapon_unlock_item_background_style.horizontal_alignment = "center"
weapon_unlock_item_background_style.color = Color.terminal_background_dark(0, true)
weapon_unlock_item_background_style.start_color = table.clone(weapon_unlock_item_background_style.color)
weapon_unlock_item_background_style.in_focus_color = Color.terminal_background_dark(128, true)
weapon_unlock_item_background_style.dimmed_out_color = Color.terminal_background_dark(150, true)
weapon_unlock_item_background_style.can_compress = true
weapon_unlock_card_style.item_icon_frame = {}
local weapon_unlock_item_frame_style = weapon_unlock_card_style.item_icon_frame
weapon_unlock_item_frame_style.size = {
	428,
	180
}
weapon_unlock_item_frame_style.offset = {
	0,
	120,
	4
}
weapon_unlock_item_frame_style.offset_original = table.clone(weapon_unlock_item_frame_style.offset)
weapon_unlock_item_frame_style.offset_compressed = {
	0,
	110,
	4
}
weapon_unlock_item_frame_style.horizontal_alignment = "center"
weapon_unlock_item_frame_style.color = start_color
weapon_unlock_item_frame_style.in_focus_color = Color.terminal_frame(255, true)
weapon_unlock_item_frame_style.dimmed_out_color = Color.terminal_frame(128, true)
weapon_unlock_item_frame_style.can_compress = true
weapon_unlock_card_style.item_display_name = table.clone(UIFontSettings.header_3)
local weapon_unlock_item_name_style = weapon_unlock_card_style.item_display_name
weapon_unlock_item_name_style.text_horizontal_alignment = "center"
weapon_unlock_item_name_style.text_vertical_alignment = "center"
weapon_unlock_item_name_style.offset = {
	content_margin,
	340,
	5
}
weapon_unlock_item_name_style.offset_original = table.clone(weapon_unlock_item_name_style.offset)
weapon_unlock_item_name_style.offset_compressed = {
	content_margin,
	220,
	5
}
weapon_unlock_item_name_style.size = {
	card_width - content_margin * 2,
	60
}
weapon_unlock_item_name_style.text_color = start_color
weapon_unlock_item_name_style.color = {
	64,
	255,
	0,
	255
}
weapon_unlock_card_style.weapon_unlocked_text = table.clone(UIFontSettings.body_small)
local weapon_unlock_unlocked_text_style = weapon_unlock_card_style.weapon_unlocked_text
weapon_unlock_unlocked_text_style.size = {
	420,
	50
}
weapon_unlock_unlocked_text_style.offset = {
	0,
	-35,
	4
}
weapon_unlock_unlocked_text_style.text_color = start_color
weapon_unlock_unlocked_text_style.horizontal_alignment = "center"
weapon_unlock_unlocked_text_style.vertical_alignment = "bottom"
weapon_unlock_unlocked_text_style.text_horizontal_alignment = "center"
weapon_unlock_unlocked_text_style.text_vertical_alignment = "center"
blueprint_styles.talents_unlocked = table.clone(level_up_card_frame_style)
local talents_unlocked_card_style = blueprint_styles.talents_unlocked
talents_unlocked_card_style.level_up_label = table.clone(level_up_content_label_style)
local talents_unlocked_label = talents_unlocked_card_style.level_up_label
talents_unlocked_label.sound_event_on_show = UISoundEvents.end_screen_summary_talents_unlocked
talents_unlocked_card_style.level_up_label_divider = table.clone(level_up_content_label_divider_style)
talents_unlocked_card_style.talent_icon_background_1 = {}
local talent_icon_background_1_style = talents_unlocked_card_style.talent_icon_background_1
talent_icon_background_1_style.size = {
	104,
	80
}
talent_icon_background_1_style.offset = {
	0,
	130,
	5
}
talent_icon_background_1_style.horizontal_alignment = "center"
talent_icon_background_1_style.offset_original = table.clone(talent_icon_background_1_style.offset)
talent_icon_background_1_style.offset_compressed = {
	0,
	122,
	5
}
talent_icon_background_1_style.color = start_color
talent_icon_background_1_style.in_focus_color = Color.terminal_frame(255, true)
talent_icon_background_1_style.dimmed_out_color = Color.terminal_frame(128, true)
talent_icon_background_1_style.can_compress = true
talents_unlocked_card_style.talent_icon_background_2 = table.clone(talent_icon_background_1_style)
local talent_icon_background_2_style = talents_unlocked_card_style.talent_icon_background_2
talent_icon_background_2_style.offset[2] = 225
talent_icon_background_2_style.offset_original[2] = talent_icon_background_2_style.offset[2]
talent_icon_background_2_style.offset_compressed[2] = 177
talents_unlocked_card_style.talent_icon_background_3 = table.clone(talent_icon_background_1_style)
local talent_icon_background_3_style = talents_unlocked_card_style.talent_icon_background_3
talent_icon_background_3_style.offset[2] = 320
talent_icon_background_3_style.offset_original[2] = talent_icon_background_3_style.offset[2]
talent_icon_background_3_style.offset_compressed[2] = 232
talents_unlocked_card_style.talent_icon_1 = {}
local talent_icon_1_style = talents_unlocked_card_style.talent_icon_1
talent_icon_1_style.size = {
	110,
	110
}
talent_icon_1_style.horizontal_alignment = "center"
talent_icon_1_style.offset = {
	0,
	115,
	4
}
talent_icon_1_style.offset_original = table.clone(talent_icon_1_style.offset)
talent_icon_1_style.offset_compressed = {
	0,
	115,
	4
}
talent_icon_1_style.color = start_color
talent_icon_1_style.material_values = {}
talent_icon_1_style.can_compress = true
talents_unlocked_card_style.talent_icon_2 = table.clone(talent_icon_1_style)
local talent_icon_2_style = talents_unlocked_card_style.talent_icon_2
talent_icon_2_style.offset[2] = 210
talent_icon_2_style.offset_original[2] = talent_icon_2_style.offset[2]
talent_icon_2_style.offset_compressed[2] = 170
talents_unlocked_card_style.talent_icon_3 = table.clone(talent_icon_1_style)
local talent_icon_3_style = talents_unlocked_card_style.talent_icon_3
talent_icon_3_style.offset[2] = 305
talent_icon_3_style.offset_original[2] = talent_icon_3_style.offset[2]
talent_icon_3_style.offset_compressed[2] = 225
talents_unlocked_card_style.talents_unlocked_text = table.clone(UIFontSettings.body_small)
local talents_card_unlocked_text_style = talents_unlocked_card_style.talents_unlocked_text
talents_card_unlocked_text_style.size = {
	420,
	50
}
talents_card_unlocked_text_style.offset = {
	0,
	-35,
	4
}
talents_card_unlocked_text_style.text_color = start_color
talents_card_unlocked_text_style.horizontal_alignment = "center"
talents_card_unlocked_text_style.vertical_alignment = "bottom"
talents_card_unlocked_text_style.text_horizontal_alignment = "center"
talents_card_unlocked_text_style.text_vertical_alignment = "center"
local item_reward_card_width = 500
local item_reward_content_margin = 86
blueprint_styles.item_reward_card = table.clone(card_frame_style)
local item_reward_card_style = blueprint_styles.item_reward_card
item_reward_card_style.size = {
	item_reward_card_width,
	300
}
item_reward_card_style.card_folded_height = item_reward_card_style.size[2]
item_reward_card_style.expand_sound = UISoundEvents.end_screen_item_drop_card_expand
item_reward_card_style.frame_default_top = nil
item_reward_card_style.frame_default_middle = nil
item_reward_card_style.frame_default_bottom = nil
item_reward_card_style.frame_top = {}
local item_reward_card_frame_top_style = item_reward_card_style.frame_top
item_reward_card_frame_top_style.size = {
	item_reward_card_width,
	356
}
item_reward_card_frame_top_style.offset = {
	0,
	-230,
	5
}
item_reward_card_style.frame_middle = {}
local item_reward_card_frame_middle_style = item_reward_card_style.frame_middle
item_reward_card_frame_middle_style.size = {
	item_reward_card_width
}
item_reward_card_frame_middle_style.size_addition = {
	0,
	-170
}
item_reward_card_frame_middle_style.vertical_alignment = "bottom"
item_reward_card_frame_middle_style.offset = {
	0,
	-178,
	3
}
item_reward_card_style.frame_bottom = {}
local item_reward_card_bottom_style = item_reward_card_style.frame_bottom
item_reward_card_bottom_style.size = {
	item_reward_card_width,
	178
}
item_reward_card_bottom_style.vertical_alignment = "bottom"
item_reward_card_bottom_style.offset = {
	0,
	0,
	2
}
local item_reward_card_background_style = item_reward_card_style.background
item_reward_card_background_style.offset = {
	50,
	0,
	0
}
item_reward_card_background_style.size_addition = {
	-(item_reward_card_background_style.offset[1] * 2),
	-(item_reward_card_background_style.offset[2] + 32)
}
item_reward_card_background_style.color = Color.black(192, true)
item_reward_card_style.rarity_background = table.clone(item_reward_card_background_style)
local item_reward_card_rarity_bg_style = item_reward_card_style.rarity_background
item_reward_card_rarity_bg_style.offset = {
	50,
	50,
	1
}
item_reward_card_rarity_bg_style.size_addition = {
	-(item_reward_card_rarity_bg_style.offset[1] * 2),
	-(item_reward_card_rarity_bg_style.offset[2] + 32)
}
item_reward_card_rarity_bg_style.color = {
	192,
	100,
	100,
	100
}
local item_reward_card_label_style = item_reward_card_style.label
item_reward_card_label_style.size = {
	354,
	78
}
item_reward_card_label_style.offset = {
	0,
	-75,
	7
}
item_reward_card_style.item_display_name = table.clone(UIFontSettings.header_3)
local item_reward_item_name_style = item_reward_card_style.item_display_name
item_reward_item_name_style.offset = {
	item_reward_content_margin,
	60,
	3
}
item_reward_item_name_style.size = {
	item_reward_card_width - item_reward_content_margin * 2,
	60
}
item_reward_item_name_style.text_horizontal_alignment = "center"
item_reward_item_name_style.text_vertical_alignment = "center"
item_reward_item_name_style.text_color = start_color
item_reward_item_name_style.color = {
	64,
	255,
	0,
	255
}
item_reward_card_style.item_sub_display_name = table.clone(UIFontSettings.body_small)
local item_reward_item_sub_name_style = item_reward_card_style.item_sub_display_name
item_reward_item_sub_name_style.offset = {
	item_reward_content_margin,
	0,
	4
}
item_reward_item_sub_name_style.offset_original = table.clone(item_reward_item_sub_name_style.offset)
item_reward_item_sub_name_style.offset_compressed = {
	item_reward_content_margin,
	-10,
	4
}
item_reward_item_sub_name_style.size = {
	item_reward_card_width - item_reward_content_margin * 2,
	60
}
item_reward_item_sub_name_style.text_horizontal_alignment = "center"
item_reward_item_sub_name_style.text_color = start_color
item_reward_item_sub_name_style.drop_shadow = true
item_reward_item_sub_name_style.color = {
	64,
	255,
	0,
	255
}
item_reward_card_style.item_icon = {}
local item_reward_item_icon_style = item_reward_card_style.item_icon
item_reward_item_icon_style.size = {
	nil,
	200
}
item_reward_item_icon_style.offset = {
	0,
	100,
	3
}
item_reward_item_icon_style.offset_original = table.clone(item_reward_item_icon_style.offset)
item_reward_item_icon_style.offset_compressed = {
	0,
	110,
	3
}
item_reward_item_icon_style.horizontal_alignment = "center"
item_reward_item_icon_style.color = start_color
item_reward_item_icon_style.material_values = {
	use_placeholder_texture = 1
}
item_reward_item_icon_style.sound_event_on_show = ViewSettings.item_rarity_sounds[1]
item_reward_item_icon_style.can_compress = true
item_reward_card_style.item_level = table.clone(UIFontSettings.header_3)
local item_reward_card_item_level_style = item_reward_card_style.item_level
item_reward_card_item_level_style.size = {
	item_reward_card_width - item_reward_content_margin * 2,
	30
}
item_reward_card_item_level_style.offset = {
	item_reward_content_margin,
	45,
	4
}
item_reward_card_item_level_style.offset_original = table.clone(item_reward_card_item_level_style.offset)
item_reward_card_item_level_style.offset_compressed = {
	item_reward_content_margin,
	20,
	4
}
item_reward_card_item_level_style.text_horizontal_alignment = "center"
item_reward_card_item_level_style.text_color = start_color
item_reward_card_item_level_style.in_focus_text_color = Color.text_default(255, true)
item_reward_card_item_level_style.dimmed_out_text_color = Color.ui_grey_medium(255, true)
item_reward_card_style.added_to_inventory_text = table.clone(UIFontSettings.body_small)
local item_reward_card_added_text_style = item_reward_card_style.added_to_inventory_text
item_reward_card_added_text_style.size = {
	240,
	30
}
item_reward_card_added_text_style.offset = {
	0,
	95,
	4
}
item_reward_card_added_text_style.offset_original = table.clone(item_reward_card_added_text_style.offset)
item_reward_card_added_text_style.offset_compressed = {
	0,
	65,
	4
}
item_reward_card_added_text_style.text_horizontal_alignment = "center"
item_reward_card_added_text_style.horizontal_alignment = "center"
item_reward_card_added_text_style.text_color = start_color
item_reward_card_added_text_style.in_focus_text_color = Color.text_default(255, true)
item_reward_card_added_text_style.dimmed_out_text_color = Color.ui_grey_medium(255, true)
blueprint_styles.empty_test_card = table.clone(card_frame_style)

return settings("EndPlayerViewStyles", end_player_view_styles)
