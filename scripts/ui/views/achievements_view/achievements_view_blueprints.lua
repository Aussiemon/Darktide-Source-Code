local AchievementFlags = require("scripts/settings/achievements/achievement_flags")
local AchievementTypes = require("scripts/managers/achievements/achievement_types")
local AchievementUIHelper = require("scripts/managers/achievements/utility/achievement_ui_helper")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local ItemUtils = require("scripts/utilities/items")
local StatDefinitions = require("scripts/managers/stats/stat_definitions")
local TextUtilities = require("scripts/utilities/ui/text")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewStyles = require("scripts/ui/views/achievements_view/achievements_view_styles")
local _color_lerp = ColorUtilities.color_lerp
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

local _text_extra_options = {}

local function _text_size(ui_renderer, text, style)
	local text_extra_options = _text_extra_options

	table.clear(text_extra_options)
	UIFonts.get_font_options_by_style(style, text_extra_options)

	local width, height, min = UIRenderer.text_size(ui_renderer, text, style.font_type, style.font_size, style.size, text_extra_options)

	return _math_round(width), _math_round(height + min[2]), min
end

local function _text_height(ui_renderer, text, style)
	local text_extra_options = _text_extra_options

	table.clear(text_extra_options)
	UIFonts.get_font_options_by_style(style, text_extra_options)

	local height = UIRenderer.text_height(ui_renderer, text, style.font_type, style.font_size, style.size, text_extra_options)

	return _math_round(height)
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

local function _block_on_gamepad(widget_content, callback_function)
	return function ()
		if not widget_content.is_gamepad_active then
			callback_function()
		end
	end
end

local achievements_view_blueprints = {}
local _in_progress_overlay_pass_template = {
	{
		style_id = "in_progress_overlay",
		value_id = "in_progress_overlay",
		pass_type = "rect"
	},
	{
		value = "content/ui/materials/icons/generic/bookmark",
		style_id = "bookmark",
		pass_type = "texture"
	}
}

local function _achievement_background_hover_change_function(content, style)
	local hotspot = content.hotspot
	local hover_progress = _math_max(hotspot.anim_hover_progress, hotspot.anim_focus_progress)
	local color = style.color
	local alpha = style.alpha or 1
	color[1] = alpha * hover_progress
end

local function _get_achievement_common_pass_templates(is_complete)
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

	if not is_complete then
		table.append(pass_template, _in_progress_overlay_pass_template)
	end

	return pass_template
end

local function _achievement_set_favorite(is_favorite, widget_content, widget_style, config, ui_renderer)
	widget_style.bookmark.visible = is_favorite
	widget_content.is_favorite = is_favorite
end

local function _achievement_change_favorite(widget_content, widget_style, config, ui_renderer)
	local achievement_definition = config.achievement_definition
	local achievement_id = achievement_definition.id
	local is_favorite = AchievementUIHelper.is_favorite_achievement(achievement_id)
	local is_complete = config.is_complete
	local did_change = false

	if is_favorite then
		did_change = AchievementUIHelper.remove_favorite_achievement(achievement_id)
	elseif not is_complete then
		did_change = AchievementUIHelper.add_favorite_achievement(achievement_id)
	end

	if did_change then
		_achievement_set_favorite(not is_favorite, widget_content, widget_style, config, ui_renderer)
	end
end

local _score_params = {}

