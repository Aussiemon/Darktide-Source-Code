-- chunkname: @scripts/game_states/state_game.lua

require("core/volumetrics/lua/volumetrics_flow_callbacks")
require("core/wwise/lua/wwise_flow_callbacks")
require("scripts/global_tables")
require("scripts/script_flow_nodes/flow_callbacks")
require("scripts/script_flow_nodes/ui_flow_callbacks")

local AccountManager = require("scripts/managers/account/account_manager")
local AchievementsManager = require("scripts/managers/achievements/achievements_manager")
local ApproveChannelDelegate = require("scripts/managers/multiplayer/approve_channel_delegate")
local BackendManager = require("scripts/foundation/managers/backend/backend_manager")
local BotManager = require("scripts/managers/bot/bot_manager")
local ChatManager = require("scripts/managers/chat/chat_manager")
local ConnectionManager = require("scripts/managers/multiplayer/connection_manager")
local DataServiceManager = require("scripts/managers/data_service/data_service_manager")
local DLCManager = require("scripts/managers/dlc/dlc_manager")
local EACClientManager = require("scripts/managers/eac/eac_client_manager")
local EACServerManager = require("scripts/managers/eac/eac_server_manager")
local ErrorManager = require("scripts/managers/error/error_manager")
local EventManager = require("scripts/managers/event/event_manager")
local FrameRateManager = require("scripts/managers/frame_rate/frame_rate_manager")
local FrameTableManager = require("scripts/foundation/managers/frame_table/frame_table_manager")
local FreeFlightManager = require("scripts/foundation/managers/free_flight/free_flight_manager")
local GameStateMachine = require("scripts/foundation/utilities/game_state_machine")
local GRPCManager = require("scripts/managers/grpc/grpc_manager")
local InputManager = require("scripts/managers/input/input_manager")
local LiveEventManager = require("scripts/managers/live_event/live_event_manager")
local LoadingManager = require("scripts/managers/loading/loading_manager")
local MechanismManager = require("scripts/managers/mechanism/mechanism_manager")
local MultiplayerSessionManager = require("scripts/managers/multiplayer/multiplayer_session_manager")
local NarrativeManager = require("scripts/managers/narrative/narrative_manager")
local NetworkEventDelegate = require("scripts/managers/multiplayer/network_event_delegate")
local PackageSynchronizationManager = require("scripts/managers/loading/package_synchronization_manager")
local PartyImmateriumManager = require("scripts/managers/party_immaterium/party_immaterium_manager")
local PartyManagerDummy = require("scripts/managers/party/party_manager_dummy")
local PingManager = require("scripts/managers/ping/ping_manager")
local PlayerManager = require("scripts/foundation/managers/player/player_manager")
local PresenceManager = require("scripts/managers/presence/presence_manager")
local PresenceManagerDummy = require("scripts/managers/presence/presence_manager_dummy")
local ProfileSynchronizationManager = require("scripts/managers/loading/profile_synchronization_manager")
local ProgressionManager = require("scripts/managers/progression/progression_manager")
local Promise = require("scripts/foundation/utilities/promise")
local PS5UDSManager = require("scripts/managers/ps5_uds/ps5_uds_manager")
local SaveManager

if IS_PLAYSTATION then
	SaveManager = require("scripts/managers/save/save_manager_ps5")
else
	SaveManager = require("scripts/managers/save/save_manager")
end

local ServerMetricsManager = require("scripts/managers/server_metrics/server_metrics_manager")
local ServerMetricsManagerDummy = require("scripts/managers/server_metrics/server_metrics_manager_dummy")
local StateGameTestify = GameParameters.testify and require("scripts/game_states/state_game_testify")
local StateSplash = require("scripts/game_states/game/state_splash")
local StatsManager = require("scripts/managers/stats/stats_manager")
local SteamManager = require("scripts/managers/steam/steam_manager")
local TelemetryEvents = require("scripts/managers/telemetry/telemetry_events")
local TelemetryManager = require("scripts/managers/telemetry/telemetry_manager")
local TelemetryReporters = require("scripts/managers/telemetry/telemetry_reporters")
local TimeManager = require("scripts/foundation/managers/time/time_manager")
local TokenManager = require("scripts/foundation/managers/token/token_manager")
local TransitionManager = require("scripts/managers/transition/transition_manager")
local UIFontManager = require("scripts/managers/ui/ui_font_manager")
local UIManager = require("scripts/managers/ui/ui_manager")
local UrlLoaderManager = require("scripts/managers/url_loader/url_loader_manager")
local VOSourcesCache = require("scripts/extension_systems/dialogue/vo_sources_cache")
local VotingManager = require("scripts/managers/voting/voting_manager")
local WorldLevelDespawnManager = require("scripts/managers/world_level_despawn/world_level_despawn_manager")
local WorldManager = require("scripts/foundation/managers/world/world_manager")
local WwiseGameSyncManager = require("scripts/managers/wwise_game_sync/wwise_game_sync_manager")
local XAsyncManager = require("scripts/managers/xasync/xasync_manager")
local DefaultInputSettings = {}

