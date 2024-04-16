require("scripts/extension_systems/weapon/actions/action_weapon_base")

local Pickups = require("scripts/settings/pickup/pickups")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local ActionDiscard = class("ActionDiscard", "ActionWeaponBase")

ActionDiscard.init = function (self, action_context, ...)
	ActionDiscard.super.init(self, action_context, ...)

	local unit_data_extension = action_context.unit_data_extension
	self._action_component = unit_data_extension:read_component("action_place")
	self._weapon_system = Managers.state.extension:system("weapon_system")
end

ActionDiscard.fixed_update = function (self, dt, t, time_in_action)
	local action_settings = self._action_settings
	local time_scale = self._weapon_action_component.time_scale

	if time_in_action >= action_settings.total_time / time_scale then
		local inventory_component = self._inventory_component
		local player_unit = self._player_unit
		local wielded_slot = inventory_component.wielded_slot
		local previously_wielded_weapon_slot = inventory_component.previously_wielded_weapon_slot

		PlayerUnitVisualLoadout.unequip_item_from_slot(player_unit, wielded_slot, t)
		PlayerUnitVisualLoadout.wield_slot(previously_wielded_weapon_slot, player_unit, t)
		self:_discard(action_settings)
	end
end

ActionDiscard._discard = function (self, action_settings)
	if not self._is_server then
		return
	end

	local position = self._action_component.position
	local rotation = self._action_component.rotation
	local pickup_name = action_settings.pickup_name
	local player_or_nil = Managers.state.player_unit_spawn:owner(self._player_unit)
	local item_name = pickup_name or action_settings.deployable_settings.unit_template

	Managers.telemetry_reporters:reporter("placed_items"):register_event(player_or_nil, item_name)

	if pickup_name then
		local pickup_system = Managers.state.extension:system("pickup_system")
		local placed_unit = nil

		if player_or_nil then
			placed_unit = pickup_system:player_spawn_pickup(pickup_name, position, rotation, player_or_nil, player_or_nil:session_id())
		else
			placed_unit = pickup_system:spawn_pickup(pickup_name, position, rotation)
		end

		local equipped_pickup_data = Pickups.by_name[pickup_name]

		if equipped_pickup_data and equipped_pickup_data.on_drop_func then
			equipped_pickup_data.on_drop_func(placed_unit)
		end
	else
		local deployable_settings = action_settings.deployable_settings
		local unit_template = deployable_settings.unit_template
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[self._player_unit]
		local side_id = side.side_id
		local unit_name, material = nil

		Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template, position, rotation, material, side_id, deployable_settings)
	end
end

return ActionDiscard
