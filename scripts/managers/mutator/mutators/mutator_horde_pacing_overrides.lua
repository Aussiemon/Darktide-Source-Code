-- chunkname: @scripts/managers/mutator/mutators/mutator_horde_pacing_overrides.lua

require("scripts/managers/mutator/mutators/mutator_base")

local HordePacingTemplates = require("scripts/managers/pacing/horde_pacing/horde_pacing_templates")
local MutatorHordePacingOverride = class("MutatorHordePacingOverride", "MutatorBase")

MutatorHordePacingOverride.init = function (self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)
	MutatorHordePacingOverride.super.init(self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)

	local template = self._template
	local pacing_override = template.pacing_override
	local template_name = template.template_name
	local templates = HordePacingTemplates[template_name].resistance_templates[pacing_override]

	self._pacing_override = templates

	if self._is_server and self._pacing_override then
		Managers.state.pacing:override_horde_pacing(self._pacing_override)
	end
end

MutatorHordePacingOverride.horde_pacing_override = function (self)
	return self._pacing_override
end

return MutatorHordePacingOverride
