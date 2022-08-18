require("scripts/extension_systems/weapon/actions/action_weapon_base")

local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local Overheat = require("scripts/utilities/overheat")
local WarpCharge = require("scripts/utilities/warp_charge")
local attack_types = AttackSettings.attack_types
local ActionOveruseExplosion = class("ActionOveruseExplosion", "ActionWeaponBase")
local DEFAULT_POWER_LEVEL = 2000

ActionOveruseExplosion.init = function (self, action_context, action_params, ...)
	ActionOveruseExplosion.super.init(self, action_context, action_params, ...)

	local weapon = action_params.weapon
	self._on_start_source_name = weapon.fx_sources._overheat
	self._exploding_character_state_component = action_context.unit_data_extension:write_component("exploding_character_state")
end

ActionOveruseExplosion.start = function (self, action_settings, ...)
	ActionOveruseExplosion.super.start(self, action_settings, ...)

	local sfx = action_settings.sfx
	local on_start_sfx = sfx and sfx.on_start

	if on_start_sfx then
		local sync_to_clients = true
		local external_properties = nil

		self._fx_extension:trigger_gear_wwise_event_with_source(on_start_sfx, external_properties, self._on_start_source_name, sync_to_clients)
	end
end

ActionOveruseExplosion.fixed_update = function (self, dt, t, time_in_action)
	ActionOveruseExplosion.super.fixed_update(self, dt, t, time_in_action)

	if self._is_server then
		local action_settings = self._action_settings
		local dot_settings = action_settings.dot_settings

		if dot_settings then
			local damage_frequency = dot_settings.damage_frequency
			local this_frame_time = time_in_action % damage_frequency
			local previous_frame_time = math.max(time_in_action - dt, 0) % damage_frequency
			local time_to_do_damage = this_frame_time < previous_frame_time

			if time_to_do_damage then
				local damage_profile = dot_settings.damage_profile
				local player_unit = self._player_unit
				local power_level = dot_settings.power_level
				local weapon_item = self._weapon.item

				Attack.execute(player_unit, damage_profile, "power_level", power_level, "item", weapon_item)
			end
		end
	end
end

ActionOveruseExplosion.finish = function (self, reason, data, t, time_in_action)
	ActionOveruseExplosion.super.finish(self, reason, data, t, time_in_action)

	if reason == "aborted" then
		return
	end

	self:_explode(self._action_settings)

	local state_component = self._exploding_character_state_component
	local unit_data_extension = self._unit_data_extension

	if state_component.reason == "overheat" then
		local slot_name = state_component.slot_name
		local inventory_slot_component = unit_data_extension:write_component(slot_name)

		Overheat.clear(inventory_slot_component)
	elseif state_component.reason == "warp_charge" then
		local warp_charge_component = unit_data_extension:write_component("warp_charge")

		WarpCharge.clear(warp_charge_component)
	end
end

ActionOveruseExplosion._explode = function (self, action_settings)
	if self._is_server then
		local explosion_template = action_settings.explosion_template
		local position = self._locomotion_component.position
		local impact_normal = nil
		local power_level = DEFAULT_POWER_LEVEL
		local charge_level = 1

		Explosion.create_explosion(self._world, self._physics_world, position, impact_normal, self._player_unit, explosion_template, power_level, charge_level, attack_types.explosion, nil, nil)
	end

	if action_settings.death_on_explosion then
		Attack.execute(self._player_unit, action_settings.death_damage_profile, "instakill", true, "damage_type", action_settings.death_damage_type, "item", nil)
	end
end

return ActionOveruseExplosion
