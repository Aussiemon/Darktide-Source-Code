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
local ConnectionManager = require("scripts/managers/multiplayer/connection_manager")
local ContractsManager = require("scripts/managers/contracts/contracts_manager")
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
local LoadingManager = require("scripts/managers/loading/loading_manager")
local MechanismManager = require("scripts/managers/mechanism/mechanism_manager")
local MultiplayerSessionManager = require("scripts/managers/multiplayer/multiplayer_session_manager")
local NarrativeManager = require("scripts/managers/narrative/narrative_manager")
local NetworkEventDelegate = require("scripts/managers/multiplayer/network_event_delegate")
local PackageSynchronizationManager = require("scripts/managers/loading/package_synchronization_manager")
local PartyImmateriumManager = require("scripts/managers/party_immaterium/party_immaterium_manager")
local PartyManagerDummy = require("scripts/managers/party/party_manager_dummy")
local PlayerManager = require("scripts/foundation/managers/player/player_manager")
local PresenceManager = require("scripts/managers/presence/presence_manager")
local PresenceManagerDummy = require("scripts/managers/presence/presence_manager_dummy")
local ProfileSynchronizationManager = require("scripts/managers/loading/profile_synchronization_manager")
local ProgressionManager = require("scripts/managers/progression/progression_manager")
local Promise = require("scripts/foundation/utilities/promise")
local SaveManager = require("scripts/managers/save/save_manager")
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
local UIManager = require("scripts/managers/ui/ui_manager")
local UrlLoaderManager = require("scripts/managers/url_loader/url_loader_manager")
local VivoxManager = require("scripts/managers/vivox/vivox_manager")
local VOSourcesCache = require("scripts/extension_systems/dialogue/vo_sources_cache")
local VotingManager = require("scripts/managers/voting/voting_manager")
local WorldManager = require("scripts/foundation/managers/world/world_manager")
local WwiseGameSyncManager = require("scripts/managers/wwise_game_sync/wwise_game_sync_manager")
local XAsyncManager = require("scripts/managers/xasync/xasync_manager")
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
		vo_sources_cache = self._vo_sources_cache
	}

	self:_init_managers(params.package_manager, params.localization_manager, event_delegate, approve_channel_delegate)

	if not IS_XBS then
		Managers.save:load()
	end

	local start_params = {}
	local start_state = nil
	start_state = StateSplash
	start_params.is_booting = true
	self._sm = GameStateMachine:new(self, start_state, start_params, creation_context)

	if Managers.ui then
		self._sm:register_on_state_change_callback("UIManager", callback(Managers.ui, "cb_on_game_state_change"))
	end

	if not DEDICATED_SERVER then
		Managers.wwise_game_sync:set_game_state_machine(self._sm)
	end
end

