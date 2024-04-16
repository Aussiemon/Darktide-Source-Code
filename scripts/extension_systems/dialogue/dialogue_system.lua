require("scripts/extension_systems/dialogue/dialogue_extension")

local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local DialogueBreedSettings = require("scripts/settings/dialogue/dialogue_breed_settings")
local DialogueCategoryConfig = require("scripts/settings/dialogue/dialogue_category_config")
local DialogueEventQueue = require("scripts/extension_systems/dialogue/dialogue_event_queue")
local DialogueLookupContexts = require("scripts/settings/dialogue/dialogue_lookup_contexts")
local DialogueQueryQueue = require("scripts/extension_systems/dialogue/dialogue_query_queue")
local DialogueSettings = require("scripts/settings/dialogue/dialogue_settings")
local DialogueSystemSubtitle = require("scripts/extension_systems/dialogue/dialogue_system_subtitle")
local DialogueSystemTestify = GameParameters.testify and require("scripts/extension_systems/dialogue/dialogue_system_testify")
local DialogueSystemWwise = require("scripts/extension_systems/dialogue/dialogue_system_wwise")
local NetworkLookup = require("scripts/network_lookup/network_lookup")
local TagQuery = require("scripts/extension_systems/dialogue/tag_query")
local TagQueryDatabase = require("scripts/extension_systems/dialogue/tag_query_database")
local TagQueryLoader = require("scripts/extension_systems/dialogue/tag_query_loader")
local Vo = require("scripts/utilities/vo")
local WwiseRouting = require("scripts/settings/dialogue/wwise_vo_routing_settings")
local RPCS = {
	"rpc_interrupt_dialogue_event",
	"rpc_trigger_dialogue_event",
	"rpc_play_dialogue_event",
	"rpc_dialogue_system_joined",
	"rpc_set_dynamic_smart_tag",
	"rpc_trigger_subtitle_event"
}
local DialogueSystem = class("DialogueSystem", "ExtensionSystemBase")

DialogueSystem.init = function (self, extension_system_creation_context, system_init_data, ...)
	DialogueSystem.super.init(self, extension_system_creation_context, system_init_data, ...)

	self._dialogue_system_enabled = true
	self._update_units = {}
	self._circumstance_name = extension_system_creation_context.circumstance_name
	self._debug_state = nil
	self._t = nil
	local is_rule_db_enabled = system_init_data.is_rule_db_enabled
	local vo_sources_cache = system_init_data.vo_sources_cache
	self._current_mission = system_init_data.mission
	self._current_game_mode = nil
	self._vo_sources_cache = vo_sources_cache
	self._is_rule_db_enabled = is_rule_db_enabled
	self._original_dialogue_settings = {}
	local dialogue_templates = {}
	self._loaded_player_files_tracker = {}
	self._in_game_voice_profiles = {}

	if is_rule_db_enabled then
		self._tagquery_database = TagQueryDatabase:new(self)
		self._tagquery_loader = TagQueryLoader:new(self._tagquery_database, dialogue_templates)
	end

	self._dialogue_templates = dialogue_templates
	self._random_ignored_dialogue_end_t = {}
	self._random_ignored_dialogue_failed_tries = {}
	self.global_context = {
		player_voice_profiles = nil,
		team_lowest_player_level = nil
	}
	self._decaying_tension_hold_time = 0
	local network_event_delegate = self._network_event_delegate

	if network_event_delegate and is_rule_db_enabled then
		network_event_delegate:register_session_events(self, unpack(RPCS))
	end

	local auto_load_files = DialogueSettings.auto_load_files

	if self._current_mission then
		local mission_name = self._current_mission.name
		self.global_context.current_mission = mission_name
		local dialogue_settings_override = self._current_mission.dialogue_settings

		if dialogue_settings_override then
			for setting_name, value in pairs(dialogue_settings_override) do
				self._original_dialogue_settings[setting_name] = DialogueSettings[setting_name]
				DialogueSettings[setting_name] = value
			end
		end

		local game_mode_name = self._current_mission.game_mode_name
		self._current_game_mode = game_mode_name
		local dialogue_filename = DialogueSettings.default_rule_path .. game_mode_name

		self:_load_dialogue_resource(dialogue_filename)

		local blocked_auto_load = DialogueSettings.blocked_auto_load_files[self._current_mission.name]

		if not blocked_auto_load then
			self:_load_dialogue_resources(auto_load_files)
		end

		local level_specific_load_files = DialogueSettings.level_specific_load_files[mission_name]

		if level_specific_load_files then
			self:_load_dialogue_resources(level_specific_load_files)
		end

		self.global_context.circumstance_vo_id = "default"
		local circumstance_template = CircumstanceTemplates[self._circumstance_name]
		local dialogue_id = circumstance_template.dialogue_id

		if dialogue_id then
			local circumstance_load_files = circumstance_template.dialogue_load_files

			if circumstance_load_files then
				self:_load_dialogue_resources(circumstance_load_files)
			else
				self:_load_dialogue_resource(dialogue_id)
			end

			self.global_context.circumstance_vo_id = dialogue_id
		end
	else
		self:_load_dialogue_resources(auto_load_files)

		local menu_vo_files = DialogueSettings.menu_vo_files

		self:_load_dialogue_resources(menu_vo_files)
	end

	if is_rule_db_enabled then
		self._tagquery_database:finalize_rules()
		self._tagquery_database:set_global_context(self.global_context)
	end

	local world = self._world
	local wwise_world = self._wwise_world
	local dialogue_system_wwise = DialogueSystemWwise:new(world)
	self._dialogue_system_subtitle = DialogueSystemSubtitle:new(world, wwise_world)
	self._dialogue_system_wwise = dialogue_system_wwise
	self._faction_memories = {
		player = {},
		enemy = {},
		npc = {},
		none = {}
	}
	local extension_per_breed_wwise_voice_index = {}
	self._extension_per_breed_wwise_voice_index = extension_per_breed_wwise_voice_index
	self.global_context.level_time = 0
	self._next_story_line_update_t = DialogueSettings.story_start_delay
	self._next_short_story_line_update_t = DialogueSettings.short_story_start_delay
	self._next_npc_story_line_update_t = DialogueSettings.npc_story_ticker_start_delay
	self._LOCAL_GAMETIME = 0
	local extension_init_context = self._extension_init_context
	extension_init_context.vo_sources_cache = vo_sources_cache
	extension_init_context.dialogue_system_wwise = dialogue_system_wwise
	extension_init_context.extension_per_breed_wwise_voice_index = extension_per_breed_wwise_voice_index
	self.dialogueLookupContexts = DialogueLookupContexts
	self.dialogueLookupConcepts = NetworkLookup.dialogues_all_concepts
	self._wwise_routes = WwiseRouting
	self._wwise_route_default = nil

	for key, value in pairs(self._wwise_routes) do
		if value.is_default then
			self._wwise_route_default = value

			break
		end
	end

	self._event_queue = nil
	self._query_queue = nil
	self._playing_dialogues = {}
	self._playing_dialogues_array = {}
	self._playing_units = {}

	if self._is_server and is_rule_db_enabled then
		self._event_queue = DialogueEventQueue:new(dialogue_templates, self._tagquery_database)
		self._query_queue = DialogueQueryQueue:new()
		self._reject_queries_until = 0
		self._missions_data = {}
		self._missions = {}
		self._time_since_mission_fetch = 0
		self._missions_board_promise = nil
	elseif not is_rule_db_enabled then
		self._vo_rule_queue = {}
	end

	self._next_player_level_check = 0
	self._next_local_events_queue_process = 0
	self._next_audible_check = 0
