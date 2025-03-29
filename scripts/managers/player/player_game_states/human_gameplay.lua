-- chunkname: @scripts/managers/player/player_game_states/human_gameplay.lua

require("scripts/extension_systems/first_person/character_state_orientation/default_player_orientation")

local CameraHandler = require("scripts/managers/player/player_game_states/camera_handler")
local CommunicationWheelPlayerOrientation = require("scripts/extension_systems/first_person/character_state_orientation/communication_wheel_player_orientation")
local DeadPlayerOrientation = require("scripts/extension_systems/first_person/character_state_orientation/dead_player_orientation")
local ForcedPlayerOrientation = require("scripts/extension_systems/first_person/character_state_orientation/forced_player_orientation")
local HubPlayerOrientation = require("scripts/extension_systems/first_person/character_state_orientation/hub_player_orientation")
local HudElementsSpectator = require("scripts/ui/hud/hud_elements_spectator")
local HudVisibilityGroups = require("scripts/ui/hud/hud_visibility_groups")
local HumanInputHandler = require("scripts/managers/player/player_game_states/human_input_handler")
local InputHandlerSettings = require("scripts/managers/player/player_game_states/input_handler_settings")
local LedgeHangingPlayerOrientation = require("scripts/extension_systems/first_person/character_state_orientation/ledge_hanging_player_orientation")
local LungeTemplates = require("scripts/settings/lunge/lunge_templates")
local Missions = require("scripts/settings/mission/mission_templates")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local SmoothForceViewPlayerOrientation = require("scripts/extension_systems/first_person/character_state_orientation/smooth_force_view_player_orientation")
local SweepStickyness = require("scripts/utilities/action/sweep_stickyness")
local WeaponForceViewPlayerOrientation = require("scripts/extension_systems/first_person/character_state_orientation/weapon_force_view_player_orientation")
local WeaponLockViewPlayerOrientation = require("scripts/extension_systems/first_person/character_state_orientation/weapon_lock_view_player_orientation")
local unit_alive = Unit.alive
local HumanGameplay = class("HumanGameplay")

HumanGameplay.init = function (self, player, game_state_context)
	local is_server = game_state_context.is_server

	self._player = player
	self._player_unit = player.player_unit
	self._last_frame = 0
	self._is_server = is_server

	local mission_name = game_state_context.mission_name

	self._mission_name = mission_name

	self:_init_input(player)

	player.input_handler = HumanInputHandler:new(player, is_server, game_state_context.clock_handler)

	local world = game_state_context.world
	local level = game_state_context.level
	local themes = game_state_context.themes
	local camera_handler = CameraHandler:new(player, world)

	camera_handler:spawn_camera(level, themes)

	player.camera_handler = camera_handler

	local orientation = player:get_orientation()

	self._dead_player_orientation = DeadPlayerOrientation:new(player, orientation)

	if is_server then
		local position, rotation, parent, side

		if LEVEL_EDITOR_TEST then
			local camera_position = Application.get_data("LevelEditor", "camera_position")
			local camera_rotation = Application.get_data("LevelEditor", "camera_rotation")

			position, rotation = camera_position, camera_rotation
		else
			local player_spawner_system = Managers.state.extension:system("player_spawner_system")
			local wanted_spawn_point = player:wanted_spawn_point()

			player:set_wanted_spawn_point(nil)

			local spawn_position, spawn_rotation, spawn_parent, spawn_side = player_spawner_system:next_free_spawn_point(wanted_spawn_point)

			position = spawn_position
			rotation = spawn_rotation
			parent = spawn_parent
			side = spawn_side
		end

		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local force_spawn = true
		local is_respawn = false

		player_unit_spawn_manager:spawn_player(player, position, rotation, parent, force_spawn, side, nil, "walking", is_respawn)
	end

	local event_manager = Managers.event

	event_manager:register(self, "player_activate_emote", "_cb_player_activate_emote")

	self._has_own_hud = false
	self._has_spectator_hud = false
	self._spectated_player = nil

	local game_mode_manager = Managers.state.game_mode

	self._hotkey_settings = game_mode_manager:hotkey_settings()
	self._default_player_class_name = game_mode_manager:default_player_orientation() or "DefaultPlayerOrientation"
end

HumanGameplay.on_reload = function (self, refreshed_resources)
	if self._has_own_hud then
		self:_destroy_player_hud()
		self:_create_player_hud(self._player)
	end

	if self._has_spectator_hud then
		self:_destroy_spectator_hud()
		self:_create_spectator_hud(self._spectated_player)
	end

	self._player.camera_handler:on_reload()
end

