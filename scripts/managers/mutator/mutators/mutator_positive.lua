-- chunkname: @scripts/managers/mutator/mutators/mutator_positive.lua

require("scripts/managers/mutator/mutators/mutator_base")

local MutatorPositive = class("MutatorPositive", "MutatorBase")

MutatorPositive.init = function (self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)
	MutatorPositive.super.init(self, is_server, network_event_delegate, mutator_template, nav_world, world, level_seed)
end

MutatorPositive.on_gameplay_post_init = function (self, level, themes)
	return
end

return MutatorPositive
