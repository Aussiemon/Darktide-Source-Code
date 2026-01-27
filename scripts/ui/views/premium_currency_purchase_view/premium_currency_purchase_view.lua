-- chunkname: @scripts/ui/views/premium_currency_purchase_view/premium_currency_purchase_view.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local LoadingStateData = require("scripts/ui/loading_state_data")
local MasterItems = require("scripts/backend/master_items")
local PremiumCurrencyPurchaseViewContentBlueprints = require("scripts/ui/views/premium_currency_purchase_view/premium_currency_purchase_view_content_blueprints")
local PremiumCurrencyPurchaseViewDefinitions = require("scripts/ui/views/premium_currency_purchase_view/premium_currency_purchase_view_definitions")
local PremiumCurrencyPurchaseViewSettings = require("scripts/ui/views/premium_currency_purchase_view/premium_currency_purchase_view_settings")
local Promise = require("scripts/foundation/utilities/promise")
local PromiseContainer = require("scripts/utilities/ui/promise_container")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementWallet = require("scripts/ui/view_elements/view_element_wallet/view_element_wallet")
local AQUILA_STORE_LAYOUT = {
	display_name = "loc_premium_store_category_title_currency",
	storefront = "hard_currency_store",
	template = ButtonPassTemplates.default_button,
}
local PremiumCurrencyPurchaseView = class("PremiumCurrencyPurchaseView", "BaseView")

PremiumCurrencyPurchaseView.FILTER_OWNED = function (offer)
	if offer.isOwned == nil then
		return true
	end

	if offer.isOwned.is_promise then
		return not offer.isOwned.value.is_owner
	end

	return not not offer.isOwned
end

PremiumCurrencyPurchaseView.FILTER_CURRENCY_REQUIRED = function (money_required)
	return function (offer)
		if money_required == nil then
			return true
		end

		return offer.value.amount >= money_required
	end
end

