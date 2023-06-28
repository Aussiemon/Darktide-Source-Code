require("scripts/extension_systems/buff/buffs/buff")

local ZealotManiacPassiveBuff = class("ZealotManiacPassiveBuff", "Buff")

ZealotManiacPassiveBuff.visual_stack_count = function (self)
	local template_data = self._template_data
	local stack_count = template_data.current_stacks or 0

	return stack_count
end

return ZealotManiacPassiveBuff
