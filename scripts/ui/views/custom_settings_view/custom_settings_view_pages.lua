local render_settings = require("scripts/settings/options/render_settings")
local sound_settings = require("scripts/settings/options/sound_settings")
local interface_settings = require("scripts/settings/options/interface_settings")
local custom_settings_view_settings = require("scripts/ui/views/custom_settings_view/custom_settings_view_settings")
local settings_grid_width = custom_settings_view_settings.settings_grid_width
local gamma_settings = {
	{
		id = "checker",
		default_value = 1,
		widget_type = "gamma_texture",
		update = function (template)
			return (Application.user_setting("gamma") or 0) + 1 or template.default_value
		end
	},
	{
		widget_type = "extra_large_spacing"
	},
	{
		shrink_to_fit = true,
		display_name = "loc_setting_brightness_gamma_description",
		widget_type = "description",
		size = {
			settings_grid_width
		},
		style = {
			text_horizontal_alignment = "center",
			offset = {
				0,
				0,
				3
			}
		}
	},
	{
		id = "brightness_value",
		widget_type = "large_value_slider",
		num_decimals = 2,
		focusable = true,
		min_value = -1,
		max_value = 1,
		default_value = 0,
		step_size_value = 0.01,
		apply_on_drag = true,
		value_width = 200,
		get_function = function (template)
			return Application.user_setting("gamma") or template.default_value
		end,
		on_value_changed = function (value, template)
			if template.min_value > value or value > template.max_value then
				Application.set_user_setting("gamma", template.default_value)
			else
				Application.set_user_setting("gamma", value)
			end

			if template.changed_callback then
				template.changed_callback(value)
			end

			render_settings.settings_utilities.save_user_settings()
		end,
		on_activated = function (value, template)
			template.on_changed(value, template)
		end,
		on_changed = function (value, template)
			return template.on_value_changed(value, template)
		end,
		explode_function = function (normalized_value, template)
			local value_range = template.max_value - template.min_value
			local exploded_value = template.min_value + normalized_value * value_range
			local step_size = template.step_size_value or 0.1
			exploded_value = math.round(exploded_value / step_size) * step_size

			return exploded_value
		end,
		format_value_function = function (value)
			local number_format = string.format("%%.%sf", 2)

			return string.format(number_format, value)
		end,
		validation_function = function ()
			return true
		end,
		size = {
			settings_grid_width - 200
		},
		alignment = {
			horizontal_alignment = "left",
			size = {
				400
			}
		},
		dependent_focus_ids = {
			"checker"
		}
	}
}
local page_templates = {
	first_run_page_settings = {
		{
			next_button_alignment = "right",
			grid_alignment = "center",
			widgets = gamma_settings,
			on_enter = function (parent)
				parent._widgets_by_name.background.content.visible = false
				parent._widgets_by_name.gamma_background.content.visible = true
			end,
			on_leave = function (parent)
				parent._widgets_by_name.background.content.visible = true
				parent._widgets_by_name.gamma_background.content.visible = false
			end
		},
		{
			next_button_alignment = "right",
			grid_alignment = "left",
			widgets = {
				interface_settings.settings_by_id.subtitle_enabled,
				interface_settings.settings_by_id.subtitle_speaker_enabled,
				sound_settings.settings_by_id.option_master_slider,
				sound_settings.settings_by_id.sound_device,
				sound_settings.settings_by_id.speaker_settings
			}
		}
	},
	brightness_render_option_settings = {
		{
			next_button_alignment = "right",
			grid_alignment = "center",
			widgets = gamma_settings,
			on_enter = function (parent)
				parent._widgets_by_name.background.content.visible = false
				parent._widgets_by_name.gamma_background.content.visible = true
			end,
			on_leave = function (parent)
				parent._widgets_by_name.background.content.visible = true
				parent._widgets_by_name.gamma_background.content.visible = false
			end
		}
	}
}

return page_templates
