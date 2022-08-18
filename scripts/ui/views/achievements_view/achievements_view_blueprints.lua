local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local AchievementUITypes = require("scripts/settings/achievements/achievement_ui_types")
local ItemPassTemplates = require("scripts/ui/pass_templates/item_pass_templates")
local ItemUtils = require("scripts/utilities/items")
local TextUtilities = require("scripts/utilities/ui/text")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ViewStyles = require("scripts/ui/views/achievements_view/achievements_view_styles")
local _math_round = math.round
local blueprint_styles = ViewStyles.blueprints
local pass_template_styles = blueprint_styles.pass_template
local _format_progress_params = {}

local function _format_progress(current_progress, goal)
	local params = _format_progress_params
	params.progress = current_progress
	params.goal = goal

	return Localize("loc_achievement_progress", true, params)
end

local _time_trial_params = {}

local function _format_time_trial_progress(current_progress)
	local params = _time_trial_params
	params.min = math.floor(current_progress / 60)
	params.sec = current_progress % 60

	return Localize("loc_achievements_menu_time_trial_progress", true, params)
end

local function _format_completed_achievement_label(label)
	return string.format(" %s", label)
end

local _text_extra_options = {}

local function _text_size(ui_renderer, text, style)
	local text_extra_options = _text_extra_options

	table.clear(text_extra_options)
	UIFonts.get_font_options_by_style(style, text_extra_options)

	local width, height, min = UIRenderer.text_size(ui_renderer, text, style.font_type, style.font_size, style.size, text_extra_options)

	return _math_round(width), _math_round(height + min[2]), min
end

local achievements_view_blueprints = {}

local function _common_highlight_change_function(content, style)
	local hotspot = content.hotspot
	local progress = hotspot.anim_focus_progress
	style.color[1] = 255 * math.easeOutCubic(progress)
	local ease_in_progress = math.easeInCubic(1 - progress)
	local style_size_addition = style.size_addition
	local min_size_addition = style.min_size_addition
	local max_size_addition = style.max_size_addition
	style_size_addition[1] = math.lerp(min_size_addition[1], max_size_addition[1], ease_in_progress)
	style_size_addition[2] = math.lerp(min_size_addition[2], max_size_addition[2], ease_in_progress)
	local default_offset = style.default_offset
	local offset = style.offset
	offset[1] = default_offset[1] - style_size_addition[1] / 2
	offset[2] = default_offset[2] - style_size_addition[2] / 2
	style.hdr = progress == 1
end

local function _get_achievement_common_pass_templates(achievement)
	local pass_template = {
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "hotspot",
			content = {
				use_is_focused = true
			}
		},
		{
			pass_type = "texture",
			style_id = "highlight",
			value = "content/ui/materials/frames/hover",
			style = pass_template_styles.highlight,
			change_function = _common_highlight_change_function,
			visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
		},
		{
			value_id = "icon_background",
			style_id = "icon_background",
			pass_type = "texture",
			value = "content/ui/materials/icons/achievements/frames/default",
			style = pass_template_styles.icon_background
		},
		{
			value_id = "icon",
			style_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/icons/achievements/default",
			style = pass_template_styles.icon
		},
		{
			style_id = "label",
			value_id = "label",
			pass_type = "text",
			style = pass_template_styles.label
		},
		{
			style_id = "description",
			value_id = "description",
			pass_type = "text",
			style = pass_template_styles.description
		},
		{
			value_id = "score",
			style_id = "score",
			pass_type = "text",
			value = "000",
			style = pass_template_styles.score
		}
	}

	if achievement.rewards then
		pass_template[#pass_template + 1] = {
			value_id = "reward",
			style_id = "reward",
			pass_type = "texture",
			value = "content/ui/materials/icons/achievement_rewards/container",
			style = pass_template_styles.reward
		}
	end

	return pass_template
end

_score_params = {}