local function _achievement_common_pass_template_init(widget_content, widget_style, config, ui_renderer)
	local achievement_definition = config.achievement_definition
	local hotspot = widget_content.hotspot
	hotspot.on_hover_sound = UISoundEvents.default_mouse_hover
	hotspot.on_select_sound = nil
	local is_complete = config.is_complete
	local is_favorite = AchievementUIHelper.is_favorite_achievement(achievement_definition.id)

	if not is_complete or is_favorite then
		_achievement_set_favorite(is_favorite, widget_content, widget_style, config, ui_renderer)

		local change_favorite_callback = callback(_achievement_change_favorite, widget_content, widget_style, config, ui_renderer)
		widget_content.change_favorite_callback = change_favorite_callback
		hotspot.right_pressed_callback = _block_on_gamepad(widget_content, change_favorite_callback)
	end

	local label = AchievementUIHelper.localized_title(achievement_definition)
	local description = AchievementUIHelper.localized_description(achievement_definition)
	local label_style = widget_style.label
	local description_style = widget_style.description
	widget_content.label = label
	widget_content.description = description
	local score_params = _score_params
	score_params.score = achievement_definition.score

	if not score_params.score then
		Log.error("_achievement_common_pass_template_init", "Achievement %s does not have a defined score", achievement_definition.id)

		score_params.score = 0
	end

	widget_content.score = Localize("loc_achievements_view_score", true, score_params)
	local icon_style = widget_style.icon
	local icon_material_values = icon_style.material_values
	icon_material_values.icon = achievement_definition.icon
	local label_height = _text_height(ui_renderer, label, label_style)

	if label_style.size[2] < label_height then
		label_style.size[2] = label_height
	else
		label_height = label_style.size[2]
	end

	description_style.offset[2] = label_style.offset[2] + label_height + description_style.offset[2]
	local description_height = _text_height(ui_renderer, description, description_style)

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
		value = "0/0",
		value_id = "progress",
		pass_type = "text",
		style_id = "progress"
	}
}

local function _add_progress_bar_template_style(style, achievement)
	table.merge(style, pass_template_styles.progress_bar)
end

local function _achievement_progress_bar_template_init(widget_content, widget_style, config, content_height)
	local player = config.player
	local achievement_definition = config.achievement_definition
	local achievement_type_name = achievement_definition.type
	local achievement_type = AchievementTypes[achievement_type_name]
	local progress, goal = achievement_type.get_progress(achievement_definition, player)
	progress = math.min(progress, goal)
	widget_content.progress = _format_progress(progress, goal)
	local normalized_progress = progress / goal
	local background_style = widget_style.progress_bar_background
	local frame_style = widget_style.progress_bar_frame
	local bar_style = widget_style.progress_bar
	local edge_style = widget_style.progress_bar_edge
	local text_style = widget_style.progress
	local progress_bar_width = background_style.size[1] * normalized_progress
	local alpha_multiplier = math.clamp01(-progress_bar_width / edge_style.relative_negative_offset_x)
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

local function _achievement_foldout_pass_template_init(widget, widget_content, widget_style, config, parent, folded_height, unfolded_height)
	widget_content.size[2] = folded_height
	widget_content.folded_height = folded_height
	widget_content.unfolded_height = unfolded_height
	widget_content.unfolded = false

	local function fold_callback()
		local content = widget_content
		local unfolded = not content.unfolded
		content.unfolded = unfolded
		content.size[2] = unfolded and widget_content.unfolded_height or widget_content.folded_height
		local arrow_style = widget_style.arrow
		arrow_style.angle = math.degrees_to_radians(unfolded and 90 or -90)

		Managers.ui:play_2d_sound(unfolded and arrow_style.unfold_sound or arrow_style.fold_sound)
		parent:force_update_list_size_keeping_scroll()
	end

	widget_content.hotspot.pressed_callback = _block_on_gamepad(widget_content, fold_callback)
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

local function _small_reward_icon_template_init(widget_content, widget_style, config)
	local achievement_definition = config.achievement_definition
	local reward_item = AchievementUIHelper.get_reward_item(achievement_definition)

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

	if item.icon_material and item.icon_material ~= "" then
		widget_content[item_id] = item.icon_material
		icon_style.old_icon_size = icon_style.size
		icon_style.size = icon_size
	else
		material_values.texture_icon = item.icon
		material_values.icon_size = icon_size
	end

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

	if icon_style.old_icon_size then
		icon_style.size = icon_style.old_icon_size
		icon_style.old_icon_size = nil
	end

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

			if item_group == "nameplates" or item_group == "titles" then
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

local function _add_foldout_reward_pass_template(pass_template, config)
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

local function _init_foldout_reward_pass_templates(widget_content, widget_style, config, unfolded_height, ui_renderer)
	local achievement_definition = config.achievement_definition
	local reward_item, reward_item_group = AchievementUIHelper.get_reward_item(achievement_definition)

	if not reward_item then
		return
	end

	local reward_item_margin = pass_template_styles.reward_item_margins[2]
	local offset_y = unfolded_height
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
	local display_name_height = _text_height(ui_renderer, display_name, reward_display_name_style)
	local reward_sub_display_name_offset = widget_style.reward_sub_display_name.offset
	reward_sub_display_name_offset[2] = reward_sub_display_name_offset[2] + display_name_height + offset_y
	offset_y = offset_y + top_margin + reward_icon_frame_style.size[2] + reward_item_margin

	return offset_y
