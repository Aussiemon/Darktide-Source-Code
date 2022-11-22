local Definitions = require("scripts/ui/views/vendor_view_base/vendor_view_base_definitions")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WalletSettings = require("scripts/settings/wallet_settings")
local TextUtilities = require("scripts/utilities/ui/text")
local ItemGridViewBase = require("scripts/ui/views/item_grid_view_base/item_grid_view_base")
local VendorViewBase = class("VendorViewBase", "ItemGridViewBase")

VendorViewBase.init = function (self, definitions, settings, context)
	local merged_definitions = table.clone(Definitions)

	if definitions then
		table.merge_recursive(merged_definitions, definitions)
	end

	self._fetch_store_items_on_enter = context and context.fetch_store_items_on_enter

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
	local can_afford = self:can_afford(price_data.amount, price_data.type)

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
	local display_name = tab_content.display_name

	self:_present_layout_by_slot_filter(slot_types, display_name)

	if not ignore_item_selection then
		local first_element = self:element_by_index(1)
		local first_offer = first_element and first_element.offer

		if first_offer then
			self:focus_on_offer(first_offer)
		end
	end
end

VendorViewBase._set_preview_widgets_visibility = function (self, visible)
	VendorViewBase.super._set_preview_widgets_visibility(self, visible)

	local widgets_by_name = self._widgets_by_name
	widgets_by_name.price_text.content.visible = visible
	widgets_by_name.purchase_button.content.visible = visible
	widgets_by_name.price_icon.content.visible = visible
end

VendorViewBase._preview_element = function (self, element)
	VendorViewBase.super._preview_element(self, element)

	local offer = element.offer
	local price = offer.price.amount

	self:_set_display_price(price)

	self._previewed_offer = offer
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

VendorViewBase._fetch_store_items = function (self)
	self._current_rotation_end = nil
	self._offer_items_layout = nil
	self._filtered_offer_items_layout = nil
	self._next_tab_index = nil
	self._next_tab_index_ignore_item_selection = nil

	if self._store_promise then
		self._store_promise:cancel()

		self._store_promise = nil
	end

	local store_promise = self:_get_store()

	if not store_promise then
		return
	end

	local use_item_categories = false
	local generic_category_id = "generic"

	store_promise:next(function (data)
		local offers = data.offers
		self._offers = offers
		local layout = self:_convert_offers_to_layout_entries(self._offers)
		self._offer_items_layout = layout
		self._current_rotation_end = data.current_rotation_end
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

		if self._tab_menu_element then
			self:_remove_element("tab_menu")

			self._tab_menu_element = nil
		end

		local use_tab_menu = use_item_categories and #menu_tab_content_array > 1

		self:_update_grid_height(use_tab_menu)

		if use_tab_menu then
			local function tab_sort_function(a, b)
				local store_category_sort_order = UISettings.store_category_sort_order

				return store_category_sort_order[a.store_category] < store_category_sort_order[b.store_category]
			end

			table.sort(menu_tab_content_array, tab_sort_function)
			self:_setup_menu_tabs(menu_tab_content_array)
			self:_switch_tab(1, true)
		elseif #menu_tab_content_array > 0 then
			local content = menu_tab_content_array[1]
			local slot_types = content.slot_types
			local display_name = use_item_categories and content.display_name or nil

			self:_present_layout_by_slot_filter(slot_types, display_name)
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

			if found == false then
				self:_stop_previewing()

				self._previewed_offer = nil
			else
				self:focus_on_offer(self._previewed_offer)

				focus_on_first_offer = false
			end
		end

		local first_element = self:element_by_index(1)
		local first_offer = first_element and first_element.offer

		if focus_on_first_offer and first_offer then
			self:focus_on_offer(first_offer)
		end
	end):catch(function (error)
		self._current_rotation_end = nil
		self._offer_items_layout = nil
		self._filtered_offer_items_layout = nil
		self._next_tab_index = nil
		self._next_tab_index_ignore_item_selection = nil
		self._store_promise = nil
	end)

	self._store_promise = store_promise
