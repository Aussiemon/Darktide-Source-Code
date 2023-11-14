local TaskLocalization = {}

local function _create_task(id, optional_parameters)
	local label_key = string.format("loc_contracts_task_label_%s", id)
	local description_key = string.format("loc_contracts_task_description_%s", id)

	return {
		label_key = label_key,
		description_key = description_key,
		parameters = optional_parameters or {}
	}
end

TaskLocalization.KillBosses = _create_task("kill_bosses")
TaskLocalization.CollectPickup = _create_task("collect_pickups", {
	{
		pattern = "loc_contract_task_pickup_type_%s",
		key = "kind",
		input = "pickupType"
	}
})
TaskLocalization.CollectResource = _create_task("collect_resources", {
	{
		pattern = "loc_currency_name_%s",
		key = "kind",
		input = "resourceTypes"
	}
})
TaskLocalization.KillMinions = _create_task("kill_minions", {
	{
		pattern = "loc_contract_task_enemy_type_%s",
		key = "enemy_type",
		input = "enemyType"
	},
	{
		pattern = "loc_contract_task_weapon_type_%s",
		key = "weapon_type",
		input = "weaponType"
	}
})
TaskLocalization.BlockDamage = _create_task("block_damage")
TaskLocalization.CompleteMissions = _create_task("complete_missions")
TaskLocalization.CompleteMissionsNoDeath = _create_task("mission_no_death")
TaskLocalization.CompleteMissionsByName = _create_task("complete_missions_by_name", {
	{
		pattern = "loc_mission_name_%s",
		key = "map",
		input = "name"
	}
})

return TaskLocalization
