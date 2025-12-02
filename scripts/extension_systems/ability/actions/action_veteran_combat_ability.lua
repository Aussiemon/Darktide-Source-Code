-- chunkname: @scripts/extension_systems/ability/actions/action_veteran_combat_ability.lua

require("scripts/extension_systems/ability/actions/action_stance_change")

local Action = require("scripts/utilities/action/action")
local Ammo = require("scripts/utilities/ammo")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local Interrupt = require("scripts/utilities/attack/interrupt")
local Luggable = require("scripts/utilities/luggable")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local ReloadStates = require("scripts/extension_systems/weapon/utilities/reload_states")
local ShoutAbilityImplementation = require("scripts/extension_systems/ability/utilities/shout_ability_implementation")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
local Vo = require("scripts/utilities/vo")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local proc_events = BuffSettings.proc_events
local reload_kinds = ReloadStates.reload_kinds
local special_rules = SpecialRulesSettings.special_rules
local EXTERNAL_PROPERTIES = {}
local ActionVeteranCombatAbility = class("ActionVeteranCombatAbility", "ActionAbilityBase")

ActionVeteranCombatAbility.init = function (self, action_context, action_params, action_settings)
	ActionVeteranCombatAbility.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension

	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._inventory_slot_secondary_component = unit_data_extension:write_component("slot_secondary")
	self._inventory_component = unit_data_extension:read_component("inventory")
	self._combat_ability_component = unit_data_extension:write_component("combat_ability")
	self._ability_type = action_settings.ability_type or "none"
	self._talent_extension = ScriptUnit.extension(self._player_unit, "talent_system")
end

