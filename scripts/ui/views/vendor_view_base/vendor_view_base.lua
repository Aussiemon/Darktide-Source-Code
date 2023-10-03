local Definitions = require("scripts/ui/views/vendor_view_base/vendor_view_base_definitions")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WalletSettings = require("scripts/settings/wallet_settings")
local TextUtilities = require("scripts/utilities/ui/text")
local Promise = require("scripts/foundation/utilities/promise")
local ItemGridViewBase = require("scripts/ui/views/item_grid_view_base/item_grid_view_base")
local definition_merge_recursive = nil

function definition_merge_recursive(dest, source, stop_recursive)
	for key, value in pairs(source) do
		local is_table = type(value) == "table"

		if value == source then
			dest[key] = dest
		elseif is_table and type(dest[key]) == "table" then
			if not stop_recursive then
				definition_merge_recursive(dest[key], value, true)
			end
		elseif is_table then
			dest[key] = table.clone(value)
		else
			dest[key] = value
		end
	end

	return dest
end

local VendorViewBase = class("VendorViewBase", "ItemGridViewBase")

VendorViewBase.init = function (self, definitions, settings, context)
	local merged_definitions = nil

	if definitions then
		merged_definitions = table.clone(definitions)
	else
		merged_definitions = {}
	end

	definition_merge_recursive(merged_definitions, Definitions)

	self._fetch_store_items_on_enter = context and context.fetch_store_items_on_enter
	self._use_item_categories = context and context.use_item_categories
	self._use_title = context and context.use_title
	self._fetch_account_items = context and context.fetch_account_items
	self._account_items = {}
	self._hide_price = context and context.hide_price
	local optional_sort_options = context and context.optional_sort_options

	if optional_sort_options then
		self._sort_options = optional_sort_options
	end

	VendorViewBase.super.init(self, merged_definitions, settings, context)
end

VendorViewBase.on_enter = function (self)
	VendorViewBase.super.on_enter(self)

	self._current_balance = {}

	self:_update_wallets():next(function ()
		if self._fetch_store_items_on_enter then
			self:_fetch_store_items()
		end
	end)
	self:_register_button_callbacks()
end

VendorViewBase.character_level = function (self)
	local player = self:_player()
	local profile = player:profile()
	local profile_level = profile.current_level

	return profile_level
end

VendorViewBase.equipped_item_in_slot = function (self, slot_name)
	local player = self:_player()
	local profile = player:profile()
	local loadout = profile.loadout
	local slot_item = loadout[slot_name]

	return slot_item
end

VendorViewBase._register_button_callbacks = function (self)
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.purchase_button.content.hotspot.pressed_callback = callback(self, "_cb_on_purchase_pressed")
end

VendorViewBase._cb_on_purchase_pressed = function (self)
	local offer = self._previewed_offer

	if not offer then
		return
	end

	local price_data = offer.price.amount
	local price = price_data.discounted_price or price_data.amount
	local can_afford = self:can_afford(price, price_data.type)

	if can_afford then
		local is_active = offer.state == "active"

		if is_active then
			self:_purchase_item(offer)
		end
	end
end

VendorViewBase.cb_switch_tab = function (self, index, ignore_item_selection)
	self._next_tab_index = index
	self._next_tab_index_ignore_item_selection = ignore_item_selection
end

VendorViewBase._switch_tab = function (self, index, ignore_item_selection)
	self:_stop_previewing()

	self._previewed_offer = nil
	local tabs_content = self._tabs_content
	local tab_content = tabs_content[index]
	local slot_types = tab_content.slot_types
	local display_name = self._use_title and tab_content.display_name

	self:_present_layout_by_slot_filter(slot_types, nil, display_name)

	if not ignore_item_selection then
		local first_element = self:element_by_index(1)
		local first_offer = first_element and first_element.offer

		if first_offer then
			self:focus_on_offer(first_offer)
		end
	end

	local tab_menu_element = self._tab_menu_element

	if tab_menu_element and index ~= tab_menu_element:selected_index() then
		tab_menu_element:set_selected_index(index)
	end
end

VendorViewBase._set_preview_widgets_visibility = function (self, visible)
	VendorViewBase.super._set_preview_widgets_visibility(self, visible)

	local widgets_by_name = self._widgets_by_name
	widgets_by_name.price_text.content.visible = not self._hide_price and visible or false
	widgets_by_name.price_icon.content.visible = not self._hide_price and visible or false
	widgets_by_name.purchase_button.content.visible = visible
end

