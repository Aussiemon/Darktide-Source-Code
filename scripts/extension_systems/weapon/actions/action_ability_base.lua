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
	self._ability_charges_used_at_start = 0
	self._ability_charges_used_at_finish = 0
	self._remaining_ability_charges_before_use_at_start = 0
	self._remaining_ability_charges_before_use_at_finish = 0
end

ActionAbilityBase.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionAbilityBase.super.start(self, action_settings, t, time_scale, action_start_params)

	local ability_extension = self._ability_extension
	local ability_type = action_settings.ability_type

	self._remaining_ability_charges_before_use_at_start = ability_extension:remaining_ability_charges(ability_type) or 0

	local use_ability_charge = self._ability_template_tweak_data.use_ability_charge == nil and action_settings.use_ability_charge or self._ability_template_tweak_data.use_ability_charge

	if use_ability_charge and action_settings.use_charge_at_start then
		local ability_charges_used = self:_use_ability_charge()

		self._ability_charges_used_at_start = ability_charges_used

		if self._is_server then
			Managers.stats:record_private("hook_ability_charges_used_from_action", self._player, ability_type, ability_charges_used)
		end
	end

	if self._ability_pause_cooldown_setting then
		self._ability_component.cooldown_paused = true
	end
end

ActionAbilityBase.finish = function (self, reason, data, t, time_in_action)
	ActionAbilityBase.super.finish(self, reason, data, t, time_in_action)

	local action_settings = self._action_settings

	if action_settings then
		local use_ability_charge = self._ability_template_tweak_data.use_ability_charge == nil and action_settings.use_ability_charge or self._ability_template_tweak_data.use_ability_charge
		local should_use_charge = not action_settings.use_charge_at_start

		if use_ability_charge and should_use_charge then
			local ability_extension = self._ability_extension
			local ability_type = action_settings.ability_type

			self._remaining_ability_charges_before_use_at_finish = ability_extension:remaining_ability_charges(ability_type)

			local ability_charges_used = self:_use_ability_charge()

			self._ability_charges_used_at_finish = ability_charges_used

			if self._is_server then
				Managers.stats:record_private("hook_ability_charges_used_from_action", self._player, action_settings.ability_type, ability_charges_used)
			end
		end
	end
end

return ActionAbilityBase
