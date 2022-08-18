local CinematicLevelLoader = require("scripts/extension_systems/cinematic_scene/utilities/cinematic_level_loader")
local CinematicManagerTestify = GameParameters.testify and require("scripts/managers/cinematic/cinematic_manager_testify")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local CinematicManager = class("CinematicManager")
local CLIENT_RPCS = {
	"rpc_cinematic_story_sync",
	"rpc_cinematic_load_levels"
}

CinematicManager.init = function (self, world, is_server, network_event_delegate)
	self._stories = {}
	self._stories_onhold = {}
	self._active_story = nil
	self._queued_stories = {}
	self._is_server = is_server
	self._world = world
	self._storyteller = World.storyteller(world)
	self._network_event_delegate = network_event_delegate
	self._level_loader = CinematicLevelLoader:new()
	self._cinematic_levels = {}
	self._on_levels_spawned_callback = {}
	self._aligned_levels = {}

	if not is_server then
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))

		self._network_event_delegate = network_event_delegate
	end
end

CinematicManager.destroy = function (self)
	self:_unload_all_levels()

	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end
end

CinematicManager._is_valid_origin_level = function (self, origin_level, destination_level)
	local has_origin_level = origin_level ~= destination_level
	local origin_level_name = ""

	if has_origin_level then
		origin_level_name = Level.name(origin_level)
		origin_level_name = origin_level_name:match("(.+)%..+$")
		local is_external_level = self._level_loader:has_level(origin_level_name)

		if not is_external_level then
			has_origin_level = false
			origin_level_name = ""
		end
	end

	return has_origin_level, origin_level_name
end

