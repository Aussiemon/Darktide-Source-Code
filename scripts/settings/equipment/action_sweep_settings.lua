local HitZone = require("scripts/utilities/attack/hit_zone")
local hit_zone_names = HitZone.hit_zone_names
local WORST_HIT_ZONE_PRIORITY = math.huge
local action_sweep_settings = {
	proximity_overlap_radius = 10,
	sweep_height_mod = 1,
	sweep_range_mod = 1,
	sweep_width_mod = 1,
	default_hit_zone_priority = {
		[hit_zone_names.shield] = 0,
		[hit_zone_names.weakspot] = 0,
		[hit_zone_names.head] = 1,
		[hit_zone_names.torso] = 2,
		[hit_zone_names.upper_left_arm] = 3,
		[hit_zone_names.lower_left_arm] = 3,
		[hit_zone_names.upper_right_arm] = 3,
		[hit_zone_names.lower_right_arm] = 3,
		[hit_zone_names.upper_left_leg] = 3,
		[hit_zone_names.lower_left_leg] = 3,
		[hit_zone_names.upper_right_leg] = 3,
		[hit_zone_names.lower_right_leg] = 3,
		[hit_zone_names.upper_tail] = 4,
		[hit_zone_names.lower_tail] = 4,
		[hit_zone_names.tongue] = 5,
		[hit_zone_names.afro] = 6,
		[hit_zone_names.center_mass] = 6,
		[hit_zone_names.captain_void_shield] = 6,
		[hit_zone_names.corruptor_armor] = 6,
		[hit_zone_names.right_shoulderguard] = 6,
		[hit_zone_names.delayed_gib] = 6
	}
}
action_sweep_settings.hit_zone_priority_functions = {
	[hit_zone_names.shield] = function (unit, attacking_unit_position, current_hit_zone_priority)
		local shield_extension = ScriptUnit.has_extension(unit, "shield_system")

		if shield_extension and shield_extension:can_block_from_position(attacking_unit_position) then
			return current_hit_zone_priority
		else
			return WORST_HIT_ZONE_PRIORITY
		end
	end
}

return settings("ActionSweepSettings", action_sweep_settings)
