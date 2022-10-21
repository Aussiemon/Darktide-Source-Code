require("scripts/extension_systems/weapon/actions/action_place_base")

local Pickups = require("scripts/settings/pickup/pickups")
local ActionPlacePickup = class("ActionPlacePickup", "ActionPlaceBase")

ActionPlacePickup._place_unit = function (self, action_settings, position, rotation, placed_on_unit)
	local player_unit = self._player_unit
	local weapon_template = self._weapon_template
	local pickup_name = action_settings.pickup_name or weapon_template.pickup_name
	local player_or_nil = Managers.state.player_unit_spawn:owner(player_unit)
	local pickup_system = Managers.state.extension:system("pickup_system")
	local placed_unit = nil

	if player_or_nil then
		placed_unit = pickup_system:player_spawn_pickup(pickup_name, position, rotation, player_or_nil:session_id(), placed_on_unit)
	else
		placed_unit = pickup_system:spawn_pickup(pickup_name, position, rotation, nil, placed_on_unit)
	end

	local equipped_pickup_data = Pickups.by_name[pickup_name]

	if equipped_pickup_data and equipped_pickup_data.on_drop_func then
		equipped_pickup_data.on_drop_func(placed_unit)
	end

	self:_register_stats_and_telemetry(pickup_name, player_or_nil)
	Managers.event:trigger("on_pickup_placed", placed_unit)
end

return ActionPlacePickup
