local AchievementUIHelper = require("scripts/managers/achievements/utility/achievement_ui_helper")
local AchievementUITypes = require("scripts/settings/achievements/achievement_ui_types")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local ItemUtils = require("scripts/utilities/items")
local TextUtilities = require("scripts/utilities/ui/text")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewStyles = require("scripts/ui/views/achievements_view/achievements_view_styles")
local _get_reward_item = AchievementUIHelper.get_reward_item
local _color_copy = ColorUtilities.color_copy
local _color_lerp = ColorUtilities.color_lerp
local _math_lerp = math.lerp
local _math_max = math.max
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

local _text_extra_options = {}

local function _text_size(ui_renderer, text, style)
	local text_extra_options = _text_extra_options

	table.clear(text_extra_options)
	UIFonts.get_font_options_by_style(style, text_extra_options)

	local width, height, min = UIRenderer.text_size(ui_renderer, text, style.font_type, style.font_size, style.size, text_extra_options)

	return _math_round(width), _math_round(height + min[2]), min
end

local function _common_frame_hover_change_function(content, style)
	local color_lerp = _color_lerp
	local hotspot = content.hotspot
	local focus_progress = hotspot.anim_focus_progress
	local hover_progress = hotspot.anim_hover_progress
	local color = style.color or style.text_color
	local default_color = style.default_color
	local hover_color = style.hover_color
	local focused_color = style.selected_color
	local target_color = nil

	if hover_progress < focus_progress then
		target_color = focused_color
		hover_progress = focus_progress
	else
		target_color = hover_color
	end

	color_lerp(default_color, target_color, hover_progress, color)
end

local function _common_icon_hover_change_function(content, style)
	local color_lerp = _color_lerp
	local hotspot = content.hotspot
	local focus_progress = hotspot.anim_focus_progress
	local hover_progress = hotspot.anim_hover_progress
	local target_color, icon_target_color = nil

	if hover_progress < focus_progress then
		hover_progress = focus_progress
		target_color = style.selected_color
		icon_target_color = style.icon_selected_color
	else
		target_color = style.hover_color
		icon_target_color = style.icon_hover_color
	end

	if target_color then
		color_lerp(style.default_color, target_color, hover_progress, style.color)
	end

	if icon_target_color then
		local material_values = style.material_values

		color_lerp(style.icon_default_color, icon_target_color, hover_progress, material_values.icon_color)
	end
end

local function _common_focus_visibility_function(content, style)
	local hotspot = content.hotspot

	return hotspot.is_focused or hotspot.anim_focus_progress > 0
end

local function _common_hover_visibility_function(content, style)
	local hotspot = content.hotspot
	local is_hovered = hotspot.is_hover or hotspot.is_focused
	local was_hovered = hotspot.anim_hover_progress > 0 or hotspot.anim_focus_progress > 0

	return is_hovered or was_hovered
end

local achievements_view_blueprints = {}

local function _achievement_background_hover_change_function(content, style)
	local hotspot = content.hotspot
	local hover_progress = _math_max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)
	local color = style.color
	local alpha = style.alpha or 1
	color[1] = alpha * hover_progress
end

local function _get_achievement_common_pass_templates(is_summary)
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
			style_id = "background",
			pass_type = "texture",
			value_id = "background",
			value = "content/ui/materials/backgrounds/default_square",
			change_function = _achievement_background_hover_change_function,
			visibility_function = _common_focus_visibility_function
		},
		{
			style_id = "background_gradient",
			pass_type = "texture",
			value_id = "background_gradient",
			value = "content/ui/materials/masks/gradient_horizontal_sides_02",
			change_function = _common_frame_hover_change_function,
			visibility_function = _common_hover_visibility_function
		},
		{
			style_id = "frame",
			pass_type = "texture",
			value_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			change_function = _common_frame_hover_change_function
		},
		{
			style_id = "corner",
			pass_type = "texture",
			value_id = "corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			change_function = _common_frame_hover_change_function
		},
		{
			style_id = "icon",
			pass_type = "texture",
			value_id = "icon",
			value = "content/ui/materials/icons/achievements/achievement_icon_container",
			change_function = _common_icon_hover_change_function
		},
		{
			style_id = "label",
			value_id = "label",
			pass_type = "text"
		},
		{
			style_id = "description",
			value_id = "description",
			pass_type = "text"
		},
		{
			value_id = "score",
			style_id = "score",
			pass_type = "text",
			value = "000",
			style = pass_template_styles.score
		}
	}

	return pass_template
end

local _score_params = {}

local function _achievement_common_pass_template_init(widget_content, widget_style, config, selected_callback, achievement, ui_renderer)
	local label = achievement.label
	local description = achievement.description
	local label_style = widget_style.label
	local description_style = widget_style.description
	widget_content.element = config
	widget_content.label = label
	widget_content.description = description
	local score_params = _score_params
	score_params.score = achievement.score
	widget_content.score = Localize("loc_achievements_view_score", true, score_params)
	local icon_style = widget_style.icon
	local icon_material_values = icon_style.material_values
	icon_material_values.icon = achievement.icon
	local hotspot = widget_content.hotspot
	hotspot.selected_callback = selected_callback
	local _, label_height = _text_size(ui_renderer, label, label_style)

	if label_style.size[2] < label_height then
		label_style.size[2] = label_height
	else
		label_height = label_style.size[2]
	end

	description_style.offset[2] = label_style.offset[2] + label_height + description_style.offset[2]
	local _, description_height = _text_size(ui_renderer, description, description_style)

	if description_style.size[2] < description_height then
		description_style.size[2] = description_height
	else
		description_height = description_style.size[2]
	end

	local total_height = description_style.offset[2] + description_height

	return total_height