end

local function _add_sub_achievements_pass_template(pass_template, config)
	local achievement_definition = config.achievement_definition
	local sub_achievements = achievement_definition.achievements

	for achievement_id, _ in pairs(sub_achievements) do
		local sub_achievement_icon_name = string.format("sub_icon_%s", achievement_id)
		local sub_label_name = string.format("sub_label_%s", achievement_id)

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

local function _add_sub_achievements_pass_style(style, config)
	local achievement_definition = config.achievement_definition
	local sub_achievements = achievement_definition.achievements
	local pass_styles = pass_template_styles.meta_sub_achievements

	for achievement_id, _ in pairs(sub_achievements) do
		local sub_achievement_icon_name = string.format("sub_icon_%s", achievement_id)
		local sub_label_name = string.format("sub_label_%s", achievement_id)
		style[sub_achievement_icon_name] = pass_styles.sub_icon
		style[sub_label_name] = pass_styles.sub_label
	end
end

local function _sub_achievements_pass_template_init(widget_content, widget_style, config, unfolded_height)
	local player = config.player
	local achievement_definition = config.achievement_definition
	local sub_achievements = achievement_definition.achievements
	local sub_achievement_margin = pass_template_styles.meta_sub_achievement_margins[2]
	local sub_achievement_offset_y = unfolded_height
	local achievements = Managers.achievements
	local achievement_definitions = achievements:achievement_definitions()

	for sub_achievement_id, _ in pairs(sub_achievements) do
		local sub_achievement = achievement_definitions[sub_achievement_id]

		if sub_achievement then
			local sub_achievement_completed = achievements:achievement_completed(player, sub_achievement_id)
			local sub_label_name = string.format("sub_label_%s", sub_achievement_id)
			widget_content[sub_label_name] = AchievementUIHelper.localized_title(sub_achievement)
			local sub_label_style = widget_style[sub_label_name]
			sub_label_style.offset[2] = sub_label_style.offset[2] + sub_achievement_offset_y
			local sub_achievement_icon_name = string.format("sub_icon_%s", sub_achievement_id)
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
	end

	unfolded_height = sub_achievement_offset_y + sub_achievement_margin

	return unfolded_height
end

local function _add_family_achievements_pass_template(pass_template, config)
	local achievement_definition = config.achievement_definition
	local family = AchievementUIHelper.get_family(achievement_definition)

	table.append(pass_template, {
		{
			value_id = "family_label",
			style_id = "family_label",
			pass_type = "text",
			value = Localize("loc_achievements_view_family_label"),
			visibility_function = _foldout_visibility_function
		}
	})

	for i = 1, #family do
		local sub_achievement_icon_name = "family_sub_icon_" .. i
		local sub_score_name = "family_sub_score_" .. i

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

local function _add_family_achievements_pass_style(style, config)
	table.merge(style, pass_template_styles.achievement_family)

	local pass_styles = pass_template_styles.family_sub_achievements
	local achievement_definition = config.achievement_definition
	local family = AchievementUIHelper.get_family(achievement_definition)

	for i = 1, #family do
		for pass_id, pass_style in pairs(pass_styles) do
			local style_id = string.format("family_%s_%d", pass_id, i)
			style[style_id] = pass_style
		end
	end
end

