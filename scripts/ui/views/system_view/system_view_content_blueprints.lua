local SystemViewSettings = require("scripts/ui/views/system_view/system_view_settings")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local grid_size = SystemViewSettings.grid_size
local grid_width = grid_size[1]
local blueprints = {
	spacing_vertical = {
		size = {
			grid_width,
			0
		}
	},
	spacing_group_divder = {
		size = {
			grid_width,
			20
		}
	},
	button = {
		size = {
			grid_width,
			ButtonPassTemplates.list_button_default_height
		},
		pass_template = ButtonPassTemplates.list_button,
		init = function (parent, widget, element, callback_name, disabled)
			local content = widget.content
			content.text = Managers.localization:localize(element.text)
			local hotspot = content.hotspot
			hotspot.pressed_callback = callback(parent, callback_name, widget, element)
			hotspot.disabled = disabled or nil
		end
	},
	large_button = {
		size = {
			grid_width,
			80
		},
		pass_template = ButtonPassTemplates.list_button_large,
		init = function (parent, widget, element, callback_name, disabled)
			local content = widget.content
			content.text = Managers.localization:localize(element.text)
			local hotspot = content.hotspot
			hotspot.pressed_callback = callback(parent, callback_name, widget, element)
			hotspot.disabled = disabled or nil
		end
	}
}

return settings("SystemViewBlueprints", blueprints)
