-- chunkname: @scripts/settings/equipment/weapon_templates/pocketables/pockatables_utils.lua

local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local PocketableUtils = {}

PocketableUtils.validate_slot_not_equipped = function (target_unit, slot_name)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local target_player = target_unit and player_unit_spawn_manager:owner(target_unit)
	local is_valid_target = target_player and target_player:is_human_controlled()

	if not is_valid_target then
		return false
	end

	local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
	local target_inventory_component = target_unit_data_extension:read_component("inventory")
	local target_visual_loadout_extension = ScriptUnit.extension(target_unit, "visual_loadout_system")
	local is_equipped = PlayerUnitVisualLoadout.slot_equipped(target_inventory_component, target_visual_loadout_extension, slot_name)

	return not is_equipped
end

PocketableUtils.validate_give_pocketable_target_func = function (target_unit)
	return PocketableUtils.validate_slot_not_equipped(target_unit, "slot_pocketable")
end

PocketableUtils.validate_give_pocketable_small_target_func = function (target_unit)
	return PocketableUtils.validate_slot_not_equipped(target_unit, "slot_pocketable_small")
end

return PocketableUtils
