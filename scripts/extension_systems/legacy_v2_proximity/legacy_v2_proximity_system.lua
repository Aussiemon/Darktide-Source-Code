-- chunkname: @scripts/extension_systems/legacy_v2_proximity/legacy_v2_proximity_system.lua

require("scripts/extension_systems/legacy_v2_proximity/minion_proximity_extension")
require("scripts/extension_systems/legacy_v2_proximity/player_proximity_extension")

local Breed = require("scripts/utilities/breed")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local DialogueBreedSettings = require("scripts/settings/dialogue/dialogue_breed_settings")
local DialogueSettings = require("scripts/settings/dialogue/dialogue_settings")
local Vo = require("scripts/utilities/vo")
local breed_types = BreedSettings.types
local ENEMY_PROXIMITY_DISTANCE = DialogueSettings.enemy_proximity_distance
local ENEMY_PROXIMITY_DISTANCE_HEARD_SQ = DialogueSettings.enemy_proximity_distance_heard^2
local HEAR_ENEMY_CHECK_INTERVAL = DialogueSettings.hear_enemy_check_interval
local HEARD_SPEAK_DISTANCE = DialogueSettings.heard_speak_distance
local MINION_BREED_TYPE = breed_types.minion
local PLAYER_BREED_TYPE = breed_types.player
local CHARACTER_BREED_TYPES = {
	MINION_BREED_TYPE,
	PLAYER_BREED_TYPE,
}
local PROXIMITY_FX_DISTANCE = 40
local PROXIMITY_FX_DISTANCE_SQ = PROXIMITY_FX_DISTANCE^2
local RAYCAST_ENEMY_CHECK_INTERVAL = DialogueSettings.raycast_enemy_check_interval
local SEEN_RAYCAST_TARGET_NODE_NAME = "enemy_aim_target_02"
local SEEN_ENEMY_PRECISION = DialogueSettings.seen_enemy_precision
local LegacyV2ProximitySystem = class("LegacyV2ProximitySystem", "ExtensionSystemBase")
local BEHIND_MULTIPLIER, CAMERA_FOLLOW_TARGET_MULTIPLIER, HAS_TARGET_MULTIPLIER = 2, 3, 2

LegacyV2ProximitySystem.init = function (self, extension_system_creation_context, ...)
	LegacyV2ProximitySystem.super.init(self, extension_system_creation_context, ...)

	if not DEDICATED_SERVER then
		local game_session, target_unit_id_field_name = extension_system_creation_context.game_session, "target_unit_id"

		FxProximityCulling.init(game_session, NetworkConstants.invalid_game_object_id, BEHIND_MULTIPLIER, CAMERA_FOLLOW_TARGET_MULTIPLIER, HAS_TARGET_MULTIPLIER, target_unit_id_field_name)
	end

	self._player_unit_extensions_map = {}
	self._player_unit_component_map = {}
	self._enemy_check_raycasts = {}
	self._raycast_read_index = 1
	self._raycast_write_index = 1
	self._raycast_max_index = 16
	self._num_units_that_support_proximity_driven_vo = 0
	self._minion_units_proximity_last = Script.new_map(32)
	self._minion_units_proximity_new = Script.new_map(32)
	self._cache_delayed_vo = nil
	self._broadphase_result = Script.new_array(128)
	self._broadphase_system = self._extension_manager:system("broadphase_system")
	self._distance_based_vo_queries = {}

	local cb = callback(self, "_async_raycast_result_cb")

	self._raycast_object = PhysicsWorld.make_raycast(self._physics_world, cb, "all", "collision_filter", "filter_see_enemies")
	self._raycast_data = Script.new_map(3)
end

LegacyV2ProximitySystem.destroy = function (self)
	self._raycast_object = nil

	if not DEDICATED_SERVER then
		FxProximityCulling.destroy()
	end

	LegacyV2ProximitySystem.super.destroy(self)
end

local function _can_trigger_vo(breed_configuration)
	return breed_configuration.trigger_heard_vo, breed_configuration.trigger_seen_vo
end