end

local _achievement_progress_bar_template = {
	{
		value = "content/ui/materials/backgrounds/default_square",
		value_id = "progress_bar_background",
		pass_type = "texture",
		style_id = "progress_bar_background"
	},
	{
		style_id = "progress_bar_frame",
		pass_type = "texture",
		value_id = "progress_bar_frame",
		value = "content/ui/materials/backgrounds/default_square",
		change_function = _common_frame_hover_change_function
	},
	{
		value = "content/ui/materials/bars/simple/fill",
		value_id = "progress_bar",
		pass_type = "texture",
		style_id = "progress_bar"
	},
	{
		value = "content/ui/materials/bars/simple/end",
		value_id = "progress_bar_edge",
		pass_type = "texture",
		style_id = "progress_bar_edge"
	},
	{
		value_id = "progress",
		style_id = "progress",
		pass_type = "text",
		value = "0/0",
		style = pass_template_styles.progress
	}
}

local function _add_progress_bar_template_style(style, achievement)
	table.merge(style, pass_template_styles.progress_bar)
end

local function _achievement_progress_bar_template_init(widget_content, widget_style, achievement, content_height)
	local goal = achievement.progress_goal
	local current_progress = math.min(achievement.progress_current, goal)
	local current_progress_normalized = current_progress / goal
	widget_content.progress = _format_progress(current_progress, goal)
	local background_style = widget_style.progress_bar_background
	local frame_style = widget_style.progress_bar_frame
	local bar_style = widget_style.progress_bar
	local edge_style = widget_style.progress_bar_edge
	local text_style = widget_style.progress
	local progress_bar_width = background_style.size[1] * current_progress_normalized
	local alpha_multiplier = math.clamp(progress_bar_width / -edge_style.relative_negative_offset_x, 0, 1)
	bar_style.size[1] = progress_bar_width
	edge_style.offset[1] = edge_style.offset[1] + progress_bar_width
	background_style.offset[2] = background_style.offset[2] + content_height
	frame_style.offset[2] = frame_style.offset[2] + content_height
	bar_style.offset[2] = bar_style.offset[2] + content_height
	edge_style.offset[2] = edge_style.offset[2] + content_height
	text_style.offset[2] = text_style.offset[2] + content_height
	edge_style.color[1] = 255 * alpha_multiplier

	return frame_style.offset[2] + frame_style.size[2]
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

local _achievement_foldout_pass_template = {
	{
		style_id = "arrow",
		pass_type = "rotated_texture",
		value_id = "arrow",
		value = "content/ui/materials/buttons/arrow_01",
		change_function = _common_frame_hover_change_function
	}
}

local function _achievement_foldout_pass_template_init(widget, widget_content, widget_style, achievement, parent, folded_height, unfolded_height)
	widget_content.size[2] = folded_height
	widget_content.folded_height = folded_height
	widget_content.unfolded_height = unfolded_height
	widget_content.unfolded = false

	local function fold_callback()
		local parent = parent
		local content = widget_content
		local unfolded = not content.unfolded
		content.unfolded = unfolded
		content.size[2] = unfolded and widget_content.unfolded_height or widget_content.folded_height
		local arrow_style = widget_style.arrow
		arrow_style.angle = math.degrees_to_radians(unfolded and 90 or -90)

		Managers.ui:play_2d_sound(unfolded and arrow_style.unfold_sound or arrow_style.fold_sound)
		parent:select_grid_widget(widget)
		parent:force_update_list_size()
	end

	widget_content.hotspot.pressed_callback = function ()
		local content = widget_content

		if not content.is_gamepad_active then
			fold_callback()
		end
	end

	widget_content.fold_callback = fold_callback
end

local _small_reward_icon_template = {
	{
		style_id = "reward_icon_small",
		pass_type = "texture",
		value_id = "reward_icon_small",
		value = "content/ui/materials/icons/achievements/achievement_icon_container",
		change_function = _common_icon_hover_change_function
	}
}

local function _small_reward_icon_template_init(widget_content, widget_style, reward_item)
	if not reward_item then
		return
	end

	widget_content.item = reward_item
	local reward_type_icon = ItemUtils.type_texture(reward_item)
	local small_reward_icon_style = widget_style.reward_icon_small
	local material_values = small_reward_icon_style.material_values
	material_values.icon = reward_type_icon
	local rarity = reward_item.rarity

	if rarity then
		local rarity_color, dark_rarity_color = ItemUtils.rarity_color(reward_item)
		small_reward_icon_style.color = table.clone(rarity_color)
	end
end

local function _apply_live_item_icon_cb_func(widget, item_id, grid_index, rows, columns, render_target)
	local widget_style = widget.style
	local widget_content = widget.content
	local icon_style = widget_style[item_id]
	widget_content[item_id] = "content/ui/materials/icons/items/containers/item_container_landscape"
	local material_values = icon_style.material_values
	material_values.use_placeholder_texture = 0
	material_values.use_render_target = 1
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
	material_values.render_target = render_target
	widget_content.use_placeholder_texture = material_values.use_placeholder_texture
end

local function _remove_live_item_icon_cb_func(widget, item_id, ui_renderer)
	if widget.content.visible then
		UIWidget.set_visible(widget, ui_renderer, false)
		UIWidget.set_visible(widget, ui_renderer, true)
	end

	local widget_style = widget.style
	local widget_content = widget.content
	local icon_style = widget_style[item_id]
	local material_values = icon_style.material_values
	material_values.use_placeholder_texture = 1
	material_values.use_render_target = 0
	material_values.rows = nil
	material_values.columns = nil
	material_values.grid_index = nil
	widget_content.use_placeholder_texture = material_values.use_placeholder_texture
	material_values.render_target = nil
	widget_content[item_id] = nil
