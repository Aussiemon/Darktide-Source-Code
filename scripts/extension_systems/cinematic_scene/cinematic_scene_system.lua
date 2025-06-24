-- chunkname: @scripts/extension_systems/cinematic_scene/cinematic_scene_system.lua

require("scripts/extension_systems/cinematic_scene/cinematic_scene_extension")

local Breeds = require("scripts/settings/breed/breeds")
local CinematicSceneSettings = require("scripts/settings/cinematic_scene/cinematic_scene_settings")
local CinematicSceneTemplates = require("scripts/settings/cinematic_scene/cinematic_scene_templates")
local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local HOST_TYPES = MatchmakingConstants.HOST_TYPES
local CINEMATIC_NAMES = CinematicSceneSettings.CINEMATIC_NAMES
local CinematicSceneSystem = class("CinematicSceneSystem", "ExtensionSystemBase")
local NUM_CPT_PER_UNIT = 1
local CLIENT_RPCS = {
	"rpc_play_cutscene",
	"rpc_cinematic_intro_played",
}
local SERVER_RPCS = {
	"rpc_request_play_cutscene",
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
	[CINEMATIC_NAMES.traitor_captain_intro] = "cutscene_view",
	[CINEMATIC_NAMES.hub_location_intro_barber] = "cutscene_view",
	[CINEMATIC_NAMES.hub_location_intro_mission_board] = "cutscene_view",
	[CINEMATIC_NAMES.hub_location_intro_training_grounds] = "cutscene_view",
	[CINEMATIC_NAMES.hub_location_intro_contracts] = "cutscene_view",
	[CINEMATIC_NAMES.hub_location_intro_crafting] = "cutscene_view",
	[CINEMATIC_NAMES.hub_location_intro_gun_shop] = "cutscene_view",
}

local function _origin_level_names(cinematic_name)
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
	self._cinematics = self:_mission_settings(system_init_data.mission, extension_init_context.circumstance_name)
	self._cinematics_setups = {}
	self._cinematics_left_to_play = 0
	self._current_cinematic_name = CINEMATIC_NAMES.none
	self._intro_played = false
	self._intro_loading_started = false

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

CinematicSceneSystem._mission_settings = function (self, mission, circumstance_name)
	local original_settings = mission.cinematics or {}
	local circumstance_template = CircumstanceTemplates[circumstance_name]
	local mission_overrides = circumstance_template.mission_overrides
	local circumstance_settings = mission_overrides and mission_overrides.cinematics or nil

	return circumstance_settings or original_settings
end

CinematicSceneSystem.destroy = function (self, ...)
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
	local load_only = true
	local origin_level_names = _origin_level_names(cinematic_name)

	if #origin_level_names == 0 then
		Managers.event:trigger("cutscene_loaded_all_clients", load_only, preload_id)
	else
		local template = CinematicSceneTemplates[cinematic_name]
		local hotjoin_only = template.hotjoin_only
		local on_level_loaded_cb = callback(self, "_on_level_loaded", cinematic_name)

		Managers.state.cinematic:load_levels(cinematic_name, origin_level_names, on_level_loaded_cb, nil, hotjoin_only, load_only, preload_id)

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
	local origin_level_names = _origin_level_names(cinematic_name)

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
		local new_cinematic_setup = {}

		new_cinematic_setup.scene_unit_origin = nil
		new_cinematic_setup.scene_unit_destination = nil
		new_cinematic_setup.scene_level_destination = self._level
		new_cinematic_setup.scene_level_origin = nil
		new_cinematic_setup.camera_unit = nil
		new_cinematic_setup.camera = nil
		new_cinematic_setup.is_valid = true
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
				local use_transition_ui = template.use_transition_ui and not ui_manager:view_active("video_view")
				local no_transition_ui = use_transition_ui == false
				local view_settings_override = no_transition_ui and {
					use_transition_ui = false,
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
