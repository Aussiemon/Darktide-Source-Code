-- chunkname: @scripts/ui/views/lobby_view/lobby_view_content_blueprints.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local LobbyViewSettings = require("scripts/ui/views/lobby_view/lobby_view_settings")
local MasterItems = require("scripts/backend/master_items")
local ColorUtilities = require("scripts/utilities/ui/colors")
local grid_width = LobbyViewSettings.grid_size[1]
local blueprints = {}

blueprints.spacing_vertical = {
	size = {
		grid_width,
		LobbyViewSettings.list_button_spacing
	}
}
blueprints.spacing_horizontal = {
	size = {
		(ButtonPassTemplates.ready_button.size[1] - ButtonPassTemplates.default_button_small.size[1]) * 0.5,
		ButtonPassTemplates.default_button_small.size[2]
	}
}
blueprints.ready_button = {
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
blueprints.item_icon = {
	size = {
		128,
		48
	},
	pass_template = {
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			value = "content/ui/materials/frames/dropshadow_medium",
			style_id = "outer_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				color = Color.black(200, true),
				size_addition = {
					20,
					20
				}
			}
		},
		{
			value_id = "icon",
			style_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/icons/weapons/hud/combat_blade_01",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.terminal_text_body(255, true),
				default_color = Color.terminal_text_body(nil, true),
				selected_color = Color.terminal_icon(nil, true),
				offset = {
					0,
					4,
					5
				},
				size = {
					128,
					48
				}
			}
		},
		{
			value = "content/ui/materials/backgrounds/default_square",
			style_id = "background",
			pass_type = "texture",
			style = {
				color = Color.terminal_background_dark(nil, true),
				selected_color = Color.terminal_background_selected(nil, true),
				offset = {
					0,
					0,
					0
				}
			}
		},
		{
			value = "content/ui/materials/gradients/gradient_vertical",
			style_id = "background_gradient",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				default_color = {
					100,
					33,
					35,
					37
				},
				color = {
					100,
					33,
					35,
					37
				},
				offset = {
					0,
					0,
					1
				}
			}
		},
		{
			pass_type = "texture",
			style_id = "button_gradient",
			value = "content/ui/materials/gradients/gradient_diagonal_down_right",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.terminal_background_gradient(nil, true),
				offset = {
					0,
					0,
					1
				}
			},
			change_function = ButtonPassTemplates.terminal_button_hover_change_function
		},
		{
			pass_type = "texture",
			style_id = "frame",
			value = "content/ui/materials/frames/frame_tile_2px",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.terminal_frame(nil, true),
				default_color = Color.terminal_frame(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
				hover_color = Color.terminal_frame_hover(nil, true),
				offset = {
					0,
					0,
					6
				}
			},
			change_function = function (content, style)
				local hotspot = content.hotspot
				local is_selected = hotspot.is_selected
				local is_hover = hotspot.is_hover
				local default_color = style.default_color
				local hover_color = style.hover_color
				local selected_color = style.selected_color
				local color

				if is_selected and selected_color then
					color = selected_color
				elseif is_hover and hover_color then
					color = selected_color
				elseif default_color then
					color = default_color
				end

				if color then
					ColorUtilities.color_copy(color, style.color)
				end
			end
		},
		{
			pass_type = "texture",
			style_id = "corner",
			value = "content/ui/materials/frames/frame_corner_2px",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Color.terminal_corner(nil, true),
				default_color = Color.terminal_corner(nil, true),
				selected_color = Color.terminal_corner_selected(nil, true),
				hover_color = Color.terminal_corner_hover(nil, true),
				offset = {
					0,
					0,
					7
				}
			},
			change_function = function (content, style)
				local hotspot = content.hotspot
				local is_selected = hotspot.is_selected
				local is_hover = hotspot.is_hover
				local default_color = style.default_color
				local hover_color = style.hover_color
				local selected_color = style.selected_color
				local color

				if is_selected and selected_color then
					color = selected_color
				elseif is_hover and hover_color then
					color = selected_color
				elseif default_color then
					color = default_color
				end

				if color then
					ColorUtilities.color_copy(color, style.color)
				end
			end
		}
	},
	init = function (parent, widget, entry)
		local item = entry.item
		local id = item.name
		local master_item = MasterItems.get_item(id)
		local hud_icon = "content/ui/materials/icons/weapons/hud/combat_blade_01"

		if master_item and master_item.hud_icon then
			hud_icon = master_item.hud_icon
		end

		widget.content.icon = hud_icon
		widget.content.item = item
		widget.content.slot = entry.slot
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
