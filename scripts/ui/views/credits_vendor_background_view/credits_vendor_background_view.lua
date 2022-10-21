local Definitions = require("scripts/ui/views/credits_vendor_background_view/credits_vendor_background_view_definitions")
local VendorInteractionViewBase = require("scripts/ui/views/vendor_interaction_view_base/vendor_interaction_view_base")
local CreditsVendorBackgroundView = class("CreditsVendorBackgroundView", "VendorInteractionViewBase")

CreditsVendorBackgroundView.init = function (self, settings, context)
	self._wallet_type = "credits"

	CreditsVendorBackgroundView.super.init(self, Definitions, settings, context)
end

CreditsVendorBackgroundView.on_enter = function (self)
	CreditsVendorBackgroundView.super.on_enter(self)

	local narrative_manager = Managers.narrative
	local narrative_event_name = "level_unlock_credits_store_visited"

	if narrative_manager:can_complete_event(narrative_event_name) then
		narrative_manager:complete_event(narrative_event_name)
	end
end

return CreditsVendorBackgroundView
