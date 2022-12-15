local Breed = require("scripts/utilities/breed")
local DialogueBreedSettings = require("scripts/settings/dialogue/dialogue_breed_settings")
local DialogueSettings = require("scripts/settings/dialogue/dialogue_settings")
local Vo = require("scripts/utilities/vo")
local PROXIMITY_DISTANCE_ENEMIES = math.max(DialogueSettings.enemies_close_distance, DialogueSettings.enemies_distant_distance)
local PROXIMITY_DISTANCE_FRIENDS = math.max(DialogueSettings.friends_close_distance, DialogueSettings.friends_distant_distance)
local RAYCAST_ENEMY_CHECK_INTERVAL = DialogueSettings.raycast_enemy_check_interval
local HEAR_ENEMY_CHECK_INTERVAL = DialogueSettings.hear_enemy_check_interval
local SPECIAL_PROXIMITY_DISTANCE = DialogueSettings.special_proximity_distance
local SPECIAL_PROXIMITY_DISTANCE_HEARD = DialogueSettings.special_proximity_distance_heard
local SPECIAL_PROXIMITY_DISTANCE_HEARD_SQ = SPECIAL_PROXIMITY_DISTANCE_HEARD * SPECIAL_PROXIMITY_DISTANCE_HEARD
local HEARD_SPEAK_DEFAULT_DISTANCE = DialogueSettings.heard_speak_default_distance
local LegacyV2ProximitySystem = class("LegacyV2ProximitySystem", "ExtensionSystemBase")
local legacy_extensions = {
	"PlayerProximityExtension",
	"AIProximityExtension"
}
local legacy_extension_lookup = {}

for i = 1, #legacy_extensions do
	legacy_extension_lookup[legacy_extensions[i]] = true
end

LegacyV2ProximitySystem.init = function (self, extension_system_creation_context, system_init_data, system_name, extension_list, ...)
	table.append(extension_list, legacy_extensions)
	LegacyV2ProximitySystem.super.init(self, extension_system_creation_context, system_init_data, system_name, extension_list, ...)

	self._unit_extension_data = {}
	self._player_unit_extensions_map = {}
	self._player_unit_component_map = {}
	self._ai_unit_extensions_map = {}
	self._special_unit_extension_map = {}
	self._is_server = extension_system_creation_context.is_server
	self._enemy_broadphase = Broadphase(PROXIMITY_DISTANCE_ENEMIES, 128)
	self._special_units_broadphase = Broadphase(SPECIAL_PROXIMITY_DISTANCE, 8)
	self._player_units_broadphase = Broadphase(PROXIMITY_DISTANCE_FRIENDS, 4)
	self._enemy_check_raycasts = {}
	self._raycast_read_index = 1
	self._raycast_write_index = 1
	self._raycast_max_index = 16
	self._num_specials = 0
	self._num_players = 0
	self._near_units_last = Script.new_map(32)
	self._near_units_new = Script.new_map(32)
	self._added = Script.new_map(32)
	self._broadphase_result = {}
	self._distance_based_vo_queries = {}
	local side_system = Managers.state.extension:system("side_system")
	self._player_side = side_system:get_side_from_name(side_system:get_default_player_side_name())
	self._safe_raycast_cb = callback(self, "_async_raycast_result_cb")
	self._raycast_object = Managers.state.game_mode:create_safe_raycast_object("all", "collision_filter", "filter_see_enemies")
end

local function _can_trigger_vo(breed_configuration)
	return breed_configuration.can_trigger_vo and (breed_configuration.trigger_heard_vo or breed_configuration.trigger_seen_vo)
end

local EMPTY_TABLE = {}

local function _camera_position()
	local local_player = Managers.player:local_player(1)
	local position = local_player and Managers.state.camera:camera_position(local_player.viewport_name)

	return position
end

LegacyV2ProximitySystem._spread_start_times = function (self)
	local num_players = self._num_players
	local index = 1

	for unit, extension in pairs(self._unit_extension_data) do
		local delta = (index - 1) / num_players
		extension.raycast_timer = RAYCAST_ENEMY_CHECK_INTERVAL * delta
		extension.hear_timer = HEAR_ENEMY_CHECK_INTERVAL * delta
		index = index + 1
	end
