-- chunkname: @scripts/extension_systems/weapon/actions/action_deploy_mine.lua

require("scripts/extension_systems/weapon/actions/action_place_base")

local LagCompensation = require("scripts/utilities/lag_compensation")
local MasterItems = require("scripts/backend/master_items")
local Vo = require("scripts/utilities/vo")
local ActionDeployMine = class("ActionDeployMine", "ActionPlaceBase")

ActionDeployMine.init = function (self, action_context, action_params, action_settings)
	ActionDeployMine.super.init(self, action_context, action_params, action_settings)

	local weapon = action_params.weapon

	self._weapon = weapon
	self._weapon_unit = weapon.weapon_unit
	self._weapon_template = weapon.weapon_template
	self._inventory_slot_component = weapon.inventory_slot_component
	self._mine_settings_name = self._weapon_template.mine_settings_name
	self._item_definitions = MasterItems.get_cached()

	local unit_data_extension = action_context.unit_data_extension

	self._action_component = unit_data_extension:write_component("action_place")
	self._action_aim_projectile_component = unit_data_extension:read_component("action_aim_projectile")
	self._action_settings = action_settings
	self._side_system = Managers.state.extension:system("side_system")
end

ActionDeployMine.start = function (self, action_settings, t, ...)
	ActionDeployMine.super.start(self, action_settings, t, ...)

	self._item = self._weapon.item
end

ActionDeployMine._place_unit = function (self, action_settings, position, rotation, placed_on_unit)
	if not self._is_server then
		return
	end

	local item = self._item

	if self._is_server then
		local owner_side = self._side_system.side_by_unit[self._player_unit]
		local owner_side_name = owner_side and owner_side:name()
		local unit_template_name = "deployable_mine"
		local mine_settings_name = self._mine_settings_name
		local owner_unit = self._player_unit

		Managers.state.unit_spawner:spawn_network_unit(nil, unit_template_name, position, rotation, nil, item, owner_side_name, mine_settings_name, nil, nil, nil, owner_unit)
	end
end

ActionDeployMine.finish = function (self, reason, data, t, time_in_action)
	ActionDeployMine.super.finish(self, reason, data, t, time_in_action)
end

return ActionDeployMine
