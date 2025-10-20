-- chunkname: @scripts/managers/mutator/mutators/mutator_modify_havoc.lua

require("scripts/managers/mutator/mutators/mutator_base")

local MutatorModifyHavoc = class("MutatorModifyHavoc", "MutatorBase")

MutatorModifyHavoc.init = function (self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)
	MutatorModifyHavoc.super.init(self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)

	local template = self._template
	local init_modify_horde = template.init_modify_horde

	if self._is_server and init_modify_horde then
		Managers.state.game_mode:game_mode():extension("havoc"):init_horde_buff()
	end
end

return MutatorModifyHavoc