HumanGameplay._create_player_hud = function (self, player)
	local ui_manager = Managers.ui
	local peer_id = player:peer_id()
	local local_player_id = player:local_player_id()
	local mission_name = self._mission_name
	local mission_settings = Missions[mission_name]
	local hud_elements = require(mission_settings.hud_elements or "scripts/ui/hud/hud_elements_player")
	local visibility_groups = require(mission_settings.hud_visibility_groups or "scripts/ui/hud/hud_visibility_groups")

	ui_manager:create_player_hud(peer_id, local_player_id, hud_elements, visibility_groups)

	self._has_own_hud = true
end

HumanGameplay._destroy_player_hud = function (self)
	local ui_manager = Managers.ui

	ui_manager:destroy_player_hud()

	self._has_own_hud = false
end

HumanGameplay._create_spectator_hud = function (self, spectated_player)
	local ui_manager = Managers.ui
	local peer_id = spectated_player:peer_id()
	local local_player_id = spectated_player:local_player_id()

	Managers.ui:create_spectator_hud(self._player.viewport_name, peer_id, local_player_id, HudElementsSpectator, HudVisibilityGroups)

	self._has_spectator_hud = true
end

HumanGameplay._destroy_spectator_hud = function (self)
	local ui_manager = Managers.ui

	ui_manager:destroy_spectator_hud()

	self._has_spectator_hud = false
end

HumanGameplay._create_player_orientation_classes = function (self, player)
	local orientation = player:get_orientation()

	self._default_player_orientation = CLASSES[self._default_player_class_name]:new(player, orientation)
	self._hub_player_orientation = HubPlayerOrientation:new(player, orientation)
	self._forced_player_orientation = ForcedPlayerOrientation:new(player, orientation)
	self._ledge_hanging_player_orientation = LedgeHangingPlayerOrientation:new(player, orientation)
	self._weapon_lock_view_player_orientation = WeaponLockViewPlayerOrientation:new(player, orientation)
	self._weapon_force_view_player_orientation = WeaponForceViewPlayerOrientation:new(player, orientation)
	self._smooth_force_view_player_orientation = SmoothForceViewPlayerOrientation:new(player, orientation)

	if not self._dead_player_orientation then
		self._dead_player_orientation = DeadPlayerOrientation:new(player, orientation)
	end

	self._communication_wheel_orientation = CommunicationWheelPlayerOrientation:new(player, orientation)
end

HumanGameplay._destroy_player_orientation_classes = function (self, all)
	self._default_player_orientation:destroy()
	self._hub_player_orientation:destroy()
	self._forced_player_orientation:destroy()
	self._ledge_hanging_player_orientation:destroy()

	if all then
		self._dead_player_orientation:destroy()
	end

	self._communication_wheel_orientation:destroy()
end

HumanGameplay.destroy = function (self)
	local player = self._player

	if self._spectated_player then
		Managers.input:stop_suppress_wwise_rumble()
	end

	if self._has_own_hud then
		self:_destroy_player_hud()
	end

	if self._has_spectator_hud then
		self:_destroy_spectator_hud()
	end

	player.camera_handler:destroy_camera()
	player.camera_handler:delete()

	player.camera_handler = nil

	if self._is_server then
		local player_unit_spawn_manager = Managers.state.player_unit_spawn

		player_unit_spawn_manager:despawn_player(player)
	end

	local event_manager = Managers.event

	event_manager:unregister(self, "player_activate_emote")
end

HumanGameplay._init_input = function (self)
	local input_manager = Managers.input

	self._input = input_manager:get_input_service("Ingame")
end

HumanGameplay._input_active = function (self)
	local imgui_manager = Managers.imgui
	local ui_manager = Managers.ui

	if imgui_manager and imgui_manager:using_input() or ui_manager and ui_manager:using_input() then
		return false
	end

	if Managers.state.cinematic:cinematic_active() then
		return false
	end

	return true
end

HumanGameplay._get_input = function (self)
	local input = self._input

	if not self:_input_active() then
		input = input:null_service()
	end

	return input
end

local ui_interaction_action = {}