table.insert(DefaultInputSettings, require("scripts/settings/input/default_debug_input_settings"))
table.insert(DefaultInputSettings, require("scripts/settings/input/default_free_flight_input_settings"))
table.insert(DefaultInputSettings, require("scripts/settings/input/default_ingame_input_settings"))
table.insert(DefaultInputSettings, require("scripts/settings/input/default_imgui_input_settings"))
table.insert(DefaultInputSettings, require("scripts/settings/input/default_view_input_settings"))

local StateGame = class("StateGame")

StateGame.on_enter = function (self, parent, params)
	local event_delegate = NetworkEventDelegate:new()

	self._event_delegate = event_delegate

	local approve_channel_delegate = ApproveChannelDelegate:new()

	self._approve_channel_delegate = approve_channel_delegate
	self._vo_sources_cache = VOSourcesCache:new()

	local creation_context = {
		network_receive_function = function (dt)
			Network.update_receive(dt, self._event_delegate.event_table)
			Managers.connection:update(dt)
			Managers.multiplayer_session:update(dt)
		end,
		network_transmit_function = function (dt)
			Network.update_transmit()
		end,
		vo_sources_cache = self._vo_sources_cache,
	}

	self:_init_managers(params.package_manager, params.localization_manager, event_delegate, approve_channel_delegate)

	if GameParameters.testify and not DEDICATED_SERVER then
		Managers.telemetry_events:system_settings()
	end

	if not IS_XBS and not IS_PLAYSTATION then
		Managers.save:load()
	end

	local start_params = {}
	local start_state

	start_state = StateSplash
	start_params.is_booting = true

	local state_change_callbacks = {}

	if not DEDICATED_SERVER then
		state_change_callbacks.PresenceManager = callback(Managers.presence, "cb_on_game_state_change")
	end

	self._sm = GameStateMachine:new(self, start_state, start_params, creation_context, state_change_callbacks, "Main", "Game", true)

	if Managers.ui then
		self._sm:register_on_state_change_callback("UIManager", callback(Managers.ui, "cb_on_game_state_change"))
	end

	if not DEDICATED_SERVER then
		Managers.wwise_game_sync:set_game_state_machine(self._sm)
	end

	local app_type = "host"

	if Managers.connection:is_dedicated_mission_server() then
		app_type = "mission_server"
	elseif Managers.connection:is_dedicated_hub_server() then
		app_type = "hub_server"
	elseif Managers.connection:is_client() then
		app_type = "client"
	end

	local program_name = string.format("darktide-%s-%s", app_type, tostring(APPLICATION_SETTINGS.content_revision))

	Profiler.set_program_name(program_name)
	Managers.event:register(self, "on_pre_suspend", "_on_pre_suspend")
end

local function _connection_options(is_dedicated_hub_server, is_dedicated_mission_server)
	local options

	if GameParameters.network_wan or GameParameters.prod_like_backend then
		if DEDICATED_SERVER then
			options = {
				network_platform = "wan_server",
				project_hash = "bishop",
				wan_port = GameParameters.wan_server_port,
				argument_hash = DevParameters.network_hash,
			}
		else
			options = {
				network_platform = "wan_client",
				project_hash = "bishop",
				argument_hash = DevParameters.network_hash,
			}
		end
	end

	options.is_dedicated_hub_server = is_dedicated_hub_server
	options.is_dedicated_mission_server = is_dedicated_mission_server

	return options
end

