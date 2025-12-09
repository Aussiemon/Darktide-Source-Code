-- chunkname: @scripts/ui/view_content_blueprints/item_blueprints.lua

local Archetypes = require("scripts/settings/archetype/archetypes")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ItemPassTemplates = require("scripts/ui/pass_templates/item_pass_templates")
local Items = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local ProfileUtils = require("scripts/utilities/profile_utils")
local Text = require("scripts/utilities/ui/text")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local WalletSettings = require("scripts/settings/wallet_settings")

local function is_item_equipped_in_slot(parent, item, slot_name)
	if not parent or not item then
		return false
	end

	local equipped = false

	if parent.equipped_item_in_slot then
		local equipped_item = parent:equipped_item_in_slot(slot_name)
		local equipped_gear_id = equipped_item and equipped_item.gear_id
		local item_gear_id = item.gear_id

		if item_gear_id then
			equipped = item_gear_id == equipped_gear_id or false
		else
			local item_name = item.name
			local equipped_item_name = equipped_item and equipped_item.name

			equipped = item_name and equipped_item_name and item_name == equipped_item_name or false
		end
	end

	if parent.equipped_item_name_in_slot then
		local equipped_item_name = parent:equipped_item_name_in_slot(slot_name)

		if item.empty_item and (not equipped_item_name or equipped_item_name == "") then
			return true
		end

		local item_name = item.name or item.gear and item.gear.masterDataInstance.id

		equipped = item_name == equipped_item_name
	end

	return equipped
end

local function is_item_equipped_in_any_slot(parent, item, slots)
	if not parent or not item then
		return false
	end

	for i = 1, #slots do
		local slot_name = slots[i]

		if is_item_equipped_in_slot(parent, item, slot_name) then
			return true
		end
	end

	return false
end

local function get_generic_profile(breed, gender, archetype)
	local dummy_profile = {
		loadout = {},
		archetype = archetype,
		breed = archetype.name == "ogryn" and "ogryn" or breed,
		gender = gender,
	}
	local required_breed_item_names_per_slot = UISettings.item_preview_required_slot_items_per_slot_by_breed_and_gender[breed]
	local required_gender_item_names_per_slot = required_breed_item_names_per_slot and required_breed_item_names_per_slot[gender]
	local required_items = required_gender_item_names_per_slot and required_gender_item_names_per_slot.default

	if required_items then
		for slot_name, slot_item_name in pairs(required_items) do
			local item_definition = MasterItems.get_item(slot_item_name)

			if item_definition then
				local slot_item = table.clone(item_definition)

				dummy_profile.loadout[slot_name] = slot_item
			end
		end
	end

	return dummy_profile
end

