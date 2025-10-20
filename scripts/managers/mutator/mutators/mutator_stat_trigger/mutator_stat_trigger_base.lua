﻿-- chunkname: @scripts/managers/mutator/mutators/mutator_stat_trigger/mutator_stat_trigger_base.lua

local MutatorStatTriggerBase = class("MutatorStatTriggerBase")

MutatorStatTriggerBase.init = function (self, triggers)
	self._triggers = triggers

	self:_reset()
end

MutatorStatTriggerBase._reset = function (self)
	self._previous_stat_value = 0
	self._tracked_stat_value = 0
end

MutatorStatTriggerBase.on_stat_change = function (self, mutator, stat_delta, caused_by_player)
	self._previous_stat_value = self._tracked_stat_value
	self._tracked_stat_value = self._tracked_stat_value + stat_delta

	if self:_should_trigger() then
		self:_trigger(mutator, caused_by_player)
	end
end

MutatorStatTriggerBase._should_trigger = function (self)
	return false
end

MutatorStatTriggerBase._trigger = function (self, mutator, caused_by_player)
	for i = 1, #self._triggers do
		self._triggers[i](mutator, caused_by_player)
	end
end

return MutatorStatTriggerBase
