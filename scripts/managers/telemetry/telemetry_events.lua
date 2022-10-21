local TelemetryEvent = require("scripts/managers/telemetry/telemetry_event")
local TelemetrySettings = require("scripts/managers/telemetry/telemetry_settings")
local TelemetryEvents = class("TelemetryEvents")
local RPCS = {
	"rpc_sync_server_session_id"
}
local SOURCE = table.remove_empty_values(TelemetrySettings.source)

TelemetryEvents.init = function (self, telemetry_manager, event_delegate)
	self._manager = telemetry_manager
	self._event_delegate = event_delegate

	if GameParameters.testify then
		self._subject = {
			machine_id = Application.machine_id(),
			machine_name = string.value_or_nil(GameParameters.machine_name)
		}
	else
		self._subject = {}
	end

	if DEDICATED_SERVER then
		self._session = {}
	else
		self._session = {
			game = Application.guid()
		}

		self._event_delegate:register_connection_events(self, unpack(RPCS))
	end

	if Wwise.set_starvation_callback then
		Wwise.set_starvation_callback(function (event_name, object_name, error_code)
			self:on_wwise_starvation(event_name, object_name, error_code)
		end)
	end

	self.context = {}

	self:game_startup()
end

TelemetryEvents.destroy = function (self)
	if not DEDICATED_SERVER then
		self._event_delegate:unregister_events(unpack(RPCS))
	end

	self:game_shutdown()
end

TelemetryEvents.on_wwise_starvation = function (self, event_name, object_name, error_code)
	local event = self:_create_event("wwise_source_starvation")

	event:set_data({
		event_name = event_name,
		object_name = object_name,
		error_code = error_code
	})
	self._manager:register_event(event)
end

TelemetryEvents.rpc_sync_server_session_id = function (self, channel_id, session_id)
	self._session.gameplay = session_id

	for _, player in pairs(Managers.player:players_at_peer(Network.peer_id())) do
		self:client_connected(player)
	end
end

TelemetryEvents.client_connected = function (self, player)
	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "client_connected", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay
	})

	event:set_data({
		auth_platform = Managers.presence:presence_entry_myself():platform()
	})
	self._manager:register_event(event)
end

TelemetryEvents.client_disconnected = function (self, player, info)
	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "client_disconnected", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay
	})

	event:set_data({
		info = info
	})
	self._manager:register_event(event)

	self._session.gameplay = nil
	self.context.map = nil
end

TelemetryEvents.game_startup = function (self)
	local event = self:_create_event("game_startup")

	self._manager:register_event(event)
end

TelemetryEvents.game_shutdown = function (self)
	local event = self:_create_event("game_shutdown")

	self._manager:register_event(event)
end

TelemetryEvents._create_event = function (self, type)
	return TelemetryEvent:new(SOURCE, self._subject, type, self._session)
end

TelemetryEvents.mission_session_started = function (self, session_id, map)
	self._session.gameplay = session_id
	self.context.map = map
	local event = self:_create_event("mission_session_started")

	self._manager:register_event(event)
end

TelemetryEvents.mission_session_completed = function (self)
	local event = self:_create_event("mission_session_completed")

	self._manager:register_event(event)

	self._session.gameplay = nil
	self.context.map = nil
end

TelemetryEvents.hub_session_started = function (self, session_id)
	self._session.gameplay = session_id
	local event = self:_create_event("hub_session_started")

	self._manager:register_event(event)
end

TelemetryEvents.hub_session_completed = function (self)
	local event = self:_create_event("hub_session_completed")

	self._manager:register_event(event)

	self._session.gameplay = nil
end

TelemetryEvents.player_authenticated = function (self, account)
	self._subject.account_id = string.value_or_nil(account.sub)
	local event = self:_create_event("player_authenticated")

	self._manager:register_event(event)
end