PremiumCurrencyPurchaseView.open = function (callback_on_close, currency_required, item_name)
	local filters = {
		PremiumCurrencyPurchaseView.FILTER_OWNED,
	}

	if currency_required then
		filters[#filters + 1] = PremiumCurrencyPurchaseView.FILTER_CURRENCY_REQUIRED(currency_required)
	end

	local context = {
		callback_on_close = callback_on_close,
		filters = filters,
		currency_required = currency_required,
		item_name = item_name,
	}

	Managers.ui:open_view("premium_currency_purchase_view", nil, false, nil, nil, context, nil)
end

PremiumCurrencyPurchaseView.init = function (self, settings, context)
	self._context = context or {}
	self._storefront_request_id = 1
	self._promise_container = PromiseContainer:new()

	PremiumCurrencyPurchaseView.super.init(self, PremiumCurrencyPurchaseViewDefinitions, settings, context)

	self._pass_draw = context.pass_draw == nil and true or context.pass_draw
	self._wallet_type = {
		"aquilas",
	}

	if IS_PLAYSTATION then
		self._ps_store_icon_showing = false
	end
end

PremiumCurrencyPurchaseView.on_enter = function (self)
	PremiumCurrencyPurchaseView.super.on_enter(self)

	self._account_items = {}
	self._url_textures = {}
	self._success = false

	self:_setup_input_legend()

	local on_complete_callback = callback(self, "setup_aquila_store")

	self:_fetch_storefront(AQUILA_STORE_LAYOUT.storefront, on_complete_callback)

	self._wallet_element = self:_add_element(ViewElementWallet, "wallet_element", 100)

	self:_update_element_position("wallet_element_pivot", self._wallet_element, true)
	self._wallet_element:generate_currencies(self._wallet_type, {
		nil,
		30,
	})
end

PremiumCurrencyPurchaseView._on_navigation_input_changed = function (self)
	if self._using_cursor_navigation then
		if self._aquila_open then
			self:_select_aquila_widget_by_slot_index()
		end

		return
	end

	if self._aquila_open and not self._selected_aquila_slot_index then
		self:_select_first_aquila_button()
	end
end

PremiumCurrencyPurchaseView._update_account_items = function (self)
	return Managers.data_service.gear:fetch_inventory():next(function (items)
		self._account_items = items
	end)
end

PremiumCurrencyPurchaseView.setup_aquila_store = function (self)
	self._selected_page_index = 1

	self:_set_telemetry_name("aquilas")
	self:_start_animation("grid_entry", self._aquilas_widgets, self)

	if not self._using_cursor_navigation then
		self:_select_first_aquila_button()
	end

	self._aquila_open = true
end

PremiumCurrencyPurchaseView.cb_on_back_pressed = function (self)
	self._aquila_open = false

	self:_destroy_aquilas_presentation()

	local view_name = self.view_name

	Managers.ui:close_view(view_name)
	self:_play_sound(UISoundEvents.default_menu_exit)
end

PremiumCurrencyPurchaseView._clear_telemetry_name = function (self)
	local telemetry_name = self._telemetry_name

	if telemetry_name then
		Managers.telemetry_events:close_view(telemetry_name)

		self._telemetry_name = nil
	end
end

PremiumCurrencyPurchaseView._set_telemetry_name = function (self, category, page)
	self:_clear_telemetry_name()

	page = page or 1

	local telemetry_name = string.format("%s_store_%d_view", category, page)

	self._telemetry_name = telemetry_name

	Managers.telemetry_events:open_view(telemetry_name, self._hub_interaction)
end

local function _merge_offers_and_platform_offers(offers, platform_offers)
	if not platform_offers then
		return offers
	end

	local merged = table.shallow_copy_array(offers)

	for i = 1, #platform_offers do
		local platform_offer = platform_offers[i]
		local aquilas_amount = 0

		for j = 1, #platform_offer.content do
			local content = platform_offer.content[j]

			if content.rewardType == "currency" and content.amount.type == "aquilas" then
				aquilas_amount = math.max(aquilas_amount, content.amount.amount)
			end
		end

		platform_offer.value = {
			type = "platform_offer",
			amount = aquilas_amount,
		}

		table.insert(merged, platform_offer)
	end

	return merged
end

local function _separate_golden_offer(offers)
	local golden_offer
	local filtered_offers = {}

	for i = 1, #offers do
		local offer = offers[i]
		local presentation_style = offer.clean_offer.metadata.presentationStyle
		local is_golden = presentation_style == "special_offer_2" or offer.value.type == "platform_offer"

		if is_golden then
			golden_offer = offer
			golden_offer.clean_offer.is_golden = true
		else
			table.insert(filtered_offers, offer)
		end
	end

	return filtered_offers, golden_offer
end

PremiumCurrencyPurchaseView._fill_layout_with_offers = function (self, offers, platform_offers)
	self:_unload_url_textures()

	offers = _merge_offers_and_platform_offers(offers, platform_offers)

	if not offers then
		return Promise.rejected("no offers found")
	end

	local filters = self._context.filters

	filters = filters or {
		self.FILTER_OWNED,
	}

	return self:_filter_aquila_offers(offers, filters):next(function (filtered_offers)
		local texture_promises = {}

		for i = 1, #filtered_offers do
			table.insert(texture_promises, self:_load_offer_images(filtered_offers[i]))
		end

		return Promise.all(unpack(texture_promises)):next(function ()
			local offer_list_no_golden, golden_offer = _separate_golden_offer(filtered_offers)

			return self:_create_aquilas_presentation(offer_list_no_golden, golden_offer)
		end)
	end, function (error)
		self._success = false

		self:cb_on_back_pressed()
	end)
end

PremiumCurrencyPurchaseView._load_offer_images = function (self, offer)
	local media_url = offer.mediaUrl

	if media_url then
		local url_textures = self._url_textures

		url_textures[#url_textures + 1] = media_url

		return self._promise_container:cancel_on_destroy(Managers.url_loader:load_texture(media_url, nil, "premium_currency_purchase_view"):next(function (data)
			offer.texture_data = {
				main = data,
			}
		end))
	end

	if offer.media then
		local texture_promises = {}

		for url_idx = 1, #offer.media do
			local media = offer.media[url_idx]
			local url_textures = self._url_textures

			url_textures[#url_textures + 1] = media.url

			local texture_promise = self._promise_container:cancel_on_destroy(Managers.url_loader:load_texture(media.url, nil, "premium_currency_purchase_view"):next(function (data)
				return {
					media = media,
					data = data,
				}
			end))

			table.insert(texture_promises, texture_promise)
		end

		return Promise.all(unpack(texture_promises)):next(function (media_textures)
			local texture_data = {}

			for i = 1, #media_textures do
				local media_texture = media_textures[i]

				if media_texture.media.mediaType == "icon" or media_texture.media.mediaType == "text" then
					texture_data[media_texture.media.mediaType] = media_texture.data
				else
					texture_data.main = media_texture.data
				end
			end

			offer.texture_data = texture_data
		end)
	end
end

PremiumCurrencyPurchaseView._filter_aquila_offers = function (self, offers, filters)
	local promises = {}

	for idx, offer in ipairs(offers) do
		if offer.isOwned and offer.isOwned.is_promise then
			table.insert(promises, offer.isOwned)
		end
	end

	return Promise.all(unpack(promises)):next(function (_)
		for _, filter in ipairs(filters) do
			local filtered = table.filter_array(offers, filter)

			if #filtered == 0 then
				Log.warning("PremiumCurrencyPurchaseView", "filter would remove all possible offers, reverting filter")

				filtered = offers
			end

			offers = filtered
		end

		return self:_preprocess_offers(offers)
	end)
end

PremiumCurrencyPurchaseView._preprocess_offers = function (self, offers)
	local best_offer_idx = -1
	local best_offer_per_currency = -1
	local clean_offers = {}

	for offerIdx = 1, #offers do
		local offer = offers[offerIdx]

		if offer.clean_offer then
			table.insert(clean_offers, offer)

			offer.clean_offer.media_count = offer.mediaUrl and 1 or offer.media and #offer.media or 1

			local bonus_aquila = offer.bonus or 0
			local total_aquila = bonus_aquila + offer.value.amount
			local offer_price = offer.clean_offer.discount_price and offer.clean_offer.discount_price or offer.clean_offer.base_price
			local offer_per_currency = total_aquila / offer_price

			if not best_offer_idx then
				best_offer_idx = offerIdx
				best_offer_per_currency = offer_per_currency
			elseif best_offer_per_currency < offer_per_currency then
				best_offer_idx = #clean_offers
				best_offer_per_currency = offer_per_currency
			end
		end
	end

	clean_offers[best_offer_idx].is_best_offer = true

	return clean_offers
end

PremiumCurrencyPurchaseView._get_platform = function ()
	local authenticate_method = Managers.backend:get_auth_method()

	if authenticate_method == Managers.backend.AUTH_METHOD_STEAM and HAS_STEAM then
		return "steam"
	elseif authenticate_method == Managers.backend.AUTH_METHOD_XBOXLIVE and PLATFORM == "win32" then
		return "microsoft"
	elseif authenticate_method == Managers.backend.AUTH_METHOD_XBOXLIVE and Application.xbox_live and Application.xbox_live() == true then
		return "microsoft"
	elseif authenticate_method == Managers.backend.AUTH_METHOD_PSN then
		return "psn"
	end

	return "steam"
end

PremiumCurrencyPurchaseView._create_aquilas_presentation = function (self, offers, golden_offer)
	self:_destroy_aquilas_presentation()

	local scenegraph_id = "grid_aquilas_content"
	local widgets = {}
	local size_addition = {
		20,
		20,
	}
	local spacing = {
		20,
		25,
	}
	local large_size = {
		260,
		350,
	}
	local small_size = {
		260,
		250,
	}
	local medium_size = {
		260,
		300,
	}
	local golden_offer_size = {
		350,
		350,
	}
	local size_per_row = {}
	local bonus_offer_count = 0
	local valid_offers = #offers
	local non_bonus_offer_count = 0
	local golden_element_first_row_positional_offset = {
		-golden_offer_size[1] / 4,
		-5,
	}
	local global_x_offset = 0

	for offerIdx = 1, #offers do
		local offer = offers[offerIdx]
		local bonus_aquila = offer.bonus or 0
		local presentation_style = offer.clean_offer.metadata.presentationStyle
		local is_large = bonus_aquila and bonus_aquila > 0 and offer.value.type == "aquilas" or presentation_style == "special_offer_2" or offer.value.type == "platform_offer"

		offer.clean_offer.is_large = is_large
		offer.clean_offer.is_golden = presentation_style == "special_offer_2" or offer.value.type == "platform_offer"

		if is_large then
			bonus_offer_count = bonus_offer_count + offer.clean_offer.media_count
		else
			non_bonus_offer_count = non_bonus_offer_count + offer.clean_offer.media_count
		end
	end

	local canvas_width = self._ui_scenegraph.canvas.size[1]
	local max_allowed_large_per_row = math.floor(canvas_width / (large_size[1] + spacing[1]))

	if max_allowed_large_per_row > #offers and non_bonus_offer_count == 0 and golden_offer then
		bonus_offer_count = bonus_offer_count + golden_offer.clean_offer.media_count
		golden_offer.clean_offer.is_large = true
		golden_offer.clean_offer.is_golden = true
		global_x_offset = 100

		table.insert(offers, golden_offer)

		golden_offer = nil
	end

	local max_allowed_small_per_row = math.floor(canvas_width / (small_size[1] + spacing[1]))
	local max_allowed_medium_per_row = math.floor(canvas_width / (medium_size[1] + spacing[1]))
	local large_needed_rows = math.ceil(bonus_offer_count / max_allowed_large_per_row)
	local small_needed_rows = math.ceil(non_bonus_offer_count / max_allowed_small_per_row)
	local use_same_size_on_all_offers = large_needed_rows > 1 or small_needed_rows > 1

	table.sort(offers, function (a, b)
		if a.clean_offer.is_large and not b.clean_offer.is_large then
			return true
		end

		if not a.clean_offer.is_large and b.clean_offer.is_large then
			return false
		end

		if a.clean_offer.is_large and b.clean_offer.is_large then
			if a.clean_offer.is_golden and not b.clean_offer.is_golden then
				return false
			end

			if not a.clean_offer.is_golden and b.clean_offer.is_golden then
				return true
			end
		end

		return a.value.amount > b.value.amount
	end)

	local widgets_by_slot_index = {}
	local slots_per_row = {}
	local total_slots = 0
	local i = 0

	for offerIdx = 1, #offers do
		local offer = offers[offerIdx]
		local element = {}

		i = i + 1
		element.formatted_price = offer.clean_offer.formatted_price
		element.title = offer.value.amount

		local description = ""
		local bonus_aquila = offer.bonus or 0

		if bonus_aquila and bonus_aquila > 0 then
			local aquilas = offer.value.amount
			local aquila_minus_bonus = aquilas - bonus_aquila
			local bonus_text = Localize("loc_premium_store_credits_bonus", true, {
				amount = bonus_aquila,
			})

			description = string.format("%d\n%s", aquila_minus_bonus, bonus_text)
		end

		element.description = description
		element.offer = offer
		element.item_types = {
			"currency",
		}

		local size, max_allowed_items_per_row, total_elements_in_row
		local column_count = offer.clean_offer.media_count

		if use_same_size_on_all_offers then
			size = medium_size
			max_allowed_items_per_row = max_allowed_medium_per_row
		elseif offer.clean_offer.is_large then
			size = large_size
			max_allowed_items_per_row = max_allowed_large_per_row
			total_elements_in_row = bonus_offer_count
		else
			size = small_size
			max_allowed_items_per_row = max_allowed_small_per_row
			total_elements_in_row = non_bonus_offer_count
		end

		size = offer.clean_offer.is_golden and golden_offer_size or size
		size[1] = size[1] * offer.clean_offer.media_count + 20 * (offer.clean_offer.media_count - 1)
		max_allowed_items_per_row = max_allowed_items_per_row - (offer.clean_offer.media_count > 1 and offer.clean_offer.media_count or 0)

		local blueprint = PremiumCurrencyPurchaseViewContentBlueprints.create_blueprint(size, offer.texture_data, element.description ~= "", offer.clean_offer.is_golden)
		local widget_definition = UIWidget.create_definition(blueprint.pass_template, scenegraph_id, nil, size)
		local name = "currency_widget_" .. i
		local widget = self:_create_widget(name, widget_definition)

		widget.type = "aquila_button"

		local row = not use_same_size_on_all_offers and (offer.clean_offer.is_large and 1 or 2) or math.ceil(i / max_allowed_items_per_row)
		local start_row = not use_same_size_on_all_offers and (row == 1 and 0 or bonus_offer_count) or (row - 1) * max_allowed_items_per_row

		total_elements_in_row = total_elements_in_row or row == 1 and max_allowed_items_per_row or valid_offers - max_allowed_items_per_row

		local end_row = start_row + total_elements_in_row
		local element_offset = i - 1
		local element_position = end_row - element_offset - column_count

		widget.row = row
		widget.content.is_best_offer = offer.is_best_offer
		widget.content.formatted_original_price = offer.clean_offer.formatted_original_price and string.format("{#strike(true)}%s{#strike(false)}", offer.clean_offer.formatted_original_price)
		widget.content.formatted_price = offer.clean_offer.formatted_price
		size_per_row[row] = size_per_row[row] or {}
		size_per_row[row][1] = (size_per_row[row][1] or 0) + size[1] + spacing[1]
		size_per_row[row][2] = math.max(size_per_row[row][2] or 0, size[2])
		widget.offset = {
			element_position * (size[1] + spacing[1]) + global_x_offset,
			0,
			0,
		}

		if offer.clean_offer.is_golden and row == 1 then
			widget.offset[1] = widget.offset[1] + golden_element_first_row_positional_offset[1]
			widget.offset[2] = widget.offset[2] + golden_element_first_row_positional_offset[2]
		end

		local init = blueprint.init

		if init then
			init(self, widget, element, "cb_on_grid_entry_left_pressed")
		end

		widgets[i] = widget
		widget.slot_indices = {}

		for slot_idx = i, i + (column_count - 1) do
			if slots_per_row[row] == nil then
				slots_per_row[row] = {}
			end

			table.insert(slots_per_row[row], slot_idx)

			widgets_by_slot_index[slot_idx] = widget
			total_slots = total_slots + 1

			table.insert(widget.slot_indices, slot_idx)
		end
	end

	local needed_rows = #size_per_row
	local total_width = 0
	local total_height = (needed_rows - 1) * spacing[2]

	for jj = 1, needed_rows do
		total_width = math.max(total_width, size_per_row[jj][1] - spacing[1])
		total_height = total_height + size_per_row[jj][2]
	end

	for jj = 1, #widgets do
		local widget = widgets[jj]
		local row = widget.row - 1
		local offset_height_value = 0
		local row_width_value = size_per_row[widget.row][1]

		if row > 0 then
			for ff = 1, row do
				offset_height_value = offset_height_value + size_per_row[ff][2]
			end
		end

		widget.offset[1] = widget.offset[1] + (total_width - row_width_value) * 0.5
		widget.offset[2] = widget.offset[2] + offset_height_value + PremiumCurrencyPurchaseViewSettings.row_separation_height * row
	end

	self:_set_scenegraph_size(scenegraph_id, total_width, total_height)

	local aquilas_frame_element_vertical_margin = 40
	local min_aquilas_frame_element_height = 0
	local screen_size = self:_scenegraph_size("screen")

	self:_set_scenegraph_size("aquilas_background", screen_size, math.max(min_aquilas_frame_element_height, total_height + aquilas_frame_element_vertical_margin + size_addition[2] * needed_rows))

	self._aquilas_widgets = widgets

	if golden_offer then
		i = i + 1

		local element = {}

		element.formatted_price = golden_offer.clean_offer.formatted_price
		element.title = golden_offer.value.amount
		element.description = ""
		element.offer = golden_offer
		element.item_types = {
			"currency",
		}

		local blueprint = PremiumCurrencyPurchaseViewContentBlueprints.create_blueprint(golden_offer_size, golden_offer.texture_data, element.description ~= "", true)
		local widget_definition = UIWidget.create_definition(blueprint.pass_template, "special_offer_pivot", nil, golden_offer_size)
		local name = "currency_widget_golden"
		local widget = self:_create_widget(name, widget_definition)

		widget.type = "aquila_button"
		self._golden_widget = widget
		widget.content.formatted_original_price = golden_offer.clean_offer.formatted_original_price and string.format("{#strike(true)}%s{#strike(false)}", golden_offer.clean_offer.formatted_original_price)
		widget.content.formatted_price = golden_offer.clean_offer.formatted_price

		local row = 3

		widget.row = row

		local init = blueprint.init

		if init then
			init(self, widget, element, "cb_on_grid_entry_left_pressed")
		end

		widget.slot_indices = {}

		for slot_idx = i, i + (golden_offer.clean_offer.media_count - 1) do
			if slots_per_row[row] == nil then
				slots_per_row[row] = {}
			end

			table.insert(slots_per_row[row], slot_idx)

			widgets_by_slot_index[slot_idx] = widget
			total_slots = total_slots + 1

			table.insert(widget.slot_indices, slot_idx)
		end

		needed_rows = needed_rows + 1
	end

	self._aquilas_navigation_data = {
		widgets_by_slot_index = widgets_by_slot_index,
		slots_per_row = slots_per_row,
		total_slots = total_slots,
		num_rows = needed_rows,
	}

	if not self._using_cursor_navigation then
		self:_select_first_aquila_button()
	end

	self._widgets_by_name.aquilas_background.content.visible = true
	self._widgets_by_name.page_title_text.content.visible = true

	if IS_PLAYSTATION then
		local POSITION = {
			CENTER = 0,
			LEFT = 1,
			RIGHT = 2,
		}

		if not self._ps_store_icon_showing then
			NpCommerceDialog.show_ps_store_icon(POSITION.RIGHT)

			self._ps_store_icon_showing = true
		end
	end

	if self._context.currency_required then
		self._widgets_by_name.required_aquilas_text.content.visible = true
		self._widgets_by_name.required_aquilas_text.content.text = string.format("%s ", Localize("loc_premium_store_required_credits", true, {
			offer = self._context.item_name,
			value = self._context.currency_required,
		}))
	end
end

PremiumCurrencyPurchaseView._destroy_aquilas_presentation = function (self)
	if self._aquilas_widgets then
		for i = 1, #self._aquilas_widgets do
			local widget = self._aquilas_widgets[i]
			local widget_name = widget.name

			self:_unregister_widget_name(widget_name)
		end

		self._aquilas_widgets = nil
	end

	self._widgets_by_name.aquilas_background.content.visible = false
	self._widgets_by_name.page_title_text.content.visible = false

	if IS_PLAYSTATION and self._ps_store_icon_showing then
		NpCommerceDialog.hide_ps_store_icon()

		self._ps_store_icon_showing = false
	end
end

PremiumCurrencyPurchaseView._fetch_storefront = function (self, storefront, on_complete_callback)
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

	return self._store_promise:next(function (data)
		if self._destroyed then
			return
		end

		self._store_promise = self:_fill_layout_with_offers(data.offers, data.platform_offers):next(function (elements)
			if self._destroyed or not self._store_promise then
				return
			end

			self._store_promise = nil

			if on_complete_callback then
				on_complete_callback()
			end
		end):catch(function (elements)
			if self._destroyed or not self._store_promise then
				return
			end

			self._store_promise = nil

			if on_complete_callback then
				on_complete_callback()
			end
		end)

		return self._store_promise
	end):catch(function (error)
		self._store_promise = nil

		self:cb_on_back_pressed()
	end)
end

PremiumCurrencyPurchaseView.can_exit = function (self)
	return self._can_exit
end

PremiumCurrencyPurchaseView.on_exit = function (self)
	self:_clear_telemetry_name()

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

	self:_unload_url_textures()
	self:_play_sound(UISoundEvents.default_menu_exit)
	PremiumCurrencyPurchaseView.super.on_exit(self)
end

PremiumCurrencyPurchaseView.destroy = function (self)
	if self._context.callback_on_close then
		self._context.callback_on_close(self._success)
	end

	self._promise_container:delete()
	PremiumCurrencyPurchaseView.super.destroy(self)
end

PremiumCurrencyPurchaseView._unload_url_textures = function (self)
	local url_textures = self._url_textures
	local url_texture_count = url_textures and #url_textures or 0

	for i = 1, url_texture_count do
		local url = url_textures[i]

		Managers.url_loader:unload_texture(url)
	end

	self._url_textures = {}
end

PremiumCurrencyPurchaseView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 10)

	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

PremiumCurrencyPurchaseView._is_golden_widget_focused = function (self)
	if not self._golden_widget then
		return false
	end

	return self._golden_widget.content.hotspot.is_focused
end

PremiumCurrencyPurchaseView._handle_input = function (self, input_service)
	local using_cursor = self._using_cursor_navigation

	if using_cursor then
		return
	end

	local new_selection_index, new_selection_row

	if input_service:get("navigate_up_continuous") and self._selected_aquila_row then
		if self:_is_golden_widget_focused() then
			new_selection_index = #self._aquilas_navigation_data.slots_per_row[1]
			new_selection_row = 1
		else
			new_selection_row = self._selected_aquila_row > 1 and "up"
		end
	elseif input_service:get("navigate_down_continuous") and self._selected_aquila_row then
		local first_row = self._aquilas_navigation_data.slots_per_row[1]

		if self._golden_widget and self._selected_aquila_row == 1 and self._selected_aquila_slot_index == first_row[#first_row] then
			new_selection_index = 1
			new_selection_row = self._golden_widget.row
		else
			new_selection_row = self._selected_aquila_row < (self._aquilas_navigation_data and self._aquilas_navigation_data.num_rows or self._selected_aquila_row) and "down"
		end
	elseif input_service:get("navigate_left_continuous") and self._selected_aquila_slot_index then
		local widget = self._aquilas_navigation_data.widgets_by_slot_index[self._selected_aquila_slot_index]
		local up_row = self._aquilas_navigation_data.slots_per_row[self._golden_widget and self._golden_widget.row - 1 or 1]

		if self._golden_widget and self._selected_aquila_row == 2 and self._selected_aquila_slot_index == up_row[#up_row] then
			new_selection_index = 1
			new_selection_row = self._golden_widget.row
		else
			local next_index = widget.slot_indices[#widget.slot_indices] + 1
			local row_slots = self._aquilas_navigation_data.slots_per_row[self._selected_aquila_row]

			new_selection_index = math.clamp(next_index, row_slots[1], row_slots[#row_slots])
		end
	elseif input_service:get("navigate_right_continuous") and self._selected_aquila_slot_index then
		if self:_is_golden_widget_focused() then
			local up_row = self._aquilas_navigation_data.slots_per_row[self._golden_widget and self._golden_widget.row - 1 or 1]

			new_selection_index = up_row[#up_row]
			new_selection_row = self._golden_widget.row - 1
		else
			local next_index = self._aquilas_navigation_data.widgets_by_slot_index[self._selected_aquila_slot_index].slot_indices[1] - 1
			local row_slots = self._aquilas_navigation_data.slots_per_row[self._selected_aquila_row]

			new_selection_index = math.clamp(next_index, row_slots[1], row_slots[#row_slots])
		end
	end

	if new_selection_index then
		if new_selection_row then
			self:_select_aquila_widget_by_slot_index(new_selection_index, new_selection_row)
		elseif self._aquilas_navigation_data.widgets_by_slot_index[new_selection_index].row == self._aquilas_navigation_data.widgets_by_slot_index[self._selected_aquila_slot_index].row then
			self:_select_aquila_widget_by_slot_index(new_selection_index, self._selected_aquila_row)
		end
	elseif new_selection_row then
		self:_select_aquila_widget_by_row(new_selection_row)
	end
end

PremiumCurrencyPurchaseView.update = function (self, dt, t, input_service)
	if not self:can_handle_input() then
		input_service = input_service:null_service()
	end

	if self._store_promise or self._purchase_promise then
		self._widgets_by_name.loading.content.visible = true

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

	self._widgets_by_name.aquilas_background.visible = not self._show_loading
	self._widgets_by_name.page_title_text.content.visible = not self._show_loading

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

	return PremiumCurrencyPurchaseView.super.update(self, dt, t, input_service)
end

PremiumCurrencyPurchaseView.cb_on_grid_entry_left_pressed = function (self, widget, element)
	if element.offer.clean_offer.is_platform_option then
		return self:_on_platform_widget_pressed(widget, element)
	end

	return self:_on_currency_widget_pressed(widget, element)
end

PremiumCurrencyPurchaseView._on_currency_widget_pressed = function (self, widget, element)
	if self._purchase_promise then
		return
	end

	Managers.telemetry_events:premium_currency_button_pressed(element.offer.id)

	self._purchase_promise = Managers.data_service.store:purchase_currency(element.offer):next(function (data)
		if self._destroyed or not self._purchase_promise then
			return
		end

		if data and data.body.state == "failed" then
			self._purchase_promise = nil

			return
		end

		self._success = true

		self:_play_sound(UISoundEvents.aquilas_vendor_purchase_aquilas)

		local currency = element.offer.value.type
		local amount = element.offer.value.amount

		Managers.event:trigger("event_add_notification_message", "currency", {
			currency = currency,
			amount = amount,
		})
		self:_update_wallets()
		Managers.event:trigger("event_stop_waiting")
		self:cb_on_back_pressed()

		self._purchase_promise = nil
	end):catch(function (error)
		self._purchase_promise = nil
		self._success = false

		local popup_context = {
			description_text = "loc_premium_currency_purchase_error_generic",
			title_text = "loc_popup_header_error",
			options = {
				{
					close_on_pressed = true,
					text = "loc_popup_button_confirm",
				},
			},
		}

		if error.player_message then
			popup_context.description_text = error.player_message
		end

		Managers.event:trigger("event_show_ui_popup", popup_context)
	end)
end

PremiumCurrencyPurchaseView._on_platform_widget_pressed = function (self, widget, element)
	Managers.telemetry_events:dlc_purchase_button_clicked(element.offer.id)

	self._purchase_promise = Managers.dlc:open_to_store(element.offer.clean_offer.product_id, callback(self, "_cb_platform_purchase_finished", element))
end

PremiumCurrencyPurchaseView._cb_platform_purchase_finished = function (self, element, is_success)
	if not is_success then
		self._purchase_promise = nil

		return
	end

	Managers.backend.interfaces.external_payment:reconcile_dlc({
		element.offer.clean_offer.product_id,
	}):next(function (response)
		local dlc_updates = response.dlcUpdates

		if not dlc_updates or #dlc_updates <= 0 then
			self._purchase_promise = nil

			return
		end

		self._purchase_promise = nil

		self:_trigger_platform_purchase_dlc_updates(dlc_updates)

		self._success = true

		self:_play_sound(UISoundEvents.aquilas_vendor_purchase_aquilas)
		Managers.backend.interfaces.external_payment:invalidate_cache()
		self:_update_wallets()
		self:cb_on_back_pressed()
	end, function (error)
		self._purchase_promise = nil
		self._success = false

		self:_update_wallets()
		self:cb_on_back_pressed()
	end)
end

PremiumCurrencyPurchaseView._trigger_platform_purchase_dlc_updates = function (self, dlc_updates)
	for i = 1, #dlc_updates do
		local dlc = dlc_updates[i]

		for j = 1, #dlc.rewards do
			local reward = dlc.rewards[j]

			if reward.rewardType == "currency" then
				self:_trigger_currency_notification(reward.currencyType, reward.amount)
				Managers.data_service.store:change_cached_wallet_balance(reward.currencyType, reward.amount, true, "PremiumCurrencyPurchaseView")
			elseif reward.rewardType == "item" then
				local master_id = reward.masterId

				self:_trigger_item_grant_notification(master_id)
			end
		end
	end
end

PremiumCurrencyPurchaseView._trigger_currency_notification = function (self, currency_type, amount)
	Managers.event:trigger("event_add_notification_message", "currency", {
		currency = currency_type,
		amount = amount,
	})
end

PremiumCurrencyPurchaseView._trigger_item_grant_notification = function (self, master_item_id)
	Managers.event:trigger("event_add_notification_message", "item_granted", MasterItems.get_item(master_item_id))
end

PremiumCurrencyPurchaseView.can_handle_input = function (self)
	if self._purchase_promise then
		return false
	end

	return self._on_enter_anim_id == nil or not self:_is_animation_active(self._on_enter_anim_id)
end

PremiumCurrencyPurchaseView.draw = function (self, dt, t, input_service, layer)
	if not self:can_handle_input() or self._show_loading then
		input_service = input_service:null_service()
	end

	PremiumCurrencyPurchaseView.super.draw(self, dt, t, input_service, layer)

	local render_settings = self._render_settings
	local ui_renderer = self._ui_renderer
	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	if self._aquilas_widgets then
		for i = 1, #self._aquilas_widgets do
			local widget = self._aquilas_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	if self._golden_widget then
		UIWidget.draw(self._golden_widget, ui_renderer)
	end

	UIRenderer.end_pass(ui_renderer)
end

PremiumCurrencyPurchaseView._select_aquila_widget_by_row = function (self, direction)
	if not self._aquilas_widgets then
		return
	end

	local new_selection_row

	if direction == "up" then
		new_selection_row = self._selected_aquila_row > 1 and self._selected_aquila_row - 1 or self._selected_aquila_row
	elseif direction == "down" then
		new_selection_row = self._selected_aquila_row < self._aquilas_navigation_data.num_rows and self._selected_aquila_row + 1 or self._selected_aquila_row
	end

	if new_selection_row then
		local next_slot_index = self._aquilas_navigation_data.widgets_by_slot_index[self._selected_aquila_slot_index].previous_selection_idx

		if next_slot_index == nil then
			local current_row_slots = self._aquilas_navigation_data.slots_per_row[self._selected_aquila_row]
			local next_row_slots = self._aquilas_navigation_data.slots_per_row[new_selection_row]
			local current_slot_idx = table.find(current_row_slots, self._selected_aquila_slot_index)
			local closest_next_idx = math.floor((current_slot_idx - 1) / #current_row_slots * #next_row_slots) + 1

			next_slot_index = next_row_slots[closest_next_idx]
		end

		self:_select_aquila_widget_by_slot_index(next_slot_index, new_selection_row)
	end
end

PremiumCurrencyPurchaseView._select_first_aquila_button = function (self)
	if self._aquilas_navigation_data then
		local slots = self._aquilas_navigation_data.slots_per_row[1]

		self:_select_aquila_widget_by_slot_index(slots[#slots], 1)
	end
end

PremiumCurrencyPurchaseView._select_aquila_widget_by_slot_index = function (self, slot_idx, row_index)
	if not self._aquilas_widgets then
		return
	end

	if not slot_idx then
		for i = 1, #self._aquilas_widgets do
			local widget = self._aquilas_widgets[i]

			widget.content.hotspot.is_focused = false
		end

		return
	end

	local row_slots = self._aquilas_navigation_data.slots_per_row[row_index]

	slot_idx = math.clamp(slot_idx, row_slots[1], row_slots[#row_slots])

	local selected_widget = self._aquilas_navigation_data.widgets_by_slot_index[slot_idx]

	for i = 1, #self._aquilas_widgets do
		local widget = self._aquilas_widgets[i]

		widget.content.hotspot.is_focused = widget == selected_widget
	end

	if self._golden_widget then
		self._golden_widget.content.hotspot.is_focused = self._golden_widget == selected_widget
	end

	if not selected_widget then
		self:_select_first_aquila_button()

		return
	end

	if selected_widget.row ~= self._selected_aquila_row then
		selected_widget.previous_selection_idx = self._selected_aquila_slot_index
	else
		selected_widget.previous_selection_idx = nil
	end

	self._selected_aquila_slot_index = slot_idx
	self._selected_aquila_row = selected_widget.row
end

PremiumCurrencyPurchaseView._update_wallets = function (self)
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

PremiumCurrencyPurchaseView.on_resolution_modified = function (self, scale)
	PremiumCurrencyPurchaseView.super.on_resolution_modified(self, scale)
end

return PremiumCurrencyPurchaseView
