local pickups = {
	by_group = {},
	by_name = {},
	data = {}
}

local function _create_pickup_entry(path)
	local pickup_data = require(path)
	local pickup_name = pickup_data.name
	local group_name = pickup_data.group

	fassert(pickup_name, "[Pickups] Missing name field in %q.", path)
	fassert(group_name, "[Pickups] Missing group name field in %q.", path)

	if not pickups.by_group[group_name] then
		pickups.by_group[group_name] = {}
	end

	pickups.by_group[group_name][pickup_name] = pickup_data
end

_create_pickup_entry("scripts/settings/pickup/pickups/small_clip_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/large_clip_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/health_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/small_grenade_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/small_metal_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/large_metal_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/small_platinum_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/large_platinum_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/battery_01_luggable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/container_01_luggable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/container_02_luggable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/control_rod_01_luggable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/luggable_reference_01_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/ammo_cache_pocketable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/medical_crate_pocketable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/ammo_cache_deployable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/medical_crate_deployable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/side_mission/consumable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/side_mission/grimoire_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/side_mission/tome_pickup")

pickups.data.near_pickup_spawn_chance = {}

for group_name, group_pickup in pairs(pickups.by_group) do
	local total_spawn_weighting = 0

	for _, settings in pairs(group_pickup) do
		total_spawn_weighting = total_spawn_weighting + settings.spawn_weighting
	end

	for pickup_name, settings in pairs(group_pickup) do
		settings.spawn_weighting = settings.spawn_weighting / total_spawn_weighting
		pickups.by_name[pickup_name] = settings
	end

	pickups.data.near_pickup_spawn_chance[group_name] = pickups.data.near_pickup_spawn_chance[group_name] or 0
end

return pickups