StateGame._init_managers = function (self, package_manager, localization_manager, event_delegate, approve_channel_delegate)
	Managers.error = ErrorManager:new()
	Managers.frame_table = FrameTableManager:new(GameParameters.debug_frame_tables, 64)
	Managers.package = package_manager
	Managers.time = TimeManager:new()
	Managers.world = WorldManager:new()
	Managers.player = PlayerManager:new()
	Managers.event = EventManager:new()
	Managers.localization = localization_manager
	Managers.transition = TransitionManager:new()

	if DEDICATED_SERVER then
		Managers.server_metrics = ServerMetricsManager:new()
	else
		Managers.server_metrics = ServerMetricsManagerDummy:new()
	end

	Managers.wwise_game_sync = WwiseGameSyncManager:new(Managers.world)
	Managers.token = TokenManager:new()
	Managers.save = SaveManager:new(GameParameters.save_file_name, GameParameters.cloud_save_enabled)
	Managers.input = InputManager:new()

	for _, default_setting in ipairs(DefaultInputSettings) do
		Managers.input:add_setting(default_setting.service_type, default_setting.aliases, default_setting.settings, default_setting.filters, default_setting.default_devices)
	end

	Managers.input:load_settings()

	if not DEDICATED_SERVER then
		Managers.chat = ChatManager:new()
		Managers.url_loader = UrlLoaderManager:new()
	end

	local version_id = PLATFORM .. "#" .. (APPLICATION_SETTINGS.content_revision or LOCAL_CONTENT_REVISION or "")
	local language = Managers.localization:language()

	Managers.backend = BackendManager:new(function ()
		return {
			["request-id"] = math.uuid(),
			["platform-name"] = version_id,
			["accept-language"] = language,
			["is-modded"] = GameParameters.is_modded_crashify_property or nil,
		}
	end)
	Managers.steam = SteamManager:new()
	Managers.grpc = GRPCManager:new()
	Managers.ping = PingManager:new()
	Managers.frame_rate = FrameRateManager:new()
	Managers.data_service = DataServiceManager:new()

	Managers.input:init_all_devices()

	local is_dedicated_hub_server = false
	local is_dedicated_mission_server = false
	local mechanism_name

	if is_dedicated_mission_server then
		mechanism_name = "idle"
	elseif LEVEL_EDITOR_TEST then
		mechanism_name = "sandbox"
	end

	Managers.mechanism = MechanismManager:new(event_delegate, mechanism_name, {
		mission_name = GameParameters.mission,
	})
	Managers.connection = ConnectionManager:new(_connection_options(is_dedicated_hub_server, is_dedicated_mission_server), event_delegate, approve_channel_delegate)
	Managers.multiplayer_session = MultiplayerSessionManager:new()
	Managers.world_level_despawn = WorldLevelDespawnManager:new()
	Managers.profile_synchronization = ProfileSynchronizationManager:new()
	Managers.package_synchronization = PackageSynchronizationManager:new()
	Managers.bot = BotManager:new()

	if not DEDICATED_SERVER then
		local connection_manager = Managers.connection
		local network_hash = connection_manager.combined_hash
		local platform = connection_manager.platform

		if GameParameters.prod_like_backend then
			Managers.presence = PresenceManager:new()
			Managers.party_immaterium = PartyImmateriumManager:new()
		end
	else
		Managers.presence = PresenceManagerDummy:new()
	end

	if IS_PLAYSTATION then
		Managers.ps5_uds = PS5UDSManager:new()
	end

	local is_stat_client = not DEDICATED_SERVER

	Managers.stats = StatsManager:new(is_stat_client, event_delegate)

	local use_batched_saving = is_dedicated_mission_server and GameParameters.save_achievements_in_batch
	local broadcast_unlocks = is_dedicated_mission_server

	Managers.achievements = AchievementsManager:new(not DEDICATED_SERVER, event_delegate, use_batched_saving, broadcast_unlocks)
	Managers.voting = VotingManager:new(event_delegate)
	Managers.progression = ProgressionManager:new()
	Managers.live_event = LiveEventManager:new(DEDICATED_SERVER)
	Managers.telemetry = TelemetryManager:new()
	Managers.telemetry_events = TelemetryEvents:new(Managers.telemetry, Managers.connection)
	Managers.telemetry_reporters = TelemetryReporters:new()
	Managers.account = AccountManager:new()

	if Application.xbox_live and Application.xbox_live() == true then
		Managers.xasync = XAsyncManager:new()
	end

	local disable_ui = DEDICATED_SERVER

	if not disable_ui then
		Managers.font = UIFontManager:new()
		Managers.ui = UIManager:new()
	end

	Managers.loading = LoadingManager:new()
	Managers.narrative = NarrativeManager:new()

	if not DEDICATED_SERVER then
		Managers.dlc = DLCManager:new()
	end
end

