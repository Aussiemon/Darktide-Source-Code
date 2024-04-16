local Definitions = require("scripts/ui/views/contracts_background_view/contracts_background_view_definitions")
local VendorInteractionViewBase = require("scripts/ui/views/vendor_interaction_view_base/vendor_interaction_view_base")
local ContractsViewSettings = require("scripts/ui/views/contracts_view/contracts_view_settings")
local ContractsBackgroundView = class("ContractsBackgroundView", "VendorInteractionViewBase")

ContractsBackgroundView.init = function (self, settings, context)
	self._wallet_type = "marks"

	ContractsBackgroundView.super.init(self, Definitions, settings, context)
end

ContractsBackgroundView.on_enter = function (self)
	ContractsBackgroundView.super.on_enter(self)

	local viewport_name = Definitions.background_world_params.viewport_name

	if self._world_spawner then
		self._world_spawner:set_listener(viewport_name)
	end

	local narrative_manager = Managers.narrative
	local narrative_event_name = "level_unlock_contract_store_visited"

	if narrative_manager:can_complete_event(narrative_event_name) then
		narrative_manager:complete_event(narrative_event_name)
		self:play_vo_events(ContractsViewSettings.vo_event_vendor_first_interaction, "contract_vendor_a", nil, 0.8)
	else
		self:play_vo_events(ContractsViewSettings.vo_event_vendor_greeting, "contract_vendor_a", nil, 0.8, true)
	end
end

ContractsBackgroundView.update_wallets = function (self)
	ContractsBackgroundView.super._update_wallets(self)
end

ContractsBackgroundView.on_exit = function (self)
	if self._world_spawner then
		self._world_spawner:release_listener()
	end

	ContractsBackgroundView.super.on_exit(self)

	local level = Managers.state.mission and Managers.state.mission:mission_level()

	if level then
		Level.trigger_event(level, "lua_contracts_store_closed")
	end
end

return ContractsBackgroundView
