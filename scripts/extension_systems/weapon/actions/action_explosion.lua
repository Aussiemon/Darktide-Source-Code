require("scripts/extension_systems/weapon/actions/action_weapon_base")

local AttackSettings = require("scripts/settings/damage/attack_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local ActionExplosion = class("ActionExplosion", "ActionWeaponBase")

ActionExplosion.init = function (self, action_context, action_params, action_settings)
	ActionExplosion.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension
	self._warp_charge_component = unit_data_extension:write_component("warp_charge")
	self._action_module_charge_component = unit_data_extension:write_component("action_module_charge")
	self._action_module_position_finder_component = unit_data_extension:write_component("action_module_position_finder")
end

ActionExplosion.start = function (self, action_settings, t, ...)
	ActionExplosion.super.start(self, action_settings, t, ...)

	local charge_level = 1

	if action_settings.use_charge then
		charge_level = self._action_module_charge_component.charge_level
		self._action_module_charge_component.charge_level = 0
	end

	self:_pay_warp_charge_cost(t, charge_level)

	if self._is_server then
		self:_explode(charge_level)
	end
end

ActionExplosion._explode = function (self, charge_level)
	local action_settings = self._action_settings
	local explosion_template = action_settings.explosion_template
	local power_level = action_settings.power_level
	local position_component = self._action_module_position_finder_component
	local position = position_component.position
	local attack_type = AttackSettings.attack_types.explosion
	local player_unit = self._player_unit

	Explosion.create_explosion(self._world, self._physics_world, position, Vector3.up(), player_unit, explosion_template, power_level, charge_level, attack_type, nil, self._weapon.item)
end

ActionExplosion.finish = function (self, reason, data, t, time_in_action)
	ActionExplosion.super.finish(self, reason, data, t, time_in_action)

	self._action_module_position_finder_component.position = Vector3.zero()
end

return ActionExplosion
