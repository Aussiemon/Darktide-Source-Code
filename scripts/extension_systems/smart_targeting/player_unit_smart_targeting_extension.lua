local Breed = require("scripts/utilities/breed")
local LagCompensation = require("scripts/utilities/lag_compensation")
local Recoil = require("scripts/utilities/recoil")
local SmartTargeting = require("scripts/utilities/smart_targeting")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local Sway = require("scripts/utilities/sway")
local EMPTY_TABLE = {}
local INDEX_POSITION = 1
local INDEX_DISTANCE = 2
local INDEX_ACTOR = 4
local SMART_TAG_TARGETING_DELAY = 0.2
local PlayerUnitSmartTargetingExtension = class("PlayerUnitSmartTargetingExtension")

PlayerUnitSmartTargetingExtension.init = function (self, extension_init_context, unit, extension_init_data)
	self._unit = unit
	self._world = extension_init_context.world
	self._player = extension_init_data.player
	self._is_server = extension_init_data.is_server
	self._is_local_unit = extension_init_data.is_local_unit
	self._is_social_hub = extension_init_data.is_social_hub
	local physics_world = extension_init_context.physics_world
	self._physics_world = physics_world
	self._latest_fixed_frame = extension_init_context.fixed_frame
	self._targeting_data = {}
	self._target_unit = nil
	self._smart_tag_targeting_data = {}
	self._smart_tag_targeting_time = 0
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	self._unit_data_extension = unit_data_extension
	self._first_person_component = unit_data_extension:read_component("first_person")
	self._inventory_component = unit_data_extension:read_component("inventory")
	self._movement_state_component = unit_data_extension:read_component("movement_state")
	self._recoil_component = unit_data_extension:read_component("recoil")
	self._recoil_control_component = unit_data_extension:read_component("recoil_control")
	self._sway_component = unit_data_extension:read_component("sway")
	self._sway_control_component = unit_data_extension:read_component("sway_control")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._target_position_box = Vector3Box(Vector3.zero())
	self._target_rotation_box = QuaternionBox(Quaternion.identity())
	self._visibility_raycast_object = PhysicsWorld.make_raycast(physics_world, "closest", "types", "statics", "collision_filter", "filter_ray_aim_assist_line_of_sight")
	self._line_of_sight_cache = {}
	self._visibility_cache = {}
	self._visibility_check_frame = {}
end

PlayerUnitSmartTargetingExtension.extensions_ready = function (self)
	local unit = self._unit
	self._first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	self._weapon_extension = ScriptUnit.extension(unit, "weapon_system")
end

PlayerUnitSmartTargetingExtension.fixed_update = function (self, unit, dt, t, fixed_frame)
	self._latest_fixed_frame = fixed_frame

	if self._unit_data_extension.is_resimulating then
		table.clear(self._targeting_data)
		table.clear(self._smart_tag_targeting_data)

		return
	end

	if not self._player:is_human_controlled() then
		return
	end

	local smart_targeting_template = SmartTargeting.smart_targeting_template(t, self._weapon_action_component)
	self._num_visibility_checks_this_frame = 0
	local ray_origin, forward, right, up = self:_targeting_parameters()
	local line_of_sight_cache = self._line_of_sight_cache

	for los_unit, time in pairs(line_of_sight_cache) do
		time = time - dt

		if time < 0 then
			line_of_sight_cache[los_unit] = nil
		else
			line_of_sight_cache[los_unit] = time
		end
	end

	self:_update_precision_target(unit, smart_targeting_template, ray_origin, forward, right, up, self._targeting_data, fixed_frame, line_of_sight_cache)
	self:_update_proximity(unit, smart_targeting_template, ray_origin, forward, right, up)

	if not DEDICATED_SERVER and self._is_local_unit and not self._is_social_hub then
		local update_tag_targets = self._smart_tag_targeting_time <= t

		if update_tag_targets then
			self:_update_precision_target(unit, SmartTargetingTemplates.smart_tag_target, ray_origin, forward, right, up, self._smart_tag_targeting_data, fixed_frame)

			self._smart_tag_targeting_time = t + SMART_TAG_TARGETING_DELAY
		end
	end

	if fixed_frame % 20 == 0 then
		local visibility_check_frame = self._visibility_check_frame
		local visibility_cache = self._visibility_cache

		for cached_unit, check_frame in pairs(visibility_check_frame) do
			if fixed_frame - check_frame > 5 then
				visibility_cache[cached_unit] = nil
				visibility_check_frame[cached_unit] = nil
			end
		end
	end
