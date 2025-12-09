-- chunkname: @scripts/ui/views/store_view/store_view.lua

local Archetypes = require("scripts/settings/archetype/archetypes")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local DLCUtils = require("scripts/utilities/dlc_utils")
local Items = require("scripts/utilities/items")
local LoadingStateData = require("scripts/ui/loading_state_data")
local MasterItems = require("scripts/backend/master_items")
local Offer = require("scripts/utilities/offer")
local PremiumCurrencyPurchaseView = require("scripts/ui/views/premium_currency_purchase_view/premium_currency_purchase_view")
local Promise = require("scripts/foundation/utilities/promise")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local StoreViewBlueprintFactory = require("scripts/ui/views/store_view/store_view_blueprint_factory")
local StoreViewDefinitions = require("scripts/ui/views/store_view/store_view_definitions")
local StoreViewSettings = require("scripts/ui/views/store_view/store_view_settings")
local Text = require("scripts/utilities/ui/text")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementTabMenu = require("scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu")
local ViewElementWallet = require("scripts/ui/view_elements/view_element_wallet/view_element_wallet")
local Vo = require("scripts/utilities/vo")
local DIRECTION = {
	DOWN = 2,
	LEFT = 3,
	RIGHT = 4,
	UP = 1,
}
local TAB_ELEMENT_LAYER = 4
local STORE_LAYOUT = {
	{
		display_name = "loc_premium_store_category_title_featured",
		storefront = "premium_store_featured",
		telemetry_name = "featured",
		template = ButtonPassTemplates.terminal_tab_menu_with_divider_button,
	},
	{
		display_name = "loc_premium_store_category_skins_title_veteran",
		storefront = "premium_store_skins_veteran",
		telemetry_name = "veteran",
		template = ButtonPassTemplates.terminal_tab_menu_with_divider_button,
	},
	{
		display_name = "loc_premium_store_category_skins_title_zealot",
		storefront = "premium_store_skins_zealot",
		telemetry_name = "zealot",
		template = ButtonPassTemplates.terminal_tab_menu_with_divider_button,
	},
	{
		display_name = "loc_premium_store_category_skins_title_psyker",
		storefront = "premium_store_skins_psyker",
		telemetry_name = "psyker",
		template = ButtonPassTemplates.terminal_tab_menu_with_divider_button,
	},
	{
		display_name = "loc_premium_store_category_skins_title_ogryn",
		storefront = "premium_store_skins_ogryn",
		telemetry_name = "ogryn",
		template = ButtonPassTemplates.terminal_tab_menu_with_divider_button,
	},
	{
		display_name = "loc_premium_store_category_skins_title_adamant",
		storefront = "premium_store_skins_adamant",
		telemetry_name = "adamant",
		template = ButtonPassTemplates.terminal_tab_menu_with_divider_button,
		require_archetype_ownership = Archetypes.adamant,
	},
	{
		display_name = "loc_premium_store_category_skins_title_broker",
		storefront = "premium_store_skins_broker",
		telemetry_name = "broker",
		template = ButtonPassTemplates.terminal_tab_menu_button,
		require_archetype_ownership = Archetypes.broker,
	},
}
local DEBUG_GRID = false
local StoreView = class("StoreView", "BaseView")

StoreView.init = function (self, settings, context)
	self._context = context or {}
	self._storefront_request_id = 1

	StoreView.super.init(self, StoreViewDefinitions, settings, context)

	self._pass_draw = false
	self._can_exit = true
	self._wallet_type = {
		"aquilas",
	}
	self._current_vo_event = nil
	self._current_vo_id = nil
	self._vo_unit = nil

	self._vo_callback = function (...)
		if not self.__deleted then
			return self:_cb_on_play_vo(...)
		end
	end

	self._vo_world_spawner = nil
	self._hub_interaction = context and context.hub_interaction

	if IS_PLAYSTATION then
		self._ps_store_icon_showing = false
	end
end

StoreView.on_enter = function (self)
	StoreView.super.on_enter(self)

	self._options_voice_fx = Application.user_setting("sound_settings", "voice_fx_setting") ~= false

	if not self._options_voice_fx then
		Wwise.set_state("options_voice_fx", "on")
	end

	self._account_items = {}
	self._url_textures = {}

	self:_setup_background_world()
	self:_setup_input_legend()
	self:_setup_offscreen_gui()
	self:_register_button_callbacks()

	self._wallet_element = self:_add_element(ViewElementWallet, "wallet_element", 100)

	self:_update_element_position("wallet_element_pivot", self._wallet_element, true)
	self._wallet_element:generate_currencies(self._wallet_type, {
		nil,
		30,
	})

	self._store_promise = self:_update_account_items():next(function ()
		if self._destroyed or not self._store_promise then
			return
		end

		self._store_promise = nil
		self._on_enter_anim_id = self:_start_animation("on_enter", self._widgets_by_name, self)

		self:_setup_navigation_arrows()
	end):catch(function (error)
		self._store_promise = nil
	end)

	if self._hub_interaction then
		local narrative_manager = Managers.narrative
		local narrative_event_name = "level_unlock_premium_store_visited"

		if narrative_manager:can_complete_event(narrative_event_name) then
			narrative_manager:complete_event(narrative_event_name)
			self:play_vo_events(StoreViewSettings.vo_event_vendor_first_interaction, "purser_a", nil, 0.8)
		else
			self:play_vo_events(StoreViewSettings.vo_event_vendor_greeting, "purser_a", nil, 0.8, true)
		end
	end
end

StoreView._update_store_page = function (self)
	self:_update_wallets()

	return self:_update_account_items():next(function ()
		if self._destroyed then
			return
		end

		local path = {
			page_index = self._selected_page_index or 1,
			category_index = self._selected_category_index or 1,
		}

		return self:_open_navigation_path(path):next(function ()
			if self._destroyed then
				return
			end

			local found_element

			for i = 1, #self._grid_widgets do
				local element = self._grid_widgets[i].content.element

				if element.offer.offerId == self._selected_store_item_offerId then
					found_element = element

					break
				end
			end

			return found_element
		end):catch(function (error)
			return
		end)
	end):catch(function (error)
		return
	end)
end

StoreView._on_navigation_input_changed = function (self)
	if self._using_cursor_navigation and (not self._aquila_open or true) then
		if self._grid_widgets then
			self:_set_selected_grid_index()
		end
	elseif self._aquila_open then
		-- Nothing
	elseif self._grid_widgets then
		local index = self:_get_first_grid_panel_index()

		if index then
			self:_set_selected_grid_index(index)
		end
	end
end

