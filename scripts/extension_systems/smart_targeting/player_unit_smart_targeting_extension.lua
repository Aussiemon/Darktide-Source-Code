local Breed = require("scripts/utilities/breed")
local LagCompensation = require("scripts/utilities/lag_compensation")
local Recoil = require("scripts/utilities/recoil")
local SmartTargeting = require("scripts/utilities/smart_targeting")
local SmartTargetingTemplates = require("scripts/settings/equipment/smart_targeting_templates")
local Sway = require("scripts/utilities/sway")
local EMPTY_TABLE = {}
local INDEX_POSITION = 1
local INDEX_ACTOR = 4
local SMART_TAG_TARGETING_DELAY = 0.2
local PlayerUnitSmartTargetingExtension = class("PlayerUnitSmartTargetingExtension")

PlayerUnitSmartTargetingExtension.init = function (self, extension_init_context, unit, extension_init_data)
	self._unit = unit
	self._world = extension_init_context.world
	self._player = extension_init_data.player
	self._is_server = extension_init_data.is_server
	self._is_local_unit = extension_init_data.is_local_unit
	self._physics_world = extension_init_context.physics_world
	self._targeting_data = {}
	self._target_unit = nil
	self._smart_tag_targeting_data = {}
	self._smart_tag_targeting_time = 0
	self._smart_tag_targeting_updated_current_frame = false
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
end

PlayerUnitSmartTargetingExtension.extensions_ready = function (self)
	local unit = self._unit
	self._first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	self._weapon_extension = ScriptUnit.extension(unit, "weapon_system")
end

PlayerUnitSmartTargetingExtension.fixed_update = function (self, unit, dt, t, frame)
	if self._unit_data_extension.is_resimulating then
		table.clear(self._targeting_data)
		table.clear(self._smart_tag_targeting_data)

		return
	end

	if not self._player:is_human_controlled() then
		return
	end

	local smart_targeting_template = SmartTargeting.smart_targeting_template(t, self._weapon_action_component)
	local ray_origin, forward, right, up = self:_targeting_parameters()

	self:_update_precision_target(unit, smart_targeting_template, ray_origin, forward, right, up, self._targeting_data)
	self:_update_proximity(unit, smart_targeting_template, ray_origin, forward, right, up)

	if not DEDICATED_SERVER and self._is_local_unit then
		local update_tag_targets = self._smart_tag_targeting_time <= t

		if update_tag_targets then
			self:_update_precision_target(unit, SmartTargetingTemplates.smart_tag_target, ray_origin, forward, right, up, self._smart_tag_targeting_data)

			self._smart_tag_targeting_time = t + SMART_TAG_TARGETING_DELAY
		end

		self._smart_tag_targeting_updated_current_frame = update_tag_targets
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

PlayerUnitSmartTargetingExtension._update_precision_target = function (self, unit, smart_targeting_template, ray_origin, forward, right, up, targeting_data)
	local static_hit_position_box = targeting_data.static_hit_position or Vector3Box()

	table.clear(targeting_data)

	local precision_target_settings = smart_targeting_template and smart_targeting_template.precision_target

	if not precision_target_settings then
		return
	end

	local best_unit, best_unit_distance, best_unit_aim_position, static_hit_position = nil
	local rewind_ms = LagCompensation.rewind_ms(self._is_server, self._is_local_unit, self._player)
	local physics_world = self._physics_world
	local min_range = precision_target_settings.min_range
	local max_range = precision_target_settings.max_range
	local max_unit_range = precision_target_settings.max_unit_range or max_range
	local target_node_name = precision_target_settings.wanted_target
	local breed_weights = precision_target_settings.breed_weights or EMPTY_TABLE
	local smart_tagging = precision_target_settings.smart_tagging
	local collision_filter = precision_target_settings.collision_filter or smart_tagging and "filter_player_ping_target_selection" or "filter_ray_aim_assist"
	local hit_dot_check = precision_target_settings.hit_dot_check or 0.7
	local hits, num_hits = PhysicsWorld.raycast(physics_world, ray_origin, forward, max_range, "all", "collision_filter", collision_filter, "rewind_ms", rewind_ms)
	local best_score = -math.huge
	local math_abs = math.abs
	local math_max = math.max
	local math_atan = math.atan
	local math_log = math.log
	local Vector3_dot = Vector3.dot
	local Vector3_length = Vector3.length
	local Unit_get_data = Unit.get_data

	for i = 1, num_hits do
		local hit = hits[i]
		local hit_actor = hit[INDEX_ACTOR]
		local hit_position = hit[INDEX_POSITION]
		local distance = nil

		if hit_actor then
			local hit_unit = Actor.unit(hit_actor)
			local unit_data_extension = ScriptUnit.has_extension(hit_unit, "unit_data_system")
			local is_valid = false
			local is_static = false

			if smart_tagging then
				local tag_extension = ScriptUnit.has_extension(hit_unit, "smart_tag_system")

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
			elseif not unit_data_extension then
				is_static = true
			end

			local breed = unit_data_extension and unit_data_extension:breed()
			local is_prop = Breed.is_prop(breed) or Breed.is_living_prop(breed)
			local include_even_if_prop = not is_prop or smart_tagging

			if include_even_if_prop and is_valid and best_score ~= math.huge then
				if is_prop then
					breed = nil
				end

				local hit_unit_pose, half_extents = Unit.box(hit_unit, true)
				local hit_unit_center_pos, _ = Actor.world_bounds(hit_actor)
				local object_right = Matrix4x4.right(hit_unit_pose)
				local object_forward = Matrix4x4.forward(hit_unit_pose)
				local half_width, half_height, target_weight = nil

				if breed then
					local world_extents_right = object_right * 0.3
					local world_extents_forward = object_forward * 0.3
					half_width = math_max(math_abs(Vector3_dot(right, world_extents_right + world_extents_forward)), math_abs(Vector3_dot(right, world_extents_right - world_extents_forward)))
					half_height = Breed.height(hit_unit, breed) * 0.5
					local breed_name = breed.name
					target_weight = breed_weights[breed_name] or 1
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
					local x_diff = math_abs(Vector3_dot(hit_offset, right))
					local y_diff = math_abs(Vector3_dot(hit_offset, up))
					local epsilon = 0.01
					local direct_hit = x_diff <= half_width + epsilon and y_diff <= half_height + epsilon
					local only_direct_hit = smart_targeting_template.only_direct_hit
					local visible_target, aim_position = nil

					if breed then
						visible_target, aim_position = self:_target_visibility_and_aim_position(breed, hit_unit, ray_origin, target_node_name)
					else
						visible_target, aim_position = self:_target_visibility_and_aim_position_non_breed(hit_unit, ray_origin, hit_actor, hits, i)
					end

					if not visible_target then
						-- Nothing
					elseif direct_hit then
						best_unit = hit_unit
						best_unit_distance = distance
						best_unit_aim_position = aim_position
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
						local y_offset = math_max((angle_y_diff - angle_height) / angle_width, epsilon) / math_log(angle_width)
						local utility = 1 / (x_offset * y_offset) * target_weight

						if best_score < utility then
							local hit_direction = Vector3.normalize(hit_unit_center_pos - ray_origin)
							local hit_dot = Vector3_dot(forward, hit_direction)

							if hit_dot_check < hit_dot then
								best_unit = hit_unit
								best_unit_distance = distance
								best_unit_aim_position = aim_position
								best_score = utility
							end
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
		targeting_data.target_position = Vector3Box(best_unit_aim_position)
		local current_rotation = self._first_person_component.rotation
		local target_rotation = Quaternion.look(best_unit_aim_position - own_position, Vector3.up())
		local yaw = Quaternion.yaw(target_rotation)
		local pitch = Quaternion.pitch(current_rotation)
		local roll = Quaternion.roll(current_rotation)
		local target_rotation_box = QuaternionBox(Quaternion.from_yaw_pitch_roll(yaw, pitch, roll))
		targeting_data.target_rotation = target_rotation_box
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

