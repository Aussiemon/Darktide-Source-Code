local AttackReportManager = require("scripts/managers/attack_report/attack_report_manager")
local BloodManager = require("scripts/managers/blood/blood_manager")
local BotNavTransitionManager = require("scripts/managers/bot_nav_transition/bot_nav_transition_manager")
local CameraManager = require("scripts/managers/camera/camera_manager")
local ChunkLodManager = require("scripts/managers/chunk_lod/chunk_lod_manager")
local CinematicManager = require("scripts/managers/cinematic/cinematic_manager")
local CircumstanceManager = require("scripts/managers/circumstance/circumstance_manager")
local DecalManager = require("scripts/managers/decal/decal_manager")
local DifficultyManager = require("scripts/managers/difficulty/difficulty_manager")
local EmoteManager = require("scripts/managers/emote/emote_manager")
local GameplayInitStepInterface = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_state_interface")
local GameplayInitStepExtensionUnits = require("scripts/game_states/game/gameplay_sub_states/gameplay_init_step_states/gameplay_init_step_extension_units")
local HordeManager = require("scripts/managers/horde/horde_manager")
local MinionDeathManager = require("scripts/managers/minion/minion_death_manager")
local MinionSpawnManager = require("scripts/managers/minion/minion_spawn_manager")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local MutatorManager = require("scripts/managers/mutator/mutator_manager")
local NetworkedFlowStateManager = require("scripts/managers/networked_flow_state/networked_flow_state_manager")
local NetworkStoryManager = require("scripts/managers/network_story/network_story_manager")
local PacingManager = require("scripts/managers/pacing/pacing_manager")
local PlayerOverlapManager = require("scripts/managers/player/player_overlap_manager")
local PlayerUnitSpawnManager = require("scripts/managers/player/player_unit_spawn_manager")
local RoomsAndPortalsManager = require("scripts/managers/wwise/rooms_and_portals_manager")
local TerrorEventManager = require("scripts/managers/terror_event/terror_event_manager")
local UnitJobManager = require("scripts/managers/unit_job/unit_job_manager")
local UnitSpawnerManager = require("scripts/foundation/managers/unit_spawner/unit_spawner_manager")
local VoiceOverSpawnManager = require("scripts/managers/voice_over/voice_over_spawn_manager")
local VideoManager = require("scripts/managers/video/video_manager")
local WorldInteractionManager = require("scripts/managers/world_interaction/world_interaction_manager")
local GameplayInitStepManagers = class("GameplayInitStepManagers")

GameplayInitStepManagers.on_enter = function (self, parent, params)
	local shared_state = params.shared_state
	self._shared_state = shared_state
	local world = shared_state.world
	local level_name = shared_state.level_name
	local is_server = shared_state.is_server
	local physics_world = shared_state.physics_world
	local level = shared_state.level
	local level_seed = shared_state.level_seed
	local mission_name = shared_state.mission_name
	local challenge = shared_state.challenge
	local resistance = shared_state.resistance
	local circumstance_name = shared_state.circumstance_name
	local side_mission = shared_state.side_mission
	local vo_sources_cache = shared_state.vo_sources_cache
	local fixed_time_step = shared_state.fixed_time_step
	local mission_giver_vo = shared_state.mission_giver_vo
	local nav_world = shared_state.nav_world
	local has_navmesh = not table.is_empty(shared_state.nav_data)
	local pacing_control = shared_state.pacing_control

	self:_init_state_managers(world, physics_world, nav_world, has_navmesh, level, level_name, level_seed, is_server, mission_name, mission_giver_vo, challenge, resistance, circumstance_name, side_mission, shared_state.soft_cap_out_of_bounds_units, vo_sources_cache, pacing_control, fixed_time_step, time_query_handle)
end

GameplayInitStepManagers.update = function (self, main_dt, main_t)
	local next_step_params = {
		shared_state = self._shared_state
	}

	return GameplayInitStepExtensionUnits, next_step_params