end

local function _apply_live_nameplate_icon_cb_func(widget, item_id, item)
	local widget_style = widget.style
	local widget_content = widget.content
	local icon_style = widget_style[item_id]
	widget_content[item_id] = "content/ui/materials/icons/items/containers/item_container_square"
	local material_values = icon_style.material_values
	local item_slot = ItemUtils.item_slot(item)
	local icon_size = item_slot.item_icon_size
	material_values.texture_icon = item.icon
	material_values.icon_size = icon_size
	material_values.use_placeholder_texture = 0
	widget.content.use_placeholder_texture = material_values.use_placeholder_texture
end

local function _remove_live_nameplate_icon_cb_func(widget, item_id, ui_renderer)
	UIWidget.set_visible(widget, ui_renderer, false)
	UIWidget.set_visible(widget, ui_renderer, true)

	local widget_style = widget.style
	local widget_content = widget.content
	local icon_style = widget_style[item_id]
	local material_values = icon_style.material_values
	widget_content[item_id] = nil
	material_values.icon_size = nil
	material_values.texture_icon = nil
	material_values.use_placeholder_texture = 1
	widget.content.use_placeholder_texture = material_values.use_placeholder_texture
end

local function _reward_load_icon_func(parent, widget, config, ui_renderer)
	local content = widget.content
	local reward_ids = content.reward_ids
	local reward_items = content.reward_items
	local reward_groups = content.reward_groups

	if not reward_ids then
		return
	end

	local icon_load_ids = content.icon_load_ids

	if not icon_load_ids then
		icon_load_ids = {}
		content.icon_load_ids = icon_load_ids
	end

	for i = 1, #reward_ids do
		local reward_item_id = reward_ids[i]

		if not icon_load_ids[reward_item_id] then
			local reward_item = reward_items[i]
			local item_group = reward_groups[i]
			local slot_name = ItemUtils.slot_name(reward_item)
			local item_state_machine = reward_item.state_machine
			local item_animation_event = reward_item.animation_event
			local render_context = {
				camera_focus_slot_name = slot_name,
				state_machine = item_state_machine,
				animation_event = item_animation_event
			}
			local cb, unload_cb = nil

			if item_group == "nameplates" then
				cb = callback(_apply_live_nameplate_icon_cb_func, widget, reward_item_id)
				unload_cb = callback(_remove_live_nameplate_icon_cb_func, widget, reward_item_id, ui_renderer)
			elseif item_group == "weapon_skin" then
				cb = callback(_apply_live_item_icon_cb_func, widget, reward_item_id)
				unload_cb = callback(_remove_live_item_icon_cb_func, widget, reward_item_id, ui_renderer)
				reward_item = ItemUtils.weapon_skin_preview_item(reward_item)
			else
				cb = callback(_apply_live_item_icon_cb_func, widget, reward_item_id)
				unload_cb = callback(_remove_live_item_icon_cb_func, widget, reward_item_id, ui_renderer)
			end

			icon_load_ids[reward_item_id] = Managers.ui:load_item_icon(reward_item, cb, render_context, nil, nil, unload_cb)
		end
	end
end

local function _reward_unload_icon_func(parent, widget, element, ui_renderer)
	local content = widget.content
	local icon_load_ids = content.icon_load_ids

	if icon_load_ids then
		local ui_manager = Managers.ui

		for item_id, load_id in pairs(icon_load_ids) do
			ui_manager:unload_item_icon(load_id)
		end

		content.icon_load_ids = nil
	end
end

local function _add_reward_pass_template(pass_template, config)
	local reward_item = config.reward_item

	if not reward_item then
		return
	end

	table.append(pass_template, _small_reward_icon_template)
	table.append(pass_template, {
		{
			style_id = "reward_icon_frame",
			pass_type = "texture",
			value_id = "reward_icon_frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			change_function = _common_frame_hover_change_function,
			visibility_function = _foldout_visibility_function
		},
		{
			value_id = "reward_icon_background",
			style_id = "reward_icon_background",
			pass_type = "texture",
			value = "content/ui/materials/gradients/gradient_vertical",
			visibility_function = _foldout_visibility_function
		},
		{
			value_id = "reward_icon",
			style_id = "reward_icon",
			pass_type = "texture",
			visibility_function = function (content, style)
				return _foldout_visibility_function(content, style) and content.reward_icon
			end
		},
		{
			value_id = "reward_label",
			style_id = "reward_label",
			pass_type = "text",
			value = Localize("loc_achievements_view_reward_label"),
			visibility_function = _foldout_visibility_function
		},
		{
			style_id = "reward_display_name",
			value_id = "reward_display_name",
			pass_type = "text",
			visibility_function = _foldout_visibility_function
		},
		{
			style_id = "reward_sub_display_name",
			value_id = "reward_sub_display_name",
			pass_type = "text",
			visibility_function = _foldout_visibility_function
		}
	})
end

local function _add_reward_pass_style(style, config)
	local reward_item = config.reward_item

	if not reward_item then
		return
	end

	table.merge(style, pass_template_styles.rewards)
end

