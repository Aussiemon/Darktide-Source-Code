-- chunkname: @scripts/settings/pickup/pickups.lua

local pickups = {
	by_group = {},
	by_name = {},
	data = {},
}

local function _create_pickup_entry(path)
	local pickup_data = require(path)
	local pickup_name = pickup_data.name
	local group_name = pickup_data.group
	local unit_name = pickup_data.unit_name
	local unit_names = pickup_data.unit_names

	pickup_data.unit_template_name = pickup_data.unit_template_name or "pickup"
	pickup_data.game_object_type = pickup_data.game_object_type or "pickup"

	if not pickups.by_group[group_name] then
		pickups.by_group[group_name] = {}
	end

	pickups.by_group[group_name][pickup_name] = pickup_data
end

_create_pickup_entry("scripts/settings/pickup/pickups/consumable/hordes_mcguffin_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/large_clip_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/large_metal_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/large_platinum_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/paper_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/paper_pickup_02")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/paper_pickup_03")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/paper_pickup_04")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/small_clip_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/small_grenade_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/small_metal_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/small_platinum_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/expedition_common_key_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/expedition_deadsider_key_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/expedition_dataslate_key_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/deployable/ammo_cache_deployable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/deployable/medical_crate_deployable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/level/large_ammunition_crate_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/luggable/battery_01_luggable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/luggable/battery_02_luggable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/luggable/prismata_case_01_luggable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/luggable/container_01_luggable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/luggable/container_02_luggable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/luggable/container_03_luggable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/luggable/control_rod_01_luggable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/luggable/explosive_01_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/luggable/expedition_loot_heavy_tier_1_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/luggable/expedition_loot_heavy_tier_2_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/luggable/expedition_loot_heavy_tier_3_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/pocketable/ammo_cache_pocketable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/pocketable/breach_charge_pocketable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/pocketable/medical_crate_pocketable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/pocketable/syringe_ability_boost_pocketable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/pocketable/syringe_corruption_pocketable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/pocketable/syringe_power_boost_pocketable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/pocketable/syringe_speed_boost_pocketable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/pocketable/expedition_grenade_airstrike_pocketable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/pocketable/expedition_grenade_artillery_strike_pocketable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/pocketable/expedition_grenade_big_pocketable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/pocketable/expedition_grenade_valkyrie_hover_pocketable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/pocketable/motion_detection_mine_fire_pocketable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/pocketable/motion_detection_mine_explosive_pocketable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/pocketable/motion_detection_mine_shock_pocketable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/pocketable/expedition_deployable_force_field_pocketable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/pocketable/expedition_time_syringe_timed_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/reward/skulls_01_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/reward/stolen_rations_01_pickup_small")
_create_pickup_entry("scripts/settings/pickup/pickups/reward/stolen_rations_01_pickup_medium")
_create_pickup_entry("scripts/settings/pickup/pickups/side_mission/communications_hack_device_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/side_mission/consumable_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/side_mission/grimoire_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/side_mission/tome_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/expedition_effective_sprinting_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/expedition_max_toughness_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/expedition_currency_small_tier_1")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/expedition_currency_small_tier_2")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/debug_expedition_pickup_full_heal")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/debug_expedition_pickup_full_ammo")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/expedition_loot_small_tier_1")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/expedition_loot_small_tier_2")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/expedition_loot_small_tier_3")
_create_pickup_entry("scripts/settings/pickup/pickups/consumable/expedition_loot_player_drop")
_create_pickup_entry("scripts/settings/pickup/pickups/pocketable/expedition_loot_crate_tier_1_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/pocketable/expedition_loot_crate_tier_2_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/pocketable/expedition_loot_crate_tier_3_pickup")
_create_pickup_entry("scripts/settings/pickup/pickups/reward/live_event_saints_01_pickup_small")
_create_pickup_entry("scripts/settings/pickup/pickups/reward/live_event_saints_01_pickup_medium")
_create_pickup_entry("scripts/settings/pickup/pickups/reward/live_event_saints_01_pickup_large")

for group_name, group_pickup in pairs(pickups.by_group) do
	for pickup_name, settings in pairs(group_pickup) do
		pickups.by_name[pickup_name] = settings
	end
end

return pickups
