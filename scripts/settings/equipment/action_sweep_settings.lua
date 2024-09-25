-- chunkname: @scripts/settings/equipment/action_sweep_settings.lua

local HitZone = require("scripts/utilities/attack/hit_zone")
local hit_zone_names = HitZone.hit_zone_names
local WORST_HIT_ZONE_PRIORITY = math.huge
local action_sweep_settings = {
	sweep_height_mod = 1,
	sweep_range_mod = 1,
	sweep_width_mod = 1,
	default_hit_zone_priority = {
		[hit_zone_names.captain_void_shield] = 0,
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
		[hit_zone_names.backpack] = 9,
		[hit_zone_names.center_mass] = 6,
		[hit_zone_names.corruptor_armor] = 6,
		[hit_zone_names.right_shoulderguard] = 6,
		[hit_zone_names.delayed_gib] = 6,
	},
	hit_zone_priority_functions = {
		[hit_zone_names.shield] = function (unit, attacking_unit_position, current_hit_zone_priority)
			local shield_extension = ScriptUnit.has_extension(unit, "shield_system")

			if shield_extension then
				if not shield_extension:is_blocking() then
					return WORST_HIT_ZONE_PRIORITY
				end

				local blocking_angle = math.degrees_to_radians(70)
				local unit_rotation = Unit.local_rotation(unit, 1)
				local unit_forward = Quaternion.forward(unit_rotation)
				local unit_position = POSITION_LOOKUP[unit]
				local to_attacking_unit = Vector3.normalize(attacking_unit_position - unit_position)
				local angle = Vector3.angle(unit_forward, to_attacking_unit)
				local is_within_blocking_angle = angle < blocking_angle

				if is_within_blocking_angle then
					return current_hit_zone_priority
				else
					return WORST_HIT_ZONE_PRIORITY
				end
			else
				return WORST_HIT_ZONE_PRIORITY
			end
		end,
	},
}

return settings("ActionSweepSettings", action_sweep_settings)