end

PlayerUnitSmartTargetingExtension._targeting_parameters = function (self)
	local first_person_component = self._first_person_component
	local ray_origin = first_person_component.position
	local rotation_1p = first_person_component.rotation
	local ray_rotation = first_person_component.rotation
	local weapon_extension = self._weapon_extension
	local recoil_template = weapon_extension:recoil_template()
	local sway_template = weapon_extension:sway_template()
	local movement_state_component = self._movement_state_component
	ray_rotation = Recoil.apply_weapon_recoil_rotation(recoil_template, self._recoil_component, movement_state_component, ray_rotation)
	ray_rotation = Sway.apply_sway_rotation(sway_template, self._sway_component, movement_state_component, ray_rotation)
	local forward = Quaternion.forward(ray_rotation)
	local right = Quaternion.right(rotation_1p)
	local up = Quaternion.up(rotation_1p)

	return ray_origin, forward, right, up
end

PlayerUnitSmartTargetingExtension._update_precision_target = function (self, unit, smart_targeting_template, ray_origin, forward, right, up, targeting_data, fixed_frame, optional_line_of_sight_cache)
	local static_hit_position_box = targeting_data.static_hit_position or Vector3Box()

	table.clear(targeting_data)

	local precision_target_settings = smart_targeting_template and smart_targeting_template.precision_target

	if not precision_target_settings then
		return
	end

	local best_unit, best_unit_distance, best_unit_aim_position, static_hit_position, best_unit_distance_to_box, best_unit_distance_to_box_x, best_unit_distance_to_box_y = nil
	local rewind_ms = LagCompensation.rewind_ms(self._is_server, self._is_local_unit, self._player)
	local physics_world = self._physics_world
	local min_range = precision_target_settings.min_range
	local max_range = precision_target_settings.max_range
	local max_unit_range = precision_target_settings.max_unit_range or max_range
	local target_node_name = precision_target_settings.wanted_target
	local fallback_node_name = precision_target_settings.wanted_target_fallback
	local breed_weights = precision_target_settings.breed_weights or EMPTY_TABLE
	local smart_tagging = precision_target_settings.smart_tagging
	local collision_filter = precision_target_settings.collision_filter or smart_tagging and "filter_player_ping_target_selection" or "filter_ray_aim_assist"
	local within_distance_to_box_x = precision_target_settings.within_distance_to_box_x or 0.7
	local within_distance_to_box_y = precision_target_settings.within_distance_to_box_y or 0.2
	local hits, num_hits = PhysicsWorld.raycast(physics_world, ray_origin, forward, max_range, "all", "collision_filter", collision_filter, "rewind_ms", rewind_ms)
	local best_score = -math.huge
	local math_abs = math.abs
	local math_max = math.max
	local math_atan = math.atan
	local math_log = math.log
	local Vector3_dot = Vector3.dot
	local Vector3_length = Vector3.length
	local Quaternion = Quaternion
	local Actor_unit = Actor.unit
	local ScriptUnit_has_extension = ScriptUnit.has_extension
	local Breed_is_prop = Breed.is_prop
	local Breed_is_living_prop = Breed.is_living_prop
	local Unit_box = Unit.box
	local Actor_world_bounds = Actor.world_bounds
	local Matrix4x4_right = Matrix4x4.right
	local Matrix4x4_forward = Matrix4x4.forward
	local Breed_height = Breed.height
	local Vector3_normalize = Vector3.normalize
	local Unit_get_data = Unit.get_data
	local visibility_cache = self._visibility_cache
	local visibility_check_frame = self._visibility_check_frame
	local num_insignificant_targets = 0
	local last_insignificant_target_was_visible = false

	for i = 1, num_hits do
		local hit = hits[i]
		local hit_actor = hit[INDEX_ACTOR]
		local hit_position = hit[INDEX_POSITION]
		local distance = nil

		if hit_actor then
			local hit_unit = Actor_unit(hit_actor)
			local unit_data_extension = ScriptUnit_has_extension(hit_unit, "unit_data_system")
			local is_valid = false
			local is_static = false
			local breed = unit_data_extension and unit_data_extension:breed()
			local is_insignificant_target = false

			if smart_tagging then
				local tag_extension = ScriptUnit_has_extension(hit_unit, "smart_tag_system")

				if tag_extension then
					if tag_extension:can_tag(unit) then
						local target_actor = tag_extension:target_actor()

						if not target_actor or target_actor == hit_actor then
							is_valid = true
						end
					end
				elseif not unit_data_extension then
					local ignore_raycast = Unit_get_data(hit_unit, "ignored_by_interaction_raycast")
					is_static = not ignore_raycast
				end
			elseif unit_data_extension and HEALTH_ALIVE[hit_unit] then
				is_valid = true
				local tags = breed.tags

				if tags.horde or tags.melee and not tags.elite then
					is_insignificant_target = true
					num_insignificant_targets = num_insignificant_targets + 1

					if num_insignificant_targets > 5 then
						is_valid = false
					end
				end
			elseif not unit_data_extension then
				is_static = true
			end

			local is_prop = Breed_is_prop(breed) or Breed_is_living_prop(breed)
			local include_even_if_prop = not is_prop or smart_tagging

			if include_even_if_prop and is_valid and best_score ~= math.huge then
				if is_prop then
					breed = nil
				end

				local hit_unit_pose, half_extents = Unit_box(hit_unit, true)
				local hit_unit_center_pos, _ = Actor_world_bounds(hit_actor)
				local object_right = Matrix4x4_right(hit_unit_pose)
				local object_forward = Matrix4x4_forward(hit_unit_pose)
				local half_width, half_height, target_weight = nil

				if breed then
					local world_extents_right = object_right * (breed.half_extent_right or 0.3)
					local world_extents_forward = object_forward * (breed.half_extent_forward or 0.3)
					half_width = math_max(math_abs(Vector3_dot(right, world_extents_right + world_extents_forward)), math_abs(Vector3_dot(right, world_extents_right - world_extents_forward)))
					half_height = Breed_height(hit_unit, breed) * 0.5
					local breed_name = breed.name
					target_weight = breed_weights[breed_name] or 1
					min_range = half_width
				else
					local world_extents_right = object_right * half_extents.x
					local world_extents_forward = object_forward * half_extents.y
					half_width = 0.5 * math_max(math_abs(Vector3_dot(right, world_extents_right + world_extents_forward)), math_abs(Vector3_dot(right, world_extents_right - world_extents_forward)))
					half_height = half_extents.z
					target_weight = 1
				end

				distance = Vector3_length(hit_unit_center_pos - ray_origin) - half_width

				if min_range < distance and distance <= max_unit_range then
					local hit_offset = hit_position - hit_unit_center_pos
					local x_diff_no_abs = Vector3_dot(hit_offset, right)
					local x_diff = math_abs(x_diff_no_abs)
					local y_diff = math_abs(Vector3_dot(hit_offset, up))
					local epsilon = 0.01
					local direct_hit = x_diff <= half_width + epsilon and y_diff <= half_height + epsilon
					local only_direct_hit = smart_targeting_template.only_direct_hit
					local visible_target, aim_position = nil

					if breed then
						visible_target, aim_position = self:_target_visibility_and_aim_position(ray_origin, forward, right, up, hit_unit_center_pos, distance, half_width, half_height, x_diff_no_abs, hit_unit, fixed_frame, visibility_cache, visibility_check_frame)

						if optional_line_of_sight_cache and visible_target then
							optional_line_of_sight_cache[hit_unit] = 0.3
						end
					else
						aim_position = hit_unit_center_pos
						visible_target = true
					end

					local hit_direction = Vector3_normalize(hit_unit_center_pos - ray_origin)
					local hit_dot = Vector3_dot(forward, hit_direction)
					local in_front_check = hit_dot > 0.7

					if not visible_target then
						-- Nothing
					elseif direct_hit and in_front_check then
						best_unit = hit_unit
						best_unit_distance = distance
						best_unit_aim_position = aim_position
						best_unit_distance_to_box = 0
						best_unit_distance_to_box_x = 0
						best_unit_distance_to_box_y = 0
						best_score = math.huge

						if not smart_tagging then
							break
						end
					elseif not only_direct_hit then
						local angle_width = math_atan(half_width / distance)
						local angle_height = math_atan(half_height / distance)
						local angle_x_diff = math_atan(x_diff / distance)
						local angle_y_diff = math_atan(y_diff / distance)
						local x_offset = math_max((angle_x_diff - angle_width) / angle_width, epsilon) / math_log(angle_width)
						local y_offset = math_max((angle_y_diff - angle_height) / angle_height, epsilon) / math_log(angle_height)
						local utility = 1 / (x_offset * y_offset) * target_weight
						local x_distance = math_abs(x_offset)
						local y_distance = math_abs(y_offset)
						local within_distance = x_distance <= within_distance_to_box_x and y_distance <= within_distance_to_box_y

						if best_score < utility and within_distance then
							best_unit = hit_unit
							best_unit_distance = distance
							best_unit_aim_position = aim_position
							best_unit_distance_to_box = math_max(x_distance, y_distance)
							best_unit_distance_to_box_x = x_distance
							best_unit_distance_to_box_y = y_distance
							best_score = utility
						end
					end
				end
			elseif is_static then
				static_hit_position = hit_position

				break
			end
		end
	end

	targeting_data.unit = best_unit
	targeting_data.aim_score = best_score
	targeting_data.distance = best_unit_distance

	if best_unit then
		local own_position = self._first_person_component.position
		local target_position_box = self._target_position_box

		target_position_box:store(best_unit_aim_position)

		targeting_data.target_position = target_position_box
		local current_rotation = self._first_person_component.rotation
		local target_rotation = Quaternion.look(best_unit_aim_position - own_position, Vector3.up())
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

	if static_hit_position then
		Vector3Box.store(static_hit_position_box, static_hit_position)

		targeting_data.static_hit_position = static_hit_position_box
	end