local function _connection_options(is_dedicated_hub_server, is_dedicated_mission_server)
	local options = nil

	if GameParameters.network_wan or GameParameters.prod_like_backend then
		if DEDICATED_SERVER then
			options = {
				project_hash = "bishop",
				network_platform = "wan_server",
				wan_port = GameParameters.wan_server_port,
				argument_hash = DevParameters.network_hash
			}
		else
			options = {
				project_hash = "bishop",
				network_platform = "wan_client",
				argument_hash = DevParameters.network_hash
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

	if not DEDICATED_SERVER then
		Managers.chat = VivoxManager:new()
		Managers.url_loader = UrlLoaderManager:new()
	end

	Managers.token = TokenManager:new()
	Managers.save = SaveManager:new(GameParameters.save_file_name, GameParameters.cloud_save_enabled)
	Managers.input = InputManager:new()
	local version_id = PLATFORM .. "#" .. (APPLICATION_SETTINGS.content_revision or LOCAL_CONTENT_REVISION or "")
	local language = Managers.localization:language()
	Managers.backend = BackendManager:new(function ()
		return {
			["request-id"] = math.uuid(),
			["platform-name"] = version_id,
			["accept-language"] = language
		}
	end)
	Managers.steam = SteamManager:new()
	Managers.grpc = GRPCManager:new()
	local disable_ui = DEDICATED_SERVER

	if not disable_ui then
		Managers.ui = UIManager:new()
	end

	Managers.input:init_all_devices()

	local is_dedicated_hub_server = false
	local is_dedicated_mission_server = false
	local mechanism_name = nil

	if is_dedicated_mission_server then
		mechanism_name = "idle"
	elseif LEVEL_EDITOR_TEST then
		mechanism_name = "sandbox"
	end

	Managers.mechanism = MechanismManager:new(event_delegate, mechanism_name, {
		mission_name = GameParameters.mission
	})
	Managers.connection = ConnectionManager:new(_connection_options(is_dedicated_hub_server, is_dedicated_mission_server), event_delegate, approve_channel_delegate)
	Managers.multiplayer_session = MultiplayerSessionManager:new()
	Managers.loading = LoadingManager:new()
	Managers.profile_synchronization = ProfileSynchronizationManager:new()
	Managers.package_synchronization = PackageSynchronizationManager:new()
	Managers.bot = BotManager:new()
	Managers.frame_rate = FrameRateManager:new()

	if not DEDICATED_SERVER then
		local connection_manager = Managers.connection
		local network_hash = connection_manager.combined_hash
		local platform = connection_manager.platform

		if GameParameters.prod_like_backend then
			Managers.presence = PresenceManager:new()
			Managers.data_service = DataServiceManager:new()
			Managers.party_immaterium = PartyImmateriumManager:new()
		else
			assert(false, "Production like backend must be enabled.")
		end
	else
		Managers.presence = PresenceManagerDummy:new()
		Managers.data_service = DataServiceManager:new()
	end

	Managers.stats = StatsManager:new(DEDICATED_SERVER)
	Managers.achievements = AchievementsManager:new(DEDICATED_SERVER, event_delegate)
	Managers.contracts = ContractsManager:new(DEDICATED_SERVER, event_delegate)
	Managers.voting = VotingManager:new(event_delegate)
	Managers.progression = ProgressionManager:new()

	if GameParameters.enable_EAC_feature then
		if DEDICATED_SERVER then
			Managers.eac_server = EACServerManager:new()
		elseif IS_WINDOWS then
			Managers.eac_client = EACClientManager:new()
		end
	end

	Managers.telemetry = TelemetryManager:new()
	Managers.telemetry_events = TelemetryEvents:new(Managers.telemetry, Managers.connection:network_event_delegate())
	Managers.telemetry_reporters = TelemetryReporters:new()
	Managers.account = AccountManager:new()

	if Application.xbox_live and Application.xbox_live() == true then
		Managers.xasync = XAsyncManager:new()
	end

	Managers.narrative = NarrativeManager:new()

	if not DEDICATED_SERVER then
		Managers.dlc = DLCManager:new()
	end
end

StateGame.on_exit = function (self)
	if not DEDICATED_SERVER then
		Managers.wwise_game_sync:set_game_state_machine(nil)
	end

	if Managers.ui then
		self._sm:unregister_on_state_change_callback("UIManager")
	end

	self._sm:delete()
	self._vo_sources_cache:destroy()
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
	Profiler.start("StateGame:update()")

	local network_is_active = Network.is_active()

	Profiler.start("update_resolution_lookup_update")
	UPDATE_RESOLUTION_LOOKUP()
	Profiler.stop("update_resolution_lookup_update")
	Profiler.start("time_manager_update")
	Managers.time:update(dt)
	Profiler.stop("time_manager_update")

	local t = Managers.time:time("main")

	Profiler.start("promise_manager_update")
	Promise.update(dt, t)
	Profiler.stop("promise_manager_update")
	Profiler.start("account_manager_update")
	Managers.account:update(dt, t)
	Profiler.stop("account_manager_update")
	Profiler.start("package_manager_update")
	Managers.package:update(dt, t)
	Profiler.stop("package_manager_update")
	Profiler.start("token_manager_update")
	Managers.token:update(dt, t)
	Profiler.stop("token_manager_update")
	Profiler.start("input_manager_update")
	Managers.input:update(dt, t)
	Profiler.stop("input_manager_update")
	Profiler.start("state_machine_update")
	self._sm:update(dt, t)
	Profiler.stop("state_machine_update")

	local ui_manager = Managers.ui

	if ui_manager then
		Profiler.start("ui_manager_update")
		ui_manager:update(dt, t)
		Profiler.stop("ui_manager_update")
	end

	if not DEDICATED_SERVER then
		Profiler.start("dlc_manager_update")
		Managers.dlc:update(dt, t)
		Profiler.stop("dlc_manager_update")
		Profiler.start("wwise_game_sync_update")
		Managers.wwise_game_sync:update(dt, t)
		Profiler.stop("wwise_game_sync_update")
	end

	Profiler.start("loading_manager_update")
	Managers.loading:update(dt)
	Profiler.stop("loading_manager_update")
	Profiler.start("profile_synchronization_manager_update")
	Managers.profile_synchronization:update(dt)
	Profiler.stop("profile_synchronization_manager_update")
	Profiler.start("package_synchronization_manager_update")
	Managers.package_synchronization:update(dt)
	Profiler.stop("package_synchronization_manager_update")
	Profiler.start("bot_manager_update")
	Managers.bot:update(dt)
	Profiler.stop("bot_manager_update")
	Profiler.start("world_manager_update")
	Managers.world:update(dt, t)
	Profiler.stop("world_manager_update")
	Profiler.start("steam_manager_update")
	Managers.steam:update()
	Profiler.stop("steam_manager_update")
	Profiler.start("backend_manager_update")
	Managers.backend:update(dt, t)
	Profiler.stop("backend_manager_update")

	if Managers.chat then
		Profiler.start("chat_manager_update")
		Managers.chat:update(dt, t)
		Profiler.stop("chat_manager_update")
	end

	if Managers.data_service.social then
		Profiler.start("social_manager_update")
		Managers.data_service.social:update(dt, t)
		Profiler.stop("social_manager_update")
	end

	Profiler.start("grpc_update")
	Managers.grpc:update(dt, t)
	Profiler.stop("grpc_update")
	Profiler.start("presence_update")
	Managers.presence:update(dt, t)
	Profiler.stop("presence_update")

	if Managers.party_immaterium then
		Profiler.start("party_immaterium_manager_update")
		Managers.party_immaterium:update(dt, t)
		Profiler.stop("party_immaterium_manager_update")
	end

	if Managers.hub_server then
		Profiler.start("hub_server_manager_update")
		Managers.hub_server:update(dt, t)
		Profiler.stop("hub_server_manager_update")
	end

	if Managers.mission_server then
		Profiler.start("mission_server_manager_update")
		Managers.mission_server:update(dt, t)
		Profiler.stop("mission_server_manager_update")
	end

	if Managers.boons then
		Profiler.start("boons_manager_update")
		Managers.boons:update(dt, t)
		Profiler.stop("boons_manager_update")
	end

	Profiler.start("progression_manager_update")
	Managers.progression:update(dt, t)
	Profiler.stop("progression_manager_update")
	Profiler.start("stats_manager_update")
	Managers.stats:update(dt, t)
	Profiler.stop("stats_manager_update")

	if Managers.eac_server then
		Profiler.start("eac_server_manager_update")
		Managers.eac_server:update(dt, t)
		Profiler.stop("eac_server_manager_update")
	end

	if Managers.eac_client then
		Profiler.start("eac_client_manager_update")
		Managers.eac_client:update(dt, t)
		Profiler.stop("eac_client_manager_update")
	end

	Profiler.start("voting_manager_update")
	Managers.voting:update(dt, t)
	Profiler.stop("voting_manager_update")

	if Managers.xasync then
		Profiler.start("xasync_update")
		Managers.xasync:update(dt)
		Profiler.stop("xasync_update")
	end

	if GameParameters.testify then
		Profiler.start("testify_update")
		Testify:update(dt, t)
		Profiler.stop("testify_update")
		Testify:poll_requests_through_handler(StateGameTestify, self)
	end

	Profiler.start("telemetry_update")
	Managers.telemetry:update(dt, t)
	Managers.telemetry_reporters:update(dt, t)
	Profiler.stop("telemetry_update")
	Profiler.start("server_metrics_update")
	Managers.server_metrics:update(dt, t)
	Profiler.stop("server_metrics_update")
	Profiler.start("state_machine_post_update")
	self._sm:post_update(dt, t)
	Profiler.stop("state_machine_post_update")
	Profiler.start("bot_manager_post_update")
	Managers.bot:post_update(dt, t)
	Profiler.stop("bot_manager_post_update")
	Profiler.start("multiplayer_session_manager_post_update")
	Managers.multiplayer_session:post_update()
	Profiler.stop("multiplayer_session_manager_post_update")

	if ui_manager then
		Profiler.start("ui_manager_post_update")
		ui_manager:post_update(dt, t)
		Profiler.stop("ui_manager_post_update")
	end

	FlowCallbacks.clear_return_value()
	Profiler.stop("StateGame:update()")
end

local time_name = "main"

StateGame.render = function (self)
	Profiler.start("StateGame:render()")
	Profiler.start("state_machine_render")
	self._sm:render()
	Profiler.stop("state_machine_render")

	local t = Managers.time:time(time_name)
	local dt = Managers.time:delta_time(time_name)
	local ui_manager = Managers.ui

	if ui_manager then
		Profiler.start("ui_manager_draw")
		ui_manager:render(dt, t)
		Profiler.stop("ui_manager_draw")
	end

	Profiler.start("world_render")
	Managers.world:render()
	Profiler.stop("world_render")
	Profiler.start("state_machine_post_render")
	self._sm:post_render()
	Profiler.stop("state_machine_post_render")
	Profiler.start("frame_table_swap_buffers")
	Managers.frame_table:swap_buffers()
	Profiler.stop("frame_table_swap_buffers")
	Profiler.stop("StateGame:render()")
end

StateGame.current_state_name = function (self)
	return self._sm:current_state_name()
end

return StateGame
