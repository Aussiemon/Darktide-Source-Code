-- chunkname: @scripts/extension_systems/weapon/actions/action_block.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local Block = require("scripts/utilities/attack/block")
local ActionBlock = class("ActionBlock", "ActionWeaponBase")

ActionBlock.init = function (self, action_context, ...)
	ActionBlock.super.init(self, action_context, ...)

	local unit_data_extension = action_context.unit_data_extension

	self._block_component = unit_data_extension:write_component("block")
	self._movement_state_component = unit_data_extension:write_component("movement_state")
	self._dodge_character_state_component = unit_data_extension:write_component("dodge_character_state")
end

ActionBlock.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionBlock.super.start(self, action_settings, t, time_scale, action_start_params)

	local perfect_block_ends_at_t = Block.start_block_action(t, self._block_component, action_settings.skip_update_perfect_blocking)

	self._perfect_block_ends_at_t = perfect_block_ends_at_t or self._perfect_block_ends_at_t

	if action_settings.can_jump ~= nil then
		self._movement_state_component.can_jump = action_settings.can_jump
	end

	if action_settings.can_crouch ~= nil then
		self._movement_state_component.can_crouch = action_settings.can_crouch
	end

	local weapon_lock_view_component = self._weapon_lock_view_component

	if weapon_lock_view_component and action_settings.force_look then
		weapon_lock_view_component.state = "force_look"

		local yaw, _, _ = self._input_extension:get_orientation()

		weapon_lock_view_component.yaw = yaw
		weapon_lock_view_component.pitch = 0
	end

	if action_settings.weapon_special then
		self._weapon_extension:set_wielded_weapon_weapon_special_active(t, true, "manual_toggle")
	end
end

ActionBlock.fixed_update = function (self, dt, t, time_in_action)
	local weapon_lock_view_component = self._weapon_lock_view_component
	local action_settings = self._action_settings
	local force_look = action_settings.force_look

	if force_look then
		local lock_view_at_time = action_settings.lock_view_at_time

		if lock_view_at_time and lock_view_at_time < time_in_action and weapon_lock_view_component.state == "force_look" then
			weapon_lock_view_component.state = "weapon_lock_no_lerp"
		end
	end

	if action_settings.disallow_dodging then
		self._dodge_character_state_component.cooldown = t + 0.1
	end

	if not action_settings.skip_update_perfect_blocking then
		Block.update_perfect_blocking(t, self._perfect_block_ends_at_t, self._block_component)
	end
end

ActionBlock.running_action_state = function (self, t, time_in_action)
	if self._block_component.has_blocked then
		return "has_blocked"
	end

	return nil
end

ActionBlock.finish = function (self, reason, data, t, time_in_action)
	ActionBlock.super.finish(self, reason, data, t)

	local stop_blocking = true

	if reason == "new_interrupting_action" then
		local new_action_kind = data.new_action_kind
		local want_push = new_action_kind == "push"
		local want_sweep = new_action_kind == "sweep"

		stop_blocking = not want_push
		stop_blocking = stop_blocking and not want_sweep
	end

	if stop_blocking then
		local block_component = self._block_component

		block_component.is_blocking = false
		block_component.has_blocked = false
		self._perfect_block_ends_at_t = nil
	end

	local action_settings = self._action_settings

	if action_settings.can_jump ~= nil then
		self._movement_state_component.can_jump = true
	end

	if action_settings.can_crouch ~= nil then
		self._movement_state_component.can_crouch = true
	end

	local weapon_lock_view_component = self._weapon_lock_view_component

	if weapon_lock_view_component and action_settings.force_look then
		weapon_lock_view_component.state = "in_active"
	end

	if action_settings.weapon_special then
		self._weapon_extension:set_wielded_weapon_weapon_special_active(t, false, "manual_toggle")
	end

	if action_settings.disallow_dodging then
		self._dodge_character_state_component.cooldown = t
	end
end

return ActionBlock
