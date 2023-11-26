-- chunkname: @scripts/ui/views/marks_goods_vendor_view/marks_goods_vendor_view.lua

local VendorViewBase = require("scripts/ui/views/vendor_view_base/vendor_view_base")
local Definitions = require("scripts/ui/views/marks_goods_vendor_view/marks_goods_vendor_view_definitions")
local MarksGoodsVendorViewSettings = require("scripts/ui/views/marks_goods_vendor_view/marks_goods_vendor_view_settings")
local ViewElementItemResultOverlay = require("scripts/ui/view_elements/view_element_item_result_overlay/view_element_item_result_overlay")
local MasterItems = require("scripts/backend/master_items")
local MarksGoodsVendorView = class("MarksGoodsVendorView", "VendorViewBase")

MarksGoodsVendorView.init = function (self, settings, context)
	MarksGoodsVendorView.super.init(self, Definitions, settings, context)

	local parent = context and context.parent

	self._parent = parent
	self._debug = context and context.debug

	if parent then
		context.parent:set_is_handling_navigation_input(true)
	end
end

MarksGoodsVendorView._setup_result_overlay = function (self, result_data)
	if self._result_overlay then
		self._result_overlay = nil

		self:_remove_element("result_overlay")
	end

	local reference_name = "result_overlay"
	local layer = 40

	self._result_overlay = self:_add_element(ViewElementItemResultOverlay, reference_name, layer)

	self:_update_result_overlay_position()
	self._result_overlay:start(result_data)
end

MarksGoodsVendorView._update_result_overlay_position = function (self)
	if not self._result_overlay then
		return
	end
end

MarksGoodsVendorView._get_store = function (self)
	local store_service = Managers.data_service.store
	local store_promise

	if self._show_temporary_store_items then
		store_promise = store_service:get_marks_store_temporary()
	else
		store_promise = store_service:get_marks_store()
	end

	return store_promise
end

MarksGoodsVendorView.show_items = function (self)
	self:_clear_list()

	self._show_temporary_store_items = false

	self:_update_wallets():next(function ()
		self:_fetch_store_items()
	end)
end

MarksGoodsVendorView._setup_sort_options = function (self)
	return
end

MarksGoodsVendorView.cb_on_grid_entry_left_pressed = function (self, widget, element)
	local function cb_func()
		if self._destroyed then
			return
		end

		local offer = element.offer

		if Managers.ui:using_cursor_navigation() and offer and offer ~= self._previewed_offer then
			local widget_index = self._item_grid:widget_index(widget) or 1

			self._item_grid:focus_grid_index(widget_index)
		end
	end

	self._update_callback_on_grid_entry_left_pressed = callback(cb_func)
end

local general_goods_offer_display_information = {
	{
		background_icon = "content/ui/materials/icons/items/general_melee_weapon",
		icon = "content/ui/materials/icons/contracts/contracts_store/uknown_melee_weapon",
		display_name = Localize("loc_contracts_view_general_goods_random_melee_weapon"),
		sub_header = Localize("loc_contracts_view_general_goods_random_item_desc")
	},
	{
		background_icon = "content/ui/materials/icons/items/general_range_weapon",
		icon = "content/ui/materials/icons/contracts/contracts_store/uknown_ranged_weapon",
		display_name = Localize("loc_contracts_view_general_goods_random_ranged_weapon"),
		sub_header = Localize("loc_contracts_view_general_goods_random_item_desc")
	},
	{
		background_icon = "content/ui/materials/icons/items/general_curio_01",
		icon = "content/ui/materials/icons/contracts/contracts_store/uknown_melee_weapon",
		display_name = Localize("loc_contracts_view_general_goods_random_gadget_defensive"),
		sub_header = Localize("loc_contracts_view_general_goods_random_item_desc")
	},
	{
		background_icon = "content/ui/materials/icons/items/general_curio_02",
		icon = "content/ui/materials/icons/contracts/contracts_store/uknown_melee_weapon",
		display_name = Localize("loc_contracts_view_general_goods_random_gadget_teamplay"),
		sub_header = Localize("loc_contracts_view_general_goods_random_item_desc")
	},
	{
		background_icon = "content/ui/materials/icons/items/general_curio_03",
		icon = "content/ui/materials/icons/contracts/contracts_store/uknown_melee_weapon",
		display_name = Localize("loc_contracts_view_general_goods_random_gadget_utility"),
		sub_header = Localize("loc_contracts_view_general_goods_random_item_desc")
	}
}

