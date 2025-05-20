-- chunkname: @scripts/managers/telemetry/telemetry_events.lua

local TelemetryEvent = require("scripts/managers/telemetry/telemetry_event")
local TelemetrySettings = require("scripts/managers/telemetry/telemetry_settings")
local TelemetryHelper = require("scripts/managers/telemetry/telemetry_helper")
local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local HOST_TYPES = MatchmakingConstants.HOST_TYPES
local TelemetryEvents = class("TelemetryEvents")
local RPCS = {
	"rpc_sync_server_session_id",
}
local SOURCE = table.remove_empty_values(TelemetrySettings.source)
local BLACKLISTED_VIEWS = TelemetrySettings.blacklisted_views

TelemetryEvents.init = function (self, telemetry_manager, connection_manager)
	self._manager = telemetry_manager
	self._connection_manager = connection_manager
	self._subject = {}

	if GameParameters.testify then
		self._subject = {
			machine_id = Application.machine_id(),
			machine_name = string.value_or_nil(GameParameters.machine_name),
		}
	end

	self._session = {
		game = Application.guid(),
	}

	Crashify.print_property("game_session_id", self._session.game)

	if not DEDICATED_SERVER then
		self._connection_manager:network_event_delegate():register_connection_events(self, unpack(RPCS))
	end

	if Wwise.set_starvation_callback then
		Wwise.set_starvation_callback(function (event_name, object_name, error_code)
			self:on_wwise_starvation(event_name, object_name, error_code)
		end)
	end

	self._context = {}

	self:game_startup()
end

TelemetryEvents.refresh_settings = function (self)
	SOURCE.backend_environment = BACKEND_ENV
	SOURCE.auth_platform = AUTH_PLATFORM
end

TelemetryEvents.destroy = function (self)
	if not DEDICATED_SERVER then
		self._connection_manager:network_event_delegate():unregister_events(unpack(RPCS))
	end

	self:game_shutdown()

	local batch_size, time_since_last_post, event_types = Managers.telemetry:batch_info()

	self:post_batch(batch_size, time_since_last_post, event_types, true)
end

TelemetryEvents.on_wwise_starvation = function (self, event_name, object_name, error_code)
	local event = self:_create_event("wwise_source_starvation")

	event:set_data({
		event_name = event_name,
		object_name = object_name,
		error_code = error_code,
	})
	self._manager:register_event(event)
end

TelemetryEvents.rpc_sync_server_session_id = function (self, channel_id, session_id)
	local host_type = self._connection_manager:host_type()

	if host_type == HOST_TYPES.mission_server or host_type == HOST_TYPES.hub_server then
		self._session.gameplay = session_id
	end
end

TelemetryEvents.client_connected = function (self, player)
	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "client_connected", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay,
	})

	self._manager:register_event(event)
end

local _tracked_slots = {
	"slot_attachment_1",
	"slot_attachment_2",
	"slot_attachment_3",
	"slot_primary",
	"slot_secondary",
	"slot_character_title",
}

TelemetryEvents.player_inventory = function (self, player)
	local profile = player:profile()
	local item_data = profile and profile.loadout_item_data or {}
	local item_ids = profile and profile.loadout_item_ids or {}
	local items = table.clone(item_data)

	for i = 1, #_tracked_slots do
		local slot_name = _tracked_slots[i]
		local id = item_ids[slot_name]
		local data = items[slot_name]

		if data and id then
			data.gear_id = id
		end
	end

	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "player_inventory", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay,
	})

	event:set_data(items)
	self._manager:register_event(event)
end

TelemetryEvents.client_disconnected = function (self, player, info)
	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "client_disconnected", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay,
	})

	event:set_data(info)
	event:set_revision(1)
	self._manager:register_event(event)
end

TelemetryEvents.game_startup = function (self)
	local event = self:_create_event("game_startup")

	self._manager:register_event(event)
end

TelemetryEvents.game_shutdown = function (self)
	local event = self:_create_event("game_shutdown")

	event:set_data({
		time_in_game = Application.time_since_launch(),
	})
	self._manager:register_event(event)
end

TelemetryEvents._create_event = function (self, type)
	return TelemetryEvent:new(SOURCE, self._subject, type, self._session)
end

TelemetryEvents.mission_session_started = function (self, session_id, map)
	self._session.gameplay = session_id
	self._context.map = map

	local event = self:_create_event("mission_session_started")

	self._manager:register_event(event)