local function _reward_detail_pass_template_init(widget_content, widget_style, achievement, parent, config, folded_height, ui_renderer)
	local reward_item = config.reward_item

	if not reward_item then
		return folded_height
	end

	_small_reward_icon_template_init(widget_content, widget_style, reward_item)

	local reward_item_margin = pass_template_styles.reward_item_margins[2]
	local offset_y = folded_height
	local reward_item_group = config.reward_item_group
	widget_content.reward_ids = {
		"reward_icon"
	}
	widget_content.reward_items = {
		reward_item
	}
	widget_content.reward_groups = {
		reward_item_group
	}
	local display_name = ItemUtils.display_name(reward_item)
	local item_type = ItemUtils.type_display_name(reward_item)
	widget_content.reward_display_name = display_name
	local reward_icon_frame_style = widget_style.reward_icon_frame
	local reward_icon_frame_offset = reward_icon_frame_style.offset
	local top_margin = reward_icon_frame_offset[2]
	reward_icon_frame_offset[2] = reward_icon_frame_offset[2] + offset_y
	local reward_icon_background_style = widget_style.reward_icon_background
	local reward_icon_background_offset = reward_icon_background_style.offset
	reward_icon_background_offset[2] = reward_icon_background_offset[2] + offset_y
	local rarity = reward_item.rarity

	if rarity then
		local rarity_color, dark_rarity_color = ItemUtils.rarity_color(reward_item)
		widget_style.reward_icon_background.color = table.clone(dark_rarity_color)
		local rarity_display_name = ItemUtils.rarity_display_name(reward_item)
		widget_content.reward_sub_display_name = string.format("{#color(%d, %d, %d)}%s{#reset()} • %s", rarity_color[2], rarity_color[3], rarity_color[4], rarity_display_name, item_type)
	else
		widget_content.reward_sub_display_name = item_type
	end

	local reward_icon_style = widget_style.reward_icon
	reward_icon_style.use_placeholder_texture = 1
	reward_icon_style.offset[2] = reward_icon_style.offset[2] + offset_y
	local reward_label_offset = widget_style.reward_label.offset
	reward_label_offset[2] = reward_label_offset[2] + offset_y
	local reward_display_name_style = widget_style.reward_display_name
	local reward_display_name_offset = reward_display_name_style.offset
	reward_display_name_offset[2] = reward_display_name_offset[2] + offset_y
	local _, display_name_height = _text_size(ui_renderer, display_name, reward_display_name_style)
	local reward_sub_display_name_offset = widget_style.reward_sub_display_name.offset
	reward_sub_display_name_offset[2] = reward_sub_display_name_offset[2] + display_name_height + offset_y
	offset_y = offset_y + top_margin + reward_icon_frame_style.size[2] + reward_item_margin

	return offset_y
end

local function _add_meta_sub_achievements_pass_template(pass_template, config)
	local sub_achievements = config.sub_achievements

	if not sub_achievements or not sub_achievements[1] then
		return
	end

	local num_sub_achievements = #sub_achievements

	for i = 1, num_sub_achievements do
		local sub_achievement_icon_name = "sub_icon_" .. i
		local sub_label_name = "sub_label_" .. i

		table.append(pass_template, {
			{
				pass_type = "texture",
				value = "content/ui/materials/icons/achievements/achievement_icon_container",
				value_id = sub_achievement_icon_name,
				style_id = sub_achievement_icon_name,
				change_function = _common_icon_hover_change_function,
				visibility_function = _foldout_visibility_function
			},
			{
				pass_type = "text",
				value_id = sub_label_name,
				style_id = sub_label_name,
				visibility_function = _foldout_visibility_function
			}
		})
	end
end

local function _add_meta_sub_achievements_pass_style(style, config)
	local sub_achievements = config.sub_achievements

	if not sub_achievements then
		return
	end

	local pass_styles = pass_template_styles.meta_sub_achievements
	local num_sub_achievements = #sub_achievements

	for i = 1, num_sub_achievements do
		for pass_id, pass_style in pairs(pass_styles) do
			local style_id = string.format("%s_%d", pass_id, i)
			style[style_id] = pass_style
		end
	end
end

local function _sub_meta_achievements_pass_template_init(widget_content, widget_style, achievement, parent, config, folded_height)
	local sub_achievements = config.sub_achievements

	if not sub_achievements then
		return folded_height
	end

	local sub_achievement_margin = pass_template_styles.meta_sub_achievement_margins[2]
	local sub_achievement_offset_y = folded_height

	for i = 1, #sub_achievements do
		local sub_achievement = sub_achievements[i]
		local sub_achievement_completed = sub_achievement.completed
		local sub_label_name = "sub_label_" .. i
		widget_content[sub_label_name] = sub_achievement.label
		local sub_label_style = widget_style[sub_label_name]
		sub_label_style.offset[2] = sub_label_style.offset[2] + sub_achievement_offset_y
		local sub_achievement_icon_name = "sub_icon_" .. i
		local icon_style = widget_style[sub_achievement_icon_name]
		local icon_offset = icon_style.offset
		icon_offset[2] = icon_offset[2] + sub_achievement_offset_y
		local icon_material_values = icon_style.material_values
		icon_material_values.icon = sub_achievement.icon

		if sub_achievement_completed then
			icon_style.icon_default_color = icon_style.icon_completed_color
			icon_style.icon_hover_color = icon_style.icon_completed_hover_color
			icon_style.icon_selected_color = icon_style.icon_completed_selected_color
			icon_material_values.frame = icon_style.completed_frame
			sub_label_style.offset[3] = sub_label_style.completed_layer
			sub_label_style.text_color = sub_label_style.completed_color
		end

		sub_achievement_offset_y = icon_offset[2] + icon_style.size[2]
	end

	local unfolded_height = sub_achievement_offset_y + sub_achievement_margin

	return unfolded_height
