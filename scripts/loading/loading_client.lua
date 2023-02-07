local Loader = require("scripts/loading/loader")
local LocalCreateWorldState = require("scripts/loading/local_states/local_create_world_state")
local LocalDetermineLevelState = require("scripts/loading/local_states/local_determine_level_state")
local LocalDetermineSpawnGroupState = require("scripts/loading/local_states/local_determine_spawn_group_state")
local LocalIngameState = require("scripts/loading/local_states/local_ingame_state")
local LocalLevelState = require("scripts/loading/local_states/local_level_state")
local LocalLoadersState = require("scripts/loading/local_states/local_loaders_state")
local LocalLoadFailState = require("scripts/loading/local_states/local_load_fail_state")
local LocalResetState = require("scripts/loading/local_states/local_reset_state")
local LocalThemeState = require("scripts/loading/local_states/local_theme_state")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local StateMachine = require("scripts/foundation/utilities/state_machine")
local LocalWaitForMissionBriefingDoneState = require("scripts/loading/local_states/local_wait_for_mission_briefing_done_state")
local LoadingClient = class("LoadingClient")
LoadingClient.TIMEOUT = 30

LoadingClient.init = function (self, network_delegate, host_channel_id, loaders)
	self._network_delegate = network_delegate
	local shared_state = {
		state = "loading",
		network_delegate = network_delegate,
		host_channel_id = host_channel_id,
		timeout = LoadingClient.TIMEOUT,
		loaders = loaders,
		themes = {}
	}
	local parent = nil
	local state_machine = StateMachine:new("LoadingClient", parent, shared_state)

	state_machine:add_transition("LocalDetermineLevelState", "mission_determined", LocalLoadersState)
	state_machine:add_transition("LocalDetermineLevelState", "hub_determined", LocalLoadersState)
	state_machine:add_transition("LocalDetermineLevelState", "no_level_needed", LocalIngameState)
	state_machine:add_transition("LocalDetermineLevelState", "reset", StateMachine.IGNORE_EVENT)
	state_machine:add_transition("LocalDetermineSpawnGroupState", "spawn_group_set_mission", LocalIngameState)
	state_machine:add_transition("LocalDetermineSpawnGroupState", "spawn_group_set_hub", LocalIngameState)
	state_machine:add_transition("LocalDetermineSpawnGroupState", "no_level_needed", LocalIngameState)
	state_machine:add_transition("LocalDetermineSpawnGroupState", "reset", StateMachine.IGNORE_EVENT)
	state_machine:add_transition("LocalResetState", "reset", StateMachine.IGNORE_EVENT)
	state_machine:add_transition("LocalResetState", "no_level_needed", LocalIngameState)
	state_machine:add_transition("LocalResetState", "start_load", LocalLoadersState)
	state_machine:add_transition("LocalResetState", "disconnected", LocalLoadFailState)
	state_machine:add_transition("LocalLoadersState", "load_done", LocalCreateWorldState)
	state_machine:add_transition("LocalLoadersState", "no_level_needed", LocalIngameState)
	state_machine:add_transition("LocalLoadersState", "reset", LocalResetState)
	state_machine:add_transition("LocalLoadersState", "disconnected", LocalLoadFailState)
	state_machine:add_transition("LocalCreateWorldState", "load_done", LocalThemeState)
	state_machine:add_transition("LocalCreateWorldState", "no_level_needed", StateMachine.IGNORE_EVENT)
	state_machine:add_transition("LocalCreateWorldState", "reset", LocalResetState)
	state_machine:add_transition("LocalCreateWorldState", "disconnected", LocalLoadFailState)
	state_machine:add_transition("LocalThemeState", "load_done", LocalLevelState)
	state_machine:add_transition("LocalThemeState", "no_level_needed", StateMachine.IGNORE_EVENT)
	state_machine:add_transition("LocalThemeState", "reset", LocalResetState)
	state_machine:add_transition("LocalThemeState", "disconnected", LocalLoadFailState)
	state_machine:add_transition("LocalLevelState", "mission_load_done", LocalWaitForMissionBriefingDoneState)
	state_machine:add_transition("LocalLevelState", "hub_load_done", LocalDetermineSpawnGroupState)
	state_machine:add_transition("LocalLevelState", "no_level_needed", StateMachine.IGNORE_EVENT)
	state_machine:add_transition("LocalLevelState", "reset", LocalResetState)
	state_machine:add_transition("LocalLevelState", "disconnected", LocalLoadFailState)
	state_machine:add_transition("LocalWaitForMissionBriefingDoneState", "mission_briefing_done", LocalDetermineSpawnGroupState)
	state_machine:add_transition("LocalWaitForMissionBriefingDoneState", "no_level_needed", StateMachine.IGNORE_EVENT)
	state_machine:add_transition("LocalWaitForMissionBriefingDoneState", "reset", StateMachine.IGNORE_EVENT)
	state_machine:add_transition("LocalWaitForMissionBriefingDoneState", "disconnected", LocalLoadFailState)
	state_machine:add_transition("LocalIngameState", "disconnected", LocalLoadFailState)
	state_machine:add_transition("LocalIngameState", "load_mission", LocalLoadersState)
	state_machine:add_transition("LocalIngameState", "load_hub", LocalLoadersState)
	state_machine:add_transition("LocalIngameState", "no_level_needed", StateMachine.IGNORE_EVENT)
	state_machine:add_transition("LocalIngameState", "reset", StateMachine.IGNORE_EVENT)
	state_machine:set_initial_state(LocalDetermineLevelState)

	self._state_machine = state_machine
	self._shared_state = shared_state
