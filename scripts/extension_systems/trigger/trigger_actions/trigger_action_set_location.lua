require("scripts/extension_systems/trigger/trigger_actions/trigger_action_base")

local TriggerActionSetLocation = class("TriggerActionSetLocation", "TriggerActionBase")

TriggerActionSetLocation.init = function (self, is_server, volume_unit, params)
	TriggerActionSetLocation.super.init(self, is_server, volume_unit, params)

	self._location_full = params.action_location_name_full
	self._location_short = params.action_location_name_short
end

TriggerActionSetLocation.local_on_activate = function (self, unit)
	TriggerActionSetLocation.super.local_on_activate(self, unit)
	self:_update_player_location(unit)
end

TriggerActionSetLocation._update_player_location = function (self, unit)
	local location_full = self._location_full
	local location_short = self._location_short
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(unit)

	if player then
		Managers.event:trigger("event_player_set_new_location", player, location_full, location_short)

		local volume_unit = self._volume_unit

		Unit.set_flow_variable(volume_unit, "lua_component_guid", self._component_guid)
		Unit.flow_event(volume_unit, "lua_trigger_activated")
	end
end

return TriggerActionSetLocation