local function _camera_position_forward_direction_and_follow_go_id()
	local local_player = Managers.player:local_player(1)

	if not local_player then
		return nil, nil, nil
	end

	local pose = Managers.state.camera:camera_pose(local_player.viewport_name)
	local position, forward = Matrix4x4.translation(pose), Matrix4x4.forward(pose)
	local camera_handler = local_player.camera_handler
	local camera_follow_unit = camera_handler:camera_follow_unit()
	local camera_follow_go_id = Managers.state.unit_spawner:game_object_id(camera_follow_unit) or NetworkConstants.invalid_game_object_id

	return position, forward, camera_follow_go_id
end

LegacyV2ProximitySystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local extension = LegacyV2ProximitySystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)
	local breed = extension.breed

	if extension_name == "PlayerProximityExtension" then
		extension.current_ptype = 0
		extension.proximity_array = {
			{
				count_start = -1,
				id = "friends_close",
				num = 0,
				side_relation = "allied",
				breed_types = PLAYER_BREED_TYPE,
				distance = DialogueSettings.friends_close_distance,
			},
			{
				count_start = -1,
				id = "friends_distant",
				num = 0,
				side_relation = "allied",
				breed_types = PLAYER_BREED_TYPE,
				distance = DialogueSettings.friends_distant_distance,
			},
			{
				count_start = 0,
				id = "enemies_close",
				num = 0,
				side_relation = "enemy",
				breed_types = CHARACTER_BREED_TYPES,
				distance = DialogueSettings.enemies_close_distance,
			},
			{
				count_start = 0,
				id = "enemies_distant",
				num = 0,
				side_relation = "enemy",
				breed_types = CHARACTER_BREED_TYPES,
				distance = DialogueSettings.enemies_distant_distance,
			},
		}
		self._player_unit_extensions_map[unit] = extension
		extension.raycast_timer = 0
		extension.hear_timer = 0

		local trigger_heard_vo, trigger_seen_vo = _can_trigger_vo(DialogueBreedSettings[breed.name])

		if trigger_heard_vo or trigger_seen_vo then
			extension.bot_reaction_times = {}
			extension.has_been_seen = false
			extension.trigger_heard_vo = trigger_heard_vo
			extension.trigger_seen_vo = trigger_seen_vo
			self._num_units_that_support_proximity_driven_vo = self._num_units_that_support_proximity_driven_vo + 1
		end

		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local first_person_component = unit_data_extension:read_component("first_person")

		self._player_unit_component_map[unit] = first_person_component
	elseif extension_name == "MinionProximityExtension" then
		local trigger_heard_vo, trigger_seen_vo = _can_trigger_vo(DialogueBreedSettings[breed.name])

		if trigger_heard_vo or trigger_seen_vo then
			extension.bot_reaction_times = {}
			extension.has_been_seen = false
			extension.trigger_heard_vo = trigger_heard_vo
			extension.trigger_seen_vo = trigger_seen_vo
			self._num_units_that_support_proximity_driven_vo = self._num_units_that_support_proximity_driven_vo + 1
		end

		if DEDICATED_SERVER then
			extension.is_proximity_fx_enabled = false
		else
			local camera_position, _, _ = _camera_position_forward_direction_and_follow_go_id()
			local position = POSITION_LOOKUP[unit]
			local distance_sq = camera_position and Vector3.distance_squared(position, camera_position)

			if distance_sq and distance_sq <= PROXIMITY_FX_DISTANCE_SQ then
				extension.is_proximity_fx_enabled = true
				self._minion_units_proximity_last[unit] = true
			else
				extension.is_proximity_fx_enabled = false
			end
		end
	end

	return extension
end

LegacyV2ProximitySystem.on_remove_extension = function (self, unit, extension_name)
	local extension = self._unit_to_extension_map[unit]

	self._player_unit_component_map[unit] = nil
	self._player_unit_extensions_map[unit] = nil

	if extension.trigger_heard_vo or extension.trigger_seen_vo then
		self._num_units_that_support_proximity_driven_vo = self._num_units_that_support_proximity_driven_vo - 1
	end

	LegacyV2ProximitySystem.super.on_remove_extension(self, unit, extension_name)
end

LegacyV2ProximitySystem.add_distance_based_vo_query = function (self, source_unit, concept_name, query_data)
	if not self._unit_to_extension_map[source_unit] then
		Log.warning("LegacyV2ProximitySystem", "Unit %s is not registered in the proximity system.", source_unit)

		return
	end

	local next_element = #self._distance_based_vo_queries + 1

	self._distance_based_vo_queries[next_element] = {
		source = source_unit,
		concept_name = concept_name,
		query_data = query_data,
	}
