local BuffSettings = require("scripts/settings/buff/buff_settings")
local MissionObjectiveCollect = require("scripts/extension_systems/mission_objective/utilities/mission_objective_collect")
local MissionObjectiveDecode = require("scripts/extension_systems/mission_objective/utilities/mission_objective_decode")
local MissionObjectiveDemolition = require("scripts/extension_systems/mission_objective/utilities/mission_objective_demolition")
local MissionObjectiveDestination = require("scripts/extension_systems/mission_objective/utilities/mission_objective_destination")
local MissionObjectiveGoal = require("scripts/extension_systems/mission_objective/utilities/mission_objective_goal")
local MissionObjectiveKill = require("scripts/extension_systems/mission_objective/utilities/mission_objective_kill")
local MissionObjectiveList = require("scripts/extension_systems/mission_objective/mission_objective_list")
local MissionObjectiveLuggable = require("scripts/extension_systems/mission_objective/utilities/mission_objective_luggable")
local MissionObjectiveSide = require("scripts/extension_systems/mission_objective/utilities/mission_objective_side")
local MissionObjectiveSystemTestify = GameParameters.testify and require("scripts/extension_systems/mission_objective/mission_objective_system_testify")
local MissionObjectiveTemplates = require("scripts/settings/mission_objective/mission_objective_templates")
local MissionObjectiveTestify = GameParameters.testify and require("scripts/extension_systems/mission_objective/mission_objective_testify")
local MissionObjectiveTimed = require("scripts/extension_systems/mission_objective/utilities/mission_objective_timed")
local MissionObjectiveZone = require("scripts/extension_systems/mission_objective/utilities/mission_objective_zone")
local proc_events = BuffSettings.proc_events
local mission_objectives = {
	collect = MissionObjectiveCollect,
	destination = MissionObjectiveDestination,
	goal = MissionObjectiveGoal,
	decode = MissionObjectiveDecode,
	kill = MissionObjectiveKill,
	timed = MissionObjectiveTimed,
	demolition = MissionObjectiveDemolition,
	luggable = MissionObjectiveLuggable,
	scanning = MissionObjectiveZone,
	side = MissionObjectiveSide
}
local MissionObjectiveSystem = class("MissionObjectiveSystem", "ExtensionSystemBase")
local RPCS = {
	"rpc_start_mission_objective",
	"rpc_start_mission_objective_stage",
	"rpc_update_mission_objective_progression",
	"rpc_update_mission_objective_second_progression",
	"rpc_update_mission_objective_increment",
	"rpc_end_mission_objective",
	"rpc_add_objective_marker",
	"rpc_remove_objective_marker",
	"rpc_mission_objective_override_ui_string",
	"rpc_mission_objective_show_counter",
	"rpc_mission_sound_event"
}
local GLOBAL_LIST_INDEX = -1

MissionObjectiveSystem.init = function (self, context, system_init_data, ...)
	MissionObjectiveSystem.super.init(self, context, system_init_data, ...)

	self._is_server = context.is_server
	self._objective_lists = {
		[GLOBAL_LIST_INDEX] = MissionObjectiveList:new()
	}
	self._synced_progressions = {}
	self._synced_second_progressions = {}
	self._synced_increments = {}
	self._synced_max_increments = {}
	self._game_session = Managers.state.game_session
	self._progression_sync_granularity = 0.01
	self._objective_definitions = {}
	self._new_ui_strings = {}
	self._objective_start_times = {}
	self._music_event_listener = nil
	local network_event_delegate = context.network_event_delegate
	self._network_event_delegate = network_event_delegate

	network_event_delegate:register_session_events(self, unpack(RPCS))

	self._level_name = context.level_name
	local mission = system_init_data.mission

	self:_load_definitions(mission)
end

MissionObjectiveSystem.destroy = function (self, ...)
	self._network_event_delegate:unregister_events(unpack(RPCS))
	MissionObjectiveSystem.super.destroy(self, ...)
end