end

DialogueSystem.playing_dialogues_array = function (self)
	return self._playing_dialogues_array
end

DialogueSystem.is_dialogue_playing = function (self)
	return #self._playing_dialogues_array > 0
end

DialogueSystem.destroy = function (self)
	if self._is_rule_db_enabled then
		self._tagquery_loader:unload_files()
		self._tagquery_database:destroy()
	end

	if self._network_event_delegate then
		self._network_event_delegate:unregister_events(unpack(RPCS))
	end

	if next(self._original_dialogue_settings) then
		for setting_name, value in pairs(self._original_dialogue_settings) do
			DialogueSettings[setting_name] = value
		end
	end

	table.clear(self)
end

DialogueSystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local breed = extension_init_data.breed
	local breed_dialogue_settings = breed and DialogueBreedSettings[breed.name]

	if breed and breed_dialogue_settings.has_dialogue_extension == false then
		Log.error("DialogueSystem", "According to dialogue_breed_settings.lua unit %s should not get a dialogue extension, please contact the Audio Team")
	end

	if Managers.state.extension then
		self:_update_lowest_player_level()
	end

	local extension = DialogueSystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)

	if self._is_rule_db_enabled then
		self._tagquery_database:add_object_context(unit, "user_memory", extension:get_user_memory())
		self._tagquery_database:add_object_context(unit, "user_context", extension:get_context())

		local faction_memory_name = nil

		if extension_init_data.faction_memory_name then
			faction_memory_name = extension_init_data.faction_memory_name
		elseif breed_dialogue_settings then
			faction_memory_name = breed_dialogue_settings.dialogue_memory_faction_name
		end

		if faction_memory_name then
			local faction_memory = self._faction_memories[faction_memory_name]

			self._tagquery_database:add_object_context(unit, "faction_memory", faction_memory)
			extension:set_faction_memory(faction_memory)
		end
	end

	return extension
end

DialogueSystem._update_global_context_player_voices = function (self, in_game_player_voices)
	local unique_voice_profiles = table.unique_array_values(in_game_player_voices)

	table.sort(unique_voice_profiles, function (a, b)
		return a:upper() < b:upper()
	end)

	self.global_context.player_voice_profiles = unique_voice_profiles
end

DialogueSystem._update_decaying_tension = function (self, dt, t)
	local is_decaying_tension = Managers.state.pacing:is_decaying_tension()

	if is_decaying_tension then
		self.global_context.is_decaying_tension = "true"
		local decaying_tension_delay = DialogueSettings.decaying_tension_delay
		self._decaying_tension_hold_time = decaying_tension_delay
	else
		self._decaying_tension_hold_time = self._decaying_tension_hold_time - dt

		if self._decaying_tension_hold_time <= 0 then
			self.global_context.is_decaying_tension = "false"
		end
	end
end

DialogueSystem.extensions_ready = function (self, world, unit, extension_name)
	local extension = self._unit_to_extension_map[unit]

	if extension:is_a_player() then
		local voice_profile = extension:get_voice_profile()

		table.insert(self._in_game_voice_profiles, voice_profile)
		self:_update_global_context_player_voices(self._in_game_voice_profiles)

		if self._current_game_mode == "coop_complete_objective" then
			self:_load_player_resource(voice_profile)
		end
	end
end

DialogueSystem.on_remove_extension = function (self, unit, extension_name)
	local extension = self._unit_to_extension_map[unit]

	if extension:is_a_player() then
		local voice_profile = extension:get_voice_profile()
		local voice_profile_index = table.index_of(self._in_game_voice_profiles, voice_profile)

		table.remove(self._in_game_voice_profiles, voice_profile_index)

		if self._current_game_mode == "coop_complete_objective" then
			self:_unload_player_resource(voice_profile)
		end
	end

	if self._is_rule_db_enabled then
		self._tagquery_database:remove_object(unit)
	end

	self._update_units[unit] = nil

	DialogueSystem.super.on_remove_extension(self, unit, extension_name)
end

local _function_by_op = {
	[TagQuery.OP.ADD] = function (lhs, rhs)
		return (lhs or 0) + rhs
	end,
	[TagQuery.OP.SUB] = function (lhs, rhs)
		return (lhs or 0) - rhs
	end,
	[TagQuery.OP.NUMSET] = function (lhs, rhs)
		return rhs or 0
	end,
	[TagQuery.OP.TIMESET] = function ()
		return Managers.time:time("gameplay") + 900
	end
}