end

TelemetryEvents.hub_session_started = function (self, session_id)
	self._session.gameplay = session_id

	local event = self:_create_event("hub_session_started")

	self._manager:register_event(event)
end

TelemetryEvents.gameplay_started = function (self, params)
	self._context.host_type = params.host_type
	self._context.map = params.mission_name

	if params.host_type == HOST_TYPES.singleplay or params.host_type == HOST_TYPES.hub_server then
		self._session.gameplay = Application.guid()
	end

	local event = self:_create_event("gameplay_started")

	event:set_data({
		map = self._context.map,
		host_type = self._context.host_type,
	})
	self._manager:register_event(event)

	local telemetry_reporters = Managers.telemetry_reporters

	telemetry_reporters:start_reporter("com_wheel")
	telemetry_reporters:start_reporter("combat_ability")
	telemetry_reporters:start_reporter("enemy_spawns")
	telemetry_reporters:start_reporter("fixed_update_missed_inputs")
	telemetry_reporters:start_reporter("frame_time", params)
	telemetry_reporters:start_reporter("grenade_ability")
	telemetry_reporters:start_reporter("pacing")
	telemetry_reporters:start_reporter("picked_items")
	telemetry_reporters:start_reporter("used_items")
	telemetry_reporters:start_reporter("ping", params)
	telemetry_reporters:start_reporter("placed_items")
	telemetry_reporters:start_reporter("player_dealt_damage")
	telemetry_reporters:start_reporter("player_taken_damage")
	telemetry_reporters:start_reporter("player_terminate_enemy")
	telemetry_reporters:start_reporter("shared_items")
	telemetry_reporters:start_reporter("smart_tag")
	telemetry_reporters:start_reporter("tactical_overlay")
	telemetry_reporters:start_reporter("voice_over_bank_reshuffled")
	telemetry_reporters:start_reporter("voice_over_event_triggered")
	telemetry_reporters:start_reporter("mispredict")
end

TelemetryEvents.gameplay_stopped = function (self)
	local telemetry_reporters = Managers.telemetry_reporters

	telemetry_reporters:stop_reporter("voice_over_event_triggered")
	telemetry_reporters:stop_reporter("voice_over_bank_reshuffled")
	telemetry_reporters:stop_reporter("tactical_overlay")
	telemetry_reporters:stop_reporter("smart_tag")
	telemetry_reporters:stop_reporter("shared_items")
	telemetry_reporters:stop_reporter("player_terminate_enemy")
	telemetry_reporters:stop_reporter("player_taken_damage")
	telemetry_reporters:stop_reporter("player_dealt_damage")
	telemetry_reporters:stop_reporter("placed_items")
	telemetry_reporters:stop_reporter("ping")
	telemetry_reporters:stop_reporter("picked_items")
	telemetry_reporters:stop_reporter("used_items")
	telemetry_reporters:stop_reporter("pacing")
	telemetry_reporters:stop_reporter("grenade_ability")
	telemetry_reporters:stop_reporter("frame_time")
	telemetry_reporters:stop_reporter("fixed_update_missed_inputs")
	telemetry_reporters:stop_reporter("enemy_spawns")
	telemetry_reporters:stop_reporter("combat_ability")
	telemetry_reporters:stop_reporter("com_wheel")
	telemetry_reporters:stop_reporter("mispredict")

	local event = self:_create_event("gameplay_stopped")

	event:set_data({
		map = self._context.map,
		host_type = self._context.host_type,
	})
	self._manager:register_event(event)

	self._session.gameplay = nil
	self._context.map = nil
end

TelemetryEvents.player_authenticated = function (self, account)
	self._subject.account_id = string.value_or_nil(account.sub)

	local event = self:_create_event("player_authenticated")

	self._manager:register_event(event)
end

TelemetryEvents.local_player_spawned = function (self, player)
	self._subject.account_id = player:account_id()
	self._subject.character_id = player:character_id()
end

TelemetryEvents.character_selected = function (self, character_id)
	self._subject.character_id = character_id
end

