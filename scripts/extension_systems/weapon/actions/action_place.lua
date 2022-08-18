require("scripts/extension_systems/weapon/actions/action_weapon_base")

local Pickups = require("scripts/settings/pickup/pickups")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local ActionPlace = class("ActionPlace", "ActionWeaponBase")

ActionPlace.init = function (self, action_context, ...)
	ActionPlace.super.init(self, action_context, ...)

	local unit_data_extension = action_context.unit_data_extension
	self._action_component = unit_data_extension:read_component("action_place")
	self._weapon_system = Managers.state.extension:system("weapon_system")
end

ActionPlace.fixed_update = function (self, dt, t, time_in_action)
	local action_settings = self._action_settings
	local time_scale = self._weapon_action_component.time_scale

	if time_in_action >= action_settings.total_time / time_scale then
		local inventory_component = self._inventory_component
		local wielded_slot = inventory_component.wielded_slot
		local previously_wielded_weapon_slot = inventory_component.previously_wielded_weapon_slot
		local player_unit = self._player_unit

		if action_settings.remove_item_from_inventory then
			PlayerUnitVisualLoadout.unequip_item_from_slot(player_unit, wielded_slot, t)
		end

		PlayerUnitVisualLoadout.wield_slot(previously_wielded_weapon_slot, player_unit, t)

		if self._is_server then
			self:_place_unit(action_settings)
		end
	end
end

ActionPlace._place_unit = function (self, action_settings)
	ferror("ActionPlace is using base implementation of _place_unit, it shouldn't")
end

ActionPlace._register_stats_and_telemetry = function (self, item_name, player_or_nil)
	if DEDICATED_SERVER then
		local is_human = player_or_nil and player_or_nil:is_human_controlled()

		if is_human then
			Managers.stats:record_place_item(player_or_nil, item_name)
			Managers.telemetry_events:player_placed_item(player_or_nil, item_name)
		end
	end
end

return ActionPlace
