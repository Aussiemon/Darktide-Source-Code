-- chunkname: @scripts/extension_systems/ability/actions/action_cryptic_precision_stance_toggle.lua

require("scripts/extension_systems/weapon/actions/action_ability_base")

local Action = require("scripts/utilities/action/action")
local Ammo = require("scripts/utilities/ammo")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local Interrupt = require("scripts/utilities/attack/interrupt")
local Luggable = require("scripts/utilities/luggable")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local ReloadStates = require("scripts/extension_systems/weapon/utilities/reload_states")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local Suppression = require("scripts/utilities/attack/suppression")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
local Vo = require("scripts/utilities/vo")
local WarpCharge = require("scripts/utilities/warp_charge")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local buff_proc_events = BuffSettings.proc_events
local proc_events = BuffSettings.proc_events
local reload_kinds = ReloadStates.reload_kinds
local special_rules = SpecialRulesSettings.special_rules
local talent_settings = TalentSettings.cryptic
local ActionPrecisionStanceToggle = class("ActionPrecisionStanceToggle", "ActionAbilityBase")

ActionPrecisionStanceToggle.init = function (self, action_context, action_params, action_settings)
	ActionPrecisionStanceToggle.super.init(self, action_context, action_params, action_settings)

	self._ability_type = action_settings.ability_type or "none"

	local unit_data_extension = action_context.unit_data_extension

	self._combat_ability_component = unit_data_extension:write_component("combat_ability")

	local player_unit = self._player_unit

	self._talent_extension = ScriptUnit.extension(player_unit, "talent_system")
	self._precision_stance_buff_local_index = nil
	self._precision_stance_buff_component_index = nil
end

ActionPrecisionStanceToggle.start = function (self, action_settings, t, time_scale, action_start_params)
	local player_unit = self._player_unit
	local buff_extension = self._buff_extension
	local combat_ability_component = self._combat_ability_component

	if combat_ability_component.active then
		combat_ability_component.active = false

		if buff_extension:has_running_buff_with_index(self._precision_stance_buff_local_index, self._precision_stance_buff_component_index) then
			buff_extension:remove_externally_controlled_buff(self._precision_stance_buff_local_index, self._precision_stance_buff_component_index)
		end

		self._precision_stance_buff_local_index, self._precision_stance_buff_component_index = nil

		return
	end

	combat_ability_component.active = true

	local ability_extension = self._ability_extension

	self._remaining_ability_charges_before_use_at_start = ability_extension:remaining_ability_charges("combat_ability") or 0

	ability_extension:increase_ability_cooldown_percentage("combat_ability", talent_settings.precision_stance.cooldown_percent_cost_on_activation)

	local inventory_component = self._inventory_component
	local wielded_slot_name = inventory_component.wielded_slot

	if wielded_slot_name ~= "slot_secondary" then
		local visual_loadout_extension = self._visual_loadout_extension

		Luggable.drop_luggable(t, player_unit, inventory_component, visual_loadout_extension, true)
		PlayerUnitVisualLoadout.wield_slot("slot_secondary", player_unit, t, false)
	end

	local num_charges_used_on_activation = math.floor(talent_settings.precision_stance.cooldown_percent_cost_on_activation)

	self._ability_charges_used_at_start = math.max(num_charges_used_on_activation, 1)

	local ability_template_tweak_data = self._ability_template_tweak_data
	local buff_to_add
	local charge_based_buffs_to_add = ability_template_tweak_data.charge_based_buffs_to_add

	if charge_based_buffs_to_add then
		local charges = self._ability_charges_used_at_start

		buff_to_add = charge_based_buffs_to_add[charges]
	else
		buff_to_add = ability_template_tweak_data.buff_to_add
	end

	if self._precision_stance_buff_component_index then
		if buff_extension:has_running_buff_with_index(self._precision_stance_buff_local_index, self._precision_stance_buff_component_index) then
			buff_extension:remove_externally_controlled_buff(self._precision_stance_buff_local_index, self._precision_stance_buff_component_index)
		end

		self._precision_stance_buff_local_index, self._precision_stance_buff_component_index = nil
	end

	local _, buff_local_index, buff_component_index = buff_extension:add_externally_controlled_buff(buff_to_add, t)

	self._precision_stance_buff_local_index = buff_local_index
	self._precision_stance_buff_component_index = buff_component_index

	if self._talent_extension:has_special_rule(special_rules.cryptic_precision_stance_restores_toughness) then
		Suppression.clear_suppression(player_unit)
	end

	if action_settings then
		local param_table = buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.unit = player_unit
			param_table.ability_charges_used = num_charges_used_on_activation
			param_table.remaining_ability_charges_before_use = self._remaining_ability_charges_before_use_at_start

			buff_extension:add_proc_event(proc_events.on_combat_ability, param_table)
		end
	end

	local vo_tag = action_settings.vo_tag

	if vo_tag then
		Vo.play_combat_ability_event(player_unit, vo_tag)
	end
end

ActionPrecisionStanceToggle.fixed_update = function (self, dt, t, time_in_action)
	return true
end

ActionPrecisionStanceToggle.finish = function (self, reason, data, t, time_in_action, action_settings)
	return
end

return ActionPrecisionStanceToggle
