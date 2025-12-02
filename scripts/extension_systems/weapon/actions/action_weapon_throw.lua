-- chunkname: @scripts/extension_systems/weapon/actions/action_weapon_throw.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local ActionWeaponThrow = class("ActionWeaponThrow", "ActionSpawnProjectile")

ActionWeaponThrow.init = function (self, action_context, action_params, action_settings)
	ActionWeaponThrow.super.init(self, action_context, action_params, action_settings)

	local weapon_template = self._weapon_template
	local weapon_special_tweak_data = weapon_template and weapon_template.weapon_special_tweak_data

	self._weapon_special_tweak_data = weapon_special_tweak_data
end

ActionWeaponThrow.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionWeaponThrow.super.start(self, action_settings, t, time_scale, action_start_params)

	local weapon_special_tweak_data = self._weapon_special_tweak_data
	local num_charges_to_consume_on_activation = weapon_special_tweak_data and weapon_special_tweak_data.num_charges_to_consume_on_activation

	if num_charges_to_consume_on_activation then
		local inventory_slot_component = self._inventory_slot_component
		local num_special_charges = inventory_slot_component.num_special_charges

		inventory_slot_component.num_special_charges = math.max(num_special_charges - num_charges_to_consume_on_activation, 0)
	end
end

return ActionWeaponThrow
