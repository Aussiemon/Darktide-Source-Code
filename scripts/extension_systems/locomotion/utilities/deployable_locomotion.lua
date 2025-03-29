-- chunkname: @scripts/extension_systems/locomotion/utilities/deployable_locomotion.lua

local DeployableLocomotion = {}

DeployableLocomotion.set_placed_on_unit = function (world, unit, placed_on_unit)
	local moveable_platform_extension = ScriptUnit.has_extension(placed_on_unit, "moveable_platform_system")

	if moveable_platform_extension then
		local platform_position = Unit.world_position(placed_on_unit, 1)
		local platform_rot = Unit.local_rotation(placed_on_unit, 1)
		local unit_pos = Unit.world_position(unit, 1)
		local unit_rot = Unit.local_rotation(unit, 1)
		local grounded_unit_pos = Vector3(unit_pos.x, unit_pos.y, platform_position.z)
		local position_difference = grounded_unit_pos - platform_position
		local x, y, z = Quaternion.to_euler_angles_xyz(platform_rot)
		local angle = (360 - z) * math.pi / 180
		local new_x = position_difference.x * math.cos(angle) - position_difference.y * math.sin(angle)
		local new_y = position_difference.x * math.sin(angle) + position_difference.y * math.cos(angle)
		local new_local_pos = Vector3(new_x, new_y, 0)

		World.link_unit(world, unit, 1, placed_on_unit, 1)
		Unit.set_local_position(unit, 1, new_local_pos)
		Unit.set_local_rotation(unit, 1, unit_rot)
	end
end

return DeployableLocomotion