end

local function _add_family_sub_achievements_pass_template(pass_template, config)
	local sub_achievements = config.sub_achievements

	table.append(pass_template, {
		{
			value_id = "group_label",
			style_id = "group_label",
			pass_type = "text",
			value = Localize("loc_achievements_view_family_label"),
			visibility_function = _foldout_visibility_function
		}
	})

	local num_sub_achievements = #sub_achievements

	for i = 1, num_sub_achievements do
		local sub_achievement_icon_name = "sub_icon_" .. i
		local sub_score_name = "sub_score_" .. i

		table.append(pass_template, {
			{
				pass_type = "texture",
				value = "content/ui/materials/icons/achievements/achievement_icon_container",
				value_id = sub_achievement_icon_name,
				style_id = sub_achievement_icon_name,
				change_function = _common_icon_hover_change_function,
				visibility_function = _foldout_visibility_function
			},
			{
				pass_type = "text",
				value_id = sub_score_name,
				style_id = sub_score_name,
				visibility_function = _foldout_visibility_function
			}
		})
	end
end

local function _add_family_sub_achievements_pass_style(style, config)
	local sub_achievements = config.sub_achievements

	table.merge(style, pass_template_styles.achievement_family)

	local pass_styles = pass_template_styles.family_sub_achievements
	local num_sub_achievements = #sub_achievements

	for i = 1, num_sub_achievements do
		for pass_id, pass_style in pairs(pass_styles) do
			local style_id = string.format("%s_%d", pass_id, i)
			style[style_id] = pass_style
		end
	end
end

local function _family_sub_achievements_pass_template_init(widget_content, widget_style, achievement, parent, config, folded_height)
	local sub_achievements = config.sub_achievements
	local score_params = _score_params
	local sub_achievement_margins = pass_template_styles.family_sub_achievement_margins
	local sub_achievement_offset_x = sub_achievement_margins[1]
	local sub_achievement_offset_y = folded_height
	local group_label_style = widget_style.group_label
	local group_label_offset = group_label_style.offset
	group_label_offset[2] = group_label_offset[2] + sub_achievement_offset_y
	local total_score = 0

	for i = 1, #sub_achievements do
		local sub_achievement = sub_achievements[i]
		sub_achievement_offset_y = group_label_offset[2] + group_label_style.size[2]
		local sub_achievement_icon_name = "sub_icon_" .. i
		local icon_style = widget_style[sub_achievement_icon_name]
		local icon_offset = icon_style.offset
		sub_achievement_offset_x = sub_achievement_offset_x + icon_offset[1]
		sub_achievement_offset_y = sub_achievement_offset_y + icon_offset[2]
		icon_offset[1] = sub_achievement_offset_x
		icon_offset[2] = sub_achievement_offset_y
		sub_achievement_offset_y = sub_achievement_offset_y + icon_style.size[2]
		local sub_score_name = "sub_score_" .. i
		local sub_achievement_score = sub_achievement.score
		score_params.score = sub_achievement_score
		widget_content[sub_score_name] = Localize("loc_achievements_view_score", true, _score_params)
		local sub_label_style = widget_style[sub_score_name]
		local sub_label_style_offset = sub_label_style.offset
		sub_achievement_offset_y = sub_achievement_offset_y + sub_label_style_offset[2]
		sub_label_style_offset[1] = sub_achievement_offset_x
		sub_label_style_offset[2] = sub_achievement_offset_y
		sub_achievement_offset_y = sub_achievement_offset_y + sub_label_style.size[2]
		local icon_material_values = icon_style.material_values
		icon_material_values.icon = sub_achievement.icon

		if sub_achievement.completed then
			total_score = total_score + sub_achievement_score
			icon_style.icon_default_color = icon_style.icon_completed_color
			icon_style.icon_hover_color = icon_style.icon_completed_hover_color
			icon_style.icon_selected_color = icon_style.icon_completed_selected_color
			icon_material_values.frame = icon_style.completed_frame
		end

		sub_achievement_offset_x = sub_achievement_offset_x + icon_style.size[1]
	end

	score_params.score = total_score
	widget_content.score = Localize("loc_achievements_view_score", true, _score_params)
	local unfolded_height = sub_achievement_offset_y + sub_achievement_margins[2]

	return unfolded_height
end

local function _add_family_rewards_pass_template(pass_template, config)
	local sub_achievements = config.sub_achievements
	local reward_count = 0
	local show_small_icon = false
	local step_param = {}
	local num_sub_achievements = #sub_achievements

	for i = 1, num_sub_achievements do
		local achievement = sub_achievements[i]
		local reward_item, item_group = _get_reward_item(achievement)

		if reward_item then
			reward_count = reward_count + 1
			local name_prefix = string.format("reward_%d_", reward_count)
			step_param.step = i

			table.append(pass_template, {
				{
					pass_type = "texture",
					value = "content/ui/materials/frames/frame_tile_2px",
					value_id = name_prefix .. "icon_frame",
					style_id = name_prefix .. "icon_frame",
					change_function = _common_frame_hover_change_function,
					visibility_function = _foldout_visibility_function
				},
				{
					pass_type = "texture",
					value = "content/ui/materials/gradients/gradient_vertical",
					value_id = name_prefix .. "icon_background",
					style_id = name_prefix .. "icon_background",
					visibility_function = _foldout_visibility_function
				},
				{
					pass_type = "texture",
					value_id = name_prefix .. "icon",
					style_id = name_prefix .. "icon",
					visibility_function = function (content, style)
						return _foldout_visibility_function(content, style) and content[name_prefix .. "icon"]
					end
				},
				{
					pass_type = "text",
					value_id = name_prefix .. "label",
					style_id = name_prefix .. "label",
					value = Localize("loc_achievements_view_family_reward_label", true, step_param),
					visibility_function = _foldout_visibility_function
				},
				{
					pass_type = "text",
					value_id = name_prefix .. "display_name",
					style_id = name_prefix .. "display_name",
					visibility_function = _foldout_visibility_function
				},
				{
					pass_type = "text",
					value_id = name_prefix .. "sub_display_name",
					style_id = name_prefix .. "sub_display_name",
					visibility_function = _foldout_visibility_function
				}
			})

			if achievement.completed then
				show_small_icon = true
			else
				table.append(pass_template, {
					{
						pass_type = "text",
						value = "",
						value_id = name_prefix .. "lock",
						style_id = name_prefix .. "lock",
						change_function = _common_frame_hover_change_function,
						visibility_function = _foldout_visibility_function
					}
				})
			end
		end
	end

	if show_small_icon then
		table.append(pass_template, _small_reward_icon_template)
	end