local function _init_family_achievements_pass_template(widget_content, widget_style, config, unfolded_height)
	local achievement_definition = config.achievement_definition
	local is_complete = config.is_complete
	local score_params = _score_params
	local sub_achievement_margins = pass_template_styles.family_sub_achievement_margins
	local sub_achievement_offset_x = sub_achievement_margins[1]
	local sub_achievement_offset_y = unfolded_height
	local family_label_style = widget_style.family_label
	local family_label_offset = family_label_style.offset
	family_label_offset[2] = family_label_offset[2] + sub_achievement_offset_y
	local total_score = 0
	local family = AchievementUIHelper.get_family(achievement_definition)
	local index_in_family = achievement_definition.family_index

	for i = 1, #family do
		local family_achievement_definition = family[i]
		sub_achievement_offset_y = family_label_offset[2] + family_label_style.size[2]
		local sub_achievement_icon_name = "family_sub_icon_" .. i
		local icon_style = widget_style[sub_achievement_icon_name]
		local icon_offset = icon_style.offset
		sub_achievement_offset_x = sub_achievement_offset_x + icon_offset[1]
		sub_achievement_offset_y = sub_achievement_offset_y + icon_offset[2]
		icon_offset[1] = sub_achievement_offset_x
		icon_offset[2] = sub_achievement_offset_y
		sub_achievement_offset_y = sub_achievement_offset_y + icon_style.size[2]
		local sub_score_name = "family_sub_score_" .. i
		local sub_achievement_score = family_achievement_definition.score or 0
		score_params.score = sub_achievement_score
		widget_content[sub_score_name] = Localize("loc_achievements_view_score", true, _score_params)
		local sub_label_style = widget_style[sub_score_name]
		local sub_label_style_offset = sub_label_style.offset
		sub_achievement_offset_y = sub_achievement_offset_y + sub_label_style_offset[2]
		sub_label_style_offset[1] = sub_achievement_offset_x
		sub_label_style_offset[2] = sub_achievement_offset_y
		sub_achievement_offset_y = sub_achievement_offset_y + sub_label_style.size[2]
		local icon_material_values = icon_style.material_values
		icon_material_values.icon = family_achievement_definition.icon
		local is_current = i == index_in_family

		if i < index_in_family or is_complete and is_current then
			icon_style.icon_default_color = icon_style.icon_completed_color
			icon_style.icon_hover_color = icon_style.icon_completed_hover_color
			icon_style.icon_selected_color = icon_style.icon_completed_selected_color
			icon_material_values.frame = icon_style.completed_frame
		end

		if i <= index_in_family then
			total_score = total_score + sub_achievement_score
		end

		sub_achievement_offset_x = sub_achievement_offset_x + icon_style.size[1]
	end

	score_params.score = total_score
	widget_content.score = Localize("loc_achievements_view_score", true, _score_params)
	unfolded_height = sub_achievement_offset_y + sub_achievement_margins[2]

	return unfolded_height
end

local function _definition_has_reward(achievement_definition)
	local reward = achievement_definition.rewards

	return reward and #reward > 0
end

local function _add_family_rewards_pass_template(pass_template, config)
	local achievement_definition = config.achievement_definition
	local index_in_family = achievement_definition.family_index
	local is_complete = config.is_complete

	table.append(pass_template, {
		{
			value_id = "family_reward_label",
			style_id = "family_reward_label",
			pass_type = "text",
			value = Localize("loc_training_grounds_rewards_title"),
			visibility_function = _foldout_visibility_function
		}
	})

	local step_param = {}
	local family = AchievementUIHelper.get_family(achievement_definition)
	local reward_count = 0

	for i = 1, #family do
		local family_achievement_definition = family[i]
		local has_reward = _definition_has_reward(family_achievement_definition)

		if has_reward then
			reward_count = reward_count + 1
			local name_prefix = string.format("family_reward_%d_", reward_count)
			step_param.step = i
			local icon_name = name_prefix .. "icon"

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
					value_id = icon_name,
					style_id = icon_name,
					visibility_function = function (content, style)
						return _foldout_visibility_function(content, style) and content[icon_name]
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

			local is_current = i == index_in_family
			local current_is_complete = is_current and is_complete or i < index_in_family

			if not current_is_complete then
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

	local has_reward = _definition_has_reward(achievement_definition)
	local show_small_icon = has_reward

	if show_small_icon then
		table.append(pass_template, _small_reward_icon_template)
	end
end

local function _add_family_rewards_pass_style(style, config)
	local achievement_definition = config.achievement_definition
	style.family_reward_label = pass_template_styles.achievement_family.family_label
	local reward_count = 0
	local family = AchievementUIHelper.get_family(achievement_definition)
	local pass_styles = pass_template_styles.achievement_family_reward

	for i = 1, #family do
		local family_achievement_definition = family[i]

		if _definition_has_reward(family_achievement_definition) then
			reward_count = reward_count + 1

			for pass_id, pass_style in pairs(pass_styles) do
				local style_id = string.format("family_reward_%d_%s", reward_count, pass_id)
				style[style_id] = pass_style
			end
		end
	end

	local has_reward = _definition_has_reward(achievement_definition)
	local show_small_icon = has_reward

	if show_small_icon then
		style.reward_icon_small = pass_template_styles.rewards.reward_icon_small
	end
