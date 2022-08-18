local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIResolution = require("scripts/managers/ui/ui_resolution")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ListHeaderPassTemplates = require("scripts/ui/pass_templates/list_header_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local highlight_size_addition = ListHeaderPassTemplates.highlight_size_addition

local function list_item_highlight_change_function(content, style)
	local hotspot = content.hotspot
	local use_is_focused = hotspot.use_is_focused
	local focus_progress = (use_is_focused and hotspot.anim_focus_progress) or (not use_is_focused and hotspot.anim_select_progress)
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
local CheckboxPassTemplates = {
	settings_checkbox = function (width, height, settings_area_width, num_options, use_is_focused)
		local header_width = width - settings_area_width
		local passes = ListHeaderPassTemplates.list_header(header_width, height, use_is_focused)
		passes[#passes + 1] = {
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
		}
		local option_width = settings_area_width / num_options
		local option_size = {
			option_width,
			height
		}

		for i = 1, num_options, 1 do
			local horizontal_offset = -((num_options - i) * option_width)
			local option_font_style = table.clone(UIFontSettings.list_button)
			option_font_style.horizontal_alignment = "right"
			option_font_style.text_horizontal_alignment = "center"
			option_font_style.size = option_size
			option_font_style.offset[1] = horizontal_offset
			local hotspot_id = "option_hotspot_" .. i
			passes[#passes + 1] = {
				pass_type = "hotspot",
				content_id = hotspot_id,
				style_id = hotspot_id,
				style = {
					vertical_alignment = "top",
					horizontal_alignment = "right",
					size = option_size,
					offset = {
						horizontal_offset,
						0,
						10
					}
				}
			}
			passes[#passes + 1] = {
				pass_type = "texture",
				value = "content/ui/materials/buttons/background_selected",
				style = {
					horizontal_alignment = "right",
					size = option_size,
					offset = {
						horizontal_offset,
						0,
						1
					},
					color = Color.ui_terminal(255, true)
				},
				change_function = function (content, style)
					style.color[1] = 255 * content[hotspot_id].anim_select_progress
				end,
				visibility_function = function (content, style)
					return content[hotspot_id].is_selected
				end
			}
			passes[#passes + 1] = {
				pass_type = "text",
				style = option_font_style,
				style_id = "option_" .. i,
				value_id = "option_" .. i,
				value = "option_" .. i,
				change_function = highlight_color_change_function
			}
		end

		return passes
	end
}

return CheckboxPassTemplates
