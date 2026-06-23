-- chunkname: @scripts/extension_systems/ability/actions/action_cryptic_chordclaw_charge.lua

require("scripts/extension_systems/ability/actions/action_targeted_dash_aim")

local Luggable = require("scripts/utilities/luggable")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local special_rules = SpecialRulesSettings.special_rules
local chordclaw_ability_talent_settings = TalentSettings.cryptic.chordclaw_ability
local ActionCrypticChordclawCharge = class("ActionCrypticChordclawCharge", "ActionAbilityBase")

ActionCrypticChordclawCharge.init = function (self, action_context, action_params, action_setting)
	ActionCrypticChordclawCharge.super.init(self, action_context, action_params, action_setting)
end

ActionCrypticChordclawCharge.start = function (self, action_settings, t, time_scale, action_start_params)
	local player_unit = self._player_unit
	local inventory_component = self._inventory_component
	local visual_loadout_extension = self._visual_loadout_extension

	if Luggable.is_carrying_luggable(t, player_unit, inventory_component, visual_loadout_extension) then
		Luggable.drop_luggable(t, player_unit, inventory_component, visual_loadout_extension, true)
		PlayerUnitVisualLoadout.wield_slot("slot_combat_ability", player_unit, t)
	end

	ActionCrypticChordclawCharge.super.start(self, action_settings, t, time_scale, action_start_params)
end

ActionCrypticChordclawCharge.finish = function (self, reason, data, t, time_in_action)
	ActionCrypticChordclawCharge.super.finish(self, reason, data, t, time_in_action)
end

return ActionCrypticChordclawCharge
