local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local LobbyViewSettings = require("scripts/ui/views/lobby_view/lobby_view_settings")
local grid_width = LobbyViewSettings.grid_size[1]
local blueprints = {
	spacing_vertical = {
		size = {
			grid_width,
			LobbyViewSettings.list_button_spacing
		}
	},
	spacing_horizontal = {
		size = {
			(ButtonPassTemplates.ready_button.size[1] - ButtonPassTemplates.default_button_small.size[1]) * 0.5,
			ButtonPassTemplates.default_button_small.size[2]
		}
	},
	ready_button = {
		size = ButtonPassTemplates.ready_button.size,
		pass_template = ButtonPassTemplates.ready_button,
		init = function (parent, widget, entry, callback_name)
			local content = widget.content
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, entry)
			content.select_callback = content.hotspot.pressed_callback
			local display_name = entry.display_name
			content.text = Localize(display_name)
			content.icon = entry.icon
			content.hotspot.use_is_focused = true
		end
	},
	secondary_button = {
		size = ButtonPassTemplates.default_button_small.size,
		pass_template = ButtonPassTemplates.default_button_small,
		init = function (parent, widget, entry, callback_name)
			local content = widget.content
			local style = widget.style
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, entry)
			content.select_callback = content.hotspot.pressed_callback
			local display_name = entry.display_name
			content.text = Localize(display_name)
			content.icon = entry.icon
			content.hotspot.use_is_focused = true
			style.offset = {
				60,
				0,
				0
			}
		end
	},
	button = {
		size = {
			grid_width,
			ButtonPassTemplates.list_button_default_height
		},
		pass_template = ButtonPassTemplates.list_button,
		init = function (parent, widget, entry, callback_name)
			local content = widget.content
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, entry)
			content.select_callback = content.hotspot.pressed_callback
			local display_name = entry.display_name
			content.text = Localize(display_name)
			content.icon = entry.icon
		end
	}
}

return blueprints