end

LegacyV2ProximitySystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data)
	if not legacy_extension_lookup[extension_name] then
		return LegacyV2ProximitySystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data)
	else
		local extension = {
			side_id = extension_init_data.side_id
		}

		ScriptUnit.set_extension(unit, "legacy_v2_proximity_system", extension)

		self._unit_extension_data[unit] = extension

		if extension_name == "PlayerProximityExtension" then
			extension.current_ptype = 0
			local position = POSITION_LOOKUP[unit]
			local proximity_types = {
				friends_close = {
					count_start = -1,
					id = "friends_close",
					num = 0,
					distance = DialogueSettings.friends_close_distance,
					broadphase = self._player_units_broadphase
				},
				friends_distant = {
					count_start = -1,
					id = "friends_distant",
					num = 0,
					distance = DialogueSettings.friends_distant_distance,
					broadphase = self._player_units_broadphase
				},
				enemies_close = {
					count_start = 0,
					id = "enemies_close",
					num = 0,
					distance = DialogueSettings.enemies_close_distance,
					broadphase = self._enemy_broadphase
				},
				enemies_distant = {
					count_start = 0,
					id = "enemies_distant",
					num = 0,
					distance = DialogueSettings.enemies_distant_distance,
					broadphase = self._enemy_broadphase
				}
			}
			extension.proximity_array = {
				proximity_types.friends_close,
				proximity_types.friends_distant,
				proximity_types.enemies_close,
				proximity_types.enemies_distant
			}
			extension.proximity_types = proximity_types

			self:_spread_start_times()

			extension.player_broadphase_id = Broadphase.add(self._player_units_broadphase, unit, position, 0.5)
			self._player_unit_extensions_map[unit] = extension
			self._num_players = self._num_players + 1
			local breed = extension_init_data.breed

			if _can_trigger_vo(DialogueBreedSettings[breed.name]) then
				extension.special_broadphase_id = Broadphase.add(self._special_units_broadphase, unit, position, 0.5)
				extension.bot_reaction_times = {}
				extension.has_been_seen = false
				extension.breed = breed
				self._special_unit_extension_map[unit] = extension
			end

			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local first_person_component = unit_data_extension:read_component("first_person")
			self._player_unit_component_map[unit] = first_person_component
		elseif extension_name == "AIProximityExtension" then
			local position = POSITION_LOOKUP[unit]
			extension.enemy_broadphase_id = Broadphase.add(self._enemy_broadphase, unit, position, 0.5)
			extension.bot_reaction_times = {}
			extension.has_been_seen = false
			self._ai_unit_extensions_map[unit] = extension
			local breed = extension_init_data.breed

			if _can_trigger_vo(DialogueBreedSettings[breed.name]) then
				extension.special_broadphase_id = Broadphase.add(self._special_units_broadphase, unit, position, 0.5)
				extension.breed = breed
				self._special_unit_extension_map[unit] = extension
				self._num_specials = self._num_specials + 1
			end

			if DEDICATED_SERVER then
				extension.is_proximity_fx_enabled = false
			else
				local camera_position = _camera_position()
				local distance_sq = camera_position and Vector3.distance_squared(position, camera_position)

				if distance_sq and distance_sq <= SPECIAL_PROXIMITY_DISTANCE_HEARD_SQ then
					extension.is_proximity_fx_enabled = true
				else
					extension.is_proximity_fx_enabled = false
				end
			end
		end

		return extension
	end
end

LegacyV2ProximitySystem.register_extension_update = function (self, unit, extension_name, extension)
	if not legacy_extension_lookup[extension_name] then
		LegacyV2ProximitySystem.super.register_extension_update(self, unit, extension_name, extension)
	end
end

LegacyV2ProximitySystem.extensions_ready = function (self, world, unit, extension_name)
	if extension_name == "PlayerProximityExtension" then
		local extension = self._player_unit_extensions_map[unit]
		local side_system = Managers.state.extension:system("side_system")
		local side_id = extension.side_id
		local side = side_system:get_side(side_id)
		extension.side = side
	end
end