end

LoadingClient.destroy = function (self)
	local shared_state = self._shared_state

	self:_cleanup_level(shared_state)

	local loaders = shared_state.loaders

	for _, loader in ipairs(loaders) do
		loader:cleanup()
		loader:delete()
	end

	table.clear(shared_state.loaders)

	if Managers.state.game_session then
		Managers.state.game_session:delete()

		Managers.state.game_session = nil
	end

	self._state_machine:delete()

	self._state_machine = nil
	self._shared_state = nil
end

LoadingClient._cleanup_level = function (self, shared_state)
	self._state_machine:event("reset")
	self._state_machine:update(0)

	local themes = shared_state.themes
	local level = shared_state.level
	local world = shared_state.world

	if #themes > 0 then
		for _, theme in ipairs(themes) do
			World.destroy_theme(world, theme)
		end

		shared_state.themes = {}
	end

	if shared_state.level_spawner then
		shared_state.level_spawner:destroy()

		shared_state.level_spawner = nil
	elseif level then
		local level_name = shared_state.level_name

		ScriptWorld.destroy_level(world, level_name)

		shared_state.level = nil
	end

	if world then
		Managers.world:destroy_world(world)

		shared_state.world = nil
	end
end

LoadingClient.load_mission = function (self, mission_name, level_name, circumstance_name)
	local shared_state = self._shared_state

	self:_cleanup_level(shared_state)

	shared_state.state = "loading"
	shared_state.level_name = level_name
	shared_state.mission_name = mission_name
	shared_state.circumstance_name = circumstance_name
	local state = self._state_machine:state()

	if state.load_mission then
		state:load_mission()
	end
end

LoadingClient.stop_load_mission = function (self)
	local shared_state = self._shared_state

	self:_cleanup_level(shared_state)

	shared_state.state = "loading"
	shared_state.level_name = nil
	shared_state.mission_name = nil
	shared_state.circumstance_name = nil
end

LoadingClient.no_level_needed = function (self)
	self._state_machine:event("no_level_needed")
end

LoadingClient.load_finished = function (self)
	return self._shared_state.state == "playing"
end

LoadingClient.update = function (self, dt)
	self._state_machine:update(dt)
end

LoadingClient.state = function (self)
	return self._shared_state.state
end

LoadingClient.take_ownership_of_level = function (self)
	local world, level = nil
	local themes = {}
	local shared_state = self._shared_state
	shared_state.world = world
	world = shared_state.world
	shared_state.level = level
	level = shared_state.level
	shared_state.themes = themes
	themes = shared_state.themes

	return world, level, themes
end

LoadingClient.spawn_group = function (self)
	local shared_state = self._shared_state

	return shared_state.spawn_group
end

LoadingClient.mission = function (self)
	return self._shared_state.mission_name
end

return LoadingClient
