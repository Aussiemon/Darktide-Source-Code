-- chunkname: @scripts/settings/breed/breed_blackboard_component_templates/sand_vortex_blackboard_component_templates.lua

local base_template = require("scripts/settings/breed/breed_blackboard_component_templates/base_blackboard_component_template")
local sand_vortex = {
	behavior = {
		move_medium = "string",
		move_state = "string",
	},
}

table.merge(sand_vortex, base_template)

sand_vortex.perception = nil
sand_vortex.stagger = nil
sand_vortex.spawn = {
	anim_translation_scale_factor = "number",
	game_object_id = "number",
	game_session = "GameSession",
	is_exiting_spawner = "boolean",
	physics_world = "PhysicsWorld",
	spawn_source = "string",
	spawner_spawn_index = "number",
	spawner_unit = "Unit",
	unit = "Unit",
	world = "World",
}
sand_vortex.vortex = {
	idle_time = "number",
	new_target_time = "number",
	num_players_inside = "number",
	target_unit = "Unit",
	wander_state = "string",
	wander_time = "number",
}

local templates = {
	sand_vortex = sand_vortex,
}

return templates