TelemetryEvents.system_settings = function (self, account_id)
	local fullscreen = Application.user_setting("fullscreen")
	local borderless_fullscreen = Application.user_setting("borderless_fullscreen")
	local windowed = not fullscreen and not borderless_fullscreen
	local screen_mode = fullscreen and "fullscreen" or borderless_fullscreen and "borderless_fullscreen" or windowed and "windowed"
	local master_render_settings = Application.user_setting("master_render_settings")
	local video_settings = {
		resolution = string.format("%dx%d", Application.back_buffer_size()),
		screen_mode = screen_mode,
		adapter_index = Application.user_setting("adapter_index"),
	}

	if master_render_settings then
		video_settings.master_render_settings = master_render_settings
		video_settings.render_settings = Application.user_setting("render_settings") or {}
		video_settings.performance_settings = Application.user_setting("performance_settings") or {}
		video_settings.render_api = Renderer.render_device_string()
		video_settings.vsync = Application.user_setting("vsync")
	end

	local sound_settings = Application.user_setting("sound_settings")
	local account_data = Managers.save:account_data(account_id)
	local language = Managers.localization:language()
	local data = {
		system = Application.sysinfo(),
		video_settings = video_settings,
		sound_settings = sound_settings,
		interface_settings = account_data.interface_settings,
		input_settings = account_data.input_settings,
		language = language,
	}

	if IS_XBS then
		local xbox_data = {}

		xbox_data.is_streaming = XboxLive.is_streaming and XboxLive.is_streaming() or false

		if Xbox.console_type() == Xbox.CONSOLE_TYPE_XBOX_SCARLETT_ANACONDA then
			xbox_data.model = "anaconda"
		elseif Xbox.console_type() == Xbox.CONSOLE_TYPE_XBOX_SCARLETT_LOCKHEART then
			xbox_data.model = "lockheart"
		end

		data.xbox = xbox_data
	end

	if IS_WINDOWS then
		local win_data = {}

		if HAS_STEAM then
			win_data.steamdeck = Steam.is_running_on_steamdeck and Steam.is_running_on_steamdeck() or false
		end

		win_data.wine_version = Application.wine_version and Application.wine_version() or false
		data.windows = win_data
	end

	local event = self:_create_event("system_settings")

	event:set_data(data)
	event:set_revision(2)
	self._manager:register_event(event)
end

TelemetryEvents.heartbeat = function (self)
	local event = self:_create_event("heartbeat")

	self._manager:register_event(event)
end

TelemetryEvents.start_terror_event = function (self, event_name)
	local event = self:_create_event("start_terror_event")

	event:set_data({
		name = event_name,
	})
	self._manager:register_event(event)
end

TelemetryEvents.stop_terror_event = function (self, event_name)
	local event = self:_create_event("stop_terror_event")

	event:set_data({
		name = event_name,
	})
	self._manager:register_event(event)
end

TelemetryEvents.player_dealt_damage_report = function (self, reports)
	for _, report in pairs(reports) do
		local entries = report.entries
		local player_data = report.player_data
		local event = TelemetryEvent:new(SOURCE, player_data.telemetry_subject, "player_dealt_damage_report", {
			game = player_data.telemetry_game_session,
			gameplay = self._session.gameplay,
		})

		event:set_data(entries)
		self._manager:register_event(event)
	end
end

TelemetryEvents.player_taken_damage_report = function (self, reports)
	for _, report in pairs(reports) do
		local entries = report.entries
		local player_data = report.player_data
		local event = TelemetryEvent:new(SOURCE, player_data.telemetry_subject, "player_taken_damage_report", {
			game = player_data.telemetry_game_session,
			gameplay = self._session.gameplay,
		})

		event:set_data(entries)
		self._manager:register_event(event)
	end
end

TelemetryEvents.player_terminate_enemy_report = function (self, reports)
	for _, report in pairs(reports) do
		local entries = report.entries
		local player_data = report.player_data
		local event = TelemetryEvent:new(SOURCE, player_data.telemetry_subject, "player_terminate_enemy_report", {
			game = player_data.telemetry_game_session,
			gameplay = self._session.gameplay,
		})

		event:set_data(entries)
		self._manager:register_event(event)
	end
end

TelemetryEvents.equip_item = function (self, slot_name, item)
	local item_name = item and item.name

	if not item_name then
		return
	end

	local event = self:_create_event("equip_item")

	event:set_data({
		slot_name = slot_name,
		item_name = item_name,
	})
	self._manager:register_event(event)
end

