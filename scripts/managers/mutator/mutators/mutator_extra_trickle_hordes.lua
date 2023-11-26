-- chunkname: @scripts/managers/mutator/mutators/mutator_extra_trickle_hordes.lua

require("scripts/managers/mutator/mutators/mutator_base")

local MutatorExtraTrickleHordes = class("MutatorExtraTrickleHordes", "MutatorBase")

MutatorExtraTrickleHordes.on_gameplay_post_init = function (self, level, themes)
	local template = self._template
	local trickle_horde_templates = template.trickle_horde_templates

	if self._is_server and trickle_horde_templates then
		for i = 1, #trickle_horde_templates do
			local trickle_horde_template = trickle_horde_templates[i]

			Managers.state.pacing:add_trickle_horde(trickle_horde_template)
		end
	end
end

return MutatorExtraTrickleHordes
