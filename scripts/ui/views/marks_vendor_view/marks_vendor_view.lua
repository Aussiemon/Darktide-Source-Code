local VendorViewBase = require("scripts/ui/views/vendor_view_base/vendor_view_base")
local Definitions = require("scripts/ui/views/marks_vendor_view/marks_vendor_view_definitions")
local MarksVendorViewSettings = require("scripts/ui/views/marks_vendor_view/marks_vendor_view_settings")
local MarksVendorView = class("MarksVendorView", "VendorViewBase")

MarksVendorView.init = function (self, settings, context)
	MarksVendorView.super.init(self, Definitions, settings, context)

	local parent = context and context.parent
	self._parent = parent

	if parent then
		context.parent:set_is_handling_navigation_input(true)
	end
end

MarksVendorView._get_store = function (self)
	local store_service = Managers.data_service.store
	local store_promise = nil

	if self._show_temporary_store_items then
		store_promise = store_service:get_marks_store_temporary()
	else
		store_promise = store_service:get_marks_store()
	end

	return store_promise
end

MarksVendorView.show_items = function (self)
	self:_clear_list()

	self._show_temporary_store_items = true

	self:_update_wallets():next(function ()
		self:_fetch_store_items()
	end)
end

MarksVendorView._on_purchase_complete = function (self, items)
	MarksVendorView.super._on_purchase_complete(self, items)

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

MarksVendorView.dialogue_system = function (self)
	return self._parent:dialogue_system()
end

return MarksVendorView