local function _achievement_common_pass_template_init(widget_content, widget_style, achievement, ui_renderer, reward_item, is_completed)
	local label = achievement.label

	if is_completed then
		label = _format_completed_achievement_label(label)
	end

	local description = achievement.description
	local label_style = widget_style.label
	local description_style = widget_style.description
	widget_content.label = label
	widget_content.description = description
	local score_params = _score_params
	score_params.score = achievement.score
	widget_content.score = Localize("loc_achievements_view_score", true, score_params)

	if reward_item then
		widget_content.item = reward_item
		local reward_type_icon = ItemUtils.type_texture(reward_item)
		local reward_style = widget_style.reward
		reward_style.visible = true
		local material_values = reward_style.material_values
		material_values.item_type_icon = reward_type_icon
		local rarity = reward_item.rarity

		if rarity then
			material_values.frame = UISettings.item_rarity_texture_types.achievement_reward[rarity]
			reward_style.color = ItemUtils.rarity_color(reward_item)
		end
	end

	local _, label_height, text_min = _text_size(ui_renderer, label, label_style)

	if is_completed and text_min then
		label_style.offset[2] = label_style.offset[2] - text_min[2]
	end

	local label_height_difference = label_height - label_style.size[2]

	if label_height_difference > 0 then
		label_style.size[2] = label_height
		description_style.offset[2] = description_style.offset[2] + label_height_difference
	end

	local _, description_height = _text_size(ui_renderer, description, description_style)
	local description_height_difference = description_height - description_style.size[2]

	if description_height_difference > 0 then
		description_style.size[2] = description_height
	end

	local total_difference = label_height_difference + description_height_difference

	if total_difference < 0 then
		total_difference = 0
	end

	return total_difference
end

local _achievement_progress_bar_template = {
	{
		value = "content/ui/materials/bars/simple/frame",
		style_id = "progressbar_background",
		pass_type = "texture",
		style = pass_template_styles.progressbar_background
	},
	{
		value = "content/ui/materials/bars/simple/fill",
		style_id = "progressbar",
		pass_type = "texture",
		style = pass_template_styles.progressbar
	},
	{
		value = "content/ui/materials/bars/simple/end",
		style_id = "progressbar_edge",
		pass_type = "texture",
		style = pass_template_styles.progressbar_edge
	},
	{
		value_id = "progress",
		style_id = "progress",
		pass_type = "text",
		value = "0/0",
		style = pass_template_styles.progress
	}
}

local function _achievement_progress_bar_template_init(widget_content, widget_style, achievement, extra_offset)
	extra_offset = extra_offset or 0
	local goal = achievement.progress_goal
	local current_progress = math.min(achievement.progress_current, goal)
	widget_content.progress = _format_progress(current_progress, goal)
	local background_style = widget_style.progressbar_background
	local bar_style = widget_style.progressbar
	local edge_style = widget_style.progressbar_edge
	local progress_style = widget_style.progress
	local progress_bar_width = background_style.size[1] * current_progress / goal
	bar_style.size[1] = progress_bar_width
	edge_style.offset[1] = edge_style.offset[1] + progress_bar_width
	background_style.offset[2] = background_style.offset[2] + extra_offset
	bar_style.offset[2] = bar_style.offset[2] + extra_offset
	edge_style.offset[2] = edge_style.offset[2] + extra_offset
	progress_style.offset[2] = progress_style.offset[2] + extra_offset
end

local _achievement_time_trial_template = {
	{
		value_id = "best_time",
		style_id = "progress",
		pass_type = "text",
		value = "",
		style = pass_template_styles.progress
	}
}

local function _achievement_time_trial_template_init(widget_content, widget_style, achievement)
	local progress = achievement.progress_current
	widget_content.best_time = _format_time_trial_progress(progress)
end

local function _foldout_visibility_function(content, style)
	return content.unfolded
end

local _achievement_folding_template = {
	{
		value_id = "foldout_arrow",
		style_id = "foldout_arrow",
		pass_type = "text",
		value = "",
		style = pass_template_styles.foldout_arrow
	}
}

