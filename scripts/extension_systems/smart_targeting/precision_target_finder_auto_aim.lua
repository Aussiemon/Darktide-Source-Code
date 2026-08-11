-- chunkname: @scripts/extension_systems/smart_targeting/precision_target_finder_auto_aim.lua

local Breed = require("scripts/utilities/breed")
local HitZone = require("scripts/utilities/attack/hit_zone")
local LagCompensation = require("scripts/utilities/lag_compensation")
local PrecisionTargetFinderInterface = require("scripts/extension_systems/smart_targeting/precision_target_finder_interface")
local EMPTY_TABLE = {}
local math_abs = math.abs
local math_min = math.min
local math_max = math.max
local math_atan = math.atan
local math_log = math.log
local Vector3_length = Vector3.length
local Vector3_normalize = Vector3.normalize
local Vector3_dot = Vector3.dot
local Matrix4x4_right = Matrix4x4.right
local Matrix4x4_forward = Matrix4x4.forward
local Matrix4x4_up = Matrix4x4.up
local Raycast_cast = Raycast.cast
local Breed_height = Breed.height
local Breed_is_prop = Breed.is_prop
local Breed_is_living_prop = Breed.is_living_prop
local Actor_unit = Actor.unit
local Actor_world_bounds = Actor.world_bounds
local ScriptUnit_has_extension = ScriptUnit.has_extension
local Unit_box = Unit.box
local PrecisionTargetFinderAutoAim = class("PrecisionTargetFinderAutoAim")

PrecisionTargetFinderAutoAim.init = function (self, is_server, is_local_unit, player, physics_world, unit)
	self._unit = unit
	self._is_server = is_server
	self._is_local_unit = is_local_unit
	self._player = player
	self._physics_world = physics_world
	self._visibility_raycast_object = PhysicsWorld.make_raycast(physics_world, "closest", "types", "statics", "collision_filter", "filter_ray_aim_assist_line_of_sight")
	self._target_position_box = Vector3Box(Vector3.zero())
	self._target_rotation_box = QuaternionBox(Quaternion.identity())
	self._num_visibility_checks_this_frame = 0

	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

	self._unit_data_extension = unit_data_extension
	self._first_person_component = unit_data_extension:read_component("first_person")
end

PrecisionTargetFinderAutoAim.extensions_ready = function (self)
	return
end

PrecisionTargetFinderAutoAim.get_unit_distance_to_box = function (self, distance, half_width, half_height, x_diff, y_diff, epsilon)
	local best_unit_distance_to_box, best_unit_distance_to_box_x, best_unit_distance_to_box_y
	local angle_width = math_atan(half_width / distance)
	local angle_height = math_atan(half_height / distance)
	local angle_x_diff = math_atan(x_diff / distance)
	local angle_y_diff = math_atan(y_diff / distance)
	local x_offset = math_max((angle_x_diff - angle_width) / angle_width, epsilon) / math_log(angle_width)
	local y_offset = math_max((angle_y_diff - angle_height) / angle_height, epsilon) / math_log(angle_height)
	local x_distance = math_abs(x_offset)
	local y_distance = math_abs(y_offset)

	best_unit_distance_to_box = math_max(x_distance, y_distance)
	best_unit_distance_to_box_x = x_distance
	best_unit_distance_to_box_y = y_distance

	return best_unit_distance_to_box, best_unit_distance_to_box_x, best_unit_distance_to_box_y
end

local RAYCAST_INDEX_ACTOR = 4
local RAYCAST_INDEX_POSITION = 1
local nearby_target_units = Script.new_array(16)
local nearby_target_positions = Script.new_array(16)
local nearby_target_distances = Script.new_array(16)