end

local function _init_family_rewards_pass_template(widget_content, widget_style, config, unfolded_height, ui_renderer)
	local achievement_definition = config.achievement_definition
	local index_in_family = achievement_definition.family_index
	local is_complete = config.is_complete
	local num_columns = 2
	local current_column = 1
	local family_reward_label_style = widget_style.family_reward_label
	local family_label_offset = family_reward_label_style.offset
	family_label_offset[2] = unfolded_height
	local sub_reward_margins = pass_template_styles.family_sub_reward_margins
	local rewards_offset_x = sub_reward_margins[1]
	local rewards_offset_y = family_label_offset[2] + family_reward_label_style.size[2] - pass_template_styles.achievement_family_reward.icon.offset[2] + sub_reward_margins[2]
	local rewards_height = rewards_offset_y
	local reward_count = 0
	local reward_ids = {}
	local reward_items = {}
	local reward_item_groups = {}
	local text_spacing = 2
	local family = AchievementUIHelper.get_family(achievement_definition)

	for i = 1, #family do
		local family_achievement = family[i]
		local reward_item, item_groups = AchievementUIHelper.get_reward_item(family_achievement)
		local has_reward = reward_item ~= nil

		if has_reward then
			reward_count = reward_count + 1
			local reward_icon_name = string.format("family_reward_%d_icon", reward_count)
			reward_ids[reward_count] = reward_icon_name
			reward_items[reward_count] = reward_item
			reward_item_groups[reward_count] = item_groups
			local icon_style = widget_style[reward_icon_name]
			local icon_offset = icon_style.offset
			icon_offset[1] = rewards_offset_x + icon_offset[1]
			icon_offset[2] = rewards_offset_y + icon_offset[2]
			local reward_icon_background_name = string.format("family_reward_%d_icon_background", reward_count)
			local icon_background_style = widget_style[reward_icon_background_name]
			local icon_background_offset = icon_background_style.offset
			icon_background_offset[1] = icon_offset[1]
			icon_background_offset[2] = icon_offset[2]
			local reward_icon_frame_name = string.format("family_reward_%d_icon_frame", reward_count)
			local frame_style = widget_style[reward_icon_frame_name]
			local frame_offset = frame_style.offset
			frame_offset[1] = rewards_offset_x + frame_offset[1]
			frame_offset[2] = rewards_offset_y + frame_offset[2]
			local reward_label_name = string.format("family_reward_%d_label", reward_count)
			local label_style = widget_style[reward_label_name]
			local label_offset = label_style.offset
			label_offset[1] = rewards_offset_x + label_offset[1]
			label_offset[2] = rewards_offset_y + label_offset[2]
			local reward_display_name_id = string.format("family_reward_%d_display_name", reward_count)
			local reward_display_name = ItemUtils.display_name(reward_item)
			widget_content[reward_display_name_id] = reward_display_name
			local display_name_style = widget_style[reward_display_name_id]
			local display_name_offset = display_name_style.offset
			display_name_offset[1] = rewards_offset_x + display_name_offset[1]
			display_name_offset[2] = label_offset[2] + _text_height(ui_renderer, widget_content[reward_label_name], display_name_style) + text_spacing
			local reward_sub_display_name_id = string.format("family_reward_%d_sub_display_name", reward_count)
			local sub_display_name_style = widget_style[reward_sub_display_name_id]
			local sub_display_name_offset = sub_display_name_style.offset
			sub_display_name_offset[1] = rewards_offset_x + sub_display_name_offset[1]
			sub_display_name_offset[2] = display_name_offset[2] + _text_height(ui_renderer, reward_display_name, display_name_style) + text_spacing
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

			local is_current = i == index_in_family
			local current_is_complete = is_current and is_complete or i < index_in_family

			if not current_is_complete then
				local reward_lock_name = string.format("family_reward_%d_lock", reward_count)
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

	if _definition_has_reward(achievement_definition) then
		_small_reward_icon_template_init(widget_content, widget_style, config)
	end

	unfolded_height = rewards_height + sub_reward_margins[2]

	return unfolded_height