ActionVeteranCombatAbility.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionVeteranCombatAbility.super.start(self, action_settings, t, time_scale, action_start_params)

	local stop_current_action
	local vo_tags = action_settings.vo_tags
	local player_unit = self._player_unit
	local inventory_component = self._inventory_component
	local visual_loadout_extension = self._visual_loadout_extension
	local ability_template_tweak_data = self._ability_template_tweak_data
	local class_tag = ability_template_tweak_data.class_tag or "base"

	Luggable.drop_luggable(t, player_unit, inventory_component, visual_loadout_extension, true)

	local talent_extension = self._talent_extension
	local is_server = self._is_server

	if is_server then
		local increase_and_restore_toughness_to_coherency = talent_extension:has_special_rule(special_rules.veteran_combat_ability_increase_and_restore_toughness_to_coherency)

		if increase_and_restore_toughness_to_coherency then
			local coherency_extension = ScriptUnit.extension(player_unit, "coherency_system")

			for coherency_unit, _ in pairs(coherency_extension:in_coherence_units()) do
				local buff_extension = ScriptUnit.has_extension(coherency_unit, "buff_system")

				if buff_extension then
					buff_extension:add_internally_controlled_buff("veteran_combat_ability_increase_toughness_to_coherency", t, "owner_unit", player_unit)
				end
			end
		end

		if class_tag == "squad_leader" or class_tag == "shock_trooper" then
			local tougness_granted = Toughness.recover_max_toughness(player_unit, "ability_stance")

			self._ability_extension = ScriptUnit.extension(self._player_unit, "ability_system")

			local current_ability = self._ability_extension:get_current_ability_name()

			if tougness_granted > 0 and current_ability == "veteran_combat_ability_shout" then
				local source_player = player_unit and Managers.state.player_unit_spawn:owner(player_unit)

				if source_player then
					Managers.stats:record_private("hook_voice_of_command_toughness_given", source_player, tougness_granted)
				end
			end
		end
	end

	if vo_tags then
		Vo.play_combat_ability_event(player_unit, vo_tags[class_tag])
	end

	if stop_current_action then
		Interrupt.action(t, player_unit, "combat_ability", nil, true)
	end

	local wield_secondary = not not ability_template_tweak_data.wield_secondary_slot
	local reload_secondary = talent_extension:has_special_rule(special_rules.veteran_combat_ability_reloads_secondary_weapon)
	local slot_to_wield = "slot_secondary"

	if wield_secondary then
		local wielded_slot = inventory_component.wielded_slot

		if slot_to_wield ~= wielded_slot then
			local skip_wield_action = true

			PlayerUnitVisualLoadout.wield_slot(slot_to_wield, player_unit, t, skip_wield_action)

			local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
			local param_table = buff_extension:request_proc_event_param_table()

			if param_table then
				param_table.previously_wielded_slot = wielded_slot

				buff_extension:add_proc_event(proc_events.on_wield_ranged, param_table)
			end
		end
	end

	if reload_secondary then
		local weapon_action_component = self._unit_data_extension:read_component("weapon_action")
		local current_weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
		local _, current_action_settings = Action.current_action(weapon_action_component, current_weapon_template)
		local current_action_kind = current_action_settings and current_action_settings.kind

		if current_action_kind and reload_kinds[current_action_kind] then
			Interrupt.action(t, player_unit, "veteran_ability")
		end

		local inventory_slot_secondary_component = self._inventory_slot_secondary_component
		local missing_ammo_in_clip = Ammo.missing_ammo_in_clips(inventory_slot_secondary_component)

		Ammo.transfer_from_reserve_to_clip(inventory_slot_secondary_component, missing_ammo_in_clip)

		local weapon_template = visual_loadout_extension:weapon_template_from_slot(slot_to_wield)
		local reload_template = weapon_template.reload_template

		if reload_template then
			ReloadStates.reset(reload_template, inventory_slot_secondary_component)
		end
	end

	local stagger_nearby_enemies = talent_extension:has_special_rule(special_rules.veteran_combat_ability_stagger_nearby_enemies)
	local enter_stealth = talent_extension:has_special_rule(special_rules.veteran_combat_ability_stealth)
	local has_stance = not stagger_nearby_enemies and not enter_stealth

	if stagger_nearby_enemies then
		if is_server then
			local rotation = self._first_person_component.rotation
			local forward = Vector3.normalize(Vector3.flat(Quaternion.forward(rotation)))
			local radius = action_settings.radius
			local shout_target_template_name = self._ability_template_tweak_data.shout_target_template or action_settings.shout_target_template

			ShoutAbilityImplementation.execute(radius, shout_target_template_name, player_unit, t, self._locomotion_component, forward)
		end

		local source_name = action_settings.sound_source or "head"
		local sync_to_clients = action_settings.has_husk_sound
		local include_client = false

		table.clear(EXTERNAL_PROPERTIES)

		EXTERNAL_PROPERTIES.ability_template = self._ability.ability_template

		self._fx_extension:trigger_gear_wwise_event_with_source("ability_shout", EXTERNAL_PROPERTIES, source_name, sync_to_clients, include_client)

		self._combat_ability_component.active = true
	end

	local anim, anim_3p

	if stagger_nearby_enemies then
		anim, anim_3p = "ability_shout", "ability_shout"
	elseif enter_stealth then
		anim, anim_3p = "ability_cloak"
	else
		anim, anim_3p = "reload_end"
	end

	if anim or anim_3p then
		self:trigger_anim_event(anim, anim_3p)
	end

	local buff_extension = ScriptUnit.extension(player_unit, "buff_system")

	if has_stance then
		local increased_duration = talent_extension:has_special_rule(special_rules.veteran_combat_ability_ogryn_outlines)

		if increased_duration then
			buff_extension:add_internally_controlled_buff("veteran_combat_ability_stance_master_increased_duration", t)
		else
			buff_extension:add_internally_controlled_buff("veteran_combat_ability_stance_master", t)
		end
	end

	if action_settings then
		local param_table = buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.unit = player_unit

			buff_extension:add_proc_event(proc_events.on_combat_ability, param_table)
		end
	end
end

ActionVeteranCombatAbility.finish = function (self, reason, data, t, time_in_action, action_settings)
	ActionVeteranCombatAbility.super.finish(self, reason, data, t, time_in_action, action_settings)

	if self._weapon_actions_blocked then
		self._weapon_actions_blocked = nil

		local weapon_extension = ScriptUnit.extension(self._player_unit, "weapon_system")

		weapon_extension:unblock_actions("weapon_action")
	end

	self._combat_ability_component.active = false
end

return ActionVeteranCombatAbility
