local ColorUtilities = require("scripts/utilities/ui/colors")
local ViewStyles = require("scripts/ui/views/talents_view/talents_view_styles")

local function icon_frame_select_change_function(content, style, animation, dt)
	local hotspot_content = content.hotspot
	local select_progress = hotspot_content.anim_select_progress
	style.color[1] = 255 * select_progress
end

local function icon_frame_focus_and_selected_change_function(content, style, animation, dt)
	local hotspot_content = content.hotspot
	local alpha_multiplier = hotspot_content.anim_select_progress * math.max(hotspot_content.anim_hover_progress, hotspot_content.anim_focus_progress)
	local color = style.color or style.text_color
	color[1] = 255 * alpha_multiplier
end

local function icon_focus_change_function(content, style, animations, dt)
	local hotspot_content = content.hotspot
	local focus_progress = math.max(hotspot_content.anim_hover_progress, hotspot_content.anim_focus_progress)

	ColorUtilities.color_lerp(style.idle_color, style.focused_color, focus_progress, style.color)
end

local function group_change_function(content, style, animation, dt)
	local color = style.color or style.text_color

	ColorUtilities.color_lerp(style.color_default, style.color_focused, content.hotspot.anim_focus_progress, color)
end

local function _icon_select_change_function(content, style, animation, dt)
	local hotspot_content = content.hotspot
	local is_new = content.is_new
	local select_progress = hotspot_content.anim_select_progress

	ColorUtilities.color_lerp(style.unselected_color, style.selected_color, select_progress, style.color)

	local material_values = style.material_values
	material_values.saturation = select_progress
	material_values.frame_texture = not is_new and select_progress == 1 and style.selected or style.unselected
end

local function _icon_frame_focus_change_function(content, style, animation, dt)
	local hotspot_content = content.hotspot
	local focus_progress = hotspot_content.anim_focus_progress
	local color = style.color
	color[1] = 255 * focus_progress
end

local blueprints = {
	talent_group_main_specialization = {
		size = ViewStyles.large_icon.size,
		pass_template = {
			{
				style_id = "group_name",
				value_id = "group_name",
				pass_type = "text"
			}
		},
		style = ViewStyles.talent_group_main_specialization,
		offset = ViewStyles.talent_group_main_specialization.offset,
		init = function (widget, group_settings)
			local content = widget.content
			local group_label = group_settings.label
			content.group_name = Localize(group_label)
		end
	},
	talent_group_tactical_aura = {
		size = ViewStyles.talent_icon.size,
		pass_template = {
			{
				style_id = "group_name",
				value_id = "group_name",
				pass_type = "text"
			}
		},
		style = ViewStyles.talent_group_tactical_aura,
		init = function (widget, group_settings)
			local content = widget.content
			local group_label = group_settings.label
			content.group_name = Localize(group_label)
		end
	},
	talent_group_passive = {
		size = ViewStyles.talent_group_passive.size,
		pass_template = {
			{
				style_id = "group_name",
				value_id = "group_name",
				pass_type = "text"
			}
		},
		offset = ViewStyles.talent_group_passive.offset,
		style = ViewStyles.talent_group_passive,
		init = function (widget, group_settings, group_definition)
			local content = widget.content
			local group_label = group_settings.label
			content.group_name = Localize(group_label)
		end
	},
	talent_group_tier = {
		size = ViewStyles.talent_icon.size,
		pass_template = {
			{
				style_id = "frame",
				pass_type = "rect",
				style = {
					color = {
						0,
						255,
						0,
						255
					}
				}
			}
		},
		style = ViewStyles.talent_group_tactical_aura,
		init = function (widget, group_settings)
			return
		end
	},
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
				pass_type = "texture"
			}
		},
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
				pass_type = "texture"
			},
			{
				value = "content/ui/materials/icons/talents/menu/frame_locked",
				style_id = "frame",
				pass_type = "texture"
			}
		},
		style = ViewStyles.locked_talent_icon
	}
}

return settings("TalentsViewBlueprints", blueprints)