end

local nearby_target_units = {}
local nearby_target_positions = {}
local nearby_target_distances = {}

PlayerUnitSmartTargetingExtension._update_proximity = function (self, unit, smart_targeting_template, ray_origin, forward, right, up)
	table.clear(nearby_target_units)
	table.clear(nearby_target_positions)
	table.clear(nearby_target_distances)

	local proximity_settings = smart_targeting_template and smart_targeting_template.proximity

	if not proximity_settings then
		return
	end

	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local min_range = proximity_settings.min_range
	local max_range = proximity_settings.max_range
	local max_angle = proximity_settings.max_angle
	local distance_weight = proximity_settings.distance_weight
	local angle_weight = proximity_settings.angle_weight
	local max_results = proximity_settings.max_results
	local num_nearby_target_units = EngineOptimized.smart_targeting_query(broadphase, "enemy_aim_target_02", ray_origin, forward, min_range, max_range, max_angle, distance_weight, angle_weight, max_results, nearby_target_units, nearby_target_positions, nearby_target_distances, enemy_side_names)
	local targeting_data = self._targeting_data
	targeting_data.targets_within_range = num_nearby_target_units > 0
end

PlayerUnitSmartTargetingExtension.assisted_hitscan_trajectory = function (self, smart_targeting_template, weapon_template, raw_aim_rotation)
	local targeting_data = self._targeting_data
	local trajectory_assist_settings = smart_targeting_template and smart_targeting_template.trajectory_assist

	if not targeting_data.unit or not trajectory_assist_settings then
		return raw_aim_rotation
	end

	local weapon_extension = self._weapon_extension
	local first_person_component = self._first_person_component
	local own_position = first_person_component.position
	local range = trajectory_assist_settings.range
	local distance = targeting_data.distance
	local falloff_multiplier = trajectory_assist_settings.falloff_func(range, distance)
	local recoil_template = weapon_extension:recoil_template()
	local recoil_multiplier = Recoil.aim_assist_multiplier(recoil_template, self._recoil_control_component, self._recoil_component, self._movement_state_component)
	local multiplier = trajectory_assist_settings.assist_multiplier * falloff_multiplier * recoil_multiplier
	local wanted_rotation = Quaternion.look(targeting_data.target_position:unbox() - own_position)
	local error_angle = Quaternion.angle(raw_aim_rotation, wanted_rotation)
	local t_value = nil

	if multiplier == 0 then
		t_value = 0
	else
		local min = trajectory_assist_settings.min_angle * multiplier
		local max = trajectory_assist_settings.max_angle * multiplier
		t_value = math.clamp((error_angle - min) / max - min, 0, 1)
	end

	local assisted_aim_rotation = Quaternion.lerp(wanted_rotation, raw_aim_rotation, t_value)

	return assisted_aim_rotation