TelemetryEvents.system_settings = function (self)
	local fullscreen = Application.user_setting("fullscreen")
	local borderless_fullscreen = Application.user_setting("borderless_fullscreen")
	local windowed = not fullscreen and not borderless_fullscreen
	local screen_mode = fullscreen and "fullscreen" or borderless_fullscreen and "borderless_fullscreen" or windowed and "windowed"
	local master_render_settings = Application.user_setting("master_render_settings")
	local video_settings = {
		resolution = string.format("%dx%d", Application.back_buffer_size()),
		screen_mode = screen_mode,
		adapter_index = Application.user_setting("adapter_index")
	}

	if master_render_settings then
		table.merge(video_settings, master_render_settings)
		table.merge(video_settings, Application.user_setting("render_settings") or {})
		table.merge(video_settings, Application.user_setting("performance_settings") or {})

		video_settings.render_api = Renderer.render_device_string()
		video_settings.graphics_quality = video_settings.graphics_quality or Application.user_setting("graphics_quality")
		video_settings.vsync = Application.user_setting("vsync")
	end

	local sound_settings = Application.user_setting("sound_settings")
	local account_data = Managers.save:account_data()
	local language = Managers.localization:language()
	local event = self:_create_event("system_settings")

	event:set_data({
		system = Application.sysinfo(),
		video_settings = video_settings,
		sound_settings = sound_settings,
		interface_settings = account_data.interface_settings,
		input_settings = account_data.input_settings,
		language = language
	})
	event:set_revision(1)
	self._manager:register_event(event)
end

TelemetryEvents.heartbeat = function (self)
	local event = self:_create_event("heartbeat")

	self._manager:register_event(event)
end

TelemetryEvents.player_dealt_damage_summary = function (self, summaries)
	for player, summary in pairs(summaries) do
		local entries = summary.entries
		local player_data = summary.player_data
		local event = TelemetryEvent:new(SOURCE, player_data.telemetry_subject, "player_dealt_damage_summary", {
			game = player_data.telemetry_game_session,
			gameplay = self._session.gameplay
		})

		event:set_data(entries)
		self._manager:register_event(event)
	end
end

TelemetryEvents.player_taken_damage_summary = function (self, summaries)
	for player, summary in pairs(summaries) do
		local entries = summary.entries
		local player_data = summary.player_data
		local event = TelemetryEvent:new(SOURCE, player_data.telemetry_subject, "player_taken_damage_summary", {
			game = player_data.telemetry_game_session,
			gameplay = self._session.gameplay
		})

		event:set_data(entries)
		self._manager:register_event(event)
	end
end

TelemetryEvents.player_killed_enemy = function (self, player, data)
	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "player_killed_enemy", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay
	})

	event:set_data(data)
	self._manager:register_event(event)
end

TelemetryEvents.player_knocked_down = function (self, player, data)
	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "player_knocked_down", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay
	})

	event:set_data(data)
	self._manager:register_event(event)
end

TelemetryEvents.player_died = function (self, player, data)
	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "player_died", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay
	})

	event:set_data(data)
	self._manager:register_event(event)
end

TelemetryEvents.player_revived_ally = function (self, player, reviver_position, revivee_position)
	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "player_revived_ally", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay
	})

	event:set_data({
		reviver_position = reviver_position,
		revivee_position = revivee_position
	})
	self._manager:register_event(event)
end

TelemetryEvents.player_hacked_terminal = function (self, player, mistakes)
	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "player_hacked_terminal", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay
	})

	event:set_data({
		mistakes = mistakes
	})
	self._manager:register_event(event)
end

TelemetryEvents.player_scanned_objects = function (self, player, objects)
	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "player_scanned_objects", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay
	})

	event:set_data({
		objects = objects
	})
	self._manager:register_event(event)
end

TelemetryEvents.player_completed_objective = function (self, player, objective)
	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "player_completed_objective", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay
	})

	event:set_data({
		objective = objective
	})
	self._manager:register_event(event)
end

TelemetryEvents.player_picked_item = function (self, player, item)
	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "player_picked_item", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay
	})

	event:set_data({
		item = item
	})
	self._manager:register_event(event)
end

TelemetryEvents.player_placed_item = function (self, player, item)
	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "player_placed_item", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay
	})

	event:set_data({
		item = item
	})
	self._manager:register_event(event)
end

TelemetryEvents.player_shared_item = function (self, player, item)
	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "player_shared_item", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay
	})

	event:set_data({
		item = item
	})
	self._manager:register_event(event)
end

