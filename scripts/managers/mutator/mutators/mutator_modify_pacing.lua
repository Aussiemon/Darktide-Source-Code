require("scripts/managers/mutator/mutators/mutator_base")

local MutatorModifyPacing = class("MutatorModifyPacing", "MutatorBase")

MutatorModifyPacing.on_gameplay_post_init = function (self, level, themes)
	local template = self._template
	local modify_pacing_settings = template.modify_pacing

	if self._is_server and modify_pacing_settings then
		Managers.state.pacing:add_pacing_modifiers(modify_pacing_settings)
	end
end

return MutatorModifyPacing
