local ColorUtilities = require("scripts/utilities/ui/colors")
local ViewStyles = require("scripts/ui/views/talents_view/talents_view_styles")
local _color_lerp = ColorUtilities.color_lerp
local _color_copy = ColorUtilities.color_copy
local _math_ease_in_cubic = math.easeInCubic
local _math_ease_sine = math.ease_sine
local _math_max = math.max

local function _icon_select_change_function(content, style, animation, dt)
	local math_max = _math_max
	local hotspot_content = content.hotspot
	local is_new = content.is_new
	local select_progress = hotspot_content.anim_select_progress
	local hover_progress = math_max(hotspot_content.anim_hover_progress, hotspot_content.anim_focus_progress)
	local intensity = 0

	if is_new then
		local pulse = content.is_new_pulse or 0
		pulse = pulse + dt / style.pulse_time
		content.is_new_pulse = pulse
		intensity = math_max(_math_ease_sine(pulse), hover_progress) * (style.selected_hover_intensity or 0)

		_color_copy(style.selected_color, style.color)
	elseif hotspot_content.is_selected then
		intensity = _math_ease_in_cubic(hover_progress) * (style.selected_hover_intensity or 0)

		_color_copy(style.selected_color, style.color)
	else
		_color_lerp(style.unselected_color, style.hover_color, hover_progress, style.color)
	end

	local material_values = style.material_values
	material_values.saturation = is_new and 1 or select_progress
	material_values.intensity = intensity
	material_values.frame_texture = select_progress == 1 and style.selected or style.unselected
end

local function _icon_frame_focus_change_function(content, style, animation, dt)
	local hotspot_content = content.hotspot
	local focus_progress = hotspot_content.anim_focus_progress
	local color = style.color
	color[1] = 255 * focus_progress
end

local function _is_empty_visibility_function(content, style)
	return not content.group_has_selected_talent
end

local function _is_new_change_function(content, style, animation, dt)
	local fade_progress = content.fade_progress or 0

	if content.is_new then
		if fade_progress < 1 then
			fade_progress = math.min(fade_progress + dt * 2, 1)
		end
	elseif fade_progress > 0 then
		fade_progress = math.max(fade_progress - dt * 4, 0)
	end

	content.fade_progress = fade_progress
	local color = style.color or style.text_color
	color[1] = fade_progress * style.alpha
end

local function _is_new_visibility_function(content, style)
	local color = style.color or style.text_color

	return content.is_new or color[1] > 0
end

