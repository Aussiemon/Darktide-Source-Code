require("scripts/extension_systems/weapon/actions/action_ability_base")

local ActionUtility = require("scripts/extension_systems/weapon/actions/utilities/action_utility")
local AimProjectile = require("scripts/utilities/aim_projectile")
local LagCompensation = require("scripts/utilities/lag_compensation")
local MasterItems = require("scripts/backend/master_items")
local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local Vo = require("scripts/utilities/vo")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local ActionThrowGrenade = class("ActionThrowGrenade", "ActionWeaponBase")
local locomotion_states = ProjectileLocomotionSettings.states

ActionThrowGrenade.init = function (self, action_context, action_params, action_settings)
	ActionThrowGrenade.super.init(self, action_context, action_params, action_settings)

	self._item_definitions = MasterItems.get_cached()
	local unit_data_extension = action_context.unit_data_extension
	self._action_aim_projectile_component = unit_data_extension:read_component("action_aim_projectile")
	self._action_settings = action_settings
	self._ability_extension = action_context.ability_extension
	self._weapon_template = action_params.weapon.weapon_template
end

ActionThrowGrenade.start = function (self, action_settings, t, ...)
	self:_check_for_critical_strike(false, true)

	local projectile_template = ActionUtility.get_projectile_template(action_settings, self._weapon_template, self._ability_extension)

	if projectile_template then
		Vo.throwing_item_event(self._player_unit, projectile_template.name)
	end

	self._spawn_at_time = t + (action_settings.spawn_at_time or 0)
end

ActionThrowGrenade.fixed_update = function (self, dt, t, time_in_action)
	local rewind_ms = LagCompensation.rewind_ms(self._is_server, self._is_local_unit, self._player) / 1000 / 2

	if self._spawn_at_time and self._spawn_at_time < t + rewind_ms then
		self._spawn_at_time = nil

		self:_spawn_projectile()

		local action_settings = self._action_settings
		local use_ability_charge = action_settings.use_ability_charge

		if use_ability_charge then
			self:_use_ability_charge()
		end
	end
end

ActionThrowGrenade._spawn_projectile = function (self)
	if self._is_server then
		local ability_extension = self._ability_extension
		local action_settings = self._action_settings
		local weapon_template = self._weapon_template
		local item, origin_item_slot = ActionUtility.get_ability_item(action_settings, ability_extension)
		local projectile_template = ActionUtility.get_projectile_template(action_settings, weapon_template, ability_extension)
		local locomotion_template = projectile_template.locomotion_template
		local owner_unit = self._player_unit
		local material = nil
		local fire_config = action_settings.fire_configuration
		local skip_aiming = fire_config and fire_config.skip_aiming
		local position, rotation, direction, speed, momentum = nil
		local first_person_component = self._first_person_component

		if skip_aiming then
			local look_rotation = first_person_component.rotation
			local look_position = first_person_component.position
			position, rotation, direction, speed, momentum = AimProjectile.get_spawn_parameters_from_current_aim(action_settings, look_position, look_rotation, locomotion_template)
		else
			local action_aim_projectile = self._action_aim_projectile_component
			position, rotation, direction, speed, momentum = AimProjectile.get_spawn_parameters_from_aim_component(action_aim_projectile)
		end

		local spawn_node = action_settings.spawn_node

		if spawn_node then
			local first_person_extension = ScriptUnit.extension(owner_unit, "first_person_system")
			local first_person_unit = first_person_extension:first_person_unit()
			local node = Unit.node(first_person_unit, spawn_node)
			position = Unit.world_position(first_person_unit, node)
		end

		local throw_parameters = locomotion_template and locomotion_template.throw_parameters and locomotion_template.throw_parameters.throw
		local starting_state = throw_parameters and throw_parameters.locomotion_state or locomotion_states.manual_physics
		local is_critical_strike = self._critical_strike_component.is_active

		if self._is_server then
			local projectile_unit, _ = Managers.state.unit_spawner:spawn_network_unit(nil, "item_projectile", position, rotation, material, item, projectile_template, starting_state, direction, speed, momentum, owner_unit, is_critical_strike, origin_item_slot)
		end
	end
end

ActionThrowGrenade.finish = function (self, reason, data, t, time_in_action)
	ActionThrowGrenade.super.finish(self, reason, data, t, time_in_action)
end

return ActionThrowGrenade
