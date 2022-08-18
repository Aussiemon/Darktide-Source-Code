local VendorViewBase = require("scripts/ui/views/vendor_view_base/vendor_view_base")
local Definitions = require("scripts/ui/views/credits_vendor_view/credits_vendor_view_definitions")
local CreditsVendorViewSettings = require("scripts/ui/views/credits_vendor_view/credits_vendor_view_settings")
local CreditsVendorView = class("CreditsVendorView", "VendorViewBase")

CreditsVendorView.init = function (self, settings, context)
	CreditsVendorView.super.init(self, Definitions, settings, context)
end

CreditsVendorView._get_store = function (self)
	local store_service = Managers.data_service.store
	local store_promise = store_service:get_credits_store()

	return store_promise
end

return CreditsVendorView
