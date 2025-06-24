-- chunkname: @scripts/ui/views/inventory_view/inventory_view_content_blueprints.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local Colors = require("scripts/utilities/ui/colors")
local InventoryViewSettings = require("scripts/ui/views/inventory_view/inventory_view_settings")
local ItemPassTemplates = require("scripts/ui/pass_templates/item_pass_templates")
local Items = require("scripts/utilities/items")
local ProfileUtils = require("scripts/utilities/profile_utils")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local grid_size = InventoryViewSettings.grid_size
local grid_width = grid_size[1]
local group_header_font_style = table.clone(UIFontSettings.header_3)

group_header_font_style.offset = {
	0,
	0,
	3,
}
group_header_font_style.text_horizontal_alignment = "center"
group_header_font_style.text_vertical_alignment = "center"
group_header_font_style.text_color = Color.ui_grey_light(255, true)

local sub_header_font_style = table.clone(UIFontSettings.header_3)

sub_header_font_style.offset = {
	0,
	0,
	3,
}
sub_header_font_style.font_size = 18
sub_header_font_style.text_horizontal_alignment = "center"
sub_header_font_style.text_vertical_alignment = "center"
sub_header_font_style.text_color = Color.ui_grey_medium(255, true)

local item_sub_header_font_style = table.clone(UIFontSettings.header_1)

item_sub_header_font_style.offset = {
	0,
	0,
	3,
}
item_sub_header_font_style.font_size = 32
item_sub_header_font_style.text_color = {
	255,
	255,
	255,
	255,
}
item_sub_header_font_style.text_horizontal_alignment = "center"
item_sub_header_font_style.text_vertical_alignment = "center"
item_sub_header_font_style.material = "content/ui/materials/font_gradients/slug_font_gradient_rust"

local cosmetic_item_display_name_text_style = table.clone(UIFontSettings.header_3)

cosmetic_item_display_name_text_style.text_horizontal_alignment = "left"
cosmetic_item_display_name_text_style.text_vertical_alignment = "center"
cosmetic_item_display_name_text_style.horizontal_alignment = "left"
cosmetic_item_display_name_text_style.vertical_alignment = "center"
cosmetic_item_display_name_text_style.offset = {
	10,
	0,
	5,
}
cosmetic_item_display_name_text_style.size = {
	grid_width - 20,
	50,
}

local function _apply_package_item_icon_cb_func(widget, item)
	local icon_style = widget.style.icon
	local item_slot = Items.item_slot(item)
	local item_icon_size = item_slot and item_slot.item_icon_size
	local material_values = icon_style.material_values

	if item.icon_material and item.icon_material ~= "" then
		widget.content.old_icon_material = widget.content.icon
		widget.content.icon = item.icon_material

		if item_icon_size then
			icon_style.size = item_icon_size
			icon_style.old_horizontal_alignment = icon_style.horizontal_alignment
			icon_style.old_vertical_alignment = icon_style.vertical_alignment
			icon_style.horizontal_alignment = "center"
			icon_style.vertical_alignment = "center"
		end
	else
		material_values.texture_icon = item.icon
	end

	material_values.use_placeholder_texture = 0
	material_values.use_render_target = 0
	widget.content.use_placeholder_texture = material_values.use_placeholder_texture
end

local function _remove_package_item_icon_cb_func(widget, ui_renderer)
	UIWidget.set_visible(widget, ui_renderer, false)
	UIWidget.set_visible(widget, ui_renderer, true)

	local material_values = widget.style.icon.material_values

	widget.style.icon.material_values.texture_icon = nil
	material_values.use_placeholder_texture = 1

	local icon_style = widget.style.icon

	icon_style.size = nil

	if icon_style.old_horizontal_alignment then
		icon_style.horizontal_alignment = icon_style.old_horizontal_alignment
		icon_style.old_horizontal_alignment = nil
	end

	if icon_style.old_vertical_alignment then
		icon_style.vertical_alignment = icon_style.old_vertical_alignment
		icon_style.old_vertical_alignment = nil
	end

	if widget.content.old_icon_material then
		widget.content.icon = widget.content.old_icon_material
		widget.content.old_icon_material = nil
	end

	widget.content.use_placeholder_texture = material_values.use_placeholder_texture
end

