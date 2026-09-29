-- chunkname: @scripts/extension_systems/weapon/actions/action_ability_base.lua

require("scripts/extension_systems/weapon/actions/action_base")

local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local ActionAbilityBase = class("ActionAbilityBase", "ActionBase")

ActionAbilityBase.init = function (self, action_context, action_params, action_settings)
	ActionAbilityBase.super.init(self, action_context, action_params, action_settings)

	local ability = action_params.ability or {}

	self._ability = ability
	self._ability_template_tweak_data = ability.ability_template_tweak_data or {}
	self._ability_pause_cooldown_setting = ability.pause_cooldown_settings
	self._ability_component = action_params.ability_component
	self._weapon_extension = action_context.weapon_extension
	self._ability_extension = action_context.ability_extension
	self._ability_cost_at_start = 0
	self._ability_cost_at_finish = 0
	self._remaining_ability_charges_before_use_at_start = 0
	self._remaining_ability_charges_before_use_at_finish = 0
end

ActionAbilityBase.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionAbilityBase.super.start(self, action_settings, t, time_scale, action_start_params)

	local ability_type = self._ability_type
	local ability_extension = self._ability_extension

	self._remaining_ability_charges_before_use_at_start = ability_extension:remaining_ability_charges(ability_type) or 0

	local consume_ability_usage_cost = self._ability_template_tweak_data.consume_ability_usage_cost == nil and action_settings.consume_ability_usage_cost or self._ability_template_tweak_data.consume_ability_usage_cost

	if consume_ability_usage_cost and action_settings.consume_usage_cost_at_start then
		local target_cost, _ = self:_consume_ability_usage_cost()

		self._ability_cost_at_start = target_cost
	end

	if self._ability_pause_cooldown_setting then
		self._ability_extension:pause_ability_resource_regen(ability_type)
	end
end

ActionAbilityBase.finish = function (self, reason, data, t, time_in_action)
	ActionAbilityBase.super.finish(self, reason, data, t, time_in_action)

	local action_settings = self._action_settings

	if action_settings then
		local consume_ability_usage_cost = self._ability_template_tweak_data.consume_ability_usage_cost == nil and action_settings.consume_ability_usage_cost or self._ability_template_tweak_data.consume_ability_usage_cost
		local should_use_charge = not action_settings.consume_usage_cost_at_start

		if consume_ability_usage_cost and should_use_charge then
			local ability_extension = self._ability_extension

			self._remaining_ability_charges_before_use_at_finish = ability_extension:remaining_ability_charges(self._ability_type)

			local target_cost, actual_consumption = self:_consume_ability_usage_cost()

			self._ability_cost_at_finish = target_cost
		end
	end
end

return ActionAbilityBase
