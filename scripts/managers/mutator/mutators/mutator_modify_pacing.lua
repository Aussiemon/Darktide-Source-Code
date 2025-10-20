-- chunkname: @scripts/managers/mutator/mutators/mutator_modify_pacing.lua

require("scripts/managers/mutator/mutators/mutator_base")

local MutatorModifyPacing = class("MutatorModifyPacing", "MutatorBase")

MutatorModifyPacing.init = function (self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)
	MutatorModifyPacing.super.init(self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)

	local template = self._template
	local init_modify_pacing = template.init_modify_pacing

	if self._is_server and init_modify_pacing then
		Managers.state.pacing:add_pacing_modifiers(init_modify_pacing)
	end

	local client_dummy_challenge = template.client_dummy_challenge

	if client_dummy_challenge then
		local dummy_challenge = Managers.state.difficulty:get_table_entry_by_challenge(client_dummy_challenge)

		Managers.state.difficulty:set_dummy_challenge(dummy_challenge)
	end
end

MutatorModifyPacing.on_gameplay_post_init = function (self, level, themes)
	local template = self._template
	local modify_pacing_settings = template.modify_pacing

	if self._is_server and modify_pacing_settings then
		Managers.state.pacing:add_pacing_modifiers(modify_pacing_settings)
	end
end

return MutatorModifyPacing
