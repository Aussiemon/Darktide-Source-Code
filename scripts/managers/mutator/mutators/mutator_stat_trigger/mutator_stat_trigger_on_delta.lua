-- chunkname: @scripts/managers/mutator/mutators/mutator_stat_trigger/mutator_stat_trigger_on_delta.lua

require("scripts/managers/mutator/mutators/mutator_stat_trigger/mutator_stat_trigger_base")

local MutatorStatTriggerOnDelta = class("MutatorStatTriggerOnDelta", "MutatorStatTriggerBase")

MutatorStatTriggerOnDelta.init = function (self, template)
	MutatorStatTriggerOnDelta.super.init(self, template)

	self._trigger_amount = template.trigger_amount
	self._trigger_once = template.trigger_once
end

MutatorStatTriggerOnDelta._reset = function (self)
	MutatorStatTriggerOnDelta.super._reset(self)

	self._did_trigger = false
end

MutatorStatTriggerOnDelta._should_trigger = function (self, stat_delta)
	if self._trigger_once and self._did_trigger then
		return false
	end

	return stat_delta >= self._trigger_amount
end

MutatorStatTriggerOnDelta._trigger = function (self, mutator, for_value, delta, caused_by_player)
	MutatorStatTriggerOnDelta.super._trigger(self, mutator, for_value, delta, caused_by_player)

	self._did_trigger = true
end

return MutatorStatTriggerOnDelta
