local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local LobbyViewSettings = require("scripts/ui/views/lobby_view/lobby_view_settings")
local MasterItems = require("scripts/backend/master_items")
local ColorUtilities = require("scripts/utilities/ui/colors")
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
	}
}
blueprints.secondary_button = {
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
}
blueprints.button = {
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
blueprints.talent = {
	size = {
		64,
		64
	},
	pass_template = {
		{
			value_id = "talent",
			style_id = "talent",
			pass_type = "texture",
			value = "content/ui/materials/frames/talents/talent_icon_container",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					1
				},
				color = Color.white(255, true),
				material_values = {}
			},
			visibility_function = function (content, style)
				return true
			end
		},
		{
			value_id = "frame_selected_talent",
			style_id = "frame_selected_talent",
			pass_type = "texture",
			value = "content/ui/materials/frames/talents/circular_frame_selected",
			style = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				color = Color.ui_terminal(255, true),
				size_addition = {
					0,
					0
				},
				offset = {
					0,
					0,
					2
				}
			},
			visibility_function = function (content)
				return content.hotspot.is_hover or content.hotspot.is_selected
			end
		},
		{
			pass_type = "hotspot",
			content_id = "hotspot",
			content = {
				disabled = false
			},
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom"
			}
		}
	},
	init = function (parent, widget, entry)
		local style = widget.style
		local content = widget.content
		local talent_style_material_values = style.talent.material_values
		talent_style_material_values.icon = entry.loadout.icon
		talent_style_material_values.gradient_map = entry.node_type_settings.gradient_map
		talent_style_material_values.frame = entry.node_type_settings.frame
		talent_style_material_values.icon_mask = entry.node_type_settings.icon_mask
		content.frame_selected_talent = entry.node_type_settings.selected_material
		content.loadout_id = entry.loadout_id
		content.icon = entry.loadout.icon
	end
}

return blueprints
