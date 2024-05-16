-- chunkname: @scripts/extension_systems/locomotion/utilities/projectile_linking.lua

local ProjectileLinking = {}

ProjectileLinking.link_position_and_rotation = function (sticking_to_unit, sticking_to_actor_index, world_position, world_rotation, hit_normal, hit_direction)
	local hit_node_rot = Unit.world_rotation(sticking_to_unit, sticking_to_actor_index)
	local hit_node_pos = Unit.world_position(sticking_to_unit, sticking_to_actor_index)
	local rel_pos = world_position - hit_node_pos
	local offset_position = Vector3(Vector3.dot(Quaternion.right(hit_node_rot), rel_pos), Vector3.dot(Quaternion.forward(hit_node_rot), rel_pos), Vector3.dot(Quaternion.up(hit_node_rot), rel_pos))
	local random_pitch = math.random_range(math.pi / 6, math.pi / 3)
	local random_roll = math.random_range(-math.pi / 10, math.pi / 10)
	local link_direction = Vector3.normalize((hit_direction - hit_normal) * 0.5)
	local link_rotation = Quaternion.look(link_direction, Vector3.up())

	link_rotation = Quaternion.multiply(link_rotation, Quaternion(Vector3.forward(), random_roll))
	link_rotation = Quaternion.multiply(link_rotation, Quaternion(Vector3.left(), random_pitch))

	local local_rotation = Quaternion.multiply(Quaternion.inverse(hit_node_rot), link_rotation)

	return offset_position, local_rotation
end

return ProjectileLinking