local FALLBACK_NODE_NAME = "enemy_aim_target_02"

PlayerUnitSmartTargetingExtension._target_visibility_and_aim_position = function (self, target_breed, target_unit, own_position, target_node_name)
	local wanted_node_name = target_node_name or FALLBACK_NODE_NAME
	local wanted_pos = Unit.world_position(target_unit, Unit.node(target_unit, wanted_node_name))
	local weakspot_direction = Vector3.normalize(wanted_pos - own_position)
	local weakspot_distance = Vector3.length(wanted_pos - own_position)
	local physics_world = self._physics_world
	local hit = PhysicsWorld.raycast(physics_world, own_position, weakspot_direction, weakspot_distance, "closest", "collision_filter", "filter_ray_aim_assist_line_of_sight")
	local visible_target, target_position = nil

	if not hit then
		visible_target = true
		target_position = wanted_pos
	elseif FALLBACK_NODE_NAME ~= wanted_node_name then
		local center_mass_pos = Unit.world_position(target_unit, Unit.node(target_unit, FALLBACK_NODE_NAME))
		local center_mass_direction = Vector3.normalize(center_mass_pos - own_position)
		local center_mass_distance = Vector3.length(center_mass_pos - own_position)
		hit = PhysicsWorld.raycast(physics_world, own_position, center_mass_direction, center_mass_distance, "closest", "collision_filter", "filter_ray_aim_assist_line_of_sight")
		visible_target = not hit
		target_position = visible_target and center_mass_pos or nil
	end

	return visible_target, target_position
end

PlayerUnitSmartTargetingExtension._target_visibility_and_aim_position_non_breed = function (self, target_unit, own_position, target_actor, hits, current_index)
	local owner_unit = self._unit
	local Unit_get_data = Unit.get_data

	for ii = current_index - 1, 1, -1 do
		local hit = hits[ii]
		local hit_actor = hit[INDEX_ACTOR]
		local hit_unit = Actor.unit(hit_actor)
		local ignore_raycast = Unit_get_data(hit_unit, "ignored_by_interaction_raycast")

		if not ignore_raycast and hit_unit ~= owner_unit then
			return false, nil
		end
	end

	return true, Actor.world_bounds(target_actor)
end

PlayerUnitSmartTargetingExtension.targeting_data = function (self)
	return self._targeting_data
end

PlayerUnitSmartTargetingExtension.smart_tag_targeting_data = function (self)
	return self._smart_tag_targeting_data
end

PlayerUnitSmartTargetingExtension.force_update_smart_tag_targets = function (self)
	if self._smart_tag_targeting_updated_current_frame then
		return
	end

	local ray_origin, forward, right, up = self:_targeting_parameters()

	self:_update_precision_target(self._unit, SmartTargetingTemplates.smart_tag_target, ray_origin, forward, right, up, self._smart_tag_targeting_data)
end

return PlayerUnitSmartTargetingExtension
