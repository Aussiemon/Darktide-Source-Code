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
	self._old_nearby = {}
	self._new_nearby = {}
	self._broadphase_result = {}
	self._pseudo_sorted_list = {}
	self._old_enabled_fx = {}
	self._new_enabled_fx = {}
	self._distance_based_vo_queries = {}
	self._safe_raycast_cb = callback(self, "_async_raycast_result_cb")
	self._raycast_object = Managers.state.game_mode:create_safe_raycast_object("all", "collision_filter", "filter_see_enemies")
end

local function _can_trigger_vo(breed_configuration)
	fassert(breed_configuration, "[LegacyV2ProximitySystem] Breed configuration can't be nil. Please add it to DialogueBreedSettings and contact the Audio team.")

	return breed_configuration.can_trigger_vo and (breed_configuration.trigger_heard_vo or breed_configuration.trigger_seen_vo)
end

local function _average_local_human_player_position(local_players)
	local human_player_position_sum = Vector3(0, 0, 0)
	local num_human_players = 0
	local camera_manager = Managers.state.camera

	for _, player in pairs(local_players) do
		if player:is_human_controlled() then
			local camera_position = camera_manager:camera_position(player.viewport_name)
			human_player_position_sum = human_player_position_sum + camera_position
			num_human_players = num_human_players + 1
		end
	end

	if num_human_players > 0 then
		local average_human_player_position = human_player_position_sum / num_human_players

		return average_human_player_position
	else
		return nil
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
			local position = POSITION_LOOKUP[unit]
			extension.proximity_types = {
				friends_close = {
					num = 0,
					distance = DialogueSettings.friends_close_distance,
					check = self._player_unit_extensions_map,
					broadphase = self._player_units_broadphase
				},
				friends_distant = {
					num = 0,
					distance = DialogueSettings.friends_distant_distance,
					check = self._player_unit_extensions_map,
					broadphase = self._player_units_broadphase
				},
				enemies_close = {
					num = 0,
					distance = DialogueSettings.enemies_close_distance,
					check = self._ai_unit_extensions_map,
					broadphase = self._enemy_broadphase
				},
				enemies_distant = {
					num = 0,
					distance = DialogueSettings.enemies_distant_distance,
					check = self._ai_unit_extensions_map,
					broadphase = self._enemy_broadphase
				}
			}
			extension.raycast_timer = 0
			extension.hear_timer = 0
			extension.player_broadphase_id = Broadphase.add(self._player_units_broadphase, unit, position, 0.5)
			self._player_unit_extensions_map[unit] = extension
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
			end

			if DEDICATED_SERVER then
				extension.is_proximity_fx_enabled = false
			else
				local local_players = Managers.player:players_at_peer(Network.peer_id())
				local average_local_human_player_position = local_players and _average_local_human_player_position(local_players)
				local distance_sq = average_local_human_player_position and Vector3.distance_squared(position, average_local_human_player_position)

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
		end

		if extension.special_broadphase_id then
			Broadphase.remove(self._special_units_broadphase, extension.special_broadphase_id)
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

	fassert(concept_name, "distance based VO concept can't be nil")

	local next_element = #self._distance_based_vo_queries + 1
	self._distance_based_vo_queries[next_element] = {
		source = source_unit,
		concept_name = concept_name,
		query_data = query_data
	}
end

LegacyV2ProximitySystem.update = function (self, ...)
	LegacyV2ProximitySystem.super.update(self, ...)

	if not self._is_server then
		return
	end
end

local near_lookup = {
	human = "human_test",
	ogryn = "ogryn_test"
}