VendorViewBase._preview_element = function (self, element)
	VendorViewBase.super._preview_element(self, element)

	local offer = element and element.offer
	local price = offer and offer.price.amount

	if not self._hide_price then
		self:_set_display_price(price)
	end

	self._previewed_offer = offer

	self:_update_button_disable_state()
end

VendorViewBase.on_exit = function (self)
	if self._store_promise then
		self._store_promise:cancel()

		self._store_promise = nil
	end

	if self._purchase_promise then
		self._purchase_promise:cancel()

		self._purchase_promise = nil
	end

	if self._wallet_promise then
		self._wallet_promise:cancel()

		self._wallet_promise = nil
	end

	VendorViewBase.super.on_exit(self)
end

VendorViewBase._get_store = function (self)
	return
end

VendorViewBase._clear_list = function (self)
	self._offer_items_layout = {}

	if self._previewed_offer then
		self:_stop_previewing()

		self._previewed_offer = nil
	end

	if self._store_promise then
		self._store_promise:cancel()

		self._store_promise = nil
	end

	if self._tab_menu_element then
		self:_remove_element("tab_menu")

		self._tab_menu_element = nil
	end

	self._current_rotation_end = nil

	self:_present_layout_by_slot_filter({})
end

VendorViewBase._update_account_items = function (self, wrapped, promise)
	local local_player_id = 1
	local player = Managers.player:local_player(local_player_id)
	local character_id = player:character_id()

	return Managers.data_service.gear:fetch_inventory(character_id):next(function (items)
		if self._destroyed then
			return
		end

		self._account_items = items
	end)
end

VendorViewBase.set_loading_state = function (self, state)
	VendorViewBase.super.set_loading_state(self, state)
end

VendorViewBase._fetch_store_items = function (self, ignore_focus_on_offer)
	self._current_rotation_end = nil
	self._offer_items_layout = nil
	self._filtered_offer_items_layout = nil
	self._next_tab_index = nil
	self._next_tab_index_ignore_item_selection = nil

	if self._store_promise then
		self._store_promise:cancel()

		self._store_promise = nil
	end

	local function handle_store_promise_fecthing()
		self:set_loading_state(true)

		local store_promise = self:_get_store()

		if not store_promise then
			return
		end

		local use_item_categories = self._use_item_categories or false
		self._store_promise = store_promise

		store_promise:next(function (data)
			local offers = data.offers
			self._offers = offers

			self:_update_bundle_offers_owned_skus()
			self:set_loading_state(false)

			local layout = self:_convert_offers_to_layout_entries(self._offers)
			self._offer_items_layout = layout
			self._current_rotation_end = data.current_rotation_end
			local menu_tab_content_array, _ = self:_generate_menu_tabs(layout, offers)

			if self._tab_menu_element then
				self:_remove_element("tab_menu")

				self._tab_menu_element = nil
			end

			local use_tab_menu = use_item_categories and #menu_tab_content_array > 1

			self:_update_grid_height(use_tab_menu)

			if use_tab_menu then
				local function tab_sort_function(a, b)
					local store_category_sort_order = UISettings.store_category_sort_order

					if a.store_category and b.store_category then
						return store_category_sort_order[a.store_category] < store_category_sort_order[b.store_category]
					end

					if a.display_name and b.display_name then
						return a.display_name < b.display_name
					end

					return false
				end

				table.sort(menu_tab_content_array, tab_sort_function)
				self:_setup_menu_tabs(menu_tab_content_array)
				self:_switch_tab(1, true)
			elseif #menu_tab_content_array > 0 then
				local content = menu_tab_content_array[1]
				local slot_types = content.slot_types
				local display_name = self._use_title and use_item_categories and content.display_name or nil

				self:_present_layout_by_slot_filter(slot_types, nil, display_name)
			else
				self._current_rotation_end = nil

				self:_present_layout_by_slot_filter({})
			end

			self._store_promise = nil
			local focus_on_first_offer = true

			if self._previewed_offer then
				local preview_offer_id = self._previewed_offer.offerId
				local found = false

				for i = 1, #self._offers do
					local offer = self._offers[i]
					local offer_id = offer.offerId

					if preview_offer_id == offer_id then
						self._previewed_offer = offer
						found = true

						break
					end
				end

				if found == false or ignore_focus_on_offer then
					self:_stop_previewing()

					self._previewed_offer = nil
				else
					self:focus_on_offer(self._previewed_offer)

					focus_on_first_offer = false
				end
			end

			local first_element = self:element_by_index(1)
			local first_offer = first_element and first_element.offer

			if not ignore_focus_on_offer and focus_on_first_offer and first_offer then
				self:focus_on_offer(first_offer)
			end
		end):catch(function (error)
			self:set_loading_state(false)

			self._current_rotation_end = nil
			self._offer_items_layout = nil
			self._filtered_offer_items_layout = nil
			self._next_tab_index = nil
			self._next_tab_index_ignore_item_selection = nil
			self._store_promise = nil
		end)

		return store_promise
	end

	local return_promise = nil
	local fetch_account_items = self._fetch_account_items

	if fetch_account_items then
		return_promise = Promise.all(self:_update_account_items(), handle_store_promise_fecthing())
	else
		return_promise = handle_store_promise_fecthing()
	end

	return return_promise