CinematicManager._fetch_origin_level = function (self, story_definition, origin_level_names)
	local level_cinematic_scene_name = nil

	if story_definition.use_alignment_units then
		local origin_level = story_definition.origin_level
		local destination_level = story_definition.destination_level
		local has_origin_level, origin_level_name = self:_is_valid_origin_level(origin_level, destination_level)

		if has_origin_level then
			origin_level_names[#origin_level_names + 1] = origin_level_name
			level_cinematic_scene_name = story_definition.cinematic_scene_name
		end
	end

	return level_cinematic_scene_name
end

CinematicManager._send_hot_join_story = function (self, sender, channel, story_definition)
	local category = story_definition.category
	local story_name = story_definition.name
	local scene_unit_origin_level_id = NetworkConstants.invalid_level_unit_id
	local scene_unit_destination_level_id = NetworkConstants.invalid_level_unit_id
	local has_origin_level = false
	local origin_level_name = ""
	local cinematic_scene_name = story_definition.cinematic_scene_name
	local cinematic_scene_name_id = NetworkLookup.cinematic_scene_names[cinematic_scene_name]

	if story_definition.use_alignment_units then
		local origin_level = story_definition.origin_level
		local scene_unit_origin = story_definition.scene_unit_origin
		scene_unit_origin_level_id = Level._unit_index(origin_level, scene_unit_origin)
		local destination_level = story_definition.destination_level
		local scene_unit_destination = story_definition.scene_unit_destination
		scene_unit_destination_level_id = Level._unit_index(destination_level, scene_unit_destination)
		has_origin_level, origin_level_name = self:_is_valid_origin_level(origin_level, destination_level)
	end

	RPC.rpc_cinematic_story_sync(channel, cinematic_scene_name_id, category, story_name, scene_unit_origin_level_id, scene_unit_destination_level_id, has_origin_level, origin_level_name)
end

CinematicManager.hot_join_sync = function (self, sender, channel)
	local origin_level_names = {}
	local level_cinematic_scene_name = nil

	if self._active_story then
		local story_definition = self._active_story
		level_cinematic_scene_name = self:_fetch_origin_level(story_definition, origin_level_names)
	end

	for _, story_definition in ipairs(self._queued_stories) do
		level_cinematic_scene_name = self:_fetch_origin_level(story_definition, origin_level_names)
	end

	if #origin_level_names > 0 then
		fassert(level_cinematic_scene_name, "[hot_join_sync] Missing Cinematic Scene Name.")

		local cinematic_name_id = NetworkLookup.cinematic_scene_names[level_cinematic_scene_name]

		RPC.rpc_cinematic_load_levels(channel, cinematic_name_id, origin_level_names)
	end

	if self._active_story then
		local story_definition = self._active_story

		self:_send_hot_join_story(sender, channel, story_definition)
	end

	for _, story_definition in ipairs(self._queued_stories) do
		self:_send_hot_join_story(sender, channel, story_definition)
	end
end

CinematicManager.update = function (self, dt, t)
	local story = self._active_story

	if story then
		local story_id = story.story_id
		local story_time = self._storyteller:time(story_id)
		local length = self._storyteller:length(story_id)
		local story_done = length < story_time

		if story_done then
			self._storyteller:stop(story_id)

			if story.played_callback then
				story.played_callback()
			end

			local cinematic_scene_name = self._active_story.cinematic_scene_name
			self._active_story = nil

			self:_play_next_in_queue()

			if not self._is_server then
				self:_check_last_played_on_client(cinematic_scene_name)
			end
		end
	else
		self:_play_next_in_queue()
	end

	if GameParameters.testify then
		Testify:poll_requests_through_handler(CinematicManagerTestify, self)
	end
end

CinematicManager._check_last_played_on_client = function (self, cinematic_scene_name)
	fassert(not self._is_server, "Client only method.")

	if table.is_empty(self._queued_stories) and self._active_story == nil then
		local cinematic_scene_system = Managers.state.extension:system("cinematic_scene_system")

		cinematic_scene_system:client_unset_scene(cinematic_scene_name)
		self:unload_levels(cinematic_scene_name)
		Managers.world:set_world_update_time_scale(1)
	end
end

CinematicManager._play_next_in_queue = function (self)
	if not table.is_empty(self._queued_stories) then
		local item = table.remove(self._queued_stories, 1)

		self:play_story(item)

		if not self._is_server then
			local cinematic_scene_system = Managers.state.extension:system("cinematic_scene_system")

			cinematic_scene_system:client_set_scene(item.cinematic_scene_name)
		end
	end
end

CinematicManager.active_camera = function (self)
	if self._active_testify_camera then
		return self._active_testify_camera, true
	else
		local story = self._active_story
		local camera = nil

		if story and story.story_id and story.story_id >= 0 then
			local story_length = self._storyteller:length(story.story_id)
			local story_time = self._storyteller:time(story.story_id)
			story_time = math.clamp(story_time, 0, story_length - 1e-05)
			camera = self._storyteller:get_active_camera(story.story_id, story_time)
		end

		return camera, false
	end
end

CinematicManager.is_playing = function (self)
	return self._active_story ~= nil
end

CinematicManager.is_using_cinematic_levels = function (self)
	return self._level_loader:has_levels()
end

CinematicManager.alignment_inverse_pose = function (self)
	local story = self._active_story

	if story and story.story_id and story.story_id >= 0 then
		return story.alignment_inverse_pose
	end

	return nil
end

CinematicManager.active = function (self)
	return self:active_camera() ~= nil
end

CinematicManager.register_story = function (self, params)
	local category = params.cinematic_category
	local story_definition = {
		name = params.story_name,
		weight = params.weight,
		level = params.flow_level,
		category = category,
		scene_unit_origin = nil,
		scene_unit_destination = nil,
		use_alignment_units = false,
		alignment_pose = nil,
		alignment_inverse_pose = nil,
		origin_level = nil,
		destination_level = nil,
		story_id = nil
	}
	local category_stories = self._stories[category] or {}
	category_stories[#category_stories + 1] = story_definition
	self._stories[category] = category_stories
end

CinematicManager.queue_story = function (self, cinematic_scene_name, category, optional_scene_unit_origin, optional_scene_unit_destination, played_callback, client_channel_id, hotjoin_only)
	local category_stories = self._stories[category]

	if category_stories and #category_stories > 0 then
		local total_weight = 0

		for _, story_definition in ipairs(category_stories) do
			total_weight = total_weight + story_definition.weight
		end

		local story_definition = category_stories[1]
		local roll = math.random() * total_weight

		for i = 1, #category_stories do
			roll = roll - category_stories[i].weight

			if roll <= 0 then
				story_definition = category_stories[i]

				break
			end
		end

		story_definition.played_callback = played_callback
		story_definition.cinematic_scene_name = cinematic_scene_name

		fassert(optional_scene_unit_origin ~= nil and optional_scene_unit_destination ~= nil or optional_scene_unit_origin == nil and optional_scene_unit_destination == nil, "Missing alignment units with component 'CinematicScene'.")

		if optional_scene_unit_origin ~= nil and optional_scene_unit_destination ~= nil then
			story_definition.category = category
			story_definition.scene_unit_origin = optional_scene_unit_origin
			story_definition.scene_unit_destination = optional_scene_unit_destination
			local destination_pose = Unit.world_pose(optional_scene_unit_destination, 1)
			local alignment_inverse_pose = Matrix4x4.inverse(destination_pose)
			story_definition.alignment_pose = Matrix4x4Box(destination_pose)
			story_definition.alignment_inverse_pose = Matrix4x4Box(alignment_inverse_pose)
			story_definition.use_alignment_units = true
			local origin_level = Unit.level(optional_scene_unit_origin)
			local destination_level = Unit.level(optional_scene_unit_destination)
			story_definition.origin_level = origin_level
			story_definition.destination_level = destination_level
			local has_origin_level, origin_level_name = self:_is_valid_origin_level(origin_level, destination_level)
			local scene_unit_origin_level_id = Level._unit_index(origin_level, optional_scene_unit_origin)
			local scene_unit_destination_level_id = Level._unit_index(destination_level, optional_scene_unit_destination)
			local story_name = story_definition.name
			local cinematic_scene_name_id = NetworkLookup.cinematic_scene_names[cinematic_scene_name]

			if self._is_server then
				if not client_channel_id and not hotjoin_only then
					Managers.state.game_session:send_rpc_clients("rpc_cinematic_story_sync", cinematic_scene_name_id, category, story_name, scene_unit_origin_level_id, scene_unit_destination_level_id, has_origin_level, origin_level_name)
				elseif client_channel_id then
					RPC.rpc_cinematic_story_sync(client_channel_id, cinematic_scene_name_id, category, story_name, scene_unit_origin_level_id, scene_unit_destination_level_id, has_origin_level, origin_level_name)
				end
			end
		else
			story_definition.use_alignment_units = false
			local story_name = story_definition.name

			if self._is_server then
				if not client_channel_id and not hotjoin_only then
					local cinematic_scene_name_id = NetworkLookup.cinematic_scene_names[cinematic_scene_name]

					Managers.state.game_session:send_rpc_clients("rpc_cinematic_story_sync", cinematic_scene_name_id, category, story_name, NetworkConstants.invalid_level_unit_id, NetworkConstants.invalid_level_unit_id, false, "")
				elseif client_channel_id then
					local cinematic_scene_name_id = NetworkLookup.cinematic_scene_names[cinematic_scene_name]

					RPC.rpc_cinematic_story_sync(client_channel_id, cinematic_scene_name_id, category, story_name, NetworkConstants.invalid_level_unit_id, NetworkConstants.invalid_level_unit_id, false, "")
				end
			end
		end

		if not client_channel_id then
			table.insert(self._queued_stories, story_definition)
		end

		return true
	else
		return false
	end
end

CinematicManager.play_story = function (self, story_definition)
	if GameParameters.skip_cinematics then
		return false
	end

	local story_level = story_definition.level
	local story_id = self._storyteller:play_level_story(story_level, story_definition.name)

	if story_definition.use_alignment_units and not self._aligned_levels[story_level] then
		local alignment_pose = story_definition.alignment_pose:unbox()

		Level.set_pose(story_level, alignment_pose)

		local position = Unit.local_position(story_definition.scene_unit_destination, 1)
		local rotation = Unit.local_rotation(story_definition.scene_unit_destination, 1)

		self._storyteller:set_rotation(story_id, rotation)
		self._storyteller:set_position(story_id, position)

		self._aligned_levels[story_level] = true
	end

	story_definition.story_id = story_id
	self._active_story = story_definition

	return true
end

CinematicManager.stop_all_stories = function (self)
	self:_unload_all_levels()

	if self._active_story then
		local story_definition = self._active_story
		local story_id = story_definition.story_id

		self._storyteller:stop(story_id)

		self._active_story = nil
	end

	table.clear(self._queued_stories)
end

CinematicManager._on_levels_loaded = function (self, request_id, cinematic_name, levels_loaded)
	if not self._cinematic_levels[cinematic_name] then
		self._cinematic_levels[cinematic_name] = {}
	end

	local levels = self._cinematic_levels[cinematic_name]

	fassert(#levels == 0, "Previous levels not cleaned.")

	for level_name, _ in pairs(levels_loaded) do
		levels[#levels + 1] = self:_spawn_cinematic_level(level_name)
	end

	if self._is_server then
		fassert(self._on_levels_spawned_callback[request_id] ~= nil, "No Cinematic Scene callback set.")
		self._on_levels_spawned_callback[request_id](cinematic_name)

		self._on_levels_spawned_callback[request_id] = nil
	else
		self._on_levels_spawned_callback[request_id]()

		self._on_levels_spawned_callback[request_id] = nil
	end
end

CinematicManager.load_levels = function (self, cinematic_name, level_names, on_levels_spawned_callback, client_channel_id, hotjoin_only)
	local request_id = cinematic_name .. "_" .. tostring(client_channel_id)

	fassert(self._on_levels_spawned_callback[request_id] == nil, "Cinematic Scene currently loading levels for %s.", cinematic_name)

	self._on_levels_spawned_callback[request_id] = on_levels_spawned_callback
	local on_levels_loaded = callback(self, "_on_levels_loaded", request_id)

	self._level_loader:start_loading(cinematic_name, level_names, on_levels_loaded)

	if self._is_server then
		if not client_channel_id and not hotjoin_only then
			local cinematic_name_id = NetworkLookup.cinematic_scene_names[cinematic_name]

			Managers.state.game_session:send_rpc_clients("rpc_cinematic_load_levels", cinematic_name_id, level_names)
		elseif client_channel_id then
			local cinematic_name_id = NetworkLookup.cinematic_scene_names[cinematic_name]

			RPC.rpc_cinematic_load_levels(client_channel_id, cinematic_name_id, level_names)
		end
	end
end

CinematicManager._on_client_levels_prepared = function (self)
	fassert(not self._is_server, "[CinematicManager] Client only method.")

	local stories_onhold = self._stories_onhold

	for _, story_onhold in ipairs(stories_onhold) do
		self:_client_cinematic_story_sync(story_onhold.cinematic_scene_name, story_onhold.category, story_onhold.story_name, story_onhold.scene_unit_origin_level_id, story_onhold.scene_unit_destination_level_id, story_onhold.origin_level_name)
	end

	table.clear(stories_onhold)
end

CinematicManager._unload_all_levels = function (self)
	local cinematic_levels = self._cinematic_levels

	for cinematic_name, levels in pairs(cinematic_levels) do
		if table.size(levels) > 0 then
			self:unload_levels(cinematic_name)
		end
	end

	table.clear(cinematic_levels)
	self._level_loader:cleanup()
end

CinematicManager.unload_levels = function (self, cinematic_name)
	for _, stories in pairs(self._stories) do
		for i = #stories, 1, -1 do
			if stories[i].cinematic_scene_name == cinematic_name then
				table.remove(stories, i)
			end
		end
	end

	local cinematic_levels = self._cinematic_levels[cinematic_name]

	if cinematic_levels then
		for _, level in ipairs(cinematic_levels) do
			self:_unspawn_level(level)
		end

		table.clear(cinematic_levels)
		table.clear(self._aligned_levels)
	end

	self._level_loader:cleanup()
end

CinematicManager._spawn_cinematic_level = function (self, level_name)
	local world = self._world
	local spawn_units = true
	local level = ScriptWorld.spawn_level(world, level_name, nil, nil, nil, spawn_units)

	Level.set_data(level, "runtime_loaded_level", true)

	local level_units = Level.units(level, true)
	local category_name = "cinematic"
	local extension_manager = Managers.state.extension

	extension_manager:add_and_register_units(world, level_units, nil, category_name)

	local unit_spawner_manager = Managers.state.unit_spawner

	unit_spawner_manager:register_runtime_loaded_level(level)
	Level.trigger_level_spawned(level)

	return level
end

CinematicManager._unspawn_level = function (self, level)
	Level.trigger_level_shutdown(level)

	local unit_spawner_manager = Managers.state.unit_spawner

	unit_spawner_manager:unregister_runtime_loaded_level(level)

	local level_units = Level.units(level, true)
	local extension_manager = Managers.state.extension

	extension_manager:unregister_units(level_units, #level_units)

	local world = self._world
	local level_name = Level.name(level)
	level_name = level_name:match("(.+)%..+$")

	ScriptWorld.destroy_level(world, level_name)
end

CinematicManager.rpc_cinematic_story_sync = function (self, channel_id, cinematic_scene_name_id, category, story_name, scene_unit_origin_level_id, scene_unit_destination_level_id, has_origin_level, origin_level_name)
	local cinematic_scene_name = NetworkLookup.cinematic_scene_names[cinematic_scene_name_id]

	if not has_origin_level or self._level_loader:check_loading(cinematic_scene_name) then
		self:_client_cinematic_story_sync(cinematic_scene_name, category, story_name, scene_unit_origin_level_id, scene_unit_destination_level_id, origin_level_name)
	else
		local story_definition = {
			category = category,
			story_name = story_name,
			scene_unit_origin_level_id = scene_unit_origin_level_id,
			scene_unit_destination_level_id = scene_unit_destination_level_id,
			origin_level_name = origin_level_name,
			cinematic_scene_name = cinematic_scene_name
		}
		self._stories_onhold[#self._stories_onhold + 1] = story_definition
	end
end

CinematicManager._client_cinematic_story_sync = function (self, cinematic_scene_name, category, story_name, scene_unit_origin_level_id, scene_unit_destination_level_id, origin_level_name)
	fassert(not self._is_server, "[CinematicManager] Client only method.")

	local category_stories = self._stories[category]
	local world = self._world

	for i = 1, #category_stories do
		local story_definition = category_stories[i]

		if story_definition.name == story_name then
			story_definition.cinematic_scene_name = cinematic_scene_name

			if scene_unit_origin_level_id ~= NetworkConstants.invalid_level_unit_id and scene_unit_destination_level_id ~= NetworkConstants.invalid_level_unit_id then
				local scene_unit_origin = nil
				local is_level_unit = true

				if origin_level_name ~= "" then
					local origin_level = ScriptWorld.level(world, origin_level_name)
					scene_unit_origin = Level._unit_by_index(origin_level, scene_unit_origin_level_id)
				else
					scene_unit_origin = Managers.state.unit_spawner:unit(scene_unit_origin_level_id, is_level_unit)
				end

				local scene_unit_destination = Managers.state.unit_spawner:unit(scene_unit_destination_level_id, is_level_unit)

				fassert(scene_unit_origin ~= nil, "[CinematicManager] Could not retrieve Origin Cinematic Scene.")
				fassert(scene_unit_destination ~= nil, "[CinematicManager] Could not retrieve Destination Cinematic Scene.")

				story_definition.scene_unit_origin = scene_unit_origin
				story_definition.scene_unit_destination = scene_unit_destination
				local destination_pose = Unit.world_pose(scene_unit_destination, 1)
				local alignment_inverse_pose = Matrix4x4.inverse(destination_pose)
				story_definition.alignment_pose = Matrix4x4Box(destination_pose)
				story_definition.alignment_inverse_pose = Matrix4x4Box(alignment_inverse_pose)
				story_definition.use_alignment_units = true
				local origin_level = Unit.level(scene_unit_origin)
				local destination_level = Unit.level(scene_unit_destination)
				story_definition.origin_level = origin_level
				story_definition.destination_level = destination_level
			elseif scene_unit_origin_level_id == NetworkConstants.invalid_level_unit_id and scene_unit_destination_level_id == NetworkConstants.invalid_level_unit_id then
				story_definition.use_alignment_units = false
			else
				fassert(false, "[CinematicManager] Incomplete message to queue story. scene_unit_origin_level_id(%d), scene_unit_destination_level_id(%d).", scene_unit_origin_level_id, scene_unit_destination_level_id)
			end

			table.insert(self._queued_stories, story_definition)
		end
	end
end

CinematicManager.rpc_cinematic_load_levels = function (self, channel_id, cinematic_name_id, cinematic_level_names)
	local cinematic_name = NetworkLookup.cinematic_scene_names[cinematic_name_id]
	local on_client_levels_prepared = callback(self, "_on_client_levels_prepared")

	self:load_levels(cinematic_name, cinematic_level_names, on_client_levels_prepared)
end

CinematicManager.deactivate_testify_camera = function (self)
	self._active_testify_camera = nil
end

CinematicManager.set_active_testify_camera = function (self, camera)
	self._active_testify_camera = camera
end

CinematicManager.testify_camera = function (self)
	return self._active_testify_camera
end

return CinematicManager