PrecisionTargetFinderAutoAim._try_find_target_with_raycast = function (self, visibility_cache, visibility_check_frame, fixed_frame, ray_origin, forward, min_range, max_range, max_angle_rad, target_units, target_positions, target_distances)
	local rewind_ms = LagCompensation.rewind_ms(self._is_server, self._is_local_unit, self._player)
	local found_potential_targets = false
	local hits, num_hits, num_columns = PhysicsWorld.raycast(self._physics_world, ray_origin, forward, max_range, "all", "collision_filter", "filter_ray_aim_assist", "rewind_ms", rewind_ms)

	for i = 1, num_hits do
		local hit = hits[i]
		local hit_actor = hit[RAYCAST_INDEX_ACTOR]
		local hit_position = hit[RAYCAST_INDEX_POSITION]

		repeat
			local hit_unit = Actor_unit(hit_actor)
			local unit_data_extension = ScriptUnit_has_extension(hit_unit, "unit_data_system")
			local breed = unit_data_extension and unit_data_extension:breed()
			local is_prop = breed and (Breed_is_prop(breed) or Breed_is_living_prop(breed)) or false

			if not breed or not HEALTH_ALIVE[hit_unit] or is_prop then
				break
			end

			local hit_unit_center_position, _ = Actor_world_bounds(hit_actor)
			local node_to_aim_afro = Unit.node(hit_unit, "r_afro")
			local node_to_aim_torso = Unit.node(hit_unit, "enemy_aim_target_02")
			local node_to_aim_head = Unit.node(hit_unit, "enemy_aim_target_03")
			local aim_target_position_afro = Unit.world_position(hit_unit, node_to_aim_afro)
			local aim_target_position_torso = Unit.world_position(hit_unit, node_to_aim_torso)
			local aim_target_position_head = Unit.world_position(hit_unit, node_to_aim_head)
			local aim_target_position = hit_unit_center_position + (aim_target_position_torso - aim_target_position_afro) + Vector3.multiply(aim_target_position_head - aim_target_position_torso, 0.4)
			local to_target_aim_position = aim_target_position - ray_origin
			local to_target_aim_position_normalized = Vector3_normalize(to_target_aim_position)
			local distance_to_target = Vector3_length(to_target_aim_position)
			local dot_to_target = Vector3.dot(forward, to_target_aim_position_normalized)

			if distance_to_target < min_range or dot_to_target < 0.5 then
				break
			end

			local is_visible = false
			local cached_visibility = visibility_cache[hit_unit]

			if cached_visibility then
				is_visible = cached_visibility
			elseif self._num_visibility_checks_this_frame < 5 then
				self._num_visibility_checks_this_frame = self._num_visibility_checks_this_frame + 1

				local first_hit = Raycast_cast(self._visibility_raycast_object, ray_origin, to_target_aim_position_normalized, distance_to_target)

				if not first_hit then
					is_visible = true
					visibility_cache[hit_unit] = true
					visibility_check_frame[hit_unit] = fixed_frame
				end
			end

			if is_visible then
				found_potential_targets = true

				local angle_to_target = Vector3.angle(forward, to_target_aim_position_normalized)

				if max_angle_rad < angle_to_target then
					break
				end

				table.insert(target_units, hit_unit)
				table.insert(target_positions, hit_unit_center_position)
				table.insert(target_distances, distance_to_target)
			end
		until true

		if self._num_visibility_checks_this_frame >= 5 then
			break
		end
	end

	return found_potential_targets
end