LegacyV2ProximitySystem.on_remove_extension = function (self, unit, extension_name)
	if not legacy_extension_lookup[extension_name] then
		LegacyV2ProximitySystem.super.on_remove_extension(self, unit, extension_name)
	else
		local extension = self._unit_extension_data[unit]

		if extension.enemy_broadphase_id then
			Broadphase.remove(self._enemy_broadphase, extension.enemy_broadphase_id)
		end

		if extension.player_broadphase_id then
			Broadphase.remove(self._player_units_broadphase, extension.player_broadphase_id)

			self._num_players = self._num_players - 1
		end

		if extension.special_broadphase_id then
			Broadphase.remove(self._special_units_broadphase, extension.special_broadphase_id)

			self._num_specials = self._num_specials - 1
		end

		self._unit_extension_data[unit] = nil
		self._player_unit_extensions_map[unit] = nil
		self._ai_unit_extensions_map[unit] = nil
		self._special_unit_extension_map[unit] = nil

		ScriptUnit.remove_extension(unit, "legacy_v2_proximity_system")
	end
end

LegacyV2ProximitySystem.set_unit_local = function (self, unit)
	if not self._unit_extension_data[unit] then
		LegacyV2ProximitySystem.super.set_unit_local(self, unit)
	end
end

LegacyV2ProximitySystem.add_distance_based_vo_query = function (self, source_unit, concept_name, query_data)
	if not self._unit_extension_data[source_unit] then
		Log.warning("LegacyV2ProximitySystem", "Unit %s is not registered in the proximity system.", source_unit)

		return
	end

	local next_element = #self._distance_based_vo_queries + 1
	self._distance_based_vo_queries[next_element] = {
		source = source_unit,
		concept_name = concept_name,
		query_data = query_data
	}
end

LegacyV2ProximitySystem.update = function (self, ...)
	return
end

