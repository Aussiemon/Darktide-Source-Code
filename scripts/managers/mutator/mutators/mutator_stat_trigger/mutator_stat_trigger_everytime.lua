-- chunkname: @scripts/managers/mutator/mutators/mutator_stat_trigger/mutator_stat_trigger_everytime.lua

require("scripts/managers/mutator/mutators/mutator_stat_trigger/mutator_stat_trigger_base")

local MutatorStatTriggerEverytime = class("MutatorStatsTriggerEverytime", "MutatorStatTriggerBase")

MutatorStatTriggerEverytime._should_trigger = function (self)
	return true
end

return MutatorStatTriggerEverytime