end

LegacyV2ProximitySystem.update = function (self, ...)
	return
end

LegacyV2ProximitySystem.physics_async_update = function (self, context, dt, t)
	local broadphase, broadphase_result = self._broadphase_system.broadphase, self._broadphase_result

	if not DEDICATED_SERVER then
		self:_update_nearby_minions(broadphase, broadphase_result)
	end

	if not self._is_server then
		return
	end

	local vo = self._cache_delayed_vo

	if vo then
		self._cache_delayed_vo.timer = vo.timer - dt

		if vo.timer < 0 then
			Vo.distance_based_event(vo.unit, vo.proximity_type, vo.event_data)

			self._cache_delayed_vo = nil
		end
	end

	local player_unit_extensions_map = self._player_unit_extensions_map

	if not player_unit_extensions_map[self._next_unit] then
		self._next_unit = nil
	end

	local unit, extension = next(player_unit_extensions_map, self._next_unit)

	self._next_unit = unit

	if ALIVE[unit] then
		local POSITION_LOOKUP = POSITION_LOOKUP
		local position, proximity_array = POSITION_LOOKUP[unit], extension.proximity_array
		local num_proximity_types = #proximity_array

		extension.current_ptype = extension.current_ptype % num_proximity_types + 1

		local proximity_data = extension.proximity_array[extension.current_ptype]
		local radius = proximity_data.distance
		local side_relation = proximity_data.side_relation
		local side = extension.side
		local side_names = side:relation_side_names(side_relation)
		local num_nearby_units = Broadphase.query(broadphase, position, radius, broadphase_result, side_names, proximity_data.breed_types)
		local num_matching_units = proximity_data.count_start

		for i = 1, num_nearby_units do
			local nearby_unit = broadphase_result[i]

			if HEALTH_ALIVE[nearby_unit] then
				num_matching_units = num_matching_units + 1
			end
		end

		local last_num_matching_units = proximity_data.num

		if num_matching_units < last_num_matching_units * 0.67 or num_matching_units > last_num_matching_units * 1.49 then
			proximity_data.num = num_matching_units

			local proximity_type = proximity_data.id
			local send_friends_distant = proximity_type == "friends_distant" and num_matching_units == 0

			if proximity_type == "friends_close" or send_friends_distant then
				local dialogue_extension = ScriptUnit.extension(unit, "dialogue_system")
				local event_data = dialogue_extension:get_event_data_payload()

				event_data.num_units = num_matching_units
				self._cache_delayed_vo = {
					timer = 0.5,
					unit = unit,
					proximity_type = proximity_type,
					event_data = event_data,
				}
			end
		end

		if t > extension.raycast_timer then
			if self._num_units_that_support_proximity_driven_vo > 0 then
				local enemy_check_raycasts = self._enemy_check_raycasts
				local ray_read_index, ray_write_index, ray_max = self._raycast_read_index, self._raycast_write_index, self._raycast_max_index
				local first_person_component = self._player_unit_component_map[unit]
				local look_rot, look_position = first_person_component.rotation, first_person_component.position
				local look_direction = Quaternion.forward(look_rot)
				local pos_flat = Vector3.flat(position)
				local unit_to_extension_map = self._unit_to_extension_map
				local enemy_side_names = side:relation_side_names("enemy")
				local num_nearby_enemy_units = Broadphase.query(broadphase, position, ENEMY_PROXIMITY_DISTANCE, broadphase_result, enemy_side_names, CHARACTER_BREED_TYPES)

				for i = 1, num_nearby_enemy_units do
					local nearby_unit = broadphase_result[i]

					broadphase_result[i] = nil

					local nearby_unit_extension = unit_to_extension_map[nearby_unit]
					local trigger_heard_vo, trigger_seen_vo = nearby_unit_extension.trigger_heard_vo, nearby_unit_extension.trigger_seen_vo

					if (trigger_heard_vo or trigger_seen_vo) and HEALTH_ALIVE[nearby_unit] then
						if trigger_heard_vo and t > extension.hear_timer then
							local nearby_unit_pos = POSITION_LOOKUP[nearby_unit]
							local distance_sq = Vector3.distance_squared(nearby_unit_pos, position)

							if distance_sq < ENEMY_PROXIMITY_DISTANCE_HEARD_SQ then
								local nearby_unit_pos_flat = Vector3.flat(nearby_unit_pos)
								local distance = Vector3.distance(nearby_unit_pos_flat, pos_flat)
								local breed_name = nearby_unit_extension.breed.name

								Vo.heard_enemy_event(unit, breed_name, nearby_unit, distance)

								extension.hear_timer = t + HEAR_ENEMY_CHECK_INTERVAL
							else
								extension.hear_timer = t + 1
							end
						end

						if trigger_seen_vo and not nearby_unit_extension.has_been_seen then
							local nearby_unit_node = Unit.node(nearby_unit, SEEN_RAYCAST_TARGET_NODE_NAME)
							local nearby_unit_node_pos = Unit.world_position(nearby_unit, nearby_unit_node)
							local to_nearby_unit_node_normalized = Vector3.normalize(nearby_unit_node_pos - look_position)
							local result = Vector3.dot(to_nearby_unit_node_normalized, look_direction)

							if result > SEEN_ENEMY_PRECISION then
								enemy_check_raycasts[ray_write_index] = unit
								enemy_check_raycasts[ray_write_index + 1] = nearby_unit
								ray_write_index = (ray_write_index + 1) % ray_max + 1

								if ray_read_index == ray_write_index then
									ray_read_index = (ray_read_index + 1) % ray_max + 1
								end
							end
						end
					end
				end

				self._raycast_read_index, self._raycast_write_index = ray_read_index, ray_write_index
			end

			extension.raycast_timer = t + RAYCAST_ENEMY_CHECK_INTERVAL
		end
	end

	self:_process_distance_based_vo_query(broadphase, broadphase_result)