DialogueSystem._update_currently_playing_dialogues = function (self, dt, t)
	local ALIVE = ALIVE
	local unit_to_extension_map = self._unit_to_extension_map
	local playing_units = self._playing_units
	local is_server = self._is_server
	local dialogue_system_wwise = self._dialogue_system_wwise

	for unit, extension in pairs(playing_units) do
		repeat
			if not ALIVE[unit] then
				playing_units[unit] = nil
			else
				local currently_playing_dialogue = extension:get_currently_playing_dialogue()
				local is_currently_playing = nil
				local dialogue_timer = currently_playing_dialogue.dialogue_timer

				if dialogue_timer then
					is_currently_playing = dialogue_timer - dt > 0
				end

				if not is_currently_playing then
					local animation_event = "stop_talking"

					self:_trigger_face_animation_event(unit, animation_event)
					dialogue_system_wwise:stop_if_playing(currently_playing_dialogue.concurrent_wwise_event_id)

					local used_query = currently_playing_dialogue.used_query

					extension:set_is_currently_playing_dialogue(false)
					self:_remove_stopped_dialogue(unit, currently_playing_dialogue)

					if not is_server then
						break
					end

					local result = used_query ~= nil and used_query.result

					if result then
						local source = used_query.query_context.source
						local success_rule = used_query.validated_rule
						local on_done = success_rule.on_done

						if on_done then
							local user_contexts = unit_to_extension_map[source]

							for i = 1, #on_done do
								local on_done_command = on_done[i]
								local table_name = on_done_command[1]
								local argument_name = on_done_command[2]
								local op = on_done_command[3]
								local argument = on_done_command[4]

								if type(op) == "table" then
									local new_value = _function_by_op[op](user_contexts:read_from_memory(table_name, argument_name), argument)

									user_contexts:store_in_memory(table_name, argument_name, new_value)
								else
									user_contexts:store_in_memory(table_name, argument_name, op)
								end
							end
						end

						if success_rule.on_post_rule_execution and success_rule.on_post_rule_execution.reject_events then
							local reject_events_command = success_rule.on_post_rule_execution.reject_events
							self._reject_queries_until = t + reject_events_command.duration
						end

						local temp_event_data = {
							dialogue_name = result,
							speaker_class = extension:vo_class_name(),
							sound_event = extension:get_last_query_sound_event(),
							voice_profile = extension:get_voice_profile()
						}

						if success_rule.heard_speak_routing ~= nil then
							local heard_speak_target = success_rule.heard_speak_routing.target

							if heard_speak_target ~= "disabled" then
								if heard_speak_target == "players" then
									self:append_faction_event(unit, "heard_speak", temp_event_data, nil, "imperium", true)
								elseif heard_speak_target == "all" then
									for registered_unit, registered_extension in pairs(unit_to_extension_map) do
										repeat
											if registered_unit == unit or registered_extension:is_dialogue_disabled() then
												break
											end

											self:append_event_to_queue(registered_unit, "heard_speak", temp_event_data, nil)
										until true
									end
								elseif heard_speak_target == "self" then
									self:append_self_event(unit, "heard_speak", temp_event_data, nil)
								elseif heard_speak_target == "mission_giver_default" then
									local voice_over_spawn_manager = Managers.state.voice_over_spawn
									local default_mission_giver_voice_profile = voice_over_spawn_manager:current_voice_profile()
									local default_mission_giver_unit = voice_over_spawn_manager:voice_over_unit(default_mission_giver_voice_profile)

									self:append_targeted_source_event(default_mission_giver_unit, "heard_speak", temp_event_data, nil)
								elseif heard_speak_target == "mission_giver_default_class" then
									local voice_over_spawn_manager = Managers.state.voice_over_spawn
									local default_mission_giver_voice_profile = voice_over_spawn_manager:current_voice_profile()
									local default_mission_giver_unit = voice_over_spawn_manager:voice_over_unit(default_mission_giver_voice_profile)
									local default_mission_giver_dialogue_extension = unit_to_extension_map[default_mission_giver_unit]
									local default_mission_giver_class = default_mission_giver_dialogue_extension._context.class_name
									local breed_setting = DialogueBreedSettings[default_mission_giver_class]
									local voices = breed_setting.wwise_voices

									for _, voice in pairs(voices) do
										local mission_giver_unit = voice_over_spawn_manager:voice_over_unit(voice)

										if mission_giver_unit and mission_giver_unit ~= unit then
											self:append_targeted_source_event(mission_giver_unit, "heard_speak", temp_event_data, nil)
										end
									end
								elseif heard_speak_target == "mission_givers" then
									local voice_over_spawn_manager = Managers.state.voice_over_spawn
									local mission_giver_units = voice_over_spawn_manager:voice_over_units()

									for _, mission_giver_unit in pairs(mission_giver_units) do
										if mission_giver_unit and mission_giver_unit ~= unit then
											self:append_targeted_source_event(mission_giver_unit, "heard_speak", temp_event_data, nil)
										end
									end
								elseif heard_speak_target == "level_event" then
									local level = Managers.state.mission:mission_level()

									if level then
										Level.trigger_event(level, success_rule.name)
									end
								elseif heard_speak_target == "all_including_self" then
									for registered_unit, registered_extension in pairs(unit_to_extension_map) do
										repeat
											if registered_extension:is_dialogue_disabled() then
												break
											end

											self:append_event_to_queue(registered_unit, "heard_speak", temp_event_data, nil)
										until true
									end
								elseif heard_speak_target == "visible_npcs" then
									for registered_unit, registered_extension in pairs(unit_to_extension_map) do
										repeat
											if registered_extension:is_dialogue_disabled() then
												break
											end

											local faction = registered_extension:faction_name()

											if faction ~= "npc" then
												break
											end

											local is_invisible = Unit.get_data(registered_unit, "invisible")

											if is_invisible then
												break
											end

											self:append_event_to_queue(registered_unit, "heard_speak", temp_event_data, nil)
										until true
									end
								else
									Log.warning("DialogueSystem", "heard_speak_routing.target %s is wrong or unrecognized", heard_speak_target)
								end
							end
						else
							local legacy_v2_proximity_system = self._extension_manager:system("legacy_v2_proximity_system")

							legacy_v2_proximity_system:add_distance_based_vo_query(unit, "heard_speak", temp_event_data)
						end

						extension:set_last_query_sound_event(nil)
					end
				elseif dialogue_timer then
					if not DEDICATED_SERVER then
						local playing = dialogue_system_wwise:is_playing(currently_playing_dialogue.currently_playing_event_id)

						if not playing then
							local sequence_table = currently_playing_dialogue.dialogue_sequence

							if sequence_table then
								table.remove(sequence_table, 1)

								if table.size(sequence_table) > 0 then
									local next_event = sequence_table[1]

									if next_event.type == "vorbis_external" then
										self._dialogue_system_subtitle:add_playing_localized_dialogue(currently_playing_dialogue.speaker_name, currently_playing_dialogue)
									end

									currently_playing_dialogue.currently_playing_event_id = extension:play_event(next_event)
								end
							end
						end

						if currently_playing_dialogue.subtitle_distance then
							currently_playing_dialogue.is_audible = self:is_dialogue_audible(unit, currently_playing_dialogue, t)
						end
					end

					currently_playing_dialogue.dialogue_timer = currently_playing_dialogue.dialogue_timer - dt
				end
			end
		until true
	end
end

local PLAYER_LEVEL_CHECK_INTERVAL = 4

DialogueSystem.physics_async_update = function (self, context, dt, t)
	self._t = t

	self:_update_currently_playing_dialogues(dt, t)

	if not DEDICATED_SERVER then
		self._dialogue_system_subtitle:update(dt)
	end

	if not self._is_server then
		return
	end

	self.global_context.level_time = t
	self.global_context.pacing_tension = Managers.state.pacing:tension()
	self.global_context.team_threat_level = Managers.state.pacing:combat_state()

	self:_update_decaying_tension(dt, t)

	self.global_context.pacing_state = Managers.state.pacing:state()
	self._LOCAL_GAMETIME = t + 900
	self.global_context.active_hordes = Managers.state.horde:num_active_hordes()

	for _, extension in pairs(self._update_units) do
		extension:physics_async_update(context, dt, t)
	end

	if self._next_player_level_check < t then
		self:_update_lowest_player_level()

		self._next_player_level_check = t + PLAYER_LEVEL_CHECK_INTERVAL
	end

	if self._is_rule_db_enabled then
		local tagquery_database = self._tagquery_database
		local queries = tagquery_database:iterate_queries(self._LOCAL_GAMETIME)

		if self._dialogue_system_enabled then
			local delayed_query = self._query_queue:get_query(t)

			for i = 1, #queries do
				local query = queries[i]

				self:_process_query(query, t, false)
			end

			if delayed_query then
				self:_process_query(delayed_query, t, true)
			end

			self:_update_story_lines(t)
		end

		self._event_queue:update_new_events(dt, t)
	end
end

DialogueSystem.register_extension_update = function (self, unit, extension_name, extension)
	DialogueSystem.super.register_extension_update(self, unit, extension_name, extension)

	self._update_units[unit] = extension
end

local LOCAL_VO_EVENTS_PROCESS_INTERVAL = 0.1

DialogueSystem.update = function (self, context, dt, t)
	if GameParameters.testify then
		Testify:poll_requests_through_handler(DialogueSystemTestify, self)
	end

	if not self._is_rule_db_enabled and not DEDICATED_SERVER then
		self:_process_local_playing_dialogues(dt, t)

		if self._next_local_events_queue_process < t then
			self:_process_local_vo_event_queue()

			self._next_local_events_queue_process = t + LOCAL_VO_EVENTS_PROCESS_INTERVAL
		end
	end
