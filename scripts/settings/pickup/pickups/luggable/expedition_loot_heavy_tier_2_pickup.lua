-- chunkname: @scripts/settings/pickup/pickups/luggable/expedition_loot_heavy_tier_2_pickup.lua

local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local loot_data = {
	is_expedition_loot = true,
	tier = 2,
	type = "heavy",
}
local pickup_data = {
	description = "loc_expeditions_pickup_loot_luggable_quality_medium",
	game_object_type = "pickup_projectile",
	group = "luggable",
	interaction_type = "luggable",
	inventory_item = "content/items/luggable/expedition_loot_heavy_tier_2",
	look_at_tag = "luggable",
	name = "expedition_loot_heavy_tier_2",
	pickup_sound = "wwise/events/world/play_int_battery_pick_up",
	smart_tag_target_type = "pickup",
	unit_name = "content/pickups/luggables/expedition_loot_heavy_02/expedition_loot_heavy_02",
	projectile_template = ProjectileTemplates.luggable,
	loot_data = loot_data,
	spawn_offset = Vector3Box(0, 0, 0.4),
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data)
		local loot_type = loot_data.type
		local loot_tier = loot_data.tier
		local show_notification = false

		Managers.event:trigger("event_expedition_pocketable_collected", interactor_unit, loot_type, loot_tier, show_notification)
		Managers.state.pacing:add_heat_by_type("medium", pickup_unit, "pickups", interactor_unit)
	end,
	on_drop_func = function (pickup_unit, interactor_unit)
		local loot_type = loot_data.type
		local loot_tier = loot_data.tier
		local show_notification = false

		Managers.event:trigger("event_expedition_pocketable_dropped", interactor_unit, loot_type, loot_tier, show_notification)
	end,
}

return pickup_data
