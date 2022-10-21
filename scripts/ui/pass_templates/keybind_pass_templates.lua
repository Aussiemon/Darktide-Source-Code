local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIResolution = require("scripts/managers/ui/ui_resolution")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ListHeaderPassTemplates = require("scripts/ui/pass_templates/list_header_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local highlight_size_addition = ListHeaderPassTemplates.highlight_size_addition

local function list_item_highlight_change_function(content, style)
	local hotspot = content.hotspot
	local use_is_focused = hotspot.use_is_focused
	local focus_progress = use_is_focused and hotspot.anim_focus_progress or not use_is_focused and hotspot.anim_select_progress
	local progress = math.max(hotspot.anim_hover_progress, focus_progress)
	style.color[1] = 255 * math.easeOutCubic(progress)
	local size_addition = highlight_size_addition * math.easeInCubic(1 - progress)
	local style_size_addition = style.size_addition
	style_size_addition[1] = size_addition * 2
	style_size_addition[2] = size_addition * 2
	local offset = style.offset
	offset[1] = size_addition
	offset[2] = -size_addition
	style.hdr = progress == 1
end

local list_item_focused_visibility_function = ListHeaderPassTemplates.list_item_focused_visibility_function
local highlight_color_change_function = ListHeaderPassTemplates.list_highlight_color_change_function
local KeybindPassTemplates = {
	settings_keybind = function (width, height, settings_area_width, use_is_focused)
		local header_width = width - settings_area_width
		local value_font_style = table.clone(UIFontSettings.list_button)
		value_font_style.offset = {
			0,
			0,
			3
		}
		value_font_style.size = {
			settings_area_width,
			height
		}
		value_font_style.horizontal_alignment = "right"
		value_font_style.text_horizontal_alignment = "center"
		local header_passes = ListHeaderPassTemplates.list_header(header_width, height, use_is_focused)
		local keybind_passes = {
			{
				pass_type = "texture",
				value = "content/ui/materials/frames/hover",
				style = {
					hdr = true,
					horizontal_alignment = "right",
					size = {
						settings_area_width,
						height
					},
					color = Color.ui_terminal(255, true),
					size_addition = {
						0,
						0
					},
					offset = {
						0,
						0,
						11
					}
				},
				change_function = list_item_highlight_change_function,
				visibility_function = list_item_focused_visibility_function
			},
			{
				value = "content/ui/materials/buttons/background_selected",
				pass_type = "texture",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "right",
					size = {
						settings_area_width,
						height
					},
					color = Color.ui_terminal(255, true),
					offset = {
						0,
						0,
						0
					}
				}
			},
			{
				pass_type = "text",
				value_id = "value_text",
				value = "n/a",
				style = value_font_style,
				change_function = highlight_color_change_function
			}
		}
		local passes = {}

		table.append(passes, header_passes)
		table.append(passes, keybind_passes)

		return passes
	end
}

return KeybindPassTemplates