MissionObjectiveSystem._load_definitions = function (self, mission)
	local objective_definitions = self._objective_definitions

	table.clear(objective_definitions)
	table.merge(objective_definitions, MissionObjectiveTemplates.common.objectives)

	if mission and mission.objectives then
		table.merge(objective_definitions, MissionObjectiveTemplates[mission.objectives].objectives)
	end

	local side_mission = Managers.state.mission:side_mission()

	if side_mission then
		table.merge(objective_definitions, MissionObjectiveTemplates.side_mission.objectives)
	end
end

MissionObjectiveSystem.objective_definition = function (self, objective_name)
	return self._objective_definitions[objective_name]
end

MissionObjectiveSystem.objective_list = function (self, peer_id)
	peer_id = peer_id or GLOBAL_LIST_INDEX
	local objective_lists = self._objective_lists

	if not objective_lists[peer_id] then
		objective_lists[peer_id] = MissionObjectiveList:new()
	end

	return self._objective_lists[peer_id]
end

MissionObjectiveSystem.active_objective = function (self, objective_name, peer_id)
	local objective_list = self:objective_list(peer_id)

	return objective_list:get_active_objective(objective_name)
end

MissionObjectiveSystem.has_active_objective = function (self, objective_name, peer_id)
	peer_id = peer_id or GLOBAL_LIST_INDEX
	local objective_list = self._objective_lists[peer_id]

	if not objective_list then
		return false
	end

	return objective_list:get_active_objective(objective_name) ~= nil
end

MissionObjectiveSystem.pre_update = function (self, dt, t)
	if self._is_server then
		for peer_id, objective_list in pairs(self._objective_lists) do
			local active_objectives = objective_list:active_objectives()

			for _, objective in pairs(active_objectives) do
				objective:clear_invalid_units()
			end
		end
	end
end

MissionObjectiveSystem.update = function (self, system_context, dt, t)
	if self._is_server then
		for peer_id, objective_list in pairs(self._objective_lists) do
			local active_objectives = objective_list:active_objectives()

			for objective_name, objective in pairs(active_objectives) do
				if not objective:is_updated_externally() then
					objective:update(dt)
					objective:update_progression()

					if GameParameters.testify then
						Testify:poll_requests_through_handler(MissionObjectiveTestify, self, objective_name)
					end

					self:_propagate_objective_progression(objective, peer_id)

					if objective:max_progression_achieved() and not objective:evaluate_at_level_end() then
						self:end_mission_objective(objective_name, peer_id)
					end
				end
			end
		end
	end

	if GameParameters.testify then
		Testify:poll_requests_through_handler(MissionObjectiveSystemTestify, self)
	end
end

MissionObjectiveSystem.start_mission_objective = function (self, objective_name, progression, second_progression, increment, stage, peer_id)
	peer_id = peer_id or GLOBAL_LIST_INDEX
	progression = progression or 0
	second_progression = second_progression or 0
	increment = increment or 0
	stage = stage or 1
	local mission_objective_data = self:objective_definition(objective_name)

	if not mission_objective_data then
		return
	end

	if self:has_active_objective(objective_name, peer_id) then
		return
	end

	if self._is_server then
		local objective_name_id = NetworkLookup.mission_objective_names[objective_name]

		self:send_rpc_to_objective_list(peer_id, "rpc_start_mission_objective", objective_name_id, progression, second_progression, increment, stage)
	end

	local objective = self:_setup_mission_objective(objective_name, peer_id)

	objective:start_stage(stage)
	objective:update_increment(increment)
	objective:set_progression(progression)
	objective:set_second_progression(second_progression)
	Managers.event:trigger("event_mission_objective_start", objective_name)

	if self._is_server then
		self._objective_start_times[objective] = Managers.time:time("main")
		local players = Managers.player:players()
		local is_global_objective = peer_id == GLOBAL_LIST_INDEX

		for _, player in pairs(players) do
			local player_started_objective = is_global_objective or player:peer_id() == peer_id

			if player_started_objective then
				Managers.telemetry_events:player_started_objective(player, objective_name)
			end
		end
	end

	local mission_objective_type = mission_objective_data.mission_objective_type
end

