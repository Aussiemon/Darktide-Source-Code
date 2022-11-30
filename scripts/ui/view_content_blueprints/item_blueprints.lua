local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ItemPassTemplates = require("scripts/ui/pass_templates/item_pass_templates")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local ItemUtils = require("scripts/utilities/items")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local WalletSettings = require("scripts/settings/wallet_settings")
local UISettings = require("scripts/settings/ui/ui_settings")
local MasterItems = require("scripts/backend/master_items")
local TextUtilities = require("scripts/utilities/ui/text")
local Archetypes = require("scripts/settings/archetype/archetypes")

local function is_item_equipped_in_slot(parent, item, slot_name)
	if not parent or not item then
		return false
	end

	local equipped = false

	if parent.equipped_item_in_slot then
		local equipped_item = parent:equipped_item_in_slot(slot_name)
		local equipped_gear_id = equipped_item and equipped_item.gear_id
		local item_gear_id = item.gear_id
		equipped = item_gear_id == equipped_gear_id
	end

	if parent.equipped_item_name_in_slot then
		local equipped_item_name = parent:equipped_item_name_in_slot(slot_name)

		if not equipped_item_name and item.empty_item then
			return true
		end

		local item_name = item.gear.masterDataInstance.id
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
		gender = gender
	}
	local required_breed_item_names_per_slot = UISettings.item_preview_required_slot_items_set_per_slot_by_breed_and_gender[breed]
	local required_gender_item_names_per_slot = required_breed_item_names_per_slot and required_breed_item_names_per_slot[gender]

	if required_gender_item_names_per_slot then
		local required_items = required_gender_item_names_per_slot

		if required_items then
			for slot_name, slot_item_name in pairs(required_items) do
				local item_definition = MasterItems.get_item(slot_item_name)

				if item_definition then
					local slot_item = table.clone(item_definition)
					dummy_profile.loadout[slot_name] = slot_item
				end
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
		local material_values = widget.style.icon.material_values
		material_values.texture_icon = icon
		material_values.use_placeholder_texture = 0
		widget.content.use_placeholder_texture = material_values.use_placeholder_texture
	end

	local function _remove_package_item_icon_cb_func(widget, ui_renderer)
		UIWidget.set_visible(widget, ui_renderer, false)
		UIWidget.set_visible(widget, ui_renderer, true)

		local material_values = widget.style.icon.material_values
		material_values.texture_icon = nil
		material_values.use_placeholder_texture = 1
		widget.content.use_placeholder_texture = material_values.use_placeholder_texture
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

	local function _remove_live_item_icon_cb_func(widget)
		local material_values = widget.style.icon.material_values
		material_values.use_placeholder_texture = 1
		material_values.render_target = nil
		widget.content.use_placeholder_texture = material_values.use_placeholder_texture
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
		}
	}
	blueprints.ui_item = {
		size = ItemPassTemplates.ui_item_size,
		pass_template = ItemPassTemplates.ui_item,
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
				local display_name = item and item.display_name

				if display_name then
					content.display_name = ItemUtils.display_name(item)
					content.sub_display_name = ItemUtils.sub_display_name(item)
				end

				local item_icon_size = slot.item_icon_size
				style.icon.material_values.icon_size = item_icon_size
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local view_instance = parent._parent
			local content = widget.content
			local element = content.element
			local slot = element.slot
			local slot_name = slot.name
			local item = element.real_item or element.item
			local is_equipped = is_item_equipped_in_slot(view_instance, item, slot_name)
			content.equipped = is_equipped
		end,
		load_icon = function (parent, widget, element, ui_renderer, dummy_profile)
			local content = widget.content

			if not content.icon_load_id then
				local item = element.item
				local slot = element.slot
				local slot_name = slot.name
				local cb = callback(_apply_package_item_icon_cb_func, widget, item)
				local render_context = {
					camera_focus_slot_name = slot_name
				}
				content.icon_load_id = Managers.ui:load_item_icon(item, cb, render_context, dummy_profile)
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
	}
	blueprints.gear_item = {
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
				local display_name = item and item.display_name

				if display_name then
					content.display_name = ItemUtils.display_name(item)
					content.sub_display_name = ItemUtils.sub_display_name(item)
				end
			end

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
				price_text_style.horizontal_alignment = "right"
				local initial_margin = -15
				local icon_margin = 5
				price_text_style.offset[1] = initial_margin
				local price_text_size = UIRenderer.text_size(ui_renderer, price_text, price_text_style.font_type, price_text_style.font_size) or 0
				local wallet_icon_style = style.wallet_icon
				wallet_icon_style.offset[1] = initial_margin - price_text_size - icon_margin
				local can_afford = true
				price_text_style.material = can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds
			end

			local owned_count = element.owned_count
			local total_count = element.total_count

			if owned_count and total_count and total_count > 0 then
				local is_owned = owned_count == total_count
				content.owned = is_owned and "" or owned_count > 0 and string.format("%d/%d", owned_count, total_count) or nil
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local view_instance = parent._parent
			local content = widget.content
			local element = content.element
			local slot = element.slot
			local slot_name = slot.name
			local item = element.real_item or element.item
			local is_equipped = is_item_equipped_in_slot(view_instance, item, slot_name)
			content.equipped = is_equipped
		end,
		load_icon = function (parent, widget, element, ui_renderer, dummy_profile)
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
				content.icon_load_id = Managers.ui:load_item_icon(item, cb, render_context, dummy_profile)
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
	blueprints.item_icon = {
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
				price_text_style.horizontal_alignment = "right"
				local initial_margin = -15
				local icon_margin = 5
				price_text_style.offset[1] = initial_margin
				local price_text_size = UIRenderer.text_size(ui_renderer, price_text, price_text_style.font_type, price_text_style.font_size) or 0
				local wallet_icon_style = style.wallet_icon
				wallet_icon_style.offset[1] = initial_margin - price_text_size - icon_margin
				local can_afford = true
				price_text_style.material = can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds
			end

			local owned_count = element.owned_count
			local total_count = element.total_count

			if owned_count and total_count and total_count > 0 then
				local is_owned = owned_count == total_count
				content.owned = is_owned and "" or owned_count > 0 and string.format("%d/%d", owned_count, total_count) or nil
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local view_instance = parent._parent
			local style = widget.style
			local content = widget.content
			local element = content.element
			local item = element.real_item or element.item

			if item then
				local slots = item and item.slots
				local slot_name = element.slot_name or slots and slots[1]
				local is_equipped = slot_name and is_item_equipped_in_slot(view_instance, item, slot_name)
				content.equipped = is_equipped
			end
		end,
		load_icon = function (parent, widget, element, ui_renderer, dummy_profile)
			local content = widget.content

			if not content.icon_load_id then
				local item = element.item or element.real_item
				local cb = callback(_apply_live_item_icon_cb_func, widget)
				content.icon_load_id = Managers.ui:load_item_icon(item, cb, nil, dummy_profile)
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
			local rarity = item.rarity
			local slots = item.slots

			if slots then
				local slot_name = slots[1]
				local slot_settings = slot_name and ItemSlotSettings[slot_name]
				style.inner_highlight.color = table.clone(ItemUtils.rarity_color(item))
			end

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
				local price_text_size = UIRenderer.text_size(ui_renderer, price_text, price_text_style.font_type, price_text_style.font_size) or 0
				local wallet_icon_style = style.wallet_icon
				wallet_icon_style.offset[1] = ItemPassTemplates.icon_size[1] - wallet_icon_style.size[1] - (price_text_size + 10) + style.price_text.offset[1]
				local can_afford = false
				price_text_style.material = can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds
			end

			local display_name = item.display_name

			if display_name then
				content.display_name = ItemUtils.display_name(item)
				local no_color = true
				content.sub_display_name = ItemUtils.sub_display_name(item)
			end

			if style.item_level then
				content.item_level = ItemUtils.item_level(item)
			end

			local item_type = item.item_type
			local ITEM_TYPES = UISettings.ITEM_TYPES
			local is_weapon = item_type == ITEM_TYPES.WEAPON_MELEE or item_type == ITEM_TYPES.WEAPON_RANGED

			if is_weapon then
				local traits = item.traits

				if traits then
					local item_trait_frame_texture_lookup = UISettings.item_trait_frame_texture_lookup
					local trait_index = 1

					for i = 1, #traits do
						local trait = traits[i]
						local trait_id = trait.id
						local rarity = trait.rarity
						local trait_item = MasterItems.get_item(trait_id)

						if trait_item then
							local texture_icon, texture_frame = ItemUtils.trait_textures(trait_item, rarity)
							local pass_id = "trait_" .. trait_index
							local trait_style = style[pass_id]

							if trait_style then
								local material_values = trait_style.material_values
								material_values.icon = texture_icon
								material_values.frame = texture_frame
							end

							content[pass_id] = trait_id
							trait_index = trait_index + 1
						end
					end
				end
			end

			local required_level = ItemUtils.character_level(item)
			local view_instance = parent._parent
			local character_level = view_instance and view_instance.character_level and view_instance:character_level()
			local level_requirement_met = required_level and required_level <= character_level
			content.level_requirement_met = level_requirement_met

			if not level_requirement_met then
				local required_level_text = Localize("loc_requires_level", true, {
					level = required_level
				})
				content.required_level = required_level_text
				local required_level_style = style.required_level
				local required_level_text_width = UIRenderer.text_size(ui_renderer, required_level_text, required_level_style.font_type, required_level_style.font_size) or 0
				local required_level_background_style = style.required_level_background
				required_level_background_style.size[1] = required_level_text_width + 40
			end

			style.sub_display_name.default_color = table.clone(ItemUtils.rarity_color(item))
			style.display_name.default_color = table.clone(ItemUtils.rarity_color(item))
			style.background_gradient.color = table.clone(ItemUtils.rarity_color(item))
			style.rarity_tag.color = table.clone(ItemUtils.rarity_color(item))
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local view_instance = parent._parent
			local style = widget.style
			local content = widget.content
			local element = content.element
			local slot = element.slot

			if slot then
				local slot_name = slot.name
				local item = element.real_item or element.item
				local item_type = item.item_type
				local is_equipped = nil

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
		load_icon = function (parent, widget, element, ui_renderer, dummy_profile)
			local content = widget.content

			if not content.icon_load_id then
				local item = element.item
				local cb = callback(_apply_live_item_icon_cb_func, widget)
				content.icon_load_id = Managers.ui:load_item_icon(item, cb, nil, dummy_profile)
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
	blueprints.store_item = {
		size = ItemPassTemplates.store_item_size,
		pass_template = ItemPassTemplates.item,
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer, double_click_callback)
			local content = widget.content
			local style = widget.style
			content.hotspot.pressed_callback = callback_name and callback(parent, callback_name, widget, element)
			content.hotspot.double_click_callback = double_click_callback and callback(parent, double_click_callback, widget, element)
			content.hotspot.right_pressed_callback = secondary_callback_name and callback(parent, secondary_callback_name, widget, element)
			content.element = element
			local item = element.item
			local real_item = element.real_item
			local presentation_item = real_item or item
			local slots = presentation_item.slots
			local rarity = presentation_item.rarity
			local rarity_color = ItemUtils.rarity_color(presentation_item)

			if slots and rarity then
				style.inner_highlight.color = table.clone(rarity_color)
			end

			local offer = element.offer

			if offer and offer.price then
				local price_data = offer.price.amount
				local type = price_data.type
				local price = price_data.amount
				local price_text = TextUtilities.format_currency(price)
				content.has_price_tag = true
				content.price_text = price_text
				local wallet_settings = WalletSettings[type]
				content.wallet_icon = wallet_settings.icon_texture_small
				local price_text_style = style.price_text
				local can_afford = false
				price_text_style.material = can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds
				local is_active = offer.state == "active"
				content.sold = not is_active
			end

			local item_type = item.item_type

			if item_type == UISettings.ITEM_TYPES.GEAR_LOWERBODY or item_type == UISettings.ITEM_TYPES.GEAR_UPPERBODY or item_type == UISettings.ITEM_TYPES.GEAR_HEAD or item_type == UISettings.ITEM_TYPES.GEAR_EXTRA_COSMETIC or item_type == UISettings.ITEM_TYPES.END_OF_ROUND then
				local icon_style = style.icon
				local icon_size = icon_style.size
				local icon_offset = icon_style.offset
				icon_size[1] = UISettings.item_icon_size[1]
				icon_offset[1] = icon_offset[1] - icon_size[1] * 0.3
			end

			local item_level, has_item_level = ItemUtils.item_level(presentation_item)

			if content.item_level then
				content.item_level = has_item_level and item_level or ""
			end

			local required_level = ItemUtils.character_level(presentation_item)
			local view_instance = parent._parent
			local character_level = view_instance and view_instance.character_level and view_instance:character_level()
			local level_requirement_met = required_level and required_level <= character_level
			content.level_requirement_met = level_requirement_met

			if not level_requirement_met then
				content.required_level = Localize("loc_requires_level", true, {
					level = required_level
				})
			end

			local display_name = presentation_item.display_name

			if display_name then
				content.display_name = ItemUtils.display_name(presentation_item)
				local no_color = true
				content.sub_display_name = ItemUtils.sub_display_name(presentation_item, not level_requirement_met and required_level)
			end

			if rarity then
				style.sub_display_name.default_color = table.clone(rarity_color)
				style.display_name.default_color = table.clone(rarity_color)
				style.background_gradient.color = table.clone(rarity_color)
				style.rarity_tag.color = table.clone(rarity_color)
			end

			local traits = presentation_item.traits

			if traits then
				local trait_index = 1

				for i = 1, #traits do
					local trait = traits[i]
					local trait_id = trait.id
					local trait_rarity = trait.rarity
					local trait_item = MasterItems.get_item(trait_id)

					if trait_item then
						local texture_icon, texture_frame = ItemUtils.trait_textures(trait_item, trait_rarity)
						local pass_id = "trait_" .. trait_index
						local trait_style = style[pass_id]

						if trait_style then
							local material_values = trait_style.material_values
							material_values.icon = texture_icon
							material_values.frame = texture_frame
						end

						content[pass_id] = trait_id
						trait_index = trait_index + 1
					end
				end
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local view_instance = parent._parent
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
		load_icon = function (parent, widget, element, ui_renderer)
			local content = widget.content

			if not content.icon_load_id then
				local item = element.item
				local render_context = nil
				local item_type = item.item_type
				local ui_item_types = UISettings.ITEM_TYPES
				local dummy_profile = nil

				if item_type == ui_item_types.END_OF_ROUND then
					local gender = item.genders and item.genders[1] or "male"
					local breed = item.breeds and item.breeds[1] or "human"
					local archetype = item.archetypes and item.archetypes[1] and Archetypes[item.archetypes[1]] or Archetypes.veteran
					dummy_profile = get_generic_profile(breed, gender, archetype)
				end

				if item_type == ui_item_types.GEAR_HEAD or item_type == ui_item_types.GEAR_LOWERBODY or item_type == ui_item_types.GEAR_UPPERBODY or item_type == ui_item_types.GEAR_EXTRA_COSMETIC or item_type == ui_item_types.END_OF_ROUND then
					local item_state_machine = item.state_machine
					local item_animation_event = item.animation_event
					local slots = item.slots
					local slot_name = slots and slots[1]
					render_context = {
						camera_focus_slot_name = slot_name,
						state_machine = item_state_machine,
						animation_event = item_animation_event
					}
				end

				local cb = callback(_apply_live_item_icon_cb_func, widget)
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
	blueprints.general_goods_item = {
		size = ItemPassTemplates.store_item_size,
		pass_template = ItemPassTemplates.general_goods_item,
		init = function (parent, widget, element, callback_name, secondary_callback_name, ui_renderer, double_click_callback)
			local content = widget.content
			local style = widget.style
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
				local price_text = TextUtilities.format_currency(price)
				content.has_price_tag = true
				content.price_text = price_text
				local wallet_settings = WalletSettings[type]
				content.wallet_icon = wallet_settings.icon_texture_small
				local price_text_style = style.price_text
				local can_afford = false
				price_text_style.material = can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds
			end
		end,
		update = function (parent, widget, input_service, dt, t, ui_renderer)
			local view_instance = parent._parent
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