end

local MAX_ALLOWED_FX = 12

LegacyV2ProximitySystem._update_nearby_minions = function (self, broadphase, broadphase_result)
	local camera_position, camera_forward, camera_follow_go_id = _camera_position_forward_direction_and_follow_go_id()

	if not camera_position then
		return
	end

	local max_allowed = MAX_ALLOWED_FX
	local num_units_in_broadphase = Broadphase.query(broadphase, camera_position, PROXIMITY_FX_DISTANCE, broadphase_result, MINION_BREED_TYPE)
	local minion_units_near_sorted_by_score = FxProximityCulling.sort_by_score(camera_position, camera_forward, camera_follow_go_id, PROXIMITY_FX_DISTANCE, broadphase_result, num_units_in_broadphase)
	local unit_to_extension_map = self._unit_to_extension_map
	local minion_units_proximity_new, minion_units_proximity_last = self._minion_units_proximity_new, self._minion_units_proximity_last
	local num_units = math.min(max_allowed, num_units_in_broadphase)

	for i = 1, num_units do
		local unit = minion_units_near_sorted_by_score[i]

		if not minion_units_proximity_last[unit] then
			unit_to_extension_map[unit].is_proximity_fx_enabled = true
		end

		minion_units_proximity_new[unit] = true
	end

	for unit, _ in pairs(minion_units_proximity_last) do
		if not minion_units_proximity_new[unit] and HEALTH_ALIVE[unit] then
			unit_to_extension_map[unit].is_proximity_fx_enabled = false
		end

		minion_units_proximity_last[unit] = nil
	end

	self._minion_units_proximity_last = minion_units_proximity_new
	self._minion_units_proximity_new = minion_units_proximity_last
end

local MAX_ANSWERING_MINIONS = 5

LegacyV2ProximitySystem._process_distance_based_vo_query = function (self, broadphase, broadphase_result)
	local distance_based_vo_queries = self._distance_based_vo_queries

	if #distance_based_vo_queries <= 0 then
		return
	end

	local to_query = table.remove(distance_based_vo_queries, 1)
	local source_unit = to_query.source

	if not HEALTH_ALIVE[source_unit] then
		return
	end

	local concept_name, query_data = to_query.concept_name, to_query.query_data
	local position = POSITION_LOOKUP[source_unit]
	local num_nearby_minions = Broadphase.query(broadphase, position, HEARD_SPEAK_DISTANCE, broadphase_result, MINION_BREED_TYPE)
	local num_answering_minions = math.min(num_nearby_minions, MAX_ANSWERING_MINIONS)
	local step = math.floor(num_nearby_minions / num_answering_minions)

	for i = 1, num_answering_minions do
		local j = math.floor((i - 1) * step) + 1
		local minion_unit = broadphase_result[j]
		local dialogue_extension = ScriptUnit.has_extension(minion_unit, "dialogue_system")

		if minion_unit ~= source_unit and dialogue_extension then
			dialogue_extension:trigger_dialogue_event(concept_name, query_data, nil)
		end
	end

	local num_nearby_player_units = Broadphase.query(broadphase, position, HEARD_SPEAK_DISTANCE, broadphase_result, PLAYER_BREED_TYPE)

	for i = 1, num_nearby_player_units do
		local player_unit = broadphase_result[i]

		if player_unit ~= source_unit then
			local dialogue_input = ScriptUnit.extension_input(player_unit, "dialogue_system")

			dialogue_input:trigger_dialogue_event(concept_name, query_data, nil)
		end
	end