TelemetryEvents.mispredict_report = function (self, entries, count)
	local t, t_count = {
		count = count,
		entries = {},
	}, 0

	for _, component_data in pairs(entries) do
		for _, field_data in pairs(component_data) do
			t_count = t_count + 1
			t.entries[t_count] = field_data
		end
	end

	local event = self:_create_event("mispredict_report")

	event:set_data(t)
	self._manager:register_event(event)
end

TelemetryEvents.player_knocked_down = function (self, player, data)
	data.coherency = TelemetryHelper.unit_coherency(player.player_unit)
	data.chunk = TelemetryHelper.chunk_at_unit(player.player_unit)

	if data.reason == "damage" then
		-- Nothing
	else
		data.victim_position = TelemetryHelper.unit_position(player.player_unit)
	end

	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "player_knocked_down", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay,
	})

	event:set_data(data)
	self._manager:register_event(event)
end

TelemetryEvents.player_used_health_station = function (self, player, data)
	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "player_used_health_station", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay,
	})

	event:set_data(data)
	self._manager:register_event(event)
end

TelemetryEvents.player_input_battery_into_health_station = function (self, player, data)
	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "player_input_battery_into_health_station", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay,
	})

	event:set_data(data)
	self._manager:register_event(event)
end

TelemetryEvents.health_station_spawned = function (self, unit, data)
	data.station_position = TelemetryHelper.unit_position(unit)
	data.unit_id = Managers.state.unit_spawner:level_index(unit)

	local event = self:_create_event("health_station_spawned")

	event:set_data(data)
	self._manager:register_event(event)
end

TelemetryEvents.player_picked_up_stimm = function (self, player, data)
	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "player_picked_up_stimm", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay,
	})

	event:set_data(data)
	self._manager:register_event(event)
end

TelemetryEvents.player_used_stimm = function (self, player, data)
	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "player_used_stimm", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay,
	})

	event:set_data(data)
	self._manager:register_event(event)
end

TelemetryEvents.player_stimm_heal = function (self, player, data)
	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "player_stimm_heal", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay,
	})

	event:set_data(data)
	self._manager:register_event(event)
end

TelemetryEvents.player_died = function (self, player, data)
	local reason = data.reason or ""

	if reason == "player_unit_despawned" then
		Log.debug("TelemetryEvents", "Skipping 'player_died' event due to reason = '%s'", reason)

		return
	end

	local damage_profile = data.damage_profile or ""

	if damage_profile == "kill_volume_and_off_navmesh" then
		Log.debug("TelemetryEvents", "Skipping 'player_died' event due to damage profile = '%s'", damage_profile)

		return
	end

	data.coherency = TelemetryHelper.unit_coherency(player.player_unit)
	data.chunk = TelemetryHelper.chunk_at_unit(player.player_unit)

	if data.reason == "damage" then
		-- Nothing
	else
		data.victim_position = TelemetryHelper.unit_position(player.player_unit)
	end

	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "player_died", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay,
	})

	event:set_data(data)
	self._manager:register_event(event)
end

TelemetryEvents.player_revived_ally = function (self, reviver_player, revivee_player, reviver_position, revivee_position, state_name)
	local event = TelemetryEvent:new(SOURCE, reviver_player:telemetry_subject(), "player_revived_ally", {
		game = reviver_player:telemetry_game_session(),
		gameplay = self._session.gameplay,
	})

	event:set_data({
		revivee = revivee_player:telemetry_subject(),
		reviver_position = reviver_position,
		revivee_position = revivee_position,
		type = state_name,
	})
	self._manager:register_event(event)
end

TelemetryEvents.player_exits_captivity = function (self, player, rescued_by_player, state_name, time_in_captivity)
	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "player_exits_captivity", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay,
	})

	event:set_data({
		rescued_by_player = rescued_by_player,
		time_in_captivity = time_in_captivity,
		type = state_name,
	})
	self._manager:register_event(event)
end

TelemetryEvents.player_combat_ability_report = function (self, reports)
	for _, report in pairs(reports) do
		local entries = report.entries
		local player_data = report.player_data
		local event = TelemetryEvent:new(SOURCE, player_data.telemetry_subject, "player_combat_ability_report", {
			game = player_data.telemetry_game_session,
			gameplay = self._session.gameplay,
		})

		event:set_data(entries)
		self._manager:register_event(event)
	end
end