MarksGoodsVendorView._convert_offers_to_layout_entries = function (self, item_offers)
	local layout = {}

	for i = 1, #item_offers do
		local offer = item_offers[i]
		local offer_id = offer.offerId
		local sku = offer.sku
		local category = sku.category

		if category == "item_instance" then
			local display_information = general_goods_offer_display_information[i]

			table.insert(layout, 1, {
				widget_type = "general_goods_item",
				offer = offer,
				offer_id = offer_id,
				display_information = display_information
			})
		end
	end

	return layout
end

MarksGoodsVendorView._present_purchase_result = function (self, item)
	return
end

MarksGoodsVendorView.draw = function (self, dt, t, input_service, layer)
	if self._result_overlay then
		input_service = input_service:null_service()
	end

	return MarksGoodsVendorView.super.draw(self, dt, t, input_service, layer)
end

MarksGoodsVendorView.update = function (self, dt, t, input_service)
	local result_overlay = self._result_overlay
	local handle_input = true

	if result_overlay then
		if result_overlay:presentation_complete() then
			self._result_overlay = nil

			self:_remove_element("result_overlay")
		else
			handle_input = false
		end
	end

	local pass_input, pass_draw = MarksGoodsVendorView.super.update(self, dt, t, input_service)

	return handle_input and pass_input, pass_draw
end

local input_action = "back"

MarksGoodsVendorView._handle_input = function (self, input_service)
	if input_service:get(input_action) and self:_is_result_presentation_active() then
		self._result_overlay = nil

		self:_remove_element("result_overlay")
	end

	MarksGoodsVendorView.super._handle_input(self, input_service)
end

MarksGoodsVendorView._on_purchase_complete = function (self, items)
	MarksGoodsVendorView.super._on_purchase_complete(self, items)

	local first_purchased_item = items and items[1]

	if first_purchased_item then
		local uuid = first_purchased_item.uuid
		local item = MasterItems.get_item_instance(first_purchased_item, uuid)

		if item then
			self:_present_purchase_result(item)
		end
	end

	if self._debug then
		return
	end

	local randomize_vo = math.random()

	if randomize_vo < 0.2 then
		self._parent:play_vo_events({
			"credit_store_servitor_purchase_c"
		}, "credit_store_servitor_c", nil, 1.4)
	elseif randomize_vo > 0.85 then
		self._parent:play_vo_events({
			"credit_store_servitor_purchase_c"
		}, "credit_store_servitor_c", nil, 1.4)
		self._parent:play_vo_events({
			"contract_vendor_servitor_purchase_b"
		}, "contract_vendor_a", nil, 1)
	else
		self._parent:play_vo_events({
			"contract_vendor_purchase_a"
		}, "contract_vendor_a", nil, 1.4)
	end
end

MarksGoodsVendorView._is_result_presentation_active = function (self)
	if self._result_overlay then
		return true
	end

	return false
end

MarksGoodsVendorView._preview_item = function (self, item)
	self._previewed_item = item

	local visible = true

	self:_set_preview_widgets_visibility(visible)
end

MarksGoodsVendorView._set_preview_widgets_visibility = function (self, visible)
	MarksGoodsVendorView.super._set_preview_widgets_visibility(self, visible)
end

MarksGoodsVendorView.dialogue_system = function (self)
	if self._debug then
		return
	end

	return self._parent:dialogue_system()
end

return MarksGoodsVendorView
