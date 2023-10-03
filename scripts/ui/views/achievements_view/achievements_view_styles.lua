local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local left_column_width = 540
local visible_area_width = 1560
local visible_area_height = 780
local achievements_grid_margin = 16
local achievement_width = 882
local main_column_width = achievement_width + 2 * achievements_grid_margin
local achievement_icon_size = {
	70,
	70
}
local reward_item_size = table.clone(UISettings.item_icon_size)
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
	categories_grid_spacing = {
		0,
		-2
	},
	achievement_margins = {
		8,
		8
	},
	completed = {}
}
local completed_styles = achievements_view_styles.completed
completed_styles.size = {
	440,
	60
}
completed_styles.total_score = table.clone(UIFontSettings.header_2)
local completed_score_style = completed_styles.total_score
completed_score_style.font_size = 55
completed_score_style.text_horizontal_alignment = "center"
local categories_grid_margin = 16
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
	780
}
achievements_grid_style.margin = achievements_grid_margin
achievements_view_styles.achievement_summary = {}
local achievement_summary_style = achievements_view_styles.achievement_summary
achievement_summary_style.num_completed_to_show = num_completed_to_show
achievement_summary_style.num_near_completed_to_show = num_near_completed_to_show
achievements_view_styles.gamepad_unfold_hint = {}
local gamepad_unfold_hint_style = achievements_view_styles.gamepad_unfold_hint
gamepad_unfold_hint_style.text = table.clone(UIFontSettings.body)
local gamepad_unfold_hint_text_style = gamepad_unfold_hint_style.text
gamepad_unfold_hint_text_style.text_horizontal_alignment = "center"
gamepad_unfold_hint_text_style.text_vertical_alignment = "center"
gamepad_unfold_hint_text_style.offset = {
	0,
	0,
	10
}
achievements_view_styles.blueprints = {}
local blueprint_styles = achievements_view_styles.blueprints
blueprint_styles.pass_template = {}
local pass_template_styles = blueprint_styles.pass_template
pass_template_styles.common_achievement_passes = {}
local common_achievement_pass_styles = pass_template_styles.common_achievement_passes
common_achievement_pass_styles.background = {}
local common_achievement_background_style = common_achievement_pass_styles.background
common_achievement_background_style.color = Color.terminal_background_selected(nil, true)
common_achievement_background_style.hover_alpha = 64
common_achievement_background_style.selected_alpha = 24
common_achievement_background_style.size = common_achievement_background_style.size
common_achievement_background_style.scale_to_material = true
common_achievement_pass_styles.background_gradient = {}
local common_achievement_background_gradient_style = common_achievement_pass_styles.background_gradient
common_achievement_background_gradient_style.color = Color.terminal_background_gradient(nil, true)
common_achievement_background_gradient_style.default_color = common_achievement_background_gradient_style.color
common_achievement_background_gradient_style.hover_color = common_achievement_background_gradient_style.color
common_achievement_background_gradient_style.selected_color = Color.terminal_background_gradient_selected(nil, true)
common_achievement_background_gradient_style.alpha = common_achievement_background_gradient_style.color[1]
common_achievement_background_gradient_style.size = common_achievement_background_style.size
common_achievement_background_gradient_style.offset = {
	0,
	0,
	1
}
common_achievement_background_gradient_style.scale_to_material = true
common_achievement_pass_styles.frame = {}
local common_achievement_frame_style = common_achievement_pass_styles.frame
common_achievement_frame_style.color = Color.terminal_frame(nil, true)
common_achievement_frame_style.default_color = common_achievement_frame_style.color
common_achievement_frame_style.hover_color = Color.terminal_frame_hover(nil, true)
common_achievement_frame_style.selected_color = Color.terminal_frame_selected(nil, true)
common_achievement_frame_style.offset = {
	0,
	0,
	6
}
common_achievement_frame_style.hover_layer = 7
common_achievement_frame_style.selected_layer = 8
common_achievement_frame_style.scale_to_material = true
common_achievement_pass_styles.corner = {}
local common_achievement_corner_style = common_achievement_pass_styles.corner
common_achievement_corner_style.default_color = Color.terminal_corner(nil, true)
common_achievement_corner_style.hover_color = Color.terminal_corner_hover(nil, true)
common_achievement_corner_style.selected_color = Color.terminal_corner_selected(nil, true)
common_achievement_corner_style.offset = {
	0,
	0,
	9
}
common_achievement_corner_style.hover_layer = 10
common_achievement_corner_style.selected_layer = 11
common_achievement_corner_style.scale_to_material = true
common_achievement_pass_styles.icon = {}
local common_achievement_icon_style = common_achievement_pass_styles.icon
common_achievement_icon_style.offset = {
	8,
	8,
	3
}
common_achievement_icon_style.size = achievement_icon_size
common_achievement_icon_style.color = Color.white(255, true)
common_achievement_icon_style.material_values = {
	icon_color = Color.ui_achievement_icon(nil, true)
}
common_achievement_icon_style.icon_default_color = table.clone(common_achievement_icon_style.material_values.icon_color)
common_achievement_icon_style.icon_hover_color = Color.ui_achievement_icon_hover(nil, true)
common_achievement_pass_styles.label = table.clone(UIFontSettings.header_3)
local common_achievement_label_style = common_achievement_pass_styles.label
common_achievement_label_style.vertical_alignment = "top"
common_achievement_label_style.offset = {
	achievement_icon_size[1] + 16,
	8,
	3
}
common_achievement_label_style.size = {
	512,
	30
}
common_achievement_pass_styles.description = table.clone(UIFontSettings.body_small)
local common_achievement_description_style = common_achievement_pass_styles.description
common_achievement_description_style.offset = {
	common_achievement_label_style.offset[1],
	4,
	3
}
common_achievement_description_style.size = {
	512,
	20
}
common_achievement_pass_styles.score = table.clone(UIFontSettings.terminal_header_3)
local common_achievement_score_styles = common_achievement_pass_styles.score
common_achievement_score_styles.horizontal_alignment = "right"
common_achievement_score_styles.offset = {
	-30,
	25,
	3
}
common_achievement_score_styles.size = {
	170,
	30
}
common_achievement_score_styles.text_horizontal_alignment = "center"
pass_template_styles.reward_item_margins = {
	achievement_icon_size[1] + 16,
	16
}
pass_template_styles.rewards = {}
local rewards_style = pass_template_styles.rewards
rewards_style.reward_icon_small = {}
local reward_icon_small_style = rewards_style.reward_icon_small
reward_icon_small_style.horizontal_alignment = "right"
reward_icon_small_style.size = {
	50,
	50
}
reward_icon_small_style.material_values = {
	frame = "content/ui/textures/icons/achievements/frames/default_frame",
	background = "content/ui/textures/icons/achievements/frames/frame_background_blank",
	icon_color = Color.terminal_frame_hover(255, true)
}
reward_icon_small_style.offset = {
	-212,
	20,
	5
}
reward_icon_small_style.color = Color.terminal_frame(nil, true)
reward_icon_small_style.default_color = reward_icon_small_style.color
reward_icon_small_style.hover_color = Color.terminal_frame_hover(nil, true)
reward_icon_small_style.selected_color = Color.terminal_frame_selected(nil, true)
reward_icon_small_style.icon_default_color = reward_icon_small_style.material_values.icon_color
reward_icon_small_style.icon_hover_color = Color.terminal_corner_hover(255, true)
reward_icon_small_style.icon_selected_color = Color.terminal_corner_selected(nil, true)
reward_icon_small_style.scale_to_material = true
rewards_style.reward_icon_frame = table.clone(common_achievement_frame_style)
local reward_icon_frame_style = rewards_style.reward_icon_frame
reward_icon_frame_style.offset = {
	achievement_icon_size[1] + 16,
	4,
	5
}
reward_icon_frame_style.size = {
	reward_item_size[1] + 4,
	reward_item_size[2] + 4
}
rewards_style.reward_icon_background = {}
local reward_icon_background_style = rewards_style.reward_icon_background
reward_icon_background_style.color = {
	100,
	33,
	35,
	37
}
reward_icon_background_style.size = reward_item_size
reward_icon_background_style.offset = {
	reward_icon_frame_style.offset[1] + 2,
	reward_icon_frame_style.offset[2] + 2,
	5
}
rewards_style.reward_icon = {}
local reward_icon_style = rewards_style.reward_icon
reward_icon_style.size = reward_item_size
reward_icon_style.offset = {
	reward_icon_frame_style.offset[1] + 2,
	reward_icon_frame_style.offset[2] + 2,
	6
}
reward_icon_style.material_values = {
	use_placeholder_texture = 1
}
reward_icon_style.scale_to_material = true
rewards_style.reward_label = table.clone(UIFontSettings.body_small)
local reward_label_style = rewards_style.reward_label
reward_label_style.offset = {
	reward_icon_frame_style.offset[1] + reward_icon_frame_style.size[1] + 20,
	28,
	3
}
rewards_style.reward_display_name = table.clone(common_achievement_label_style)
local reward_display_name_style = rewards_style.reward_display_name
reward_display_name_style.offset = {
	reward_label_style.offset[1],
	reward_label_style.offset[2] + 22,
	3
}
rewards_style.reward_sub_display_name = table.clone(UIFontSettings.body_small)
local reward_sub_display_name_style = rewards_style.reward_sub_display_name
reward_sub_display_name_style.offset = {
	reward_label_style.offset[1],
	reward_display_name_style.offset[2] + 6,
	3
}
reward_sub_display_name_style.text_color = Color.terminal_text_body_sub_header(nil, true)
pass_template_styles.progress_bar = {}
local progress_bar_pass_template_styles = pass_template_styles.progress_bar
progress_bar_pass_template_styles.size = {
	412,
	12
}
progress_bar_pass_template_styles.progress_bar_frame = {}
progress_bar_frame_style = progress_bar_pass_template_styles.progress_bar_frame
progress_bar_frame_style.offset = {
	common_achievement_label_style.offset[1],
	8,
	6
}
progress_bar_frame_style.size = progress_bar_pass_template_styles.size
progress_bar_frame_style.default_color = Color.terminal_frame(nil, true)
progress_bar_frame_style.hover_color = Color.terminal_frame_hover(nil, true)
progress_bar_frame_style.selected_color = Color.terminal_frame_selected(nil, true)
progress_bar_pass_template_styles.progress_bar_background = {}
progress_bar_background_style = progress_bar_pass_template_styles.progress_bar_background
progress_bar_background_style.offset = {
	progress_bar_frame_style.offset[1] + 1,
	progress_bar_frame_style.offset[2] + 1,
	7
}
progress_bar_background_style.size = {
	progress_bar_pass_template_styles.size[1] - 2,
	progress_bar_pass_template_styles.size[2] - 2
}
progress_bar_background_style.color = Color.terminal_background(255, true)
progress_bar_pass_template_styles.progress_bar_edge = {}
progress_bar_edge_style = progress_bar_pass_template_styles.progress_bar_edge
progress_bar_edge_style.size = {
	12,
	28
}
progress_bar_edge_style.relative_negative_offset_x = -6
progress_bar_edge_style.offset = {
	progress_bar_background_style.offset[1] + progress_bar_edge_style.relative_negative_offset_x,
	progress_bar_background_style.offset[2] - 9,
	10
}
progress_bar_pass_template_styles.progress_bar = table.clone(progress_bar_background_style)
local progress_bar_style = progress_bar_pass_template_styles.progress_bar
progress_bar_style.offset[3] = 8
progress_bar_style.color = Color.white(255, true)
progress_bar_pass_template_styles.progress = table.clone(UIFontSettings.body_small)
local progress_text_style = progress_bar_pass_template_styles.progress
progress_text_style.offset = {
	progress_bar_frame_style.offset[1] + progress_bar_frame_style.size[1] + 8,
	progress_bar_frame_style.offset[2] - 5,
	3
}
pass_template_styles.meta_sub_achievement_margins = {
	achievement_icon_size[1] + 32,
	20
}
pass_template_styles.meta_sub_achievements = {}
local meta_sub_achievement_style = pass_template_styles.meta_sub_achievements
meta_sub_achievement_style.sub_icon = table.clone(common_achievement_icon_style)
local meta_sub_achievement_icon_style = meta_sub_achievement_style.sub_icon
meta_sub_achievement_icon_style.offset = {
	achievement_icon_size[1] + 32,
	4,
	6
}
meta_sub_achievement_icon_style.size = {
	achievement_icon_size[1] / 2,
	achievement_icon_size[2] / 2
}
meta_sub_achievement_icon_style.completed_frame = "content/ui/textures/icons/achievements/frames/achieved"
meta_sub_achievement_icon_style.icon_completed_color = Color.ui_achievement_icon_completed(nil, true)
meta_sub_achievement_icon_style.icon_completed_hover_color = Color.ui_achievement_icon_completed_hover(nil, true)
meta_sub_achievement_style.sub_label = table.clone(UIFontSettings.body)
local meta_sub_achievement_label_style = meta_sub_achievement_style.sub_label
meta_sub_achievement_label_style.offset = {
	meta_sub_achievement_icon_style.offset[1] + meta_sub_achievement_icon_style.size[1] + 8,
	6,
	3
}
meta_sub_achievement_label_style.completed_layer = 6
meta_sub_achievement_label_style.text_color = Color.ui_grey_light(255, true)
meta_sub_achievement_label_style.completed_color = Color.terminal_text_body(255, true)
pass_template_styles.family_sub_achievement_margins = {
	achievement_icon_size[1] - 16,
	20
}
pass_template_styles.achievement_family = {}
local achievement_family_style = pass_template_styles.achievement_family
achievement_family_style.group_label = table.clone(UIFontSettings.body_small)
achievement_family_group_label_style = achievement_family_style.group_label
achievement_family_group_label_style.offset = {
	achievement_icon_size[1] + 16,
	0,
	3
}
achievement_family_group_label_style.size = {
	512,
	18
}
pass_template_styles.family_sub_achievements = {}
local family_sub_achievement_style = pass_template_styles.family_sub_achievements
family_sub_achievement_style.sub_icon = table.clone(meta_sub_achievement_icon_style)
local family_sub_achievement_icon_style = family_sub_achievement_style.sub_icon
family_sub_achievement_icon_style.offset = {
	32,
	8,
	3
}
family_sub_achievement_icon_style.size = {
	achievement_icon_size[1],
	achievement_icon_size[2]
}
family_sub_achievement_style.sub_score = table.clone(UIFontSettings.body_small)
local family_sub_achievement_score_style = family_sub_achievement_style.sub_score
family_sub_achievement_score_style.offset = {
	family_sub_achievement_icon_style.offset[1],
	4,
	3
}
family_sub_achievement_score_style.text_horizontal_alignment = "center"
family_sub_achievement_score_style.size = {
	achievement_icon_size[1],
	18
}
family_sub_achievement_score_style.text_color = Color.terminal_text_body(255, true)
pass_template_styles.family_sub_reward_margins = {
	achievement_icon_size[1] - 16,
	20
}
pass_template_styles.achievement_family_reward = {}
local achievement_family_reward_style = pass_template_styles.achievement_family_reward
achievement_family_reward_style.icon = {}
local family_reward_icon_style = achievement_family_reward_style.icon
family_reward_icon_style.size = {
	96,
	96
}
family_reward_icon_style.offset = {
	34,
	34,
	5
}
family_reward_icon_style.material_values = {
	use_placeholder_texture = 1
}
family_reward_icon_style.scale_to_material = true
achievement_family_reward_style.icon_background = table.clone(reward_icon_background_style)
local family_reward_icon_background_style = achievement_family_reward_style.icon_background
family_reward_icon_background_style.size = family_reward_icon_style.size
family_reward_icon_background_style.offset = {
	family_reward_icon_style.offset[1],
	family_reward_icon_style.offset[2],
	4
}
achievement_family_reward_style.icon_frame = table.clone(common_achievement_frame_style)
local family_reward_icon_frame_style = achievement_family_reward_style.icon_frame
family_reward_icon_frame_style.offset = {
	family_reward_icon_style.offset[1] - 2,
	family_reward_icon_style.offset[2] - 2,
	5
}
family_reward_icon_frame_style.size = {
	family_reward_icon_style.size[1] + 4,
	family_reward_icon_style.size[2] + 4
}
achievement_family_reward_style.label = table.clone(UIFontSettings.body_small)
local family_reward_label_style = achievement_family_reward_style.label
family_reward_label_style.offset = {
	family_reward_icon_style.offset[1] + family_reward_icon_style.size[1] + 16,
	28,
	3
}
achievement_family_reward_style.display_name = table.clone(UIFontSettings.body_small)
local family_reward_display_name_style = achievement_family_reward_style.display_name
family_reward_display_name_style.offset = {
	family_reward_label_style.offset[1],
	family_reward_label_style.offset[2] + 22,
	3
}
family_reward_display_name_style.size = {
	250,
	18
}
family_reward_display_name_style.text_color = Color.terminal_text_header(255, true)
achievement_family_reward_style.sub_display_name = table.clone(UIFontSettings.body_small)
local family_reward_display_name_style = achievement_family_reward_style.sub_display_name
family_reward_display_name_style.offset = {
	family_reward_label_style.offset[1],
	family_reward_label_style.offset[2] + 45,
	3
}
family_reward_display_name_style.size = {
	250,
	18
}
family_reward_display_name_style.text_color = Color.terminal_text_body_sub_header(255, true)
achievement_family_reward_style.lock = {}
local family_reward_lock_style = achievement_family_reward_style.lock
family_reward_lock_style.font_type = "proxima_nova_bold"
family_reward_lock_style.font_size = 55
family_reward_lock_style.size = family_reward_icon_style.size
family_reward_lock_style.offset = {
	family_reward_icon_style.offset[1],
	family_reward_icon_style.offset[2],
	8
}
family_reward_lock_style.text_horizontal_alignment = "center"
family_reward_lock_style.text_vertical_alignment = "center"
family_reward_lock_style.default_color = Color.terminal_frame(nil, true)
family_reward_lock_style.hover_color = Color.terminal_frame_hover(nil, true)
family_reward_lock_style.selected_color = Color.terminal_frame_selected(nil, true)
pass_template_styles.completed_overlay = {}
local completed_overlay_style = pass_template_styles.completed_overlay
completed_overlay_style.offset = {
	0,
	0,
	4
}
completed_overlay_style.color = {
	128,
	0,
	0,
	0
}
blueprint_styles.list_padding = {
	size = {
		achievement_width,
		4
	}
}
blueprint_styles.category_list_padding_top = {}
local category_list_padding_top_style = blueprint_styles.category_list_padding_top
category_list_padding_top_style.size = {
	category_width,
	12
}
blueprint_styles.category_list_padding_bottom = {
	size = {
		category_width,
		10
	}
}
blueprint_styles.simple_category_button = {}
local simple_category_blueprint_style = blueprint_styles.simple_category_button
simple_category_blueprint_style.size = {
	category_width,
	ButtonPassTemplates.list_button_default_height
}
blueprint_styles.top_category_button = {}
local top_category_blueprint_style = blueprint_styles.top_category_button
top_category_blueprint_style.size = table.clone(simple_category_blueprint_style.size)
top_category_blueprint_style.folded_height = top_category_blueprint_style.size[2]
top_category_blueprint_style.hotspot = {}
local top_category_blueprint_hotspot_style = top_category_blueprint_style.hotspot
top_category_blueprint_hotspot_style.anim_select_speed = 32
top_category_blueprint_hotspot_style.on_pressed_sound = nil
top_category_blueprint_style.arrow = {}
local top_category_blueprint_arrow_style = top_category_blueprint_style.arrow
top_category_blueprint_arrow_style.color = Color.terminal_text_body(255, true)
top_category_blueprint_arrow_style.default_color = top_category_blueprint_arrow_style.color
top_category_blueprint_arrow_style.hover_color = Color.terminal_text_header(nil, true)
top_category_blueprint_arrow_style.selected_color = Color.terminal_text_header_selected(nil, true)
top_category_blueprint_arrow_style.angle = math.degrees_to_radians(-90)
top_category_blueprint_arrow_style.size = {
	24,
	24
}
top_category_blueprint_arrow_style.offset = {
	-16,
	0,
	4
}
top_category_blueprint_arrow_style.vertical_alignment = "center"
top_category_blueprint_arrow_style.horizontal_alignment = "right"
top_category_blueprint_arrow_style.unfold_sound = UISoundEvents.default_dropdown_expand
top_category_blueprint_arrow_style.fold_sound = UISoundEvents.default_dropdown_minimize
blueprint_styles.sub_category_button = {
	bullet = {
		offset = {}
	},
	bullet_active = {
		offset = {}
	},
	text = {
		offset = {}
	}
}
local sub_category_blueprint_style = blueprint_styles.sub_category_button
sub_category_blueprint_style.folded_size = {
	0,
	0
}
sub_category_blueprint_style.unfolded_size = {
	category_width,
	56
}
sub_category_blueprint_style.size = sub_category_blueprint_style.folded_size
sub_category_blueprint_style.text = table.clone(UIFontSettings.list_button)
local sub_category_blueprint_text_style = sub_category_blueprint_style.text
sub_category_blueprint_text_style.font_size = 20
sub_category_blueprint_text_style.offset[1] = 52
sub_category_blueprint_style.bullet.offset[1] = 30
sub_category_blueprint_style.bullet_active.offset[1] = 30
sub_category_blueprint_style.text.offset[1] = 68
local header_height = 54
local header_height_margin = 12
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
blueprint_header_label_style.vertical_alignment = "center"
blueprint_header_label_style.offset = {
	0,
	0,
	5
}
blueprint_header_style.divider_right = {}
local blueprint_header_divider_right_style = blueprint_header_style.divider_right
blueprint_header_divider_right_style.size = {
	achievement_width / 2 - 60,
	24
}
blueprint_header_divider_right_style.horizontal_alignment = "right"
blueprint_header_divider_right_style.vertical_alignment = "center"
blueprint_header_divider_right_style.offset = {
	-40,
	0,
	5
}
blueprint_header_divider_right_style.color = Color.terminal_frame(255, true)
blueprint_header_style.divider_left = table.clone(blueprint_header_divider_right_style)
local blueprint_header_divider_left_style = blueprint_header_style.divider_left
blueprint_header_divider_left_style.horizontal_alignment = "left"
blueprint_header_divider_left_style.offset[1] = 40
blueprint_header_divider_left_style.uvs = {
	{
		1,
		0
	},
	{
		0,
		1
	}
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
blueprint_styles.normal_achievement = table.clone(common_achievement_pass_styles)
local normal_achievement_style = blueprint_styles.normal_achievement
normal_achievement_style.size = {
	achievement_width,
	90
}
normal_achievement_style.hotspot = {}
local normal_achievement_hotspot_style = normal_achievement_style.hotspot
normal_achievement_hotspot_style.on_hover_sound = UISoundEvents.default_mouse_hover
normal_achievement_hotspot_style.on_select_sound = UISoundEvents.default_click
local normal_achievement_icon_style = normal_achievement_style.icon
normal_achievement_icon_style.icon_default_color = Color.ui_achievement_icon_completed(nil, true)
normal_achievement_icon_style.icon_hover_color = Color.ui_achievement_icon_completed_hover(nil, true)
normal_achievement_icon_style.material_values = {
	frame = "content/ui/textures/icons/achievements/frames/achieved",
	icon_color = table.clone(normal_achievement_icon_style.icon_default_color)
}
normal_achievement_style.in_progress_overlay = table.clone(pass_template_styles.completed_overlay)
blueprint_styles.foldout_achievement = table.clone(normal_achievement_style)
local foldout_achievement_style = blueprint_styles.foldout_achievement
foldout_achievement_style.size = {
	achievement_width,
	90
}
foldout_achievement_style.arrow = {}
local foldout_achievement_arrow_style = foldout_achievement_style.arrow
foldout_achievement_arrow_style.color = Color.terminal_text_body(255, true)
foldout_achievement_arrow_style.default_color = foldout_achievement_arrow_style.color
foldout_achievement_arrow_style.hover_color = Color.terminal_text_header(255, true)
foldout_achievement_arrow_style.selected_color = Color.terminal_text_header_selected(nil, true)
foldout_achievement_arrow_style.angle = math.degrees_to_radians(-90)
foldout_achievement_arrow_style.size = {
	24,
	24
}
foldout_achievement_arrow_style.offset = {
	-20,
	32,
	4
}
foldout_achievement_arrow_style.vertical_alignment = "top"
foldout_achievement_arrow_style.horizontal_alignment = "right"
foldout_achievement_arrow_style.unfold_sound = UISoundEvents.default_dropdown_expand
foldout_achievement_arrow_style.fold_sound = UISoundEvents.default_dropdown_minimize
blueprint_styles.completed_achievement = table.clone(normal_achievement_style)
local completed_achievement_style = blueprint_styles.completed_achievement
completed_achievement_style.size = {
	achievement_width,
	90
}
completed_achievement_style.margin_bottom = 30
completed_achievement_style.reward = table.clone(reward_icon_small_style)
blueprint_styles.completed_foldout_achievement = table.clone(completed_achievement_style)
local completed_foldout_achievement_style = blueprint_styles.completed_foldout_achievement
completed_foldout_achievement_style.arrow = table.clone(foldout_achievement_arrow_style)

return settings("AchievementsViewStyles", achievements_view_styles)
