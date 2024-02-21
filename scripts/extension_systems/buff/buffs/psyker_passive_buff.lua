require("scripts/extension_systems/buff/buffs/buff")

local PsykerBiomancerPassiveBuff = class("PsykerBiomancerPassiveBuff", "ProcBuff")

PsykerBiomancerPassiveBuff.visual_stack_count = function (self)
	local template_data = self._template_data
	local stack_count = template_data.talent_resource_component.current_resource

	return stack_count
end

return PsykerBiomancerPassiveBuff
