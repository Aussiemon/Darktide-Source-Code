require("scripts/extension_systems/weapon/actions/action_weapon_base")

local ActionBlock = class("ActionBlock", "ActionWeaponBase")

ActionBlock.init = function (self, action_context, ...)
	ActionBlock.super.init(self, action_context, ...)

	self._block_component = action_context.unit_data_extension:write_component("block")
end

ActionBlock.start = function (self, ...)
	ActionBlock.super.start(self, ...)

	self._block_component.is_blocking = true
	self._block_component.has_blocked = false
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
end

return ActionBlock
