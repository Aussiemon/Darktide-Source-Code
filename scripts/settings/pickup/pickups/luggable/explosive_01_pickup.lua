-- chunkname: @scripts/settings/pickup/pickups/luggable/explosive_01_pickup.lua

local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local pickup_data = {
	description = "loc_expeditions_pickup_explosive_luggable_01",
	extra_description = "loc_expeditions_pickup_extra_description_explosive_luggable_01",
	game_object_type = "pickup_projectile",
	group = "luggable",
	interaction_icon = "content/ui/materials/hud/interactions/icons/barrel_explosive",
	interaction_type = "luggable",
	inventory_item = "content/items/luggable/expedition_explosive_01_luggable",
	look_at_tag = "luggable",
	name = "expedition_explosive_luggable_01",
	pickup_sound = "wwise/events/world/play_int_battery_pick_up",
	smart_tag_target_type = "pickup",
	unit_name = "content/pickups/luggables/deadside_explosive/deadside_explosive",
	projectile_template = ProjectileTemplates.luggable,
	spawn_offset = Vector3Box(0, 0, 0.4),
	luggable_explosion_component_data = {
		charge_level = 1,
		create_game_object = false,
		difficulty_scaling = 1,
		explosion_template_name = "expeditions_explosive_barrel",
		has_health_bar = false,
		hit_mass = 1,
		invulnerable = false,
		invulnerable_when_carried = true,
		liquid_area_template_name = "promethium",
		max_health = 10,
		power_level = 100,
		regenerate_health = false,
		speed_on_hit = 5,
		unkillable = false,
		breed_white_list = {},
		ignored_colliders = {},
	},
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data)
		return
	end,
	on_drop_func = function (pickup_unit, interactor_unit)
		return
	end,
}

return pickup_data