HumanGameplay.pre_update = function (self, main_dt, main_t)
	local input = self:_get_input()
	local player = self._player
	local player_unit_is_alive = player:unit_is_alive()

	table.clear(ui_interaction_action)

	if player_unit_is_alive then
		local interactor_extension = ScriptUnit.extension(player.player_unit, "interactor_system")
		local is_interacting = interactor_extension:is_interacting()

		if is_interacting then
			local interaction = interactor_extension:interaction()
			local ui_view_name = interaction:ui_view_name()

			if ui_view_name and not Managers.ui:view_active(ui_view_name) then
				ui_interaction_action.finished_interaction = true
			end
		end

		local emote = self._emote

		if emote then
			ui_interaction_action[emote] = true
			self._emote = nil
		end
	end

	player.input_handler:pre_update(main_dt, main_t, input, ui_interaction_action)

	local rotation_contraints
	local sensitivity_modifier = 1

	if player_unit_is_alive then
		local player_unit = player.player_unit
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		local weapon_ext = ScriptUnit.extension(player_unit, "weapon_system")
		local weapon_system_sensitivity_modifier = weapon_ext:sensitivity_modifier()
		local weapon_system_rotation_contraints = weapon_ext:rotation_contraints()

		sensitivity_modifier = weapon_system_sensitivity_modifier or 1
		rotation_contraints = weapon_system_rotation_contraints

		local lunge_character_state_component = unit_data_extension:read_component("lunge_character_state")

		if lunge_character_state_component and lunge_character_state_component.is_lunging then
			local lunge_template = LungeTemplates[lunge_character_state_component.lunge_template]

			if lunge_template then
				local lunge_sensitivity_modifier = lunge_template.sensitivity_modifier or 1

				sensitivity_modifier = 1 * math.min(weapon_system_sensitivity_modifier, lunge_sensitivity_modifier)

				if lunge_template.rotation_contraints then
					rotation_contraints = lunge_template.rotation_contraints
				end
			end
		end
	end

	if player_unit_is_alive and player.player_unit ~= self._player_unit then
		self._player_unit = player.player_unit

		self:_create_player_orientation_classes(player)

		local unit_data_extension = ScriptUnit.has_extension(player.player_unit, "unit_data_system")

		self._character_state_component = unit_data_extension:read_component("character_state")
		self._force_look_rotation_component = unit_data_extension:read_component("force_look_rotation")
		self._ledge_hanging_character_state_component = unit_data_extension:read_component("ledge_hanging_character_state")
		self._weapon_lock_view_component = unit_data_extension:read_component("weapon_lock_view")
		self._interacting_character_state_component = unit_data_extension:read_component("interaction")
		self._action_sweep_component = unit_data_extension:read_component("action_sweep")
	elseif unit_alive(self._player_unit) and not player_unit_is_alive then
		self:_destroy_player_orientation_classes()

		self._action_sweep_component = nil
		self._character_state_component = nil
		self._force_look_rotation_component = nil
		self._ledge_hanging_character_state_component = nil
		self._weapon_lock_view_component = nil
		self._interacting_character_state_component = nil
		self._player_unit = nil
	end

	local player_orientation_class = self:_player_orientation_class()

	if player_orientation_class then
		player_orientation_class:pre_update(main_t, main_dt, input, sensitivity_modifier, rotation_contraints)
	end
end

HumanGameplay._player_orientation_class = function (self)
	if not ALIVE[self._player_unit] then
		return self._dead_player_orientation
	end

	local weapon_lock_view_component_state = self._weapon_lock_view_component.state
	local ui_using_camera_orientation = false

	if Managers.ui then
		ui_using_camera_orientation = Managers.ui:communication_wheel_wants_camera_control()

		if Managers.ui:emote_wheel_wants_camera_control() then
			ui_using_camera_orientation = true
		end
	end

	if self._force_look_rotation_component.use_force_look_rotation then
		return self._forced_player_orientation
	elseif PlayerUnitStatus.is_ledge_hanging(self._character_state_component) then
		return self._ledge_hanging_player_orientation
	elseif weapon_lock_view_component_state == "weapon_lock" or weapon_lock_view_component_state == "weapon_lock_no_lerp" then
		return self._weapon_lock_view_player_orientation
	elseif weapon_lock_view_component_state == "force_look" then
		return self._weapon_force_view_player_orientation
	elseif SweepStickyness.is_sticking_to_unit(self._action_sweep_component) then
		return self._smooth_force_view_player_orientation
	elseif ui_using_camera_orientation then
		return self._communication_wheel_orientation
	else
		return self._default_player_orientation
	end
end

HumanGameplay._cb_player_activate_emote = function (self, emote, player)
	self._emote = emote
end

HumanGameplay.initialize_client_fixed_frame = function (self, fixed_frame)
	self._last_frame = fixed_frame

	local input = self:_get_input()
	local player_orientation_class = self:_player_orientation_class()
	local yaw, pitch, roll = 0, 0, 0

	if player_orientation_class then
		yaw, pitch, roll = player_orientation_class:orientation()
	end

	self._player.input_handler:initialize_client_fixed_frame(fixed_frame, input, yaw, pitch, roll)
end

HumanGameplay.fixed_update = function (self, game_dt, game_t, fixed_frame)
	self._last_frame = fixed_frame

	local input = self:_get_input()
	local player_orientation_class = self:_player_orientation_class()
	local yaw, pitch, roll = 0, 0, 0

	if player_orientation_class then
		yaw, pitch, roll = player_orientation_class:orientation()
	end

	self._player.input_handler:fixed_update(game_dt, game_t, fixed_frame, input, yaw, pitch, roll)