end

local math_abs = math.abs
local math_min = math.min
local Vector3_length = Vector3.length
local Vector3_normalize = Vector3.normalize
local Raycast_cast = Raycast.cast
local half_height_mod = 0.3333333333333333
local half_width_mod = 0.5

PlayerUnitSmartTargetingExtension._target_visibility_and_aim_position = function (self, ray_origin, forward, right, up, hit_unit_center_pos, distance_to_center_pos, half_width, half_height, x_diff_no_abs, hit_unit, fixed_frame, visibility_cache, visibility_check_frame)
	local num_visibility_checks_this_frame = self._num_visibility_checks_this_frame + 1
	local use_cached_result = false
	local cached_visibility = visibility_cache[hit_unit]

	if cached_visibility ~= nil then
		local last_check_frame = visibility_check_frame[hit_unit]

		if fixed_frame - last_check_frame < 5 then
			use_cached_result = true
		end
	end

	local skip_raycast = false

	if use_cached_result then
		if cached_visibility == false then
			return false
		end
	elseif num_visibility_checks_this_frame > 5 then
		skip_raycast = true
	else
		self._num_visibility_checks_this_frame = num_visibility_checks_this_frame
	end

	local first_ray_pos = nil
	local aim_position = ray_origin + forward * distance_to_center_pos
	local sub_box_half_height = half_height * half_height_mod
	local top_position = hit_unit_center_pos + up * sub_box_half_height * 2
	local bottom_position = hit_unit_center_pos - up * sub_box_half_height * 2
	local aim_z = aim_position.z
	local top_z = top_position.z
	local middle_z = hit_unit_center_pos.z
	local bottom_z = bottom_position.z
	local top_z_distance = math_abs(top_z - aim_z)
	local mid_z_distance = math_abs(middle_z - aim_z)
	local bot_z_distance = math_abs(bottom_z - aim_z)
	local shortest_distance = math_min(top_z_distance, mid_z_distance, bot_z_distance)

	if top_z_distance == shortest_distance then
		first_ray_pos = top_position
	elseif mid_z_distance == shortest_distance then
		first_ray_pos = hit_unit_center_pos
	elseif bot_z_distance == shortest_distance then
		first_ray_pos = bottom_position
	else
		first_ray_pos = hit_unit_center_pos
	end

	if use_cached_result and cached_visibility == "center" then
		return true, first_ray_pos
	elseif not use_cached_result then
		if skip_raycast then
			return true, first_ray_pos
		end

		local to_first_ray = first_ray_pos - ray_origin
		local first_hit = Raycast_cast(self._visibility_raycast_object, ray_origin, Vector3_normalize(to_first_ray), Vector3_length(to_first_ray))

		if not first_hit then
			visibility_cache[hit_unit] = "center"
			visibility_check_frame[hit_unit] = fixed_frame

			return true, first_ray_pos
		end
	end

	local left = x_diff_no_abs < 0
	local second_ray_pos = nil

	if left then
		second_ray_pos = first_ray_pos - right * half_width * half_width_mod
	elseif not left then
		second_ray_pos = first_ray_pos + right * half_width * half_width_mod
	end

	if use_cached_result then
		return true, second_ray_pos
	else
		local to_second_ray = second_ray_pos - ray_origin
		local second_hit = Raycast_cast(self._visibility_raycast_object, ray_origin, Vector3_normalize(to_second_ray), Vector3_length(to_second_ray))
		visibility_cache[hit_unit] = not second_hit
		visibility_check_frame[hit_unit] = fixed_frame

		return not second_hit, second_ray_pos
	end
end

PlayerUnitSmartTargetingExtension.targeting_data = function (self)
	return self._targeting_data
end

PlayerUnitSmartTargetingExtension.smart_tag_targeting_data = function (self)
	return self._smart_tag_targeting_data
end

PlayerUnitSmartTargetingExtension.has_line_of_sight = function (self, unit)
	return self._line_of_sight_cache[unit] ~= nil
end

PlayerUnitSmartTargetingExtension.force_update_smart_tag_targets = function (self)
	local ray_origin, forward, right, up = self:_targeting_parameters()

	self:_update_precision_target(self._unit, SmartTargetingTemplates.smart_tag_target, ray_origin, forward, right, up, self._smart_tag_targeting_data, self._latest_fixed_frame)
end

return PlayerUnitSmartTargetingExtension
