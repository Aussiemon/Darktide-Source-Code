require("scripts/extension_systems/cinematic_scene/cinematic_scene_extension")

local Breeds = require("scripts/settings/breed/breeds")
local CinematicSceneSettings = require("scripts/settings/cinematic_scene/cinematic_scene_settings")
local CinematicSceneTemplates = require("scripts/settings/cinematic_scene/cinematic_scene_templates")
local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local UIProfileSpawner = require("scripts/managers/ui/ui_profile_spawner")
local UIUnitSpawner = require("scripts/managers/ui/ui_unit_spawner")
local HOST_TYPES = MatchmakingConstants.HOST_TYPES
local CINEMATIC_NAMES = CinematicSceneSettings.CINEMATIC_NAMES
local CinematicSceneSystem = class("CinematicSceneSystem", "ExtensionSystemBase")
local NUM_CPT_PER_UNIT = 1
local NUM_PLAYER_SPAWN = 4
local CLIENT_RPCS = {
	"rpc_play_cutscene",
	"rpc_cinematic_intro_played"
}
local SERVER_RPCS = {
	"rpc_request_play_cutscene"
}
local CINEMATIC_VIEWS = {
	[CINEMATIC_NAMES.intro_abc] = "cutscene_view",
	[CINEMATIC_NAMES.outro_win] = "cutscene_view",
	[CINEMATIC_NAMES.outro_fail] = "cutscene_view",
	[CINEMATIC_NAMES.cutscene_1] = "cutscene_view",
	[CINEMATIC_NAMES.cutscene_2] = "cutscene_view",
	[CINEMATIC_NAMES.cutscene_3] = "cutscene_view",
	[CINEMATIC_NAMES.cutscene_4] = "cutscene_view",
	[CINEMATIC_NAMES.cutscene_5] = "cutscene_view",
	[CINEMATIC_NAMES.cutscene_5_hub] = "cutscene_view",
	[CINEMATIC_NAMES.cutscene_6] = "cutscene_view",
	[CINEMATIC_NAMES.cutscene_7] = "cutscene_view",
	[CINEMATIC_NAMES.cutscene_8] = "cutscene_view",
	[CINEMATIC_NAMES.cutscene_9] = "cutscene_view",
	[CINEMATIC_NAMES.cutscene_10] = "cutscene_view",
	[CINEMATIC_NAMES.path_of_trust_01] = "cutscene_view",
	[CINEMATIC_NAMES.path_of_trust_02] = "cutscene_view",
	[CINEMATIC_NAMES.path_of_trust_03] = "cutscene_view",
	[CINEMATIC_NAMES.path_of_trust_04] = "cutscene_view",
	[CINEMATIC_NAMES.path_of_trust_05] = "cutscene_view",
	[CINEMATIC_NAMES.path_of_trust_06] = "cutscene_view",
	[CINEMATIC_NAMES.path_of_trust_07] = "cutscene_view",
	[CINEMATIC_NAMES.path_of_trust_08] = "cutscene_view",
	[CINEMATIC_NAMES.path_of_trust_09] = "cutscene_view",
	[CINEMATIC_NAMES.traitor_captain_intro] = "cutscene_view"
}

