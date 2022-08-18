local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local DefaultPassStyles = require("scripts/ui/default_pass_styles")
local ItemPassTemplates = require("scripts/ui/pass_templates/item_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local completed_color = Color.ui_brown_light(255, true)
local completed_material = "content/ui/materials/font_gradients/slug_font_gradient_header"
local left_column_width = 540
local main_column_width = 920
local visible_area_width = 1560
local visible_area_height = 770
local achievements_grid_margin = 30
local achievement_width = main_column_width - 2 * achievements_grid_margin
local reward_item_size = ItemPassTemplates.item_size
local reward_item_horizontal_margin = math.floor((achievement_width - reward_item_size[1]) / 2)
local num_completed_to_show = 3
local num_near_completed_to_show = 3
local achievements_view_styles = {
	visible_area_size = {
		visible_area_width,
		visible_area_height
	},
	left_column_size = {
		left_column_width,
		visible_area_height
	},
	main_column_size = {
		main_column_width,
		visible_area_height
	},
	reward_item_margins = {
		reward_item_horizontal_margin,
		15
	}
}
local progress_bar_size = {
	440,
	22
}
achievements_view_styles.completed = {}
local completed_styles = achievements_view_styles.completed
completed_styles.size = progress_bar_size
completed_styles.progressbar = {}
local completed_progressbar_styles = completed_styles.progressbar
completed_progressbar_styles.size = {
	430,
	12
}
completed_progressbar_styles.default_size = table.clone(completed_progressbar_styles.size)
completed_progressbar_styles.offset = {
	5,
	5,
	1
}
completed_styles.progressbar_edge = {}
local completed_progressbar_edge_style = completed_styles.progressbar_edge
completed_progressbar_edge_style.size = {
	12,
	24
}
completed_progressbar_edge_style.offset = {
	-1,
	-1,
	1
}
completed_progressbar_edge_style.default_offset = table.clone(completed_progressbar_edge_style.offset)
completed_styles.completed = table.clone(UIFontSettings.body)
local completed_text_style = completed_styles.completed
completed_text_style.offset = {
	0,
	-30,
	1
}
completed_styles.total_score = table.clone(completed_text_style)
local completed_score_style = completed_styles.total_score
completed_score_style.text_horizontal_alignment = "right"
local categories_grid_margin = 30
local category_width = left_column_width - 2 * categories_grid_margin
achievements_view_styles.categories_grid = {}
local categories_grid_style = achievements_view_styles.categories_grid
categories_grid_style.position = {
	0,
	0,
	0
}
categories_grid_style.size = {
	category_width,
	565
}
categories_grid_style.margin = categories_grid_margin
achievements_view_styles.achievements_grid = {}
local achievements_grid_style = achievements_view_styles.achievements_grid
achievements_grid_style.size = {
	achievement_width,
	770
}
achievements_grid_style.margin = achievements_grid_margin
achievements_view_styles.achievement_summary = {}
local achievement_summary_style = achievements_view_styles.achievement_summary
achievement_summary_style.num_completed_to_show = num_completed_to_show
achievement_summary_style.num_near_completed_to_show = num_near_completed_to_show
achievements_view_styles.blueprints = {}
local blueprint_styles = achievements_view_styles.blueprints
blueprint_styles.pass_template = {}
local pass_template_styles = blueprint_styles.pass_template
pass_template_styles.highlight = {}
local pass_template_highlight_styles = pass_template_styles.highlight
pass_template_highlight_styles.color = Color.ui_terminal(255, true)
pass_template_highlight_styles.offset = {
	0,
	-10,
	3
}
pass_template_highlight_styles.default_offset = table.clone(pass_template_highlight_styles.offset)
pass_template_highlight_styles.size_addition = {
	0,
	0
}
pass_template_highlight_styles.min_size_addition = {
	30,
	15
}
pass_template_highlight_styles.max_size_addition = {
	50,
	40
}
pass_template_styles.icon_background = {}
pass_template_icon_background_style = pass_template_styles.icon_background
pass_template_icon_background_style.size = {
	70,
	70
}
pass_template_styles.icon = {}
pass_template_icon_style = pass_template_styles.icon
pass_template_icon_style.size = {
	70,
	70
}
pass_template_icon_style.offset = {
	0,
	0,
	1
}
pass_template_icon_style.color = {
	255,
	83,
	46,
	46
}
pass_template_styles.label = table.clone(UIFontSettings.header_3)
local pass_template_label_style = pass_template_styles.label
pass_template_label_style.offset = {
	85,
	0,
	1
}
pass_template_label_style.material = "content/ui/materials/font_gradients/slug_font_gradient_header_toggled"
pass_template_label_style.text_color = Color.white(255, true)
pass_template_label_style.size = {
	570,
	25
}
pass_template_styles.description = table.clone(UIFontSettings.body_small)
local pass_template_description_style = pass_template_styles.description
pass_template_description_style.offset = {
	85,
	30,
	1
}
pass_template_description_style.size = {
	570,
	22
}
pass_template_styles.score = table.clone(UIFontSettings.body)
local pass_template_score_style = pass_template_styles.score
pass_template_score_style.text_horizontal_alignment = "right"
pass_template_score_style.offset = {
	0,
	0,
	1
}
pass_template_styles.reward = {}
local pass_template_reward_style = pass_template_styles.reward
pass_template_reward_style.material_values = {}
pass_template_reward_style.size = {
	64,
	64
}
pass_template_reward_style.horizontal_alignment = "right"
pass_template_reward_style.offset = {
	-80,
	1,
	1
}
pass_template_styles.progressbar_background = {}
local pass_template_progressbar_background_style = pass_template_styles.progressbar_background
pass_template_progressbar_background_style.offset = {
	85,
	60,
	0
}
pass_template_progressbar_background_style.size = {
	475,
	10
}
pass_template_styles.progressbar = {}
local pass_template_progressbar_style = pass_template_styles.progressbar
pass_template_progressbar_style.offset = {
	pass_template_progressbar_background_style.offset[1] + 3,
	pass_template_progressbar_background_style.offset[2] + 3,
	2
}
pass_template_progressbar_style.size = {
	pass_template_progressbar_background_style.size[1] - 6,
	4
}
pass_template_styles.progressbar_edge = {}
local pass_template_progressbar_edge_style = pass_template_styles.progressbar_edge
pass_template_progressbar_edge_style.size = {
	12,
	16
}
pass_template_progressbar_edge_style.offset = {
	pass_template_progressbar_background_style.offset[1] - 3,
	pass_template_progressbar_background_style.offset[2] - 3,
	3
}
pass_template_styles.progress = table.clone(UIFontSettings.body_small)
pass_template_progress_style = pass_template_styles.progress
pass_template_progress_style.offset = {
	10 + pass_template_progressbar_background_style.offset[1] + pass_template_progressbar_background_style.size[1],
	pass_template_progressbar_background_style.offset[2] - 7,
	1
}
pass_template_styles.foldout_arrow = {}
local foldout_arrow_style = pass_template_styles.foldout_arrow
foldout_arrow_style.offset = {
	0,
	30,
	2
}
foldout_arrow_style.font_type = "proxima_nova_bold"
foldout_arrow_style.font_size = 24
foldout_arrow_style.horizontal_alignment = "right"
foldout_arrow_style.text_horizontal_alignment = "center"
foldout_arrow_style.text_vertical_alignment = "center"
foldout_arrow_style.material = completed_material
foldout_arrow_style.text_color = Color.white(255, true)
foldout_arrow_style.size = {
	45,
	45
}
pass_template_styles.item_icon = {}
local item_icon_style = pass_template_styles.item_icon
item_icon_style.vertical_alignment = "top"
item_icon_style.offset = {
	reward_item_horizontal_margin,
	0,
	2
}
item_icon_style.material_values = {
	use_placeholder_texture = 1
}
pass_template_styles.item_rarity_side_texture = {}
local pass_template_item_rarity_side_texture_style = pass_template_styles.item_rarity_side_texture
pass_template_item_rarity_side_texture_style.size = {
	reward_item_size[1] - ItemPassTemplates.icon_size[1],
	reward_item_size[2]
}
pass_template_item_rarity_side_texture_style.vertical_alignment = "top"
pass_template_item_rarity_side_texture_style.offset = {
	-reward_item_horizontal_margin,
	5,
	2
}
pass_template_styles.item_item_empty = {}
local item_item_empty_style = pass_template_styles.item_item_empty
item_item_empty_style.size = reward_item_size
pass_template_styles.item_display_name = {}
local item_display_name_text_style = pass_template_styles.item_display_name
item_display_name_text_style.offset = {
	-20 - reward_item_horizontal_margin,
	20,
	5
}
item_display_name_text_style.size = {
	pass_template_item_rarity_side_texture_style.size[1] - 40,
	50
}
pass_template_styles.item_sub_display_name = {}
local item_sub_display_name_text_style = pass_template_styles.item_sub_display_name
item_sub_display_name_text_style.offset = {
	-20 - reward_item_horizontal_margin,
	70,
	5
}
item_sub_display_name_text_style.size = table.clone(item_display_name_text_style.size)
pass_template_styles.item_hotspot = {}
local item_hotspot_style = pass_template_styles.item_hotspot
item_hotspot_style.visible = false
pass_template_styles.item_hover = {}
local item_hover_style = pass_template_styles.item_hover
item_hover_style.visible = false
pass_template_styles.item_item_highlight = {}
local item_item_highlight_style = pass_template_styles.item_item_highlight
item_item_highlight_style.visible = false
pass_template_styles.item_salvage_circle = {}
local item_salvage_circle_style = pass_template_styles.item_salvage_circle
item_salvage_circle_style.visible = false
pass_template_styles.item_salvage_icon = {}
local item_salvage_icon_style = pass_template_styles.item_salvage_icon
item_salvage_icon_style.visible = false
pass_template_styles.item_salvage_icon_right = {}
local item_salvage_icon_right_style = pass_template_styles.item_salvage_icon_right
item_salvage_icon_right_style.visible = false
pass_template_styles.item_price_background = {}
local item_price_background_style = pass_template_styles.item_price_background
item_price_background_style.visible = false
pass_template_styles.item_wallet_icon = {}
local item_wallet_icon_style = pass_template_styles.item_wallet_icon
item_wallet_icon_style.visible = false
pass_template_styles.item_price_text = {}
local item_price_text_style = pass_template_styles.item_price_text
item_price_text_style.visible = false
pass_template_styles.foldout_sub_label = table.clone(UIFontSettings.header_4)
local foldout_sub_label_style = pass_template_styles.foldout_sub_label
foldout_sub_label_style.size = {
	nil,
	30
}
foldout_sub_label_style.completed_color = completed_color
pass_template_styles.foldout_sub_progress = table.clone(UIFontSettings.body)
local foldout_sub_progress_style = pass_template_styles.foldout_sub_progress
foldout_sub_progress_style.size = table.clone(foldout_sub_label_style.size)
foldout_sub_progress_style.offset = {
	0,
	0,
	2
}
foldout_sub_progress_style.text_horizontal_alignment = "right"
foldout_sub_progress_style.completed_color = Color.white(255, true)
foldout_sub_progress_style.completed_material = completed_material
blueprint_styles.list_padding = {
	size = {
		main_column_width,
		20
	}
}
blueprint_styles.category_list_padding = {
	size = {
		left_column_width,
		10
	}
}
blueprint_styles.category_button = {}
local category_blueprint_style = blueprint_styles.category_button
category_blueprint_style.size = {
	category_width,
	ButtonPassTemplates.list_button_default_height
}
category_blueprint_style.progress = table.clone(UIFontSettings.list_button)
local category_progress_style = category_blueprint_style.progress
category_progress_style.text_horizontal_alignment = "right"
category_progress_style.offset[1] = -UIFontSettings.list_button.offset[1]
local header_height = 54
local header_height_margin = 22
blueprint_styles.header = {}
local blueprint_header_style = blueprint_styles.header
blueprint_header_style.size = {
	achievement_width,
	header_height + header_height_margin
}
blueprint_header_style.label = table.clone(UIFontSettings.grid_title)
local blueprint_header_label_style = blueprint_header_style.label
blueprint_header_label_style.size = {
	achievement_width - 2 * achievements_grid_margin,
	header_height
}
blueprint_header_label_style.horizontal_alignment = "center"
blueprint_header_label_style.offset = {
	0,
	0,
	3
}
blueprint_header_style.background_rect = {}
local blueprint_header_background_rect_style = blueprint_header_style.background_rect
blueprint_header_background_rect_style.size = {
	main_column_width,
	header_height
}
blueprint_header_background_rect_style.offset = {
	0,
	0,
	1
}
blueprint_header_background_rect_style.horizontal_alignment = "center"
blueprint_header_background_rect_style.color = Color.black(100, true)
blueprint_header_style.background = {}
local blueprint_header_background_style = blueprint_header_style.background
blueprint_header_background_style.size = {
	main_column_width,
	header_height
}
blueprint_header_background_style.offset = {
	0,
	0,
	2
}
blueprint_header_background_style.color = Color.ui_terminal(70, true)
blueprint_header_background_style.horizontal_alignment = "center"
blueprint_header_style.divider_top = {}
local blueprint_header_divider_top_style = blueprint_header_style.divider_top
blueprint_header_divider_top_style.size = {
	main_column_width,
	44
}
blueprint_header_divider_top_style.horizontal_alignment = "center"
blueprint_header_divider_top_style.offset = {
	0,
	-22,
	3
}
blueprint_header_style.divider_bottom = table.clone(blueprint_header_style.divider_top)
local blueprint_header_divider_bottom_style = blueprint_header_style.divider_bottom
blueprint_header_divider_bottom_style.size = {
	main_column_width,
	44
}
blueprint_header_divider_bottom_style.vertical_alignment = "bottom"
blueprint_header_divider_bottom_style.offset = {
	0,
	0,
	3
}
blueprint_styles.achievement_divider = {}
local achievement_divider_style = blueprint_styles.achievement_divider
achievement_divider_style.size = {
	achievement_width,
	22
}
achievement_divider_style.divider = {}
local blueprint_divider_divider_style = achievement_divider_style.divider
blueprint_divider_divider_style.size = {
	achievement_width,
	2
}
blueprint_divider_divider_style.horizontal_alignment = "center"
blueprint_divider_divider_style.color = Color.ui_grey_medium(255, true)
blueprint_styles.section_divider = {}
local section_divider_style = blueprint_styles.section_divider
section_divider_style.width_without_scrollbar = main_column_width
section_divider_style.width_with_scrollbar = main_column_width - 6
section_divider_style.size = {
	main_column_width,
	25
}
section_divider_style.divider = {}
local section_divider_divider_style = section_divider_style.divider
section_divider_divider_style.offset = {
	-20,
	-12,
	3
}
section_divider_divider_style.size = {
	section_divider_style.width_without_scrollbar,
	44
}
blueprint_styles.normal_achievement = {}
local normal_achievement_style = blueprint_styles.normal_achievement
normal_achievement_style.size = {
	achievement_width,
	90
}
blueprint_styles.foldout_achievement = table.clone(normal_achievement_style)
local foldout_achievement_style = blueprint_styles.foldout_achievement
foldout_achievement_style.size = {
	achievement_width,
	90
}
foldout_achievement_style.margin_bottom = 30
blueprint_styles.completed_achievement = table.clone(normal_achievement_style)
local completed_achievement_style = blueprint_styles.completed_achievement
completed_achievement_style.size = {
	achievement_width,
	90
}
completed_achievement_style.margin_bottom = 30
completed_achievement_style.label = table.clone(pass_template_label_style)
local completed_achievement_label_style = completed_achievement_style.label
completed_achievement_label_style.material = completed_material
completed_achievement_style.description = table.clone(pass_template_description_style)
completed_achievement_style.icon = table.clone(pass_template_icon_style)
local completed_achievement_icon_style = completed_achievement_style.icon
completed_achievement_icon_style.color = {
	255,
	242,
	228,
	157
}

return settings("AchievementsViewStyles", achievements_view_styles)
