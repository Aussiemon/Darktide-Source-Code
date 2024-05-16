-- chunkname: @scripts/utilities/attack/interrupt.lua

local ActionAvailability = require("scripts/extension_systems/weapon/utilities/action_availability")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local WeaponSpecial = require("scripts/utilities/weapon_special")
local buff_keywords = BuffSettings.keywords
local Interrupt = {}
local _is_interrupt_immune_from_buff

Interrupt.ability = function (t, unit, reason, reason_data_or_nil, ignore_immunity)
	if not ignore_immunity and _is_interrupt_immune_from_buff(unit) then
		return
	end

	local ability_extension = ScriptUnit.extension(unit, "ability_system")

	ability_extension:stop_action(reason, reason_data_or_nil, t)
end

Interrupt.action = function (t, unit, reason, reason_data_or_nil, ignore_immunity)
	if not ignore_immunity and _is_interrupt_immune_from_buff(unit) then
		return
	end

	local weapon_extension = ScriptUnit.extension(unit, "weapon_system")
	local action_settings = weapon_extension:running_action_settings()
	local sprinting = reason and reason == "started_sprint"
	local allow_chain_input_from_stop_reason = true

	if sprinting and action_settings then
		local buff_extension = ScriptUnit.has_extension(unit, "buff_system")
		local allowed_during_sprint, buff_keyword_allows_action_during_sprint = ActionAvailability.available_in_sprint(action_settings, buff_extension)
		local sprint_requires_press_to_interrupt = not buff_keyword_allows_action_during_sprint and Sprint.requires_press_to_interrupt(action_settings, buff_extension)
		local no_interruption_for_sprint = Sprint.no_interruption_for_sprint(action_settings, buff_extension)

		if (not allowed_during_sprint or sprint_requires_press_to_interrupt) and not no_interruption_for_sprint then
			weapon_extension:stop_action(reason, reason_data_or_nil, t, allow_chain_input_from_stop_reason)
		end
	else
		weapon_extension:stop_action(reason, reason_data_or_nil, t, allow_chain_input_from_stop_reason)
	end

	local weapon_template = weapon_extension:weapon_template()

	if weapon_template and not weapon_template.allow_sprinting_with_special then
		WeaponSpecial.disable(unit)
	end
end

Interrupt.ability_and_action = function (t, unit, reason, reason_data_or_nil, ignore_immunity)
	Interrupt.ability(t, unit, reason, reason_data_or_nil, ignore_immunity)
	Interrupt.action(t, unit, reason, reason_data_or_nil, ignore_immunity)
end

function _is_interrupt_immune_from_buff(unit)
	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	if not buff_extension then
		return false
	end

	return buff_extension:has_keyword(buff_keywords.uninterruptible)
end

return Interrupt
