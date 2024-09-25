-- chunkname: @scripts/extension_systems/weapon/actions/action_toggle_weapon_special_with_block.lua

require("scripts/extension_systems/weapon/actions/action_toggle_weapon_special")

local Block = require("scripts/utilities/attack/block")
local ActionToggleWeaponSpecialWithBlock = class("ActionToggleWeaponSpecialWithBlock", "ActionToggleWeaponSpecial")

ActionToggleWeaponSpecialWithBlock.init = function (self, action_context, action_params, action_settings)
	ActionToggleWeaponSpecialWithBlock.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension

	self._block_component = unit_data_extension:write_component("block")
end

ActionToggleWeaponSpecialWithBlock.start = function (self, action_settings, t, ...)
	self._perfect_block_ends_at_t = Block.start_block_action(t, self._block_component)

	ActionToggleWeaponSpecialWithBlock.super.start(self, action_settings, t, ...)
end

ActionToggleWeaponSpecialWithBlock.fixed_update = function (self, dt, t, time_in_action)
	local action_settings = self._action_settings
	local block_component = self._block_component

	if block_component.is_blocking then
		Block.update_perfect_blocking(t, self._perfect_block_ends_at_t, self._block_component)

		local is_block_ended = not action_settings.block_duration or time_in_action >= action_settings.block_duration

		if is_block_ended then
			block_component.is_blocking = false
		end
	end

	ActionToggleWeaponSpecialWithBlock.super.fixed_update(self, dt, t, time_in_action)
end

ActionToggleWeaponSpecialWithBlock.finish = function (self, reason, data, t, time_in_action)
	self._block_component.is_blocking = false

	ActionToggleWeaponSpecialWithBlock.super.finish(self, reason, data, t, time_in_action)
end

return ActionToggleWeaponSpecialWithBlock