end

local function _category_common_pass_templates_init(parent, widget, config, callback_name, secondary_callback_name, ui_renderer)
	local content = widget.content
	local style = widget.style
	local label = config.label
	content.text = Localize(label)
	local hotspot = content.hotspot
	hotspot.on_select_sound = nil
	hotspot.pressed_callback = callback(parent, callback_name, widget, config, config.category)
	hotspot.selected_callback = callback(config.selected_callback, widget, config, config.category)
	local percent_done = config.percent_done

	if percent_done then
		content.percent_done = string.format("%d%%", percent_done)
	else
		content.percent_done = ""
	end

	local has_sub_categories = style.arrow ~= nil

	if has_sub_categories then
		content.unfolded = false
	end

	local widgets_by_category = config.widgets_by_category

	if widgets_by_category then
		widgets_by_category[config.category] = widget
	end
end

local function _stats_sort_iterator(stats, stats_sorting)
	local sort_table = stats_sorting or table.keys(stats)
	local ii = 0

	return function ()
		ii = ii + 1

		return sort_table[ii], stats[sort_table[ii]]
	end
end

local function _add_substat_templates(pass_templates, config)
	local achievement_definition = config.achievement_definition
	local stats = achievement_definition.stats
	local stats_sorting = achievement_definition.stats_sorting

	for stat_name, _ in _stats_sort_iterator(stats, stats_sorting) do
		local id_left = string.format("l_substat_%s", stat_name)
		local id_right = string.format("r_substat_%s", stat_name)

		table.append(pass_templates, {
			{
				pass_type = "text",
				value = " ???",
				value_id = id_left,
				style_id = id_left,
				style = UIFontSettings.body_small,
				visibility_function = _foldout_visibility_function
			},
			{
				pass_type = "text",
				value = "0/0",
				value_id = id_right,
				style_id = id_right,
				style = UIFontSettings.body_small,
				visibility_function = _foldout_visibility_function
			}
		})
	end
end

local function _init_substat_templates(widget_content, widget_style, parent, config, unfolded_height, ui_renderer)
	local player = config.player
	local player_id = player.remote and player.stat_id or player:local_player_id()
	local achievement_definition = config.achievement_definition
	local stats = achievement_definition.stats
	local stats_sorting = achievement_definition.stats_sorting

	for stat_name, stat_settings in _stats_sort_iterator(stats, stats_sorting) do
		local padding = ViewStyles.achievement_margins[1]
		local bar_left = pass_template_styles.progress_bar.progress_bar.offset[1]
		local bar_right = bar_left + pass_template_styles.progress_bar.progress_bar.size[1]
		local size = 256
		local id_left = string.format("l_substat_%s", stat_name)
		local id_right = string.format("r_substat_%s", stat_name)
		local loc_stat_name = string.format("• %s", Localize(StatDefinitions[stat_name].stat_name or "unknown"))
		widget_content[id_left] = loc_stat_name
		local left_style = widget_style[id_left]
		left_style.size = {
			size,
			30
		}
		left_style.offset = {
			bar_left + padding,
			unfolded_height,
			5
		}
		local target = stat_settings.target
		local value = math.min(Managers.stats:read_user_stat(player_id, stat_name), target)
		local progress = _format_progress(value, target)
		widget_content[id_right] = progress
		local right_style = widget_style[id_right]
		right_style.size = {
			bar_right - size - bar_left - 3 * padding,
			30
		}
		right_style.offset = {
			bar_left + 2 * padding + size,
			unfolded_height,
			5
		}
		right_style.text_horizontal_alignment = "right"
		local text_height = _text_height(ui_renderer, loc_stat_name, left_style)
		unfolded_height = unfolded_height + text_height + padding
	end

	local bottom_padding = 4

	return unfolded_height + bottom_padding
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
local category_button_template = table.clone(ButtonPassTemplates.terminal_list_button)

table.append(category_button_template, {
	{
		style_id = "percent_done",
		pass_type = "text",
		value_id = "percent_done",
		value = "",
		change_function = function (content, style)
			local hotspot = content.hotspot
			local default_color = hotspot.disabled and style.disabled_color or style.default_color
			local hover_color = style.hover_color
			local text_color = style.text_color
			local progress = math.max(math.max(hotspot.anim_focus_progress, hotspot.anim_select_progress), math.max(hotspot.anim_hover_progress, hotspot.anim_input_progress))

			_color_lerp(default_color, hover_color, progress, text_color)
		end
	}
})

