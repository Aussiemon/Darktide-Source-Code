-- chunkname: @scripts/utilities/item_slot_utils.lua

local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local slot_configuration = PlayerCharacterConstants.slot_configuration
local ItemSlotUtils = {}

local function _sort_array_by_priority(a, b)
	local config_a, config_b = slot_configuration[a], slot_configuration[b]

	if not config_a ~= not config_b then
		return (config_a == nil and 0 or config_a.priority) < (config_b == nil and 0 or config_b.priority)
	end

	if config_a then
		return config_a.priority < config_b.priority
	end

	return a < b
end

ItemSlotUtils.slot_keys_by_priority = function (slot_map, scratch_table)
	local out = scratch_table and (table.clear(scratch_table) or scratch_table) or {}
	local sorted_array = table.keys(slot_map, out)

	table.sort(sorted_array, _sort_array_by_priority)

	return sorted_array
end

ItemSlotUtils.sort_slot_array_by_priority = function (slot_array)
	table.sort(slot_array, _sort_array_by_priority)

	return slot_array
end

return ItemSlotUtils
