-- chunkname: @scripts/extension_systems/ability/actions/action_cryptic_chordclaw.lua

require("scripts/extension_systems/weapon/actions/action_ability_base")

local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local Luggable = require("scripts/utilities/luggable")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local Vo = require("scripts/utilities/vo")
local BROADPHASE_RESULTS = {}
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local attack_types = AttackSettings.attack_types
local proc_events = BuffSettings.proc_events
local cryptic_talent_settings = TalentSettings.cryptic
local chordclaw_ability_talent_settings = cryptic_talent_settings.chordclaw_ability
local special_rules = SpecialRulesSettings.special_rules
local ActionCrypticChordclaw = class("ActionCrypticChordclaw", "ActionAbilityBase")
local external_properties = {}

ActionCrypticChordclaw.init = function (self, action_context, action_params, action_settings)
	ActionCrypticChordclaw.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension

	self._unit_data_extension = unit_data_extension
	self._character_sate_component = unit_data_extension:read_component("character_state")
	self._combat_ability_component = unit_data_extension:write_component("combat_ability")
	self._lunge_character_state_component = unit_data_extension:read_component("lunge_character_state")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._talent_extension = ScriptUnit.extension(self._player_unit, "talent_system")
end

ActionCrypticChordclaw.start = function (self, action_settings, t, time_scale, action_start_params)
	local inventory_component = self._inventory_component

	if inventory_component.wielded_slot ~= "slot_combat_ability" then
		return
	end

	ActionCrypticChordclaw.super.start(self, action_settings, t, time_scale, action_start_params)

	local ability_template_tweak_data = self._ability_template_tweak_data
	local ability_extension = self._ability_extension
	local buff_extension = self._buff_extension
	local visual_loadout_extension = self._visual_loadout_extension
	local locomotion_component = self._locomotion_component
	local lunge_character_state_component = self._lunge_character_state_component
	local locomotion_position = locomotion_component.position
	local player_position = locomotion_position
	local player_unit = self._player_unit
	local talent_extension = self._talent_extension
	local charges_used = self._ability_charges_used_at_start

	Luggable.drop_luggable(t, player_unit, inventory_component, visual_loadout_extension, true)

	local vo_tag = action_settings.vo_tag

	Vo.play_combat_ability_event(player_unit, vo_tag)
	table.clear(external_properties)

	local ability = self._ability

	external_properties.ability_template = ability and ability.ability_template

	local has_chordclaw_gives_chordclaw_damage_on_use = talent_extension:has_special_rule("cryptic_chordclaw_gives_chordclaw_damage_on_use")

	if has_chordclaw_gives_chordclaw_damage_on_use then
		buff_extension:add_internally_controlled_buff("cryptic_chordclaw_consecutive_bonus", t)
	end

	local has_three_charge_bonus_talent = talent_extension:has_special_rule("cryptic_chordclaw_gives_melee_attacks_speed_and_toughness")

	if has_three_charge_bonus_talent and charges_used >= chordclaw_ability_talent_settings.three_charge_bonus.num_charges_used_required then
		buff_extension:add_internally_controlled_buff("cryptic_chordclaw_melee_attack_speed_and_toughness_damage_taken", t)
	end

	if not self._combat_ability_component.active then
		buff_extension:add_internally_controlled_buff("cryptic_chordclaw", t)

		local buff_to_add = ability_template_tweak_data.buff_to_add
		local charge_based_buffs_to_add = ability_template_tweak_data.charge_based_buffs_to_add

		if charge_based_buffs_to_add then
			buff_to_add = charge_based_buffs_to_add[charges_used]
		end

		if buff_to_add then
			buff_extension:add_internally_controlled_buff(buff_to_add, t)
		end

		local param_table = buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.unit = player_unit
			param_table.ability_charges_used = charges_used
			param_table.remaining_ability_charges_before_use = self._remaining_ability_charges_before_use_at_start

			buff_extension:add_proc_event(proc_events.on_combat_ability, param_table)
		end
	end

	self._combat_ability_component.active = true
end

ActionCrypticChordclaw.fixed_update = function (self, dt, t, time_in_action)
	return true
end

ActionCrypticChordclaw.finish = function (self, reason, data, t, time_in_action, action_settings)
	return
end

return ActionCrypticChordclaw