MissionObjectiveSystem._setup_mission_objective = function (self, objective_name, peer_id)
	local mission_objective_data = self:objective_definition(objective_name)
	local mission_objective_type = mission_objective_data.mission_objective_type
	local objective_list = self:objective_list(peer_id)
	local objective = objective_list:get_active_objective(objective_name)
	objective = mission_objectives[mission_objective_type]:new()

	objective:set_peer_id(peer_id)
	objective_list:add_active_objective(objective_name, objective)

	if mission_objective_data.evaluate_at_level_end then
		objective_list:add_level_end_objectives(objective_name, objective)
	end

	local registered_units = objective_list:objective_registered_units(objective_name)
	local synchronizer_unit = objective_list:objective_registered_synchronizer(objective_name)

	objective:start_objective(mission_objective_data, registered_units, synchronizer_unit)

	return objective
end

MissionObjectiveSystem.start_mission_objective_stage = function (self, objective_name, stage, peer_id)
	if self._is_server then
		local objective_name_id = NetworkLookup.mission_objective_names[objective_name]

		self:send_rpc_to_objective_list(peer_id, "rpc_start_mission_objective_stage", objective_name_id, stage)
	end

	local objective = self:active_objective(objective_name, peer_id)

	objective:start_stage(stage)
end

MissionObjectiveSystem.evaluate_level_end_objectives = function (self)
	for peer_id, objective_list in pairs(self._objective_lists) do
		local level_end_objectives = objective_list:level_end_objectives()

		for objective_name, objective in pairs(level_end_objectives) do
			local completed = objective:is_done()

			if completed then
				self:end_mission_objective(objective_name, peer_id)
			end
		end
	end
end

MissionObjectiveSystem.end_mission_objective = function (self, objective_name, peer_id)
	peer_id = peer_id or GLOBAL_LIST_INDEX
	local objective_list = self:objective_list(peer_id)
	local objective = objective_list:get_active_objective(objective_name)

	if not objective then
		return
	end

	local objective_type = objective:objective_type()
	local is_side_mission = objective:is_side_mission()

	if self._is_server then
		local objective_name_id = NetworkLookup.mission_objective_names[objective_name]

		self:send_rpc_to_objective_list(peer_id, "rpc_end_mission_objective", objective_name_id)
	end

	objective:end_objective()
	objective:delete()
	objective_list:set_objective_to_completed(objective_name)

	if self._is_server then
		local mission_name = Managers.state.mission:mission_name()
		local current_time = Managers.time:time("main")
		local start_time = self._objective_start_times[objective] or 0
		local objective_time = current_time - start_time
		self._objective_start_times[objective] = nil
		local players = Managers.player:players()
		local is_global_objective = peer_id == GLOBAL_LIST_INDEX

		for _, player in pairs(players) do
			local player_completed_objective = is_global_objective or player:peer_id() == peer_id

			if player_completed_objective then
				if is_side_mission then
					self:_proc_side_mission_objective_complete_buffs(player)
				end

				Managers.telemetry_events:player_completed_objective(player, objective_name)

				if player:is_human_controlled() and Managers.stats.can_record_stats() then
					Managers.stats:record_objective_complete(player, mission_name, objective_name, objective_type, objective_time)
				end
			end
		end
	end
end

MissionObjectiveSystem._proc_side_mission_objective_complete_buffs = function (self, player)
	local player_unit = player.player_unit

	if not player_unit then
		return
	end

	local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.unit = player_unit

		buff_extension:add_proc_event(proc_events.on_side_mission_objective_complete, param_table)
	end
end

MissionObjectiveSystem.external_update_mission_objective = function (self, objective_name, dt, increment, peer_id)
	if self._is_server then
		local objective = self:active_objective(objective_name, peer_id)

		if not objective then
			return
		end

		objective:update(dt)
		objective:update_increment(increment)
		objective:update_progression()
		self:_propagate_objective_progression(objective, peer_id)
		self:propagate_objective_increment(objective, peer_id)

		if objective:max_progression_achieved() and not objective:evaluate_at_level_end() then
			self:end_mission_objective(objective_name, peer_id)
		end
	end