end

local function _add_family_rewards_pass_style(style, config)
	local sub_achievements = config.sub_achievements
	local pass_styles = pass_template_styles.achievement_family_reward
	local reward_count = 0
	local show_small_icon = false
	local num_sub_achievements = #sub_achievements

	for i = 1, num_sub_achievements do
		local achievement = sub_achievements[i]
		local reward_item = _get_reward_item(achievement)

		if reward_item then
			reward_count = reward_count + 1

			for pass_id, pass_style in pairs(pass_styles) do
				local style_id = string.format("reward_%d_%s", reward_count, pass_id)
				style[style_id] = pass_style
			end

			if achievement.completed then
				show_small_icon = true
			end
		end
	end

	if show_small_icon then
		style.reward_icon_small = pass_template_styles.rewards.reward_icon_small
	end
end

local function _family_sub_rewards_pass_template_init(widget_content, widget_style, achievement, parent, config, folded_height)
	local sub_achievements = config.sub_achievements
	local num_columns = 2
	local current_column = 1
	local sub_reward_margins = pass_template_styles.family_sub_reward_margins
	local rewards_offset_x = sub_reward_margins[1]
	local rewards_offset_y = folded_height - sub_reward_margins[2]
	local rewards_height = rewards_offset_y
	local reward_count = 0
	local reward_ids = {}
	local reward_items = {}
	local reward_item_groups = {}
	local small_icon_item = nil

	for i = 1, #sub_achievements do
		local sub_achievement = sub_achievements[i]
		local reward_item, item_groups = _get_reward_item(sub_achievement)

		if reward_item then
			reward_count = reward_count + 1
			local reward_icon_name = string.format("reward_%d_icon", reward_count)
			reward_ids[reward_count] = reward_icon_name
			reward_items[reward_count] = reward_item
			reward_item_groups[reward_count] = item_groups
			local icon_style = widget_style[reward_icon_name]
			local icon_offset = icon_style.offset
			icon_offset[1] = rewards_offset_x + icon_offset[1]
			icon_offset[2] = rewards_offset_y + icon_offset[2]
			local reward_icon_background_name = string.format("reward_%d_icon_background", reward_count)
			local icon_background_style = widget_style[reward_icon_background_name]
			local icon_background_offset = icon_background_style.offset
			icon_background_offset[1] = icon_offset[1]
			icon_background_offset[2] = icon_offset[2]
			local reward_icon_frame_name = string.format("reward_%d_icon_frame", reward_count)
			local frame_style = widget_style[reward_icon_frame_name]
			local frame_offset = frame_style.offset
			frame_offset[1] = rewards_offset_x + frame_offset[1]
			frame_offset[2] = rewards_offset_y + frame_offset[2]
			local reward_label_name = string.format("reward_%d_label", reward_count)
			local label_style = widget_style[reward_label_name]
			local label_offset = label_style.offset
			label_offset[1] = rewards_offset_x + label_offset[1]
			label_offset[2] = rewards_offset_y + label_offset[2]
			local reward_display_name_id = string.format("reward_%d_display_name", reward_count)
			widget_content[reward_display_name_id] = ItemUtils.display_name(reward_item)
			local display_name_style = widget_style[reward_display_name_id]
			local display_name_offset = display_name_style.offset
			display_name_offset[1] = rewards_offset_x + display_name_offset[1]
			display_name_offset[2] = rewards_offset_y + display_name_offset[2]
			local reward_sub_display_name_id = string.format("reward_%d_sub_display_name", reward_count)
			local sub_display_name_style = widget_style[reward_sub_display_name_id]
			local sub_display_name_offset = sub_display_name_style.offset
			sub_display_name_offset[1] = rewards_offset_x + sub_display_name_offset[1]
			sub_display_name_offset[2] = rewards_offset_y + sub_display_name_offset[2]
			local rarity = reward_item.rarity
			local item_type = ItemUtils.type_display_name(reward_item)

			if rarity then
				local rarity_color, dark_rarity_color = ItemUtils.rarity_color(reward_item)
				icon_background_style.color = table.clone(dark_rarity_color)
				local rarity_display_name = ItemUtils.rarity_display_name(reward_item)
				widget_content[reward_sub_display_name_id] = string.format("{#color(%d, %d, %d)}%s{#reset()} • %s", rarity_color[2], rarity_color[3], rarity_color[4], rarity_display_name, item_type)
			else
				widget_content[reward_sub_display_name_id] = item_type
			end

			if sub_achievement.completed then
				small_icon_item = reward_item
			else
				local reward_lock_name = string.format("reward_%d_lock", reward_count)
				local lock_style = widget_style[reward_lock_name]
				local lock_offset = lock_style.offset
				lock_offset[1] = rewards_offset_x + lock_offset[1]
				lock_offset[2] = rewards_offset_y + lock_offset[2]
			end

			if current_column < num_columns then
				current_column = current_column + 1
				rewards_offset_x = display_name_offset[1] + display_name_style.size[1]
				rewards_height = icon_offset[2] + icon_style.size[2]
			else
				current_column = 1
				rewards_offset_x = sub_reward_margins[1]
				rewards_offset_y = rewards_height
			end
		end
	end

	if reward_count > 0 then
		widget_content.reward_ids = reward_ids
		widget_content.reward_items = reward_items
		widget_content.reward_groups = reward_item_groups
	end

	if small_icon_item then
		_small_reward_icon_template_init(widget_content, widget_style, small_icon_item)
	end

	local unfolded_height = rewards_height + sub_reward_margins[2]

	return unfolded_height