end

LegacyV2ProximitySystem._make_async_raycast_to_center = function (self, raycast_object, unit, unit_position, nearby_unit)
	local raycast_data = self._raycast_data
	local nearby_unit_node = Unit.node(nearby_unit, SEEN_RAYCAST_TARGET_NODE_NAME)
	local nearby_unit_node_pos = Unit.world_position(nearby_unit, nearby_unit_node)
	local ray_direction, ray_length = Vector3.direction_length(nearby_unit_node_pos - unit_position)
	local id = raycast_object:cast(unit_position, ray_direction, ray_length)

	raycast_data.id, raycast_data.unit, raycast_data.nearby_unit = id, unit, nearby_unit
end

local INDEX_POSITION = 1
local INDEX_ACTOR = 4

LegacyV2ProximitySystem._async_raycast_result_cb = function (self, id, hits, num_hits)
	local raycast_data = self._raycast_data

	if num_hits <= 0 then
		table.clear(raycast_data)

		return
	end

	local unit = raycast_data.unit

	if not HEALTH_ALIVE[unit] then
		table.clear(raycast_data)

		return
	end

	local nearby_unit = raycast_data.nearby_unit

	if not HEALTH_ALIVE[nearby_unit] then
		table.clear(raycast_data)

		return
	end

	local nearby_unit_extension = self._unit_to_extension_map[nearby_unit]

	if nearby_unit_extension.has_been_seen then
		table.clear(raycast_data)

		return
	end

	local hit_target

	for i = 1, num_hits do
		local hit_data = hits[i]
		local hit_unit = Actor.unit(hit_data[INDEX_ACTOR])

		if hit_unit ~= unit then
			if hit_unit == nearby_unit then
				hit_target = true

				break
			else
				local unit_data_extension = ScriptUnit.has_extension(hit_unit, "unit_data_system")
				local breed_or_nil = unit_data_extension and unit_data_extension:breed()

				if not Breed.is_character(breed_or_nil) then
					break
				end
			end
		end
	end

	if hit_target then
		local breed_name = nearby_unit_extension.breed.name
		local position = Unit.local_position(unit, 1)
		local position_flat = Vector3.flat(position)
		local nearby_unit_pos = Unit.local_position(nearby_unit, 1)
		local nearby_unit_pos_flat = Vector3.flat(nearby_unit_pos)
		local distance = Vector3.distance(nearby_unit_pos_flat, position_flat)

		Vo.seen_enemy_event(unit, breed_name, nearby_unit, distance)

		nearby_unit_extension.has_been_seen = true
	end

	table.clear(raycast_data)
end

LegacyV2ProximitySystem.post_update = function (self, ...)
	LegacyV2ProximitySystem.super.post_update(self, ...)

	if not self._is_server then
		return
	end

	local read_index = self._raycast_read_index

	if read_index ~= self._raycast_write_index then
		self._raycast_read_index = (read_index + 1) % self._raycast_max_index + 1

		local enemy_check_raycasts = self._enemy_check_raycasts
		local unit, nearby_unit = enemy_check_raycasts[read_index], enemy_check_raycasts[read_index + 1]
		local ALIVE = ALIVE

		if ALIVE[unit] and ALIVE[nearby_unit] then
			local nearby_unit_extension = self._unit_to_extension_map[nearby_unit]

			if not nearby_unit_extension.has_been_seen then
				local first_person_component = self._player_unit_component_map[unit]
				local camera_position = first_person_component.position

				self:_make_async_raycast_to_center(self._raycast_object, unit, camera_position, nearby_unit)
			end
		end
	end
end

return LegacyV2ProximitySystem
