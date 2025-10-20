-- chunkname: @scripts/managers/mutator/mutators/mutator_player_buff.lua

require("scripts/managers/mutator/mutators/mutator_base")

local MutatorPlayerBuff = class("MutatorPlayerBuff", "MutatorBase")

MutatorPlayerBuff._on_mission_buffs_event_player_spawned = function (self, player, is_respawn)
	local externally_controlled_buffs = self._template.externally_controlled_buffs

	for i = 1, #externally_controlled_buffs do
		Managers.event:trigger("mission_buffs_event_add_externally_controlled_to_player", player, externally_controlled_buffs[i])
	end
end

MutatorPlayerBuff._on_event_player_action_use_syringe = function (self, player, syringe_data)
	local externally_controlled_buffs = self._template.externally_controlled_buffs

	for i = 1, #externally_controlled_buffs do
		Managers.event:trigger("mission_buffs_event_add_externally_controlled_to_player", player, externally_controlled_buffs[i])
	end
end

return MutatorPlayerBuff