StoreView._set_panels_store = function (self)
	if self._category_panel then
		self:_destroy_category_panel()
	end

	local tab_menu_settings = {
		button_spacing = 20,
		horizontal_alignment = "center",
		wrapped_selection = true,
		button_size = {
			200,
			30,
		},
	}
	local category_panel = self:_setup_element(ViewElementTabMenu, "category_panel", TAB_ELEMENT_LAYER, tab_menu_settings)

	self._category_panel = category_panel

	local input_action_left = "navigate_primary_left_pressed"
	local input_action_right = "navigate_primary_right_pressed"

	category_panel:set_input_actions(input_action_left, input_action_right)
	category_panel:set_is_handling_navigation_input(true)

	local category_panel_tab_ids = {}

	for i = 1, #STORE_LAYOUT do
		local tab_content = STORE_LAYOUT[i]
		local display_name = Utf8.upper(Localize(tab_content.display_name))
		local tab_button_template = table.clone(tab_content.template)

		tab_button_template[1].style = {
			on_released_sound = nil,
			on_hover_sound = UISoundEvents.tab_secondary_button_hovered,
			on_pressed_sound = UISoundEvents.tab_secondary_button_pressed,
		}

		local function entry_callback_function()
			local path = {
				page_index = 1,
				category_index = i,
			}

			if not self._using_cursor_navigation then
				self:_play_sound(UISoundEvents.tab_secondary_button_pressed)
			end

			self:_open_navigation_path(path)
			category_panel:set_selected_index(i)
		end

		local cb = callback(entry_callback_function)
		local tab_id = category_panel:add_entry(display_name, cb, tab_button_template, nil, nil, true)

		category_panel_tab_ids[i] = tab_id

		category_panel:set_selected_index(1)
	end

	self._category_tab_ids = category_panel_tab_ids

	if #category_panel_tab_ids > 0 then
		self._widgets_by_name.category_panel_background.content.visible = true
	end

	self:_update_panel_positions()
end

StoreView._update_account_items = function (self)
	return Managers.data_service.gear:fetch_inventory():next(function (items)
		self._account_items = items
	end)
end

StoreView._initialize_opening_page = function (self)
	local path = {
		category_index = 1,
		page_index = 1,
	}

	if self._context.target_storefront then
		for i = 1, #STORE_LAYOUT do
			if STORE_LAYOUT[i].storefront == self._context.target_storefront then
				path.category_index = i
			end
		end
	end

	self:_open_navigation_path(path)
end

StoreView._register_button_callbacks = function (self)
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.aquila_button.content.hotspot.pressed_callback = function ()
		if not self._category_panel then
			return
		end

		self:_cb_on_grid_exit_done()

		if self._page_panel then
			self:_remove_element("page_panel")

			self._page_panel = nil
			self._widgets_by_name.navigation_arrow_left.content.visible = false
			self._widgets_by_name.navigation_arrow_right.content.visible = false
		end

		self._widgets_by_name.aquila_button.content.visible = false
		self._widgets_by_name.get_dlc_button.content.hotspot.disabled = true
		self._widgets_by_name.get_dlc_button.content.visible = false

		self:_destroy_category_panel()

		if self._store_promise then
			self._store_promise:cancel()

			self._store_promise = nil
		end

		if self._debounce_tab_switch then
			self._debounce_tab_switch:cancel()
		end

		self._input_legend_element:set_visibility(false)
		PremiumCurrencyPurchaseView.open(callback(self, "cb_on_aquilas_closed"))
	end
end

StoreView._get_first_grid_panel_index = function (self)
	for i = 1, #self._grid_widgets do
		local widget = self._grid_widgets[i]

		if widget and widget.content.hotspot and not widget.content.hotspot.disabled then
			return i
		end
	end
end

StoreView._get_last_grid_panel_index = function (self)
	for i = #self._grid_widgets, 1, -1 do
		local widget = self._grid_widgets[i]

		if widget and widget.content.hotspot and not widget.content.hotspot.disabled then
			return i
		end
	end
end

StoreView._destroy_category_panel = function (self)
	if self._category_panel then
		self:_remove_element("category_panel")

		self._category_panel = nil
		self._widgets_by_name.category_panel_background.content.visible = false
	end
end

StoreView.cb_on_aquilas_closed = function (self, success)
	if success then
		self:_update_wallets()
	end

	local path = {
		page_index = self._selected_page_index,
		category_index = self._selected_category_index,
	}

	self._selected_category_index = nil
	self._selected_page_index = nil

	if self.closing_view then
		return
	end

	self._widgets_by_name.aquila_button.content.visible = true

	self._input_legend_element:set_visibility(true)
	self:_open_navigation_path(path)
end

StoreView.cb_on_back_pressed = function (self)
	local view_name = self.view_name

	Managers.ui:close_view(view_name)
	self:_play_sound(UISoundEvents.default_menu_exit)
end

StoreView._setup_offscreen_gui = function (self)
	local ui_manager = Managers.ui
	local class_name = self.__class_name
	local timer_name = "ui"
	local world_layer = 10
	local world_name = class_name .. "_ui_offscreen_world"
	local view_name = self.view_name

	self._world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)

	local viewport_name = class_name .. "_ui_offscreen_world_viewport"
	local viewport_type = "overlay_offscreen"
	local viewport_layer = 1

	self._viewport = ui_manager:create_viewport(self._world, viewport_name, viewport_type, viewport_layer)
	self._viewport_name = viewport_name
	self._ui_offscreen_renderer = ui_manager:create_renderer(class_name .. "_ui_offscreen_renderer", self._world)
end

StoreView._destroy_offscreen_gui = function (self)
	if self._ui_offscreen_renderer then
		self._ui_offscreen_renderer = nil

		Managers.ui:destroy_renderer(self.__class_name .. "_ui_offscreen_renderer")

		local world = self._world
		local viewport_name = self._viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._viewport_name = nil
		self._world = nil
	end
end

StoreView._setup_background_world = function (self)
	self:_register_event("event_register_store_view_camera")

	local world_name = StoreViewSettings.world_name
	local world_layer = StoreViewSettings.world_layer
	local world_timer_name = StoreViewSettings.timer_name

	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)

	if self._context then
		self._context.background_world_spawner = self._world_spawner
	end

	local level_name = StoreViewSettings.level_name

	self._world_spawner:spawn_level(level_name)
end

StoreView.event_register_store_view_camera = function (self, camera_unit)
	self:_unregister_event("event_register_store_view_camera")

	local viewport_name = StoreViewSettings.viewport_name
	local viewport_type = StoreViewSettings.viewport_type
	local viewport_layer = StoreViewSettings.viewport_layer
	local shading_environment = StoreViewSettings.shading_environment

	self._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)
	self._world_spawner:set_listener(viewport_name)
end

StoreView._setup_element = function (self, element, reference_name, layer, additional_settings)
	if self:_element(reference_name) then
		self:_remove_element(reference_name)
	end

	layer = layer or 1

	return self:_add_element(element, reference_name, layer, additional_settings)
end

StoreView._check_owned = function (self, store_item)
	local is_owned = false

	if not store_item then
		return is_owned
	end

	if type(store_item.description) == "table" and store_item.description.type == "skin_set" then
		local parts = store_item.description.contents.parts or {}
		local own_count = 0
		local set_count = 0

		for _, offer_item in pairs(parts) do
			set_count = set_count + 1
			own_count = self:_check_owned(offer_item) and own_count + 1 or own_count
		end

		is_owned = own_count == set_count
	elseif type(store_item.description) == "table" and store_item.description.type == "bundle" then
		local own_count = 0

		for i = 1, #store_item.bundleInfo do
			local bundle_item = store_item.bundleInfo[i]

			own_count = self:_check_owned(bundle_item) and own_count + 1 or own_count
		end

		is_owned = own_count == #store_item.bundleInfo
	elseif type(store_item.description) == "table" then
		is_owned = self:_check_owned(store_item.description)
	else
		is_owned = self:is_item_owned(store_item.gearId)
	end

	return is_owned