end

MissionObjectiveSystem._propagate_objective_progression = function (self, objective, peer_id)
	local objective_name = objective:name()
	local objective_name_id = NetworkLookup.mission_objective_names[objective_name]
	local progression = objective:progression()
	local synced_progress = self._synced_progressions[objective] or 0
	local delta = math.abs(progression - synced_progress)
	local should_sync_progression = not self._synced_progressions[objective] or self._progression_sync_granularity < delta

	if should_sync_progression then
		self._synced_progressions[objective] = progression

		self:send_rpc_to_objective_list(peer_id, "rpc_update_mission_objective_progression", objective_name_id, progression)
		objective:progression_to_flow()
	end

	local second_progression = objective:second_progression()
	local synced_second_progression = self._synced_second_progressions[objective] or 0
	delta = math.abs(second_progression - synced_second_progression)
	local should_sync_second_progression = not self._synced_second_progressions[objective] or self._progression_sync_granularity < delta

	if should_sync_second_progression then
		self._synced_second_progressions[objective] = second_progression

		self:send_rpc_to_objective_list(peer_id, "rpc_update_mission_objective_second_progression", objective_name_id, second_progression)
	end
end

MissionObjectiveSystem.propagate_objective_increment = function (self, objective, peer_id)
	local objective_name = objective:name()
	local objective_name_id = NetworkLookup.mission_objective_names[objective_name]
	local increment = objective:incremented_progression()
	local max_increment = objective:max_incremented_progression()
	local synced_increment = self._synced_increments[objective] or 0
	local synced_max_increment = self._synced_max_increments[objective] or 0
	local increment_delta = math.abs(increment - synced_increment)
	local max_increment_delta = math.abs(max_increment - synced_max_increment)
	local should_sync = increment_delta > 0 or max_increment_delta > 0

	if should_sync then
		self._synced_increments[objective] = increment
		self._synced_max_increments[objective] = max_increment

		self:send_rpc_to_objective_list(peer_id, "rpc_update_mission_objective_increment", objective_name_id, increment, max_increment)
	end
end

MissionObjectiveSystem.is_current_active_objective = function (self, objective_name, peer_id)
	return self:active_objective(objective_name, peer_id) ~= nil
end

MissionObjectiveSystem.get_active_objective = function (self, objective_name, peer_id)
	return self:active_objective(objective_name, peer_id)
end

MissionObjectiveSystem.get_active_objectives = function (self, peer_id)
	local objective_list = self:objective_list(peer_id)

	return objective_list:active_objectives()
end

MissionObjectiveSystem.get_completed_objectives = function (self, peer_id)
	local objective_list = self:objective_list(peer_id)

	return objective_list:completed_objectives()
end

MissionObjectiveSystem.get_objective_progress = function (self, objective_name, peer_id)
	local is_objective_complete = false
	local progression = 0
	local max_progression = 0
	local objective_list = self:objective_list(peer_id)
	local objective = objective_list:get_complete_objective(objective_name)

	if objective then
		is_objective_complete = true
	else
		objective = objective_list:get_active_objective(objective_name)
	end

	if objective then
		progression = objective:incremented_progression()
		max_progression = objective:max_incremented_progression()
	end

	return is_objective_complete, progression, max_progression
end

MissionObjectiveSystem.is_objective_complete = function (self, objective_name, peer_id)
	local objective_list = self:objective_list(peer_id)
	local completed_objectives = objective_list:completed_objectives()

	return not not completed_objectives[objective_name]
end

