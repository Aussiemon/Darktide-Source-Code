local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ItemPassTemplates = require("scripts/ui/pass_templates/item_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local InventoryViewSettings = require("scripts/ui/views/inventory_view/inventory_view_settings")
local ItemUtils = require("scripts/utilities/items")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local grid_size = InventoryViewSettings.grid_size
local grid_width = grid_size[1]
local group_header_font_style = table.clone(UIFontSettings.header_3)
group_header_font_style.offset = {
	0,
	0,
	3
}
group_header_font_style.text_horizontal_alignment = "center"
group_header_font_style.text_vertical_alignment = "center"
group_header_font_style.text_color = Color.ui_grey_light(255, true)
local sub_header_font_style = table.clone(UIFontSettings.header_3)
sub_header_font_style.offset = {
	0,
	0,
	3
}
sub_header_font_style.font_size = 18
sub_header_font_style.text_horizontal_alignment = "center"
sub_header_font_style.text_vertical_alignment = "center"
sub_header_font_style.text_color = Color.ui_grey_medium(255, true)
local cosmetic_item_display_name_text_style = table.clone(UIFontSettings.header_3)
cosmetic_item_display_name_text_style.text_horizontal_alignment = "left"
cosmetic_item_display_name_text_style.text_vertical_alignment = "center"
cosmetic_item_display_name_text_style.horizontal_alignment = "left"
cosmetic_item_display_name_text_style.vertical_alignment = "center"
cosmetic_item_display_name_text_style.offset = {
	10,
	0,
	5
}
cosmetic_item_display_name_text_style.size = {
	grid_width - 20,
	50
}

local function _apply_package_item_icon_cb_func(widget, item)
	local icon = item.icon
	widget.style.icon.material_values.texture_icon = icon
	widget.style.icon.material_values.use_placeholder_texture = 0
end

local function _remove_package_item_icon_cb_func(widget, ui_renderer)
	if widget.content.visible then
		UIWidget.set_visible(widget, ui_renderer, false)
		UIWidget.set_visible(widget, ui_renderer, true)
	end

	local material_values = widget.style.icon.material_values
	widget.style.icon.material_values.texture_icon = nil
	material_values.use_placeholder_texture = 1
end

local function _apply_live_item_icon_cb_func(widget, grid_index, rows, columns)
	local material_values = widget.style.icon.material_values
	material_values.use_placeholder_texture = 0
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
end

local function _remove_live_item_icon_cb_func(widget)
	local material_values = widget.style.icon.material_values
	material_values.use_placeholder_texture = 1
end

local blueprints = {
	dynamic_spacing = {
		size = {
			0,
			0
		},
		size_function = function (parent, config)
			return config.size
		end
	},
	spacing_vertical = {
		size = {
			grid_width,
			20
		}
	},
	spacing_vertical_small = {
		size = {
			grid_width,
			10
		}
	},
	button = {
		size = {
			grid_width,
			50
		},
		pass_template = ButtonPassTemplates.list_button,
		init = function (parent, widget, element, callback_name)
			local content = widget.content
			content.text = element.display_name
		end
	},
	list_button_with_background = {
		size = {
			0,
			0
		},
		size_function = function (parent, config)
			return config.size
		end,
		pass_template = ButtonPassTemplates.list_button_with_background,
		init = function (parent, widget, element, callback_name)
			local content = widget.content
			content.element = element
			content.text = Utf8.upper(Localize(element.display_name))
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
			content.hotspot.disabled = element and element.disabled
		end
	},
	cosmetic_item = {
		size = {
			grid_width,
			60
		},
		pass_template = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "hotspot",
				style = {
					on_hover_sound = UISoundEvents.default_mouse_hover,
					on_pressed_sound = UISoundEvents.apparel_select
				}
			},
			{
				value = "content/ui/materials/frames/hover",
				pass_type = "texture",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					hdr = true,
					color = Color.ui_terminal(255, true),
					size_addition = {
						20,
						20
					},
					offset = {
						0,
						0,
						0
					}
				},
				change_function = function (content, style)
					local anim_progress = math.max(math.max(content.hotspot.anim_hover_progress, content.hotspot.anim_select_progress), content.hotspot.anim_focus_progress)
					style.color[1] = anim_progress * 255
					local size_addition = style.size_addition
					local size_padding = 10 - math.easeInCubic(anim_progress) * 10
					size_addition[1] = size_padding
					size_addition[2] = size_padding
				end
			},
			{
				value_id = "title_text",
				style_id = "title_text",
				pass_type = "text",
				value = "n/a",
				style = cosmetic_item_display_name_text_style
			},
			{
				style_id = "background",
				pass_type = "texture",
				value = "content/ui/materials/buttons/background_selected",
				style = {
					color = Color.ui_terminal(255, true)
				},
				visibility_function = function (content, style)
					return content.equipped
				end
			},
			{
				style_id = "equip_icon",
				pass_type = "texture",
				value = "content/ui/materials/buttons/background_selected",
				style = {
					vertical_alignment = "center",
					horizontal_alignment = "right",
					size = {
						10,
						10
					},
					offset = {
						-10,
						0,
						3
					},
					color = Color.ui_terminal(255, true)
				},
				visibility_function = function (content, style)
					return content.equipped
				end
			}
		},
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
			local slot = element.slot

			if slot then
				local slot_name = slot.name
				local item = element.item
				local item_name = item and item.name
				local equipped_item = parent:equipped_item_in_slot(slot_name)
				local equipped_item_name = equipped_item and equipped_item.name
				content.equipped = item_name and item_name == equipped_item_name
			end
		end,
		init = function (parent, widget, element, callback_name, secondary_callback_name)
			local content = widget.content
			local item = element.item
			local icon = element.icon or item and item.icon or "content/ui/materials/icons/items/default"
			content.title_text = ItemUtils.display_name(item)
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, element)
			content.hotspot.right_pressed_callback = callback(parent, secondary_callback_name, widget, element)
			content.element = element
		end
	},
	emote_item_slot = {
		size = {
			grid_width,
			50
		},
		pass_template = ItemPassTemplates.emote_item_slot,
		init = function (parent, widget, element, callback_name)
			local content = widget.content
			local style = widget.style
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, element)
			content.element = element
			local slot = element.slot

			if slot then
				local slot_name = slot.name
				local slot_display_name = slot.display_name
				local slot_icon_angle = slot.icon_angle
				local equipped_item = parent:equipped_item_in_slot(slot_name)
				content.item = equipped_item
				style.slot_icon.angle = slot_icon_angle or 0
				content.title_text = Localize(slot_display_name)
				local item_display_name = equipped_item and equipped_item.display_name

				if item_display_name then
					content.name_text = ItemUtils.display_name(equipped_item)
				else
					content.name_text = Localize("loc_item_slot_empty")
				end
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
			local slot = element.slot

			if slot then
				local slot_name = slot.name
				local slot_display_name = slot.display_name
				local item = content.item
				local item_name = item and item.name
				local equipped_item = parent:equipped_item_in_slot(slot_name)
				local equipped_item_name = equipped_item and equipped_item.name
				local update = item_name ~= equipped_item_name

				if update then
					content.item = equipped_item
					content.title_text = Localize(slot_display_name)
					local item_display_name = equipped_item and equipped_item.display_name

					if item_display_name then
						content.name_text = ItemUtils.display_name(equipped_item)
					else
						content.name_text = Localize("loc_item_slot_empty")
					end
				end
			end
		end
	},
	animation_item_slot = {
		size = {
			grid_width,
			50
		},
		pass_template = ItemPassTemplates.animation_item_slot,
		init = function (parent, widget, element, callback_name)
			local content = widget.content
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, element)
			content.element = element
			local slot = element.slot

			if slot then
				local slot_name = slot.name
				local slot_display_name = slot.display_name
				local equipped_item = parent:equipped_item_in_slot(slot_name)
				content.item = equipped_item
				content.title_text = Localize(slot_display_name)
				local item_display_name = equipped_item and equipped_item.display_name

				if item_display_name then
					content.name_text = ItemUtils.display_name(equipped_item)
				else
					content.name_text = Localize("loc_item_slot_empty")
				end
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
			local slot = element.slot

			if slot then
				local slot_name = slot.name
				local slot_display_name = slot.display_name
				local item = content.item
				local item_name = item and item.name
				local equipped_item = parent:equipped_item_in_slot(slot_name)
				local equipped_item_name = equipped_item and equipped_item.name
				local update = item_name ~= equipped_item_name

				if update then
					content.item = equipped_item
					content.title_text = Localize(slot_display_name)
					local item_display_name = equipped_item and equipped_item.display_name

					if item_display_name then
						content.name_text = ItemUtils.display_name(equipped_item)
					else
						content.name_text = Localize("loc_item_slot_empty")
					end
				end
			end
		end
	},
	ui_item = {
		size = ItemPassTemplates.ui_item_size,
		pass_template = ItemPassTemplates.ui_item,
		init = function (parent, widget, element, callback_name, secondary_callback_name)
			local content = widget.content
			local style = widget.style
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, element)
			content.hotspot.right_pressed_callback = callback(parent, secondary_callback_name, widget, element)
			content.element = element
			local slot = element.slot

			if slot then
				local item = element.item
				content.item = item
				local display_name = item and item.display_name

				if display_name then
					content.display_name = ItemUtils.display_name(item)
					content.sub_display_name = ItemUtils.sub_display_name(item)
				end

				local _, rarity_side_texture = ItemUtils.rarity_textures(item)
				content.rarity_side_texture = rarity_side_texture
				local item_icon_size = slot.item_icon_size
				style.icon.material_values.icon_size = item_icon_size
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
			local slot = element.slot
			local slot_name = slot.name
			local item = content.item
			local equipped_item = parent:equipped_item_in_slot(slot_name)
			local is_equipped = equipped_item and item and item.gear_id ~= equipped_item.gear_id
			content.equipped = is_equipped
		end,
		load_icon = function (parent, widget, element)
			local content = widget.content

			if not content.icon_load_id then
				local item = element.item
				local slot = element.slot
				local slot_name = slot.name
				local cb = callback(_apply_package_item_icon_cb_func, widget, item)
				local render_context = {
					camera_focus_slot_name = slot_name
				}
				content.icon_load_id = Managers.ui:load_item_icon(item, cb, render_context)
			end
		end,
		unload_icon = function (parent, widget, element, ui_renderer)
			local content = widget.content

			if content.icon_load_id then
				_remove_package_item_icon_cb_func(widget, ui_renderer)
				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end,
		destroy = function (parent, widget, element, ui_renderer)
			local content = widget.content

			if content.icon_load_id then
				_remove_package_item_icon_cb_func(widget, ui_renderer)
				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end
	},
	ui_item_slot = {
		size = ItemPassTemplates.ui_item_size,
		pass_template = ItemPassTemplates.ui_item_slot,
		init = function (parent, widget, element, callback_name, secondary_callback_name)
			local content = widget.content
			local style = widget.style
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, element)
			content.element = element
			local slot_title = element.slot_title
			content.slot_title = slot_title and Utf8.upper(Localize(slot_title)) or ""
			local slot = element.slot

			if slot then
				local slot_name = slot.name
				local equipped_item = parent:equipped_item_in_slot(slot_name)
				content.item = equipped_item
				local display_name = equipped_item and equipped_item.display_name

				if display_name then
					content.display_name = ItemUtils.display_name(equipped_item)
					content.sub_display_name = ItemUtils.sub_display_name(equipped_item)
				end

				local item_icon_size = slot.item_icon_size
				style.icon.material_values.icon_size = item_icon_size

				if equipped_item then
					local cb = callback(_apply_package_item_icon_cb_func, widget, equipped_item)
					content.icon_load_id = Managers.ui:load_item_icon(equipped_item, cb)
				end
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
			local slot = element.slot

			if slot then
				local slot_name = slot.name
				local previous_item = content.item
				local equipped_item = parent:equipped_item_in_slot(slot_name)
				local update = not equipped_item and previous_item or previous_item and previous_item.gear_id ~= equipped_item.gear_id

				if update then
					content.item = equipped_item
					local display_name = equipped_item and equipped_item.display_name

					if display_name then
						content.display_name = ItemUtils.display_name(equipped_item)
						content.sub_display_name = ItemUtils.sub_display_name(equipped_item)
					end

					if content.icon_load_id then
						_remove_package_item_icon_cb_func(widget, ui_renderer)
						Managers.ui:unload_item_icon(content.icon_load_id)

						content.icon_load_id = nil
					end

					if equipped_item then
						local cb = callback(_apply_package_item_icon_cb_func, widget, equipped_item)
						content.icon_load_id = Managers.ui:load_item_icon(equipped_item, cb)
					end
				end
			end
		end,
		destroy = function (parent, widget, element, ui_renderer)
			local content = widget.content

			if content.icon_load_id then
				_remove_package_item_icon_cb_func(widget, ui_renderer)
				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end
	},
	gear_item = {
		size = ItemPassTemplates.gear_icon_size,
		pass_template = ItemPassTemplates.gear_item,
		init = function (parent, widget, element, callback_name, secondary_callback_name)
			local content = widget.content
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, element)
			content.hotspot.right_pressed_callback = callback(parent, secondary_callback_name, widget, element)
			content.element = element
			local slot = element.slot

			if slot then
				local item = element.item
				content.item = item
				local display_name = item and item.display_name

				if display_name then
					content.display_name = ItemUtils.display_name(item)
					content.sub_display_name = ItemUtils.sub_display_name(item)
				end
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
			local slot = element.slot
			local slot_name = slot.name
			local item = content.item
			local equipped_item = parent:equipped_item_in_slot(slot_name)
			local is_equipped = equipped_item and item and item.gear_id ~= equipped_item.gear_id
			content.equipped = is_equipped
		end,
		load_icon = function (parent, widget, element)
			local content = widget.content

			if not content.icon_load_id then
				local item = element.item
				local slot = element.slot
				local slot_name = slot.name
				local cb = callback(_apply_live_item_icon_cb_func, widget)
				local item_state_machine = item.state_machine
				local item_animation_event = item.animation_event
				local render_context = {
					camera_focus_slot_name = slot_name,
					state_machine = item_state_machine,
					animation_event = item_animation_event
				}
				content.icon_load_id = Managers.ui:load_item_icon(item, cb, render_context)
			end
		end,
		unload_icon = function (parent, widget, element, ui_renderer)
			local content = widget.content

			if content.icon_load_id then
				_remove_live_item_icon_cb_func(widget)
				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end,
		destroy = function (parent, widget, element, ui_renderer)
			local content = widget.content

			if content.icon_load_id then
				_remove_live_item_icon_cb_func(widget)
				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end
	},
	gear_item_slot = {
		size = ItemPassTemplates.gear_icon_size,
		pass_template = ItemPassTemplates.gear_item_slot,
		init = function (parent, widget, element, callback_name, secondary_callback_name)
			local content = widget.content
			local style = widget.style
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, element)
			content.element = element
			local slot_title = element.slot_title
			content.slot_title = slot_title and Utf8.upper(Localize(slot_title)) or ""
			local slot = element.slot

			if slot then
				local slot_name = slot.name
				local equipped_item = parent:equipped_item_in_slot(slot_name)
				content.item = equipped_item
				local display_name = equipped_item and equipped_item.display_name

				if display_name then
					content.display_name = ItemUtils.display_name(equipped_item)
					content.sub_display_name = ItemUtils.sub_display_name(equipped_item)
				end

				if equipped_item then
					local cb = callback(_apply_live_item_icon_cb_func, widget)
					local render_context = {
						camera_focus_slot_name = slot_name
					}
					content.icon_load_id = Managers.ui:load_item_icon(equipped_item, cb, render_context)
				end
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local style = widget.style
			local element = content.element
			local slot = element.slot

			if slot then
				local slot_name = slot.name
				local previous_item = content.item
				local equipped_item = parent:equipped_item_in_slot(slot_name)
				local update = not equipped_item and previous_item or previous_item and previous_item.gear_id ~= equipped_item.gear_id

				if update then
					content.item = equipped_item
					local display_name = equipped_item and equipped_item.display_name

					if display_name then
						content.display_name = ItemUtils.display_name(equipped_item)
						content.sub_display_name = ItemUtils.sub_display_name(equipped_item)
					end

					if content.icon_load_id then
						_remove_live_item_icon_cb_func(widget)
						Managers.ui:unload_item_icon(content.icon_load_id)

						content.icon_load_id = nil
					end

					if equipped_item then
						local cb = callback(_apply_live_item_icon_cb_func, widget)
						local render_context = {
							camera_focus_slot_name = slot_name
						}
						content.icon_load_id = Managers.ui:load_item_icon(equipped_item, cb, render_context)
					end
				end
			end
		end,
		destroy = function (parent, widget, element, ui_renderer)
			local content = widget.content

			if content.icon_load_id then
				_remove_live_item_icon_cb_func(widget)
				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end
	},
	item = {
		size = ItemPassTemplates.icon_size,
		pass_template = ItemPassTemplates.item,
		init = function (parent, widget, element, callback_name, secondary_callback_name)
			local content = widget.content
			local style = widget.style
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, element)
			content.hotspot.right_pressed_callback = callback(parent, secondary_callback_name, widget, element)
			content.element = element
			local slot = element.slot

			if slot then
				local item = element.item
				content.item = item
				local display_name = item and item.display_name

				if display_name then
					content.display_name = ItemUtils.display_name(item)
					content.sub_display_name = ItemUtils.sub_display_name(item)
				end

				local rarity_frame_texture, rarity_side_texture = ItemUtils.rarity_textures(item)
				content.rarity_side_texture = rarity_side_texture
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
			local slot = element.slot

			if slot then
				local slot_name = slot.name
				local item = content.item
				local equipped_item = parent.equipped_item_in_slot and parent:equipped_item_in_slot(slot_name)
				local is_equipped = equipped_item and item and item.gear_id ~= equipped_item.gear_id
				content.equipped = is_equipped
			end
		end,
		load_icon = function (parent, widget, element)
			local content = widget.content

			if not content.icon_load_id then
				local item = element.item
				local cb = callback(_apply_live_item_icon_cb_func, widget)
				content.icon_load_id = Managers.ui:load_item_icon(item, cb)
			end
		end,
		unload_icon = function (parent, widget, element, ui_renderer)
			local content = widget.content

			if content.icon_load_id then
				_remove_live_item_icon_cb_func(widget)
				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end,
		destroy = function (parent, widget, element, ui_renderer)
			local content = widget.content

			if content.icon_load_id then
				_remove_live_item_icon_cb_func(widget)
				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end
	},
	item_slot = {
		size = ItemPassTemplates.item_size,
		pass_template = ItemPassTemplates.item_slot,
		init = function (parent, widget, element, callback_name)
			local content = widget.content
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, element)
			content.element = element
			local slot = element.slot

			if slot then
				local slot_name = slot.name
				local equipped_item = parent:equipped_item_in_slot(slot_name)
				content.item = equipped_item
				local display_name = equipped_item and equipped_item.display_name

				if display_name then
					content.display_name = ItemUtils.display_name(equipped_item)
					content.sub_display_name = ItemUtils.sub_display_name(equipped_item)
				end

				local _, rarity_side_texture = ItemUtils.rarity_textures(equipped_item)
				content.rarity_side_texture = rarity_side_texture

				if equipped_item then
					local cb = callback(_apply_live_item_icon_cb_func, widget)
					content.icon_load_id = Managers.ui:load_item_icon(equipped_item, cb)
				end
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
			local slot = element.slot

			if slot then
				local slot_name = slot.name
				local previous_item = content.item
				local equipped_item = parent:equipped_item_in_slot(slot_name)
				local update = not equipped_item and previous_item or previous_item and previous_item.gear_id ~= equipped_item.gear_id

				if update then
					content.item = equipped_item
					local display_name = equipped_item and equipped_item.display_name

					if display_name then
						content.display_name = ItemUtils.display_name(equipped_item)
						content.sub_display_name = ItemUtils.sub_display_name(equipped_item)
					end

					local _, rarity_side_texture = ItemUtils.rarity_textures(equipped_item)
					content.rarity_side_texture = rarity_side_texture

					if content.icon_load_id then
						_remove_live_item_icon_cb_func(widget)
						Managers.ui:unload_item_icon(content.icon_load_id)

						content.icon_load_id = nil
					end

					if equipped_item then
						local cb = callback(_apply_live_item_icon_cb_func, widget)
						content.icon_load_id = Managers.ui:load_item_icon(equipped_item, cb)
					end
				end
			end
		end,
		destroy = function (parent, widget, element, ui_renderer)
			local content = widget.content

			if content.icon_load_id then
				_remove_live_item_icon_cb_func(widget)
				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end
	},
	gadget_item_slot = {
		size = ItemPassTemplates.gadget_size,
		pass_template = ItemPassTemplates.gadget_item_slot,
		init = function (parent, widget, element, callback_name)
			local content = widget.content
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, element)
			content.element = element
			local slot = element.slot

			if slot then
				local slot_name = slot.name
				local equipped_item = parent:equipped_item_in_slot(slot_name)
				content.item = equipped_item
				local display_name = equipped_item and equipped_item.display_name

				if display_name then
					content.display_name = ItemUtils.display_name(equipped_item)
					content.sub_display_name = ItemUtils.sub_display_name(equipped_item)
				end

				local _, rarity_side_texture = ItemUtils.rarity_textures(equipped_item)
				content.rarity_side_texture = rarity_side_texture

				if equipped_item then
					local cb = callback(_apply_live_item_icon_cb_func, widget)
					content.icon_load_id = Managers.ui:load_item_icon(equipped_item, cb)
				end
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
			local slot = element.slot

			if slot then
				local slot_name = slot.name
				local previous_item = content.item
				local equipped_item = parent:equipped_item_in_slot(slot_name)
				local update = not equipped_item and previous_item or previous_item and previous_item.gear_id ~= equipped_item.gear_id

				if update then
					content.item = equipped_item
					local display_name = equipped_item and equipped_item.display_name

					if display_name then
						content.display_name = ItemUtils.display_name(equipped_item)
						content.sub_display_name = ItemUtils.sub_display_name(equipped_item)
					end

					local _, rarity_side_texture = ItemUtils.rarity_textures(equipped_item)
					content.rarity_side_texture = rarity_side_texture

					if content.icon_load_id then
						_remove_live_item_icon_cb_func(widget)
						Managers.ui:unload_item_icon(content.icon_load_id)

						content.icon_load_id = nil
					end

					if equipped_item then
						local cb = callback(_apply_live_item_icon_cb_func, widget)
						content.icon_load_id = Managers.ui:load_item_icon(equipped_item, cb)
					end
				end
			end
		end,
		destroy = function (parent, widget, element, ui_renderer)
			local content = widget.content

			if content.icon_load_id then
				_remove_live_item_icon_cb_func(widget)
				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end
	},
	group_header = {
		size = {
			grid_width,
			70
		},
		pass_template = {
			{
				value = "n/a",
				pass_type = "text",
				value_id = "text",
				style = group_header_font_style
			}
		},
		init = function (parent, widget, element, callback_name)
			local content = widget.content
			local display_name = element.display_name
			local text = Utf8.upper(Localize(display_name))
			content.element = element
			content.localized_display_name = text
			content.text = text
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
			local display_name = element.display_name
			local group_header = content.group_header
			local suffix_text = nil
			local text = content.localized_display_name

			if suffix_text then
				text = "{#color(194,154,116)}" .. text .. " {#color(255,242,230)}" .. Localize(suffix_text)
			end

			content.text = text
		end
	},
	sub_header = {
		size = {
			grid_width,
			20
		},
		pass_template = {
			{
				value = "n/a",
				pass_type = "text",
				value_id = "text",
				style = sub_header_font_style
			}
		},
		init = function (parent, widget, element, callback_name)
			local content = widget.content
			local display_name = element.display_name
			local text = Utf8.upper(Localize(display_name))
			content.element = element
			content.localized_display_name = text
			content.text = text
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
			local display_name = element.display_name
			local group_header = content.group_header
			local suffix_text = nil
			local text = content.localized_display_name

			if suffix_text then
				text = "{#color(194,154,116)}" .. text .. " {#color(255,242,230)}" .. Localize(suffix_text)
			end

			content.text = text
		end
	}
}

return blueprints