TelemetryEvents.player_grenade_ability_report = function (self, reports)
	for _, report in pairs(reports) do
		local entries = report.entries
		local player_data = report.player_data
		local event = TelemetryEvent:new(SOURCE, player_data.telemetry_subject, "player_grenade_ability_report", {
			game = player_data.telemetry_game_session,
			gameplay = self._session.gameplay,
		})

		event:set_data(entries)
		self._manager:register_event(event)
	end
end

TelemetryEvents.player_hacked_terminal = function (self, player, mistakes)
	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "player_hacked_terminal", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay,
	})

	event:set_data({
		mistakes = mistakes,
	})
	self._manager:register_event(event)
end

TelemetryEvents.player_scanned_objects = function (self, player, objects)
	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "player_scanned_objects", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay,
	})

	event:set_data({
		objects = objects,
	})
	self._manager:register_event(event)
end

TelemetryEvents.player_started_objective = function (self, player, objective)
	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "player_started_objective", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay,
	})

	event:set_data({
		objective = objective,
	})
	self._manager:register_event(event)
end

TelemetryEvents.player_completed_objective = function (self, player, objective)
	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "player_completed_objective", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay,
	})

	event:set_data({
		objective = objective,
	})
	self._manager:register_event(event)
end

TelemetryEvents.boss_encounter_started = function (self, breed)
	local event = self:_create_event("boss_encounter_started")

	event:set_data({
		breed = breed,
	})
	self._manager:register_event(event)
end

TelemetryEvents.chest_opened = function (self, player, chest_size, chest_coordinates, chest_items)
	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "chest_opened", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay,
	})

	chest_items = table.clone(chest_items)

	for i = 1, chest_size do
		if chest_items[i] == nil then
			chest_items[i] = "empty"
		end
	end

	event:set_data({
		chest_size = chest_size,
		chest_coordinates = chest_coordinates,
		chest_items = chest_items,
	})
	self._manager:register_event(event)
end

TelemetryEvents.picked_items_report = function (self, reports)
	for player, report in pairs(reports) do
		local entries = report.entries
		local player_data = report.player_data
		local event = TelemetryEvent:new(SOURCE, player_data.telemetry_subject, "picked_items_report", {
			game = player_data.telemetry_game_session,
			gameplay = self._session.gameplay,
		})

		event:set_data(entries)
		self._manager:register_event(event)
	end
end

TelemetryEvents.placed_items_report = function (self, reports)
	for player, report in pairs(reports) do
		local entries = report.entries
		local player_data = report.player_data
		local event = TelemetryEvent:new(SOURCE, player_data.telemetry_subject, "placed_items_report", {
			game = player_data.telemetry_game_session,
			gameplay = self._session.gameplay,
		})

		event:set_data(entries)
		self._manager:register_event(event)
	end
end

TelemetryEvents.shared_items_report = function (self, reports)
	for player, report in pairs(reports) do
		local entries = report.entries
		local player_data = report.player_data
		local event = TelemetryEvent:new(SOURCE, player_data.telemetry_subject, "shared_items_report", {
			game = player_data.telemetry_game_session,
			gameplay = self._session.gameplay,
		})

		event:set_data(entries)
		self._manager:register_event(event)
	end
end

TelemetryEvents.used_items_report = function (self, reports)
	for player, report in pairs(reports) do
		local entries = report.entries
		local player_data = report.player_data
		local event = TelemetryEvent:new(SOURCE, player_data.telemetry_subject, "used_items_report", {
			game = player_data.telemetry_game_session,
			gameplay = self._session.gameplay,
		})

		event:set_data(entries)
		self._manager:register_event(event)
	end
end

TelemetryEvents.voice_over_bank_reshuffled_report = function (self, report)
	local event = self:_create_event("voice_over_bank_reshuffled_report")

	event:set_data(report)
	self._manager:register_event(event)
end

TelemetryEvents.voice_over_event_triggered_report = function (self, report)
	local event = self:_create_event("voice_over_event_triggered_report")

	event:set_data(report)
	self._manager:register_event(event)
end

TelemetryEvents.memory_usage_evolution = function (self, memory_usage_evolution)
	local event = self:_create_event("memory_usage_evolution")

	event:set_data(memory_usage_evolution)
	self._manager:register_event(event)
end

