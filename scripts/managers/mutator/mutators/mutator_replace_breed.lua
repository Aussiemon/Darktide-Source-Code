-- chunkname: @scripts/managers/mutator/mutators/mutator_replace_breed.lua

require("scripts/managers/mutator/mutators/mutator_base")

local MutatorReplaceBreed = class("MutatorReplaceBreed", "MutatorBase")

MutatorReplaceBreed.init = function (self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)
	MutatorReplaceBreed.super.init(self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)

	local template = self._template
	local init_replacement_breed = template.init_replacement_breed

	if self._is_server and init_replacement_breed then
		Managers.state.minion_spawn:mutator_breed_init(init_replacement_breed)
	end
end

return MutatorReplaceBreed
