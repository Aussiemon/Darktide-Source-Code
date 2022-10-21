local Definitions = require("scripts/ui/views/contracts_background_view/contracts_background_view_definitions")
local VendorInteractionViewBase = require("scripts/ui/views/vendor_interaction_view_base/vendor_interaction_view_base")
local ContractsBackgroundView = class("ContractsBackgroundView", "VendorInteractionViewBase")

ContractsBackgroundView.init = function (self, settings, context)
	self._wallet_type = "marks"

	ContractsBackgroundView.super.init(self, Definitions, settings, context)
end

ContractsBackgroundView.on_enter = function (self)
	ContractsBackgroundView.super.on_enter(self)

	local narrative_manager = Managers.narrative
	local narrative_event_name = "level_unlock_contract_store_visited"

	if narrative_manager:can_complete_event(narrative_event_name) then
		narrative_manager:complete_event(narrative_event_name)
	end
end

return ContractsBackgroundView
