require("scripts/extension_systems/visual_loadout/minion_visual_loadout_extension")
require("scripts/extension_systems/visual_loadout/player_unit_visual_loadout_extension")
require("scripts/extension_systems/visual_loadout/player_husk_visual_loadout_extension")

local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local VisualLoadoutSystem = class("VisualLoadoutSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_player_wield_slot",
	"rpc_player_unwield_slot"
}

VisualLoadoutSystem.init = function (self, ...)
	VisualLoadoutSystem.super.init(self, ...)

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

VisualLoadoutSystem.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	VisualLoadoutSystem.super.destroy(self)
end

VisualLoadoutSystem.rpc_player_wield_slot = function (self, channel_id, go_id, slot_id)
	local unit = Managers.state.unit_spawner:unit(go_id)
	local slot_name = NetworkLookup.player_inventory_slot_names[slot_id]
	local visual_loadout_extension = self._unit_to_extension_map[unit]
	local animation_ext = ScriptUnit.extension(unit, "animation_system")

	PlayerUnitVisualLoadout.wield_slot_husk(unit, slot_name, visual_loadout_extension, animation_ext)
end

VisualLoadoutSystem.rpc_player_unwield_slot = function (self, channel_id, go_id, slot_id)
	local unit = Managers.state.unit_spawner:unit(go_id)
	local slot_name = NetworkLookup.player_inventory_slot_names[slot_id]
	local visual_loadout_extension = self._unit_to_extension_map[unit]

	PlayerUnitVisualLoadout.unwield_slot_husk(slot_name, visual_loadout_extension)
end

return VisualLoadoutSystem
