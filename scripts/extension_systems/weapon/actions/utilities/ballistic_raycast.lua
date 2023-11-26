-- chunkname: @scripts/extension_systems/weapon/actions/utilities/ballistic_raycast.lua

local BallisticRaycast = {}
local DEFAULT_MAX_STEPS = 10
local DEFAULT_MAX_TIME = 1.5
local DEFAULT_SPEED = 15
local DEFAULT_ANGLE = 0
local DEFAULT_GRAVITY = -9.82

BallisticRaycast.cast = function (physics_world, collision_filter, first_person_component, optional_max_steps, optional_max_time, optional_speed, optional_angle, optional_gravity)
	local max_steps = optional_max_steps or DEFAULT_MAX_STEPS
	local max_time = optional_max_time or DEFAULT_MAX_TIME
	local speed = optional_speed or DEFAULT_SPEED
	local angle = optional_angle or DEFAULT_ANGLE
	local gravity = Vector3(0, 0, optional_gravity or DEFAULT_GRAVITY)
	local time_step = max_time / max_steps
	local first_person_position = first_person_component.position
	local first_person_rotation = first_person_component.rotation
	local velocity = Quaternion.forward(Quaternion.multiply(first_person_rotation, Quaternion(Vector3.right(), angle))) * speed
	local position = first_person_position

	for ii = 1, max_steps do
		local new_position = position + velocity * time_step
		local delta = new_position - position
		local direction, distance = Vector3.direction_length(delta)
		local hit, hit_position, hit_distance, normal, hit_actor = PhysicsWorld.raycast(physics_world, position, direction, distance, "closest", "types", "both", "collision_filter", collision_filter)

		if hit_position then
			return hit, hit_position, hit_distance, normal, hit_actor
		end

		velocity = velocity + gravity * time_step
		position = new_position
	end

	return false, position
end

return BallisticRaycast