MissionObjectiveSystem._override_ui_string = function (self, objective_name, new_ui_header, new_ui_description)
	if new_ui_header then
		local is_header = true

		self:_change_active_objective_ui_string(is_header, new_ui_header, objective_name)
	end

	if new_ui_description then
		local is_header = false

		self:_change_active_objective_ui_string(is_header, new_ui_description, objective_name)
	end

	if self._is_server then
		local ui_string_array = self._new_ui_strings[objective_name]

		if not ui_string_array then
			ui_string_array = {}
		else
			table.clear(ui_string_array)
		end

		if new_ui_header then
			ui_string_array[#ui_string_array + 1] = new_ui_header
		elseif new_ui_description then
			ui_string_array[#ui_string_array + 1] = new_ui_description
		end

		self._new_ui_strings[objective_name] = ui_string_array
		local objective_name_id = NetworkLookup.mission_objective_names[objective_name]
		local new_header_id = new_ui_header and NetworkLookup.mission_objective_ui_strings[new_ui_header] or 0
		local new_description_id = new_ui_description and NetworkLookup.mission_objective_ui_strings[new_ui_description] or 0

		self:send_rpc_to_objective_list(nil, "rpc_mission_objective_override_ui_string", objective_name_id, new_header_id, new_description_id)
	end
end

MissionObjectiveSystem._change_active_objective_ui_string = function (self, is_header, new_ui_string, objective_name)
	local active_objective = self:get_active_objective(objective_name)

	if active_objective then
		local localized_new_ui_string = nil

		if new_ui_string and new_ui_string ~= "empty_objective_string" then
			localized_new_ui_string = Managers.localization:localize(new_ui_string)
		end

		if is_header then
			active_objective:set_header(localized_new_ui_string)
		else
			active_objective:set_description(localized_new_ui_string)
		end
	end
end

MissionObjectiveSystem.set_objective_show_counter = function (self, objective_name, show)
	local active_objective = self:get_active_objective(objective_name)

	if active_objective then
		active_objective:set_use_counter(show)
	end

	if self._is_server then
		local objective_name_id = NetworkLookup.mission_objective_names[objective_name]

		self:send_rpc_to_objective_list(nil, "rpc_mission_objective_show_counter", objective_name_id, show)
	end
end

MissionObjectiveSystem.on_player_unit_spawn = function (self, player, unit, is_respawn)
	local active_objective = self:get_active_objective("side_mission_grimoire")

	if not active_objective then
		return
	end

	local synchronizer_unit = self:get_objective_synchronizer_unit("side_mission_grimoire")
	local synchronizer_extension = ScriptUnit.extension(synchronizer_unit, "event_synchronizer_system")

	synchronizer_extension:grant_grimoire(unit)
end

MissionObjectiveSystem.store_grimoire = function (self)
	local active_objective = self:get_active_objective("side_mission_grimoire")

	if not active_objective then
		Log.error("objective", "trying to store a grimore with no active grimoire objective")

		return
	end

	local synchronizer_unit = self:get_objective_synchronizer_unit("side_mission_grimoire")
	local synchronizer_extension = ScriptUnit.extension(synchronizer_unit, "event_synchronizer_system")

	synchronizer_extension:store_grimoire()
end

MissionObjectiveSystem.get_objective_event_music = function (self)
	for _, objective_list in pairs(self._objective_lists) do
		local active_objectives = objective_list:active_objectives()

		for _, objective in pairs(active_objectives) do
			local music_objective = objective:music_objective()

			if music_objective ~= "None" then
				return music_objective
			end
		end
	end

	return nil
end

MissionObjectiveSystem.get_objective_event_type_music = function (self)
	for _, objective_list in pairs(self._objective_lists) do
		local active_objectives = objective_list:active_objectives()

		for _, objective in pairs(active_objectives) do
			local event_type = objective:event_type()

			if event_type ~= "None" then
				return event_type
			end
		end
	end

	return nil
end

MissionObjectiveSystem.get_objective_event_music_progress = function (self)
	for _, objective_list in pairs(self._objective_lists) do
		local active_objectives = objective_list:active_objectives()

		for _, objective in pairs(active_objectives) do
			local event_type = objective:event_type()

			if event_type ~= "None" then
				return objective:total_progression()
			end
		end
	end

	return 0
end

MissionObjectiveSystem.sound_event = function (self, sound_event)
	if self._is_server then
		local mission_sound_event_id = NetworkLookup.mission_sound_events[sound_event]

		Managers.state.game_session:send_rpc_clients("rpc_mission_sound_event", mission_sound_event_id)
		self:_distribute_sound_event(sound_event)
	end
end

MissionObjectiveSystem._distribute_sound_event = function (self, sound_event)
	local listener = self._music_event_listener

	if listener then
		listener:sound_event_triggered(sound_event)
	end
end

MissionObjectiveSystem.register_music_event_listener = function (self, listener)
	self._music_event_listener = listener
end

MissionObjectiveSystem.register_objective_synchronizer = function (self, objective_name, objective_unit, peer_id)
	if not self:objective_definition(objective_name) then
		return
	end

	local objective_list = self:objective_list(peer_id)
	local synchronizer = objective_list:objective_registered_synchronizer(objective_name)

	if synchronizer then
		-- Nothing
	end

	objective_list:register_synchronizer_unit(objective_name, objective_unit)
end

MissionObjectiveSystem.get_objective_synchronizer_unit = function (self, objective_name, peer_id)
	local objective_list = self:objective_list(peer_id)

	return objective_list:objective_registered_synchronizer(objective_name)
end

MissionObjectiveSystem.register_objective_unit = function (self, objective_name, objective_unit, objective_stage, peer_id)
	objective_stage = objective_stage or 1

	if not self:objective_definition(objective_name) then
		return
	end

	local objective_list = self:objective_list(peer_id)

	objective_list:register_unit(objective_name, objective_stage, objective_unit)
end

MissionObjectiveSystem.unregister_objective_unit = function (self, objective_name, objective_unit, objective_stage, peer_id)
	if not self:objective_definition(objective_name) then
		return
	end

	local objective_list = self:objective_list(peer_id)

	objective_list:unregister_unit(objective_name, objective_stage, objective_unit)
end

MissionObjectiveSystem.add_marker = function (self, objective_name, unit, peer_id)
	local objective = self:active_objective(objective_name, peer_id)

	if objective then
		objective:add_marker(unit)
	end

	if self._is_server then
		local objective_name_id = NetworkLookup.mission_objective_names[objective_name]
		local is_level_unit, unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(unit)

		self:send_rpc_to_objective_list(peer_id, "rpc_add_objective_marker", objective_name_id, is_level_unit, unit_id)
	end
end

MissionObjectiveSystem.remove_marker = function (self, objective_name, unit, peer_id)
	local objective = self:active_objective(objective_name, peer_id)

	if objective then
		objective:remove_marker(unit)
	end

	if self._is_server then
		local objective_name_id = NetworkLookup.mission_objective_names[objective_name]
		local is_level_unit, unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(unit)

		self:send_rpc_to_objective_list(peer_id, "rpc_remove_objective_marker", objective_name_id, is_level_unit, unit_id)
	end
end

MissionObjectiveSystem.enable_unit = function (self, objective_name, unit, stage, peer_id)
	stage = stage or 1
	local registered_units = self:active_objective(objective_name, peer_id)
	local stage_units = registered_units[stage]

	if stage_units then
		for i = 1, #stage_units do
			local registered_unit = stage_units[i]

			if unit == registered_unit then
				local has_visibility_group = Unit.has_visibility_group(unit, "mission_objective")

				if has_visibility_group then
					Unit.set_visibility(unit, "mission_objective", true)
				end

				local interactee_extension = ScriptUnit.has_extension(unit, "interactee_system")

				if interactee_extension then
					interactee_extension:set_active(true)
				end
			end
		end
	end
end

MissionObjectiveSystem.disable_unit = function (self, objective_name, unit, stage, peer_id)
	stage = stage or 1
	local objective_list = self:objective_list(peer_id)
	local registered_units = objective_list:objective_registered_units(objective_name)
	local stage_units = registered_units[stage]

	if stage_units then
		for i = 1, #stage_units do
			local registered_unit = stage_units[i]

			if unit == registered_unit then
				local has_visibility_group = Unit.has_visibility_group(unit, "mission_objective")

				if has_visibility_group then
					Unit.set_visibility(unit, "mission_objective", false)
				end

				local interactee_extension = ScriptUnit.has_extension(unit, "interactee_system")

				if interactee_extension then
					interactee_extension:set_active(false)
				end
			end
		end
	end
end

local function _sort_ascending_order_of_activation_function(t, a, b)
	local order_a = t[a]:order_of_activation()
	local order_b = t[b]:order_of_activation()

	return order_a < order_b
end

MissionObjectiveSystem.hot_join_sync = function (self, sender, channel)
	local sorting_table = {}
	local game_session = self._game_session

	for peer_id, objective_list in pairs(self._objective_lists) do
		local active_objectives = objective_list:active_objectives()
		local list_channel = game_session:peer_to_channel(peer_id)

		if peer_id == GLOBAL_LIST_INDEX or list_channel == channel then
			for objective_name, objective in table.sorted(active_objectives, sorting_table, _sort_ascending_order_of_activation_function) do
				local objective_name_id = NetworkLookup.mission_objective_names[objective_name]
				local progression = objective:progression()
				local increment = objective:incremented_progression()
				local second_progression = objective:second_progression()
				local stage = objective:stage()

				RPC.rpc_start_mission_objective(channel, objective_name_id, progression, second_progression, increment, stage)

				local objective_units = objective:objective_units()

				for unit, _ in pairs(objective_units) do
					local is_level_unit, unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(unit)

					if objective:add_marker_on_hot_join(unit) then
						RPC.rpc_add_objective_marker(channel, objective_name_id, is_level_unit, unit_id)
					else
						RPC.rpc_remove_objective_marker(channel, objective_name_id, is_level_unit, unit_id)
					end
				end

				local ui_strings = self._new_ui_strings[objective_name]

				if ui_strings then
					local header_id = 0
					local description_id = 0

					for i = 1, #ui_strings do
						local ui_string = ui_strings[i]

						if i == 1 then
							header_id = NetworkLookup.mission_objective_ui_strings[ui_string]
						else
							description_id = NetworkLookup.mission_objective_ui_strings[ui_string]
						end
					end

					RPC.rpc_mission_objective_override_ui_string(channel, objective_name_id, header_id, description_id)

					local active_objective = self:get_active_objective(objective_name)
					local show = active_objective:use_counter_raw()

					RPC.rpc_mission_objective_show_counter(channel, objective_name_id, show)
				end
			end
		end
	end
end

MissionObjectiveSystem.flow_callback_register_objective_unit = function (self, objective_name, objective_unit, peer_id)
	local objective_target = ScriptUnit.has_extension(objective_unit, "mission_objective_target_system")

	if objective_target then
		objective_target:setup_from_external(objective_name, nil, nil, nil, nil, nil, false, peer_id)
	else
		self:register_objective_unit(objective_name, objective_unit, peer_id)
	end
end

MissionObjectiveSystem.flow_callback_start_mission_objective = function (self, objective_name, peer_id)
	local objective = self:active_objective(objective_name, peer_id)

	if objective then
		return
	end

	self:start_mission_objective(objective_name, nil, nil, nil, nil, peer_id)
end

MissionObjectiveSystem.flow_callback_update_mission_objective = function (self, objective_name, peer_id)
	local dt = Managers.time:delta_time("gameplay")
	local increment = 1

	self:external_update_mission_objective(objective_name, dt, increment, peer_id)
end

MissionObjectiveSystem.flow_callback_end_mission_objective = function (self, objective_name, peer_id)
	local objective = self:active_objective(objective_name, peer_id)

	if objective and objective:is_updated_externally() then
		self:end_mission_objective(objective_name, peer_id)
	end
end

MissionObjectiveSystem.flow_callback_override_ui_string = function (self, objective_name, new_ui_header, new_ui_description)
	self:_override_ui_string(objective_name, new_ui_header, new_ui_description)
end

MissionObjectiveSystem.flow_callback_set_objective_show_counter = function (self, objective_name, show)
	self:set_objective_show_counter(objective_name, show)
end

MissionObjectiveSystem.send_rpc_to_objective_list = function (self, peer_id, rpc_name, ...)
	peer_id = peer_id or GLOBAL_LIST_INDEX
	local game_session = self._game_session

	if peer_id == GLOBAL_LIST_INDEX then
		game_session:send_rpc_clients(rpc_name, ...)
	else
		local channel = game_session:peer_to_channel(peer_id)
		local rpc = RPC[rpc_name]

		if channel then
			rpc(channel, ...)
		else
			Log.error("objective", "rpc: %s, peer: %s", rpc_name, peer_id)

			return
		end
	end
end

MissionObjectiveSystem.rpc_start_mission_objective = function (self, channel_id, objective_name_id, progression, second_progression, increment, stage)
	local objective_name = NetworkLookup.mission_objective_names[objective_name_id]

	self:start_mission_objective(objective_name, progression, second_progression, increment, stage)
end

MissionObjectiveSystem.rpc_start_mission_objective_stage = function (self, channel_id, objective_name_id, stage)
	local objective_name = NetworkLookup.mission_objective_names[objective_name_id]

	self:start_mission_objective_stage(objective_name, stage)
end

MissionObjectiveSystem.rpc_update_mission_objective_progression = function (self, channel_id, objective_name_id, progression, peer_id)
	local objective_name = NetworkLookup.mission_objective_names[objective_name_id]
	local objective_list = self:objective_list(peer_id)
	local objective = objective_list:get_active_objective(objective_name)

	objective:set_progression(progression)
	objective:progression_to_flow()
end

MissionObjectiveSystem.rpc_update_mission_objective_second_progression = function (self, channel_id, objective_name_id, progression)
	local objective_name = NetworkLookup.mission_objective_names[objective_name_id]
	local objective = self:active_objective(objective_name)

	objective:set_second_progression(progression)
end

MissionObjectiveSystem.rpc_update_mission_objective_increment = function (self, channel_id, objective_name_id, increment, max_increment)
	local objective_name = NetworkLookup.mission_objective_names[objective_name_id]
	local objective = self:active_objective(objective_name)

	objective:set_increment(increment)
	objective:set_max_increment(max_increment)
end

MissionObjectiveSystem.rpc_end_mission_objective = function (self, channel_id, objective_name_id)
	local objective_name = NetworkLookup.mission_objective_names[objective_name_id]

	self:end_mission_objective(objective_name)
end

MissionObjectiveSystem.rpc_add_objective_marker = function (self, channel_id, objective_name_id, is_level_unit, level_unit_id)
	local objective_name = NetworkLookup.mission_objective_names[objective_name_id]
	local unit = Managers.state.unit_spawner:unit(level_unit_id, is_level_unit)

	self:add_marker(objective_name, unit)
end

MissionObjectiveSystem.rpc_remove_objective_marker = function (self, channel_id, objective_name_id, is_level_unit, level_unit_id)
	local objective_name = NetworkLookup.mission_objective_names[objective_name_id]
	local unit = Managers.state.unit_spawner:unit(level_unit_id, is_level_unit)

	self:remove_marker(objective_name, unit)
end

MissionObjectiveSystem.rpc_mission_objective_override_ui_string = function (self, channel_id, objective_name_id, new_header_id, new_description_id)
	local objective_name = NetworkLookup.mission_objective_names[objective_name_id]
	local new_ui_header = new_header_id ~= 0 and NetworkLookup.mission_objective_ui_strings[new_header_id] or nil
	local new_ui_description = new_description_id ~= 0 and NetworkLookup.mission_objective_ui_strings[new_description_id] or nil

	self:_override_ui_string(objective_name, new_ui_header, new_ui_description)
end

MissionObjectiveSystem.rpc_mission_objective_show_counter = function (self, channel_id, objective_name_id, show)
	local objective_name = NetworkLookup.mission_objective_names[objective_name_id]

	self:set_objective_show_counter(objective_name, show)
end

MissionObjectiveSystem.rpc_mission_sound_event = function (self, channel_id, music_event_id)
	local sound_event = NetworkLookup.mission_sound_events[music_event_id]

	self:_distribute_sound_event(sound_event)
end

return MissionObjectiveSystem
