-- chunkname: @scripts/managers/mutator/mutators/mutator_stat_trigger/mutator_stat_trigger_per_count.lua

require("scripts/managers/mutator/mutators/mutator_stat_trigger/mutator_stat_trigger_base")

local MutatorStatTriggerPerCount = class("MutatorStatTriggerPerCount", "MutatorStatTriggerBase")

MutatorStatTriggerPerCount.init = function (self, triggers, trigger_amount, trigger_once)
	MutatorStatTriggerPerCount.super.init(self, triggers)

	self._trigger_amount = trigger_amount
	self._trigger_once = trigger_once
end

MutatorStatTriggerPerCount._reset = function (self)
	MutatorStatTriggerPerCount.super._reset(self)

	self._did_trigger = false
end

MutatorStatTriggerPerCount._should_trigger = function (self)
	if self._trigger_once and self._did_trigger then
		return false
	end

	return self._tracked_stat_value >= self._trigger_amount
end

MutatorStatTriggerPerCount._trigger = function (self, mutator, caused_by_player)
	MutatorStatTriggerPerCount.super._trigger(self, mutator, caused_by_player)

	self._did_trigger = true
	self._tracked_stat_value = self._tracked_stat_value - self._trigger_amount
end

return MutatorStatTriggerPerCount