local function _achievement_folding_template_init(widget_content, widget_style, achievement, parent, config, folded_height, unfolded_height)
	widget_content.size[2] = folded_height
	widget_content.folded_height = folded_height
	widget_content.unfolded_height = unfolded_height

	widget_content.hotspot.pressed_callback = function ()
		local parent = parent
		local context = config
		local content = widget_content
		local unfolded = not content.unfolded or false
		content.unfolded = unfolded
		content.foldout_arrow = unfolded and "" or ""
		content.size[2] = unfolded and widget_content.unfolded_height or widget_content.folded_height

		parent:force_update_list_size()
		parent:scroll_to_grid_index(context.widget_index)
	end
end

local _slot_item_pass_templates = table.clone(ItemPassTemplates.item)

for i = #_slot_item_pass_templates, 1, -1 do
	local pass_template = _slot_item_pass_templates[i]
	local content_id = pass_template.content_id
	local value_id = pass_template.value_id
	local style_id = pass_template.style_id

	if content_id then
		pass_template.content_id = "item_" .. content_id
	end

	if value_id then
		pass_template.value_id = "item_" .. value_id
	end

	if style_id then
		style_id = "item_" .. style_id
		pass_template.style_id = style_id
		local custom_pass_style = pass_template_styles[style_id]

		if custom_pass_style then
			local pass_template_style = pass_template.style

			for key, value in pairs(custom_pass_style) do
				pass_template_style[key] = value
			end
		end
	end

	pass_template.change_function = nil
	pass_template.visibility_function = _foldout_visibility_function
end

local function _apply_live_item_icon_cb_func(widget, grid_index, rows, columns)
	local icon_style = widget.style.item_icon
	local material_values = icon_style.material_values
	material_values.use_placeholder_texture = 0
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
end

local function _remove_live_item_icon_cb_func(widget)
	local material_values = widget.style.item_icon.material_values
	material_values.use_placeholder_texture = 1
end

local function _reward_load_icon_func(parent, widget, config)
	local content = widget.content
	local reward_item = content.reward_item

	if reward_item and not content.icon_load_id then
		local cb = callback(_apply_live_item_icon_cb_func, widget)
		content.icon_load_id = Managers.ui:load_item_icon(reward_item, cb)
	end
end

local function _reward_unload_icon_func(parent, widget, element, ui_renderer)
	local content = widget.content

	if content.icon_load_id then
		_remove_live_item_icon_cb_func(widget)
		Managers.ui:unload_item_icon(content.icon_load_id)

		content.icon_load_id = nil
	end
end

local function _reward_destroy_icon_func(parent, widget, element, ui_renderer)
	local content = widget.content

	if content.icon_load_id then
		_remove_live_item_icon_cb_func(widget)
		Managers.ui:unload_item_icon(content.icon_load_id)

		content.icon_load_id = nil
	end
end

local function _add_reward_pass_template(pass_template, config)
	local reward_item = config.reward_item

	if not reward_item then
		return
	end

	local item_type = config.reward_item_type

	if item_type == "slot_item" then
		local slot_item_pass_templates = _slot_item_pass_templates

		table.append(pass_template, slot_item_pass_templates)
	end
end

local function _reward_detail_pass_template_init(widget_content, widget_style, achievement, parent, config, folded_height)
	local reward_item = config.reward_item

	if not reward_item then
		return folded_height
	end

	widget_content.reward_item = reward_item
	local reward_item_margin = ViewStyles.reward_item_margins[2]
	local offset_y = folded_height
	local item_type = config.reward_item_type

	if item_type == "slot_item" then
		widget_content.item_display_name = ItemUtils.display_name(reward_item)
		widget_content.item_sub_display_name = ItemUtils.sub_display_name(reward_item)
		local _, rarity_side_texture = ItemUtils.rarity_textures(reward_item)
		widget_content.item_rarity_side_texture = rarity_side_texture
		local item_icon_style = widget_style.item_icon
		item_icon_style.use_placeholder_texture = 1
		item_icon_style.offset[2] = offset_y
		local item_rarity_side_texture_offset = widget_style.item_rarity_side_texture.offset
		item_rarity_side_texture_offset[2] = item_rarity_side_texture_offset[2] + offset_y
		local item_display_name_offset = widget_style.item_display_name.offset
		item_display_name_offset[2] = item_display_name_offset[2] + offset_y
		local item_sub_display_name_offset = widget_style.item_sub_display_name.offset
		item_sub_display_name_offset[2] = item_sub_display_name_offset[2] + offset_y
		offset_y = offset_y + ItemPassTemplates.item_size[2] + reward_item_margin
	end

	return offset_y
