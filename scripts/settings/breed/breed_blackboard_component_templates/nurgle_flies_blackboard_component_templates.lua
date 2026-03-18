-- chunkname: @scripts/settings/breed/breed_blackboard_component_templates/nurgle_flies_blackboard_component_templates.lua

local base_template = require("scripts/settings/breed/breed_blackboard_component_templates/base_blackboard_component_template")
local nurgle_flies = {
	behavior = {
		move_medium = "string",
		move_state = "string",
	},
}

table.merge(nurgle_flies, base_template)

nurgle_flies.perception = nil
nurgle_flies.stagger = nil
nurgle_flies.spawn = {
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
nurgle_flies.chase_target = {
	idle_time = "number",
	kill_time = "number",
	new_target_time = "number",
	num_players_inside = "number",
	target_unit = "Unit",
	wander_state = "string",
	wander_time = "number",
}

local templates = {
	nurgle_flies = nurgle_flies,
}

return templates
