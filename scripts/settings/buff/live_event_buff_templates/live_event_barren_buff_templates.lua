-- chunkname: @scripts/settings/buff/live_event_buff_templates/live_event_barren_buff_templates.lua

local BuffTemplates = require("scripts/settings/buff/mutator_buff_templates")
local templates = {}

table.make_unique(templates)

local _stimm_pickup_list = {
	"syringe_corruption_pocketable",
	"syringe_power_boost_pocketable",
	"syringe_speed_boost_pocketable",
	"syringe_ability_boost_pocketable",
}

templates.live_event_barren_drop_random_stimm_on_death = table.add_missing({
	auto_tag_on_spawn = true,
	func_get_pickup = function ()
		return math.random_array_entry(_stimm_pickup_list)
	end,
	placement_settings = {
		circle_radius = 0.75,
		num_slots = 1,
		position_offset = 0.2,
		randomize_rotation = true,
	},
}, table.clone(BuffTemplates.drop_many_pickups_on_death))
templates.live_event_barren_drop_random_stimm_on_death.pickup_skip_group = nil

local _deployable_pickup_list = {
	"ammo_cache_pocketable",
	"medical_crate_pocketable",
}

templates.live_event_barren_drop_random_deployable_on_death = table.add_missing({
	auto_tag_on_spawn = true,
	func_get_pickup = function ()
		return math.random_array_entry(_deployable_pickup_list)
	end,
	placement_settings = {
		circle_radius = 0.75,
		num_slots = 1,
		position_offset = 0.2,
		randomize_rotation = true,
	},
}, table.clone(BuffTemplates.drop_many_pickups_on_death))
templates.live_event_barren_drop_random_deployable_on_death.pickup_skip_group = nil
templates.live_event_barren_drop_grenade_on_death = table.add_missing({
	auto_tag_on_spawn = true,
	pickup_name = "small_grenade",
	placement_settings = {
		circle_radius = 0.75,
		num_slots = 1,
		position_offset = 0.2,
		randomize_rotation = true,
	},
}, table.clone(BuffTemplates.drop_many_pickups_on_death))
templates.live_event_barren_drop_grenade_on_death.pickup_skip_group = nil
templates.live_event_barren_drop_small_clip_on_death = table.add_missing({
	auto_tag_on_spawn = true,
	pickup_name = "small_clip",
	placement_settings = {
		circle_radius = 0.75,
		num_slots = 1,
		position_offset = 0.2,
		randomize_rotation = true,
	},
}, table.clone(BuffTemplates.drop_many_pickups_on_death))
templates.live_event_barren_drop_small_clip_on_death.pickup_skip_group = nil
templates.live_event_barren_drop_small_metal_on_death = table.add_missing({
	pickup_name = "small_metal",
	placement_settings = {
		circle_radius = 0.75,
		num_slots = 1,
		position_offset = 0.2,
		randomize_rotation = true,
	},
}, table.clone(BuffTemplates.drop_many_pickups_on_death))
templates.live_event_barren_drop_small_metal_on_death.pickup_skip_group = nil
templates.live_event_barren_drop_small_platinum_on_death = table.add_missing({
	pickup_name = "small_platinum",
	placement_settings = {
		circle_radius = 0.75,
		num_slots = 1,
		position_offset = 0.2,
		randomize_rotation = true,
	},
}, table.clone(BuffTemplates.drop_many_pickups_on_death))
templates.live_event_barren_drop_small_platinum_on_death.pickup_skip_group = nil

return templates