StateGame.on_exit = function (self, exit_params)
	if not DEDICATED_SERVER then
		Managers.wwise_game_sync:set_game_state_machine(nil)
	end

	if Managers.ui then
		self._sm:unregister_on_state_change_callback("UIManager")
	end

	if not DEDICATED_SERVER then
		self._sm:unregister_on_state_change_callback("PresenceManager")
	end

	self._sm:delete(exit_params)
	self._vo_sources_cache:destroy()
	Managers.event:unregister(self, "on_pre_suspend")
	Managers:destroy()
	self._approve_channel_delegate:delete()
	self._event_delegate:delete()

	if DEDICATED_SERVER then
		CommandWindow.close()
	end
end

StateGame.on_reload = function (self, refreshed_resources)
	Managers.backend:on_reload(refreshed_resources)
	Managers.input:on_reload(refreshed_resources)
	Managers.player:on_reload(refreshed_resources)
	self._sm:on_reload(refreshed_resources)
end

StateGame.update = function (self, dt)
	local network_is_active = Network.is_active()

	UPDATE_RESOLUTION_LOOKUP()
	Managers.time:update(dt)

	local t = Managers.time:time("main")

	Promise.update(dt, t)
	Managers.account:update(dt, t)
	Managers.package:update(dt, t)
	Managers.token:update(dt, t)
	Managers.input:update(dt, t)

	if IS_PLAYSTATION then
		Managers.save:update()
		Managers.ps5_uds:update(dt)
	end

	if GameParameters.testify then
		Testify:poll_requests_through_handler(StateGameTestify, self)
	end

	self._sm:update(dt, t)

	local ui_manager = Managers.ui

	if ui_manager then
		ui_manager:update(dt, t)
	end

	if not DEDICATED_SERVER then
		Managers.dlc:update(dt, t)
		Managers.wwise_game_sync:update(dt, t)
	end

	Managers.loading:update(dt)
	Managers.profile_synchronization:update(dt)
	Managers.package_synchronization:update(dt)
	Managers.bot:update(dt)
	Managers.world:update(dt, t)
	Managers.steam:update()
	Managers.backend:update(dt, t)

	if Managers.url_loader then
		Managers.url_loader:update(dt, t)
	end

	if Managers.chat then
		Managers.chat:update(dt, t)
	end

	if Managers.data_service.social then
		Managers.data_service.social:update(dt, t)
	end

	Managers.grpc:update(dt, t)
	Managers.ping:update(dt, t)
	Managers.presence:update(dt, t)

	if Managers.party_immaterium then
		Managers.party_immaterium:update(dt, t)
	end

	if Managers.hub_server then
		Managers.hub_server:update(dt, t)
	end

	if Managers.mission_server then
		Managers.mission_server:update(dt, t)
	end

	Managers.progression:update(dt, t)
	Managers.world_level_despawn:update(dt, t)
	Managers.stats:update(dt, t)
	Managers.achievements:update(dt, t)

	if Managers.eac_server then
		Managers.eac_server:update(dt, t)
	end

	if Managers.eac_client then
		Managers.eac_client:update(dt, t)
	end

	Managers.voting:update(dt, t)

	if Managers.xasync then
		Managers.xasync:update(dt)
	end

	if GameParameters.testify then
		Testify:update(dt, t)
	end

	Managers.live_event:update(dt, dt)
	Managers.telemetry_reporters:update(dt, t)
	Managers.telemetry:update(dt, t)
	Managers.server_metrics:update(dt, t)
	self._sm:post_update(dt, t)
	Managers.bot:post_update(dt, t)
	Managers.multiplayer_session:post_update()

	if ui_manager then
		ui_manager:post_update(dt, t)
	end

	FlowCallbacks.clear_return_value()
end

local time_name = "main"

StateGame.render = function (self)
	self._sm:render()

	local t = Managers.time:time(time_name)
	local dt = Managers.time:delta_time(time_name)
	local ui_manager = Managers.ui

	if ui_manager then
		ui_manager:render(dt, t)
	end

	Managers.world:render()
	self._sm:post_render()
	Managers.frame_table:swap_buffers()
end

StateGame.current_state_name = function (self)
	return self._sm:current_state_name()
end

StateGame.state_machine = function (self)
	return self._sm
end

StateGame._on_pre_suspend = function (self)
	local error_state = CLASSES.StateError
	local params = {}
	local exit_params = {
		on_suspend = true,
	}

	self._sm:force_change_state(error_state, params, exit_params)
end

return StateGame
