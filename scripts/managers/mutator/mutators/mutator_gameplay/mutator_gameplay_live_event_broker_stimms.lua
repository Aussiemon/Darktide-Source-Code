-- chunkname: @scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_live_event_broker_stimms.lua

require("scripts/managers/mutator/mutators/mutator_gameplay/mutator_gameplay_base")

local MutatorGameplayLiveEventBrokerStimms = class("MutatorGameplayLiveEventBrokerStimms", "MutatorGameplayBase")

local function _apply_buff_stacks_for_player(player, buff_key, stacks)
	if stacks <= 0 then
		return
	end

	for i = 1, stacks do
		Managers.event:trigger("mission_buffs_event_add_externally_controlled_to_player", player, buff_key)
	end
end

MutatorGameplayLiveEventBrokerStimms.init = function (self, owner, settings, triggered_by_level)
	MutatorGameplayLiveEventBrokerStimms.super.init(self, owner, settings, triggered_by_level)

	if not self._is_server then
		return
	end

	self._buff = settings.buff

	Managers.event:register(self, "mission_buffs_event_player_spawned", "_on_event_mission_buffs_event_player_spawned")
end

MutatorGameplayLiveEventBrokerStimms.destroy = function (self)
	Managers.event:unregister(self, "mission_buffs_event_player_spawned")
	MutatorGameplayLiveEventBrokerStimms.super.destroy(self)
end

MutatorGameplayLiveEventBrokerStimms._on_event_mission_buffs_event_player_spawned = function (self, player, is_respawn, player_unit)
	if is_respawn then
		return
	end

	_apply_buff_stacks_for_player(player, self._buff, 1)
end

return MutatorGameplayLiveEventBrokerStimms
