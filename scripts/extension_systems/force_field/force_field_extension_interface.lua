-- chunkname: @scripts/extension_systems/force_field/force_field_extension_interface.lua

local force_field_extension_interface = {
	"init",
	"destroy",
	"game_object_initialized",
	"extensions_ready",
	"fixed_update",
	"update",
	"is_unit_colliding",
	"force_field_unit",
	"remaining_duration",
	"remaining_life",
	"is_dead",
	"is_sphere_shield",
	"reflected_direction",
	"on_player_enter",
	"on_player_exit",
	"on_death",
}

return force_field_extension_interface
