local pickups = {
	by_group = {},
	by_name = {},
	data = {}
}

local function _create_pickup_entry(path)
	local pickup_data = require(path)
	local pickup_name = pickup_data.name
	local group_name = pickup_data.group

	if not pickups.by_group[group_name] then
		pickups.by_group[group_name] = {}
	end

	pickups.by_group[group_name][pickup_name] = pickup_data
end

_create_pickup_entry("scripts/settings/pickup/pickups/consumable/large_clip_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/large_metal_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/large_platinum_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/small_clip_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/small_grenade_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/small_metal_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/small_platinum_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/deployable/ammo_cache_deployable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/deployable/medical_crate_deployable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/luggable/battery_01_luggable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/luggable/battery_02_luggable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/luggable/prismata_case_01_luggable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/luggable/container_01_luggable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/luggable/container_02_luggable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/luggable/container_03_luggable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/luggable/control_rod_01_luggable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/pocketable/ammo_cache_pocketable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/pocketable/breach_charge_pocketable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/pocketable/medical_crate_pocketable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/pocketable/syringe_ability_boost_pocketable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/pocketable/syringe_corruption_pocketable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/pocketable/syringe_power_boost_pocketable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/pocketable/syringe_speed_boost_pocketable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/side_mission/consumable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/side_mission/grimoire_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/side_mission/tome_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/collectible/collectible_01_pickup")

for group_name, group_pickup in pairs(pickups.by_group) do
	local total_spawn_weighting = 0

	for _, settings in pairs(group_pickup) do
		total_spawn_weighting = total_spawn_weighting + settings.spawn_weighting
	end

	for pickup_name, settings in pairs(group_pickup) do
		settings.spawn_weighting = total_spawn_weighting > 0 and settings.spawn_weighting / total_spawn_weighting or 0
		pickups.by_name[pickup_name] = settings
	end
end

return pickups