LegacyV2ProximitySystem.physics_async_update = function (self, context, dt, t)
	local Broadphase_move = Broadphase.move
	local POSITION_LOOKUP = POSITION_LOOKUP
	local enemy_broadphase = self._enemy_broadphase

	if not self._ai_unit_extensions_map[self._next_ai_unit] then
		self._next_ai_unit = nil
	end

	local counter = 0
	local max_count = 7

	while counter < max_count do
		local unit, extension = next(self._ai_unit_extensions_map, self._next_ai_unit)
		local pos = POSITION_LOOKUP[unit]

		if pos then
			Broadphase_move(enemy_broadphase, extension.enemy_broadphase_id, pos)
		end

		self._next_ai_unit = unit
		counter = counter + 1
	end

	local player_unit_extensions_map = self._player_unit_extensions_map
	local player_units_broadphase = self._player_units_broadphase

	for unit, extension in pairs(player_unit_extensions_map) do
		local position = POSITION_LOOKUP[unit]

		Broadphase_move(player_units_broadphase, extension.player_broadphase_id, position)
	end

	local special_unit_extension_map = self._special_unit_extension_map
	local special_units_broadphase = self._special_units_broadphase

	for unit, extension in pairs(special_unit_extension_map) do
		local position = POSITION_LOOKUP[unit]

		Broadphase_move(special_units_broadphase, extension.special_broadphase_id, position)
	end

	self:_update_nearby_enemies(self._player_side)

	if not self._is_server then
		return
	end

	local enemy_check_raycasts = self._enemy_check_raycasts
	local player_unit_component_map = self._player_unit_component_map
	local ray_read_index = self._raycast_read_index
	local ray_write_index = self._raycast_write_index
	local ray_max = self._raycast_max_index
	local broadphase_result = self._broadphase_result

	if not player_unit_extensions_map[self._next_unit] then
		self._next_unit = nil
	end

	local unit, extension = next(player_unit_extensions_map, self._next_unit)
	self._next_unit = unit

	if ALIVE[unit] then
		local position = POSITION_LOOKUP[unit]
		extension.current_ptype = extension.current_ptype % 4 + 1
		local proximity_data = extension.proximity_array[extension.current_ptype]
		local broadphase = proximity_data.broadphase
		local radius = proximity_data.distance
		local num_nearby_units = Broadphase.query(broadphase, position, radius, broadphase_result)
		local num_matching_units = proximity_data.count_start

		for i = 1, num_nearby_units do
			local nearby_unit = broadphase_result[i]

			if HEALTH_ALIVE[nearby_unit] then
				num_matching_units = num_matching_units + 1
			end
		end

		local last_num_matching_units = proximity_data.num

		if num_matching_units < last_num_matching_units * 0.5 or num_matching_units > last_num_matching_units * 1.5 then
			proximity_data.num = num_matching_units
			local dialogue_extension = ScriptUnit.extension(unit, "dialogue_system")
			local event_data = dialogue_extension:get_event_data_payload()
			event_data.num_units = num_matching_units
			local proximity_type = extension.id

			if proximity_type == "friends_close" or proximity_type == "friends_distant" then
				Vo.distance_based_event(dialogue_extension, proximity_type, event_data)
			end
		end

		if extension.raycast_timer < t then
			if self._num_specials > 0 then
				local first_person_component = player_unit_component_map[unit]
				local look_rot = first_person_component.rotation
				local look_direction = Quaternion.forward(look_rot)
				local pos_flat = Vector3.flat(position)
				look_direction.z = 0
				local num_nearby_units = Broadphase.query(special_units_broadphase, position, SPECIAL_PROXIMITY_DISTANCE, broadphase_result)

				for i = 1, num_nearby_units do
					local nearby_unit = broadphase_result[i]
					broadphase_result[i] = nil

					if nearby_unit ~= unit and HEALTH_ALIVE[nearby_unit] then
						local nearby_unit_pos = POSITION_LOOKUP[nearby_unit]
						local nearby_unit_pos_flat = Vector3.flat(nearby_unit_pos)

						if extension.hear_timer < t then
							local heard = false
							local distance_sq = Vector3.distance_squared(nearby_unit_pos, position)

							if distance_sq < SPECIAL_PROXIMITY_DISTANCE_HEARD_SQ then
								local special_unit_extension = special_unit_extension_map[nearby_unit]
								local breed_name = special_unit_extension.breed.name

								if DialogueBreedSettings[breed_name].trigger_heard_vo then
									local distance = Vector3.distance(nearby_unit_pos_flat, pos_flat)

									Vo.heard_enemy_event(unit, breed_name, nearby_unit, distance)

									heard = true
									extension.hear_timer = t + HEAR_ENEMY_CHECK_INTERVAL
								end
							end

							if not heard then
								extension.hear_timer = t + 1
							end
						end

						local direction_unit_nearby_unit = Vector3.normalize(nearby_unit_pos_flat - pos_flat)
						local result = Vector3.dot(direction_unit_nearby_unit, look_direction)

						if DialogueSettings.seen_enemy_precision < result then
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

			extension.raycast_timer = t + RAYCAST_ENEMY_CHECK_INTERVAL
		end

		self._raycast_read_index = ray_read_index
		self._raycast_write_index = ray_write_index
	end

	self:_process_distance_based_vo_query()
end

local MAX_ALLOWED_FX = 12

LegacyV2ProximitySystem._update_nearby_enemies = function (self, side)
	if DEDICATED_SERVER then
		return
	end

	local camera_position = _camera_position()

	if camera_position then
		local max_allowed = MAX_ALLOWED_FX
		local broadphase_result = self._broadphase_result
		local num_units_in_broadphase = Broadphase.query(self._enemy_broadphase, camera_position, PROXIMITY_DISTANCE_ENEMIES, broadphase_result)
		local num_units = math.min(max_allowed, num_units_in_broadphase)

		for i = 1, num_units do
			local unit = broadphase_result[i]

			if not self._near_units_last[unit] then
				self._unit_extension_data[unit].is_proximity_fx_enabled = true
			end

			self._near_units_new[unit] = true
			self._added[unit] = true
		end

		for unit, v in pairs(self._near_units_last) do
			if not self._added[unit] and ALIVE[unit] then
				self._unit_extension_data[unit].is_proximity_fx_enabled = false
			end

			self._near_units_last[unit] = nil
		end

		local temp = self._near_units_last
		self._near_units_last = self._near_units_new
		self._near_units_new = temp

		table.clear(self._added)
	end
end

