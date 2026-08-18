-- chunkname: @scripts/extension_systems/weapon/actions/action_cryptic_chordclaw_activation.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local BuffSettings = require("scripts/settings/buff/buff_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local proc_events = BuffSettings.proc_events
local cryptic_talent_settings = TalentSettings.cryptic
local chordclaw_ability_talent_settings = cryptic_talent_settings.chordclaw_ability
local ActionCrypticChordclawActivation = class("ActionCrypticChordclawActivation", "ActionWeaponBase")

ActionCrypticChordclawActivation.init = function (self, action_context, action_params, action_settings)
	ActionCrypticChordclawActivation.super.init(self, action_context, action_params, action_settings)

	self._ability_type = "combat_ability"

	local player_unit = action_context.player_unit
	local unit_data_extension = action_context.unit_data_extension

	self._buff_extension = ScriptUnit.extension(player_unit, "buff_system")
	self._talent_extension = ScriptUnit.extension(player_unit, "talent_system")
	self._combat_ability_component = unit_data_extension:write_component("combat_ability")
end

ActionCrypticChordclawActivation.start = function (self, dt, t, time_in_action, frame)
	ActionCrypticChordclawActivation.super.start(self, dt, t, time_in_action, frame)

	local player_unit = self._player_unit
	local ability_type = self._ability_type
	local ability_extension = self._ability_extension
	local talent_extension = self._talent_extension
	local buff_extension = self._buff_extension

	self._remaining_ability_charges_before_use_at_start = ability_extension:remaining_ability_charges(ability_type) or 0

	local ability_charges_used = ability_extension:use_ability_charge(ability_type)

	self._ability_charges_used_at_start = ability_charges_used

	if self._is_server then
		Managers.stats:record_private("hook_ability_charges_used_from_action", self._player, ability_type, ability_charges_used)
	end

	local has_chordclaw_gives_chordclaw_damage_on_use = talent_extension:has_special_rule("cryptic_chordclaw_gives_chordclaw_damage_on_use")

	if has_chordclaw_gives_chordclaw_damage_on_use then
		buff_extension:add_internally_controlled_buff("cryptic_chordclaw_consecutive_bonus", t)
	end

	local has_three_charge_bonus_talent = talent_extension:has_special_rule("cryptic_chordclaw_gives_melee_attacks_speed_and_toughness")

	if has_three_charge_bonus_talent and ability_charges_used >= chordclaw_ability_talent_settings.three_charge_bonus.num_charges_used_required then
		buff_extension:add_internally_controlled_buff("cryptic_chordclaw_melee_attack_speed_and_toughness_damage_taken", t)
	end

	if not self._combat_ability_component.active then
		buff_extension:add_internally_controlled_buff("cryptic_chordclaw", t)

		local param_table = buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.unit = player_unit
			param_table.ability_charges_used = ability_charges_used
			param_table.remaining_ability_charges_before_use = self._remaining_ability_charges_before_use_at_start

			buff_extension:add_proc_event(proc_events.on_combat_ability, param_table)
		end
	end

	self._combat_ability_component.active = true
end

return ActionCrypticChordclawActivation
