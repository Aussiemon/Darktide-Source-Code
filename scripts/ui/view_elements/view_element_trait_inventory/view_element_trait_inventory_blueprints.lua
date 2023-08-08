local ItemUtils = require("scripts/utilities/items")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local InputDevice = require("scripts/managers/input/input_device")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local amount_style = table.clone(UIFontSettings.body_small)
amount_style.text_color = Color.terminal_icon(nil, true)
amount_style.offset = {
	0,
	-1,
	3
}
amount_style.text_horizontal_alignment = "center"
amount_style.text_vertical_alignment = "bottom"
local unknown_style = table.clone(amount_style)
unknown_style.offset = {
	0,
	-5,
	3
}
unknown_style.font_size = 10
unknown_style.text_color[1] = 60
local ViewElementTraitInventoryBlueprints = {
	spacing_vertical_small = {
		size = {
			430,
			5
		}
	},
	spacing_vertical = {
		size = {
			430,
			20
		}
	}
}
ViewElementTraitInventoryBlueprints.trait = {
	size = {
		110,
		110
	},
	pass_template = {
		{
			pass_type = "hotspot",
			content_id = "hotspot",
			content = {
				on_hover_sound = UISoundEvents.default_mouse_hover,
				on_pressed_sound = UISoundEvents.default_click
			},
			change_function = function (content, style, animations, dt)
				local parent_content = content.parent
				local trait_amount = parent_content.trait_amount or 0
				parent_content.hover_multiplier = trait_amount > 0 and 1 or 0.25
				local is_hover = content.is_hover

				if InputDevice.gamepad_active then
					local parent = parent_content.parent
					local selected_grid_widget = parent:selected_grid_widget()

					if selected_grid_widget then
						local selected_grid_widget_content = selected_grid_widget.content
						local selected_grid_widget_config = selected_grid_widget_content.config
						local selected_trait_item = selected_grid_widget_config.trait_item
						local selected_trait_id = selected_trait_item.gear.uuid
						local my_config = content.parent.config
						local my_trait_item = my_config.trait_item
						local my_trait_id = my_trait_item.gear.uuid
						is_hover = my_trait_id == selected_trait_id
					end
				end

				local lerp_direction = is_hover and 1 or -1
				content.parent.progress = math.clamp((content.parent.progress or 0) + dt * lerp_direction * 6, 0, 1)
			end
		},
		{
			value = "content/ui/materials/frames/dropshadow_medium",
			style_id = "outer_shadow",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				scale_to_material = true,
				color = Color.black(100, true),
				size_addition = {
					20,
					20
				},
				offset = {
					0,
					0,
					7
				}
			}
		},
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/backgrounds/default_square",
			style = {
				default_color = Color.terminal_background(nil, true),
				selected_color = Color.terminal_background_selected(nil, true)
			},
			change_function = ButtonPassTemplates.terminal_button_change_function
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
					2
				}
			},
			change_function = ButtonPassTemplates.terminal_button_change_function
		},
		{
			{
				pass_type = "texture",
				style_id = "corner",
				value = "content/ui/materials/frames/frame_corner_2px",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					default_color = Color.terminal_corner(nil, true),
					selected_color = Color.terminal_corner_selected(nil, true),
					offset = {
						0,
						0,
						6
					}
				},
				change_function = ButtonPassTemplates.terminal_button_change_function
			},
			style_id = "background_gradient",
			pass_type = "texture",
			value = "content/ui/materials/gradients/gradient_vertical",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				default_color = Color.terminal_background_gradient(nil, true),
				selected_color = Color.terminal_frame_selected(nil, true),
				offset = {
					0,
					0,
					1
				}
			},
			change_function = function (content, style)
				ButtonPassTemplates.terminal_button_change_function(content, style)
				ButtonPassTemplates.terminal_button_hover_change_function(content, style)
			end
		},
		{
			value = "content/ui/materials/frames/line_thin_dashed_animated",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "right",
				offset = {
					0,
					0,
					8
				},
				color = Color.terminal_corner_selected(nil, true),
				default_color = Color.terminal_corner_selected(0, true),
				selected_color = Color.terminal_corner_selected(nil, true)
			},
			visibility_function = function (content, style)
				return content.marked
			end
		},
		{
			value = "content/ui/materials/frames/line_thin_detailed_02",
			pass_type = "texture",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					3
				},
				color = Color.terminal_frame(128, true)
			}
		},
		{
			pass_type = "texture",
			style_id = "icon",
			value = "content/ui/materials/icons/traits/traits_container",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				material_values = {},
				size = {
					64,
					64
				},
				offset = {
					0,
					0,
					5
				},
				color = Color.terminal_icon(255, true)
			},
			change_function = function (content, style)
				style.color[1] = content.is_wasteful and 60 or 255
			end
		}
	},
	init = function (parent, widget, config, callback_name)
		local content = widget.content
		local style = widget.style
		local trait_item = config.trait_item
		local trait_rarity = config.trait_rarity
		content.config = config
		content.parent = parent
		local texture_icon, texture_frame = ItemUtils.trait_textures(trait_item, trait_rarity)
		local icon_material_values = style.icon.material_values
		icon_material_values.icon = texture_icon
		icon_material_values.frame = texture_frame
		content.hotspot.pressed_callback = callback(parent, callback_name, widget, config)
	end,
	update = function (parent, widget, input_service, dt, t, ui_renderer)
		local content = widget.content
		local ingredients = parent:ingredients()
		local selected_trait_ids = ingredients.trait_ids
		local config = content.config
		local trait_item = config.trait_item
		local trait_uuid = trait_item.gear.uuid
		local amount = trait_item.gear.count

		for i = 1, #selected_trait_ids do
			local selected_uuid = selected_trait_ids[i]

			if selected_uuid == trait_uuid then
				amount = amount - 1
			end
		end

		content.trait_amount = amount
		content.amount = string.format("x%d", amount)
		local content = widget.content
		local hotspot = content.hotspot
		local is_hover = hotspot.is_hover

		if InputDevice.gamepad_active then
			local parent = content.parent
			local selected_grid_widget = parent:selected_grid_widget()

			if selected_grid_widget then
				local selected_grid_widget_content = selected_grid_widget.content
				local selected_grid_widget_config = selected_grid_widget_content.config
				local selected_trait_item = selected_grid_widget_config.trait_item
				local selected_trait_id = selected_trait_item.gear.uuid
				local my_config = content.config
				local my_trait_item = my_config.trait_item
				local my_trait_id = my_trait_item.gear.uuid
				is_hover = my_trait_id == selected_trait_id
			end
		end

		if is_hover then
			parent:_on_trait_hover(content.config)
		end

		content.is_wasteful = false
		local item_traits = ingredients.item.traits

		for i = 1, #item_traits do
			local item_trait = item_traits[i]
			local selected_index = ingredients.existing_trait_index

			if i == selected_index and item_trait.id == trait_item.name and trait_item.rarity == item_trait.rarity or i ~= selected_index and item_trait.id == trait_item.name then
				content.is_wasteful = true
			end
		end
	end
}
ViewElementTraitInventoryBlueprints.unknown_trait = {
	size = {
		110,
		110
	},
	pass_template = {
		{
			value = "content/ui/materials/frames/line_thin_detailed_02",
			pass_type = "texture",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					0,
					0,
					3
				},
				color = Color.terminal_frame(255, true)
			}
		},
		{
			value = "content/ui/materials/icons/traits/traits_container",
			style_id = "icon",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				material_values = {
					icon = "content/ui/textures/icons/traits/weapon_trait_unknown"
				},
				size = {
					64,
					64
				},
				offset = {
					0,
					0,
					5
				},
				color = Color.terminal_icon(100, true)
			}
		}
	}
}

return ViewElementTraitInventoryBlueprints
