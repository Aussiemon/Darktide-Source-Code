-- chunkname: @scripts/managers/mutator/mutators/mutator_modify_havoc.lua

require("scripts/managers/mutator/mutators/mutator_base")

local MutatorModifyHavoc = class("MutatorModifyHavoc", "MutatorBase")

MutatorModifyHavoc.init = function (self, is_server, network_event_delegate, mutator_template)
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate
	self._is_active = false
	self._buffs = {}
	self._template = mutator_template

	local template = self._template
	local init_modify_horde = template.init_modify_horde

	if self._is_server and init_modify_horde then
		Managers.state.havoc:init_horde_buff(init_modify_horde)
	end
end

return MutatorModifyHavoc
