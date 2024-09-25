-- chunkname: @scripts/extension_systems/weapon/actions/action_unwield.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local AimAssist = require("scripts/utilities/aim_assist")
local AlternateFire = require("scripts/utilities/alternate_fire")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local WeaponSpecial = require("scripts/utilities/weapon_special")
local buff_proc_events = BuffSettings.proc_events
local ActionUnwield = class("ActionUnwield", "ActionWeaponBase")

ActionUnwield.init = function (self, action_context, ...)
	ActionUnwield.super.init(self, action_context, ...)

	local unit_data = action_context.unit_data_extension

	self._action_unwield_component = unit_data:write_component("action_unwield")
	self._alternate_fire_component = unit_data:write_component("alternate_fire")
	self._spread_control_component = unit_data:write_component("spread_control")
	self._weapon_tweak_templates_component = unit_data:write_component("weapon_tweak_templates")
	self._sway_control_component = unit_data:write_component("sway_control")
	self._buff_extension = ScriptUnit.extension(action_context.player_unit, "buff_system")
end

ActionUnwield.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionUnwield.super.start(self, action_settings, t, time_scale, action_start_params)

	local action_unwield = self._action_unwield_component
	local used_input = action_start_params.used_input
	local next_slot = self:_next_slot(used_input, action_settings)

	action_unwield.slot_to_wield = next_slot

	local current_wielded_slot = self._inventory_component.wielded_slot
	local buff_extension = self._buff_extension
	local next_weapon_template = self._visual_loadout_extension:weapon_template_from_slot(next_slot)
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.weapon_template = next_weapon_template
		param_table.previously_wielded_slot = current_wielded_slot

		buff_extension:add_proc_event(buff_proc_events.on_wield, param_table)

		local keywords = next_weapon_template.keywords

		if table.array_contains(keywords, "ranged") then
			buff_extension:add_proc_event(buff_proc_events.on_wield_ranged, param_table)
		end

		if table.array_contains(keywords, "melee") then
			buff_extension:add_proc_event(buff_proc_events.on_wield_melee, param_table)
		end
	end

	local alternate_fire_component = self._alternate_fire_component

	if alternate_fire_component.is_active then
		AlternateFire.stop(alternate_fire_component, self._peeking_component, self._first_person_extension, self._weapon_tweak_templates_component, self._animation_extension, self._weapon_template, false, self._player_unit, true)
	end

	AimAssist.reset_ramp_multiplier(self._aim_assist_ramp_component)
	self._weapon_extension:set_wielded_weapon_weapon_special_active(t, false, "unwield")
end

ActionUnwield.fixed_update = function (self, dt, t, time_in_action)
	local action_settings = self._action_settings
	local time_scale = self._weapon_action_component.time_scale

	if time_in_action >= action_settings.total_time / time_scale then
		local current_wielded_slot = self._inventory_component.wielded_slot
		local slot_to_wield = self._action_unwield_component.slot_to_wield

		PlayerUnitVisualLoadout.wield_slot(slot_to_wield, self._player_unit, t)

		if action_settings.unequip_slot then
			PlayerUnitVisualLoadout.unequip_item_from_slot(self._player_unit, current_wielded_slot, t)
		end
	end
end

ActionUnwield._next_slot = function (self, used_input, action_settings)
	return PlayerUnitVisualLoadout.slot_name_from_wield_input(used_input, self._inventory_component, self._visual_loadout_extension, self._weapon_extension, self._ability_extension, self._input_extension)
end

ActionUnwield.finish = function (self, reason, data, t, time_in_action)
	return
end

return ActionUnwield