TelemetryEvents.perf_camera = function (self, map, camera, measurements)
	local event = self:_create_event("perf_camera")

	event:set_revision(1)
	event:set_data({
		map = map,
		camera_id = camera.id_string,
		camera_name = camera.name,
		go_to_camera_position_link = camera.go_to_camera_position_link,
		frame_time_main = measurements.frame_time_main,
		batchcount = measurements.batchcount,
		primitives_count = measurements.primitives_count,
	})
	self._manager:register_event(event)
end

TelemetryEvents.perf_cutscene = function (self, map, cutscene, measurements)
	local event = self:_create_event("perf_cutscene")

	event:set_revision(1)
	event:set_data({
		map = map,
		cutscene = cutscene,
		frame_time_main = measurements.frame_time_main,
		batchcount = measurements.batchcount,
		primitives_count = measurements.primitives_count,
	})
	self._manager:register_event(event)
end

TelemetryEvents.perf_enemies = function (self, map, measurements)
	local event = self:_create_event("perf_enemies")

	event:set_revision(1)
	event:set_data({
		map = map,
		frame_time_main = measurements.frame_time_main,
		frame_time_render = measurements.frame_time_render,
		frame_time_gpu = measurements.frame_time_gpu,
	})
	self._manager:register_event(event)
end

TelemetryEvents.perf_memory = function (self, map, index, memory_usage)
	local event = self:_create_event("perf_memory")

	event:set_revision(1)
	event:set_data({
		map = map,
		index = index,
		memory_usage = memory_usage,
	})
	self._manager:register_event(event)
end

TelemetryEvents.perf_memory_tree = function (self, map, memory_tree)
	local event = self:_create_event("perf_memory_tree")

	event:set_data({
		map = map,
		memory_tree = memory_tree,
	})
	self._manager:register_event(event)
end

TelemetryEvents.update_news_widget = function (self, index, identifier)
	local event = self:_create_event("update_news_widget")

	event:set_data({
		index = index,
		identifier = identifier,
	})
	self._manager:register_event(event)
end

TelemetryEvents.open_view = function (self, view_name, hub_interaction, optional_identifier)
	if table.array_contains(BLACKLISTED_VIEWS, view_name) then
		return
	end

	local event = self:_create_event("open_view")
	local active_views = Managers.ui:active_views()

	event:set_data({
		name = view_name,
		active_views = active_views,
		hub_interaction = hub_interaction,
		identifier = optional_identifier,
	})
	self._manager:register_event(event)
end

TelemetryEvents.close_view = function (self, view_name)
	if table.array_contains(BLACKLISTED_VIEWS, view_name) then
		return
	end

	local event = self:_create_event("close_view")
	local active_views = Managers.ui:active_views()

	event:set_data({
		name = view_name,
		active_views = active_views,
	})
	self._manager:register_event(event)
end

TelemetryEvents.end_cutscene = function (self, cinematics_name, cinematic_scene_name, percent_viewed, character_level)
	local event = self:_create_event("cutscene_ended")

	event:set_data({
		cinematics_name = cinematics_name,
		cinematic_scene_name = cinematic_scene_name,
		percent_viewed = percent_viewed,
		character_level = character_level,
	})
	self._manager:register_event(event)
end

TelemetryEvents.performance_load_times = function (self, map, wait_for_network_time, resource_load_time, mission_intro_time, wait_for_spawn_time, read_from_disk_time)
	local event = self:_create_event("performance_load_times")

	event:set_data({
		map = map,
		wait_for_network_time = wait_for_network_time,
		resource_load_time = resource_load_time,
		mission_intro_time = mission_intro_time,
		wait_for_spawn_time = wait_for_spawn_time,
		read_from_disk_time = read_from_disk_time,
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
		total_bytes = lua_trace_stats.total_bytes,
	})
	self._manager:register_event(event)
end

TelemetryEvents.performance_frame_time = function (self, avg, std_dev, p99_9, p99, p95, p90, p75, p50, p25, observations, map_name)
	local event = self:_create_event("performance_frame_time")

	event:set_data({
		avg = avg,
		std_dev = std_dev,
		p99_9 = p99_9,
		p99 = p99,
		p95 = p95,
		p90 = p90,
		p75 = p75,
		p50 = p50,
		p25 = p25,
		observations = observations,
		map_name = map_name,
	})
	self._manager:register_event(event)
end

