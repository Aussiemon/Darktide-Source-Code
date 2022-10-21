local VendorViewBase = require("scripts/ui/views/vendor_view_base/vendor_view_base")
local Definitions = require("scripts/ui/views/marks_vendor_view/marks_vendor_view_definitions")
local MarksVendorViewSettings = require("scripts/ui/views/marks_vendor_view/marks_vendor_view_settings")
local MarksVendorView = class("MarksVendorView", "VendorViewBase")

MarksVendorView.init = function (self, settings, context)
	MarksVendorView.super.init(self, Definitions, settings, context)

	if context and context.parent then
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

return MarksVendorView