end

local temp_dialogue_breed_ids = {}
local temp_dialogue_voice_indexes = {}
local temp_dialogue_extension_unit_ids = {}
local temp_dialogue_extension_profiles = {}

DialogueSystem.hot_join_sync = function (self, sender, channel)
	table.clear_array(temp_dialogue_breed_ids, #temp_dialogue_breed_ids)
	table.clear_array(temp_dialogue_voice_indexes, #temp_dialogue_voice_indexes)
	table.clear_array(temp_dialogue_extension_unit_ids, #temp_dialogue_extension_unit_ids)
	table.clear_array(temp_dialogue_extension_profiles, #temp_dialogue_extension_profiles)

	local num_breed_dialogue_voice_indexes = 0

	for breed_name, voice_index in pairs(self._extension_per_breed_wwise_voice_index) do
		num_breed_dialogue_voice_indexes = num_breed_dialogue_voice_indexes + 1
		local breed_name_id = NetworkLookup.dialogue_breed_names[breed_name]
		temp_dialogue_breed_ids[num_breed_dialogue_voice_indexes] = breed_name_id
		temp_dialogue_voice_indexes[num_breed_dialogue_voice_indexes] = voice_index
	end

	local num_dialogue_extensions = 0
	local unit_spawner_manager = Managers.state.unit_spawner

	for unit, extension in pairs(self._unit_to_extension_map) do
		repeat
			if extension:is_network_synced() == false then
				break
			end

			num_dialogue_extensions = num_dialogue_extensions + 1
			temp_dialogue_extension_unit_ids[num_dialogue_extensions] = unit_spawner_manager:game_object_id(unit)
			temp_dialogue_extension_profiles[num_dialogue_extensions] = extension:get_profile_name()
		until true
	end

	RPC.rpc_dialogue_system_joined(channel, temp_dialogue_breed_ids, temp_dialogue_voice_indexes, temp_dialogue_extension_unit_ids, temp_dialogue_extension_profiles)
end

DialogueSystem.random_player = function (self)
	local side_system = Managers.state.extension:system("side_system")
	local side_name = side_system:get_default_player_side_name()
	local side = side_system:get_side_from_name(side_name)
	local players = side:added_player_units()
	local unit_list = {}
	local unit_list_n = 0

	for i = 1, #players do
		local unit = players[i]

		if HEALTH_ALIVE[unit] then
			unit_list_n = unit_list_n + 1
			unit_list[unit_list_n] = unit
		end
	end

	if unit_list_n > 0 then
		local unit = unit_list[math.random(1, unit_list_n)]

		return unit
	end

	return nil
end

DialogueSystem.force_stop_all = function (self)
	if DEDICATED_SERVER then
		return
	end

	for unit, extension in pairs(self._playing_units) do
		extension:stop_currently_playing_vo()
	end

	local vo_rule_queue = self._vo_rule_queue

	if vo_rule_queue then
		table.clear(vo_rule_queue)
	end
end

DialogueSystem._update_story_lines = function (self, t)
	local next_story_line_update_t = self._next_story_line_update_t
	local is_story_ticker = DialogueSettings.story_ticker_enabled

	if is_story_ticker and next_story_line_update_t < t then
		self._next_story_line_update_t = t + DialogueSettings.story_tick_time

		if self.global_context.team_threat_level == "low" and self.global_context.active_hordes == 0 then
			Vo.player_vo_event_by_concept("story_talk")
		end
	end

	local is_short_story_ticker = DialogueSettings.short_story_ticker_enabled
	local next_short_story_line_update_t = self._next_short_story_line_update_t

	if is_short_story_ticker and next_short_story_line_update_t < t then
		self._next_short_story_line_update_t = t + DialogueSettings.short_story_tick_time

		if self.global_context.team_threat_level == "low" and self.global_context.active_hordes == 0 then
			Vo.player_vo_event_by_concept("short_story_talk")
		end
	end

	local is_vox_stories = DialogueSettings.npc_story_ticker_enabled

	if is_vox_stories then
		local next_npc_story_line_update_t = self._next_npc_story_line_update_t

		if is_vox_stories and next_npc_story_line_update_t < t then
			self._next_npc_story_line_update_t = t + DialogueSettings.npc_story_tick_time
			local trigger_id = "npc_story_talk"

			Vo.play_npc_story(trigger_id)
		end
	end
end

DialogueSystem._update_lowest_player_level = function (self)
	local lowest_player_level = nil
	local side_system = Managers.state.extension:system("side_system")

	if not side_system then
		return
	end

	local side_name = side_system:get_default_player_side_name()
	local side = side_system:get_side_from_name(side_name)
	local human_units = side.valid_human_units
	local HEALTH_ALIVE = HEALTH_ALIVE
	local player_unit_spawn_manager = Managers.state.player_unit_spawn

	for i = 1, #human_units do
		local human_unit = human_units[i]

		if HEALTH_ALIVE[human_unit] then
			local player = player_unit_spawn_manager:owner(human_unit)
			local profile = player:profile()
			local player_level = profile.current_level

			if player_level and lowest_player_level == nil then
				lowest_player_level = player_level
			elseif player_level and player_level < lowest_player_level then
				lowest_player_level = player_level
			end
		end
	end

	self.global_context.team_lowest_player_level = lowest_player_level
end

DialogueSystem.disable = function (self)
	self._dialogue_system_enabled = false
end

DialogueSystem.enable = function (self)
	self._dialogue_system_enabled = true
end

DialogueSystem._process_local_playing_dialogues = function (self, dt, t)
	local unit_alive = Unit.alive
	local playing_units = self._playing_units

	for unit, extension in pairs(playing_units) do
		repeat
			if not unit_alive(unit) then
				playing_units[unit] = nil
			else
				local currently_playing_dialogue = extension:get_currently_playing_dialogue()
				local is_still_playing = nil

				if currently_playing_dialogue.dialogue_timer then
					local wwise_playing = self._dialogue_system_wwise:is_playing(currently_playing_dialogue.currently_playing_event_id)
					is_still_playing = wwise_playing
				end

				if not is_still_playing then
					self:_remove_stopped_dialogue(unit, currently_playing_dialogue)
					extension:set_is_currently_playing_dialogue(false)
					table.remove(self._vo_rule_queue, 1)

					if #self._vo_rule_queue == 0 then
						local animation_event = "stop_talking"

						self:_trigger_face_animation_event(unit, animation_event)
					end
				else
					currently_playing_dialogue.dialogue_timer = currently_playing_dialogue.dialogue_timer - dt

					if currently_playing_dialogue.subtitle_distance then
						currently_playing_dialogue.is_audible = self:is_dialogue_audible(unit, currently_playing_dialogue, t)
					end
				end

				self._dialogue_system_subtitle:update()
			end
		until true
	end
end

DialogueSystem._process_local_vo_event_queue = function (self)
	if self:is_dialogue_playing() then
		return
	end

	local vo_rule_queue = self._vo_rule_queue
	local event = vo_rule_queue[1]

	if not event then
		return
	end

	local extension = self._unit_to_extension_map[event.unit]

	extension:play_local_vo_event(event.rule_name, event.wwise_route_key, event.on_play_callback, event.seed, true)
end

DialogueSystem.append_faction_event = function (self, source_unit, event_name, event_data, identifier, breed_faction_name, exclude_me)
	local num_unique_voices = self.global_context.player_voice_profiles and #self.global_context.player_voice_profiles

	if not num_unique_voices then
		return
	end

	for unit, extension in pairs(self._unit_to_extension_map) do
		repeat
			if extension:is_dialogue_disabled() then
				break
			elseif extension._faction_breed_name ~= breed_faction_name then
				break
			elseif unit == source_unit and exclude_me then
				break
			elseif breed_faction_name == "imperium" and event_data.voice_profile == extension:get_voice_profile() and num_unique_voices > 1 then
				break
			end

			self:append_event_to_queue(unit, event_name, event_data, identifier)
			extension:set_is_disabled_override(false)
		until true
	end
end

DialogueSystem.append_self_event = function (self, source_unit, event_name, event_data, identifier)
	self:append_event_to_queue(source_unit, event_name, event_data, identifier)
end

DialogueSystem.append_targeted_source_event = function (self, source_unit, event_name, event_data, identifier)
	self:append_event_to_queue(source_unit, event_name, event_data, identifier)
end

DialogueSystem.populate_faction_contexts = function (self, nice_array, base_index, target_faction, source_unit)
	local total_faction_contexts = 0

	for unit, extension in pairs(self._unit_to_extension_map) do
		repeat
			if extension._faction_breed_name ~= target_faction then
				break
			end

			if unit == source_unit then
				break
			end

			if extension._context then
				total_faction_contexts = total_faction_contexts + 1
				nice_array[base_index + total_faction_contexts] = extension._context
			end
		until true
	end

	nice_array[base_index] = total_faction_contexts
end

DialogueSystem.append_event_to_queue = function (self, unit, event_name, event_data, identifier)
	self._event_queue:append_event(unit, event_name, event_data, identifier)
end

DialogueSystem._is_playable_dialogue_category = function (self, dialogue_category)
	local is_playable = true
	local is_cinematic_playing = Managers.state.cinematic:is_playing()

	if is_cinematic_playing then
		local playable_categories = DialogueCategoryConfig.playable_during_cinematic

		if not playable_categories[dialogue_category] then
			is_playable = false
		end
	end

	return is_playable
end

DialogueSystem._prevent_on_demand_vo = function (self, actor_unit, dialogue_category)
	local prevent_play = false
	local is_on_demand_vo = dialogue_category == "player_on_demand_vo"

	if not is_on_demand_vo then
		return prevent_play
	end

	local player = Managers.state.player_unit_spawn:owner(actor_unit)

	if player then
		local account_id = player:account_id()
		local social_service_manager = Managers.data_service.social
		local player_info = account_id and social_service_manager and social_service_manager:get_player_info_by_account_id(account_id)

		if player_info then
			prevent_play = player_info:is_text_muted() or player_info:is_voice_muted()
		end
	end

	return prevent_play
end

DialogueSystem.rpc_dialogue_system_joined = function (self, channel_id, dialogue_breed_ids, dialogue_voice_indexes, dialogue_extension_unit_ids, dialogue_extension_profiles)
	local extension_per_breed_wwise_voice_index = self._extension_per_breed_wwise_voice_index

	table.clear(extension_per_breed_wwise_voice_index)

	local num_dialogue_breed_ids = #dialogue_breed_ids
	local dialogue_breed_names_lookup = NetworkLookup.dialogue_breed_names

	for i = 1, num_dialogue_breed_ids do
		local breed_name_id = dialogue_breed_ids[i]
		local breed_name = dialogue_breed_names_lookup[breed_name_id]
		extension_per_breed_wwise_voice_index[breed_name] = dialogue_voice_indexes[i]
	end

	local num_dialogue_extension_unit_ids = #dialogue_extension_unit_ids
	local unit_spawner_manager = Managers.state.unit_spawner
	local unit_to_extension_map = self._unit_to_extension_map

	for i = 1, num_dialogue_extension_unit_ids do
		repeat
			local unit = unit_spawner_manager:unit(dialogue_extension_unit_ids[i], false)

			if unit == nil then
				break
			end

			local extension = unit_to_extension_map[unit]

			extension:set_vo_profile(dialogue_extension_profiles[i])
		until true
	end
end

DialogueSystem.rpc_trigger_dialogue_event = function (self, channel_id, go_id, event_id, event_data_array, event_data_array_types, identifier)
	local unit = Managers.state.unit_spawner:unit(go_id, false)

	if not unit then
		return
	end

	local pairs_in_event_data = #event_data_array / 2
	local index = 1
	local dialogueLookupContexts = self.dialogueLookupContexts
	local all_context_names = dialogueLookupContexts.all_context_names

	for i = 1, pairs_in_event_data do
		local context = all_context_names[event_data_array[index]]
		event_data_array[index] = context
		index = index + 1

		if not event_data_array_types[index] then
			event_data_array[index] = dialogueLookupContexts[context][event_data_array[index]]
		end

		index = index + 1
	end

	local event_data = {}

	table.array_to_table(event_data_array, #event_data_array, event_data)

	local event_name = self.dialogueLookupConcepts[event_id]

	self:append_event_to_queue(unit, event_name, event_data, identifier)
end

DialogueSystem.set_ignore_server_play_requests = function (self, value)
	self._ignore_server_play_requests = value
end

DialogueSystem.rpc_play_dialogue_event = function (self, channel_id, go_id, is_level_unit, level_name_hash, dialogue_id, dialogue_index, dialogue_rule_index)
	if self._ignore_server_play_requests then
		return
	end

	self:_play_dialogue_event_implementation(go_id, is_level_unit, level_name_hash, dialogue_id, dialogue_index, dialogue_rule_index)
end

DialogueSystem._play_dialogue_event_implementation = function (self, go_id, is_level_unit, level_name_hash, dialogue_id, dialogue_index, dialogue_rule_index, optional_query)
	local dialogue_actor_unit = Managers.state.unit_spawner:unit(go_id, is_level_unit, level_name_hash)
	local extension = self._unit_to_extension_map[dialogue_actor_unit]

	if not extension then
		return
	end

	local is_a_player = extension:is_a_player()

	if is_a_player and not HEALTH_ALIVE[dialogue_actor_unit] then
		return
	end

	local dialogue_name = NetworkLookup.dialogue_names[dialogue_id]
	local dialogue_template = self._dialogue_templates[dialogue_name]
	local dialogue_category = dialogue_template.category

	if not self:_is_playable_dialogue_category(dialogue_category) then
		return
	end

	if self:_prevent_on_demand_vo(dialogue_actor_unit, dialogue_category) then
		return
	end

	local is_currently_playing_dialogue = extension:is_currently_playing_dialogue()

	if is_currently_playing_dialogue then
		extension:stop_currently_playing_vo()
	end

	local sound_event, subtitles_event, sound_event_duration = extension:get_dialogue_event(dialogue_name, dialogue_index)
	local rule = self._tagquery_database:get_rule(dialogue_rule_index)
	local is_sequence = nil

	if sound_event then
		extension:set_last_query_sound_event(sound_event)
	end

	local dialogue = extension:request_empty_dialogue_table()

	table.merge(dialogue, dialogue_template)

	local speaker_name = extension:get_context().voice_template
	dialogue.speaker_name = speaker_name
	local wwise_route_key = dialogue.wwise_route

	if speaker_name == "tech_priest_a" and wwise_route_key == 1 then
		wwise_route_key = 21
	end

	if not DEDICATED_SERVER then
		local wwise_route = self._wwise_route_default

		if wwise_route_key ~= nil then
			wwise_route = self._wwise_routes[wwise_route_key]
		end

		if sound_event then
			if rule and (rule.pre_wwise_event or rule.post_wwise_event) then
				dialogue.dialogue_sequence = self:_create_sequence_events_table(rule.pre_wwise_event, wwise_route, sound_event, rule.post_wwise_event)
				dialogue.currently_playing_event_id = extension:play_event(dialogue.dialogue_sequence[1])
				is_sequence = true
			else
				local vo_event = {
					type = "vorbis_external",
					sound_event = sound_event,
					wwise_route = wwise_route
				}
				dialogue.currently_playing_event_id = extension:play_event(vo_event)
				is_sequence = false
			end

			local concurrent_wwise_event = rule and rule.concurrent_wwise_event

			if concurrent_wwise_event then
				dialogue.concurrent_wwise_event_id = self:play_wwise_event(extension, concurrent_wwise_event)
			end

			local distance_culled_wwise_routes = DialogueSettings.distance_culled_wwise_routes
			local subtitle_distance = distance_culled_wwise_routes[wwise_route_key]

			if subtitle_distance then
				dialogue.subtitle_distance = subtitle_distance
				dialogue.is_audible = self:is_dialogue_audible(dialogue_actor_unit, dialogue)
			else
				dialogue.is_audible = true
			end
		end

		local animation_event = "start_talking"

		self:_trigger_face_animation_event(dialogue_actor_unit, animation_event)
	end

	self._playing_units[dialogue_actor_unit] = extension
	dialogue.currently_playing_unit = dialogue_actor_unit
	dialogue.dialogue_timer = sound_event_duration
	dialogue.currently_playing_subtitle = subtitles_event
	dialogue.used_query = optional_query

	extension:set_is_currently_playing_dialogue(true)

	local category_config = DialogueCategoryConfig[dialogue_category]
	self._playing_dialogues[dialogue] = category_config

	table.insert(self._playing_dialogues_array, 1, dialogue)

	local sequence_table = dialogue.dialogue_sequence

	if sequence_table ~= nil and sequence_table[1].type == "vorbis_external" or not is_sequence then
		self._dialogue_system_subtitle:add_playing_localized_dialogue(speaker_name, dialogue)
	end
end

DialogueSystem._create_sequence_events_table = function (self, pre_wwise_event, wwise_route, sound_event, post_wwise_event)
	local sequence_events = {}

	if pre_wwise_event then
		local pre_wwise_event_table = {
			type = "resource_event",
			sound_event = pre_wwise_event
		}
		sequence_events[#sequence_events + 1] = pre_wwise_event_table
	end

	local vo_event = {
		type = "vorbis_external",
		sound_event = sound_event,
		wwise_route = wwise_route
	}
	sequence_events[#sequence_events + 1] = vo_event

	if post_wwise_event then
		local post_wwise_event_table = {
			type = "resource_event",
			sound_event = post_wwise_event
		}
		sequence_events[#sequence_events + 1] = post_wwise_event_table
	end

	return sequence_events
end

DialogueSystem.play_wwise_event = function (self, extension, wwise_event)
	local wwise_event_table = {
		type = "resource_event",
		sound_event = wwise_event
	}

	return extension:play_event(wwise_event_table)
end

DialogueSystem.rpc_interrupt_dialogue_event = function (self, channel_id, go_id, is_level_unit, level_name_hash)
	local unit = Managers.state.unit_spawner:unit(go_id, is_level_unit, level_name_hash)

	if not unit then
		return
	end

	local extension = self._unit_to_extension_map[unit]
	local dialogue = extension:get_currently_playing_dialogue()

	if dialogue then
		self:_interrupt_dialogue_event_implementation(unit, dialogue)
	end
end

DialogueSystem.send_dynamic_smart_tag = function (self, go_id, smart_tag)
	local tag_id = NetworkLookup.dynamic_smart_tags[smart_tag]

	Managers.state.game_session:send_rpc_clients("rpc_set_dynamic_smart_tag", go_id, tag_id)
end

DialogueSystem.rpc_set_dynamic_smart_tag = function (self, channel_id, go_id, tag_id)
	local enemy_unit = Managers.state.unit_spawner:unit(go_id)

	if not enemy_unit then
		return
	end

	local smart_tag = NetworkLookup.dynamic_smart_tags[tag_id]
	local extension = self._unit_to_extension_map[enemy_unit]

	extension:set_dynamic_smart_tag(smart_tag)
end

DialogueSystem._resolve_subtitle = function (self, subtitle_id)
	local subtitle_data = DialogueSettings.manual_subtitle_data[subtitle_id]
	local speaker_name = subtitle_data.speaker_name
	local duration = subtitle_data.duration
	local optional_delay = subtitle_data.optional_delay

	return speaker_name, duration, optional_delay
end

DialogueSystem.send_subtitle_event = function (self, currently_playing_subtitle)
	local subtitle_id = NetworkLookup.manual_subtitles[currently_playing_subtitle]
	local speaker_name, duration, optional_delay = self:_resolve_subtitle(subtitle_id)
	local dialogue_system_subtitle = self._dialogue_system_subtitle

	dialogue_system_subtitle:create_subtitle(currently_playing_subtitle, speaker_name, duration, optional_delay)
	Managers.state.game_session:send_rpc_clients("rpc_trigger_subtitle_event", subtitle_id)
end

DialogueSystem.rpc_trigger_subtitle_event = function (self, channel_id, subtitle_id)
	local currently_playing_subtitle = NetworkLookup.manual_subtitles[subtitle_id]
	local speaker_name, duration, optional_delay = self:_resolve_subtitle(subtitle_id)
	local dialogue_system_subtitle = self._dialogue_system_subtitle

	dialogue_system_subtitle:create_subtitle(currently_playing_subtitle, speaker_name, duration, optional_delay)
end

local AUDIBLE_CHECK_FREQUENCY = 0.1

DialogueSystem.is_dialogue_audible = function (self, unit, dialogue, t)
	if not DEDICATED_SERVER then
		if t and t < self._next_audible_check then
			return dialogue.is_audible
		else
			self._next_audible_check = self._next_audible_check + AUDIBLE_CHECK_FREQUENCY
			local speaker_pos = Unit.world_position(unit, 1)
			local player = Managers.player:local_player(1)
			local player_unit = player.player_unit

			if player_unit then
				local player_pos = Unit.world_position(player_unit, 1)
				local distance = Vector3.distance(speaker_pos, player_pos)
				local max_distance = dialogue.subtitle_distance
				local re_enable_distance = max_distance - 2

				if distance < re_enable_distance then
					return true
				elseif max_distance < distance then
					return false
				else
					return dialogue.is_audible
				end
			else
				return false
			end
		end
	end
end

DialogueSystem._remove_stopped_dialogue = function (self, unit, dialogue)
	local index = table.index_of(self._playing_dialogues_array, dialogue)

	table.remove(self._playing_dialogues_array, index)

	self._playing_dialogues[dialogue] = nil
	self._playing_units[unit] = nil

	self._dialogue_system_subtitle:remove_localized_dialogue(dialogue)
end

DialogueSystem._interrupt_dialogue_event_implementation = function (self, unit, dialogue)
	if not DEDICATED_SERVER then
		local currently_playing_event_id = dialogue.currently_playing_event_id

		self._dialogue_system_wwise:stop_if_playing(currently_playing_event_id)

		local animation_event = "stop_talking"

		self:_trigger_face_animation_event(unit, animation_event)
	end

	self:_remove_stopped_dialogue(unit, dialogue)

	local extension = self._unit_to_extension_map[unit]

	extension:set_is_currently_playing_dialogue(false)
end

local interrupt_dialogue_list = {}

DialogueSystem._process_query = function (self, query, t, is_a_delayed_query)
	local dialogue_actor_unit = query.query_context.source
	local extension = self._unit_to_extension_map[dialogue_actor_unit]

	if extension == nil then
		return
	end

	extension.last_query = query
	local result = query.result

	if result == nil then
		return
	end

	local dialogue_template = self._dialogue_templates[result]
	local on_pre_rule_execution = dialogue_template.on_pre_rule_execution
	local delay_vo = on_pre_rule_execution and on_pre_rule_execution.delay_vo

	if is_a_delayed_query then
		local still_valid = self:_is_rule_still_valid(query.validated_rule, extension)

		if not still_valid then
			return
		end
	end

	local evaluate_now = is_a_delayed_query or not delay_vo

	if evaluate_now then
		table.clear(interrupt_dialogue_list)

		local will_play = self:_can_query_play(query, dialogue_actor_unit, interrupt_dialogue_list)

		if not will_play then
			return
		end

		if not table.is_empty(interrupt_dialogue_list) then
			if dialogue_template.category == "vox_prio_0" then
				local wait_time = 0

				for playing_dialogue, _ in pairs(interrupt_dialogue_list) do
					local category_config = DialogueCategoryConfig[playing_dialogue.category]

					if category_config.queue_vox_prio_0 then
						local dialogue_length = playing_dialogue.dialogue_timer

						if wait_time < dialogue_length then
							wait_time = dialogue_length + 0.3
						end
					end
				end

				if wait_time > 0 then
					self._query_queue:queue_query(t + wait_time, query)

					return
				end
			end

			self:_execute_accepted_query(t, query, dialogue_actor_unit, extension, interrupt_dialogue_list)

			self._reject_queries_until = 0

			return
		end

		if t < self._reject_queries_until then
			return
		end

		local random_ignore_vo = on_pre_rule_execution and on_pre_rule_execution.random_ignore_vo

		if random_ignore_vo then
			local random_ignored_dialogue_end_t = self._random_ignored_dialogue_end_t
			local ignored_dialogue_end_t = random_ignored_dialogue_end_t[result]

			if ignored_dialogue_end_t and t < ignored_dialogue_end_t then
				return
			end

			local random_ignored_dialogue_failed_tries = self._random_ignored_dialogue_failed_tries

			if random_ignore_vo.chance < math.random() then
				if random_ignore_vo.max_failed_tries == 0 then
					return
				end

				local dialogue_failed_tries = (random_ignored_dialogue_failed_tries[result] or 0) + 1
				random_ignored_dialogue_failed_tries[result] = dialogue_failed_tries

				if dialogue_failed_tries < random_ignore_vo.max_failed_tries then
					random_ignored_dialogue_end_t[result] = t + random_ignore_vo.hold_for

					return
				end
			end

			random_ignored_dialogue_failed_tries[result] = 0
		end

		self:_execute_accepted_query(t, query, dialogue_actor_unit, extension, interrupt_dialogue_list)
	else
		local max_extra_randomized_duration = delay_vo.max_extra_randomized_duration
		local random_extra_delay_duration = max_extra_randomized_duration and math.random() * max_extra_randomized_duration or 0
		local delay = delay_vo.duration + random_extra_delay_duration

		self._query_queue:queue_query(t + delay, query)
	end
end

DialogueSystem._get_speaker_route_settings = function (self, query)
	local success_rule = query.validated_rule

	if success_rule.speaker_routing == nil then
		return
	end

	local speaker_target = success_rule.speaker_routing.target
	local target_unit = nil

	if speaker_target then
		target_unit = query.query_context.target_unit
	end

	local is_single_target = speaker_target == "dialogist" and target_unit

	return is_single_target, speaker_target, target_unit
end

DialogueSystem._execute_targeted_dialogue_event = function (self, target_unit, query, dialogue_id, dialogue_index, is_level_unit, go_id, level_name_hash)
	local targeted_player = Managers.state.player_unit_spawn:owner(target_unit)

	if not targeted_player then
		return
	end

	local peer_id = targeted_player:peer_id()
	local is_remote_player = targeted_player.remote

	if DEDICATED_SERVER then
		Managers.state.game_session:send_rpc_client("rpc_play_dialogue_event", peer_id, go_id, is_level_unit, level_name_hash, dialogue_id, dialogue_index, query.rule_index)
	elseif self._is_server and not is_remote_player then
		self:_play_dialogue_event_implementation(go_id, is_level_unit, level_name_hash, dialogue_id, dialogue_index, query.rule_index, query)
	elseif self._is_server and is_remote_player then
		Managers.state.game_session:send_rpc_client("rpc_play_dialogue_event", peer_id, go_id, is_level_unit, level_name_hash, dialogue_id, dialogue_index, query.rule_index)
	end
end

DialogueSystem._execute_dialogue_event = function (self, extension, query, dialogue_actor_unit)
	local event_name, event_duration, dialogue_index = extension:get_dialogue_event_index(query)

	if not event_name or not event_duration then
		return
	end

	local dialogue_id = NetworkLookup.dialogue_names[query.result]
	local is_level_unit, go_id, level_name_hash = Managers.state.unit_spawner:game_object_id_or_level_index(dialogue_actor_unit)

	self:_register_telemetry_events(extension, query, event_name)

	local is_single_target, _, target_unit = self:_get_speaker_route_settings(query)

	if is_single_target then
		self:_execute_targeted_dialogue_event(target_unit, query, dialogue_id, dialogue_index, is_level_unit, go_id, level_name_hash)
	else
		Managers.state.game_session:send_rpc_clients("rpc_play_dialogue_event", go_id, is_level_unit, level_name_hash, dialogue_id, dialogue_index, query.rule_index)
		self:_play_dialogue_event_implementation(go_id, is_level_unit, level_name_hash, dialogue_id, dialogue_index, query.rule_index, query)
	end
end

DialogueSystem._execute_interruptions = function (self, INTERRUPT_DIALOGUE_LIST)
	local game_session_manager = Managers.state.game_session

	for interrupt_dialogue, _ in pairs(INTERRUPT_DIALOGUE_LIST) do
		INTERRUPT_DIALOGUE_LIST[interrupt_dialogue] = nil
		local playing_unit = interrupt_dialogue.currently_playing_unit
		local is_level_unit, unit_id, level_name_hash = Managers.state.unit_spawner:game_object_id_or_level_index(playing_unit)

		game_session_manager:send_rpc_clients("rpc_interrupt_dialogue_event", unit_id, is_level_unit, level_name_hash)
		self:_interrupt_dialogue_event_implementation(playing_unit, interrupt_dialogue)
	end
end

DialogueSystem._execute_accepted_query = function (self, t, query, dialogue_actor_unit, extension, INTERRUPT_DIALOGUE_LIST)
	self:_execute_interruptions(INTERRUPT_DIALOGUE_LIST)
	self:_execute_dialogue_event(extension, query, dialogue_actor_unit)
end

DialogueSystem._register_telemetry_events = function (self, extension, query, event_name)
	if DEDICATED_SERVER then
		Managers.telemetry_reporters:reporter("voice_over_event_triggered"):register_event(query.validated_rule.name)
	end
end

DialogueSystem._can_query_play = function (self, query, dialogue_actor_unit, INTERRUPT_DIALOGUE_LIST)
	local dialogue_template = self._dialogue_templates[query.result]
	local dialogue_category = dialogue_template.category
	local category_config = DialogueCategoryConfig[dialogue_category]
	local playable_during_category = category_config.playable_during_category
	local interrupt_self = category_config.interrupt_self
	local playing_dialogues = self._playing_dialogues
	local will_play = true

	for playing_dialogue, playing_dialogue_category_config in pairs(playing_dialogues) do
		local mutually_exclusive = playing_dialogue_category_config.mutually_exclusive
		local interrupted_by = playing_dialogue_category_config.interrupted_by

		if mutually_exclusive and dialogue_category == playing_dialogue.category then
			will_play = false

			break
		elseif playing_dialogue.currently_playing_unit == dialogue_actor_unit and not interrupt_self then
			will_play = false

			break
		elseif interrupted_by[dialogue_category] then
			INTERRUPT_DIALOGUE_LIST[playing_dialogue] = true
		elseif not playable_during_category[playing_dialogue.category] then
			will_play = false

			break
		end
	end

	return will_play, INTERRUPT_DIALOGUE_LIST
end

DialogueSystem._is_rule_still_valid = function (self, rule, extension)
	local criterias = rule.real_criterias

	for i = 1, #criterias do
		local criteria = criterias[i]
		local criteria_type = criteria[1]

		if criteria_type == "user_memory" or criteria_type == "faction_memory" then
			local memory_name = criteria[2]
			local current_memory = extension:read_from_memory(criteria_type, memory_name)

			if current_memory then
				local memory_ok = self:_check_memory(criteria, current_memory)

				if not memory_ok then
					return false
				end
			end
		end
	end

	return true
end

DialogueSystem._check_memory = function (self, criteria, current_memory)
	if criteria[3] == "TIMEDIFF" then
		if criteria[4] == "GT" then
			return current_memory + criteria[5] < self._LOCAL_GAMETIME
		elseif criteria[4] == "LT" then
			return self._LOCAL_GAMETIME < current_memory + criteria[5]
		end
	end

	return true
end

DialogueSystem._trigger_face_animation_event = function (self, unit, animation_event)
	local visual_loadout_extension = ScriptUnit.has_extension(unit, "visual_loadout_system")

	if visual_loadout_extension then
		local slot_name = "slot_body_face"
		local face_unit = visual_loadout_extension:unit_3p_from_slot(slot_name)

		if face_unit and Unit.has_animation_state_machine(face_unit) then
			local has_animation_event = Unit.has_animation_event(face_unit, animation_event)

			if has_animation_event then
				local event_index = Unit.animation_event(face_unit, animation_event)

				Unit.animation_event_by_index(face_unit, event_index)
			end
		end
	else
		local extension_manager = self._extension_manager
		local component_system = extension_manager:system("component_system")
		local player_customization_components = component_system:get_components(unit, "PlayerCustomization")
		local player_customization_component = player_customization_components[1]

		if player_customization_component then
			local face_unit = player_customization_component:unit_in_slot("slot_body_face")

			if Unit.is_valid(face_unit) and Unit.has_animation_state_machine(face_unit) then
				local state_machine_override = player_customization_component:get_face_sm_override()

				if state_machine_override ~= nil and state_machine_override ~= "" then
					Unit.set_animation_state_machine(face_unit, state_machine_override)

					local has_animation_event = Unit.has_animation_event(face_unit, animation_event)

					if has_animation_event then
						local event_index = Unit.animation_event(face_unit, animation_event)

						Unit.animation_event_by_index(face_unit, event_index)
					end
				end
			end
		end
	end
end

DialogueSystem._load_player_resource = function (self, profile_name)
	local player_load_files = DialogueSettings.player_load_files[profile_name]

	if player_load_files then
		local loaded_player_files_tracker = self._loaded_player_files_tracker
		local has_loaded = false

		for i = 1, #player_load_files do
			local filename = player_load_files[i]

			if not loaded_player_files_tracker[filename] then
				loaded_player_files_tracker[filename] = 1

				self:_load_dialogue_resource(filename)

				has_loaded = true
			else
				loaded_player_files_tracker[filename] = loaded_player_files_tracker[filename] + 1
			end
		end

		if has_loaded and self._is_rule_db_enabled then
			self._tagquery_database:finalize_rules()
		end
	end
end

DialogueSystem._unload_player_resource = function (self, profile_name)
	local unload_candidates = DialogueSettings.player_load_files[profile_name]

	if unload_candidates then
		local loaded_player_files_tracker = self._loaded_player_files_tracker
		local vo_sources_cache = self._vo_sources_cache
		local tagquery_loader = self._tagquery_loader

		for i = 1, #unload_candidates do
			local filename = unload_candidates[i]
			loaded_player_files_tracker[filename] = loaded_player_files_tracker[filename] - 1

			if loaded_player_files_tracker[filename] == 0 then
				loaded_player_files_tracker[filename] = nil

				vo_sources_cache:remove_rule_file(filename)

				if self._is_rule_db_enabled then
					local rule_file_path = DialogueSettings.default_rule_path .. filename

					tagquery_loader:unload_file(rule_file_path)
				end
			end
		end
	end
end

DialogueSystem._load_dialogue_resources = function (self, file_names)
	for i = 1, #file_names do
		local file_name = file_names[i]

		self:_load_dialogue_resource(file_name)
	end
end

DialogueSystem._load_dialogue_resource = function (self, file_name)
	local rule_file_path = DialogueSettings.default_rule_path .. file_name

	if Application.can_get_resource("lua", rule_file_path) then
		self._vo_sources_cache:add_rule_file(file_name)

		if self._is_rule_db_enabled then
			self._tagquery_loader:load_file(rule_file_path)
		end
	end
end

DialogueSystem.dialogue_system_subtitle = function (self)
	return self._dialogue_system_subtitle
end

DialogueSystem.mission_board = function (self)
	if self._is_server then
		if self._missions_board_promise then
			return nil, nil
		end

		local t = Managers.time:time("main")

		if t - self._time_since_mission_fetch < 10 then
			return self._missions_data, self._missions
		end

		self._missions_board_promise = Managers.data_service.mission_board:fetch()

		self._missions_board_promise:next(function (data)
			self._missions_data = data
			self._missions = data.missions
			self._missions_board_promise = nil
			self._time_since_mission_fetch = t
		end)

		return self._missions_data, self._missions
	end
end

return DialogueSystem