LegacyV2ProximitySystem.physics_async_update = function (self, context, dt, t)
	Profiler.start("Moving units")

	local Broadphase_move = Broadphase.move
	local POSITION_LOOKUP = POSITION_LOOKUP
	local enemy_broadphase = self._enemy_broadphase

	for unit, extension in pairs(self._ai_unit_extensions_map) do
		local position = POSITION_LOOKUP[unit]

		Broadphase_move(enemy_broadphase, extension.enemy_broadphase_id, position)
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

	Profiler.stop("Moving units")
	self:_update_nearby_enemies()

	if not self._is_server then
		return
	end

	local enemy_check_raycasts = self._enemy_check_raycasts
	local player_unit_component_map = self._player_unit_component_map
	local ray_read_index = self._raycast_read_index
	local ray_write_index = self._raycast_write_index
	local ray_max = self._raycast_max_index
	local broadphase_result = self._broadphase_result

	for unit, extension in pairs(player_unit_extensions_map) do
		local position = POSITION_LOOKUP[unit]

		Profiler.start("Update Proximity Type Data")

		for proximity_type, proximity_data in pairs(extension.proximity_types) do
			local broadphase = proximity_data.broadphase
			local radius = proximity_data.distance
			local num_nearby_units = Broadphase.query(broadphase, position, radius, broadphase_result)
			local check = proximity_data.check
			local num_matching_units = 0

			for i = 1, num_nearby_units do
				local nearby_unit = broadphase_result[i]

				if nearby_unit ~= unit and check[nearby_unit] and HEALTH_ALIVE[nearby_unit] then
					num_matching_units = num_matching_units + 1
				end
			end

			local last_num_matching_units = proximity_data.num

			if num_matching_units < last_num_matching_units * 0.5 or num_matching_units > last_num_matching_units * 1.5 then
				proximity_data.num = num_matching_units
				local dialogue_extension = ScriptUnit.extension(unit, "dialogue_system")
				local event_data = dialogue_extension:get_event_data_payload()
				event_data.num_units = num_matching_units

				if proximity_type == "friends_close" then
					for i = 1, num_nearby_units do
						local nearby_unit = broadphase_result[i]

						if nearby_unit ~= unit and check[nearby_unit] and HEALTH_ALIVE[nearby_unit] then
							local profile_name = ScriptUnit.extension(nearby_unit, "dialogue_system"):get_context().player_profile
							local near_title = near_lookup[profile_name]

							if near_title then
								event_data[near_title] = true
							end
						end
					end
				end

				dialogue_extension:trigger_dialogue_event(proximity_type, event_data)
			end

			table.clear_array(broadphase_result, num_nearby_units)
		end

		Profiler.stop("Update Proximity Type Data")
		Profiler.start("See and hear enemies")

		local raycast_timer = extension.raycast_timer + dt
		local hear_timer = extension.hear_timer + dt
		local heard, cast_ray = nil

		if RAYCAST_ENEMY_CHECK_INTERVAL < raycast_timer then
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

					if HEAR_ENEMY_CHECK_INTERVAL < hear_timer then
						local distance_sq = Vector3.distance_squared(nearby_unit_pos, position)

						if distance_sq < SPECIAL_PROXIMITY_DISTANCE_HEARD_SQ then
							local special_unit_extension = special_unit_extension_map[nearby_unit]
							local breed_name = special_unit_extension.breed.name

							if DialogueBreedSettings[breed_name].trigger_heard_vo then
								local distance = Vector3.distance(nearby_unit_pos_flat, pos_flat)

								Vo.heard_enemy_event(unit, breed_name, nearby_unit, distance)

								heard = true
							end
						end
					end

					local direction_unit_nearby_unit = Vector3.normalize(nearby_unit_pos_flat - pos_flat)
					local result = Vector3.dot(direction_unit_nearby_unit, look_direction)

					if result > 0.7 then
						cast_ray = true
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

		if cast_ray then
			raycast_timer = 0
		end

		if heard then
			hear_timer = 0
		end

		self._raycast_read_index = ray_read_index
		self._raycast_write_index = ray_write_index
		extension.hear_timer = hear_timer
		extension.raycast_timer = raycast_timer

		Profiler.stop("See and hear enemies")
	end

	self:_process_distance_based_vo_query()
end

local function _swap_erase(l, i, j)
	local v = l[j]
	l[i] = v
	l[j] = nil

	return v
end

local function _swap(l, i, j)
	local v = l[j]
	l[j] = l[i]
	l[i] = v

	return v
end

local function _remove_element(list, index, list_len)
	local next_unit = _swap_erase(list, index, list_len)

	return next_unit, list_len - 1
end

local MAX_ALLOWED_FX = 12

