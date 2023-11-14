local BackgroundMute = require("scripts/utilities/background_mute")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local WwiseStateGroupCircumstance = require("scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_circumstance")
local WwiseStateGroupCombat = require("scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_combat")
local WwiseStateGroupMinionAggroIntensity = require("scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_minion_aggro_intensity")
local WwiseStateGroupEventIntensity = require("scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_event_intensity")
local WwiseStateGroupEventType = require("scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_event_type")
local WwiseStateGroupGame = require("scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_game")
local WwiseStateGroupObjective = require("scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_objective")
local WwiseStateGroupObjectiveProgression = require("scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_objective_progression")
local WwiseStateGroupOptions = require("scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_options")
local WwiseStateGroupZone = require("scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_zone")
local WwiseGameSyncManager = class("WwiseGameSyncManager")
local WWISE_STATE_GROUP_SETTINGS = {
	music_game_state = WwiseStateGroupGame,
	music_zone = WwiseStateGroupZone,
	music_combat = WwiseStateGroupCombat,
	minion_aggro_intensity = WwiseStateGroupMinionAggroIntensity,
	music_objective = WwiseStateGroupObjective,
	music_objective_progression = WwiseStateGroupObjectiveProgression,
	circumstance = WwiseStateGroupCircumstance,
	event_category = WwiseStateGroupEventType,
	event_intensity = WwiseStateGroupEventIntensity,
	options = WwiseStateGroupOptions
}

WwiseGameSyncManager.init = function (self, world_manager)
	self._world = self:_create_world(world_manager)
	local wwise_world = world_manager:wwise_world(self._world)
	self._wwise_world = wwise_world

	WwiseWorld.trigger_resource_event(wwise_world, "wwise/events/music/play_music_manager")

	self._wwise_state_groups = {}
	self._wwise_state_group_states = {}

	for group_name, group_class in pairs(WWISE_STATE_GROUP_SETTINGS) do
		self._wwise_state_groups[group_name] = group_class:new(wwise_world, group_name)
		self._wwise_state_group_states[group_name] = WwiseGameSyncSettings.default_group_state
	end

	self._background_mute = BackgroundMute:new()
end

WwiseGameSyncManager.set_game_state_machine = function (self, game_state_machine)
	for _, group in pairs(self._wwise_state_groups) do
		group:set_game_state_machine(game_state_machine)
	end
end

WwiseGameSyncManager.on_gameplay_post_init = function (self, level)
	for _, group in pairs(self._wwise_state_groups) do
		group:on_gameplay_post_init(level)
	end
end

WwiseGameSyncManager.on_gameplay_shutdown = function (self)
	WwiseWorld.trigger_resource_event(self._wwise_world, "wwise/events/world/stop_all_mission_sounds")

	for _, group in pairs(self._wwise_state_groups) do
		group:on_gameplay_shutdown()
	end
end

WwiseGameSyncManager.destroy = function (self)
	local world = self._world

	Managers.world:destroy_world(world)

	self._world = nil
end

WwiseGameSyncManager.update = function (self, dt, t)
	self._background_mute:update()

	for group_name, group in pairs(self._wwise_state_groups) do
		group:update(dt, t)

		local new_state = group:wwise_state()

		self:_set_state(group_name, new_state)
	end
end

WwiseGameSyncManager.set_followed_player_unit = function (self, player_unit)
	local is_alive = ALIVE[player_unit]

	for _, group in pairs(self._wwise_state_groups) do
		group:set_followed_player_unit(is_alive and player_unit)
	end
end

WwiseGameSyncManager._create_world = function (self, world_manager)
	local world_name = "music_world"
	local world_layer = 905
	local timer_name = "main"
	local parameters = {
		layer = world_layer,
		timer_name = timer_name
	}
	local flags = {
		Application.DISABLE_PHYSICS,
		Application.DISABLE_RENDERING
	}
	local world = world_manager:create_world(world_name, parameters, unpack(flags))

	return world
end

WwiseGameSyncManager._set_state = function (self, group_name, new_state)
	local current_state = self._wwise_state_group_states[group_name]

	if current_state ~= new_state then
		self._wwise_state_group_states[group_name] = new_state

		Wwise.set_state(group_name, new_state)
	end
end

return WwiseGameSyncManager
