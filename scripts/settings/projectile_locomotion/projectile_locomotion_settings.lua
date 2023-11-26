-- chunkname: @scripts/settings/projectile_locomotion/projectile_locomotion_settings.lua

local projectile_locomotion_settings = {}

projectile_locomotion_settings.impact_results = table.enum("stagger", "stick", "removed")

local locomotion_states = table.enum("none", "sleep", "carried", "manual_physics", "engine_physics", "socket_lock", "sticky", "true_flight")

projectile_locomotion_settings.states = locomotion_states
projectile_locomotion_settings.moving_states = {
	[locomotion_states.manual_physics] = true,
	[locomotion_states.true_flight] = true,
	[locomotion_states.engine_physics] = true
}
projectile_locomotion_settings.valid_interaction_states = {
	[locomotion_states.sleep] = true,
	[locomotion_states.manual_physics] = true,
	[locomotion_states.engine_physics] = true
}
projectile_locomotion_settings.MINIMUM_SPEED_TO_SLEEP = 0.1
projectile_locomotion_settings.MAX_SYNCHRONIZE_COUNTER = 0
projectile_locomotion_settings.NUM_BUFFERED_SNAPSHOTS = 5
projectile_locomotion_settings.MIN_TIME_IN_ENGINE_PHYSICS_BEFORE_SLEEP = 1
projectile_locomotion_settings.MIN_TRAVEL_DISTANCE_TO_INTEGRATE = 0.0035

return settings("ProjectileLocomotionSettings", projectile_locomotion_settings)