end

local function _add_sub_achievements_pass_template(pass_template, sub_achievements)
	if not sub_achievements then
		return
	end

	local pass_template_styles = pass_template_styles
	local index = #pass_template
	local num_sub_achievements = #sub_achievements

	for i = 1, num_sub_achievements do
		local sub_label_name = "sub_label_" .. i
		local sub_label_style = table.clone(pass_template_styles.foldout_sub_label)
		local sub_progress_name = "sub_progress_" .. i
		local sub_progress_style = table.clone(pass_template_styles.foldout_sub_progress)
		pass_template[index + 1] = {
			pass_type = "text",
			value_id = sub_label_name,
			style_id = sub_label_name,
			style = sub_label_style,
			visibility_function = _foldout_visibility_function
		}
		pass_template[index + 2] = {
			pass_type = "text",
			value = "",
			value_id = sub_progress_name,
			style_id = sub_progress_name,
			style = sub_progress_style,
			visibility_function = _foldout_visibility_function
		}
		index = #pass_template
	end
end

local function _sub_achievements_pass_template_init(widget_content, widget_style, achievement, parent, config, folded_height)
	local sub_achievements = config.sub_achievements

	if not sub_achievements then
		return folded_height
	end

	local achievement_types = AchievementUITypes
	local sub_achievement_offset_y = folded_height

	for i = 1, #sub_achievements do
		local sub_achievement = sub_achievements[i]
		local sub_label_name = "sub_label_" .. i
		local sub_progress_name = "sub_progress_" .. i
		widget_content[sub_label_name] = sub_achievement.label
		local sub_label_style = widget_style[sub_label_name]
		sub_label_style.offset[2] = sub_achievement_offset_y
		local sub_achievement_type = sub_achievement.type
		local sub_progress_style = widget_style[sub_progress_name]
		sub_progress_style.offset[2] = sub_achievement_offset_y

		if sub_achievement.completed then
			widget_content[sub_progress_name] = Localize("loc_achievement_completed")
			sub_progress_style.text_color = sub_progress_style.completed_color
			sub_progress_style.material = sub_progress_style.completed_material
			sub_label_style.text_color = sub_label_style.completed_color
		elseif sub_achievement_type == achievement_types.increasing_stat then
			local sub_goal = sub_achievement.progress_goal
			local sub_progress = math.min(sub_achievement.progress_current, sub_goal)
			widget_content[sub_progress_name] = _format_progress(sub_progress, sub_goal)
		elseif sub_achievement_type == achievement_types.time_trial then
			widget_content[sub_progress_name] = _format_time_trial_progress(sub_achievement.progress_current)
		end

		sub_achievement_offset_y = sub_achievement_offset_y + sub_label_style.size[2]
	end

	local unfolded_height = folded_height + pass_template_styles.foldout_sub_label.size[2] * #sub_achievements + widget_style.margin_bottom

	return unfolded_height
end

