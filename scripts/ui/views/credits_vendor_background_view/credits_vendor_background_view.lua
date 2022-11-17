local Definitions = require("scripts/ui/views/credits_vendor_background_view/credits_vendor_background_view_definitions")
local VendorInteractionViewBase = require("scripts/ui/views/vendor_interaction_view_base/vendor_interaction_view_base")
local ViewSettings = require("scripts/ui/views/credits_vendor_view/credits_vendor_view_settings")
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

	self:play_vo_events(ViewSettings.vo_event_vendor_greeting, "credit_store_servitor_b", nil, 1)
end

CreditsVendorBackgroundView.on_exit = function (self)
	CreditsVendorBackgroundView.super.on_exit(self)

	local level = Managers.state.mission and Managers.state.mission:mission_level()

	if level then
		Level.trigger_event(level, "lua_credit_store_closed")
	end
end

return CreditsVendorBackgroundView
