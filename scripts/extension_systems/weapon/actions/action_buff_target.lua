-- chunkname: @scripts/extension_systems/weapon/actions/action_buff_target.lua

require("scripts/extension_systems/weapon/actions/action_ability_base")

local CoherencyUtils = require("scripts/extension_systems/coherency/coherency_utils")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
local Vo = require("scripts/utilities/vo")
local special_rules = SpecialRulesSetting.special_rules
local ActionBuffTarget = class("ActionBuffTarget", "ActionAbilityBase")

ActionBuffTarget.init = function (self, action_context, action_params, action_setting)
	ActionBuffTarget.super.init(self, action_context, action_params, action_setting)

	self._specialization_extension = ScriptUnit.extension(self._player_unit, "specialization_system")

	local unit_data_extension = self._unit_data_extension

	self._action_module_targeting_component = unit_data_extension:write_component("action_module_targeting")
end

ActionBuffTarget.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionBuffTarget.super.start(self, action_settings, t, time_scale, action_start_params)

	local _, self_cast = self:_get_target()
	local anim_event = self_cast and action_settings.self_cast_anim_event or action_settings.ally_anim_event

	self:trigger_anim_event(anim_event)

	local vo_tag = action_settings.vo_tag

	if vo_tag then
		Vo.play_combat_ability_event(self._player_unit, vo_tag)
	end

	local gear_sound_alias = action_settings.gear_sound_alias

	if gear_sound_alias then
		self._fx_extension:trigger_gear_wwise_event(gear_sound_alias)
	end

	self._spell_cast = false
end

ActionBuffTarget.fixed_update = function (self, dt, t, time_in_action)
	if self._unit_data_extension.is_resimulating then
		return
	end

	local action_settings = self._action_settings
	local cast_time = action_settings.cast_time

	if cast_time < time_in_action and not self._spell_cast then
		self._spell_cast = true

		local target_unit, self_cast = self:_get_target()
		local action_module_targeting_component = self._action_module_targeting_component

		action_module_targeting_component.target_unit_1 = nil
		action_module_targeting_component.target_unit_2 = nil
		action_module_targeting_component.target_unit_3 = nil

		if self._is_server then
			local has_override_buff_rule = self._specialization_extension:has_special_rule(special_rules.buff_target_buff_name_override_one)
			local has_override_buff_rule_two = self._specialization_extension:has_special_rule(special_rules.buff_target_buff_name_override_two)
			local buff_name = has_override_buff_rule and action_settings.override_buff_name_one or has_override_buff_rule_two and action_settings.override_buff_name_two or action_settings.buff_name
			local buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

			if buff_extension then
				buff_extension:add_internally_controlled_buff(buff_name, t)
			end

			local has_always_self_cast_rule = self._specialization_extension:has_special_rule(special_rules.buff_always_self_cast)

			if has_always_self_cast_rule and not self_cast then
				local own_buff_extension = self._buff_extension

				if own_buff_extension then
					own_buff_extension:add_internally_controlled_buff(buff_name, t)
				end
			end

			local has_coherency_cast_rule = self._specialization_extension:has_special_rule(special_rules.buff_coherency_units)

			if has_coherency_cast_rule then
				local coherency_buff_name = action_settings.coherency_buff_name

				CoherencyUtils.add_buff_to_all_in_coherency(target_unit, coherency_buff_name, t)
			end

			local restore_toughness = self._specialization_extension:has_special_rule(special_rules.buff_restore_coherency_toughness)

			if restore_toughness then
				local coherency_toughness = action_settings.coherency_toughness
				local coherency_extension = ScriptUnit.extension(self._player_unit, "coherency_system")
				local units_in_coherence = coherency_extension:in_coherence_units()

				for coherency_unit, _ in pairs(units_in_coherence) do
					Toughness.replenish_percentage(coherency_unit, coherency_toughness, false, "buff_restore_coherency_toughness")
				end
			end

			local has_revive_rule = self._specialization_extension:has_special_rule(special_rules.buff_revives_allies)

			if has_revive_rule then
				local unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
				local character_state_component = unit_data_extension:read_component("character_state")

				if character_state_component and PlayerUnitStatus.is_knocked_down(character_state_component) then
					local assisted_state_input_component = unit_data_extension:write_component("assisted_state_input")

					assisted_state_input_component.force_assist = true
				end
			end
		end
	end
end

ActionBuffTarget._get_target = function (self)
	local action_settings = self._action_settings
	local action_module_targeting_component = self._action_module_targeting_component
	local target_unit = action_module_targeting_component.target_unit_1
	local self_cast = action_settings.self_cast or not target_unit
	local target = self_cast and self._player_unit or target_unit

	return target, self_cast
end

return ActionBuffTarget