achievements_view_blueprints.summary_button = {
	size = table.clone(blueprint_styles.category_button.size),
	pass_template = table.clone(ButtonPassTemplates.list_button),
	init = function (parent, widget, config, callback_name, secondary_callback_name, ui_renderer)
		local content = widget.content
		content.text = Localize("loc_achievements_view_summary")
		local hotspot = content.hotspot
		hotspot.pressed_callback = callback(parent, callback_name, widget, config)
		hotspot.selected_callback = callback(config.selected_callback)
	end
}
local _category_button_string_params = {}
achievements_view_blueprints.category_button = {
	size = table.clone(blueprint_styles.category_button.size),
	pass_template = table.clone(ButtonPassTemplates.list_button),
	init = function (parent, widget, config, callback_name, secondary_callback_name, ui_renderer)
		local category = config.category
		local content = widget.content
		content.text = category.label
		_category_button_string_params.completed = category.num_completed
		_category_button_string_params.total = category.num_total
		content.progress = Localize("loc_achievement_category_completion", true, _category_button_string_params)
		local hotspot = content.hotspot
		hotspot.pressed_callback = callback(parent, callback_name, widget, config)
		hotspot.selected_callback = callback(config.selected_callback, widget, category.id)
	end
}

table.append(achievements_view_blueprints.category_button.pass_template, {
	{
		pass_type = "text",
		style_id = "progress",
		value_id = "progress",
		style = blueprint_styles.category_button.progress,
		change_function = ButtonPassTemplates.list_button_label_change_function
	}
})

