require("scripts/extension_systems/weapon/actions/action_base")

local ActionUtility = require("scripts/extension_systems/weapon/actions/utilities/action_utility")
local ActionRecall = class("ActionRecall", "ActionWeaponBase")

ActionRecall.init = function (self, action_context, action_params, action_settings)
	ActionRecall.super.init(self, action_context, action_params, action_settings)

	self._action_settings = action_settings
	self._ability_extension = action_context.ability_extension
	self._ability_extension = action_context.ability_extension
	local unit_data_extension = action_context.unit_data_extension
	self._action_component = unit_data_extension:write_component("action_shoot")
	self._warp_charge_component = unit_data_extension:write_component("warp_charge")
	local weapon = action_params.weapon
	self._muzzle_fx_source_name = weapon.fx_sources._muzzle
end

ActionRecall.start = function (self, action_settings, t, ...)
	ActionRecall.super.start(self, action_settings, t, ...)

	local weapon_tweak_templates_component = self._weapon_tweak_templates_component
	local weapon_template = self._weapon_template
	weapon_tweak_templates_component.charge_template_name = action_settings.charge_template or weapon_template.charge_template or "none"
end

ActionRecall._restore_ability_charge = function (self, ability_type, num_charges_restored)
	local ability_extension = self._ability_extension

	ability_extension:restore_ability_charge(ability_type, num_charges_restored)
end

ActionRecall.fixed_update = function (self, dt, t, time_in_action)
	local action_settings = self._action_settings
	local ability_type = action_settings.ability_type
	local first_recall_time = action_settings.first_recall_time
	local subsequent_recall_time = action_settings.subsequent_recall_time
	local trigger_catch = ActionUtility.is_within_trigger_time(time_in_action, dt, first_recall_time, subsequent_recall_time)

	if trigger_catch then
		local catch_anim_event = action_settings.anim_catch_event
		local catch_anim_event_3p = action_settings.anim_catch_event_ or catch_anim_event

		self:trigger_anim_event(catch_anim_event, catch_anim_event_3p)

		local num_charges_restored = action_settings.num_charges_restored

		if ability_type and num_charges_restored then
			self:_restore_ability_charge(ability_type, num_charges_restored)
		end

		local charge_template = action_settings.charge_template

		if charge_template then
			self:_pay_warp_charge_cost(t)
		end
	end
end

ActionRecall.finish = function (self, reason, data, t, time_in_action)
	local action_settings = self._action_settings
	local ability_type = action_settings.ability_type
	local ability_extension = self._ability_extension
	local have_charges = ability_extension:can_use_ability(ability_type)
	local anim_to_ammo_event = action_settings.anim_to_ammo_event

	if have_charges and anim_to_ammo_event then
		local anim_to_ammo_event_3p = action_settings.anim_to_ammo_event_p3 or anim_to_ammo_event

		self:trigger_anim_event(anim_to_ammo_event, anim_to_ammo_event_3p)
	end
end

ActionRecall.running_action_state = function (self, t, time_in_action)
	local action_settings = self._action_settings
	local ability_extension = self._ability_extension
	local ability_type = action_settings.ability_type
	local max = ability_extension:max_ability_charges(ability_type)
	local remaining = ability_extension:remaining_ability_charges(ability_type)
	local is_at_max = max <= remaining

	if is_at_max then
		return "fully_recalled"
	end

	return nil
end

return ActionRecall
