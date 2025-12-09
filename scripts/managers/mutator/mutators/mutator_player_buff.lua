-- chunkname: @scripts/managers/mutator/mutators/mutator_player_buff.lua

require("scripts/managers/mutator/mutators/mutator_base")

local FixedFrame = require("scripts/utilities/fixed_frame")
local MutatorPlayerBuff = class("MutatorPlayerBuff", "MutatorBase")

MutatorPlayerBuff._on_mission_buffs_event_player_spawned = function (self, event_settings, player, is_respawn)
	local externally_controlled_buffs = self._template.externally_controlled_buffs or {}

	for i = 1, #externally_controlled_buffs do
		Managers.event:trigger("mission_buffs_event_add_externally_controlled_to_player", player, externally_controlled_buffs[i])
	end
end

MutatorPlayerBuff._on_event_player_action_use_syringe = function (self, event_settings, player, syringe_data)
	if event_settings.pocketable_name and event_settings.pocketable_name ~= syringe_data.pickup_name then
		return
	end

	local target_player = syringe_data.target_player

	if not target_player then
		return
	end

	if not target_player:unit_is_alive() then
		return
	end

	local externally_controlled_buffs = self._template.externally_controlled_buffs or {}

	for i = 1, #externally_controlled_buffs do
		Managers.event:trigger("mission_buffs_event_add_externally_controlled_to_player", target_player, externally_controlled_buffs[i])
	end

	local target_buff_extension = ScriptUnit.has_extension(target_player.player_unit, "buff_system")

	if not target_buff_extension then
		return
	end

	local internally_controlled_buffs = self._template.internally_controlled_buffs or {}

	for i = 1, #internally_controlled_buffs do
		target_buff_extension:add_internally_controlled_buff(internally_controlled_buffs[i], FixedFrame.get_latest_fixed_time(), "owner_unit", player)
	end
end

return MutatorPlayerBuff
