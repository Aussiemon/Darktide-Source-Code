local SocialConstants = require("scripts/managers/data_service/services/social/social_constants")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local PopupStyles = require("scripts/ui/view_elements/view_element_player_social_popup/view_element_player_social_popup_styles")
local SocialMenuSettings = require("scripts/ui/views/social_menu_view/social_menu_view_settings")
local TextInputPassTemplates = require("scripts/ui/pass_templates/text_input_pass_templates")
local ViewStyles = require("scripts/ui/views/social_menu_roster_view/social_menu_roster_view_styles")
local blueprint_styles = PopupStyles.blueprints
local OnlineStatus = SocialConstants.OnlineStatus
local view_element_player_popup_blueprints = {
	button = {
		size = {
			PopupStyles.column_width,
			ButtonPassTemplates.list_button_default_height
		},
		pass_template = ButtonPassTemplates.list_button,
		init = function (parent, widget, context)
			local widget_content = widget.content
			widget_content.text = context.label
			widget_content.show_background_with_hover = true
			local hotspot = widget_content.hotspot
			hotspot.disabled = context.is_disabled
			hotspot.pressed_callback = context.callback
			local on_pressed_sound = context.on_pressed_sound

			if on_pressed_sound then
				widget.style.hotspot.on_pressed_sound = on_pressed_sound
			end
		end
	},
	disabled_button_with_explanation = {
		size = {
			PopupStyles.column_width,
			ButtonPassTemplates.list_button_default_height
		},
		pass_template = ButtonPassTemplates.list_button_two_rows_with_icon,
		style = blueprint_styles.disabled_button_with_explanation,
		init = function (parent, widget, context)
			local widget_content = widget.content
			widget_content.text = context.label
			widget_content.second_row = context.reason_for_disabled
			widget_content.show_background_with_hover = true
			widget_content.icon = "content/ui/materials/icons/list_buttons/block"
			local hotspot = widget_content.hotspot
			hotspot.disabled = true
			local on_pressed_sound = context.on_pressed_sound

			if on_pressed_sound then
				widget.style.hotspot.on_pressed_sound = on_pressed_sound
			end
		end
	},
	choice_header = {
		size = blueprint_styles.choice_header.size,
		pass_template = {
			{
				style_id = "text",
				value_id = "text",
				pass_type = "text"
			}
		},
		style = blueprint_styles.choice_header,
		init = function (parent, widget, context)
			local widget_content = widget.content
			widget_content.text = context.label
		end
	},
	choice_button = {
		size = {
			PopupStyles.column_width,
			ButtonPassTemplates.list_button_default_height
		},
		pass_template = ButtonPassTemplates.list_button_with_background_and_icon,
		style = blueprint_styles.choice_button,
		init = function (parent, widget, context)
			local widget_content = widget.content
			widget_content.text = context.label
			local icon = context.icon

			if icon then
				widget_content.icon = icon
			end

			local hotspot = widget_content.hotspot
			hotspot.disabled = context.is_disabled
			hotspot.pressed_callback = context.callback
			local on_pressed_sound = context.on_pressed_sound

			if on_pressed_sound then
				widget.style.hotspot.on_pressed_sound = on_pressed_sound
			end
		end
	},
	checkbox_button = {
		size = {
			PopupStyles.column_width,
			ButtonPassTemplates.list_button_default_height
		},
		pass_template = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "hotspot",
				content = {
					use_is_focused = true
				}
			},
			{
				style_id = "background_selected",
				pass_type = "texture",
				value = "content/ui/materials/buttons/background_selected",
				change_function = function (content, style)
					style.color[1] = 255 * content.hotspot.anim_select_progress
				end,
				visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
			},
			{
				style_id = "highlight",
				pass_type = "texture",
				value = "content/ui/materials/frames/hover",
				change_function = ButtonPassTemplates.list_button_highlight_change_function,
				visibility_function = ButtonPassTemplates.list_button_focused_visibility_function
			},
			{
				style_id = "checkbox_background",
				pass_type = "texture",
				value_id = "checkbox_background",
				value = "content/ui/materials/icons/list_buttons/box",
				change_function = ButtonPassTemplates.list_button_label_change_function
			},
			{
				style_id = "check_mark",
				pass_type = "texture",
				value_id = "check_mark",
				value = "content/ui/materials/icons/list_buttons/check",
				change_function = ButtonPassTemplates.list_button_label_change_function,
				visibility_function = function (content, style)
					return content.checked
				end
			},
			{
				value_id = "text",
				pass_type = "text",
				style_id = "text",
				change_function = ButtonPassTemplates.list_button_label_change_function
			}
		},
		style = blueprint_styles.checkbox_button,
		init = function (parent, widget, context)
			local widget_content = widget.content
			local widget_style = widget.style
			local is_disabled = context.is_disabled
			widget_content.text = context.label
			widget_content.checked = context.is_checked or false
			local hotspot = widget_content.hotspot
			widget_content.pressed_callback = context.callback

			hotspot.pressed_callback = function ()
				local content = widget_content
				local pressed_callback = content.pressed_callback
				content.checked = not content.checked

				pressed_callback(content.checked)
			end

			hotspot.disabled = is_disabled
			local on_pressed_sound = context.on_pressed_sound

			if on_pressed_sound then
				widget_style.hotspot.on_pressed_sound = on_pressed_sound
			end
		end
	},
	group_divider = {
		size = blueprint_styles.group_divider.size,
		pass_template = {
			{
				value = "content/ui/materials/dividers/skull_rendered_center_04",
				style_id = "divider",
				pass_type = "texture"
			}
		},
		style = blueprint_styles.group_divider
	}
}

return settings("ViewElementPlayerPopupBlueprints", view_element_player_popup_blueprints)
