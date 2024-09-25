-- chunkname: @scripts/ui/views/system_view/system_view_content_blueprints.lua

local SystemViewSettings = require("scripts/ui/views/system_view/system_view_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local grid_size = SystemViewSettings.grid_size
local grid_width = grid_size[1]
local button_size = ButtonPassTemplates.terminal_button_small.size
local button_size_large = ButtonPassTemplates.terminal_button.size
local blueprints = {
	vertical_spacing = {
		0,
		10,
	},
	spacing_vertical = {
		size = {
			grid_width,
			10,
		},
	},
	spacing_group_divder = {
		size = {
			grid_width,
			20,
		},
	},
	button = {
		size = {
			grid_width,
			50,
		},
		pass_template = ButtonPassTemplates.terminal_list_button_with_background_and_icon,
		init = function (parent, widget, element, callback_name, disabled)
			local content = widget.content
			local style = widget.style

			content.text = element.dev_text or Managers.localization:localize(element.text)

			if element.icon then
				content.icon = element.icon

				local icon_style = style.icon
				local icon_size = icon_style.size

				icon_size[1] = 40
				icon_size[2] = 40
				icon_style.offset[1] = icon_style.offset[1] + 5
			end

			local hotspot = content.hotspot

			hotspot.pressed_callback = callback(parent, callback_name, widget, element)
			hotspot.disabled = disabled or nil
		end,
	},
	large_button = {
		size = {
			grid_width,
			button_size_large[2] + 10,
		},
		pass_template = ButtonPassTemplates.terminal_list_button_with_background_and_icon,
		init = function (parent, widget, element, callback_name, disabled)
			local content = widget.content

			content.text = element.dev_text or Managers.localization:localize(element.text)

			if element.icon then
				content.icon = element.icon
			end

			local hotspot = content.hotspot

			hotspot.pressed_callback = callback(parent, callback_name, widget, element)
			hotspot.disabled = disabled or nil
		end,
		update = function (parent, widget)
			local entry = widget.entry
			local content = widget.content
			local has_highlight = entry and entry.has_highlight

			content.has_notification = has_highlight and has_highlight()
		end,
	},
}

return settings("SystemViewBlueprints", blueprints)
