-- chunkname: @scripts/settings/expeditions/settings_templates/oil_expedition_template.lua

local BaseExpeditionTemplate = require("scripts/settings/expeditions/settings_templates/base_expedition_template")
local base_settings = table.clone_instance(BaseExpeditionTemplate)
local overrides = {
	name = "oil",
	events = {},
	theme_tags = {
		"default",
	},
	location_levels = {
		"content/levels/expeditions/locations/oil/location_256m_oil_001/missions/mission_location_256m_oil_001",
		"content/levels/expeditions/locations/oil/location_256m_oil_pools_001/missions/mission_location_256m_oil_pools_001",
		"content/levels/expeditions/locations/oil/location_256m_pipeline_001/missions/mission_location_256m_pipeline_001",
	},
	safe_zone_levels = {
		"content/levels/expeditions/safe_zones/wastes/sz_cave_tunnels_002/missions/mission_sz_cave_tunnels_002",
	},
	allowed_dsl_levels = {
		"content/levels/expeditions/opportunities/oil/op_16m_pressure_001/world",
		"content/levels/expeditions/opportunities/oil/op_16m_scorch_001/world",
		"content/levels/expeditions/opportunities/oil/op_16m_vapor_001/world",
		"content/levels/expeditions/opportunities/wastes/op_16m_stash_003/world",
		"content/levels/expeditions/opportunities/wastes/op_16m_simple_puzzle_002/world",
		"content/levels/expeditions/opportunities/oil/op_32m_leak_001/world",
		"content/levels/expeditions/opportunities/oil/op_32m_revolve_001/world",
		"content/levels/expeditions/opportunities/oil/op_32m_puddle_001/world",
		"content/levels/expeditions/opportunities/oil/op_32m_puddle_002/world",
		"content/levels/expeditions/opportunities/wastes/op_32m_lot_001/world",
		"content/levels/expeditions/opportunities/wastes/op_32m_encampment_001/world",
		"content/levels/expeditions/opportunities/oil/op_48m_pistons_001/world",
		"content/levels/expeditions/opportunities/wastes/op_48m_capture_zone_002/world",
		"content/levels/expeditions/opportunities/wastes/op_48m_fort_generator_002/world",
		"content/levels/expeditions/opportunities/wastes/op_48m_jumping_puzzle_002/world",
		"content/levels/expeditions/opportunities/wastes/op_48m_valkyrie_rocks_001/world",
		"content/levels/expeditions/opportunities/oil/op_64m_pit_001/world",
		"content/levels/expeditions/traversal/wastes/tr_16m_drop_pod_001/world",
		"content/levels/expeditions/traversal/oil/tr_16m_singe_001/world",
		"content/levels/expeditions/traversal/wastes/tr_16m_sphere_001/world",
		"content/levels/expeditions/traversal/oil/tr_32m_singe_001/world",
		"content/levels/expeditions/traversal/wastes/tr_32m_plaza_001/world",
		"content/levels/expeditions/traversal/wastes/tr_32m_flat_002/world",
		"content/levels/expeditions/traversal/oil/tr_48m_pipes_001/world",
		"content/levels/expeditions/traversal/wastes/tr_48m_encampment_002/world",
		"content/levels/expeditions/traversal/wastes/tr_64m_mining_001/world",
		"content/levels/expeditions/zone_transitions/wastes/zt_16m_airlock_destroyed_001/world",
		"content/levels/expeditions/zone_transitions/wastes/zt_16m_airlock_disabled_001/world",
		"content/levels/expeditions/zone_transitions/wastes/zt_16m_airlock_makeshift_001/world",
		"content/levels/expeditions/arrivals/wastes/arr_32m_valkyrie_rocks_001/world",
		"content/levels/expeditions/arrivals/wastes/arr_48m_valkyrie_rocks_001/world",
		"content/levels/expeditions/extractions/wastes/ext_32m_valkyrie_rocks_001/world",
		"content/levels/expeditions/extractions/wastes/ext_48m_valkyrie_pad_001/world",
		"content/levels/expeditions/interactables/secondary_pickup_spawner_01/world",
		"content/levels/expeditions/interactables/sandpiles/collectibles/common_key/world",
		"content/levels/expeditions/interactables/sandpiles/collectibles/dataslate_key/world",
		"content/levels/expeditions/interactables/sandpiles/collectibles/deadsider_key/world",
	},
}

return table.merge(base_settings, overrides)