end

GameplayInitStepManagers._init_state_managers = function (self, world, physics_world, nav_world, has_navmesh, level, level_name, level_seed, is_server, mission_name, mission_giver_vo, challenge, resistance, circumstance_name, side_mission, soft_cap_out_of_bounds_units, vo_sources_cache, pacing_control, fixed_time_step, time_query_handle)
	local connection_manager = Managers.connection
	local network_event_delegate = connection_manager:network_event_delegate()

	self:_init_unit_spawner(world, is_server, level_name, network_event_delegate)

	Managers.state.camera = CameraManager:new(world)
	local mission_manager = Managers.state.mission
	local mission = mission_manager:mission()
	local player_manager = Managers.player
	local local_player = player_manager:local_player(1)
	Managers.state.chunk_lod = ChunkLodManager:new(world, mission, local_player)
	Managers.state.network_story = NetworkStoryManager:new(world, is_server, network_event_delegate)
	Managers.state.networked_flow_state = NetworkedFlowStateManager:new(world, is_server, network_event_delegate)
	Managers.state.difficulty = DifficultyManager:new(is_server, resistance, challenge)
	local mission_template = MissionTemplates[mission_name]
	local game_mode_name = mission_template.game_mode_name
	Managers.state.player_unit_spawn = PlayerUnitSpawnManager:new(is_server, level_seed, has_navmesh, game_mode_name, network_event_delegate, soft_cap_out_of_bounds_units)
	Managers.state.player_overlap_manager = PlayerOverlapManager:new(physics_world)
	Managers.state.decal = DecalManager:new(world)

	if is_server then
		Managers.state.bot_nav_transition = BotNavTransitionManager:new(world, physics_world, nav_world, is_server)
		Managers.state.minion_spawn = MinionSpawnManager:new(level_seed, soft_cap_out_of_bounds_units, network_event_delegate)
		Managers.state.voice_over_spawn = VoiceOverSpawnManager:new(is_server, mission_giver_vo)
		Managers.state.horde = HordeManager:new(nav_world, physics_world)
		Managers.state.pacing = PacingManager:new(world, nav_world, level_name, level_seed, pacing_control)
	end

	Managers.player:set_network(is_server, network_event_delegate)

	Managers.state.minion_death = MinionDeathManager:new(is_server, network_event_delegate, soft_cap_out_of_bounds_units)
	Managers.state.terror_event = TerrorEventManager:new(world, is_server, network_event_delegate, mission_template, level_name)
	Managers.state.cinematic = CinematicManager:new(world, is_server, network_event_delegate)
	Managers.state.video = VideoManager:new()
	Managers.state.blood = BloodManager:new(world, is_server, network_event_delegate)
	Managers.state.attack_report = AttackReportManager:new(is_server, network_event_delegate)
	Managers.state.rooms_and_portals = RoomsAndPortalsManager:new(world)
	Managers.state.circumstance = CircumstanceManager:new(circumstance_name)
	Managers.state.mutator = MutatorManager:new(is_server, nav_world, network_event_delegate, circumstance_name, level_seed)
	Managers.state.world_interaction = WorldInteractionManager:new(world)
	Managers.state.emote = EmoteManager:new(is_server, network_event_delegate)
end

GameplayInitStepManagers._init_unit_spawner = function (self, world, is_server, level_name, network_event_delegate)
	local game_session_manager = Managers.state.game_session
	local game_session = game_session_manager:game_session()
	local extension_manager = Managers.state.extension
	local UnitTemplates = require("scripts/extension_systems/unit_templates")
	local unit_spawner_manager = UnitSpawnerManager:new(world, extension_manager, is_server, UnitTemplates, game_session, level_name, network_event_delegate)
	Managers.state.unit_job = UnitJobManager:new(unit_spawner_manager)
	Managers.state.unit_spawner = unit_spawner_manager
end

implements(GameplayInitStepManagers, GameplayInitStepInterface)

return GameplayInitStepManagers
