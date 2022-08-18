local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ItemPassTemplates = require("scripts/ui/pass_templates/item_pass_templates")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local ItemUtils = require("scripts/utilities/items")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local WalletSettings = require("scripts/settings/wallet_settings")

local function generate_blueprints_function(grid_size)
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
		ui_item = {
			size = ItemPassTemplates.ui_item_size,
			pass_template = ItemPassTemplates.ui_item,
			init = function (parent, widget, element, callback_name, secondary_callback_name)
				local content = widget.content
				local style = widget.style
				content.hotspot.pressed_callback = callback_name and callback(parent, callback_name, widget, element)
				content.hotspot.right_pressed_callback = secondary_callback_name and callback(parent, secondary_callback_name, widget, element)
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
		gear_item = {
			size = ItemPassTemplates.gear_icon_size,
			pass_template = ItemPassTemplates.gear_item,
			init = function (parent, widget, element, callback_name, secondary_callback_name)
				local content = widget.content
				content.hotspot.pressed_callback = callback_name and callback(parent, callback_name, widget, element)
				content.hotspot.right_pressed_callback = callback_name and callback(parent, secondary_callback_name, widget, element)
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
				local equipped_item = parent.equipped_item_in_slot and parent:equipped_item_in_slot(slot_name)
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
		}
	}
	blueprints.item_icon = {
		size = ItemPassTemplates.icon_size,
		pass_template = ItemPassTemplates.item_icon,
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local content = widget.content
			local style = widget.style
			content.hotspot.pressed_callback = callback_name and callback(parent, callback_name, widget, element)
			content.hotspot.right_pressed_callback = secondary_callback_name and callback(parent, secondary_callback_name, widget, element)
			content.element = element
			local item = element.item
			local rarity = item.rarity
			local slots = item.slots

			if slots then
				local slot_name = slots[1]
				local slot_settings = slot_name and ItemSlotSettings[slot_name]
				local item_rarity_textures = slot_settings and slot_settings.item_rarity_textures
				local icon_rarity_texture = item_rarity_textures[rarity]

				if icon_rarity_texture then
					content.icon = icon_rarity_texture
				end
			end

			local offer = element.offer

			if offer then
				local price_data = offer.price.amount
				local type = price_data.type
				local price = price_data.amount
				local price_text = tostring(price)
				content.has_price_tag = true
				content.price_text = price_text
				local wallet_settings = WalletSettings[type]
				content.wallet_icon = wallet_settings.icon_texture_small
				local price_text_style = style.price_text
				local price_text_size = UIRenderer.text_size(ui_renderer, price_text, price_text_style.font_type, price_text_style.font_size) or 0
				local wallet_icon_style = style.wallet_icon
				wallet_icon_style.offset[1] = ItemPassTemplates.icon_size[1] - wallet_icon_style.size[1] - (price_text_size + 10) + style.price_text.offset[1]
				local can_afford = false
				price_text_style.material = can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local view_instance = parent._parent
			local style = widget.style
			local content = widget.content
			local element = content.element
			local slot = element.slot

			if slot then
				local slot_name = slot.name
				local item = content.item
				local equipped_item = view_instance.equipped_item_in_slot and view_instance:equipped_item_in_slot(slot_name)
				local is_equipped = equipped_item and item and item.gear_id ~= equipped_item.gear_id
				content.equipped = is_equipped
			end

			local offer = element.offer

			if offer then
				local price_data = offer.price.amount
				local type = price_data.type
				local price = price_data.amount
				local wallet_settings = WalletSettings[type]
				local price_text_style = style.price_text
				local can_afford = view_instance.can_afford and view_instance:can_afford(price, type) or false
				price_text_style.material = can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds
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
	}
	blueprints.item = {
		size = ItemPassTemplates.item_size,
		pass_template = ItemPassTemplates.item,
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer)
			local content = widget.content
			local style = widget.style
			content.hotspot.pressed_callback = callback_name and callback(parent, callback_name, widget, element)
			content.hotspot.right_pressed_callback = secondary_callback_name and callback(parent, secondary_callback_name, widget, element)
			content.element = element
			local item = element.item
			local rarity = item.rarity
			local slots = item.slots

			if slots then
				local slot_name = slots[1]
				local slot_settings = slot_name and ItemSlotSettings[slot_name]
				local item_rarity_textures = slot_settings and slot_settings.item_rarity_textures
				local icon_rarity_texture = item_rarity_textures[rarity]

				if icon_rarity_texture then
					content.icon = icon_rarity_texture
				end
			end

			local offer = element.offer

			if offer then
				local price_data = offer.price.amount
				local type = price_data.type
				local price = price_data.amount
				local price_text = tostring(price)
				content.has_price_tag = true
				content.price_text = price_text
				local wallet_settings = WalletSettings[type]
				content.wallet_icon = wallet_settings.icon_texture_small
				local price_text_style = style.price_text
				local price_text_size = UIRenderer.text_size(ui_renderer, price_text, price_text_style.font_type, price_text_style.font_size) or 0
				local wallet_icon_style = style.wallet_icon
				wallet_icon_style.offset[1] = ItemPassTemplates.icon_size[1] - wallet_icon_style.size[1] - (price_text_size + 10) + style.price_text.offset[1]
				local can_afford = false
				price_text_style.material = can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds
			end

			local display_name = item.display_name

			if display_name then
				content.display_name = ItemUtils.display_name(item)
				content.sub_display_name = ItemUtils.sub_display_name(item)
			end

			local _, rarity_side_texture = ItemUtils.rarity_textures(item)
			content.rarity_side_texture = rarity_side_texture
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local view_instance = parent._parent
			local style = widget.style
			local content = widget.content
			local element = content.element
			local slot = element.slot

			if slot then
				local slot_name = slot.name
				local item = content.item
				local equipped_item = view_instance.equipped_item_in_slot and view_instance:equipped_item_in_slot(slot_name)
				local is_equipped = equipped_item and item and item.gear_id ~= equipped_item.gear_id
				content.equipped = is_equipped
			end

			local offer = element.offer

			if offer then
				local price_data = offer.price.amount
				local type = price_data.type
				local price = price_data.amount
				local wallet_settings = WalletSettings[type]
				local price_text_style = style.price_text
				local can_afford = view_instance.can_afford and view_instance:can_afford(price, type) or false
				price_text_style.material = can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds
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
	}
	blueprints.group_header = {
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
	}
	blueprints.sub_header = {
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

	return blueprints
end

return generate_blueprints_function
