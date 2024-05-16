﻿-- chunkname: @scripts/extension_systems/ability/actions/action_stance_change.lua

require("scripts/extension_systems/weapon/actions/action_ability_base")

local Action = require("scripts/utilities/weapon/action")
local Ammo = require("scripts/utilities/ammo")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local Interrupt = require("scripts/utilities/attack/interrupt")
local Luggable = require("scripts/utilities/luggable")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local ReloadStates = require("scripts/extension_systems/weapon/utilities/reload_states")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
local Vo = require("scripts/utilities/vo")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local buff_proc_events = BuffSettings.proc_events
local proc_events = BuffSettings.proc_events
local reload_kinds = ReloadStates.reload_kinds
local special_rules = SpecialRulesSetting.special_rules
local ActionStanceChange = class("ActionStanceChange", "ActionAbilityBase")

ActionStanceChange.init = function (self, action_context, action_params, action_settings)
	ActionStanceChange.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension

	self._weapon_action_component = unit_data_extension:read_component("weapon_action")

	local ability_template_tweak_data = self._ability_template_tweak_data
	local slot_to_wield = action_settings.auto_wield_slot or ability_template_tweak_data.auto_wield_slot

	if slot_to_wield then
		self._inventory_slot_secondary_component = unit_data_extension:write_component(slot_to_wield)
	end

	self._ability_type = action_settings.ability_type or "none"

	local player_unit = self._player_unit

	self._talent_extension = ScriptUnit.extension(player_unit, "talent_system")
end

ActionStanceChange.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionStanceChange.super.start(self, action_settings, t, time_scale, action_start_params)

	local reload_secondary = action_settings.reload_secondary
	local stop_reload = action_settings.stop_reload
	local stop_current_action = action_settings.stop_current_action
	local anim = action_settings.anim
	local anim_3p = action_settings.anim_3p or anim
	local block_weapon_actions = action_settings.block_weapon_actions
	local refill_toughness = action_settings.refill_toughness
	local vo_tag = action_settings.vo_tag
	local player_unit = self._player_unit
	local ability_template_tweak_data = self._ability_template_tweak_data
	local buff_to_add = ability_template_tweak_data.buff_to_add
	local slot_to_wield = action_settings.auto_wield_slot or ability_template_tweak_data.auto_wield_slot
	local skip_wield_action = action_settings.skip_wield_action
	local inventory_component = self._inventory_component
	local visual_loadout_extension = self._visual_loadout_extension

	Luggable.drop_luggable(t, player_unit, inventory_component, visual_loadout_extension, true)

	if vo_tag then
		Vo.play_combat_ability_event(player_unit, vo_tag)
	end

	if stop_reload then
		local weapon_action_component = self._unit_data_extension:read_component("weapon_action")
		local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
		local _, current_action_settings = Action.current_action(weapon_action_component, weapon_template)
		local current_action_kind = current_action_settings and current_action_settings.kind

		if current_action_kind and reload_kinds[current_action_kind] then
			Interrupt.action(t, player_unit, "veteran_ability")
		end
	end

	if stop_current_action then
		Interrupt.action(t, player_unit, "combat_ability", nil, true)
	end

	if slot_to_wield then
		local inventory_comp = ScriptUnit.extension(player_unit, "unit_data_system"):read_component("inventory")
		local wielded_slot = inventory_comp.wielded_slot

		if slot_to_wield ~= wielded_slot then
			PlayerUnitVisualLoadout.wield_slot(slot_to_wield, player_unit, t, skip_wield_action)
		end
	end

	if buff_to_add then
		local buff_extension = ScriptUnit.extension(player_unit, "buff_system")

		buff_extension:add_internally_controlled_buff(buff_to_add, t)
	end

	if self._ability_pause_cooldown_setting then
		self._ability_component.cooldown_paused = true
	end

	local talent_extension = self._talent_extension
	local reload_weapon = talent_extension:has_special_rule(special_rules.veteran_ranger_combat_ability_reloads_weapon)

	if reload_secondary or reload_weapon then
		local inventory_slot_secondary_component = self._inventory_slot_secondary_component
		local max_ammo_in_clip = inventory_slot_secondary_component.max_ammunition_clip
		local current_ammo_in_clip = inventory_slot_secondary_component.current_ammunition_clip
		local missing_ammo_in_clip = max_ammo_in_clip - current_ammo_in_clip

		Ammo.transfer_from_reserve_to_clip(inventory_slot_secondary_component, missing_ammo_in_clip)

		local weapon_template = visual_loadout_extension:weapon_template_from_slot(slot_to_wield)
		local reload_template = weapon_template.reload_template

		if reload_template then
			ReloadStates.reset(reload_template, inventory_slot_secondary_component)
		end

		local param_table_on_reload_start = self._buff_extension:request_proc_event_param_table()

		if param_table_on_reload_start then
			param_table_on_reload_start.weapon_template = weapon_template
			param_table_on_reload_start.shotgun = false

			self._buff_extension:add_proc_event(buff_proc_events.on_reload_start, param_table_on_reload_start)
		end

		local param_table_on_reload = self._buff_extension:request_proc_event_param_table()

		if param_table_on_reload then
			param_table_on_reload.weapon_template = weapon_template
			param_table_on_reload.shotgun = false

			self._buff_extension:add_proc_event(buff_proc_events.on_reload, param_table_on_reload)
		end
	end

	if anim then
		self:trigger_anim_event(anim, anim_3p)
	end

	if block_weapon_actions then
		self._weapon_actions_blocked = true

		local weapon_extension = ScriptUnit.extension(player_unit, "weapon_system")

		weapon_extension:block_actions("weapon_action")
	end

	if self._is_server and refill_toughness then
		Toughness.recover_max_toughness(player_unit, "ability stance")
	end

	if action_settings then
		local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
		local param_table = buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.unit = player_unit

			buff_extension:add_proc_event(proc_events.on_combat_ability, param_table)
		end
	end
end

ActionStanceChange.finish = function (self, reason, data, t, time_in_action, action_settings)
	ActionStanceChange.super.finish(self, reason, data, t, time_in_action, action_settings)

	if self._weapon_actions_blocked then
		self._weapon_actions_blocked = nil

		local weapon_extension = ScriptUnit.extension(self._player_unit, "weapon_system")

		weapon_extension:unblock_actions("weapon_action")
	end
end

return ActionStanceChange
