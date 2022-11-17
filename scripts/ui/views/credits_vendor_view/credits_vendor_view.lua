local VendorViewBase = require("scripts/ui/views/vendor_view_base/vendor_view_base")
local Definitions = require("scripts/ui/views/credits_vendor_view/credits_vendor_view_definitions")
local CreditsVendorViewSettings = require("scripts/ui/views/credits_vendor_view/credits_vendor_view_settings")
local CreditsVendorView = class("CreditsVendorView", "VendorViewBase")

CreditsVendorView.init = function (self, settings, context)
	local parent = context and context.parent
	self._parent = parent
	self._optional_store_service = context and context.optional_store_service

	CreditsVendorView.super.init(self, Definitions, settings, context)
end

CreditsVendorView._get_store = function (self)
	local store_service = Managers.data_service.store
	local store_promise = nil
	local optional_store_service = self._optional_store_service

	if optional_store_service and store_service[optional_store_service] then
		store_promise = store_service[optional_store_service](store_service)
	else
		store_promise = store_service:get_credits_store()
	end

	return store_promise
end

CreditsVendorView._on_purchase_complete = function (self, items)
	CreditsVendorView.super._on_purchase_complete(self, items)
	self._parent:play_vo_events(CreditsVendorViewSettings.vo_event_vendor_purchase, "credit_store_servitor_b", nil, 1.4)
end

CreditsVendorView.dialogue_system = function (self)
	return self._parent:dialogue_system()
end

return CreditsVendorView
