-- chunkname: @scripts/loading/local_states/local_level_state.lua

local AsyncLevelSpawner = require("scripts/loading/async_level_spawner")
local GameplayInitTimeSlice = require("scripts/game_states/game/utilities/gameplay_init_time_slice")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local ScriptTheme = require("scripts/foundation/utilities/script_theme")
local LocalLevelState = class("LocalLevelState")

LocalLevelState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	self._level_spawner = nil

	local level_name = shared_state.level_name

	self:_spawn_level(level_name)

	self._mission_name = shared_state.mission_name
end

LocalLevelState.update = function (self, dt)
	local shared_state = self._shared_state
	local level_spawner = shared_state.level_spawner
	local done, world, level = level_spawner:update()

	if done then
		shared_state.world = world
		shared_state.level = level

		shared_state.level_spawner:delete()

		shared_state.level_spawner = nil

		local mission_name = self._mission_name
		local mission_template = MissionTemplates[mission_name]
		local is_hub = mission_template.is_hub

		if is_hub then
			return "hub_load_done"
		else
			return "mission_load_done"
		end
	end
end

LocalLevelState._spawn_level = function (self, level_name)
	local world_parameters = {
		layer = 1,
		timer_name = "gameplay",
	}
	local shared_state = self._shared_state
	local object_sets_to_hide = ScriptTheme.object_sets_to_hide(shared_state.themes)

	shared_state.level_spawner = AsyncLevelSpawner:new("level_world", level_name, world_parameters, GameplayInitTimeSlice.MAX_DT_IN_SEC, shared_state.world, object_sets_to_hide)
end

return LocalLevelState