local function generate_blueprints_function(grid_size)
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
		local item_icon_size = item_slot and table.clone(item_slot.item_icon_size)
		local material_values = icon_style.material_values

		if item.icon_material and item.icon_material ~= "" then
			widget.content.icon = item.icon_material
			material_values.use_placeholder_texture = 0
			material_values.use_render_target = 0

			if item_icon_size then
				widget.style.icon_original_size = icon_style.size and table.clone(icon_style.size) or {}
			end
		else
			if widget.style.icon_original_size then
				icon_style.size = widget.style.icon_original_size
				widget.style.icon_original_size = nil
			end

			local material_values = icon_style.material_values

			material_values.texture_icon = item.icon
		end

		material_values.use_placeholder_texture = 0
		material_values.use_render_target = 0
		widget.content.use_placeholder_texture = material_values.use_placeholder_texture
	end

	local function _remove_package_item_icon_cb_func(widget, ui_renderer)
		UIWidget.set_visible(widget, ui_renderer, false)

		widget.content.icon = "content/ui/materials/icons/items/containers/item_container_square"

		local material_values = widget.style.icon.material_values

		material_values.texture_icon = nil
		material_values.use_placeholder_texture = 1

		local icon_style = widget.style.icon

		icon_style.size = widget.style.icon_original_size or icon_style.size
		widget.content.use_placeholder_texture = material_values.use_placeholder_texture

		if widget.style.icon_original_size then
			icon_style.size = widget.style.icon_original_size
			widget.style.icon_original_size = nil
		end
	end

	local function _apply_live_item_icon_cb_func(widget, grid_index, rows, columns, render_target)
		local material_values = widget.style.icon.material_values

		material_values.use_placeholder_texture = 0
		material_values.use_render_target = 1
		material_values.rows = rows
		material_values.columns = columns
		material_values.grid_index = grid_index - 1
		material_values.render_target = render_target
		widget.content.use_placeholder_texture = material_values.use_placeholder_texture
	end

	local function _remove_live_item_icon_cb_func(widget, ui_renderer)
		UIWidget.set_visible(widget, ui_renderer, false)

		local material_values = widget.style.icon.material_values

		material_values.use_placeholder_texture = 1
		material_values.render_target = nil
		widget.content.use_placeholder_texture = material_values.use_placeholder_texture
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
		divider = {
			size = {
				grid_width,
				60,
			},
			pass_template = {
				{
					pass_type = "texture",
					style_id = "divider",
					value = "content/ui/materials/dividers/skull_center_02",
					value_id = "divider",
					style = {
						horizontal_alignment = "center",
						vertical_alignment = "top",
						size = {
							math.min(grid_width * 0.8, 400),
							18,
						},
						offset = {
							0,
							24,
							1,
						},
						color = Color.terminal_frame(255, true),
					},
				},
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
		ui_item = {
			size = ItemPassTemplates.ui_item_size,
			pass_template = ItemPassTemplates.ui_item,
			init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer, double_click_callback)
				local content = widget.content
				local style = widget.style

				content.hotspot.pressed_callback = callback_name and callback(parent, callback_name, widget, element)
				content.hotspot.double_click_callback = double_click_callback and callback(parent, double_click_callback, widget, element)
				content.hotspot.right_pressed_callback = secondary_callback_name and callback(parent, secondary_callback_name, widget, element)
				content.element = element
				content.locked = element.locked

				local slot = element.slot

				if slot then
					local item = element.item

					content.item = item
					content.properties = Items.item_property_icons(item) or ""

					local display_name = item and item.display_name

					if display_name then
						content.display_name = Items.display_name(item)
						content.sub_display_name = Items.sub_display_name(item)
					end

					local item_icon_size = slot.item_icon_size

					if item_icon_size then
						local element_size = element.size

						if element_size then
							local icon_width = item_icon_size[1] * (element_size[1] / ItemPassTemplates.ui_item_size[1])
							local icon_height = item_icon_size[2] * (element_size[2] / ItemPassTemplates.ui_item_size[2])

							item_icon_size = {
								icon_width,
								icon_height,
							}
						end

						style.icon.material_values.icon_size = item_icon_size
					end

					local icon_color = slot.icon_color

					if icon_color then
						local color = style.icon.color

						color[1] = icon_color[1]
						color[2] = icon_color[2]
						color[3] = icon_color[3]
						color[4] = icon_color[4]
					end

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
				local view_instance = parent._parent or parent
				local content = widget.content
				local element = content.element
				local slot = element.slot
				local slot_name = slot.name
				local item = element.real_item or element.item
				local hotspot = content.hotspot

				if hotspot and item then
					local gear_id = item.gear_id or item.name
					local favorite_state = Items.is_item_id_favorited(gear_id)

					content.favorite = favorite_state
				end

				local is_equipped = is_item_equipped_in_slot(view_instance, item, slot_name)

				content.equipped = is_equipped
			end,
			load_icon = function (parent, widget, element, ui_renderer, dummy_profile, prioritize)
				local content = widget.content
				local item = element.item

				if not content.icon_load_id and item then
					local slot = element.slot
					local slot_name = slot.name
					local cb = callback(_apply_package_item_icon_cb_func, widget, item)
					local render_context = {
						camera_focus_slot_name = slot_name,
					}

					content.icon_load_id = Managers.ui:load_item_icon(item, cb)
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
			update_item_icon_priority = function (parent, widget, element, ui_renderer, dummy_profile)
				local content = widget.content

				if content.icon_load_id then
					Managers.ui:update_item_icon_priority(content.icon_load_id)
				end
			end,
		},
		character_title_item = {
			size = ItemPassTemplates.character_title_item_size,
			pass_template = ItemPassTemplates.character_title_item,
			init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer, double_click_callback)
				local content = widget.content
				local style = widget.style

				content.hotspot.pressed_callback = callback_name and callback(parent, callback_name, widget, element)
				content.hotspot.double_click_callback = double_click_callback and callback(parent, double_click_callback, widget, element)
				content.hotspot.right_pressed_callback = secondary_callback_name and callback(parent, secondary_callback_name, widget, element)
				content.element = element
				content.locked = element.locked
				content.show_icon = element.show_icon

				local slot = element.slot

				if slot then
					local item = element.item

					content.item = item
					content.display_name = ProfileUtils.title_item_name_no_color(item, element.profile)

					local rarity = item and item.rarity

					if rarity then
						local _, rarity_color_dark = Items.rarity_color(item)

						if rarity_color_dark then
							style.background_gradient.color = table.clone(rarity_color_dark)
						end
					else
						style.background_gradient.color = style.background_gradient.default_color
					end

					local item_icon_size = slot.item_icon_size

					if item_icon_size then
						local element_size = element.size

						if element_size then
							local icon_width = item_icon_size[1] * (element_size[1] / ItemPassTemplates.ui_item_size[1])
							local icon_height = item_icon_size[2] * (element_size[2] / ItemPassTemplates.ui_item_size[2])

							item_icon_size = {
								icon_width,
								icon_height,
							}
						end

						style.icon.material_values.icon_size = item_icon_size
					end

					local icon_color = slot.icon_color

					if icon_color then
						local color = style.icon.color

						color[1] = icon_color[1]
						color[2] = icon_color[2]
						color[3] = icon_color[3]
						color[4] = icon_color[4]
					end
				end
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				local view_instance = parent._parent or parent
				local content = widget.content
				local element = content.element
				local slot = element.slot
				local slot_name = slot.name
				local item = element.real_item or element.item
				local hotspot = content.hotspot

				if hotspot and item then
					local gear_id = item.gear_id or item.name
					local previous_state = Items.is_item_id_favorited(gear_id)

					content.favorite = previous_state
				end

				local is_equipped = is_item_equipped_in_slot(view_instance, item, slot_name)

				content.equipped = is_equipped
			end,
			load_icon = function (parent, widget, element, ui_renderer, dummy_profile, prioritize)
				local content = widget.content
				local item = element.item

				if not content.icon_load_id and item then
					local cb = callback(_apply_package_item_icon_cb_func, widget, item)

					content.icon_load_id = Managers.ui:load_item_icon(item, cb)
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
			update_item_icon_priority = function (parent, widget, element, ui_renderer, dummy_profile)
				local content = widget.content

				if content.icon_load_id then
					Managers.ui:update_item_icon_priority(content.icon_load_id)
				end
			end,
		},
		gear_item = {
			size = ItemPassTemplates.gear_icon_size,
			pass_template = ItemPassTemplates.gear_item,
			init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer, double_click_callback)
				local content = widget.content
				local style = widget.style

				content.hotspot.pressed_callback = callback_name and callback(parent, callback_name, widget, element)
				content.hotspot.double_click_callback = double_click_callback and callback(parent, double_click_callback, widget, element)
				content.hotspot.right_pressed_callback = secondary_callback_name and callback(parent, secondary_callback_name, widget, element)
				content.element = element

				local slot = element.slot

				if slot then
					local item = element.item

					content.item = item
					content.properties = Items.item_property_icons(item) or ""

					local display_name = item and item.display_name

					if display_name then
						content.display_name = Items.display_name(item)
						content.sub_display_name = Items.sub_display_name(item)
					end

					local rarity = item and item.rarity

					if rarity then
						local rarity_color, rarity_color_dark = Items.rarity_color(item)

						style.background_gradient.color = table.clone(rarity_color_dark)
					end
				end

				content.locked = element.locked

				local offer = element.offer

				if offer and offer.price then
					local price_data = offer.price.amount
					local type = price_data.type
					local price = price_data.discounted_price or price_data.amount
					local price_text = Text.format_currency(price)

					content.has_price_tag = true
					content.price_text = price_text

					local wallet_settings = WalletSettings[type]

					content.wallet_icon = wallet_settings.icon_texture_small

					local price_text_style = style.price_text
					local view_instance = parent._parent or parent
					local can_afford = view_instance and view_instance.can_afford and view_instance:can_afford(price, type) or false

					price_text_style.material = can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds

					if not content.sold then
						local owned_count = element.owned_count
						local total_count = element.total_count
						local owning_total_count = owned_count and total_count and owned_count == total_count
						local is_owned = offer.state == "owned" or owning_total_count

						content.sold = is_owned

						if is_owned then
							content.owned = is_owned and ""
						elseif owned_count and total_count and total_count > 0 then
							content.owned = owned_count > 0 and string.format("%d/%d", owned_count, total_count) or nil
						end
					end
				end
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				local view_instance = parent._parent or parent
				local style = widget.style
				local content = widget.content
				local element = content.element
				local slot = element.slot
				local slot_name = slot.name
				local item = element.real_item or element.item
				local hotspot = content.hotspot

				if hotspot and item then
					local gear_id = item.gear_id
					local previous_state = Items.is_item_id_favorited(gear_id)

					content.favorite = previous_state
				end

				local is_equipped = is_item_equipped_in_slot(view_instance, item, slot_name)

				content.equipped = not element.disable_equipped_status and is_equipped

				local price_text_style = style.price_text
				local offer = element.offer

				if offer and offer.price then
					local price_data = offer.price.amount
					local type = price_data.type
					local price = price_data.discounted_price or price_data.amount
					local price_text = Text.format_currency(price)

					content.price_text = price_text

					local wallet_settings = WalletSettings[type]

					content.wallet_icon = wallet_settings.icon_texture_small

					local can_afford = view_instance and view_instance.can_afford and view_instance:can_afford(price, type) or false

					price_text_style.material = can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds
				end

				if not content.sold then
					local owned_count = element.owned_count
					local total_count = element.total_count
					local owning_total_count = owned_count and total_count and owned_count == total_count
					local is_owned = offer and offer.state == "owned" or owning_total_count

					content.sold = is_owned

					if is_owned then
						content.owned = is_owned and ""
					elseif owned_count and total_count and total_count > 0 then
						content.owned = owned_count > 0 and string.format("%d/%d", owned_count, total_count) or nil
					end
				end
			end,
			load_icon = function (parent, widget, element, ui_renderer, dummy_profile, prioritize)
				local content = widget.content
				local item = element.item

				if not content.icon_load_id and item then
					local slot = element.slot
					local slot_name = slot.name
					local cb = callback(_apply_live_item_icon_cb_func, widget)
					local item_state_machine = item.state_machine
					local item_animation_event = item.animation_event
					local item_companion_state_machine = item.companion_state_machine ~= nil and item.companion_state_machine ~= "" and item.companion_state_machine or nil
					local item_companion_animation_event = item.companion_animation_event ~= nil and item.companion_animation_event ~= "" and item.companion_animation_event or nil
					local render_context = {
						camera_focus_slot_name = slot_name,
						state_machine = item_state_machine,
						animation_event = item_animation_event,
						companion_state_machine = item_companion_state_machine,
						companion_animation_event = item_companion_animation_event,
					}

					content.icon_load_id = Managers.ui:load_item_icon(item, cb, render_context, dummy_profile, prioritize, nil)
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
			update_item_icon_priority = function (parent, widget, element, ui_renderer, dummy_profile)
				local content = widget.content

				if content.icon_load_id then
					Managers.ui:update_item_icon_priority(content.icon_load_id)
				end
			end,
		},
		item_icon = {
			size = ItemPassTemplates.icon_size,
			pass_template = ItemPassTemplates.item_icon,
			init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer, double_click_callback)
				local content = widget.content
				local style = widget.style

				content.hotspot.pressed_callback = callback_name and callback(parent, callback_name, widget, element)
				content.hotspot.double_click_callback = double_click_callback and callback(parent, double_click_callback, widget, element)
				content.hotspot.right_pressed_callback = secondary_callback_name and callback(parent, secondary_callback_name, widget, element)
				content.element = element

				local item = element.item
				local rarity = item.rarity
				local offer = element.offer

				content.locked = element.locked

				if offer and offer.price then
					local price_data = offer.price.amount
					local type = price_data.type
					local price = price_data.amount
					local price_text = Text.format_currency(price)

					content.has_price_tag = true
					content.price_text = price_text

					local wallet_settings = WalletSettings[type]

					content.wallet_icon = wallet_settings.icon_texture_small

					local price_text_style = style.price_text
					local view_instance = parent._parent or parent
					local can_afford = view_instance and view_instance.can_afford and view_instance:can_afford(price, type) or false

					price_text_style.material = can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds

					if not content.sold then
						local owned_count = element.owned_count
						local total_count = element.total_count
						local owning_total_count = owned_count and total_count and owned_count == total_count
						local is_owned = offer.state == "owned" or owning_total_count

						content.sold = is_owned

						if is_owned then
							content.owned = is_owned and ""
						elseif owned_count and total_count and total_count > 0 then
							content.owned = owned_count > 0 and string.format("%d/%d", owned_count, total_count) or nil
						end
					end
				end

				if rarity then
					local rarity_color, rarity_color_dark = Items.rarity_color(item)

					if rarity_color_dark then
						style.background_gradient.color = table.clone(rarity_color_dark)
					end
				end

				if content.show_class_restrictions then
					local item = element.visual_item
					local text = ""

					if type(item.archetypes) ~= "table" or not (#item.archetypes > 0) then
						item = element.item
					end

					if type(item.archetypes) == "table" and #item.archetypes > 0 then
						for f = 1, #item.archetypes do
							local archetype = item.archetypes[f]
							local text_icon = UISettings.archetype_font_icon[archetype]

							text = text and string.format("%s %s", text, text_icon) or text_icon
						end
					end

					content.restriction_icon_text = text
				end
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				local view_instance = parent._parent or parent
				local style = widget.style
				local content = widget.content
				local element = content.element
				local real_item = element.real_item
				local item = element.real_item or element.item

				if item then
					local slots = item and item.slots
					local slot_name = element.slot_name or slots and slots[1]
					local is_equipped = slot_name and is_item_equipped_in_slot(view_instance, item, slot_name)

					content.equipped = is_equipped

					local hotspot = content.hotspot

					if hotspot and item and not item.empty_item then
						local gear_id = item.gear_id

						if gear_id then
							local previous_state = Items.is_item_id_favorited(gear_id)

							content.favorite = previous_state
						end
					end
				end
			end,
			load_icon = function (parent, widget, element, ui_renderer, dummy_profile, prioritize)
				local content = widget.content
				local item = element.real_item or element.item

				if not content.icon_load_id and item then
					local cb = callback(_apply_live_item_icon_cb_func, widget)
					local render_context = {
						alignment_key = element.alignment_key,
						alignment_key_value = element.alignment_key_value,
						size = element.render_size,
					}

					content.icon_load_id = Managers.ui:load_item_icon(item, cb, render_context, dummy_profile, prioritize)
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
			update_item_icon_priority = function (parent, widget, element, ui_renderer, dummy_profile)
				local content = widget.content

				if content.icon_load_id then
					Managers.ui:update_item_icon_priority(content.icon_load_id)
				end
			end,
		},
		item = {
			size = ItemPassTemplates.weapon_item_size,
			pass_template = ItemPassTemplates.item,
			init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer, double_click_callback)
				local content = widget.content
				local style = widget.style

				content.hotspot.pressed_callback = callback_name and callback(parent, callback_name, widget, element)
				content.hotspot.double_click_callback = double_click_callback and callback(parent, double_click_callback, widget, element)
				content.hotspot.right_pressed_callback = secondary_callback_name and callback(parent, secondary_callback_name, widget, element)
				content.element = element

				local item = element.item
				local offer = element.offer

				if offer and offer.price then
					local price_data = offer.price.amount
					local type = price_data.type
					local price = price_data.amount
					local price_text = tostring(price)

					content.has_price_tag = true
					content.price_text = price_text

					local wallet_settings = WalletSettings[type]

					content.wallet_icon = wallet_settings.icon_texture_small

					local price_text_style = style.price_text
					local view_instance = parent._parent or parent
					local can_afford = view_instance and view_instance.can_afford and view_instance:can_afford(price, type) or false

					price_text_style.material = can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds
				end

				if style.item_level then
					local item_level, has_level = Items.expertise_level(item)

					content.item_level = has_level and item_level or ""
				end

				local item_type = item.item_type
				local ITEM_TYPES = UISettings.ITEM_TYPES
				local is_weapon = item_type == ITEM_TYPES.WEAPON_MELEE or item_type == ITEM_TYPES.WEAPON_RANGED
				local required_level = Items.character_level(item)
				local view_instance = parent._parent or parent
				local character_level = view_instance and view_instance.character_level and view_instance:character_level()
				local level_requirement_met = not item and true or required_level and required_level <= character_level

				content.level_requirement_met = level_requirement_met

				if not level_requirement_met then
					local required_level_text = Localize("loc_requires_level", true, {
						level = required_level,
					})

					content.required_level = required_level_text
				end

				local rarity_color = Items.rarity_color(item)

				if is_weapon then
					content.display_name = Items.weapon_card_display_name(item)
					content.sub_display_name = Items.weapon_card_sub_display_name(item)
					content.rarity_name = Items.rarity_display_name(item)
					style.rarity_name.text_color = table.clone(rarity_color)
				else
					content.display_name = Items.display_name(item)
					content.sub_display_name = Items.sub_display_name(item)
					content.rarity_name = ""
					style.sub_display_name.text_color = table.clone(rarity_color)
				end

				style.background_gradient.color = table.clone(rarity_color)
				style.rarity_tag.color = table.clone(rarity_color)
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				local view_instance = parent._parent or parent
				local style = widget.style
				local content = widget.content
				local element = content.element
				local slot = element.slot
				local item = element.real_item or element.item
				local hotspot = content.hotspot

				if hotspot and item then
					local gear_id = item.gear_id
					local previous_state = Items.is_item_id_favorited(gear_id)

					content.favorite = previous_state
				end

				if slot then
					local slot_name = slot.name
					local item_type = item.item_type
					local is_equipped

					if item_type == UISettings.ITEM_TYPES.GADGET then
						local slots = item and item.slots

						is_equipped = is_item_equipped_in_any_slot(view_instance, item, slots)
					else
						is_equipped = is_item_equipped_in_slot(view_instance, item, slot_name)
					end

					content.equipped = is_equipped
				end

				local offer = element.offer

				if offer and offer.price then
					local price_data = offer.price.amount
					local type = price_data.type
					local price = price_data.amount
					local wallet_settings = WalletSettings[type]
					local price_text_style = style.price_text
					local can_afford = view_instance and view_instance.can_afford and view_instance:can_afford(price, type) or false

					price_text_style.material = can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds
				end
			end,
			load_icon = function (parent, widget, element, ui_renderer, dummy_profile, prioritize)
				local content = widget.content
				local item = element.item

				if not content.icon_load_id and item then
					local cb = callback(_apply_live_item_icon_cb_func, widget)

					content.icon_load_id = Managers.ui:load_item_icon(item, cb, nil, dummy_profile, prioritize)
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
			update_item_icon_priority = function (parent, widget, element, ui_renderer, dummy_profile)
				local content = widget.content

				if content.icon_load_id then
					Managers.ui:update_item_icon_priority(content.icon_load_id)
				end
			end,
			style_function = function (parent, config, size)
				return config and config.style_override
			end,
			update_data = function (parent, widget, element)
				local item = element.item
				local content = widget.content
				local style = widget.style

				if style.item_level then
					local item_level, has_level = Items.expertise_level(item)

					content.item_level = has_level and item_level or ""
				end

				local is_weapon = Items.is_weapon(item.item_type)
				local rarity_color = Items.rarity_color(item)

				if is_weapon then
					content.display_name = Items.weapon_card_display_name(item)
					content.sub_display_name = Items.weapon_card_sub_display_name(item)
					content.rarity_name = Items.rarity_display_name(item)
					style.rarity_name.text_color = table.clone(rarity_color)
				else
					content.display_name = Items.display_name(item)
					content.sub_display_name = Items.sub_display_name(item)
					content.rarity_name = ""
					style.sub_display_name.text_color = table.clone(rarity_color)
				end

				style.background_gradient.color = table.clone(rarity_color)
				style.rarity_tag.color = table.clone(rarity_color)
			end,
		},
		gear_set = {
			size = ItemPassTemplates.gear_bundle_size,
			pass_template = ItemPassTemplates.gear_item,
			init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer, double_click_callback)
				local content = widget.content
				local style = widget.style

				content.hotspot.pressed_callback = callback_name and callback(parent, callback_name, widget, element)
				content.hotspot.double_click_callback = double_click_callback and callback(parent, double_click_callback, widget, element)
				content.hotspot.right_pressed_callback = secondary_callback_name and callback(parent, secondary_callback_name, widget, element)
				content.element = element

				local item = element.item
				local rarity = item and item.rarity
				local rarity_color, rarity_color_dark = Items.rarity_color(item)

				if rarity then
					style.background_gradient.color = table.clone(rarity_color_dark)
				end

				local offer = element.offer

				if offer and offer.price then
					local price_data = offer.price.amount
					local type = price_data.type
					local price = price_data.discounted_price or price_data.amount
					local price_text = Text.format_currency(price)

					content.has_price_tag = true
					content.price_text = price_text

					local wallet_settings = WalletSettings[type]

					content.wallet_icon = wallet_settings.icon_texture_small

					local price_text_style = style.price_text
					local view_instance = parent._parent or parent
					local can_afford = view_instance and view_instance.can_afford and view_instance:can_afford(price, type) or false

					price_text_style.material = can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds

					if not content.sold then
						local owned_count = element.owned_count
						local total_count = element.total_count
						local owning_total_count = owned_count and total_count and owned_count == total_count
						local is_owned = offer.state == "owned" or owning_total_count

						content.sold = is_owned

						if is_owned then
							content.owned = is_owned and ""
							content.owned_count_text = nil
						elseif owned_count and total_count and owned_count > 0 and owned_count < total_count then
							content.owned_count_text = string.format("%d/%d ", owned_count, total_count) or nil
						end
					end
				end
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				local style = widget.style
				local content = widget.content
				local element = content.element
				local offer = element.offer

				if offer and offer.price then
					local price_data = offer.price.amount
					local type = price_data.type
					local price = price_data.discounted_price or price_data.amount
					local price_text = Text.format_currency(price)

					content.has_price_tag = true
					content.price_text = price_text

					local wallet_settings = WalletSettings[type]

					content.wallet_icon = wallet_settings.icon_texture_small

					local price_text_style = style.price_text
					local view_instance = parent._parent or parent
					local can_afford = view_instance and view_instance.can_afford and view_instance:can_afford(price, type) or false

					price_text_style.material = can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds

					if not content.sold then
						local owned_count = element.owned_count
						local total_count = element.total_count
						local owning_total_count = owned_count and total_count and owned_count == total_count
						local is_owned = offer and offer.state == "owned" or owning_total_count

						content.sold = is_owned

						if is_owned then
							content.owned = is_owned and ""
							content.owned_count_text = nil
						elseif owned_count and total_count and owned_count > 0 and owned_count < total_count then
							content.owned_count_text = string.format("%d/%d ", owned_count, total_count) or nil
						end
					end
				end
			end,
			load_icon = function (parent, widget, element, ui_renderer, dummy_profile, prioritize)
				local content = widget.content
				local item = element.item or element.real_item

				if not content.icon_load_id and item then
					local cb = callback(_apply_live_item_icon_cb_func, widget)
					local preview_profile = dummy_profile or element.preview_profile
					local gear_bundle_size = ItemPassTemplates.gear_bundle_size
					local render_context = {
						camera_focus_slot_name = "slot_set",
						size = {
							gear_bundle_size[1],
							gear_bundle_size[2],
						},
					}

					content.icon_load_id = Managers.ui:load_item_icon(item, cb, render_context, preview_profile, prioritize)
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
			update_item_icon_priority = function (parent, widget, element, ui_renderer, dummy_profile)
				local content = widget.content

				if content.icon_load_id then
					Managers.ui:update_item_icon_priority(content.icon_load_id)
				end
			end,
		},
		store_item = {
			size = ItemPassTemplates.store_item_size,
			pass_template = ItemPassTemplates.item,
			init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer, double_click_callback)
				local content = widget.content
				local style = widget.style

				content.store_item = true
				content.hotspot.pressed_callback = callback_name and callback(parent, callback_name, widget, element)
				content.hotspot.double_click_callback = double_click_callback and callback(parent, double_click_callback, widget, element)
				content.hotspot.right_pressed_callback = secondary_callback_name and callback(parent, secondary_callback_name, widget, element)
				content.element = element

				local item = element.item
				local real_item = element.real_item
				local presentation_item = real_item or item
				local slots = presentation_item and presentation_item.slots
				local rarity = presentation_item and presentation_item.rarity
				local rarity_color = Items.rarity_color(presentation_item)
				local offer = element.offer

				if offer and offer.price then
					local price_data = offer.price.amount
					local type = price_data.type
					local price = price_data.amount
					local price_text = Text.format_currency(price)

					content.has_price_tag = true
					content.price_text = price_text

					local wallet_settings = WalletSettings[type]

					content.wallet_icon = wallet_settings.icon_texture_small

					local price_text_style = style.price_text
					local view_instance = parent._parent or parent
					local can_afford = view_instance and view_instance.can_afford and view_instance:can_afford(price, type) or false

					price_text_style.material = can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds

					local is_active = offer.state == "active"

					content.sold = not is_active

					local is_owned = offer.state == "owned"

					content.owned = is_owned
				end

				local item_type = item and item.item_type

				if item_type == UISettings.ITEM_TYPES.GEAR_LOWERBODY or item_type == UISettings.ITEM_TYPES.GEAR_UPPERBODY or item_type == UISettings.ITEM_TYPES.GEAR_HEAD or item_type == UISettings.ITEM_TYPES.GEAR_EXTRA_COSMETIC or item_type == UISettings.ITEM_TYPES.COMPANION_GEAR_FULL or item_type == UISettings.ITEM_TYPES.END_OF_ROUND then
					local icon_style = style.icon
					local icon_size = icon_style.size
					local icon_offset = icon_style.offset

					icon_size[1] = UISettings.item_icon_size[1]
					icon_offset[1] = icon_offset[1] - icon_size[1] * 0.3
				end

				local item_rating, has_item_rating

				if presentation_item then
					item_rating, has_item_rating = Items.expertise_level(presentation_item)
				end

				if content.item_level then
					content.item_level = has_item_rating and item_rating or ""
				end

				local required_level = presentation_item and Items.character_level(presentation_item)
				local view_instance = parent._parent or parent
				local character_level = view_instance and view_instance.character_level and view_instance:character_level()
				local level_requirement_met = not presentation_item and true or required_level and required_level <= character_level

				content.level_requirement_met = level_requirement_met

				if not level_requirement_met then
					content.required_level = Localize("loc_requires_level", true, {
						level = required_level,
					})
				end

				local ITEM_TYPES = UISettings.ITEM_TYPES
				local is_weapon = item_type == ITEM_TYPES.WEAPON_MELEE or item_type == ITEM_TYPES.WEAPON_RANGED

				if is_weapon then
					content.display_name = Items.weapon_card_display_name(item)
					content.sub_display_name = Items.weapon_card_sub_display_name(item)
					content.rarity_name = Items.rarity_display_name(item)
				else
					content.display_name = Items.display_name(item)
					content.sub_display_name = Items.sub_display_name(item)
					content.rarity_name = ""
					style.sub_display_name.text_color = table.clone(rarity_color)
				end

				style.background_gradient.color = table.clone(rarity_color)
				style.rarity_tag.color = table.clone(rarity_color)
				style.rarity_name.text_color = table.clone(rarity_color)
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				local view_instance = parent._parent or parent
				local style = widget.style
				local content = widget.content
				local element = content.element
				local offer = element.offer

				if offer and offer.price then
					local price_data = offer.price.amount
					local type = price_data.type
					local price = price_data.amount
					local wallet_settings = WalletSettings[type]
					local price_text_style = style.price_text
					local can_afford = view_instance and view_instance.can_afford and view_instance:can_afford(price, type) or false

					price_text_style.material = can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds

					local is_active = offer.state == "active"

					content.sold = not is_active
				end
			end,
			load_icon = function (parent, widget, element, ui_renderer, dummy_profile, prioritize)
				local content = widget.content
				local item = element.item

				if not content.icon_load_id and item then
					local render_context
					local item_type = item.item_type
					local ui_item_types = UISettings.ITEM_TYPES
					local dummy_profile

					if item_type == ui_item_types.END_OF_ROUND then
						local gender = item.genders and item.genders[1] or "male"
						local breed = item.breeds and item.breeds[1] or "human"
						local archetype = item.archetypes and item.archetypes[1] and Archetypes[item.archetypes[1]] or Archetypes.veteran

						dummy_profile = get_generic_profile(breed, gender, archetype)
					end

					if item_type == ui_item_types.GEAR_HEAD or item_type == ui_item_types.GEAR_LOWERBODY or item_type == ui_item_types.GEAR_UPPERBODY or item_type == ui_item_types.GEAR_EXTRA_COSMETIC or item_type == ui_item_types.END_OF_ROUND then
						local item_state_machine = item.state_machine
						local item_animation_event = item.animation_event
						local item_companion_state_machine = item.companion_state_machine ~= nil and item.companion_state_machine ~= "" and item.companion_state_machine or nil
						local item_companion_animation_event = item.companion_animation_event ~= nil and item.companion_animation_event ~= "" and item.companion_animation_event or nil
						local slots = item.slots
						local slot_name = slots and slots[1]

						render_context = {
							camera_focus_slot_name = slot_name,
							state_machine = item_state_machine,
							animation_event = item_animation_event,
							companion_state_machine = item_companion_state_machine,
							companion_animation_event = item_companion_animation_event,
						}
					end

					local cb = callback(_apply_live_item_icon_cb_func, widget)

					content.icon_load_id = Managers.ui:load_item_icon(item, cb, render_context, prioritize)
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
			update_item_icon_priority = function (parent, widget, element, ui_renderer, dummy_profile)
				local content = widget.content

				if content.icon_load_id then
					Managers.ui:update_item_icon_priority(content.icon_load_id)
				end
			end,
		},
		general_goods_item = {
			size = ItemPassTemplates.store_item_size,
			pass_template = ItemPassTemplates.general_goods_item,
			init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer, double_click_callback)
				local content = widget.content
				local style = widget.style

				content.store_item = true
				content.hotspot.pressed_callback = callback_name and callback(parent, callback_name, widget, element)
				content.hotspot.double_click_callback = double_click_callback and callback(parent, double_click_callback, widget, element)
				content.hotspot.right_pressed_callback = secondary_callback_name and callback(parent, secondary_callback_name, widget, element)
				content.element = element

				local display_information = element.display_information
				local display_name = display_information and display_information.display_name
				local sub_header = display_information and display_information.sub_header
				local background_icon = display_information and display_information.background_icon
				local icon = display_information and display_information.icon

				if display_name then
					content.display_name = display_name
				end

				if sub_header then
					content.sub_display_name = sub_header
				end

				if background_icon then
					content.background_icon = background_icon
				end

				if icon then
					content.icon = icon
				end

				local offer = element.offer

				if offer and offer.price then
					local price_data = offer.price.amount
					local type = price_data.type
					local price = price_data.amount
					local price_text = Text.format_currency(price)

					content.has_price_tag = true
					content.price_text = price_text

					local wallet_settings = WalletSettings[type]

					content.wallet_icon = wallet_settings.icon_texture_small

					local price_text_style = style.price_text
					local view_instance = parent._parent or parent
					local can_afford = view_instance and view_instance.can_afford and view_instance:can_afford(price, type) or false

					price_text_style.material = can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds
				end
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				local view_instance = parent._parent or parent
				local style = widget.style
				local content = widget.content
				local element = content.element
				local offer = element.offer

				if offer and offer.price then
					local price_data = offer.price.amount
					local type = price_data.type
					local price = price_data.amount
					local wallet_settings = WalletSettings[type]
					local price_text_style = style.price_text
					local can_afford = view_instance and view_instance.can_afford and view_instance:can_afford(price, type) or false

					price_text_style.material = can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds
				end
			end,
			destroy = function (parent, widget, element, ui_renderer)
				return
			end,
		},
		credits_goods_item = {
			size = ItemPassTemplates.store_item_credits_goods_size,
			pass_template = ItemPassTemplates.credits_goods_item,
			init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer, double_click_callback)
				local content = widget.content
				local style = widget.style

				content.store_item = true
				content.hotspot.pressed_callback = callback_name and callback(parent, callback_name, widget, element)
				content.hotspot.double_click_callback = double_click_callback and callback(parent, double_click_callback, widget, element)
				content.hotspot.right_pressed_callback = secondary_callback_name and callback(parent, secondary_callback_name, widget, element)
				content.element = element

				local icon = element.icon
				local item = element.item
				local display_name = element.display_name

				if display_name then
					content.display_name = display_name
				end

				local sub_display_name = element.sub_display_name

				if sub_display_name then
					content.sub_display_name = sub_display_name
				end

				if icon then
					content.icon = icon
				end

				local view_instance = parent._parent or parent
				local character_level = view_instance and view_instance.character_level and view_instance:character_level()
				local level_requirement_met = true

				if element.weapon_level_requirement then
					level_requirement_met = character_level >= element.weapon_level_requirement
				end

				content.level_requirement_met = level_requirement_met

				if level_requirement_met == false then
					content.required_level = Localize("loc_requires_level", true, {
						level = element.weapon_level_requirement,
					})
				end
			end,
			update = function (parent, widget, input_service, dt, t, ui_renderer)
				return
			end,
			destroy = function (parent, widget, element, ui_renderer)
				return
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
		item_name = {
			size_function = function (parent, config, ui_renderer)
				return config.size
			end,
			pass_template = ItemPassTemplates.item_name,
			init = function (self, widget, element, callback_name, secondary_callback_name, ui_renderer, profile)
				local item = element.real_item or element.item
				local ignore_localization = element.ignore_localization
				local display_name

				if item.item_type and item.item_type == "CHARACTER_TITLE" then
					display_name = ProfileUtils.title_item_name_no_color(item, profile)
				else
					display_name = ignore_localization and item.display_name or Items.display_name(item)
				end

				local item_type = ignore_localization and item.item_type or Items.type_display_name(item)

				widget.content.title = display_name

				local rarity = item.rarity

				if element.ignore_negative_rarity and rarity and rarity < 0 then
					rarity = nil
				end

				if rarity then
					local rarity_color, rarity_color_dark = Items.rarity_color(item)
					local rarity_display_name = ignore_localization and item.rarity_name or Items.rarity_display_name(item)

					widget.style.background.material_values.line_color = {
						rarity_color[2] / 255,
						rarity_color[3] / 255,
						rarity_color[4] / 255,
						rarity_color[1] / 255,
					}
					widget.style.background.material_values.background_color = {
						rarity_color_dark[2] / 255,
						rarity_color_dark[3] / 255,
						rarity_color_dark[4] / 255,
						rarity_color_dark[1] / 191.25,
					}
					widget.content.description = string.format("{#color(%d, %d, %d)}%s{#reset()} • %s", rarity_color[2], rarity_color[3], rarity_color[4], rarity_display_name, item_type)
				else
					local background_color = Color.terminal_frame(191.25, true)
					local line_color = Color.terminal_frame_hover(255, true)

					widget.style.background.material_values.line_color = {
						line_color[2] / 255,
						line_color[3] / 255,
						line_color[4] / 255,
						line_color[1] / 255,
					}
					widget.style.background.material_values.background_color = {
						background_color[2] / 255,
						background_color[3] / 255,
						background_color[4] / 255,
						background_color[1] / 255,
					}
					widget.content.description = item_type
				end

				local item_name_style = widget.style.title
				local display_description_style = widget.style.description

				if element.use_store_appearance then
					item_name_style.material = "content/ui/materials/font_gradients/slug_font_gradient_gold"
				else
					item_name_style.material = "content/ui/materials/font_gradients/slug_font_gradient_header"
				end

				local item_name_margin = 15
				local item_name_size = {
					widget.content.size[1],
					1080,
				}
				local item_name_height = Text.text_height(ui_renderer, widget.content.title, item_name_style, item_name_size)
				local display_description_height = Text.text_height(ui_renderer, widget.content.description, display_description_style, item_name_size)

				widget.content.size[2] = item_name_height + item_name_margin + display_description_height
				widget.style.title.size = {
					widget.content.size[1],
					item_name_height,
				}
				widget.style.description.size = {
					widget.content.size[1],
					display_description_height,
				}
				widget.style.description.offset[2] = item_name_height + item_name_margin

				local offset_x, offset_y = 0, 0

				if element.horizontal_alignment == "right" then
					offset_x = -widget.content.size[1]
				elseif element.horizontal_alignment == "center" then
					offset_x = -widget.content.size[1] * 0.5
				end

				if element.vertical_alignment == "bottom" then
					offset_y = -widget.content.size[2]
				elseif element.vertical_alignment == "center" then
					offset_x = -widget.content.size[2] * 0.5
				end

				widget.offset[1] = offset_x
				widget.offset[2] = offset_y
				widget.original_offset = table.clone(widget.offset)
			end,
		},
	}
	local WIDGET_TYPE_BY_SLOT = {
		slot_animation_emote_1 = "ui_item",
		slot_animation_emote_2 = "ui_item",
		slot_animation_emote_3 = "ui_item",
		slot_animation_emote_4 = "ui_item",
		slot_animation_emote_5 = "ui_item",
		slot_animation_end_of_round = "gear_item",
		slot_character_title = "character_title_item",
		slot_companion_gear_full = "gear_item",
		slot_gear_extra_cosmetic = "gear_item",
		slot_gear_head = "gear_item",
		slot_gear_lowerbody = "gear_item",
		slot_gear_upperbody = "gear_item",
		slot_insignia = "ui_item",
		slot_portrait_frame = "ui_item",
		slot_trinket_1 = "gear_item",
		slot_trinket_2 = "gear_item",
		slot_weapon_skin = "gear_item",
	}

	return blueprints, WIDGET_TYPE_BY_SLOT
end

return generate_blueprints_function