TelemetryEvents.performance_ping = function (self, avg, std_dev, p99_9, p99, p95, p90, p75, p50, p25, observations, region, map_name)
	local event = self:_create_event("performance_ping")

	event:set_data({
		avg = avg,
		std_dev = std_dev,
		p99_9 = p99_9,
		p99 = p99,
		p95 = p95,
		p90 = p90,
		p75 = p75,
		p50 = p50,
		p25 = p25,
		observations = observations,
		region = region,
		map_name = map_name,
	})
	self._manager:register_event(event)
end

TelemetryEvents.character_creation_time = function (self, character_id, time)
	self._subject.character_id = character_id

	local event = TelemetryEvent:new(SOURCE, {
		account_id = self._subject.account_id,
		character_id = character_id,
	}, "character_creation_time", self._session)

	event:set_data({
		time = time,
	})
	self._manager:register_event(event)
end

TelemetryEvents.record_slow_response_time = function (self, path, response_time)
	local event = self:_create_event("slow_backend_response")

	event:set_data({
		response_time = response_time,
		path = path,
	})
	self._manager:register_event(event)
end

TelemetryEvents.pacing = function (self, tension, travel_progress)
	local event = self:_create_event("pacing")

	event:set_data({
		tension = tension,
		travel_progress = travel_progress,
	})
	self._manager:register_event(event)
end

TelemetryEvents.enemies_spawned_report = function (self, report)
	local event = self:_create_event("enemies_spawned_report")

	event:set_data(report)
	self._manager:register_event(event)
end

TelemetryEvents.tactical_overlay_report = function (self, report)
	local event = self:_create_event("tactical_overlay_report")

	event:set_data(report)
	self._manager:register_event(event)
end

TelemetryEvents.penances_tracked_report = function (self, report)
	local event = self:_create_event("penances_tracked_report")

	event:set_data(report)
	self._manager:register_event(event)
end

TelemetryEvents.penance_claimed_report = function (self, report)
	local event = self:_create_event("penance_claimed_report")

	event:set_data(report)
	self._manager:register_event(event)
end

TelemetryEvents.track_claimed_report = function (self, report)
	local event = self:_create_event("track_claimed_report")

	event:set_data(report)
	self._manager:register_event(event)
end

TelemetryEvents.com_wheel_report = function (self, report)
	local event = self:_create_event("com_wheel_report")

	event:set_data(report)
	self._manager:register_event(event)
end

TelemetryEvents.smart_tag_report = function (self, reports)
	for player, report in pairs(reports) do
		local entries = report.entries
		local player_data = report.player_data
		local event = TelemetryEvent:new(SOURCE, player_data.telemetry_subject, "smart_tag_report", {
			game = player_data.telemetry_game_session,
			gameplay = self._session.gameplay,
		})

		event:set_data(entries)
		self._manager:register_event(event)
	end
end