local function get_origin_level_names(cinematic_name)
	local component_system = Managers.state.extension:system("component_system")
	local scenes = component_system:get_units_from_component_name("CinematicScene")
	local origin_level_names = {}

	for _, scene_unit in ipairs(scenes) do
		local scene_components = component_system:get_components(scene_unit, "CinematicScene")
		local scene_component = scene_components[1]
		local scene_unit_type = scene_component:unit_type()
		local origin_level_name = scene_component:origin_level_name()
		local scene_cinematic_name = scene_component:cinematic_name()

		if scene_unit_type == "destination" and origin_level_name and scene_cinematic_name == cinematic_name then
			origin_level_names[#origin_level_names + 1] = origin_level_name
		end
	end

	return origin_level_names
end

CinematicSceneSystem.init = function (self, extension_init_context, system_init_data, ...)
	CinematicSceneSystem.super.init(self, extension_init_context, system_init_data, ...)

	local is_server = extension_init_context.is_server
	self._is_server = is_server
	self._in_hub = Managers.connection:host_type() == HOST_TYPES.hub_server
	local world = extension_init_context.world
	self._world = world
	self._level = nil
	self._cinematics = self:_fetch_settings(system_init_data.mission, extension_init_context.circumstance_name)
	self._cinematics_setups = {}
	self._cinematics_left_to_play = 0
	self._current_cinematic_name = CINEMATIC_NAMES.none
	self._unit_spawner = UIUnitSpawner:new(world)
	self._spawn_slots = {}
	self._intro_played = false
	self._intro_loading_started = false

	if Managers.ui and Managers.ui:view_active("cutscene_view") then
		Managers.ui:close_view("cutscene_view", true)
	end

	local network_event_delegate = self._network_event_delegate

	if network_event_delegate then
		if is_server then
			network_event_delegate:register_session_events(self, unpack(SERVER_RPCS))
		else
			network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
		end
	end

	local mission = system_init_data.mission
	local mission_cinematics = mission.cinematics or {}

	if not mission_cinematics[CINEMATIC_NAMES.intro_abc] then
		self._intro_played = true
		self._skip_intro_cinematic = true
	end
end

CinematicSceneSystem._on_preload_cinematic = function (self, preload_id)
	if self._skip_intro_cinematic then
		Managers.event:trigger("cutscene_loaded_all_clients", true, preload_id)
	elseif not self._intro_played and not self._intro_loading_started then
		self:load_cutscene(CINEMATIC_NAMES.intro_abc, preload_id)
	end
end

CinematicSceneSystem._on_spawn_group_loaded = function (self)
	if self._intro_played == false then
		self:play_cutscene(CINEMATIC_NAMES.intro_abc)
	end
end

CinematicSceneSystem._fetch_settings = function (self, mission, circumstance_name)
	local original_settings = mission.cinematics or {}
	local circumstance_template = CircumstanceTemplates[circumstance_name]
	local mission_overrides = circumstance_template.mission_overrides
	local circumstance_settings = mission_overrides and mission_overrides.cinematics or nil

	return circumstance_settings or original_settings
end

CinematicSceneSystem.destroy = function (self, ...)
	self:_clear_spawn_slots()

	if self._is_server then
		local current_cinematic_name = self._current_cinematic_name

		if current_cinematic_name ~= CINEMATIC_NAMES.none then
			self:_activate_view(CINEMATIC_NAMES.none)
			self:_set_cinematic_name(CINEMATIC_NAMES.none)
		end

		Managers.event:unregister(self, "spawn_group_loaded")
		Managers.event:unregister(self, "preload_cinematic")
	end

	local network_event_delegate = self._network_event_delegate

	if network_event_delegate then
		if self._is_server then
			network_event_delegate:unregister_events(unpack(SERVER_RPCS))
		else
			network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
		end
	end

	CinematicSceneSystem.super.destroy(self, ...)
end

CinematicSceneSystem.on_gameplay_post_init = function (self, level)
	self._level = level

	if self._is_server then
		Managers.event:register(self, "spawn_group_loaded", "_on_spawn_group_loaded")
		Managers.event:register(self, "preload_cinematic", "_on_preload_cinematic")

		local host_type = Managers.multiplayer_session:host_type()

		if host_type == HOST_TYPES.player or host_type == HOST_TYPES.singleplay or host_type == HOST_TYPES.singleplay_backend_session then
			self:_on_spawn_group_loaded()
		end
	end
end

CinematicSceneSystem.rpc_cinematic_intro_played = function (self)
	self._intro_played = true
end

CinematicSceneSystem.intro_played = function (self)
	return self._intro_played
end

CinematicSceneSystem._can_play = function (self, cinematic_name, check_currently_playing, check_sub_cinematics, check_cinematics_setup)
	if GameParameters.skip_cinematics then
		return false
	end

	if check_currently_playing then
		local current_cinematic_name = self._current_cinematic_name

		if current_cinematic_name ~= CINEMATIC_NAMES.none then
			return false
		end
	end

	if check_sub_cinematics then
		local sub_cinematics = self._cinematics[cinematic_name]

		if not sub_cinematics then
			return false
		end
	end

	if check_cinematics_setup then
		local sub_cinematics_setup = self._cinematics_setups[cinematic_name]

		if not sub_cinematics_setup then
			return false
		end
	end

	return true
end

CinematicSceneSystem._cinematic_played = function (self, cinematic_name, cinematic_category)
	self._cinematics_left_to_play = self._cinematics_left_to_play - 1

	if self._cinematics_left_to_play == 0 then
		self:_uninitialize_cutscene_characters(cinematic_name)
		self:_activate_view(CINEMATIC_NAMES.none)
		self:_set_cinematic_name(CINEMATIC_NAMES.none)
		self:_send_cinematic_played_flow_event(cinematic_name)
		self:_uninitialize_cinematic(cinematic_name)

		if self._is_server then
			Managers.event:trigger("intro_cinematic_played", cinematic_name)
		end

		local host_type = Managers.multiplayer_session:host_type()

		if host_type == HOST_TYPES.singleplay then
			local cinematic_template = CinematicSceneTemplates[cinematic_name]

			if cinematic_template.mission_outro then
				Managers.event:trigger("mission_outro_played")
			end
		end
	end
end

CinematicSceneSystem._send_cinematic_played_flow_event = function (self, cinematic_name)
	local sub_cinematics = self._cinematics[cinematic_name]
	local sub_cinematics_setup = self._cinematics_setups[cinematic_name]

	for _, cinematic_category in ipairs(sub_cinematics) do
		local cinematic_setup = sub_cinematics_setup[cinematic_category]

		if cinematic_setup and cinematic_setup.is_valid then
			Unit.flow_event(cinematic_setup.scene_unit_origin, "lua_cinematic_played_server")
			Unit.flow_event(cinematic_setup.scene_unit_destination, "lua_cinematic_played_server")

			break
		end
	end
end

CinematicSceneSystem._on_level_loaded = function (self, cinematic_name)
	return
end

CinematicSceneSystem.load_cutscene = function (self, cinematic_name, preload_id)
	local origin_level_names = get_origin_level_names(cinematic_name)

	if #origin_level_names == 0 then
		Managers.event:trigger("cutscene_loaded_all_clients", true, preload_id)
	else
		local template = CinematicSceneTemplates[cinematic_name]
		local hotjoin_only = template.hotjoin_only
		local on_level_loaded_cb = callback(self, "_on_level_loaded", cinematic_name)

		Managers.state.cinematic:load_levels(cinematic_name, origin_level_names, on_level_loaded_cb, nil, hotjoin_only, true, preload_id)

		self._intro_loading_started = true
	end
end

CinematicSceneSystem.play_cutscene = function (self, cinematic_name, client_channel_id)
	if client_channel_id ~= nil then
		local cinematic_name_id = NetworkLookup.cinematic_scene_names[cinematic_name]

		RPC.rpc_play_cutscene(client_channel_id, cinematic_name_id)
	elseif self:_can_play(cinematic_name, true) then
		local require_levels = self:_prepare_cutscene_levels(cinematic_name)

		if not require_levels then
			self:_play_cutscene(cinematic_name)
		else
			local is_loading = true

			self:_activate_view(cinematic_name, is_loading)
			self:_set_cinematic_name(cinematic_name)
		end
	end

	if cinematic_name == CINEMATIC_NAMES.intro_abc then
		self._intro_played = true
		self._intro_loading_started = true
	end
end

CinematicSceneSystem.request_play_cutscene = function (self, cinematic_name)
	local cinematic_name_id = NetworkLookup.cinematic_scene_names[cinematic_name]

	Managers.connection:send_rpc_server("rpc_request_play_cutscene", cinematic_name_id)
end

CinematicSceneSystem._on_level_prepared = function (self, cinematic_name, client_channel_id)
	self:_play_cutscene(cinematic_name, client_channel_id)

	if client_channel_id then
		self:_uninitialize_cinematic(cinematic_name)
	end
end

CinematicSceneSystem._play_cutscene = function (self, cinematic_name, client_channel_id)
	self:_initialize_cinematic(cinematic_name)

	if self:_can_play(cinematic_name, false, true, true) then
		local queue_filled = self:_queue_cinematics(cinematic_name, client_channel_id)

		if queue_filled and not client_channel_id then
			self:_activate_view(cinematic_name)
			self:_set_cinematic_name(cinematic_name)
			self:_initialize_cutscene_characters(cinematic_name)
		end

		if self._is_server then
			Managers.event:trigger("intro_cinematic_started", cinematic_name)
		end
	else
		self:_activate_view(CINEMATIC_NAMES.none)
		self:_set_cinematic_name(CINEMATIC_NAMES.none)
		self:_uninitialize_cinematic(cinematic_name)

		if self._is_server then
			Managers.event:trigger("intro_cinematic_played")
		end
	end
end

CinematicSceneSystem._prepare_cutscene_levels = function (self, cinematic_name, client_channel_id)
	local origin_level_names = get_origin_level_names(cinematic_name)

	if #origin_level_names == 0 then
		return false
	else
		local template = CinematicSceneTemplates[cinematic_name]
		local hotjoin_only = template.hotjoin_only
		local on_level_prepared_callback = callback(self, "_on_level_prepared", cinematic_name, client_channel_id)

		Managers.state.cinematic:load_levels(cinematic_name, origin_level_names, on_level_prepared_callback, client_channel_id, hotjoin_only, false)

		return true
	end
end

CinematicSceneSystem.current_cinematic_name = function (self)
	return self._current_cinematic_name
end

CinematicSceneSystem._queue_cinematics = function (self, cinematic_name, client_channel_id)
	local sub_cinematics = self._cinematics[cinematic_name]
	local sub_cinematics_setup = self._cinematics_setups[cinematic_name]

	for _, cinematic_category in ipairs(sub_cinematics) do
		local cinematic_setup = sub_cinematics_setup[cinematic_category]

		if cinematic_setup and cinematic_setup.is_valid then
			local scene_unit_destination = cinematic_setup.scene_unit_destination
			local scene_unit_origin = cinematic_setup.scene_unit_origin
			local played_callback = callback(self, "_cinematic_played", cinematic_name, cinematic_category)
			local template = CinematicSceneTemplates[cinematic_name]
			local hotjoin_only = template.hotjoin_only
			local is_skippable = template.is_skippable
			local wait_for_player_input = template.wait_for_player_input
			local popup_info = template.popup_info
			local success = Managers.state.cinematic:queue_story(cinematic_name, cinematic_category, scene_unit_origin, scene_unit_destination, played_callback, client_channel_id, hotjoin_only, is_skippable, wait_for_player_input, popup_info)

			if success then
				self._cinematics_left_to_play = self._cinematics_left_to_play + 1
			end
		end
	end

	return self._cinematics_left_to_play > 0
end

CinematicSceneSystem._initialize_cinematic = function (self, cinematic_name)
	local sub_cinematics = self._cinematics[cinematic_name]

	if sub_cinematics then
		local sub_cinematics_setup = self:_initialize_sub_cinematics(cinematic_name, sub_cinematics)

		for cinematic_category, cinematic_setup in pairs(sub_cinematics_setup) do
			local player_spawner_units = cinematic_setup.player_spawner_units

			if #player_spawner_units > 0 then
				local camera = cinematic_setup.camera

				self:_setup_spawn_slots(self._world, cinematic_name, camera, player_spawner_units)
				self:_assign_player_slots(cinematic_name)
			end
		end

		self._cinematics_setups[cinematic_name] = sub_cinematics_setup
	else
		self._cinematics_setups[cinematic_name] = {}
	end
end

CinematicSceneSystem._uninitialize_cinematic = function (self, cinematic_name)
	Managers.state.cinematic:unload_levels(cinematic_name)
	table.clear(self._cinematics_setups[cinematic_name])
end

CinematicSceneSystem._initialize_sub_cinematics = function (self, cinematic_name, sub_cinematics)
	local sub_cinematics_setup = {}

	for _, cinematic_category in ipairs(sub_cinematics) do
		local new_cinematic_setup = {
			scene_unit_origin = nil,
			scene_unit_destination = nil,
			scene_level_destination = self._level,
			scene_level_origin = nil,
			camera_unit = nil,
			camera = nil,
			player_spawner_units = {},
			is_valid = true
		}
		sub_cinematics_setup[cinematic_category] = new_cinematic_setup
	end

	local component_system = Managers.state.extension:system("component_system")
	local scenes = component_system:get_units_from_component_name("CinematicScene")

	for _, scene_unit in ipairs(scenes) do
		local scene_components = component_system:get_components(scene_unit, "CinematicScene")
		local scene_component = scene_components[1]
		local cinematic_category = scene_component:cinematic_category()
		local scene_unit_type = scene_component:unit_type()
		local sub_cinematic_category_setup = sub_cinematics_setup[cinematic_category]

		if cinematic_category ~= "none" and sub_cinematic_category_setup then
			if scene_unit_type == "origin" then
				sub_cinematic_category_setup.scene_unit_origin = scene_unit
			elseif scene_unit_type == "destination" then
				sub_cinematic_category_setup.scene_unit_destination = scene_unit
			end
		end
	end

	local cameras = component_system:get_units_from_component_name("CutsceneCamera")

	for _, camera_unit in ipairs(cameras) do
		local camera_components = component_system:get_components(camera_unit, "CutsceneCamera")
		local camera_component = camera_components[1]
		local cinematic_category = camera_component:cinematic_category()
		local sub_cinematic_category_setup = sub_cinematics_setup[cinematic_category]

		if cinematic_category ~= "none" and sub_cinematic_category_setup then
			local camera = Unit.camera(camera_unit, "camera")

			if camera then
				sub_cinematic_category_setup.camera_unit = camera_unit
				sub_cinematic_category_setup.camera = camera
			end
		end
	end

	local cinematic_spawners = component_system:get_units_from_component_name("CinematicPlayerSpawner")

	for _, cinematic_spawner_unit in ipairs(cinematic_spawners) do
		local cinematic_spawner_components = component_system:get_components(cinematic_spawner_unit, "CinematicPlayerSpawner")
		local cinematic_spawner_component = cinematic_spawner_components[1]
		local spawner_cinematic_name = cinematic_spawner_component:cinematic_name()
		local valid_cinematic = spawner_cinematic_name ~= CINEMATIC_NAMES.none and spawner_cinematic_name == cinematic_name

		if valid_cinematic then
			for _, cinematic_category in ipairs(sub_cinematics) do
				local sub_cinematic_category_setup = sub_cinematics_setup[cinematic_category]
				local player_spawner_units = sub_cinematic_category_setup.player_spawner_units
				player_spawner_units[#player_spawner_units + 1] = cinematic_spawner_unit
			end
		end
	end

	for cinematic_category, cinematic_setup in pairs(sub_cinematics_setup) do
		if not cinematic_setup.scene_unit_origin then
			cinematic_setup.is_valid = false
		end

		if not cinematic_setup.scene_unit_destination then
			cinematic_setup.is_valid = false
		end

		if not cinematic_setup.camera_unit then
			cinematic_setup.is_valid = false
		end
	end

	return sub_cinematics_setup
end

CinematicSceneSystem._get_free_slot_id = function (self)
	local spawn_slots = self._spawn_slots

	for i = 1, #spawn_slots do
		local slot = spawn_slots[i]

		if not slot.occupied then
			return i
		end
	end
end

CinematicSceneSystem._player_slot_id = function (self, unique_id)
	local spawn_slots = self._spawn_slots

	for i = 1, #spawn_slots do
		local slot = spawn_slots[i]

		if slot.occupied and slot.unique_id == unique_id then
			return i
		end
	end
end

CinematicSceneSystem._clear_spawn_slots = function (self)
	local spawn_slots = self._spawn_slots
	local num_slots = #spawn_slots

	for i = 1, num_slots do
		local slot = spawn_slots[i]

		if slot.occupied then
			self:_reset_spawn_slot(slot)
		end
	end

	table.clear(self._spawn_slots)
end

CinematicSceneSystem._setup_spawn_slots = function (self, world, cinematic_name, camera, player_spawner_units)
	local unit_spawner = self._unit_spawner
	local template = CinematicSceneTemplates[cinematic_name]
	local ignored_slots = template.ignored_slots
	local spawn_slots = {}

	if #player_spawner_units == NUM_PLAYER_SPAWN then
		for i = 1, NUM_PLAYER_SPAWN do
			local spawn_point_unit = player_spawner_units[i]
			local initial_position = Unit.world_position(spawn_point_unit, 1)
			local initial_rotation = Unit.world_rotation(spawn_point_unit, 1)
			local profile_spawner = UIProfileSpawner:new("CinematicSceneSystem_" .. i, world, camera, unit_spawner)

			for j = 1, #ignored_slots do
				local slot_name = ignored_slots[j]

				profile_spawner:ignore_slot(slot_name)
			end

			local spawn_slot = {
				index = i,
				boxed_rotation = QuaternionBox(initial_rotation),
				boxed_position = Vector3Box(initial_position),
				profile_spawner = profile_spawner,
				spawn_point_unit = spawn_point_unit
			}
			spawn_slots[i] = spawn_slot
		end
	end

	self._spawn_slots = spawn_slots
end

CinematicSceneSystem._update_player_slots = function (self, dt, t, input_service)
	local spawn_slots = self._spawn_slots

	for i = 1, #spawn_slots do
		local slot = spawn_slots[i]

		if slot.occupied then
			local profile_spawner = slot.profile_spawner

			profile_spawner:update(dt, t, input_service)
		end
	end
end

CinematicSceneSystem._assign_player_slots = function (self, cinematic_name)
	local player_manager = Managers.player
	local players = player_manager:players()
	local spawn_slots = self._spawn_slots

	for unique_id, player in pairs(players) do
		local slot_id = self:_player_slot_id(unique_id)

		if not slot_id then
			slot_id = self:_get_free_slot_id()
			local slot = spawn_slots[slot_id]

			if slot then
				self:_assign_player_to_slot(cinematic_name, player, slot)
			end
		end
	end
end

CinematicSceneSystem._assign_player_to_slot = function (self, cinematic_name, player, slot)
	local unique_id = player:unique_id()
	local profile = player:profile()
	local boxed_position = slot.boxed_position
	local boxed_rotation = slot.boxed_rotation
	local spawn_position = Vector3Box.unbox(boxed_position)
	local spawn_rotation = QuaternionBox.unbox(boxed_rotation)
	local profile_spawner = slot.profile_spawner

	profile_spawner:spawn_profile(profile, spawn_position, spawn_rotation)

	local archetype_settings = profile.archetype
	local archetype_name = archetype_settings.name
	local breed_name = archetype_settings.breed
	local breed_settings = Breeds[breed_name]
	local mission_intro_state_machine = breed_settings.mission_intro_state_machine

	profile_spawner:assign_state_machine(mission_intro_state_machine)

	local template = CinematicSceneTemplates[cinematic_name]
	local animations_per_archetype = template.animations_per_archetype
	local animations_settings = animations_per_archetype[archetype_name]
	local anim_index = math.random(1, #animations_settings)
	local animation_event = animations_settings[anim_index]

	profile_spawner:assign_animation_event(animation_event)

	slot.occupied = true
	slot.player = player
	slot.unique_id = unique_id
end

CinematicSceneSystem._reset_spawn_slot = function (self, slot)
	local profile_spawner = slot.profile_spawner

	if profile_spawner then
		profile_spawner:destroy()
	end

	slot.unique_id = nil
	slot.profile_spawner = nil
	slot.player = nil
end

CinematicSceneSystem._initialize_cutscene_characters = function (self, cinematic_name)
	if not DEDICATED_SERVER then
		local cutscene_character_system = Managers.state.extension:system("cutscene_character_system")

		cutscene_character_system:initialize_characters_for_cinematic(cinematic_name)
	end
end

CinematicSceneSystem._uninitialize_cutscene_characters = function (self, cinematic_name)
	if not DEDICATED_SERVER then
		local cutscene_character_system = Managers.state.extension:system("cutscene_character_system")

		cutscene_character_system:uninitialize_characters_for_cinematic(cinematic_name)
	end
end

CinematicSceneSystem._set_cinematic_name = function (self, cinematic_name)
	self._current_cinematic_name = cinematic_name
end

CinematicSceneSystem.client_set_scene = function (self, cinematic_name)
	self:_initialize_cutscene_characters(cinematic_name)
	self:_activate_view(cinematic_name)
	self:_set_cinematic_name(cinematic_name)

	if cinematic_name == CINEMATIC_NAMES.intro_abc then
		self._intro_played = true

		Log.info("CinematicSceneSystem", "client_set_scene, intro_played= true")
	end
end

CinematicSceneSystem.client_unset_scene = function (self, cinematic_name)
	self:_uninitialize_cutscene_characters(cinematic_name)
	self:_activate_view(CINEMATIC_NAMES.none)
	self:_set_cinematic_name(CINEMATIC_NAMES.none)
end

CinematicSceneSystem.is_active = function (self)
	return self._current_cinematic_name ~= CINEMATIC_NAMES.none
end

CinematicSceneSystem.is_cinematic_active = function (self, cinematic_name)
	return self._current_cinematic_name == cinematic_name
end

CinematicSceneSystem.intro_loading_started = function (self)
	return self._intro_loading_started
end

CinematicSceneSystem._activate_view = function (self, cinematic_name)
	local ui_manager = Managers.ui

	if ui_manager then
		local activate = cinematic_name ~= CINEMATIC_NAMES.none
		local current_cinematic_name = self._current_cinematic_name
		local is_active = self:is_active()

		if activate and not is_active then
			local view = CINEMATIC_VIEWS[cinematic_name]

			if not ui_manager:view_active(view) then
				local view_context = {}
				local template = CinematicSceneTemplates[cinematic_name]
				local use_transition_ui = template.use_transition_ui
				local no_transition_ui = use_transition_ui == false
				local view_settings_override = no_transition_ui and {
					use_transition_ui = false
				}

				ui_manager:open_view(view, nil, nil, nil, nil, view_context, view_settings_override)
			end
		elseif not activate and is_active then
			local view = CINEMATIC_VIEWS[current_cinematic_name]

			if ui_manager:view_active(view) then
				local force_close = true

				ui_manager:close_view(view, force_close)
			end
		end
	end
end

CinematicSceneSystem.rpc_play_cutscene = function (self, channel_id, cinematic_name_id)
	local cinematic_name = NetworkLookup.cinematic_scene_names[cinematic_name_id]

	self:play_cutscene(cinematic_name)
end

CinematicSceneSystem.rpc_request_play_cutscene = function (self, channel_id, cinematic_name_id)
	local cinematic_name = NetworkLookup.cinematic_scene_names[cinematic_name_id]

	self:play_cutscene(cinematic_name, channel_id)
end

return CinematicSceneSystem
