require("scripts/extension_systems/weapon/actions/action_weapon_base")

local Luggable = require("scripts/utilities/luggable")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local ActionThrow = class("ActionThrow", "ActionWeaponBase")

ActionThrow.init = function (self, action_context, ...)
	ActionThrow.super.init(self, action_context, ...)

	local unit_data_extension = action_context.unit_data_extension
	self._action_aim_projectile_component = unit_data_extension:read_component("action_aim_projectile")
	self._action_throw_component = unit_data_extension:write_component("action_throw")
end

ActionThrow.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionThrow.super.start(self, action_settings, t, time_scale, action_start_params)

	local action_throw_component = self._action_throw_component
	action_throw_component.thrown = false
	local used_input = action_start_params.used_input
	local inventory_component = self._inventory_component
	local wielded_slot = inventory_component.wielded_slot
	local slot_name_or_nil = PlayerUnitVisualLoadout.slot_name_from_wield_input(used_input, inventory_component, self._visual_loadout_extension, self._weapon_extension, self._ability_extension)
	local slot_to_wield = nil

	if not slot_name_or_nil or slot_name_or_nil == wielded_slot then
		slot_to_wield = inventory_component.previously_wielded_weapon_slot
	else
		slot_to_wield = slot_name_or_nil
	end

	action_throw_component.slot_to_wield = slot_to_wield
end

ActionThrow.finish = function (self, ...)
	ActionThrow.super.finish(self, ...)

	local action_throw_component = self._action_throw_component
	action_throw_component.thrown = false
	action_throw_component.slot_to_wield = "none"
end

ActionThrow.fixed_update = function (self, dt, t, time_in_action)
	local action_throw_component = self._action_throw_component
	local inventory_slot_component = self._inventory_slot_component
	local existing_unit = inventory_slot_component.existing_unit_3p
	local action_settings = self._action_settings
	local time_scale = self._weapon_action_component.time_scale
	local total_time = action_settings.total_time
	local throw_time = action_settings.throw_time or total_time
	local player = self._player

	if player.remote then
		local rewind_s = player:lag_compensation_rewind_s()
		throw_time = math.max(0, throw_time - rewind_s)
	end

	local time_scaled_throw_time = throw_time / time_scale
	local time_scaled_total_time = total_time / time_scale

	if not action_throw_component.thrown and time_scaled_throw_time <= time_in_action then
		action_throw_component.thrown = true
		local throw_type = action_settings.throw_type

		self:_throw_unit(existing_unit, throw_type)
	end

	if time_scaled_total_time <= time_in_action then
		local inventory_component = self._inventory_component
		local wielded_slot = inventory_component.wielded_slot
		local player_unit = self._player_unit
		local slot_to_wield = action_throw_component.slot_to_wield

		PlayerUnitVisualLoadout.unequip_item_from_slot(player_unit, wielded_slot, t)
		PlayerUnitVisualLoadout.wield_slot(slot_to_wield, player_unit, t)
	end
end

ActionThrow._throw_unit = function (self, existing_unit, throw_type)
	if self._is_server then
		local locomotion_extension = ScriptUnit.extension(existing_unit, "locomotion_system")

		if throw_type == "throw" then
			local action_aim_projectile = self._action_aim_projectile_component
			local position = action_aim_projectile.position
			local rotation = action_aim_projectile.rotation
			local direction = action_aim_projectile.direction
			local speed = action_aim_projectile.speed
			local momentum = action_aim_projectile.momentum

			locomotion_extension:switch_to_manual(position, rotation, direction, speed, momentum)
		elseif throw_type == "drop" and self._is_server then
			local first_person_component = self._first_person_component
			local locomotion_component = self._locomotion_component

			Luggable.enable_physics(first_person_component, locomotion_component, existing_unit)
		end
	end
end

return ActionThrow
