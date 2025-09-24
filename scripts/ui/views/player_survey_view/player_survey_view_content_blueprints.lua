-- chunkname: @scripts/ui/views/player_survey_view/player_survey_view_content_blueprints.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local item_description_text_style = table.clone(UIFontSettings.body)

item_description_text_style.text_horizontal_alignment = "center"
item_description_text_style.text_vertical_alignment = "center"
item_description_text_style.text_color = Color.terminal_text_body(255, true)
item_description_text_style.offset = {
	0,
	0,
	0,
}

local choice_button_selected_icon_pass = {
	pass_type = "texture",
	style_id = "pressed_icon",
	value = "content/ui/materials/icons/generic/selected_item",
	value_id = "pressed_icon",
	style = {
		horizontal_alignment = "right",
		scale_to_material = false,
		vertical_alignment = "center",
		offset = {
			-10,
			0,
			7,
		},
		size = {
			40,
			40,
		},
		material_values = {
			grunge_tint_intensity = 1,
		},
	},
	visibility_function = function (content, style)
		return content.is_selected
	end,
}
local blueprints = {
	choice_button = {
		height = ButtonPassTemplates.terminal_button.size[2],
		pass_template_function = function (self, config, ui_renderer)
			local passes = table.clone(ButtonPassTemplates.terminal_button)

			passes.size = nil
			passes[#passes + 1] = choice_button_selected_icon_pass

			return passes
		end,
		size_function = function (parent, config, ui_renderer)
			local size = table.clone(ButtonPassTemplates.terminal_button.size)
			local column_count = config.column_count or 1

			size[1] = config.grid_size[1] - config.grid_spacing[1] * (column_count - 1)
			size[1] = size[1] * 1 / column_count
			size[2] = 64

			return size
		end,
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local content = widget.content

			widget.question = element.question
			widget.choice_id = element.choice_id
			widget.style.text.font_size = 22
			widget.style.text.text_horizontal_alignment = "left"
			widget.style.text.offset[1] = 10
			widget.style.text.size_addition = {
				-60,
				0,
			}
			content.original_text = element.text
			content.hotspot.on_pressed_sound = UISoundEvents.default_click

			content.hotspot.pressed_callback = function ()
				element.callback(widget, not content.is_selected)
			end
		end,
	},
}

return blueprints