local function _apply_live_item_icon_cb_func(widget, grid_index, rows, columns, render_target)
	local material_values = widget.style.icon.material_values

	material_values.use_placeholder_texture = 0
	material_values.use_render_target = 1
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = type(grid_index) == "number" and grid_index - 1 or nil
	material_values.render_target = render_target
	widget.content.use_placeholder_texture = material_values.use_placeholder_texture
end

local function _remove_live_item_icon_cb_func(widget, ui_renderer)
	if widget.content.visible then
		UIWidget.set_visible(widget, ui_renderer, false)
		UIWidget.set_visible(widget, ui_renderer, true)
	end

	local material_values = widget.style.icon.material_values

	material_values.use_placeholder_texture = 1
	widget.content.use_placeholder_texture = material_values.use_placeholder_texture
	material_values.render_target = nil
end

local blueprints = {
	dynamic_spacing = {
		size = {
			0,
			0,
		},
		size_function = function (parent, config)
			return config.size
		end,
	},
	spacing_vertical = {
		size = {
			grid_width,
			20,
		},
	},
	spacing_vertical_small = {
		size = {
			grid_width,
			10,
		},
	},
	button = {
		size = {
			grid_width,
			50,
		},
		pass_template = ButtonPassTemplates.list_button,
		init = function (parent, widget, element, callback_name)
			local content = widget.content

			content.text = element.display_name
		end,
	},
	list_button_with_background = {
		size = {
			0,
			0,
		},
		size_function = function (parent, config)
			return config.size
		end,
		pass_template = ButtonPassTemplates.list_button_with_background,
		init = function (parent, widget, element, callback_name)
			local content = widget.content

			content.element = element
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, element)
			content.text = Utf8.upper(Localize(element.display_name))
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element

			content.hotspot.disabled = element and element.disabled
		end,
	},
	cosmetic_item = {
		size = {
			grid_width,
			60,
		},
		pass_template = {
			{
				content_id = "hotspot",
				pass_type = "hotspot",
				style_id = "hotspot",
				style = {
					on_hover_sound = UISoundEvents.default_mouse_hover,
					on_pressed_sound = UISoundEvents.apparel_select,
				},
			},
			{
				pass_type = "texture",
				value = "content/ui/materials/frames/hover",
				style = {
					hdr = true,
					horizontal_alignment = "center",
					vertical_alignment = "center",
					color = Color.ui_terminal(255, true),
					size_addition = {
						20,
						20,
					},
					offset = {
						0,
						0,
						0,
					},
				},
				change_function = function (content, style)
					local anim_progress = math.max(math.max(content.hotspot.anim_hover_progress, content.hotspot.anim_select_progress), content.hotspot.anim_focus_progress)

					style.color[1] = anim_progress * 255

					local size_addition = style.size_addition
					local size_padding = 10 - math.easeInCubic(anim_progress) * 10

					size_addition[1] = size_padding
					size_addition[2] = size_padding
				end,
			},
			{
				pass_type = "text",
				style_id = "title_text",
				value = "n/a",
				value_id = "title_text",
				style = cosmetic_item_display_name_text_style,
			},
			{
				pass_type = "texture",
				style_id = "background",
				value = "content/ui/materials/buttons/background_selected",
				style = {
					color = Color.ui_terminal(255, true),
				},
				visibility_function = function (content, style)
					return content.equipped
				end,
			},
			{
				pass_type = "texture",
				style_id = "equip_icon",
				value = "content/ui/materials/buttons/background_selected",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "center",
					size = {
						10,
						10,
					},
					offset = {
						-10,
						0,
						3,
					},
					color = Color.ui_terminal(255, true),
				},
				visibility_function = function (content, style)
					return content.equipped
				end,
			},
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

			content.title_text = Items.display_name(item)
			content.hotspot.pressed_callback = callback(parent, callback_name, widget, element)
			content.hotspot.right_pressed_callback = callback(parent, secondary_callback_name, widget, element)
			content.element = element
		end,
	},
	emote_item_slot = {
		size = {
			64,
			64,
		},
		pass_template = ItemPassTemplates.ui_item_emote_slot,
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
					content.display_name = Items.display_name(equipped_item)
					content.sub_display_name = Items.sub_display_name(equipped_item)
				end

				local item_icon_size = slot.item_icon_size

				style.icon.material_values.icon_size = {
					item_icon_size[1] * 0.5,
					item_icon_size[2] * 0.5,
				}

				local icon_color = slot.icon_color

				if icon_color then
					local color = style.icon.color

					color[1] = icon_color[1]
					color[2] = icon_color[2]
					color[3] = icon_color[3]
					color[4] = icon_color[4]
				end

				if equipped_item then
					local cb = callback(_apply_package_item_icon_cb_func, widget, equipped_item)

					content.icon_load_id = Managers.ui:load_item_icon(equipped_item, cb)
				end

				local rarity = equipped_item and equipped_item.rarity

				if rarity then
					local _, rarity_color_dark = Items.rarity_color(equipped_item)

					if rarity_color_dark then
						style.background_gradient.color = table.clone(rarity_color_dark)
					end
				else
					style.background_gradient.color = style.background_gradient.default_color
				end
			end

			content.has_new_items_update_callback = element.has_new_items_update_callback
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
			local slot = element.slot

			if slot then
				local slot_name = slot.name
				local previous_item = content.item
				local equipped_item = parent:equipped_item_in_slot(slot_name)
				local update = equipped_item and not previous_item or not equipped_item and previous_item or previous_item and previous_item.gear_id ~= equipped_item.gear_id

				if update then
					content.item = equipped_item

					local display_name = equipped_item and equipped_item.display_name

					if display_name then
						content.display_name = Items.display_name(equipped_item)
						content.sub_display_name = Items.sub_display_name(equipped_item)
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

					local style = widget.style
					local rarity = equipped_item and equipped_item.rarity

					if rarity then
						local _, rarity_color_dark = Items.rarity_color(equipped_item)

						if rarity_color_dark then
							style.background_gradient.color = table.clone(rarity_color_dark)
						end
					else
						style.background_gradient.color = style.background_gradient.default_color
					end
				end
			end

			local item_type = element.item_type
			local has_new_items = item_type and content.has_new_items_update_callback and content.has_new_items_update_callback(item_type) or false

			content.has_new_items = has_new_items
		end,
		destroy = function (parent, widget, element, ui_renderer)
			local content = widget.content

			if content.icon_load_id then
				_remove_package_item_icon_cb_func(widget, ui_renderer)
				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end,
	},
	animation_item_slot = {
		size = {
			grid_width,
			50,
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
					content.name_text = Items.display_name(equipped_item)
				else
					content.name_text = Localize("loc_item_slot_empty")
				end

				local style = widget.style
				local rarity = equipped_item and equipped_item.rarity

				if rarity then
					local _, rarity_color_dark = Items.rarity_color(equipped_item)

					if rarity_color_dark then
						style.background_gradient.color = table.clone(rarity_color_dark)
					end
				else
					style.background_gradient.color = style.background_gradient.default_color
				end
			end

			content.has_new_items_update_callback = element.has_new_items_update_callback
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
						content.name_text = Items.display_name(equipped_item)
					else
						content.name_text = Localize("loc_item_slot_empty")
					end
				end
			end

			local item_type = element.item_type
			local has_new_items = item_type and content.has_new_items_update_callback and content.has_new_items_update_callback(item_type) or false

			content.has_new_items = has_new_items
		end,
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
					content.display_name = Items.display_name(item)
					content.sub_display_name = Items.sub_display_name(item)
				end

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
					camera_focus_slot_name = slot_name,
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
		end,
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
					content.display_name = Items.display_name(equipped_item)
					content.sub_display_name = Items.sub_display_name(equipped_item)
				end

				local rarity = equipped_item and equipped_item.rarity

				if rarity then
					local _, rarity_color_dark = Items.rarity_color(equipped_item)

					if rarity_color_dark then
						style.background_gradient.color = table.clone(rarity_color_dark)
					end
				else
					style.background_gradient.color = style.background_gradient.default_color
				end

				local item_icon_size = slot.item_icon_size

				style.icon.material_values.icon_size = item_icon_size

				if equipped_item then
					local cb = callback(_apply_package_item_icon_cb_func, widget, equipped_item)

					content.icon_load_id = Managers.ui:load_item_icon(equipped_item, cb)
				end
			end

			content.has_new_items_update_callback = element.has_new_items_update_callback
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
				local update = equipped_item and not previous_item or not equipped_item and previous_item or previous_item and previous_item.gear_id ~= equipped_item.gear_id

				if update then
					content.item = equipped_item

					local display_name = equipped_item and equipped_item.display_name

					if display_name then
						content.display_name = Items.display_name(equipped_item)
						content.sub_display_name = Items.sub_display_name(equipped_item)
					end

					local rarity = equipped_item and equipped_item.rarity

					if rarity then
						local _, rarity_color_dark = Items.rarity_color(equipped_item)

						if rarity_color_dark then
							style.background_gradient.color = table.clone(rarity_color_dark)
						end
					else
						style.background_gradient.color = style.background_gradient.default_color
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

			local item_type = element.item_type
			local has_new_items = item_type and content.has_new_items_update_callback and content.has_new_items_update_callback(item_type) or false

			content.has_new_items = has_new_items
		end,
		destroy = function (parent, widget, element, ui_renderer)
			local content = widget.content

			if content.icon_load_id then
				_remove_package_item_icon_cb_func(widget, ui_renderer)
				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end,
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
					content.display_name = Items.display_name(item)
					content.sub_display_name = Items.sub_display_name(item)
				end

				local style = widget.style
				local rarity = item and item.rarity

				if rarity then
					local _, rarity_color_dark = Items.rarity_color(item)

					if rarity_color_dark then
						style.background_gradient.color = table.clone(rarity_color_dark)
					end
				else
					style.background_gradient.color = style.background_gradient.default_color
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
					animation_event = item_animation_event,
				}

				content.icon_load_id = Managers.ui:load_item_icon(item, cb, render_context)
			end
		end,
		unload_icon = function (parent, widget, element, ui_renderer)
			local content = widget.content

			if content.icon_load_id then
				_remove_live_item_icon_cb_func(widget, ui_renderer)
				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end,
		destroy = function (parent, widget, element, ui_renderer)
			local content = widget.content

			if content.icon_load_id then
				_remove_live_item_icon_cb_func(widget, ui_renderer)
				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end,
	},
	pose_item_slot = {
		size = {
			64,
			64,
		},
		pass_template = ItemPassTemplates.ui_item_pose_slot,
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
					content.display_name = Items.display_name(equipped_item)
					content.sub_display_name = Items.sub_display_name(equipped_item)
				end

				if equipped_item then
					local cb = callback(_apply_live_item_icon_cb_func, widget)
					local item_state_machine = equipped_item.state_machine
					local item_animation_event = equipped_item.animation_event
					local render_context = {
						camera_focus_slot_name = slot_name,
						state_machine = item_state_machine,
						animation_event = item_animation_event,
					}

					content.icon_load_id = Managers.ui:load_item_icon(equipped_item, cb, render_context)
				end

				local rarity = equipped_item and equipped_item.rarity

				if rarity then
					local _, rarity_color_dark = Items.rarity_color(equipped_item)

					if rarity_color_dark then
						style.background_gradient.color = table.clone(rarity_color_dark)
					end
				else
					style.background_gradient.color = style.background_gradient.default_color
				end
			end

			content.has_new_items_update_callback = element.has_new_items_update_callback
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
				local update = equipped_item and not previous_item or not equipped_item and previous_item or previous_item and previous_item.gear_id ~= equipped_item.gear_id

				if update then
					content.item = equipped_item

					local display_name = equipped_item and equipped_item.display_name

					if display_name then
						content.display_name = Items.display_name(equipped_item)
						content.sub_display_name = Items.sub_display_name(equipped_item)
					end

					local rarity = equipped_item and equipped_item.rarity

					if rarity then
						local _, rarity_color_dark = Items.rarity_color(equipped_item)

						if rarity_color_dark then
							style.background_gradient.color = table.clone(rarity_color_dark)
						end
					else
						style.background_gradient.color = style.background_gradient.default_color
					end

					if content.icon_load_id then
						_remove_live_item_icon_cb_func(widget, ui_renderer)
						Managers.ui:unload_item_icon(content.icon_load_id)

						content.icon_load_id = nil
					end

					if equipped_item then
						local cb = callback(_apply_live_item_icon_cb_func, widget)
						local render_context = {
							camera_focus_slot_name = slot_name,
						}

						content.icon_load_id = Managers.ui:load_item_icon(equipped_item, cb, render_context)
					end
				end
			end

			local item_type = element.item_type
			local has_new_items = item_type and content.has_new_items_update_callback and content.has_new_items_update_callback(item_type) or false

			content.has_new_items = has_new_items
		end,
		destroy = function (parent, widget, element, ui_renderer)
			local content = widget.content

			if content.icon_load_id then
				_remove_live_item_icon_cb_func(widget, ui_renderer)
				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end,
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
			local player = parent and parent.player and parent:player()
			local player_profile = player and player:profile()

			if slot then
				local slot_name = slot.name
				local equipped_item = parent:equipped_item_in_slot(slot_name)

				content.item = equipped_item

				local display_name = equipped_item and equipped_item.display_name

				if display_name then
					content.display_name = Items.display_name(equipped_item)
					content.sub_display_name = Items.sub_display_name(equipped_item)
				end

				if equipped_item then
					local cb = callback(_apply_live_item_icon_cb_func, widget)
					local render_context = {
						camera_focus_slot_name = slot_name,
					}

					content.icon_load_id = Managers.ui:load_item_icon(equipped_item, cb, render_context, player_profile)
				end

				local rarity = equipped_item and equipped_item.rarity

				if rarity then
					local _, rarity_color_dark = Items.rarity_color(equipped_item)

					if rarity_color_dark then
						style.background_gradient.color = table.clone(rarity_color_dark)
					end
				else
					style.background_gradient.color = style.background_gradient.default_color
				end
			end

			content.has_new_items_update_callback = element.has_new_items_update_callback
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
				local update = equipped_item and not previous_item or not equipped_item and previous_item or previous_item and previous_item.gear_id ~= equipped_item.gear_id

				if update then
					content.item = equipped_item

					local display_name = equipped_item and equipped_item.display_name

					if display_name then
						content.display_name = Items.display_name(equipped_item)
						content.sub_display_name = Items.sub_display_name(equipped_item)
					end

					local rarity = equipped_item and equipped_item.rarity

					if rarity then
						local _, rarity_color_dark = Items.rarity_color(equipped_item)

						if rarity_color_dark then
							style.background_gradient.color = table.clone(rarity_color_dark)
						end
					else
						style.background_gradient.color = style.background_gradient.default_color
					end

					if content.icon_load_id then
						_remove_live_item_icon_cb_func(widget, ui_renderer)
						Managers.ui:unload_item_icon(content.icon_load_id)

						content.icon_load_id = nil
					end

					if equipped_item then
						local cb = callback(_apply_live_item_icon_cb_func, widget)
						local render_context = {
							camera_focus_slot_name = slot_name,
						}

						content.icon_load_id = Managers.ui:load_item_icon(equipped_item, cb, render_context)
					end
				end
			end

			local item_type = element.item_type
			local has_new_items = item_type and content.has_new_items_update_callback and content.has_new_items_update_callback(item_type) or false

			content.has_new_items = has_new_items
		end,
		destroy = function (parent, widget, element, ui_renderer)
			local content = widget.content

			if content.icon_load_id then
				_remove_live_item_icon_cb_func(widget, ui_renderer)
				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end,
	},
	character_title_item_slot = {
		size = ItemPassTemplates.character_title_button_size,
		pass_template = ItemPassTemplates.character_title_item_slot,
		init = function (parent, widget, element, callback_name, secondary_callback_name)
			local content = widget.content
			local style = widget.style

			content.hotspot.pressed_callback = callback(parent, callback_name, widget, element)
			content.element = element

			local slot_title = element.slot_title

			content.slot_title = slot_title and Utf8.upper(Localize(slot_title)) or ""

			local slot = element.slot
			local player = parent and parent.player and parent:player()
			local player_profile = player and player:profile()

			if slot then
				local slot_name = slot.name
				local equipped_item = parent:equipped_item_in_slot(slot_name)

				content.item = equipped_item
				content.display_name = equipped_item and ProfileUtils.title_item_name_no_color(equipped_item, player_profile) or ""

				local rarity = equipped_item and equipped_item.rarity

				if rarity then
					local _, rarity_color_dark = Items.rarity_color(equipped_item)

					if rarity_color_dark then
						style.background_gradient.color = table.clone(rarity_color_dark)
					end
				else
					style.background_gradient.color = style.background_gradient.default_color
				end
			end

			content.has_new_items_update_callback = element.has_new_items_update_callback
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
				local update = equipped_item and not previous_item or not equipped_item and previous_item or previous_item and previous_item.gear_id ~= equipped_item.gear_id

				if update then
					content.item = equipped_item

					local player = parent and parent.player and parent:player()
					local player_profile = player and player:profile()

					content.display_name = equipped_item and ProfileUtils.title_item_name_no_color(equipped_item, player_profile) or ""

					local rarity = equipped_item and equipped_item.rarity

					if rarity then
						local _, rarity_color_dark = Items.rarity_color(equipped_item)

						if rarity_color_dark then
							style.background_gradient.color = table.clone(rarity_color_dark)
						end
					else
						style.background_gradient.color = style.background_gradient.default_color
					end
				end
			end

			local item_type = element.item_type
			local has_new_items = item_type and content.has_new_items_update_callback and content.has_new_items_update_callback(item_type) or false

			content.has_new_items = has_new_items
		end,
		destroy = function (parent, widget, element, ui_renderer)
			return
		end,
	},
	item_slot = {
		size = ItemPassTemplates.weapon_item_size,
		pass_template = ItemPassTemplates.item_slot,
		init = function (parent, widget, element, callback_name)
			local content = widget.content
			local style = widget.style

			content.hotspot.pressed_callback = callback(parent, callback_name, widget, element)
			content.element = element

			local slot = element.slot

			if slot then
				local slot_name = slot.name
				local equipped_item = parent:equipped_item_in_slot(slot_name)

				content.item = equipped_item

				local display_name = equipped_item and equipped_item.display_name

				if display_name then
					content.display_name = Items.weapon_card_display_name(equipped_item)
					content.sub_display_name = Items.weapon_card_sub_display_name(equipped_item)
					content.rarity_name = Items.rarity_display_name(equipped_item)
				end

				if content.item_power then
					content.item_power = Items.item_power(equipped_item)
				end

				if equipped_item then
					if not equipped_item.is_fallback_item then
						local cb = callback(_apply_live_item_icon_cb_func, widget)

						content.icon_load_id = Managers.ui:load_item_icon(equipped_item, cb)
					else
						content.use_placeholder_texture = 0

						local material_values = style.icon.material_values

						material_values.use_placeholder_texture = 0
					end

					local rarity_color = Items.rarity_color(equipped_item)

					style.rarity_name.text_color = table.clone(rarity_color)
					style.background_gradient.color = table.clone(rarity_color)
					style.rarity_tag.color = table.clone(rarity_color)

					if style.item_level then
						local item_level, has_level = Items.expertise_level(equipped_item)

						content.item_level = has_level and item_level or ""
					end
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
				local update = equipped_item and not previous_item or not equipped_item and previous_item or previous_item and previous_item.gear_id ~= equipped_item.gear_id

				if update then
					content.item = equipped_item

					local display_name = equipped_item and equipped_item.display_name

					if display_name then
						content.display_name = Items.weapon_card_display_name(equipped_item)
						content.sub_display_name = Items.weapon_card_sub_display_name(equipped_item)
						content.rarity_name = Items.rarity_display_name(equipped_item)
					end

					if content.item_power then
						content.item_power = Items.item_power(equipped_item)
					end

					local rarity_color = Items.rarity_color(equipped_item)

					style.rarity_name.text_color = table.clone(rarity_color)
					style.background_gradient.color = table.clone(rarity_color)
					style.rarity_tag.color = table.clone(rarity_color)

					if style.item_level then
						local item_level, has_level = Items.expertise_level(equipped_item)

						content.item_level = has_level and item_level or ""
					end

					if content.icon_load_id then
						_remove_live_item_icon_cb_func(widget, ui_renderer)
						Managers.ui:unload_item_icon(content.icon_load_id)

						content.icon_load_id = nil
					end

					if equipped_item and not equipped_item.is_fallback_item then
						local cb = callback(_apply_live_item_icon_cb_func, widget)

						content.icon_load_id = Managers.ui:load_item_icon(equipped_item, cb)
					else
						content.use_placeholder_texture = 0

						local material_values = style.icon.material_values

						material_values.use_placeholder_texture = 0
						material_values.use_render_target = 1
						material_values.rows = nil
						material_values.columns = nil
						material_values.grid_index = nil
						material_values.render_target = nil
					end
				end

				local updated_mark = previous_item and previous_item.gear_id == equipped_item.gear_id and previous_item.name ~= equipped_item.name

				if updated_mark then
					content.item = equipped_item
					content.display_name = Items.weapon_card_display_name(equipped_item)
					content.sub_display_name = Items.weapon_card_sub_display_name(equipped_item)
					content.rarity_name = Items.rarity_display_name(equipped_item)

					Managers.ui:item_icon_updated(content.item)
				end
			end
		end,
		destroy = function (parent, widget, element, ui_renderer)
			local content = widget.content

			if content.icon_load_id then
				_remove_live_item_icon_cb_func(widget, ui_renderer)
				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end,
	},
	gadget_item_slot = {
		size = ItemPassTemplates.gadget_size,
		pass_template = ItemPassTemplates.gadget_item_slot,
		init = function (parent, widget, element, callback_name)
			local content = widget.content
			local style = widget.style

			content.hotspot.pressed_callback = callback(parent, callback_name, widget, element)
			content.element = element

			local required_level = element.required_level

			if required_level then
				local current_level = parent.profile_level and parent:profile_level()
				local unlocked = required_level <= current_level

				content.unlock_text = Localize("loc_hub_vendor_unlocks_at", true, {
					level = required_level,
				})
				content.unlocked = unlocked
			end

			local slot = element.slot

			if slot and content.unlocked then
				local slot_name = slot.name
				local equipped_item = parent:equipped_item_in_slot(slot_name)

				content.item = equipped_item

				local display_name = equipped_item and equipped_item.display_name

				if display_name then
					content.display_name = Items.display_name(equipped_item)
					content.sub_display_name = Items.sub_display_name(equipped_item)
				end

				if equipped_item then
					local cb = callback(_apply_live_item_icon_cb_func, widget)

					content.icon_load_id = Managers.ui:load_item_icon(equipped_item, cb)
					style.background_gradient.color = table.clone(Items.rarity_color(equipped_item))

					if style.item_level then
						local item_level, has_level = Items.expertise_level(equipped_item)

						content.item_level = has_level and item_level or ""
					end
				end
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local style = widget.style
			local element = content.element
			local slot = element.slot

			content.hotspot.disabled = not content.unlocked

			if slot then
				local slot_name = slot.name
				local previous_item = content.item
				local equipped_item = parent:equipped_item_in_slot(slot_name)
				local update = equipped_item and not previous_item or not equipped_item and previous_item or previous_item and previous_item.gear_id ~= equipped_item.gear_id

				if update and content.unlocked then
					content.item = equipped_item

					if content.icon_load_id then
						_remove_live_item_icon_cb_func(widget, ui_renderer)
						Managers.ui:unload_item_icon(content.icon_load_id)

						content.icon_load_id = nil
					end

					if equipped_item then
						local cb = callback(_apply_live_item_icon_cb_func, widget)

						content.icon_load_id = Managers.ui:load_item_icon(equipped_item, cb)
						style.background_gradient.color = table.clone(Items.rarity_color(equipped_item))

						if style.item_level then
							local item_level, has_level = Items.expertise_level(equipped_item)

							content.item_level = has_level and item_level or ""
						end

						local display_name = equipped_item and equipped_item.display_name

						if display_name then
							content.display_name = Items.display_name(equipped_item)
							content.sub_display_name = Items.sub_display_name(equipped_item)
						end
					else
						style.background_gradient.color = style.background_gradient.default_color
						content.item_level = ""
						content.display_name = ""
						content.sub_display_name = ""
					end
				end
			end
		end,
		destroy = function (parent, widget, element, ui_renderer)
			local content = widget.content

			if content.icon_load_id then
				_remove_live_item_icon_cb_func(widget, ui_renderer)
				Managers.ui:unload_item_icon(content.icon_load_id)

				content.icon_load_id = nil
			end
		end,
	},
	texture = {
		size = {
			64,
			64,
		},
		size_function = function (parent, element, ui_renderer)
			local size = element.size

			return {
				size[1],
				size[2],
			}
		end,
		pass_template = {
			{
				pass_type = "texture",
				style_id = "texture",
				value_id = "texture",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					offset = {
						0,
						0,
						0,
					},
					color = Color.white(255, true),
				},
			},
		},
		init = function (parent, widget, element, callback_name)
			local style = widget.style
			local content = widget.content
			local texture = element.texture

			content.texture = texture

			local color = element.color

			if color then
				local texture_color = style.texture.color

				texture_color[1] = color[1]
				texture_color[2] = color[2]
				texture_color[3] = color[3]
				texture_color[4] = color[4]
			end
		end,
	},
	group_header = {
		size = {
			grid_width,
			70,
		},
		pass_template = {
			{
				pass_type = "text",
				value = "n/a",
				value_id = "text",
				style = group_header_font_style,
			},
		},
		init = function (parent, widget, element, callback_name)
			local content = widget.content
			local display_name = element.display_name
			local text = Utf8.upper(Localize(display_name))

			content.element = element
			content.localized_display_name = text
			content.text = text
			content.has_new_items_update_callback = element.has_new_items_update_callback
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
			local display_name = element.display_name
			local group_header = content.group_header
			local suffix_text
			local text = content.localized_display_name

			if suffix_text then
				text = "{#color(194,154,116)}" .. text .. " {#color(255,242,230)}" .. Localize(suffix_text)
			end

			content.text = text

			local item_type = element.item_type
			local has_new_items = item_type and content.has_new_items_update_callback and content.has_new_items_update_callback(item_type) or false

			content.has_new_items = has_new_items
		end,
	},
	sub_header = {
		size = {
			grid_width,
			20,
		},
		pass_template = {
			{
				pass_type = "text",
				value = "n/a",
				value_id = "text",
				style = sub_header_font_style,
			},
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
			local suffix_text
			local text = content.localized_display_name

			if suffix_text then
				text = "{#color(194,154,116)}" .. text .. " {#color(255,242,230)}" .. Localize(suffix_text)
			end

			content.text = text
		end,
	},
	item_sub_header = {
		size = {
			600,
			20,
		},
		size_function = function (parent, element, ui_renderer)
			local size = element.size

			return size and {
				size[1],
				size[2],
			} or {
				grid_width,
				20,
			}
		end,
		pass_template = {
			{
				pass_type = "texture",
				style_id = "new_indicator",
				value = "content/ui/materials/symbols/new_item_indicator",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "top",
					size = {
						90,
						90,
					},
					offset = {
						180,
						-0,
						4,
					},
					color = Color.terminal_corner_selected(255, true),
				},
				visibility_function = function (content, style)
					return content.has_new_items
				end,
			},
			{
				pass_type = "text",
				value = "n/a",
				value_id = "text",
				style = item_sub_header_font_style,
			},
		},
		init = function (parent, widget, element, callback_name)
			local style = widget.style
			local content = widget.content
			local display_name = element.display_name
			local text = Utf8.upper(Localize(display_name))
			local new_indicator_width_offset = element.new_indicator_width_offset

			if new_indicator_width_offset then
				local offset = style.new_indicator.offset

				offset[1] = new_indicator_width_offset[1]
				offset[2] = new_indicator_width_offset[2]
				offset[3] = new_indicator_width_offset[3]
			end

			content.element = element
			content.localized_display_name = text
			content.text = text
			content.has_new_items_update_callback = element.has_new_items_update_callback
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local content = widget.content
			local element = content.element
			local item_type = element.item_type
			local has_new_items = item_type and content.has_new_items_update_callback and content.has_new_items_update_callback(item_type) or false

			content.has_new_items = has_new_items
		end,
	},
	exclamation_mark = {
		pass_template = {
			{
				pass_type = "texture",
				style_id = "exclamation_mark",
				value = "content/ui/materials/icons/generic/exclamation_mark",
				value_id = "exclamation_mark",
				style = {
					horizontal_alignment = "right",
					vertical_alignment = "bottom",
					offset = {
						-2,
						-2,
						7,
					},
					warning_color = {
						255,
						246,
						69,
						69,
					},
					modified_color = {
						255,
						246,
						202,
						69,
					},
					size = {
						16,
						28,
					},
				},
				change_function = function (content, style)
					local color = content.modified_content and style.modified_color or style.warning_color

					Colors.color_copy(color, style.color, true)
				end,
			},
		},
	},
}

return blueprints
