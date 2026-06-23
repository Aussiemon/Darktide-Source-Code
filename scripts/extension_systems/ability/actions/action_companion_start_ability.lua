-- chunkname: @scripts/extension_systems/ability/actions/action_companion_start_ability.lua

require("scripts/extension_systems/weapon/actions/action_ability_base")

local AbilityTemplates = require("scripts/settings/ability/ability_templates/ability_templates")
local ActionCompanionStartAbility = class("ActionCompanionStartAbility", "ActionAbilityBase")

ActionCompanionStartAbility.init = function (self, action_context, action_params, action_settings)
	ActionCompanionStartAbility.super.init(self, action_context, action_params, action_settings)

	self._weapon_extension = action_context.weapon_extension

	local ability = action_params.ability
	local ability_template_name = ability and ability.ability_template
	local ability_template = ability_template_name and AbilityTemplates[ability_template_name]
	local module_target_component_name = ability_template.module_target_component_name or "action_module_target_finder"
	local unit_data_extension = ScriptUnit.extension(self._player_unit, "unit_data_system")

	self._action_module_target_finder_component = unit_data_extension:write_component(module_target_component_name)
	self._action_module_position_finder_component = unit_data_extension:write_component("action_module_position_finder")
end

ActionCompanionStartAbility.start = function (self, action_settings, t, ...)
	ActionCompanionStartAbility.super.start(self, action_settings, t, ...)
	action_settings.ability_function(self._action_module_target_finder_component, self._action_module_position_finder_component, self._player_unit, self._is_server)
end

return ActionCompanionStartAbility
