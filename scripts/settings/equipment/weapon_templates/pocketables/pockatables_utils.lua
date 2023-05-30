local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local PocketableUtils = {}

PocketableUtils.validate_syringe_corruption_pocketable_target = function (target_unit)
	local health_extension = target_unit and ScriptUnit.has_extension(target_unit, "health_system")
	local current_health_percent = health_extension and health_extension:current_health_percent()
	local can_use = current_health_percent and current_health_percent < 1

	return can_use
end

PocketableUtils.validate_give_pockatable_target_func = function (target_unit)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local target_player = target_unit and player_unit_spawn_manager:owner(target_unit)
	local is_valid_target = target_player and target_player:is_human_controlled()

	if not is_valid_target then
		return false
	end

	local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
	local target_inventory_component = target_unit_data_extension:read_component("inventory")
	local target_visual_loadout_extension = ScriptUnit.extension(target_unit, "visual_loadout_system")
	local is_equiped = PlayerUnitVisualLoadout.slot_equipped(target_inventory_component, target_visual_loadout_extension, "slot_pocketable")

	return not is_equiped
end

return PocketableUtils