local blueprints = {
	talent_icon_large = {
		size = ViewStyles.large_icon.size,
		pass_template = {
			{
				pass_type = "hotspot",
				style_id = "hotspot",
				content_id = "hotspot",
				content = {
					hover_type = "circle"
				}
			},
			{
				value = "content/ui/materials/icons/talents/combat_talent_icon_container",
				value_id = "icon",
				pass_type = "texture",
				style_id = "icon"
			},
			{
				style_id = "frame_hover",
				pass_type = "texture",
				value_id = "frame_hover",
				value = "content/ui/materials/icons/talents/menu/frame_combat_highlight",
				change_function = _icon_frame_focus_change_function
			}
		},
		offset = ViewStyles.large_icon.offset,
		style = ViewStyles.large_icon
	},
	talent_icon = {
		has_focus_ring = true,
		pass_template = {
			{
				pass_type = "hotspot",
				style_id = "hotspot",
				content_id = "hotspot",
				content = {
					hover_type = "circle",
					use_is_focused = true
				}
			},
			{
				value = "content/ui/materials/icons/talents/talent_icon_container",
				style_id = "icon",
				pass_type = "texture",
				change_function = _icon_select_change_function
			}
		},
		offset = ViewStyles.talent_icon.offset,
		size = ViewStyles.talent_icon.size,
		style = ViewStyles.talent_icon
	},
	passive_talent_icon = {
		has_focus_ring = true,
		pass_template = {
			{
				pass_type = "hotspot",
				style_id = "hotspot",
				content_id = "hotspot",
				content = {
					hover_type = "circle",
					use_is_focused = true
				}
			},
			{
				value = "content/ui/materials/icons/talents/talent_icon_container",
				style_id = "icon",
				pass_type = "texture",
				change_function = _icon_select_change_function
			}
		},
		offset = ViewStyles.passive_talent_icon.offset,
		size = ViewStyles.passive_talent_icon.size,
		style = ViewStyles.passive_talent_icon
	},
	locked_talent_icon = {
		has_focus_ring = true,
		pass_template = {
			{
				pass_type = "hotspot",
				style_id = "hotspot",
				content_id = "hotspot",
				content = {
					hover_type = "circle",
					use_is_focused = true
				}
			},
			{
				value = "content/ui/materials/icons/talents/talent_icon_container",
				style_id = "icon",
				pass_type = "texture",
				change_function = _icon_select_change_function
			},
			{
				value = "content/ui/materials/icons/talents/menu/frame_locked",
				style_id = "frame",
				pass_type = "texture"
			}
		},
		offset = ViewStyles.locked_talent_icon.offset,
		style = ViewStyles.locked_talent_icon
	},
	talent_group_main_specialization = {
		pass_template = {
			{
				style_id = "group_name",
				value_id = "group_name",
				pass_type = "text"
			}
		},
		offset = ViewStyles.talent_group_main_specialization.offset,
		size = ViewStyles.large_icon.size,
		style = ViewStyles.talent_group_main_specialization,
		init = function (widget, group_settings)
			local content = widget.content
			local group_label = group_settings.label
			content.group_name = Utf8.upper(Localize(group_label))
		end
	},
	talent_group_tactical_aura = {
		pass_template = {
			{
				style_id = "group_name",
				value_id = "group_name",
				pass_type = "text"
			}
		},
		size = ViewStyles.talent_icon.size,
		style = ViewStyles.talent_group_tactical_aura,
		init = function (widget, group_settings)
			local content = widget.content
			local group_label = group_settings.label
			content.group_name = Utf8.upper(Localize(group_label))
		end
	},
	talent_group_passive = {
		pass_template = {
			{
				style_id = "group_name",
				value_id = "group_name",
				pass_type = "text"
			}
		},
		offset = ViewStyles.talent_group_passive.offset,
		size = ViewStyles.talent_group_passive.size,
		style = ViewStyles.talent_group_passive,
		init = function (widget, group_settings, group_definition)
			local content = widget.content
			local group_label = group_settings.label
			content.group_name = Utf8.upper(Localize(group_label))
		end
	},
	talent_group_tier = {
		pass_template = {
			{
				value = "content/ui/materials/frames/talents/window_unlocked",
				value_id = "window",
				pass_type = "texture",
				style_id = "window"
			},
			{
				style_id = "level",
				value_id = "level",
				pass_type = "text"
			},
			{
				value_id = "window_new",
				style_id = "window_new",
				pass_type = "texture",
				value = "content/ui/materials/frames/talents/window_new",
				visibility_function = _is_empty_visibility_function
			},
			{
				style_id = "new",
				pass_type = "text",
				value_id = "new",
				value = Localize("loc_talents_menu_new"),
				visibility_function = _is_new_visibility_function,
				change_function = _is_new_change_function
			},
			{
				style_id = "new_background",
				pass_type = "texture",
				value = "content/ui/materials/effects/terminal_header_glow",
				value_id = "new_background",
				visibility_function = _is_new_visibility_function,
				change_function = _is_new_change_function
			},
			{
				style_id = "new_effect",
				pass_type = "texture",
				value = "content/ui/materials/frames/talents/level_bar_new_effect",
				value_id = "new_effect",
				visibility_function = _is_new_visibility_function,
				change_function = _is_new_change_function
			}
		},
		offset = ViewStyles.talent_group_tier.offset,
		size = ViewStyles.talent_group_tier.size,
		style = ViewStyles.talent_group_tier,
		init = function (widget, group_settings, group_definition, player_level)
			local required_level = group_definition.required_level
			local content = widget.content
			content.level = required_level
		end
	},
	talent_group_tier_locked = {
		pass_template = {
			{
				value = "content/ui/materials/frames/talents/window_locked",
				value_id = "window",
				pass_type = "texture",
				style_id = "window"
			},
			{
				style_id = "level",
				value_id = "level",
				pass_type = "text"
			},
			{
				value = "content/ui/materials/frames/talents/level_bar_lock",
				value_id = "level_bar_lock",
				pass_type = "texture",
				style_id = "level_bar_lock"
			}
		},
		offset = ViewStyles.talent_group_tier_locked.offset,
		size = ViewStyles.talent_group_tier_locked.size,
		style = ViewStyles.talent_group_tier_locked,
		init = function (widget, group_settings, group_definition)
			local content = widget.content
			content.level = group_definition.required_level
		end
	}
}

return settings("TalentsViewBlueprints", blueprints)
