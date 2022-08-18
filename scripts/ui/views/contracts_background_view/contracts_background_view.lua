local Definitions = require("scripts/ui/views/contracts_background_view/contracts_background_view_definitions")
local VendorInteractionViewBase = require("scripts/ui/views/vendor_interaction_view_base/vendor_interaction_view_base")
local ContractsBackgroundView = class("ContractsBackgroundView", "VendorInteractionViewBase")

ContractsBackgroundView.init = function (self, settings, context)
	self._wallet_type = "marks"

	ContractsBackgroundView.super.init(self, Definitions, settings, context)
end

ContractsBackgroundView.on_enter = function (self)
	ContractsBackgroundView.super.on_enter(self)
end

return ContractsBackgroundView