end

HumanGameplay.update = function (self, main_dt, main_t)
	local input = self:_get_input()
	local player = self._player
	local player_orientation = self:_player_orientation_class()
	local camera_follow_unit_or_nil = player.camera_handler:update(main_dt, main_t, player_orientation, input)

	self:_update_spectating(camera_follow_unit_or_nil)

	local ui_manager = Managers.ui

	if ui_manager then
		self:_handle_huds(camera_follow_unit_or_nil)

		local hotkey_settings = self._hotkey_settings

		ui_manager:handle_view_hotkeys(hotkey_settings)
	end

	local time_manager = Managers.time

	if time_manager:has_timer("gameplay") then
		local dt, t = time_manager:delta_time("gameplay"), time_manager:time("gameplay")

		player.input_handler:update(dt, t, input)
	end

	if PLATFORM == "win32" then
		if ui_manager and ui_manager:using_input() then
			Application.set_in_menu(true)
		else
			Application.set_in_menu(false)
		end
	end
end

HumanGameplay._update_spectating = function (self, camera_follow_unit_or_nil)
	local current_spectated_player_or_nil = self._spectated_player
	local following_player_or_nil = camera_follow_unit_or_nil and Managers.state.player_unit_spawn:owner(camera_follow_unit_or_nil)

	if following_player_or_nil == nil then
		if current_spectated_player_or_nil then
			self:_stop_spectating()
		end

		return
	end

	local own_player = self._player
	local spectating_own_player = current_spectated_player_or_nil == own_player
	local spectating_requires_update = false

	if following_player_or_nil ~= current_spectated_player_or_nil then
		spectating_requires_update = true
	elseif spectating_own_player then
		local unit_data_ext = ScriptUnit.extension(camera_follow_unit_or_nil, "unit_data_system")

		spectating_requires_update = not PlayerUnitStatus.is_hogtied(unit_data_ext:read_component("character_state"))
	end

	if spectating_requires_update then
		if current_spectated_player_or_nil then
			self:_stop_spectating()
		end

		if following_player_or_nil then
			local can_spectate = true

			if following_player_or_nil == own_player then
				local unit_data_ext = ScriptUnit.extension(camera_follow_unit_or_nil, "unit_data_system")

				if not PlayerUnitStatus.is_hogtied(unit_data_ext:read_component("character_state")) then
					can_spectate = false
				end
			end

			if can_spectate then
				self:_start_spectating(following_player_or_nil)
			end
		end
	end
end

HumanGameplay._handle_huds = function (self, camera_follow_unit_or_nil)
	local own_player = self._player
	local own_player_unit_or_nil = own_player.player_unit
	local spectated_player_or_nil = self._spectated_player
	local spectated_player_unit_or_nil = spectated_player_or_nil and spectated_player_or_nil.player_unit
	local spectating_ourself = spectated_player_or_nil and spectated_player_or_nil == own_player
	local following_own_unit = own_player_unit_or_nil and camera_follow_unit_or_nil == own_player_unit_or_nil
	local should_have_own_hud = following_own_unit and not spectating_ourself or Managers.state.cinematic:cinematic_active()
	local following_spectated_player_unit = spectated_player_unit_or_nil and camera_follow_unit_or_nil == spectated_player_unit_or_nil

	if self._has_own_hud and not should_have_own_hud then
		self:_destroy_player_hud()
	elseif self._has_spectator_hud and (not following_spectated_player_unit or should_have_own_hud) then
		self:_destroy_spectator_hud()
	end

	if should_have_own_hud and not self._has_own_hud then
		self:_create_player_hud(own_player)
	elseif following_spectated_player_unit and not should_have_own_hud and not self._has_spectator_hud then
		self:_create_spectator_hud(spectated_player_or_nil)
	end
end

HumanGameplay.post_update = function (self, main_dt, main_t)
	local player = self._player
	local player_orientation = self:_player_orientation_class()

	player.camera_handler:post_update(main_dt, main_t, player_orientation)
end

HumanGameplay.on_player_removed = function (self, player)
	if player == self._spectated_player then
		self:_stop_spectating()
	end
end

HumanGameplay._start_spectating = function (self, spectated_player)
	Managers.input:start_suppress_wwise_rumble()
	self._player.camera_handler:remove_all_moods(spectated_player.player_unit)

	self._spectated_player = spectated_player
end

HumanGameplay._stop_spectating = function (self)
	Managers.input:stop_suppress_wwise_rumble()
	self._player.camera_handler:remove_all_moods(self._spectated_player.player_unit)

	if self._has_spectator_hud then
		self:_destroy_spectator_hud()
	end

	self._spectated_player = nil
end

return HumanGameplay