end

VendorViewBase._update_grid_height = function (self, use_tab_menu)
	local grid_height_difference = 130
	local item_grid_position_y = use_tab_menu and 40 + grid_height_difference or 40

	self:_set_scenegraph_position("item_grid_pivot", nil, item_grid_position_y)

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
	self._item_grid:set_expire_time(self._current_rotation_end)
end

VendorViewBase._item_valid_by_current_profile = function (self, item)
	local player = self:_player()
	local profile = player:profile()
	local archetype = profile.archetype
	local archetype_name = archetype.name
	local breed_name = archetype.breed
	local breed_valid = not item.breeds or table.contains(item.breeds, breed_name)
	local archetype_valid = not item.archetypes or table.contains(item.archetypes, archetype_name)

	if archetype_valid and breed_valid then
		return true
	end

	return false
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
						local visual_item = table.clone_instance(preview_item)
						visual_item.gear_id = item.gear_id
						visual_item.slot_weapon_skin = item
						layout[#layout + 1] = {
							widget_type = "store_item",
							item = visual_item,
							real_item = item,
							offer = offer,
							offer_id = offer_id
						}
					else
						Log.error("VendorViewBase", "Cannot find preview item (%s) for weapon skin (%s)", preview_item, item.name)
					end
				else
					layout[#layout + 1] = {
						widget_type = "store_item",
						item = item,
						offer = offer,
						offer_id = offer_id
					}
				end
			end
		end
	end

	return layout
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

	if self._previewed_offer then
		local offer = self._previewed_offer
		local is_active = offer.state == "active"
		local price_data = offer.price.amount
		local can_afford = self:can_afford(price_data.amount, price_data.type)
		local widgets_by_name = self._widgets_by_name
		local button_widget = widgets_by_name.purchase_button
		local processing_purchase = self._purchase_promise ~= nil
		local updating_store = self._store_promise ~= nil

		if button_widget then
			button_widget.content.hotspot.disabled = not can_afford or not is_active or processing_purchase or updating_store
		end
	end

	return VendorViewBase.super.update(self, dt, t, input_service)
end

VendorViewBase._set_display_price = function (self, price_data)
	local amount = price_data.amount
	local type = price_data.type
	local can_afford = self:can_afford(amount, type)
	local price_text = nil
	price_text = amount and TextUtilities.format_currency(amount) or ""
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
		self._purchase_promise = nil
		offer.state = result.offer.state

		self:_on_purchase_complete(result.items)
	end):catch(function (error)
		self:_fetch_store_items()

		self._purchase_promise = nil
	end)

	self._purchase_promise = promise
end

VendorViewBase._on_purchase_complete = function (self, items)
	for i, item_data in ipairs(items) do
		local item = MasterItems.get_store_item_instance(item_data)

		if item then
			local gear_id = item.gear_id
			local item_type = item.item_type

			ItemUtils.mark_item_id_as_new(gear_id, item_type)
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

VendorViewBase._handle_input = function (self, input_service)
	local next_tab_index = self._next_tab_index

	if next_tab_index then
		self:_switch_tab(next_tab_index, self._next_tab_index_ignore_item_selection)

		self._next_tab_index = nil
		self._next_tab_index_ignore_item_selection = nil
	else
		local is_mouse = self._using_cursor_navigation

		if not is_mouse then
			if self._previewed_offer and input_service:get("confirm_pressed") then
				self:_cb_on_purchase_pressed()
			elseif self._item_grid then
				local grid = self._item_grid
				local selected_index = grid:selected_grid_index()

				if self._current_select_grid_index ~= selected_index then
					self._current_select_grid_index = selected_index
					local widgets = self._item_grid:widgets()
					local widget = widgets[selected_index]

					if widget and widget.content.hotspot.pressed_callback then
						widget.content.hotspot.pressed_callback()
					end
				end
			end
		end
	end
end

return VendorViewBase