LegacyV2ProximitySystem._process_distance_based_vo_query = function (self)
	if #self._distance_based_vo_queries <= 0 then
		return
	end

	local to_query = table.remove(self._distance_based_vo_queries, 1)
	local source_unit = to_query.source

	if not HEALTH_ALIVE[source_unit] then
		return
	end

	local concept = to_query.concept_name
	local query_data = to_query.query_data
	local position = POSITION_LOOKUP[source_unit]
	local broadphase_result = self._broadphase_result
	local num_nearby_enemies = Broadphase.query(self._enemy_broadphase, position, HEARD_SPEAK_DEFAULT_DISTANCE, broadphase_result)
	local num_answering = math.min(num_nearby_enemies, 5)
	local step = math.floor(num_nearby_enemies / num_answering)

	for i = 1, num_answering do
		local j = math.floor((i - 1) * step) + 1
		local enemy_unit = broadphase_result[j]
		local dialogue_extension = ScriptUnit.has_extension(enemy_unit, "dialogue_system")

		if enemy_unit ~= source_unit and dialogue_extension then
			dialogue_extension:trigger_dialogue_event(concept, query_data, nil)
		end
	end

	local num_nearby_players = Broadphase.query(self._player_units_broadphase, position, HEARD_SPEAK_DEFAULT_DISTANCE, broadphase_result)

	for i = 1, num_nearby_players do
		local player_unit = broadphase_result[i]

		if player_unit ~= source_unit then
			local dialogue_input = ScriptUnit.extension_input(player_unit, "dialogue_system")

			dialogue_input:trigger_dialogue_event(concept, query_data, nil)
		end
	end
end

local INDEX_POSITION = 1
local INDEX_ACTOR = 4

LegacyV2ProximitySystem._make_async_raycast_to_center = function (self, raycast_object, unit, unit_position, nearby_unit)
	local unit_center_matrix, _ = Unit.box(nearby_unit)
	local ray_target = Matrix4x4.translation(unit_center_matrix)
	ray_target = ray_target + Vector3(0, 0, 1)
	local to_target = ray_target - unit_position
	local ray_direction = Vector3.normalize(to_target)
	local ray_length = Vector3.length(to_target)

	Managers.state.game_mode:add_safe_raycast(self._raycast_object, unit_position, ray_direction, ray_length, self._safe_raycast_cb, unit, nearby_unit)
end

LegacyV2ProximitySystem._async_raycast_result_cb = function (self, id, hits, num_hits, data)
	if num_hits <= 0 then
		return
	end

	local unit = data[1]

	if not HEALTH_ALIVE[unit] then
		return
	end

	local nearby_unit = data[2]

	if not HEALTH_ALIVE[nearby_unit] then
		return
	end

	local hit_target = nil

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
		local special_unit_extension = self._special_unit_extension_map[nearby_unit]

		if not special_unit_extension.has_been_seen then
			local breed_name = special_unit_extension.breed.name

			if DialogueBreedSettings[breed_name].trigger_seen_vo then
				local position = Unit.local_position(unit, 1)
				local position_flat = Vector3.flat(position)
				local nearby_unit_pos = Unit.local_position(nearby_unit, 1)
				local nearby_unit_pos_flat = Vector3.flat(nearby_unit_pos)
				local distance = Vector3.distance(nearby_unit_pos_flat, position_flat)

				Vo.seen_enemy_event(unit, breed_name, nearby_unit, distance)
			end

			special_unit_extension.has_been_seen = true
		end
	end
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
		local unit = enemy_check_raycasts[read_index]
		local nearby_unit = enemy_check_raycasts[read_index + 1]
		local ALIVE = ALIVE

		if ALIVE[unit] and ALIVE[nearby_unit] then
			local special_unit_extension = self._special_unit_extension_map[nearby_unit]

			if not special_unit_extension.has_been_seen then
				local breed_name = special_unit_extension.breed.name

				if DialogueBreedSettings[breed_name].trigger_seen_vo then
					local first_person_component = self._player_unit_component_map[unit]
					local camera_position = first_person_component.position

					self:_make_async_raycast_to_center(self._raycast_object, unit, camera_position, nearby_unit)
				end
			end
		end
	end
end

return LegacyV2ProximitySystem