end

VendorViewBase.is_item_owned = function (self, id)
	return self._account_items[id] ~= nil
end

VendorViewBase._generate_menu_tabs = function (self, layout, offers)
	local generic_category_id = "generic"
	local use_item_categories = self._use_item_categories or false
	local menu_tab_content_by_store_category = {}
	local menu_tab_content_array = {}

	for i = 1, #layout do
		local layout_entry = layout[i]
		local item = layout_entry.item

		if item then
			local slots = item.slots

			if slots then
				local slot_type = slots[1]
				local slot_settings = ItemSlotSettings[slot_type]
				local store_category = use_item_categories and slot_settings.store_category or generic_category_id

				if not menu_tab_content_by_store_category[store_category] then
					local store_category_slot_stypes = {}

					for key, settings in pairs(ItemSlotSettings) do
						if settings.store_category == store_category then
							store_category_slot_stypes[#store_category_slot_stypes + 1] = key
						end
					end

					local tab_content = {
						display_name = UISettings.display_name_by_store_category[store_category],
						icon = UISettings.texture_by_store_category[store_category],
						slot_types = use_item_categories and store_category_slot_stypes,
						store_category = store_category
					}
					menu_tab_content_by_store_category[store_category] = tab_content
					menu_tab_content_array[#menu_tab_content_array + 1] = tab_content
				end
			end
		end
	end

	return menu_tab_content_array, menu_tab_content_by_store_category
end

VendorViewBase._update_grid_height = function (self, use_tab_menu)
	local scenegraph_id = "item_grid_pivot"
	local scenegraph_definition = self._definitions.scenegraph_definition
	local default_scenegraph = scenegraph_definition[scenegraph_id]
	local grid_height_difference = self._use_title and 130 or 0
	local item_grid_position_y = use_tab_menu and default_scenegraph.position[2] + grid_height_difference or default_scenegraph.position[2]

	self:_set_scenegraph_position(scenegraph_id, nil, item_grid_position_y)

	local grid_settings = self._definitions.grid_settings
	local grid_height = grid_settings.grid_size[2]
	local mask_height = grid_settings.mask_size[2]

	if use_tab_menu then
		mask_height = mask_height - grid_height_difference
		grid_height = grid_height - grid_height_difference
	end

	self._item_grid:update_grid_height(grid_height, mask_height)
end

VendorViewBase.cb_on_sort_button_pressed = function (self, option)
	VendorViewBase.super.cb_on_sort_button_pressed(self, option)
end

VendorViewBase._item_valid_by_current_profile = function (self, item)
	local player = self:_player()
	local profile = player:profile()
	local archetype = profile.archetype
	local archetype_name = archetype.name
	local breed_name = archetype.breed
	local breed_valid = not item.breeds or table.contains(item.breeds, breed_name)
	local archetype_valid = self:item_valid_by_profile_archetype(archetype_name, item)

	if archetype_valid and breed_valid then
		return true
	end

	return false
end

VendorViewBase.item_valid_by_profile_archetype = function (self, archetype_name, item)
	return not item.archetypes or table.contains(item.archetypes, archetype_name)
end

VendorViewBase._convert_offers_to_layout_entries = function (self, item_offers)
	local layout = {}

	for i = 1, #item_offers do
		local offer = item_offers[i]
		local offer_id = offer.offerId
		local sku = offer.sku
		local category = sku.category

		if category == "item_instance" then
			local item = MasterItems.get_store_item_instance(offer.description)

			if item then
				local item_type = item.item_type

				if item_type == "WEAPON_SKIN" then
					local preview_item_name = item.preview_item
					local preview_item = preview_item_name and MasterItems.get_item(preview_item_name)

					if preview_item then
						layout[#layout + 1] = {
							widget_type = "gear_item",
							item = item,
							real_item = item,
							offer = offer,
							offer_id = offer_id,
							slot = {
								name = item.slots[1]
							},
							filter_slots = {
								preview_item.slots[1]
							},
							disable_equipped_status = self._disable_equipped_status
						}
					else
						Log.error("VendorViewBase", "Cannot find preview item (%s) for weapon skin (%s)", preview_item, item.name)
					end
				else
					local is_cosmetics_gear = item_type == "GEAR_EXTRA_COSMETIC" or item_type == "GEAR_HEAD" or item_type == "GEAR_UPPERBODY" or item_type == "GEAR_LOWERBODY"
					local widget_type = is_cosmetics_gear and "gear_item" or "store_item"
					layout[#layout + 1] = {
						item = item,
						widget_type = widget_type,
						offer = offer,
						offer_id = offer_id,
						slot = {
							name = item.slots[1]
						},
						disable_equipped_status = self._disable_equipped_status
					}
				end
			end
		elseif category == "bundle" then
			local bundled = offer.description.contents.bundled
			local items = {}
			local rarity = math.huge
			local owned_count = 0
			local total_count = 0

			for k = 1, #bundled do
				local info = bundled[k]
				local gear_id = info.description.gearId
				local set_item = MasterItems.get_store_item_instance(info.description, gear_id)

				if set_item then
					items[#items + 1] = set_item

					if self:is_item_owned(gear_id) then
						owned_count = owned_count + 1
					end

					total_count = total_count + 1

					if set_item.rarity and set_item.rarity < rarity then
						rarity = set_item.rarity
					end
				end
			end

			if #items == #bundled then
				table.sort(items, ItemUtils.compare_set_item_parts_presentation_order)

				local first_item = items[1]
				local fake_set_item = {
					name = "set_item",
					gear_id = offer_id,
					item_type = UISettings.ITEM_TYPES.SET,
					items = items,
					display_name = offer.sku.name or "n/a",
					genders = first_item.genders,
					breeds = first_item.breeds,
					archetypes = first_item.archetypes,
					rarity = rarity,
					description = sku.description
				}
				layout[#layout + 1] = {
					widget_type = "gear_set",
					item = fake_set_item,
					offer = offer,
					offer_id = offer_id,
					total_count = total_count,
					owned_count = owned_count,
					disable_equipped_status = self._disable_equipped_status
				}
			end
		end
	end

	return layout
end

VendorViewBase._update_bundle_offers_owned_skus = function (self)
	local offers = self._offers

	if offers then
		for i = 1, #offers do
			local offer = offers[i]
			local sku = offer.sku
			local category = sku.category

			if category == "bundle" then
				local owned_skus = nil
				local bundled = offer.description.contents.bundled
				local price_data = offer.price.amount
				local price_amount = price_data.amount
				local discounted_price = nil
				local total_count = 0

				for k = 1, #bundled do
					local info = bundled[k]
					local gear_id = info.description.gearId
					total_count = total_count + 1
					local owned = self:is_item_owned(gear_id)

					if owned and info.sku then
						if not owned_skus then
							owned_skus = {}
							discounted_price = price_amount
						end

						owned_skus[#owned_skus + 1] = info.sku.id
						local discount_value = info.discountValue and info.discountValue.amount

						if discounted_price and discount_value then
							discounted_price = discounted_price - discount_value
						end
					end
				end

				offer.owned_skus = owned_skus

				if owned_skus and #owned_skus == total_count then
					offer.state = "owned"
				end

				price_data.discounted_price = discounted_price
			end
		end
	end
end

VendorViewBase._generate_mannequin_loadout = function (self, profile)
	local presentation_profile = profile
	local gender_name = presentation_profile.gender
	local archetype = presentation_profile.archetype
	local breed_name = archetype.breed
	local new_loadout = {}
	local required_breed_item_names_per_slot = UISettings.item_preview_required_slot_items_set_per_slot_by_breed_and_gender[breed_name]
	local required_gender_item_names_per_slot = required_breed_item_names_per_slot and required_breed_item_names_per_slot[gender_name]

	if required_gender_item_names_per_slot then
		local required_items = required_gender_item_names_per_slot

		if required_items then
			for slot_name, slot_item_name in pairs(required_items) do
				local item_definition = MasterItems.get_item(slot_item_name)

				if item_definition then
					local slot_item = table.clone(item_definition)
					new_loadout[slot_name] = slot_item
				end
			end
		end
	end

	return new_loadout
end

VendorViewBase.update = function (self, dt, t, input_service)
	if self._item_grid and self._current_rotation_end then
		local server_time = Managers.backend:get_server_time(t)
		local expire_time = math.max((self._current_rotation_end - server_time) * 0.001, 0)

		self._item_grid:set_expire_time(expire_time)

		if expire_time == 0 then
			self:_fetch_store_items()
		end
	end

	self:_update_button_disable_state()

	return VendorViewBase.super.update(self, dt, t, input_service)
end

VendorViewBase._update_button_disable_state = function (self)
	if self._previewed_offer then
		local offer = self._previewed_offer
		local is_active = offer.state == "active"
		local price_data = offer.price.amount
		local price = price_data.discounted_price or price_data.amount
		local can_afford = self:can_afford(price, price_data.type)
		local widgets_by_name = self._widgets_by_name
		local button_widget = widgets_by_name.purchase_button
		local processing_purchase = self._purchase_promise ~= nil
		local updating_store = self._store_promise ~= nil
		local button_disabled = not can_afford or not is_active or processing_purchase or updating_store

		if not button_disabled and is_active and can_afford and not processing_purchase and not updating_store then
			local sku = offer.sku
			local category = sku.category

			if category == "bundle" then
				local bundled = offer.description.contents.bundled
				local items = {}
				local owned_count = 0
				local total_count = 0

				for k = 1, #bundled do
					local info = bundled[k]
					local gear_id = info.description.gearId
					local set_item = MasterItems.get_store_item_instance(info.description, gear_id)
					items[#items + 1] = set_item

					if self:is_item_owned(gear_id) then
						owned_count = owned_count + 1
					end

					total_count = total_count + 1
				end

				button_disabled = owned_count == total_count
			elseif category == "item_instance" then
				local gear_id = offer.description.gearId
				button_disabled = self:is_item_owned(gear_id)
			end
		end

		if button_widget then
			button_widget.content.hotspot.disabled = button_disabled
		end
	end
end

VendorViewBase._set_display_price = function (self, price_data)
	local price = price_data and (price_data.discounted_price or price_data.amount)
	local type = price_data and price_data.type
	local can_afford = price and self:can_afford(price, type)
	local price_text = nil
	price_text = price and TextUtilities.format_currency(price) or ""
	local widgets_by_name = self._widgets_by_name
	local price_text_widget = widgets_by_name.price_text
	local price_text_widget_style = price_text_widget.style
	local price_text_style = price_text_widget_style.text
	price_text_widget.content.text = price_text
	local wallet_settings = WalletSettings[type]

	if wallet_settings then
		price_text_widget.style.text.material = can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds
		widgets_by_name.price_icon.content.texture = wallet_settings.icon_texture_big
	end

	local text_width, _ = self:_text_size(price_text, price_text_style.font_type, price_text_style.font_size)
	local price_icon_widget = widgets_by_name.price_icon
	local price_icon_scenegraph_id = price_icon_widget.scenegraph_id
	local price_icon_width, _ = self:_scenegraph_size(price_icon_scenegraph_id)
	local price_icon_spacing = 10
	local total_width = text_width + price_icon_spacing + price_icon_width
	price_icon_widget.offset[1] = -total_width * 0.5 + price_icon_width * 0.5
	price_text_widget.offset[1] = price_icon_widget.offset[1] + text_width * 0.5 + price_icon_width * 0.5 + price_icon_spacing
end

VendorViewBase._purchase_item = function (self, offer)
	local store_service = Managers.data_service.store
	local promise = store_service:purchase_item(offer)

	promise:next(function (result)
		local widgets_by_name = self._widgets_by_name
		local purchase_sound = widgets_by_name.purchase_button.content.purchase_sound

		if purchase_sound then
			self:_play_sound(purchase_sound)
		end

		self._purchase_promise = nil
		offer.state = result.offer.state

		self:_on_purchase_complete(result.items)
		self:_update_bundle_offers_owned_skus()
	end):catch(function (error)
		self:_fetch_store_items()

		self._purchase_promise = nil
	end)

	self._purchase_promise = promise
end

VendorViewBase._update_layout_list_on_item_purchase = function (self, items_layout, item)
	local gear_id = item.gear_id

	for j = 1, #items_layout do
		local entry = items_layout[j]
		local entry_item = entry.item

		if entry_item then
			local entry_item_type = entry_item.item_type
			local entry_offer = entry.offer

			if entry_item.gear_id == gear_id then
				entry_offer.state = "owned"
				entry.test = true
			elseif entry_item_type == UISettings.ITEM_TYPES.SET then
				local offer_id = entry_offer.offerId

				if offer_id == gear_id then
					entry_offer.state = "owned"
				else
					local owned_count = 0
					local total_count = 0
					local entry_set_items = entry_item.items

					for k = 1, #entry_set_items do
						local set_item = entry_set_items[k]

						if self:is_item_owned(set_item.gear_id) then
							owned_count = owned_count + 1
						end

						total_count = total_count + 1
					end

					entry.owned_count = owned_count
					entry.total_count = total_count
				end
			end
		end
	end
end

VendorViewBase._on_purchase_complete = function (self, items)
	if #items > 1 then
		table.sort(items, ItemUtils.compare_set_item_parts_presentation_order)
	end

	local offer_items_layout = self._offer_items_layout

	for i, item_data in ipairs(items) do
		local uuid = item_data.uuid
		local item = MasterItems.get_item_instance(item_data, uuid)

		if item then
			local gear_id = item.gear_id
			self._account_items[gear_id] = item

			if offer_items_layout then
				self:_update_layout_list_on_item_purchase(offer_items_layout, item)
			end

			ItemUtils.mark_item_id_as_new(item)
			Managers.event:trigger("event_vendor_view_purchased_item")
			self:_update_wallets()
		end
	end
end

VendorViewBase._update_wallets = function (self)
	local store_service = Managers.data_service.store
	local promise = store_service:combined_wallets()

	promise:next(function (wallets_data)
		self:_update_wallets_presentation(wallets_data)

		self._wallet_promise = nil
	end)

	self._wallet_promise = promise

	return promise
end

VendorViewBase._update_wallets_presentation = function (self, wallets_data)
	if wallets_data and wallets_data.wallets then
		for i = 1, #wallets_data.wallets do
			local currency = wallets_data.wallets[i].balance
			local type = currency.type
			local wallet = wallets_data:by_type(type)
			local balance = wallet and wallet.balance
			local amount = balance and balance.amount or 0
			self._current_balance[type] = amount
		end
	end
end

VendorViewBase.can_afford = function (self, amount, type)
	return amount <= (self._current_balance[type] or 0)
end

VendorViewBase._handle_input = function (self, input_service, dt, t)
	local next_tab_index = self._next_tab_index

	if next_tab_index then
		self:_switch_tab(next_tab_index, self._next_tab_index_ignore_item_selection)

		self._next_tab_index = nil
		self._next_tab_index_ignore_item_selection = nil
	else
		local is_mouse = self._using_cursor_navigation

		if not is_mouse then
			local grid = self._item_grid
			local button_widget = self._widgets_by_name.purchase_button
			local is_purchase_disabled = button_widget.content.hotspot.disabled

			if self._previewed_offer and input_service:get("confirm_pressed") and not is_purchase_disabled then
				self:_cb_on_purchase_pressed()
			elseif grid then
				local selected_index = grid:selected_grid_index()

				if self._current_select_grid_index ~= selected_index then
					self._current_select_grid_index = selected_index
					local widgets = grid:widgets()
					local widget = widgets[selected_index]

					if widget and widget.content.hotspot.pressed_callback then
						widget.content.hotspot.pressed_callback()
					end
				end
			end
		end
	end

	VendorViewBase.super._handle_input(self, input_service, dt, t)
end

VendorViewBase._setup_sort_options = function (self)
	if not self._sort_options then
		self._sort_options = {
			{
				display_name = Localize("loc_inventory_item_grid_sort_title_item_power"),
				sort_function = ItemUtils.sort_comparator({
					">",
					ItemUtils.compare_item_level,
					">",
					ItemUtils.compare_item_type,
					"<",
					ItemUtils.compare_item_name,
					"<",
					ItemUtils.compare_item_rarity
				})
			},
			{
				display_name = Localize("loc_inventory_item_grid_sort_title_item_type"),
				sort_function = ItemUtils.sort_comparator({
					">",
					ItemUtils.compare_item_type,
					"<",
					ItemUtils.compare_item_name,
					">",
					ItemUtils.compare_item_level,
					"<",
					ItemUtils.compare_item_rarity
				})
			}
		}
	end

	local sort_callback = callback(self, "cb_on_sort_button_pressed")

	self._item_grid:setup_sort_button(self._sort_options, sort_callback, 1)
end

return VendorViewBase