LegacyV2ProximitySystem._update_nearby_enemies = function (self)
	if DEDICATED_SERVER then
		return
	end

	Profiler.start("update nearby enemies")

	local old_nearby = self._old_nearby
	local new_nearby = self._new_nearby

	table.clear(new_nearby)

	local local_players = Managers.player:players_at_peer(Network.peer_id())
	local average_local_human_player_position = local_players and _average_local_human_player_position(local_players)

	if average_local_human_player_position then
		local broadphase_result = self._broadphase_result

		Profiler.start("broadphase query")

		local num_units = Broadphase.query(self._enemy_broadphase, average_local_human_player_position, 40, broadphase_result)

		Profiler.stop("broadphase query")

		local list = self._pseudo_sorted_list
		local list_len = #list

		for i = 1, num_units do
			local unit = broadphase_result[i]
			broadphase_result[i] = nil
			new_nearby[unit] = Vector3.distance_squared(POSITION_LOOKUP[unit], average_local_human_player_position)

			if not old_nearby[unit] then
				list_len = list_len + 1
				list[list_len] = unit
			end
		end

		local higher_unit = list[1]

		if higher_unit then
			Profiler.start("sort")

			local higher_unit_dist = new_nearby[higher_unit]

			while not higher_unit_dist and list_len > 0 do
				higher_unit, list_len = _remove_element(list, 1, list_len)
				higher_unit_dist = new_nearby[higher_unit]
			end

			local lower_index = nil
			local higher_index = 1
			local max_allowed = MAX_ALLOWED_FX
			local old_enabled_fx = self._old_enabled_fx
			local new_enabled_fx = self._new_enabled_fx
			local ALIVE = ALIVE

			while higher_index <= list_len do
				lower_index = higher_index
				higher_index = higher_index + 1
				local lower_unit = higher_unit
				local lower_unit_dist = higher_unit_dist
				higher_unit = list[higher_index]
				higher_unit_dist = new_nearby[higher_unit]

				while not higher_unit_dist and higher_index <= list_len do
					higher_unit, list_len = _remove_element(list, higher_index, list_len)
					higher_unit_dist = new_nearby[higher_unit]
				end

				if higher_unit_dist and higher_unit_dist < lower_unit_dist then
					_swap(list, lower_index, higher_index)

					higher_unit = lower_unit
					higher_unit_dist = lower_unit_dist
				end

				if not ALIVE[list[lower_index]] then
					table.dump(old_enabled_fx, "old_enabled_fx", 2)
					table.dump(new_enabled_fx, "new_enabled_fx", 2)
					table.dump(old_nearby, "old_nearby", 2)
					table.dump(new_nearby, "new_nearby", 2)
					table.dump(list, "list", 2)
					error("Detected deleted unit in proximity fx list.")
				end

				local unit = list[lower_index]

				if lower_index <= max_allowed then
					self:_fx_list_add(old_enabled_fx, new_enabled_fx, unit)
				else
					self:_fx_list_remove(old_enabled_fx, new_enabled_fx, unit)
				end
			end

			if higher_unit_dist then
				if higher_index <= max_allowed then
					self:_fx_list_add(old_enabled_fx, new_enabled_fx, higher_unit)
				else
					self:_fx_list_remove(old_enabled_fx, new_enabled_fx, higher_unit)
				end
			end

			self:_clear_old_enabled_fx(old_enabled_fx)

			self._old_enabled_fx = new_enabled_fx
			self._new_enabled_fx = old_enabled_fx

			Profiler.stop("sort")
		end
	end

	self._old_nearby = new_nearby
	self._new_nearby = old_nearby

	Profiler.stop("update nearby enemies")
end

local Unit_flow_event = Unit.flow_event

LegacyV2ProximitySystem._fx_list_add = function (self, old_list, new_list, unit)
	if old_list[unit] then
		old_list[unit] = nil
	else
		Unit_flow_event(unit, "enable_proximity_fx")

		self._unit_extension_data[unit].is_proximity_fx_enabled = true
	end

	new_list[unit] = true
end

LegacyV2ProximitySystem._fx_list_remove = function (self, old_list, new_list, unit)
	if old_list[unit] then
		Unit_flow_event(unit, "disable_proximity_fx")

		self._unit_extension_data[unit].is_proximity_fx_enabled = false
		old_list[unit] = nil
	end
end

LegacyV2ProximitySystem._clear_old_enabled_fx = function (self, old_enabled_fx)
	local ALIVE = ALIVE

	for unit, _ in pairs(old_enabled_fx) do
		if ALIVE[unit] then
			Unit_flow_event(unit, "disable_proximity_fx")
		end
	end

	table.clear(old_enabled_fx)
end

LegacyV2ProximitySystem._process_distance_based_vo_query = function (self)
	if #self._distance_based_vo_queries == 0 then
		return
	end

	local to_query = table.remove(self._distance_based_vo_queries, 1)
	local source_unit = to_query.source
	local concept = to_query.concept_name
	local query_data = to_query.query_data

	fassert(concept, "process distance based VO concept can't be nil")

	if not ALIVE[source_unit] then
		return
	end

	local position = POSITION_LOOKUP[source_unit]
	local broadphase_result = self._broadphase_result
	local num_nearby_enemies = Broadphase.query(self._enemy_broadphase, position, HEARD_SPEAK_DEFAULT_DISTANCE, broadphase_result)

	for i = 1, num_nearby_enemies do
		local enemy_unit = broadphase_result[i]
		broadphase_result[i] = nil
		local dialogue_extension = ScriptUnit.has_extension(enemy_unit, "dialogue_system")

		if enemy_unit ~= source_unit and dialogue_extension then
			dialogue_extension:trigger_dialogue_event(concept, query_data, nil)
		end
	end

	local num_nearby_players = Broadphase.query(self._player_units_broadphase, position, HEARD_SPEAK_DEFAULT_DISTANCE, broadphase_result)

	for i = 1, num_nearby_players do
		local player_unit = broadphase_result[i]
		broadphase_result[i] = nil

		if player_unit ~= source_unit then
			local dialogue_input = ScriptUnit.extension_input(player_unit, "dialogue_system")

			dialogue_input:trigger_dialogue_event(concept, query_data, nil)
		end
	end
end

local INDEX_POSITION = 1
local INDEX_ACTOR = 4

LegacyV2ProximitySystem._make_async_raycast_to_center = function (self, raycast_object, physics_world, unit, unit_position, nearby_unit)
	local unit_center_matrix, _ = Unit.box(nearby_unit)
	local ray_target = Matrix4x4.translation(unit_center_matrix)
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

					self:_make_async_raycast_to_center(self._raycast_object, self._physics_world, unit, camera_position, nearby_unit)
				end
			end
		end
	end
end

return LegacyV2ProximitySystem