end

StoreView.is_item_owned = function (self, id)
	return self._account_items[id]
end

StoreView._open_navigation_path = function (self, path)
	local category_index = path.category_index or 1
	local page_index = path.page_index or 1

	if not self._category_panel then
		self:_set_panels_store()
		self._category_panel:set_selected_index(category_index)
	end

	local page_callback = callback(function ()
		self:_on_page_index_selected(page_index)
	end)

	return self:_on_category_index_selected(category_index, page_callback)
end

StoreView._on_category_index_selected = function (self, index, on_complete_callback)
	local category_layout = STORE_LAYOUT[index]

	self._selected_category_layout = category_layout

	local storefront = category_layout.storefront
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.get_dlc_button.content.hotspot.disabled = true
	widgets_by_name.get_dlc_button.content.visible = false

	local archetype = category_layout.require_archetype_ownership

	if archetype then
		DLCUtils.is_archetype_available(archetype):next(function (result)
			widgets_by_name.get_dlc_button.content.hotspot.disabled = result.available
			widgets_by_name.get_dlc_button.content.visible = not result.available

			widgets_by_name.get_dlc_button.content.hotspot.pressed_callback = function ()
				Managers.dlc:open_dlc_view(archetype.requires_dlc, archetype.deluxe_dlc, function (is_success)
					if is_success then
						self:_on_category_index_selected(index, on_complete_callback)
					end
				end)
			end
		end)
	end

	if self._debounce_tab_switch then
		self._debounce_tab_switch:cancel()
	end

	local is_item_detail_view_active = Managers.ui:view_active("store_item_detail_view")

	self._debounce_tab_switch = self._using_cursor_navigation and not is_item_detail_view_active and Promise.resolved() or Promise.delay(0.3)

	local promise = self._debounce_tab_switch:next(function ()
		if self._selected_category_index == index and not is_item_detail_view_active then
			return
		end

		self._selected_category_index = index
		self._debounce_tab_switch = nil

		return self:_fetch_storefront(storefront, on_complete_callback)
	end)

	return promise
end

StoreView._clear_telemetry_name = function (self)
	local telemetry_name = self._telemetry_name

	if telemetry_name then
		Managers.telemetry_events:close_view(telemetry_name)

		self._telemetry_name = nil
	end
end

StoreView._set_telemetry_name = function (self, category, page)
	self:_clear_telemetry_name()

	page = page or 1

	local telemetry_name = string.format("%s_store_%d_view", category, page)

	self._telemetry_name = telemetry_name

	Managers.telemetry_events:open_view(telemetry_name, self._hub_interaction)
end

StoreView._on_page_index_selected = function (self, page_index)
	local category_index = self._selected_category_index
	local category_layout = STORE_LAYOUT[category_index]
	local category_name = category_layout.telemetry_name

	self:_set_telemetry_name(category_name, page_index)

	local category_pages_layout_data = self._category_pages_layout_data

	if not category_pages_layout_data then
		return
	end

	local page_layout = category_pages_layout_data[page_index]

	if not page_layout then
		return
	end

	local previous_page_index = self._selected_page_index

	self._selected_page_index = page_index

	if self._page_panel then
		self._page_panel:set_selected_index(page_index)
	end

	local grid_settings = page_layout.grid_settings
	local elements = page_layout.elements
	local sequence_promise

	if self:_is_animation_active(self._grid_exit_animation_id) then
		sequence_promise = Promise.until_value_is_true(function ()
			return self._grid_widgets == nil
		end)
	else
		sequence_promise = Promise.resolved():next(function ()
			self:_destroy_current_grid()
		end)
	end

	sequence_promise:next(function ()
		self:_setup_grid(elements, grid_settings)

		local image_promises = {}

		for i = 1, #self._grid_widgets do
			self._grid_widgets[i].alpha_multiplier = 0

			local image_promise = self._grid_widgets[i].config._texture_load_promise

			if image_promise then
				table.insert(image_promises, image_promise)
			end
		end

		local promise

		if #image_promises > 0 then
			promise = Promise.race(Promise.delay(0.5), Promise.all(unpack(image_promises)))
		else
			promise = Promise.resolved()
		end

		promise:next(callback(self, "_show_grid_entries", page_index, previous_page_index), function ()
			return
		end)
	end)
end

StoreView._show_grid_entries = function (self, page_index, previous_page_index)
	if self._grid_widgets == nil then
		return
	end

	self:_start_animation("grid_entry", self._grid_widgets, self, nil, 1)

	local grid_index

	if not previous_page_index or previous_page_index <= page_index then
		grid_index = self:_get_first_grid_panel_index()
	else
		grid_index = self:_get_last_grid_panel_index()
	end

	if not self._using_cursor_navigation and grid_index then
		self:_set_selected_grid_index(grid_index)
	end

	self._widgets_by_name.navigation_arrow_left.content.visible = page_index > 1
	self._widgets_by_name.navigation_arrow_right.content.visible = page_index < #self._category_pages_layout_data
end

local function sum(arr, from, to)
	if arr == nil then
		return 0
	end

	local sum = 0

	for i = from or 1, to or #arr do
		sum = sum + arr[i]
	end

	return sum
end

StoreView._find_empty_element_with_type = function (self, pages, type)
	for _, page in ipairs(pages) do
		for _, element in ipairs(page.elements) do
			if not element.selected and table.array_contains(element.item_types, type) then
				element.selected = true

				return element
			end
		end
	end

	return nil
end