achievements_view_blueprints.simple_category_button = {
	size = table.clone(blueprint_styles.simple_category_button.size),
	pass_template = category_button_template,
	style = blueprint_styles.simple_category_button,
	init = _category_common_pass_templates_init
}
local foldout_category_button_template = table.clone(category_button_template)

table.append(foldout_category_button_template, {
	{
		style_id = "arrow",
		pass_type = "rotated_texture",
		value_id = "arrow",
		value = "content/ui/materials/buttons/arrow_01",
		change_function = ButtonPassTemplates.terminal_list_button_frame_hover_change_function
	}
})

achievements_view_blueprints.top_category_button = {
	size = blueprint_styles.top_category_button.size,
	pass_template = foldout_category_button_template,
	style = blueprint_styles.top_category_button,
	init = function (parent, widget, config, callback_name, secondary_callback_name, ui_renderer)
		_category_common_pass_templates_init(parent, widget, config, callback_name, secondary_callback_name, ui_renderer)

		local content = widget.content
		local hotspot = content.hotspot
		hotspot.on_pressed_sound = nil
	end
}
achievements_view_blueprints.sub_category_button = {
	size = blueprint_styles.sub_category_button.size,
	pass_template = category_button_template,
	style = blueprint_styles.sub_category_button,
	init = function (parent, widget, config, callback_name, secondary_callback_name, ui_renderer)
		_category_common_pass_templates_init(parent, widget, config, callback_name, secondary_callback_name, ui_renderer)

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
		local label = TextUtilities.localize_to_upper(config.display_name, config.localization_options)
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
achievements_view_blueprints.description = {
	size = blueprint_styles.description.size,
	pass_template = {
		{
			style_id = "label",
			value_id = "label",
			pass_type = "text"
		}
	},
	style = blueprint_styles.description,
	init = function (parent, widget, config, callback_name, secondary_callback_name, ui_renderer)
		local label = Localize(config.display_name, config.localization_options ~= nil, config.localization_options)
		local content = widget.content
		content.label = label
		content.size[2] = math.max(content.size[2], _text_height(ui_renderer, label, widget.style.label))
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

local function _set_icon_completed_style(style, config)
	local icon = style.icon
	icon.icon_default_color = Color.ui_achievement_icon_completed(nil, true)
	icon.icon_hover_color = Color.ui_achievement_icon_completed_hover(nil, true)
	icon.material_values = {
		frame = "content/ui/textures/icons/achievements/frames/achieved",
		icon_color = table.clone(icon.icon_default_color)
	}
end

local function _has_progress_bar(config)
	local is_complete = config.is_complete
	local achievement_definition = config.achievement_definition
	local achievement_type_name = achievement_definition.type
	local achievement_type = AchievementTypes[achievement_type_name]
	local has_progress_bar = achievement_type.get_progress ~= nil
	local ignore_progress_bar = achievement_definition.flags[AchievementFlags.hide_progress] or is_complete

	return has_progress_bar and not ignore_progress_bar
end

local function _has_family(config)
	local achievement_definition = config.achievement_definition

	return achievement_definition.family_index ~= nil
end

local function _has_rewards(config)
	local achievement_definition = config.achievement_definition
	local rewards = achievement_definition.rewards
	local has_rewards = rewards and #rewards > 0

	return has_rewards and not _has_family(config)
end

local function _family_has_rewards(config)
	if not _has_family(config) then
		return false
	end

	local achievement_definition = config.achievement_definition
	local family = AchievementUIHelper.get_family(achievement_definition)

	for i = 1, #family do
		local family_achievement_definition = family[i]
		local rewards = family_achievement_definition.rewards
		local has_rewards = rewards and #rewards > 0

		if has_rewards then
			return true
		end
	end

	return false
end

local function _has_substats(config)
	local is_complete = config.is_complete
	local achievement_definition = config.achievement_definition
	local achievement_type_name = achievement_definition.type

	return not is_complete and achievement_type_name == "multi_stat"
end

local function _has_sub_achievements(config)
	local achievement_definition = config.achievement_definition
	local achievement_type_name = achievement_definition.type

	return achievement_type_name == "meta"
end

local function _has_foldout(config)
	local block_folding = config.block_folding
	local has_reward = _has_rewards(config)
	local has_family = _has_family(config)
	local is_meta_achievement = _has_sub_achievements(config)
	local is_multi_stat_achievement = _has_substats(config)
	local has_foldout = not block_folding and (has_reward or is_meta_achievement or is_multi_stat_achievement or has_family)

	return has_foldout
end

achievements_view_blueprints.achievement = {
	size = blueprint_styles.foldout_achievement.size,
	pass_template_function = function (parent, config)
		local is_complete = config.is_complete
		local pass_template = _get_achievement_common_pass_templates(is_complete)

		if _has_rewards(config) then
			table.append(pass_template, _small_reward_icon_template)
		end

		if _has_foldout(config) then
			table.append(pass_template, _achievement_foldout_pass_template)

			if _has_substats(config) then
				_add_substat_templates(pass_template, config)
			end

			if _has_sub_achievements(config) then
				_add_sub_achievements_pass_template(pass_template, config)
			end

			if _has_rewards(config) then
				_add_foldout_reward_pass_template(pass_template, config)
			end

			if _has_family(config) then
				_add_family_achievements_pass_template(pass_template, config)

				if _family_has_rewards(config) then
					_add_family_rewards_pass_template(pass_template, config)
				end
			end
		end

		if _has_progress_bar(config) then
			table.append(pass_template, _achievement_progress_bar_template)
		end

		return pass_template
	end,
	style_function = function (parent, config)
		local blueprint_style = _has_foldout(config) and blueprint_styles.foldout_achievement or blueprint_styles.normal_achievement
		local style = table.clone(blueprint_style)

		if _has_rewards(config) then
			table.merge(style, pass_template_styles.rewards)
		end

		if _has_progress_bar(config) then
			_add_progress_bar_template_style(style, config)
		end

		local is_complete = config.is_complete

		if is_complete then
			_set_icon_completed_style(style, config)
		end

		if _has_foldout(config) then
			if _has_sub_achievements(config) then
				_add_sub_achievements_pass_style(style, config)
			end

			if _has_family(config) then
				_add_family_achievements_pass_style(style, config)

				if _family_has_rewards(config) then
					_add_family_rewards_pass_style(style, config)
				end
			end
		end

		return style
	end,
	init = function (parent, widget, config, callback_name, secondary_callback_name, ui_renderer)
		local widget_content = widget.content
		local widget_style = widget.style
		local folded_height = _achievement_common_pass_template_init(widget_content, widget_style, config, ui_renderer)

		if _has_progress_bar(config) then
			folded_height = _achievement_progress_bar_template_init(widget_content, widget_style, config, folded_height)
		end

		local has_rewards = _has_rewards(config)

		if has_rewards then
			_small_reward_icon_template_init(widget_content, widget_style, config)
		end

		folded_height = folded_height + ViewStyles.achievement_margins[2]
		local widget_height = _math_max(folded_height, widget_content.size[2])
		widget_content.size[2] = widget_height
		folded_height = widget_height
		local unfolded_height = folded_height

		if _has_foldout(config) then
			if _has_substats(config) then
				unfolded_height = _init_substat_templates(widget_content, widget_style, parent, config, unfolded_height, ui_renderer)
			end

			if _has_sub_achievements(config) then
				unfolded_height = _sub_achievements_pass_template_init(widget_content, widget_style, config, unfolded_height)
			end

			if has_rewards then
				unfolded_height = _init_foldout_reward_pass_templates(widget_content, widget_style, config, unfolded_height, ui_renderer)
			end

			if _has_family(config) then
				unfolded_height = _init_family_achievements_pass_template(widget_content, widget_style, config, unfolded_height)

				if _family_has_rewards(config) then
					unfolded_height = _init_family_rewards_pass_template(widget_content, widget_style, config, unfolded_height, ui_renderer)
				end
			end

			_achievement_foldout_pass_template_init(widget, widget_content, widget_style, config, parent, folded_height, unfolded_height)
		end
	end,
	load_icon = _reward_load_icon_func,
	unload_icon = _reward_unload_icon_func,
	destroy = _reward_unload_icon_func
}

return settings("AchievementsViewBlueprints", achievements_view_blueprints)
