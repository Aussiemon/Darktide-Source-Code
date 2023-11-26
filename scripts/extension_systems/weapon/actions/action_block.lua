-- chunkname: @scripts/extension_systems/weapon/actions/action_block.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local ForceLookRotation = require("scripts/extension_systems/first_person/utilities/force_look_rotation")
local ActionBlock = class("ActionBlock", "ActionWeaponBase")
local PI = math.pi

ActionBlock.init = function (self, action_context, ...)
	ActionBlock.super.init(self, action_context, ...)

	local unit_data_extension = action_context.unit_data_extension

	self._block_component = unit_data_extension:write_component("block")
	self._movement_state_component = unit_data_extension:write_component("movement_state")
	self._dodge_character_state_component = unit_data_extension:write_component("dodge_character_state")
end

ActionBlock.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionBlock.super.start(self, action_settings, t, time_scale, action_start_params)

	self._block_component.is_blocking = true
	self._block_component.has_blocked = false
	self._block_component.is_perfect_blocking = true
	self._perfect_block_duration = 0.3

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
		self:_set_weapon_special(true, t)
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

	local action_settings = self._action_settings

	if action_settings.disallow_dodging then
		self._dodge_character_state_component.cooldown = t + 0.1
	end

	if self._perfect_block_duration then
		self._perfect_block_duration = self._perfect_block_duration - dt

		if self._perfect_block_duration <= 0 then
			self._block_component.is_perfect_blocking = false
			self._perfect_block_duration = nil
		end
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

	local will_do_push = reason == "new_interrupting_action" and data.new_action_kind == "push"

	if not will_do_push then
		self._block_component.is_blocking = false
		self._block_component.has_blocked = false
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
		self:_set_weapon_special(false, t)
	end

	if action_settings.disallow_dodging then
		self._dodge_character_state_component.cooldown = t
	end
end

return ActionBlock