PrecisionTargetFinderAutoAim.update_precision_target = function (self, unit, smart_targeting_template, ray_origin, forward, right, up, targeting_data, fixed_frame, visibility_cache, visibility_check_frame, optional_line_of_sight_cache)
	table.clear(targeting_data)
	table.clear(nearby_target_units)
	table.clear(nearby_target_positions)
	table.clear(nearby_target_distances)

	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local num_insignificant_targets = 0
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local precision_target_auto_aim_settings = smart_targeting_template.precision_target_auto_aim
	local target_node_for_visibility = precision_target_auto_aim_settings.target_node_for_visibility
	local min_range = precision_target_auto_aim_settings.min_range
	local max_range_broadphase = precision_target_auto_aim_settings.max_range_broadphase
	local max_range_raycast = precision_target_auto_aim_settings.max_range_raycast
	local max_angle_rad_broadphase = precision_target_auto_aim_settings.max_angle_rad_broadphase
	local max_angle_rad_raycast = precision_target_auto_aim_settings.max_angle_rad_raycast
	local num_insignificant_targets_limit = precision_target_auto_aim_settings.num_insignificant_targets_limit
	local targeting_weights = precision_target_auto_aim_settings.targeting_weighs
	local distance_weight = targeting_weights.distance_weight
	local angle_weight = targeting_weights.angle_weight
	local breed_weights = targeting_weights.breed_weights or nil
	local tag_weights = targeting_weights.tag_weights or nil
	local ignore_direct_hit = precision_target_auto_aim_settings.ignore_direct_hit
	local only_direct_hit = precision_target_auto_aim_settings.only_direct_hit or false
	local check_for_breed_weights = not not breed_weights
	local pick_first_target = ignore_direct_hit and not check_for_breed_weights
	local check_for_tag_weights = not not tag_weights

	self._num_visibility_checks_this_frame = 0

	local found_potential_targets = self:_try_find_target_with_raycast(visibility_cache, visibility_check_frame, fixed_frame, ray_origin, forward, min_range, max_range_raycast, max_angle_rad_raycast, nearby_target_units, nearby_target_positions, nearby_target_distances)
	local num_nearby_target_units = #nearby_target_units

	if num_nearby_target_units == 0 then
		targeting_data.unit = nil
		targeting_data.aim_score = -math.huge
		targeting_data.distance = nil
		targeting_data.target_position = nil
		targeting_data.target_rotation = nil

		return
	end

	local best_score = -math.huge
	local best_unit, best_unit_is_direct_hit, best_unit_distance, best_unit_aim_position, best_unit_distance_to_box, best_unit_distance_to_box_x, best_unit_distance_to_box_y
	local i = 0
	local early_exit = false

	while num_nearby_target_units >= i + 1 and not early_exit do
		repeat
			i = i + 1

			local hit_unit = nearby_target_units[i]
			local hit_unit_position = nearby_target_positions[i]
			local distance = nearby_target_distances[i]

			if optional_line_of_sight_cache then
				optional_line_of_sight_cache[hit_unit] = 0.3
			end

			local unit_data_extension = ScriptUnit_has_extension(hit_unit, "unit_data_system")
			local breed = unit_data_extension and unit_data_extension:breed()

			if not breed or not HEALTH_ALIVE[hit_unit] then
				break
			end

			local is_valid = true
			local tags = breed.tags

			if tags.horde or tags.melee and not tags.elite then
				num_insignificant_targets = num_insignificant_targets + 1

				if num_insignificant_targets_limit and num_insignificant_targets_limit < num_insignificant_targets then
					is_valid = false
				end
			end

			if not is_valid then
				break
			end

			local hit_unit_pose, _ = Unit_box(hit_unit, true)
			local object_right = Matrix4x4_right(hit_unit_pose)
			local object_forward = Matrix4x4_forward(hit_unit_pose)
			local object_up = Matrix4x4_up(hit_unit_pose)
			local world_extents_right = object_right * (breed.half_extent_right or 0.3)
			local world_extents_forward = object_forward * (breed.half_extent_forward or 0.3)
			local half_width = math_max(math_abs(Vector3_dot(right, world_extents_right + world_extents_forward)), math_abs(Vector3_dot(right, world_extents_right - world_extents_forward)))
			local half_height = Breed_height(hit_unit, breed) * 0.5
			local hit_unit_center_pos = hit_unit_position
			local direction_to_unit = hit_unit_center_pos - ray_origin
			local x_diff_no_abs = Vector3_dot(direction_to_unit, right)
			local x_diff = math_abs(x_diff_no_abs)
			local y_diff = math_abs(Vector3_dot(direction_to_unit, up))
			local epsilon = 0.01
			local direct_hit = x_diff <= half_width + epsilon and y_diff <= half_height + epsilon
			local aim_position = self:_target_aim_position_using_actor(ray_origin, forward, right, up, hit_unit_center_pos, distance, hit_unit_position, breed.name, half_width, half_height, x_diff_no_abs, hit_unit, fixed_frame)

			if direct_hit and not ignore_direct_hit then
				best_unit = hit_unit
				best_unit_is_direct_hit = true
				best_unit_distance = distance
				best_unit_aim_position = aim_position
				best_unit_distance_to_box = 0
				best_unit_distance_to_box_x = 0
				best_unit_distance_to_box_y = 0
				best_score = math.huge
				early_exit = true

				break
			end

			if not only_direct_hit and (not best_unit or not pick_first_target) then
				local score = num_nearby_target_units - i + 1

				if check_for_breed_weights then
					local breed_name = breed.name
					local target_weight = breed_weights[breed_name] or 1

					score = score * target_weight
				end

				if check_for_tag_weights then
					local tags = breed.tags

					if tags then
						local tag_weight = 0

						for tag, _ in pairs(tags) do
							score = score * (tag_weights[tag] or 0)
						end
					end
				end

				if score < best_score then
					break
				end

				best_unit, best_unit_is_direct_hit, best_unit_distance, best_unit_aim_position = hit_unit, false, distance, aim_position
				best_unit_distance_to_box, best_unit_distance_to_box_x, best_unit_distance_to_box_y = self:get_unit_distance_to_box(distance, half_width, half_height, x_diff, y_diff, epsilon)
				best_score = score
				early_exit = pick_first_target
			end
		until true
	end

	targeting_data.unit = best_unit
	targeting_data.aim_score = best_score
	targeting_data.distance = best_unit_distance

	if best_unit then
		local target_position_box = self._target_position_box

		target_position_box:store(best_unit_aim_position)

		targeting_data.target_position = target_position_box

		local current_rotation = self._first_person_component.rotation
		local target_rotation = Quaternion.look(best_unit_aim_position - ray_origin, Vector3.up())
		local yaw = Quaternion.yaw(target_rotation)
		local pitch = Quaternion.pitch(current_rotation)
		local roll = Quaternion.roll(current_rotation)
		local target_rotation_box = self._target_rotation_box

		target_rotation_box:store(Quaternion.from_yaw_pitch_roll(yaw, pitch, roll))

		targeting_data.target_rotation = target_rotation_box
		targeting_data.distance_to_box = best_unit_distance_to_box
		targeting_data.distance_to_box_x = best_unit_distance_to_box_x
		targeting_data.distance_to_box_y = best_unit_distance_to_box_y
	else
		targeting_data.target_position = nil
		targeting_data.target_rotation = nil
	end
