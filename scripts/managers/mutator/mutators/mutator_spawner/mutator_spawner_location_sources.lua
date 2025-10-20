-- chunkname: @scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_location_sources.lua

local MutatorMonsterSpawnerSettings = require("scripts/settings/mutator/mutator_monster_spawner_settings")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local MutatorSpawnerLocationSources = {}

MutatorSpawnerLocationSources.prebaked_mission_locations = function (spawn_locations)
	return function ()
		local game_mode_manager = Managers.state.game_mode
		local game_mode = game_mode_manager:game_mode()

		spawn_locations = spawn_locations or "default_locations"

		local mission_name

		mission_name = Managers.state.mission:mission_name()

		if not MutatorMonsterSpawnerSettings[spawn_locations] then
			return
		end

		local locations = MutatorMonsterSpawnerSettings[spawn_locations][mission_name]

		if not locations then
			Log.exception("MutatorSpawnerLocationSources", "No spawn points defined in MutatorMonsterSpawnerSettings for category %s in mission %s.", spawn_locations, mission_name)
		end

		return table.clone(locations)
	end
end

MutatorSpawnerLocationSources.main_path_locations = function ()
	return function ()
		local main_path_manager = Managers.state.main_path
		local main_path_segments = main_path_manager:main_path_segments()
		local array_size = 0

		for i = 1, #main_path_segments do
			array_size = array_size + #main_path_segments[i].nodes
		end

		local processed_locations = Script.new_array(array_size)

		for i = 1, #main_path_segments do
			local segment = main_path_segments[i]

			for j = 1, #segment.nodes do
				local nodes = segment.nodes

				table.insert(processed_locations, {
					position = nodes[j],
					section = i,
				})
			end
		end

		return processed_locations
	end
end

return MutatorSpawnerLocationSources