TelemetryEvents.vote_completed = function (self, name, result, votes, params)
	local event = self:_create_event("vote_completed")
	local kick_peer_id = params.kick_peer_id
	local players_at_peer = kick_peer_id and Managers.player:players_at_peer(kick_peer_id)
	local kicked_accounts

	if kick_peer_id and players_at_peer then
		kicked_accounts = {}

		for _, player in pairs(players_at_peer) do
			kicked_accounts[#kicked_accounts + 1] = player:account_id()
		end
	end

	event:set_data({
		name = name,
		result = result,
		votes = votes,
		kicked_accounts = kicked_accounts,
	})
	self._manager:register_event(event)
end

TelemetryEvents.training_grounds_completed = function (self, start_type, finish_type, user_quit, is_onboarding, duration, finish_scenario, num_scenarios_started)
	local event = self:_create_event("training_grounds_completed")

	event:set_data({
		start_type = start_type,
		finish_type = finish_type,
		finish_scenario = finish_scenario,
		num_scenarios_started = num_scenarios_started,
		user_quit = user_quit,
		is_onboarding = is_onboarding,
		duration = duration,
	})
	self._manager:register_event(event)
end

TelemetryEvents.chat_message_sent = function (self, message_body)
	local event = self:_create_event("chat_message_sent")

	event:set_data({
		message_length = message_body:len(),
	})
	self._manager:register_event(event)
end

TelemetryEvents.breed_info = function (self, breed_info)
	local event = self:_create_event("breed_info")

	event:set_data(breed_info)
	self._manager:register_event(event)
end

TelemetryEvents.hard_mode_activated = function (self)
	local event = self:_create_event("hard_mode_activated")

	self._manager:register_event(event)
end

TelemetryEvents.destructible_destroyed = function (self, plasteel_collected, position, id, section_id)
	local event = self:_create_event("destructible_destroyed")
	local data = {
		plasteel_collected = plasteel_collected,
		id = id,
		section_id = section_id,
	}

	data.position = position

	event:set_data(data)
	self._manager:register_event(event)
end

TelemetryEvents.collectible_collected = function (self, plasteel_collected)
	local event = self:_create_event("collectible_collected")

	event:set_data({
		plasteel_collected = plasteel_collected,
	})
	self._manager:register_event(event)
end

TelemetryEvents.hordes_player_choice_completed = function (self, is_family_choice, options, choice_index, is_random_timeout_choice)
	local event = self:_create_event("hordes_player_choice_completed")
	local chosen_buff_name = options[choice_index]
	local data = {
		is_random_timeout_choice = is_random_timeout_choice,
		is_family_choice = is_family_choice,
		chosen_buff_name = chosen_buff_name,
	}

	for i, option in ipairs(options) do
		local key = "option_" .. i

		data[key] = option
	end

	event:set_data(data)
	self._manager:register_event(event)
end

TelemetryEvents.player_hordes_mode_ended = function (self, player, game_won, time, current_island, waves_completed)
	local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "player_hordes_mode_ended", {
		game = player:telemetry_game_session(),
		gameplay = self._session.gameplay,
	})
	local data = {
		game_won = game_won,
		time = time,
		waves_completed = waves_completed,
		island = current_island,
	}

	event:set_data(data)
	self._manager:register_event(event)
end

TelemetryEvents.fixed_update_missed_inputs_report = function (self, reports)
	for player, report in pairs(reports) do
		local entries = report.entries
		local player_data = report.player_data
		local event = TelemetryEvent:new(SOURCE, player_data.telemetry_subject, "fixed_update_missed_inputs_report", {
			game = player_data.telemetry_game_session,
			gameplay = self._session.gameplay,
		})

		event:set_data({
			missed_inputs = entries,
		})
		self._manager:register_event(event)
	end
end

TelemetryEvents.xbox_privileges = function (self, privileges)
	local event = self:_create_event("xbox_privileges")

	event:set_data(privileges)
	self._manager:register_event(event)
end

TelemetryEvents.game_suspended = function (self)
	local event = self:_create_event("game_suspended")

	event:set_data({
		time_in_game = Application.time_since_launch(),
	})
	self._manager:register_event(event)
end

TelemetryEvents.game_resumed = function (self)
	local event = self:_create_event("game_resumed")

	self._manager:register_event(event)
end

TelemetryEvents.player_kicked = function (self, peer_id, reason, option_details)
	if reason == "session_completed" then
		return
	end

	local players = Managers.player:players_at_peer(peer_id)

	for _, player in pairs(players) do
		local event = TelemetryEvent:new(SOURCE, player:telemetry_subject(), "player_kicked", {
			game = player:telemetry_game_session(),
			gameplay = self._session.gameplay,
		})

		event:set_data({
			reason = reason,
			details = option_details,
		})
		self._manager:register_event(event)
	end
end

TelemetryEvents.post_batch = function (self, batch_size, time_since_last_post, event_types, is_shutdown)
	local event = self:_create_event("post_batch")

	event:set_data({
		batch_size = batch_size,
		time_since_last_post = time_since_last_post,
		event_types = event_types,
		is_shutdown = is_shutdown,
	})
	self._manager:register_event(event)
end

TelemetryEvents.crashify_properties = function (self)
	local crashify_properties = Application.get_crash_properties()
	local event = self:_create_event("crashify_properties")

	event:set_data(crashify_properties)
	self._manager:register_event(event)
end

TelemetryEvents.memory_usage = function (self, tag)
	local missions_started = Managers.state.mission:num_missions_started()
	local mission_id = Managers.state.mission:mission_name()
	local usage = Memory.usage("B")

	for key, value in pairs(usage) do
		usage[key] = string.format("%d", value)
	end

	local event = self:_create_event("memory_usage")

	event:set_data({
		tag = tag,
		mission_id = mission_id,
		missions_started = missions_started,
		usage = usage,
	})
	self._manager:register_event(event)
end

return TelemetryEvents
