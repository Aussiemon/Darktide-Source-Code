-- chunkname: @scripts/ui/views/credits_vendor_view/credits_vendor_view_settings.lua

local credits_vendor_view_settings = {
	vo_event_vendor_greeting = {
		"credit_store_servitor_hello_b",
	},
	vo_event_vendor_purchase = {
		"credit_store_servitor_purchase_b",
	},
}

return settings("CreditsVendorViewSettings", credits_vendor_view_settings)