end

local _in_progress_overlay_pass_template = {
	{
		style_id = "in_progress_overlay",
		value_id = "in_progress_overlay",
		pass_type = "rect"
	}
}

local function _category_common_pass_templates_init(parent, widget, config, callback_name, secondary_callback_name, ui_renderer)
	local category = config.category
	local content = widget.content
	local label = category and category.label or config.label
	content.text = Localize(label)
	content.category = category

	if category then
		category.widget = widget
		category.has_sub_categories = config.has_sub_categories
	end

	local hotspot = content.hotspot
	hotspot.pressed_callback = callback(parent, callback_name, widget, config, category and category.id)
	hotspot.selected_callback = callback(config.selected_callback, widget, config, category and category.id)
end

achievements_view_blueprints.list_padding = {
	size = blueprint_styles.list_padding.size
}
achievements_view_blueprints.category_list_padding_top = {
	size = blueprint_styles.category_list_padding_top.size,
	pass_template = ButtonPassTemplates.terminal_list_divider
}
achievements_view_blueprints.category_list_padding_bottom = {
	size = blueprint_styles.category_list_padding_bottom.size
}
achievements_view_blueprints.simple_category_button = {
	size = table.clone(blueprint_styles.simple_category_button.size),
	pass_template = table.clone(ButtonPassTemplates.terminal_list_button),
	style = blueprint_styles.simple_category_button,
	init = _category_common_pass_templates_init
}
local _category_foldout_pass_template = {
	{
		style_id = "arrow",
		pass_type = "rotated_texture",
		value_id = "arrow",
		value = "content/ui/materials/buttons/arrow_01",
		change_function = ButtonPassTemplates.terminal_list_button_frame_hover_change_function
	}
}
achievements_view_blueprints.top_category_button = {
	size = blueprint_styles.top_category_button.size,
	pass_template_function = function (parent, config)
		local pass_templates = table.clone(ButtonPassTemplates.terminal_list_button)

		table.append(pass_templates, _category_foldout_pass_template)

		return pass_templates
	end,
	style = blueprint_styles.top_category_button,
	init = _category_common_pass_templates_init
}
achievements_view_blueprints.sub_category_button = {
	size = blueprint_styles.sub_category_button.size,
	pass_template = table.clone(ButtonPassTemplates.terminal_list_button),
	style = blueprint_styles.sub_category_button,
	init = function (parent, widget, config, callback_name, secondary_callback_name, ui_renderer)
		_category_common_pass_templates_init(parent, widget, config, callback_name, secondary_callback_name, ui_renderer)

		local widget_content = widget.content
		widget_content.parent_widget = config.parent_category.widget
		widget.visible = false
	end
}
achievements_view_blueprints.header = {
	size = blueprint_styles.header.size,
	pass_template = {
		{
			style_id = "label",
			value_id = "label",
			pass_type = "text"
		},
		{
			value = "content/ui/materials/dividers/skull_left_01",
			value_id = "divider_left",
			pass_type = "texture_uv",
			style_id = "divider_left"
		},
		{
			value = "content/ui/materials/dividers/skull_left_01",
			value_id = "divider_right",
			pass_type = "texture",
			style_id = "divider_right"
		}
	},
	style = blueprint_styles.header,
	init = function (parent, widget, config, callback_name, secondary_callback_name, ui_renderer)
		local label = TextUtilities.localize_to_upper(config.display_name)
		local content = widget.content
		content.label = label
		local style = widget.style
		local label_style = style.label
		local label_width = _text_size(ui_renderer, label, label_style)
		local divider_left_style = style.divider_left
		local divider_width = divider_left_style.size[1] - math.floor(label_width / 2)
		divider_left_style.size[1] = divider_width
		local divider_right_style = style.divider_right
		divider_right_style.size[1] = divider_width
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
		local pass_template = _get_achievement_common_pass_templates(config.is_summary)

		if not config.completed then
			table.append(pass_template, _in_progress_overlay_pass_template)

			local achievement_type = achievement.type

			if achievement_type == achievement_types.increasing_stat then
				table.append(pass_template, _achievement_progress_bar_template)
			elseif achievement_type == achievement_types.time_trial then
				table.append(pass_template, _achievement_time_trial_template)
			end
		end

		if config.reward_item then
			table.append(pass_template, _small_reward_icon_template)
		end

		return pass_template
	end,
	style_function = function (parent, config)
		local achievement_types = AchievementUITypes
		local achievement = config.achievement
		local is_completed = config.completed
		local style = is_completed and table.clone(blueprint_styles.completed_achievement) or table.clone(blueprint_styles.normal_achievement)

		if config.reward_item then
			style.reward_icon_small = pass_template_styles.rewards.reward_icon_small
		end

		local achievement_type = achievement.type

		if achievement_type == achievement_types.increasing_stat and not is_completed then
			_add_progress_bar_template_style(style, achievement)
		end

		return style
	end,
	init = function (parent, widget, config, callback_name, secondary_callback_name, ui_renderer)
		local achievement_types = AchievementUITypes
		local achievement = config.achievement
		local is_completed = config.completed
		local content = widget.content
		local style = widget.style
		content.hotspot.disabled = config.is_summary
		local content_height = _achievement_common_pass_template_init(content, style, config, config.selected_callback, achievement, ui_renderer)

		_small_reward_icon_template_init(content, style, config.reward_item)

		local achievement_type = achievement.type

		if achievement_type == achievement_types.increasing_stat and not is_completed then
			content_height = _achievement_progress_bar_template_init(content, style, achievement, content_height)
		end

		content_height = content_height + ViewStyles.achievement_margins[2]

		if content.size[2] < content_height then
			content.size[2] = content_height
		end
	end
}
achievements_view_blueprints.foldout_achievement = {
	size = blueprint_styles.foldout_achievement.size,
	pass_template_function = function (parent, config)
		local achievement_types = AchievementUITypes
		local achievement = config.achievement
		local achievement_type = achievement.type
		local is_completed = config.completed
		local pass_template = _get_achievement_common_pass_templates()

		table.append(pass_template, _achievement_foldout_pass_template)

		if not config.completed then
			table.append(pass_template, _in_progress_overlay_pass_template)

			if achievement_type == achievement_types.increasing_stat then
				table.append(pass_template, _achievement_progress_bar_template)
			end
		end

		if achievement_type == achievement_types.meta then
			_add_meta_sub_achievements_pass_template(pass_template, config)
			_add_reward_pass_template(pass_template, config)
		elseif config.sub_achievements then
			local first_completed = config.sub_achievements[1] and config.sub_achievements[1].completed

			if is_completed or not first_completed then
				_add_family_sub_achievements_pass_template(pass_template, config)
				_add_family_rewards_pass_template(pass_template, config)
			end
		else
			_add_reward_pass_template(pass_template, config)
		end

		return pass_template
	end,
	style_function = function (parent, config)
		local achievement_types = AchievementUITypes
		local achievement = config.achievement
		local is_completed = config.completed
		local style = nil

		if not is_completed then
			style = table.clone(blueprint_styles.foldout_achievement)
			style.in_progress_overlay = pass_template_styles.completed_overlay
			local achievement_type = achievement.type

			if achievement_type == achievement_types.increasing_stat then
				_add_progress_bar_template_style(style, achievement)
			end
		else
			style = table.clone(blueprint_styles.completed_foldout_achievement)
		end

		local achievement_type = achievement.type

		if achievement_type == achievement_types.meta then
			_add_meta_sub_achievements_pass_style(style, config)
			_add_reward_pass_style(style, config)
		elseif config.sub_achievements then
			local first_completed = config.sub_achievements[1] and config.sub_achievements[1].completed

			if is_completed or not first_completed then
				_add_family_sub_achievements_pass_style(style, config)
				_add_family_rewards_pass_style(style, config)
			end
		else
			_add_reward_pass_style(style, config)
		end

		return style
	end,
	init = function (parent, widget, config, callback_name, secondary_callback_name, ui_renderer)
		local achievement_types = AchievementUITypes
		local achievement = config.achievement
		local is_completed = config.completed
		local widget_content = widget.content
		local widget_style = widget.style
		local folded_height = _achievement_common_pass_template_init(widget_content, widget_style, config, config.selected_callback, achievement, ui_renderer)
		local achievement_type = achievement.type

		if achievement_type == achievement_types.increasing_stat and not is_completed then
			folded_height = _achievement_progress_bar_template_init(widget_content, widget_style, achievement, folded_height)
		end

		folded_height = folded_height + ViewStyles.achievement_margins[2]

		if widget_content.size[2] < folded_height then
			widget_content.size[2] = folded_height
		else
			folded_height = widget_content.size[2]
		end

		local unfolded_height = folded_height

		if achievement_type == achievement_types.meta then
			unfolded_height = _sub_meta_achievements_pass_template_init(widget_content, widget_style, achievement, parent, config, unfolded_height)
			unfolded_height = _reward_detail_pass_template_init(widget_content, widget_style, achievement, parent, config, unfolded_height, ui_renderer)
		elseif config.sub_achievements then
			local first_completed = config.sub_achievements[1] and config.sub_achievements[1].completed

			if is_completed or not first_completed then
				unfolded_height = _family_sub_achievements_pass_template_init(widget_content, widget_style, achievement, parent, config, unfolded_height)
				unfolded_height = _family_sub_rewards_pass_template_init(widget_content, widget_style, achievement, parent, config, unfolded_height)
			end
		else
			unfolded_height = _reward_detail_pass_template_init(widget_content, widget_style, achievement, parent, config, unfolded_height, ui_renderer)
		end

		_achievement_foldout_pass_template_init(widget, widget_content, widget_style, achievement, parent, folded_height, unfolded_height)
	end,
	load_icon = _reward_load_icon_func,
	unload_icon = _reward_unload_icon_func,
	destroy = _reward_unload_icon_func
}

return settings("AchievementsViewBlueprints", achievements_view_blueprints)