achievements_view_blueprints.list_padding = {
	size = blueprint_styles.list_padding.size
}
achievements_view_blueprints.category_list_padding = {
	size = blueprint_styles.category_list_padding.size
}
achievements_view_blueprints.header = {
	size = blueprint_styles.header.size,
	pass_template = {
		{
			value = "content/ui/materials/dividers/horizontal_frame_big_middle",
			style_id = "divider_top",
			pass_type = "texture"
		},
		{
			style_id = "label",
			value_id = "label",
			pass_type = "text"
		},
		{
			value = "content/ui/materials/backgrounds/headline_terminal",
			style_id = "background",
			pass_type = "texture"
		},
		{
			pass_type = "rect",
			style_id = "background_rect"
		},
		{
			value = "content/ui/materials/dividers/horizontal_frame_big_middle",
			style_id = "divider_bottom",
			pass_type = "texture"
		}
	},
	style = blueprint_styles.header,
	init = function (parent, widget, config, callback_name, secondary_callback_name, ui_renderer)
		local content = widget.content
		content.label = TextUtilities.localize_to_upper(config.display_name)
	end
}
achievements_view_blueprints.achievement_divider = {
	size = blueprint_styles.achievement_divider.size,
	pass_template = {
		{
			value = "content/ui/materials/dividers/faded_line_01",
			style_id = "divider",
			pass_type = "texture"
		}
	},
	style = blueprint_styles.achievement_divider
}
achievements_view_blueprints.section_divider = {
	size = blueprint_styles.section_divider.size,
	pass_template = {
		{
			value = "content/ui/materials/dividers/horizontal_frame_big_middle",
			style_id = "divider",
			pass_type = "texture"
		}
	},
	style = blueprint_styles.section_divider
}
achievements_view_blueprints.empty_space = {
	size = blueprint_styles.normal_achievement.size
}
achievements_view_blueprints.normal_achievement = {
	size = blueprint_styles.normal_achievement.size,
	pass_template_function = function (parent, config)
		local achievement_types = AchievementUITypes
		local achievement = config.achievement
		local pass_template = _get_achievement_common_pass_templates(achievement)
		local achievement_type = achievement.type

		if achievement_type == achievement_types.increasing_stat then
			table.append(pass_template, _achievement_progress_bar_template)
		elseif achievement_type == achievement_types.time_trial then
			table.append(pass_template, _achievement_time_trial_template)
		end

		return pass_template
	end,
	init = function (parent, widget, config, callback_name, secondary_callback_name, ui_renderer)
		local achievement_types = AchievementUITypes
		local achievement = config.achievement
		local content = widget.content
		local style = widget.style
		local height_difference = _achievement_common_pass_template_init(content, style, achievement, ui_renderer, config.reward_item)
		local achievement_type = achievement.type

		if achievement_type == achievement_types.increasing_stat then
			_achievement_progress_bar_template_init(content, style, achievement, height_difference)
		elseif achievement_type == achievement_types.time_trial then
			_achievement_time_trial_template_init(content, style, achievement)
		end

		content.size[2] = content.size[2] + height_difference
	end
}
achievements_view_blueprints.foldout_achievement = {
	size = blueprint_styles.foldout_achievement.size,
	pass_template_function = function (parent, config)
		local achievement = config.achievement
		local pass_template = _get_achievement_common_pass_templates(achievement)

		table.append(pass_template, _achievement_progress_bar_template)
		table.append(pass_template, _achievement_folding_template)
		_add_reward_pass_template(pass_template, config)
		_add_sub_achievements_pass_template(pass_template, config.sub_achievements)

		return pass_template
	end,
	style = blueprint_styles.foldout_achievement,
	init = function (parent, widget, config, callback_name, secondary_callback_name, ui_renderer)
		local achievement = config.achievement
		local widget_content = widget.content
		local widget_style = widget.style
		local reward_item = config.reward_item
		local extra_height = _achievement_common_pass_template_init(widget_content, widget_style, achievement, ui_renderer, reward_item)

		_achievement_progress_bar_template_init(widget_content, widget_style, achievement, extra_height)

		local folded_height = widget_content.size[2] + extra_height
		local unfolded_height = folded_height
		unfolded_height = _reward_detail_pass_template_init(widget_content, widget_style, achievement, parent, config, unfolded_height)
		unfolded_height = _sub_achievements_pass_template_init(widget_content, widget_style, achievement, parent, config, unfolded_height)

		_achievement_folding_template_init(widget_content, widget_style, achievement, parent, config, folded_height, unfolded_height)
	end,
	load_icon = _reward_load_icon_func,
	unload_icon = _reward_unload_icon_func,
	destroy = _reward_destroy_icon_func
}
achievements_view_blueprints.completed_achievement = {
	size = blueprint_styles.completed_achievement.size,
	pass_template_function = function (parent, config)
		return _get_achievement_common_pass_templates(config.achievement, config)
	end,
	style = blueprint_styles.completed_achievement,
	init = function (parent, widget, config, callback_name, secondary_callback_name, ui_renderer)
		local content = widget.content
		local extra_height = _achievement_common_pass_template_init(content, widget.style, config.achievement, ui_renderer, config.reward_item, true)
		content.size[2] = content.size[2] + extra_height
	end
}
achievements_view_blueprints.completed_foldout_achievement = {
	size = blueprint_styles.completed_achievement.size,
	pass_template_function = function (parent, config)
		local achievement = config.achievement
		local pass_template = _get_achievement_common_pass_templates(achievement)

		table.append(pass_template, _achievement_folding_template)
		_add_reward_pass_template(pass_template, config)
		_add_sub_achievements_pass_template(pass_template, config.sub_achievements)

		return pass_template
	end,
	style = blueprint_styles.completed_achievement,
	init = function (parent, widget, config, callback_name, secondary_callback_name, ui_renderer)
		local achievement = config.achievement
		local widget_content = widget.content
		local widget_style = widget.style
		local reward_item = config.reward_item
		local extra_height = _achievement_common_pass_template_init(widget_content, widget_style, achievement, ui_renderer, reward_item, true)
		local folded_height = widget_content.size[2] + extra_height
		local unfolded_height = folded_height
		unfolded_height = _reward_detail_pass_template_init(widget_content, widget_style, achievement, parent, config, unfolded_height)
		unfolded_height = _sub_achievements_pass_template_init(widget_content, widget_style, achievement, parent, config, unfolded_height)

		_achievement_folding_template_init(widget_content, widget_style, achievement, parent, config, folded_height, unfolded_height)
	end,
	load_icon = _reward_load_icon_func,
	unload_icon = _reward_unload_icon_func,
	destroy = _reward_destroy_icon_func
}

return settings("AchievementsViewBlueprints", achievements_view_blueprints)
