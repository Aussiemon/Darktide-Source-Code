-- chunkname: @scripts/extension_systems/weapon/actions/action_buff_target.lua

require("scripts/extension_systems/weapon/actions/action_ability_base")

local Vo = require("scripts/utilities/vo")
local ActionBuffTarget = class("ActionBuffTarget", "ActionAbilityBase")

ActionBuffTarget.init = function (self, action_context, action_params, action_setting)
	ActionBuffTarget.super.init(self, action_context, action_params, action_setting)

	self._talent_extension = ScriptUnit.extension(self._player_unit, "talent_system")

	local unit_data_extension = self._unit_data_extension

	self._action_module_target_finder_component = unit_data_extension:write_component("action_module_target_finder")
end

ActionBuffTarget.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionBuffTarget.super.start(self, action_settings, t, time_scale, action_start_params)

	local _, self_cast = self:_get_target()
	local anim_event = self_cast and action_settings.self_cast_anim_event or action_settings.ally_anim_event

	if anim_event then
		self:trigger_anim_event(anim_event)
	end

	local vo_tag = action_settings.vo_tag

	if vo_tag then
		Vo.play_combat_ability_event(self._player_unit, vo_tag)
	end

	local gear_sound_alias = action_settings.gear_sound_alias

	if gear_sound_alias then
		self._fx_extension:trigger_gear_wwise_event(gear_sound_alias)
	end
end

ActionBuffTarget.fixed_update = function (self, dt, t, time_in_action)
	if self._unit_data_extension.is_resimulating then
		return
	end

	local action_settings = self._action_settings
	local total_time = action_settings.total_time

	if total_time < time_in_action then
		local target_unit, self_cast = self:_get_target()

		if self._is_server then
			local buff_name = action_settings.buff_name
			local buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

			if buff_extension then
				buff_extension:add_internally_controlled_buff(buff_name, t)
			end
		end
	end
end

ActionBuffTarget._get_target = function (self)
	local action_settings = self._action_settings
	local action_module_target_finder_component = self._action_module_target_finder_component
	local target_unit = action_module_target_finder_component.target_unit_1
	local self_cast = action_settings.self_cast or not target_unit
	local target = self_cast and self._player_unit or target_unit

	return target, self_cast
end

return ActionBuffTarget