TelemetryEvents.vo_event_triggered = function (self, global_context, player_context, event_name, vo_rule, vo_profile_name, vo_category_name, resistance, challenge)
	local event = self:_create_event("vo_event_triggered")
	local data = {
		mission = {
			name = global_context.current_mission,
			time = global_context.level_time,
			challenge = challenge,
			resistance = resistance,
			pacing_tension = global_context.pacing_tension,
			active_hordes = global_context.active_hordes
		},
		vo = {
			event_name = event_name,
			rule = vo_rule,
			profile_name = vo_profile_name,
			category_name = vo_category_name
		}
	}

	if player_context.is_player == "true" then
		data.player = {
			health = player_context.health,
			friends_close = player_context.friends_close,
			enemies_close = player_context.enemies_close,
			is_knocked_down = player_context.is_knocked_down == "true",
			is_pounced_down = player_context.is_pounced_down == "true",
			is_ledge_hanging = player_context.is_ledge_hanging == "true"
		}
	end

	event:set_data(data)
	self._manager:register_event(event)
end

TelemetryEvents.vo_bank_reshuffled = function (self, character_name, bank_name)
	local event = self:_create_event("vo_bank_reshuffled")

	event:set_data({
		mission = {
			name = self.context.map
		},
		character_name = character_name,
		bank_name = bank_name
	})
	self._manager:register_event(event)
end

TelemetryEvents.camera_performance_measurements = function (self, map, camera, measurements)
	local event = self:_create_event("performance_static_camera_measurements")

	event:set_data({
		map = map,
		camera_id = camera.id_string,
		camera_name = camera.name,
		go_to_camera_position_link = camera.go_to_camera_position_link,
		ms_per_frame = measurements.ms_per_frame,
		batchcount = measurements.batchcount,
		primitives_count = measurements.primitives_count
	})
	self._manager:register_event(event)
end

TelemetryEvents.memory_usage = function (self, map, index, memory_usage)
	local event = self:_create_event("performance_memory_usage")

	event:set_data({
		map = map,
		index = index,
		memory_usage = memory_usage
	})
	self._manager:register_event(event)
end

TelemetryEvents.performance_load_times = function (self, map, wait_for_network_time, resource_load_time, mission_intro_time, wait_for_spawn_time)
	local event = self:_create_event("performance_load_times")

	event:set_data({
		map = map,
		wait_for_network_time = wait_for_network_time,
		resource_load_time = resource_load_time,
		mission_intro_time = mission_intro_time,
		wait_for_spawn_time = wait_for_spawn_time
	})
	self._manager:register_event(event)
end

TelemetryEvents.lua_trace_stats = function (self, map, index, lua_trace_stats)
	local event = self:_create_event("lua_trace_stats")

	event:set_data({
		map = map,
		index = index,
		total_offenders = lua_trace_stats.total_offenders,
		total_allocs = lua_trace_stats.total_allocs,
		total_bytes = lua_trace_stats.total_bytes
	})
	self._manager:register_event(event)
end

TelemetryEvents.performance_frame_time = function (self, avg, std_dev, p99, p95, p90, p75, p50, p25, observations, map_name)
	local event = self:_create_event("performance_frame_time")

	event:set_data({
		avg = avg,
		std_dev = std_dev,
		p99 = p99,
		p95 = p95,
		p90 = p90,
		p75 = p75,
		p50 = p50,
		p25 = p25,
		observations = observations,
		map_name = map_name
	})
	self._manager:register_event(event)
end

TelemetryEvents.performance_ping = function (self, avg, std_dev, p99, p95, p90, p75, p50, p25, observations, region, map_name)
	local event = self:_create_event("performance_ping")

	event:set_data({
		avg = avg,
		std_dev = std_dev,
		p99 = p99,
		p95 = p95,
		p90 = p90,
		p75 = p75,
		p50 = p50,
		p25 = p25,
		observations = observations,
		region = region,
		map_name = map_name
	})
	self._manager:register_event(event)
end

TelemetryEvents.character_creation_time = function (self, character_id, time)
	local event = TelemetryEvent:new(SOURCE, {
		account_id = self._subject.account_id,
		character_id = character_id
	}, "character_creation_time", self._session)

	event:set_data({
		time = time
	})
	self._manager:register_event(event)
end

TelemetryEvents.record_slow_response_time = function (self, path, response_time)
	local event = self:_create_event("slow_backend_response")

	event:set_data({
		response_time = response_time,
		path = path
	})
	self._manager:register_event(event)
end

return TelemetryEvents