StoreView._is_owned = function (self, items)
	local total_count = 0
	local owned_count = 0
	local owned_items = {}

	for i = 1, #items do
		local item = items[i]

		total_count = total_count + 1

		local is_owned = self:is_item_owned(item.gearId)

		owned_count = is_owned and owned_count + 1 or owned_count

		if is_owned then
			owned_items[#owned_items + 1] = item
		end
	end

	return total_count == owned_count, owned_items
end

StoreView._fill_layout_with_offers = function (self, pages, offers, bundle_rules)
	if not offers then
		return {}
	end

	local promises = {}
	local index = 1

	for _, offer in ipairs(offers) do
		local element = self:_find_empty_element_with_type(pages, offer.description.type)

		if element then
			local widget_types = {
				special_offer_1 = "button_special_offer_1",
			}
			local metadata_presentation_data = offer.sku.metadata and offer.sku.metadata.customPresentation

			element.widget_type = metadata_presentation_data and widget_types[metadata_presentation_data] or "button"

			local bundle_info = offer.bundleInfo

			if bundle_info then
				local starting_price = offer.price and offer.price.amount.amount or 0
				local discounted_price = starting_price
				local items = Offer.extract_items(offer)
				local _, owned_items = self:_is_owned(items)

				if #owned_items > 0 then
					for i = 1, #bundle_info do
						local part = bundle_info[i]

						if part.discountValue then
							for j = 1, #owned_items do
								local owned = owned_items[j]

								if owned.gearId == part.description.gear_id then
									discounted_price = discounted_price - part.discountValue.amount
								end
							end
						end
					end
				end

				if discounted_price ~= starting_price then
					local total_rounding = bundle_rules and bundle_rules.totalRounding or 1

					discounted_price = math.round(discounted_price / total_rounding) * total_rounding
					offer.discount = starting_price
					offer.price.amount.amount = math.max(discounted_price, 0)
					element.discount = offer.discount
				else
					offer.discount = nil
				end
			end

			local title = offer.sku.name
			local item_type = Utf8.upper(offer.description.type)
			local item = offer.description.id and offer.description.id ~= "<n/a>" and MasterItems.get_item(offer.description.id)

			if item then
				title = Localize(item.display_name)
				item_type = item.item_type
			end

			local item_type_display_name_localized = Items.type_display_name({
				item_type = item_type,
			})

			if offer.description.type == "platform_purchase" then
				item_type_display_name_localized = offer.description.localized_subtitle or Localize("loc_term_glossary_dlc")
			end

			element.title = title
			element.sub_title = item_type_display_name_localized
			element.offer = offer

			local price = offer.price.amount

			self:_format_price(element, price)

			element.owned = self:_check_owned(offer)

			local imageURL

			if element.mediaSize and offer.media then
				imageURL = Offer.find_media_url(offer, function (media)
					return media.mediaSize == element.mediaSize
				end)
				element.image_url = imageURL

				if imageURL then
					local url_textures = self._url_textures

					url_textures[#url_textures + 1] = imageURL

					Managers.url_loader:load_texture(imageURL, nil, "store_view")
				end
			end

			if not element.media_url and offer.sku and offer.sku.category == "item_instance" and offer.description.type == "weapon" then
				local item = MasterItems.get_store_item_instance(offer.description)

				if item then
					element.slot = item.slots[1]
					element.item = item
				else
					element.selected = false
				end
			end

			promises[#promises + 1] = Promise.resolved(element)
			index = index + 1
		end
	end

	return promises
end

StoreView._format_price = function (self, element, price)
	if price.formattedPrice then
		element.formattedPrice = price.formattedPrice
	else
		element.price = price.amount
	end
end

StoreView._fetch_storefront = function (self, storefront, on_complete_callback)
	self:_unload_url_textures()

	local storefront_request_id = self._storefront_request_id + 1

	self._storefront_request_id = storefront_request_id

	if self._store_promise then
		self._store_promise:cancel()

		self._store_promise = nil
	end

	local store_service = Managers.data_service.store

	self._store_promise = store_service:get_premium_store(storefront)

	if not self._store_promise then
		return Promise:resolved()
	end

	if self._page_panel then
		self:_remove_element("page_panel")

		self._page_panel = nil
		self._widgets_by_name.navigation_arrow_left.content.visible = false
		self._widgets_by_name.navigation_arrow_right.content.visible = false
	end

	if not self._store_promise:is_fulfilled() then
		self:_fade_out_grid(2)
	else
		self:_cb_on_grid_exit_done()
	end

	return self._store_promise:next(function (data)
		if self:_is_animation_active(self._grid_exit_animation_id) then
			self:_complete_animation(self._grid_exit_animation_id)
		end

		if storefront_request_id ~= self._storefront_request_id or not self._store_promise or not data then
			self._store_promise = nil

			return
		end

		if self._destroyed then
			return
		end

		local store_id = data.id
		local account_save_data = Managers.save:account_data()

		if store_id and store_service:is_featured_store(storefront) and account_save_data.last_seen_store_id ~= store_id then
			account_save_data.last_seen_store_id = store_id

			Managers.save:queue_save()
		end

		self._catalog_timer = data.catalog_validity

		local w, h = self:_scenegraph_size("grid_background")
		local start_pos = self:_scenegraph_world_position("grid_background", 1)
		local offers = data.offers
		local valid_offers = {}

		for i = 1, #offers do
			local offer = offers[i]
			local bundle_info = offer.bundleInfo
			local platform_info = offer.platformInfo

			if bundle_info then
				local offer_valid = true

				for j = 1, #bundle_info do
					local bundle_offer = bundle_info[j]
					local is_item = bundle_offer.sku and bundle_offer.sku.category == "item_instance"
					local item

					if is_item then
						item = MasterItems.get_store_item_instance(bundle_offer.description)

						if not item then
							offer_valid = false
						end
					end
				end

				if offer_valid then
					valid_offers[#valid_offers + 1] = offer
				end
			elseif platform_info then
				valid_offers[#valid_offers + 1] = offer
			else
				local is_item = offer.sku and offer.sku.category == "item_instance"
				local item

				if is_item then
					item = MasterItems.get_store_item_instance(offer.description)
				end

				if not is_item or is_item and item then
					valid_offers[#valid_offers + 1] = offer
				end
			end
		end

		local layout_config = data.layout_config
		local layout = layout_config and layout_config.layout or {
			pages = {
				{
					items = {},
				},
			},
		}
		local layout_pages = layout.pages
		local spacing = {
			30,
			40,
		}
		local category_pages_layout_data = {}

		for i = 1, #layout_pages do
			local page = layout_pages[i]
			local num_columns = sum(page.gridTemplateColumns)
			local num_rows = sum(page.gridTemplateRows)
			local items = page.items
			local elements = {}

			for j = 1, #items do
				local item = items[j]
				local column_index = 1 + sum(page.gridTemplateColumns, 1, item.gridColumnStart - 1)
				local row_index = 1 + sum(page.gridTemplateRows, 1, item.gridRowStart - 1)
				local cell_count_width = sum(page.gridTemplateColumns, item.gridColumnStart, item.gridColumnEnd - 1)
				local cell_count_height = sum(page.gridTemplateRows, item.gridRowStart, item.gridRowEnd - 1)

				table.insert(item.itemTypes, "platform_purchase")

				elements[j] = {
					index = j,
					display_name = string.format("page_%d_entry_%d", i, j),
					grid_position = {
						column_index,
						row_index,
					},
					grid_size = {
						cell_count_width,
						cell_count_height,
					},
					spacing = spacing,
					mediaSize = item.mediaSize,
					size_scale = {
						cell_count_width / num_columns,
						cell_count_height / num_rows,
					},
					position_scale = {
						(column_index - 1) / num_columns,
						(row_index - 1) / num_rows,
					},
					item_types = item.itemTypes,
				}
			end

			local grid_cell_width = w / num_columns
			local grid_cell_height = h / num_rows

			category_pages_layout_data[i] = {
				elements = elements,
				grid_settings = {
					size = {
						w,
						h,
					},
					start_offset = {
						start_pos[1],
						start_pos[2],
					},
					rows = num_rows,
					columns = num_columns,
					cell_size = {
						grid_cell_width,
						grid_cell_height,
					},
				},
			}
		end

		local count = 0
		local target = #offers
		local last_index = 1

		for i = 1, #category_pages_layout_data do
			local page = category_pages_layout_data[i]

			count = count + #page.elements
			last_index = i

			if target <= count then
				break
			end
		end

		table.remove_sequence(category_pages_layout_data, last_index + 1, #category_pages_layout_data)

		self._category_pages_layout_data = category_pages_layout_data
		self._store_promise = Promise.all(unpack(self:_fill_layout_with_offers(category_pages_layout_data, valid_offers, data.bundle_rules))):next(function (elements)
			if self._destroyed or not self._store_promise then
				return
			end

			if self:_is_animation_active(self._grid_exit_animation_id) then
				self:_complete_animation(self._grid_exit_animation_id)
			end

			self._store_promise = nil

			self:_setup_panels(category_pages_layout_data)

			if on_complete_callback then
				on_complete_callback()
			end
		end):catch(function (elements)
			if self._destroyed or not self._store_promise then
				return
			end

			self._store_promise = nil

			self:_setup_panels(category_pages_layout_data)

			if on_complete_callback then
				on_complete_callback()
			end
		end)

		return self._store_promise
	end):catch(function (error)
		self._store_promise = nil
	end)
end

StoreView._setup_panels = function (self, category_pages_layout_data)
	if #category_pages_layout_data > 1 then
		local tab_menu_settings = {
			button_spacing = 0,
			fixed_button_size = true,
			horizontal_alignment = "center",
			button_size = {
				30,
				30,
			},
		}
		local page_panel = self:_setup_element(ViewElementTabMenu, "page_panel", TAB_ELEMENT_LAYER, tab_menu_settings)

		self._page_panel = page_panel

		local tab_button_template = table.clone(ButtonPassTemplates.page_indicator_terminal)
		local page_panel_tab_ids = {}

		for i = 1, #category_pages_layout_data do
			local function entry_callback_function()
				local path = {
					category_index = self._selected_category_index,
					screen_index = self._selected_screen_index,
					page_index = i,
				}

				self:_open_navigation_path(path)
			end

			local cb = callback(entry_callback_function)
			local tab_id = page_panel:add_entry("", cb, tab_button_template)

			page_panel_tab_ids[i] = tab_id
		end

		self._page_panel_tab_ids = page_panel_tab_ids

		self:_update_panel_positions()
	elseif self._page_panel then
		self:_remove_element("page_panel")

		self._page_panel = nil
	end

	self:_setup_navigation_arrows(category_pages_layout_data)
end

StoreView._setup_navigation_arrows = function (self, layout_pages)
	self._selected_page_index = 1
	self._widgets_by_name.navigation_arrow_left.content.visible = false
	self._widgets_by_name.navigation_arrow_right.content.visible = false

	self._widgets_by_name.navigation_arrow_right.content.hotspot.pressed_callback = function ()
		local page_index = self._selected_page_index + 1

		self:_fade_out_grid(2)
		self:_on_page_index_selected(page_index)
	end

	self._widgets_by_name.navigation_arrow_left.content.hotspot.pressed_callback = function ()
		local page_index = self._selected_page_index - 1

		self:_fade_out_grid(2)
		self:_on_page_index_selected(page_index)
	end
end

StoreView._set_catalog_expire_time = function (self, catalog_timer)
	local t = Managers.time:time("main")
	local server_time

	server_time = Managers.backend:get_server_time(t)

	local start_time = catalog_timer.valid_from
	local end_time = catalog_timer.valid_to
	local valid_start_time = start_time and start_time <= server_time
	local valid_end_time = end_time and server_time <= end_time

	if valid_start_time and valid_end_time then
		return end_time - server_time > 0
	elseif not valid_start_time and start_time then
		return true
	elseif not valid_end_time and end_time then
		return false
	else
		return true
	end
end

StoreView._set_expire_time = function (self, offer)
	local t = Managers.time:time("main")
	local server_time

	server_time = Managers.backend:get_server_time(t)

	local time = offer:seconds_remaining(server_time)
	local min_time_to_disply_timer = StoreViewSettings.min_time_to_disply_timer

	if time and time > 0 then
		local timer_text = time and Text.format_time_span_long_form_localized(time) or ""

		if min_time_to_disply_timer and min_time_to_disply_timer <= time or not min_time_to_disply_timer then
			return timer_text
		end
	end
end

StoreView._update_panel_positions = function (self)
	if self._page_panel then
		local position = self:_scenegraph_world_position("page_panel_pivot")

		self._page_panel:set_pivot_offset(position[1], position[2])
	end

	if self._category_panel then
		local position = self:_scenegraph_world_position("category_panel_pivot")

		self._category_panel:set_pivot_offset(position[1], position[2])

		self._category_panel_width = self._category_panel:get_total_width()

		self:_set_scenegraph_size("category_panel_background", self._category_panel_width)
	end
end

StoreView.can_exit = function (self)
	return self._can_exit
end

StoreView.on_exit = function (self)
	self:_clear_telemetry_name()

	if not self._options_voice_fx then
		Wwise.set_state("options_voice_fx", "off")
	end

	if self._world_spawner then
		self._world_spawner:release_listener()
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	if self._input_legend_element then
		self._input_legend_element = nil

		self:_remove_element("input_legend")
	end

	if self._store_promise then
		self._store_promise:cancel()
	end

	if self._purchase_promise then
		self._purchase_promise:cancel()
	end

	if self._wallet_promise then
		self._wallet_promise:cancel()
	end

	self:_destroy_offscreen_gui()
	self:_destroy_current_grid()
	self:_unload_url_textures()
	StoreView.super.on_exit(self)

	if self._hub_interaction then
		local level = Managers.state.mission and Managers.state.mission:mission_level()

		if level then
			Level.trigger_event(level, "lua_premium_store_closed")
		end
	end
end

StoreView._unload_url_textures = function (self)
	local url_textures = self._url_textures
	local url_texture_count = url_textures and #url_textures or 0

	for i = 1, url_texture_count do
		local url = url_textures[i]

		Managers.url_loader:unload_texture(url)
	end

	self._url_textures = {}
end

StoreView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 10)

	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

StoreView._handle_input = function (self, input_service)
	local using_cursor = self._using_cursor_navigation

	if not using_cursor then
		if input_service:get("hotkey_menu_special_2") and not self._aquila_open and not self._widgets_by_name.get_dlc_button.content.hotspot.disabled then
			self._widgets_by_name.get_dlc_button.content.hotspot.pressed_callback()
		end

		if input_service:get("hotkey_menu_special_1") and not self._aquila_open and not self._widgets_by_name.aquila_button.content.hotspot.disabled then
			self:_play_sound(UISoundEvents.default_click)
			self._widgets_by_name.aquila_button.content.hotspot.pressed_callback()
		elseif self._aquila_open then
			-- Nothing
		end
	end
end

StoreView.update = function (self, dt, t, input_service)
	if not self:can_handle_input() then
		input_service = input_service:null_service()
	end

	local is_animation_active = self:_is_animation_active(self._grid_exit_animation_id)

	if self._store_promise or self._purchase_promise then
		self._widgets_by_name.loading.content.visible = not is_animation_active

		if not self._show_loading then
			Managers.event:trigger("event_start_waiting")
		end

		Managers.event:trigger("event_set_waiting_state", LoadingStateData.WAIT_REASON.store)

		local wait_reason, _, text_opacity = Managers.ui:current_wait_info()

		self._widgets_by_name.loading.content.text = wait_reason or ""
		self._widgets_by_name.loading.style.text.text_color[1] = text_opacity
		self._show_loading = true
	elseif self._show_loading then
		self._show_loading = false

		Managers.event:trigger("event_stop_waiting")

		self._widgets_by_name.loading.content.visible = false
	end

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end

	self:_find_next_widget_selection(input_service)
	self:_update_timers()
	self:_update_vo(dt, t)

	if self._category_panel and self._category_panel:get_total_width() ~= self._category_panel_width then
		self:_update_panel_positions()
	end

	local wallet_width = self._wallet_element:get_size()[1]

	if wallet_width ~= self._wallet_width then
		self._wallet_width = wallet_width

		local corner_right = self._widgets_by_name.corner_top_right

		if not corner_right.content.original_size then
			local corner_width, corner_height = self:_scenegraph_size("corner_top_right")

			corner_right.content.original_size = {
				corner_width,
				corner_height,
			}
		end

		local corner_width = corner_right.content.original_size[1]
		local total_corner_width = wallet_width + corner_width

		self:_set_scenegraph_size("corner_top_right", total_corner_width, nil)
	end

	return StoreView.super.update(self, dt, t, input_service)
end

StoreView._update_timers = function (self)
	local should_refresh_offers = false

	if self._catalog_timer then
		local time_remaining = self:_set_catalog_expire_time(self._catalog_timer)

		if not time_remaining then
			self._catalog_timer = nil
			should_refresh_offers = true
		end
	end

	if should_refresh_offers then
		local path = {
			page_index = self._selected_page_index or 1,
			category_index = self._selected_category_index or 1,
			screen_index = self._selected_screen_index or 1,
		}

		self:_open_navigation_path(path)
	end
end

StoreView._blur_fade_in = function (self, duration, anim_func)
	self._world_spawner:set_camera_blur(0.75, duration, anim_func)

	self._blurred = true
end

StoreView._blur_fade_out = function (self, duration, anim_func)
	self._world_spawner:set_camera_blur(0, duration, anim_func)

	self._blurred = false
end

StoreView._destroy_current_grid = function (self)
	if self._grid_widgets then
		for i = 1, #self._grid_widgets do
			local widget = self._grid_widgets[i]
			local widget_name = widget.name

			self:_unregister_widget_name(widget_name)

			if widget.delete then
				widget:delete()
			end
		end

		self._grid_widgets = nil
	end
end

StoreView._fade_out_grid = function (self, speed)
	if not self._grid_widgets then
		return
	end

	self._grid_exit_animation_id = self:_start_animation("grid_exit", self._grid_widgets, self, callback(self, "_cb_on_grid_exit_done"), speed)
end

StoreView._cb_on_grid_exit_done = function (self)
	self:_destroy_current_grid()
end

StoreView.cb_on_grid_entry_left_pressed = function (self, widget, element)
	if self._purchase_promise then
		return
	end

	local offer = element.offer
	local item_type = offer.description.type

	if item_type ~= "platform_purchase" then
		self._selected_store_item_offerId = element.offer.offerId

		Managers.ui:open_view("store_item_detail_view", nil, nil, nil, nil, {
			store_item = element,
			parent = self,
		})

		return
	else
		local product_id

		if IS_XBS then
			product_id = offer.sku.platformInfo.xbs
		elseif IS_GDK then
			product_id = offer.sku.platformInfo.xbs
		elseif IS_PLAYSTATION then
			product_id = offer.sku.platformInfo.psn
		elseif HAS_STEAM then
			product_id = offer.sku.platformInfo.steam
		else
			product_id = offer.sku.platformInfo.steam
		end

		Managers.dlc:open_to_store(product_id, nil)
	end
end

StoreView._setup_grid = function (self, layout, grid_settings)
	self._active_grid_settings = grid_settings

	local widgets = {}
	local left_click_callback_name = "cb_on_grid_entry_left_pressed"

	for index, entry in ipairs(layout) do
		local widget_suffix = entry.display_name
		local widget = self:_create_entry_widget_from_config(entry, widget_suffix, left_click_callback_name)

		widgets[#widgets + 1] = widget
	end

	self._grid_widgets = widgets
end

StoreView._find_widget_by_grid_cell = function (self, row, column)
	local grid_widgets = self._grid_widgets

	if not grid_widgets then
		return
	end

	for i = 1, #grid_widgets do
		local widget = grid_widgets[i]
		local config = widget.config
		local grid_position = config.grid_position
		local grid_size = config.grid_size
		local correct_column = column >= grid_position[1] and column < grid_position[1] + grid_size[1]
		local correct_row = row >= grid_position[2] and row < grid_position[2] + grid_size[2]

		if correct_column and correct_row then
			return widget, i
		end
	end
end

StoreView._create_entry_widget_from_config = function (self, config, suffix, primary_callback_name)
	if not config.offer then
		return
	end

	local scenegraph_id = "grid_content_pivot"
	local ui_renderer = self._ui_renderer
	local widget_type = config.widget_type
	local layout_width, layout_height = self:_scenegraph_size("grid_background")
	local size_scale = config.size_scale
	local spacing = config.spacing
	local new_size

	if size_scale then
		new_size = {
			layout_width * size_scale[1] - spacing[1],
			layout_height * size_scale[2] - spacing[2],
		}
	end

	local position_scale = config.position_scale
	local new_position

	if position_scale then
		new_position = {
			position_scale[1] * layout_width + spacing[1] * 0.5,
			position_scale[2] * layout_height + spacing[2] * 0.5,
			0,
		}
	end

	local template

	template = StoreViewBlueprintFactory.create_blueprint(new_size, config)

	local size = new_size or config.size or template.size_function and template.size_function(self, config) or template.size
	local pass_template_function = template.pass_template_function
	local pass_template = pass_template_function and pass_template_function(self, config) or template.pass_template
	local widget_definition = UIWidget.create_definition(pass_template, scenegraph_id, nil, size)
	local name = "widget_" .. suffix
	local widget = self:_create_widget(name, widget_definition)

	widget.type = widget_type
	widget.offset = new_position or {
		0,
		0,
		0,
	}
	widget.nodes = self:_generate_nine_grid_nodes(size, widget.offset)
	widget.config = config

	local init = template.init

	if init then
		init(self, widget, config, primary_callback_name)
	end

	widget.content.hotspot.disabled = config.disabled
	widget.alpha_multiplier = config.disabled and 0.5 or 1

	if widget.content.item then
		template.load_icon(self, widget, config)
	end

	if template.destroy then
		widget.delete = function (w)
			template.destroy(self, w, config, nil)
		end
	end

	return widget
end

StoreView._find_next_widget_selection = function (self, input_service)
	local grid_widgets = self._grid_widgets

	if not grid_widgets then
		return
	end

	local current_index = self._selected_grid_index

	if not current_index then
		return
	end

	local selected_widget = grid_widgets[current_index] or grid_widgets[1]
	local input_direction

	if input_service:get("navigate_up_continuous") then
		input_direction = DIRECTION.UP
	elseif input_service:get("navigate_down_continuous") then
		input_direction = DIRECTION.DOWN
	elseif input_service:get("navigate_left_continuous") then
		input_direction = DIRECTION.LEFT
	elseif input_service:get("navigate_right_continuous") then
		input_direction = DIRECTION.RIGHT
	end

	if input_direction then
		local widget, grid_index

		if selected_widget then
			widget, grid_index = self:_find_closest_widget_node_neighbour(selected_widget, input_direction)
		end

		if widget then
			self:_set_selected_grid_index(grid_index)
		elseif input_direction == DIRECTION.LEFT then
			local arrow = self._widgets_by_name.navigation_arrow_left

			if arrow.content.visible == true and not self._using_cursor_navigation then
				arrow.content.hotspot.pressed_callback()

				local index = self:_get_last_grid_panel_index()

				if index then
					self:_set_selected_grid_index(index)
				end
			end
		elseif input_direction == DIRECTION.RIGHT then
			local arrow = self._widgets_by_name.navigation_arrow_right

			if arrow.content.visible == true and not self._using_cursor_navigation then
				arrow.content.hotspot.pressed_callback()

				local index = self:_get_first_grid_panel_index()

				if index then
					self:_set_selected_grid_index(index)
				end
			end
		end
	end
end

StoreView._set_selected_grid_index = function (self, index)
	local grid_widgets = self._grid_widgets

	for i = 1, #grid_widgets do
		local widget = grid_widgets[i]
		local selected = i == index

		widget.content.hotspot.is_focused = selected
		widget.content.hotspot.is_selected = selected
	end

	self._selected_grid_index = index
end

StoreView._find_closest_widget_node_neighbour = function (self, source_widget, direction)
	local closest_widget, closest_widget_index
	local config = source_widget.config
	local source_grid_position = config.grid_position
	local source_grid_size = config.grid_size
	local grid_settings = self._active_grid_settings
	local num_rows = grid_settings.rows
	local num_columns = grid_settings.columns

	if direction == DIRECTION.UP then
		local start_column = source_grid_position[1] + math.ceil(source_grid_size[1] * 0.5) - 1
		local start_row = source_grid_position[2]

		if start_row >= 1 then
			local closest_occupied_column_index_abs

			for row_index = start_row - 1, 1, -1 do
				for column_index = 1, num_columns do
					local widget, widget_index = self:_find_widget_by_grid_cell(row_index, column_index)

					if widget and (not closest_widget or closest_occupied_column_index_abs >= math.abs(start_column - column_index)) then
						closest_occupied_column_index_abs = math.abs(start_column - column_index)
						closest_widget = widget
						closest_widget_index = widget_index
					end
				end

				if closest_widget then
					break
				end
			end
		end
	elseif direction == DIRECTION.DOWN then
		local start_column = source_grid_position[1] + math.ceil(source_grid_size[1] * 0.5) - 1
		local start_row = source_grid_position[2] + source_grid_size[2]

		if start_row <= num_rows then
			local closest_occupied_column_index_abs

			for row_index = start_row, num_rows do
				for column_index = 1, num_columns do
					local widget, widget_index = self:_find_widget_by_grid_cell(row_index, column_index)

					if widget and (not closest_widget or closest_occupied_column_index_abs >= math.abs(start_column - column_index)) then
						closest_occupied_column_index_abs = math.abs(start_column - column_index)
						closest_widget = widget
						closest_widget_index = widget_index
					end
				end

				if closest_widget then
					break
				end
			end
		end
	elseif direction == DIRECTION.LEFT then
		local start_column = source_grid_position[1]
		local start_row = source_grid_position[2]

		if start_column >= 1 then
			local closest_occupied_row_index_abs

			for column_index = start_column - 1, 1, -1 do
				for row_index = 1, num_rows do
					local widget, widget_index = self:_find_widget_by_grid_cell(row_index, column_index)

					if widget and (not closest_widget or closest_occupied_row_index_abs >= math.abs(start_row - row_index)) then
						closest_occupied_row_index_abs = math.abs(start_row - row_index)
						closest_widget = widget
						closest_widget_index = widget_index
					end
				end

				if closest_widget then
					break
				end
			end
		end
	elseif direction == DIRECTION.RIGHT then
		local start_column = source_grid_position[1] + source_grid_size[1]
		local start_row = source_grid_position[2]

		if start_column <= num_columns then
			local closest_occupied_row_index_abs

			for column_index = start_column, num_columns do
				for row_index = 1, num_rows do
					local widget, widget_index = self:_find_widget_by_grid_cell(row_index, column_index)

					if widget and (not closest_widget or closest_occupied_row_index_abs >= math.abs(start_row - row_index)) then
						closest_occupied_row_index_abs = math.abs(start_row - row_index)
						closest_widget = widget
						closest_widget_index = widget_index
					end
				end

				if closest_widget then
					break
				end
			end
		end
	end

	if closest_widget then
		return closest_widget, closest_widget_index
	end
end

StoreView._generate_nine_grid_nodes = function (self, size, position)
	local nodes = {
		{
			{
				0,
				0,
			},
			{
				size[1] * 0.5,
				0,
			},
			{
				size[1],
				0,
			},
		},
		{
			{
				0,
				size[2] * 0.5,
			},
			{
				size[1] * 0.5,
				size[2] * 0.5,
			},
			{
				size[1],
				size[2] * 0.5,
			},
		},
		{
			{
				0,
				size[2],
			},
			{
				size[1] * 0.5,
				size[2],
			},
			{
				size[1],
				size[2],
			},
		},
	}

	for r = 1, #nodes do
		local row = nodes[r]

		for c = 1, #row do
			local column = row[c]

			column[1] = column[1] + position[1]
			column[2] = column[2] + position[2]
		end
	end

	return nodes
end

StoreView.can_handle_input = function (self)
	return true
end

StoreView._draw_grid = function (self, dt, t, input_service)
	local widgets = self._grid_widgets

	if not widgets or self:_is_animation_active(self._on_enter_anim_id) then
		return
	end

	local widgets_by_name = self._widgets_by_name
	local interaction_widget = widgets_by_name.grid_interaction
	local is_grid_focused = not self._using_cursor_navigation or interaction_widget.content.hotspot.is_hover or false
	local render_settings = self._render_settings
	local ui_renderer = self._ui_renderer
	local ui_scenegraph = self._ui_scenegraph
	local focused_widget

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	if widgets then
		for i = 1, #widgets do
			local widget = widgets[i]
			local hotspot = widget.content.hotspot

			if hotspot then
				hotspot.force_disabled = not is_grid_focused

				if not focused_widget and hotspot.is_hover or hotspot.is_focused then
					focused_widget = widget
				end
			end

			UIWidget.draw(widget, ui_renderer)
		end
	end

	UIRenderer.end_pass(ui_renderer)

	if focused_widget and focused_widget ~= self._focused_widget then
		self._focused_widget = focused_widget

		if self._shine_animation_id and self:_is_animation_active(self._shine_animation_id) then
			self:_complete_animation(self._shine_animation_id)

			self._shine_animation_id = nil
		end

		self._shine_animation_id = self:_start_animation("on_hover", self._widgets_by_name, {
			widget = focused_widget,
		})
	elseif not focused_widget and self._focused_widget then
		self._focused_widget = nil
	end
end

StoreView.draw = function (self, dt, t, input_service, layer)
	if not self:can_handle_input() or self._show_loading then
		input_service = input_service:null_service()
	end

	local render_settings = self._render_settings

	render_settings.alpha_multiplier = self._alpha_multiplier or 0

	self:_draw_grid(dt, t, input_service)
	StoreView.super.draw(self, dt, t, input_service, layer)

	local ui_renderer = self._ui_renderer

	if DEBUG_GRID then
		self:_debug_draw_grid(dt, t, ui_renderer)
	end

	local render_settings = self._render_settings
	local ui_renderer = self._ui_renderer
	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	local wallet_widgets = self._wallet_widgets

	if wallet_widgets then
		for i = 1, #wallet_widgets do
			local widget = wallet_widgets[i]

			UIWidget.draw(widget, self._ui_renderer)
		end
	end

	UIRenderer.end_pass(ui_renderer)

	if self._wallet_element then
		self._wallet_element:draw(dt, t, ui_renderer, render_settings, input_service)
	end
end

StoreView._debug_generate_layout = function (self, grid_settings)
	if not grid_settings then
		return
	end

	local num_rows = grid_settings.rows
	local num_columns = grid_settings.columns
	local occupied_grid_cells = {}

	for i = 1, num_rows do
		occupied_grid_cells[i] = {}

		for j = 1, num_columns do
			occupied_grid_cells[i][j] = false
		end
	end

	local layout = {}
	local row_index = 1

	while row_index <= num_rows do
		local column_index = 1

		while column_index <= num_columns do
			local max_width

			for k = column_index, num_columns do
				if occupied_grid_cells[row_index][k] then
					break
				else
					max_width = k - column_index + 1
				end
			end

			local max_height

			if max_width then
				for k = row_index, num_rows do
					for j = column_index, column_index + max_width do
						if occupied_grid_cells[k][j] then
							break
						end

						if j == column_index + max_width then
							max_height = k - row_index + 1
						end
					end
				end
			end

			if max_width and max_height then
				local random_cell_count_width = math.random(1, max_width)
				local random_cell_count_height = math.random(1, max_height)
				local index = #layout + 1
				local entry = {
					widget_type = "button",
					index = index,
					display_name = "entry_" .. #layout + 1,
					grid_position = {
						column_index,
						row_index,
					},
					grid_size = {
						random_cell_count_width,
						random_cell_count_height,
					},
					size_scale = {
						random_cell_count_width / num_columns,
						random_cell_count_height / num_rows,
					},
					position_scale = {
						(column_index - 1) / num_columns,
						(row_index - 1) / num_rows,
					},
				}

				layout[#layout + 1] = entry

				for i = row_index, row_index + random_cell_count_height - 1 do
					for j = column_index, column_index + random_cell_count_width - 1 do
						occupied_grid_cells[i][j] = entry
					end
				end

				column_index = column_index + random_cell_count_width
			else
				column_index = column_index + 1
			end
		end

		row_index = row_index + 1
	end

	return layout
end

StoreView._debug_draw_grid = function (self, dt, t, ui_renderer)
	if not ui_renderer then
		return
	end

	local grid_settings = self._active_grid_settings

	if not grid_settings then
		return
	end

	local size = grid_settings.size
	local start_offset = grid_settings.start_offset
	local num_rows = grid_settings.rows
	local num_columns = grid_settings.columns
	local cell_size = grid_settings.cell_size
	local scale = RESOLUTION_LOOKUP.scale
	local inverse_scale = RESOLUTION_LOOKUP.inverse_scale

	ui_renderer.scale = scale
	ui_renderer.inverse_scale = inverse_scale

	local draw_layer = 998
	local line_thickness = 1
	local grid_cell_width = cell_size[1]
	local grid_cell_height = cell_size[2]
	local line_color_table = {
		80,
		255,
		255,
		255,
	}

	for i = 1, num_rows + 1 do
		local x = start_offset[1]
		local y = start_offset[2] + ((i - 1) * grid_cell_height - line_thickness)
		local position = Vector3(x * inverse_scale, y * inverse_scale, draw_layer)
		local rect_size = Vector2(size[1] * inverse_scale, line_thickness)

		UIRenderer.draw_rect(ui_renderer, position, rect_size, line_color_table)
	end

	for i = 1, num_columns + 1 do
		local x = start_offset[1] + (i - 1) * grid_cell_width
		local y = start_offset[2]
		local position = Vector3(x * inverse_scale, y * inverse_scale, draw_layer)
		local rect_size = Vector2(line_thickness, size[2] * inverse_scale)

		UIRenderer.draw_rect(ui_renderer, position, rect_size, line_color_table)
	end

	ui_renderer.scale = nil
	ui_renderer.inverse_scale = nil
end

StoreView._update_wallets = function (self)
	if self._wallet_element then
		self._wallet_promise = self._wallet_element:update_wallets():next(function ()
			self._wallet_promise = nil
		end):catch(function (error)
			self._wallet_promise = nil
		end)

		return self._wallet_promise
	end

	return Promise:resolved()
end

StoreView._can_afford = function (self, store_item)
	local cost = store_item.price.amount.amount
	local currency = store_item.price.amount.type
	local can_afford = cost <= self._wallet_element:get_amount_by_currency(currency)

	return can_afford
end

StoreView.on_resolution_modified = function (self, scale)
	StoreView.super.on_resolution_modified(self, scale)
	self:_update_panel_positions()
end

StoreView._update_vo = function (self, dt, t)
	if self._hub_interaction then
		local queued_vo_event_request = self._queued_vo_event_request

		if queued_vo_event_request then
			local delay = queued_vo_event_request.delay

			if delay <= 0 then
				local events = queued_vo_event_request.events
				local voice_profile = queued_vo_event_request.voice_profile
				local optional_route_key = queued_vo_event_request.optional_route_key
				local is_opinion_vo = queued_vo_event_request.is_opinion_vo
				local world_spawner = self._world_spawner
				local dialogue_system = world_spawner and self:dialogue_system()

				if dialogue_system then
					self:play_vo_events(events, voice_profile, optional_route_key, nil, is_opinion_vo)

					self._queued_vo_event_request = nil
				else
					self._queued_vo_event_request = nil
				end
			else
				queued_vo_event_request.delay = delay - dt
			end
		end

		local current_vo_id = self._current_vo_id

		if not current_vo_id then
			return
		end

		local unit = self._vo_unit
		local dialogue_extension = ScriptUnit.extension(unit, "dialogue_system")
		local is_playing = dialogue_extension:is_playing(current_vo_id)

		if not is_playing then
			self._current_vo_id = nil
			self._current_vo_event = nil
		end
	end
end

StoreView.dialogue_system = function (self)
	local world_spawner = self._world_spawner
	local world = world_spawner and world_spawner:world()
	local extension_manager = world and Managers.ui:world_extension_manager(world)
	local dialogue_system = extension_manager and extension_manager:system_by_extension("DialogueExtension")

	return dialogue_system
end

StoreView._cb_on_play_vo = function (self, id, event_name)
	self._current_vo_event = event_name
	self._current_vo_id = id
end

StoreView.play_vo_events = function (self, events, voice_profile, optional_route_key, optional_delay, is_opinion_vo)
	local dialogue_system = self:dialogue_system()

	if optional_delay then
		self._queued_vo_event_request = {
			events = events,
			voice_profile = voice_profile,
			optional_route_key = optional_route_key,
			delay = optional_delay,
			is_opinion_vo = is_opinion_vo,
		}
	else
		local wwise_route_key = optional_route_key or 40
		local callback = self._vo_callback
		local vo_unit = Vo.play_local_vo_events(dialogue_system, events, voice_profile, wwise_route_key, callback, nil, is_opinion_vo)

		self._vo_unit = vo_unit
	end
end

return StoreView