end

local half_height_mod = 0.3333333333333333

PrecisionTargetFinderAutoAim._target_aim_position_using_box = function (self, ray_origin, forward, right, up, hit_unit_center_pos, distance_to_center_pos, half_width, half_height, x_diff_no_abs, hit_unit)
	local aim_position = ray_origin + forward * distance_to_center_pos
	local sub_box_half_height = half_height * half_height_mod
	local top_position = hit_unit_center_pos + up * sub_box_half_height * 2
	local bottom_position = hit_unit_center_pos - up * sub_box_half_height * 2
	local aim_z, top_z, middle_z, bottom_z = aim_position.z, top_position.z, hit_unit_center_pos.z, bottom_position.z
	local top_z_distance = math_abs(top_z - aim_z)
	local mid_z_distance = math_abs(middle_z - aim_z)
	local bot_z_distance = math_abs(bottom_z - aim_z)
	local shortest_distance = math_min(top_z_distance, mid_z_distance, bot_z_distance)
	local aim_target

	if top_z_distance == shortest_distance then
		aim_target = top_position
	elseif mid_z_distance == shortest_distance then
		aim_target = hit_unit_center_pos
	elseif bot_z_distance == shortest_distance then
		aim_target = bottom_position
	else
		aim_target = hit_unit_center_pos
	end

	return aim_target
end

local OVERRIDE_AIM_NODE_BY_BREED = {
	chaos_armored_hound = "enemy_aim_target_02",
	chaos_hound = "enemy_aim_target_02",
}

PrecisionTargetFinderAutoAim._target_aim_position_using_actor = function (self, ray_origin, forward, right, up, hit_unit_center_pos, distance_to_center_pos, rewound_afro_center_pos, breed_name, half_width, half_height, x_diff_no_abs, hit_unit)
	local aim_position = ray_origin + forward * distance_to_center_pos
	local sub_box_half_height = half_height * half_height_mod
	local top_position = hit_unit_center_pos + up * sub_box_half_height * 2
	local bottom_position = hit_unit_center_pos - up * sub_box_half_height * 2
	local aim_z, top_z, middle_z, bottom_z = aim_position.z, top_position.z, hit_unit_center_pos.z, bottom_position.z
	local top_z_distance = math_abs(top_z - aim_z)
	local mid_z_distance = math_abs(middle_z - aim_z)
	local bot_z_distance = math_abs(bottom_z - aim_z)
	local shortest_distance = math_min(top_z_distance, mid_z_distance, bot_z_distance)
	local node_name_to_aim_towards

	if OVERRIDE_AIM_NODE_BY_BREED[breed_name] ~= nil then
		node_name_to_aim_towards = OVERRIDE_AIM_NODE_BY_BREED[breed_name]
	else
		node_name_to_aim_towards = top_z_distance == shortest_distance and "enemy_aim_target_03" or mid_z_distance == shortest_distance and "enemy_aim_target_02" or bot_z_distance == shortest_distance and "enemy_aim_target_01" or "enemy_aim_target_02"
	end

	local node_to_aim_towards = Unit.node(hit_unit, node_name_to_aim_towards)
	local aim_target = Unit.world_position(hit_unit, node_to_aim_towards)
	local hit_unit_afro = Unit.node(hit_unit, "r_afro")
	local hit_unit_afro_position = Unit.world_position(hit_unit, hit_unit_afro)
	local final_aim_target_position = rewound_afro_center_pos + Vector3.multiply(aim_target - hit_unit_afro_position, 1)

	return final_aim_target_position
end

PrecisionTargetFinderAutoAim.assisted_hitscan_trajectory = function (self, targeting_data, smart_targeting_template, weapon_template, raw_aim_rotation)
	local first_person_position = self._first_person_component.position

	if targeting_data.target_position then
		return Quaternion.look(targeting_data.target_position:unbox() - first_person_position)
	else
		return raw_aim_rotation
	end
end

implements(PrecisionTargetFinderAutoAim, PrecisionTargetFinderInterface)

return PrecisionTargetFinderAutoAim
