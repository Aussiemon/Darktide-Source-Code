-- chunkname: @scripts/extension_systems/character_state_machine/character_states/player_character_state_netted.lua

require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local Assist = require("scripts/extension_systems/character_state_machine/character_states/utilities/assist")
local CharacterStateAssistSettings = require("scripts/settings/character_state/character_state_assist_settings")
local CharacterStateNettedSettings = require("scripts/settings/character_state/character_state_netted_settings")
local DialogueSettings = require("scripts/settings/dialogue/dialogue_settings")
local FirstPersonView = require("scripts/utilities/first_person_view")
local ForceRotation = require("scripts/extension_systems/locomotion/utilities/force_rotation")
local HealthStateTransitions = require("scripts/extension_systems/character_state_machine/character_states/utilities/health_state_transitions")
local LagCompensation = require("scripts/utilities/lag_compensation")
local Luggable = require("scripts/utilities/luggable")
local Netted = require("scripts/extension_systems/character_state_machine/character_states/utilities/netted")
local PlayerVoiceGrunts = require("scripts/utilities/player_voice_grunts")
local PlayerUnitData = require("scripts/extension_systems/unit_data/utilities/player_unit_data")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local Vo = require("scripts/utilities/vo")
local PlayerCharacterStateNetted = class("PlayerCharacterStateNetted", "PlayerCharacterStateBase")
local netted_anims = CharacterStateNettedSettings.anim_settings
local breed_specific_settings = CharacterStateNettedSettings.breed_specific_settings
local assist_anims = CharacterStateAssistSettings.anim_settings.netted
local TENSION_TYPE = "netted"
local SFX_SOURCE = "head"
local STINGER_ENTER_ALIAS = "disabled_enter"
local STINGER_EXIT_ALIAS = "disabled_exit"
local LOOPING_SOUND_ALIAS = "netted"
local STINGER_PROPERTIES = {
	stinger_type = "netted",
}
local VCE_ALIAS = "scream_long_vce"

PlayerCharacterStateNetted.init = function (self, character_state_init_context, ...)
	PlayerCharacterStateNetted.super.init(self, character_state_init_context, ...)

	local unit_data_extension = character_state_init_context.unit_data
	local looping_sound_component_name = PlayerUnitData.looping_sound_component_name(LOOPING_SOUND_ALIAS)

	self._looping_sound_component = unit_data_extension:read_component(looping_sound_component_name)

	local disabled_character_state_component = unit_data_extension:write_component("disabled_character_state")

	disabled_character_state_component.is_disabled = false
	disabled_character_state_component.disabling_unit = nil
	disabled_character_state_component.disabling_type = "none"
	disabled_character_state_component.target_drag_position = Vector3.zero()
	disabled_character_state_component.has_reached_drag_position = false
	self._disabled_character_state_component = disabled_character_state_component
	self._disabled_state_input = unit_data_extension:read_component("disabled_state_input")
	self._entered_state_t = nil
	self._time_disabled = nil
end

PlayerCharacterStateNetted.extensions_ready = function (self, world, unit)
	PlayerCharacterStateNetted.super.extensions_ready(self, world, unit)

	local is_server = self._is_server
	local game_session_or_nil = self._game_session
	local game_object_id_or_nil = self._game_object_id

	self._assist = Assist:new(assist_anims, is_server, unit, game_session_or_nil, game_object_id_or_nil, "saved")
end

PlayerCharacterStateNetted.game_object_initialized = function (self, game_session, game_object_id)
	PlayerCharacterStateNetted.super.game_object_initialized(self, game_session, game_object_id)
	self._assist:game_object_initialized(game_session, game_object_id)
end

PlayerCharacterStateNetted.on_enter = function (self, unit, dt, t, previous_state, params)
	PlayerCharacterStateNetted.super.on_enter(self, unit, dt, t, previous_state, params)

	local disabling_unit = self._disabled_state_input.disabling_unit
	local disabling_unit_data_extension = ScriptUnit.extension(disabling_unit, "unit_data_system")

	self._disabling_breed = disabling_unit_data_extension:breed()

	local locomotion_component = self._locomotion_component
	local locomotion_force_rotation_component = self._locomotion_force_rotation_component
	local locomotion_steering_component = self._locomotion_steering_component
	local movement_state_component = self._movement_state_component
	local fx_extension = self._fx_extension
	local animation_extension = self._animation_extension
	local disabled_character_state_component = self._disabled_character_state_component
	local inventory_component = self._inventory_component
	local visual_loadout_extension = self._visual_loadout_extension

	Luggable.drop_luggable(t, unit, inventory_component, visual_loadout_extension, true)

	local disabling_breed = self._disabling_breed

	Netted.enter(unit, animation_extension, fx_extension, self._breed, disabling_breed, locomotion_steering_component, movement_state_component, t)

	local is_server = self._is_server

	if is_server then
		local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
		local drag_position = Netted.calculate_drag_position(locomotion_component, navigation_extension, disabling_unit, self._nav_world)

		disabled_character_state_component.target_drag_position = drag_position
	end

	disabled_character_state_component.is_disabled = true
	disabled_character_state_component.disabling_type = "netted"
	disabled_character_state_component.disabling_unit = disabling_unit
	locomotion_steering_component.disable_minion_collision = true

	local disabling_unit_rotation = Unit.world_rotation(disabling_unit, 1)
	local force_rotation = Quaternion.look(-Quaternion.forward(disabling_unit_rotation))
	local start_rotation = force_rotation
	local duration = 0

	ForceRotation.start(locomotion_force_rotation_component, locomotion_steering_component, force_rotation, start_rotation, t, duration)

	if is_server then
		self:_add_buffs(t)
		self._fx_extension:trigger_gear_wwise_event_with_source(STINGER_ENTER_ALIAS, STINGER_PROPERTIES, SFX_SOURCE, true, true)
		self._dialogue_extension:stop_currently_playing_vo()
		self:_init_player_vo(t)
		Managers.state.pacing:add_tension_type(TENSION_TYPE, unit)
	end

	if not self._looping_sound_component.is_playing then
		fx_extension:trigger_looping_wwise_event(LOOPING_SOUND_ALIAS, SFX_SOURCE)
	end

	self._entered_state_t = t
	self._time_disabled = is_server and 0 or nil

	self._assist:reset()
end

PlayerCharacterStateNetted.on_exit = function (self, unit, t, next_state)
	PlayerCharacterStateNetted.super.on_exit(self, unit, t, next_state)

	local is_server = self._is_server
	local disabled_character_state_component = self._disabled_character_state_component
	local fx_extension = self._fx_extension
	local has_reached_drag_position = disabled_character_state_component.has_reached_drag_position

	if not has_reached_drag_position then
		self:_on_drag_completed(t)
	end

	disabled_character_state_component.has_reached_drag_position = false

	local locomotion_force_rotation_component = self._locomotion_force_rotation_component

	if locomotion_force_rotation_component.use_force_rotation then
		ForceRotation.stop(locomotion_force_rotation_component)
	end

	if is_server then
		Netted.try_exit(unit, self._inventory_component, self._visual_loadout_extension, self._unit_data_extension, t)
		self:_remove_buffs()

		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local player = player_unit_spawn_manager:owner(unit)
		local is_player_alive = player:unit_is_alive()

		if is_player_alive then
			local rescued_by_player = true
			local state_name = "netted"
			local time_in_captivity = t - self._entered_state_t

			Managers.telemetry_events:player_exits_captivity(player, rescued_by_player, state_name, time_in_captivity)
			Managers.stats:record_private("hook_escaped_captivitiy", player, state_name, self._time_disabled)
		end

		self._entered_state_t = nil
		self._time_disabled = nil
	end

	local inventory_component = self._inventory_component

	if next_state ~= "dead" and inventory_component.wielded_slot == "slot_unarmed" then
		PlayerUnitVisualLoadout.wield_previous_slot(inventory_component, unit, t)
	end

	local locomotion_steering_component = self._locomotion_steering_component

	locomotion_steering_component.disable_minion_collision = false

	local rewind_ms = LagCompensation.rewind_ms(is_server, self._is_local_unit, self._player)

	FirstPersonView.enter(t, self._first_person_mode_component, rewind_ms)
	self._assist:stop()

	if is_server and next_state == "walking" then
		fx_extension:trigger_exclusive_gear_wwise_event(STINGER_EXIT_ALIAS, STINGER_PROPERTIES)
	end

	if self._looping_sound_component.is_playing then
		fx_extension:stop_looping_wwise_event(LOOPING_SOUND_ALIAS)
	end
end

PlayerCharacterStateNetted.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	self:_update_netted(unit, dt, t)

	local assist = self._assist
	local assist_done = assist:update(dt, t)

	if self._is_server then
		if not assist:in_progress() then
			self._time_disabled = self._time_disabled + dt
		end

		if not assist_done then
			self:_update_vo(t)
		end
	end

	return self:_check_transition(unit, t, next_state_params, assist_done)
end

PlayerCharacterStateNetted._update_netted = function (self, unit, dt, t)
	local constants = self._constants
	local character_state_component = self._character_state_component
	local fp_anim_t = character_state_component.entered_t + constants.netted_fp_anim_duration

	if fp_anim_t < t then
		local is_in_fp = self._first_person_mode_component.wants_1p_camera

		if is_in_fp then
			self._animation_extension:anim_event(netted_anims.dragged_anim_event)
			FirstPersonView.exit(t, self._first_person_mode_component)
		end

		local disabled_character_state_component = self._disabled_character_state_component
		local has_reached_drag_position = disabled_character_state_component.has_reached_drag_position

		if not has_reached_drag_position then
			local target_drag_position = disabled_character_state_component.target_drag_position

			self:_update_drag(unit, dt, t, target_drag_position)
		end
	end
end

PlayerCharacterStateNetted._check_transition = function (self, unit, t, next_state_params, assist_done)
	local unit_data_extension = self._unit_data_extension
	local health_transition = HealthStateTransitions.poll(unit_data_extension, next_state_params)

	if health_transition then
		return health_transition
	end

	if assist_done then
		return "walking"
	end

	return nil
end

PlayerCharacterStateNetted._init_player_vo = function (self, t)
	self._next_vo_trigger_time_t = t + DialogueSettings.netted_vo_start_delay_t
	self._vo_sequence = 1
end

PlayerCharacterStateNetted._update_drag = function (self, unit, dt, t, target_drag_position)
	local locomotion_component = self._locomotion_component
	local current_position = locomotion_component.position
	local constants = self._constants
	local netted_drag_destination_size = constants.netted_drag_destination_size
	local distance_remaining = Vector3.distance(Vector3.flat(current_position), Vector3.flat(target_drag_position))
	local disabled_character_state_component = self._disabled_character_state_component
	local has_reached_drag_position = disabled_character_state_component.has_reached_drag_position

	if not has_reached_drag_position and distance_remaining <= netted_drag_destination_size then
		self:_on_drag_completed(t)
	else
		if not self._previous_position then
			self._previous_position = Vector3Box(current_position)
		end

		local is_stuck = self:_is_stuck(current_position)

		if is_stuck then
			self:_on_drag_completed(t)

			return
		end

		local breed_settings = breed_specific_settings[self._breed.name]
		local slowdown_distance = breed_settings.slowdown_distance
		local min_slowdown_factor = breed_settings.min_slowdown_factor
		local max_slowdown_factor = breed_settings.max_slowdown_factor
		local drag_speed = breed_settings.drag_speed
		local slowdown_factor = math.clamp(distance_remaining / slowdown_distance, min_slowdown_factor, max_slowdown_factor)
		local wanted_speed = drag_speed * slowdown_factor
		local direction = Vector3.normalize(target_drag_position - current_position)
		local wanted_velocity = direction * wanted_speed

		self._locomotion_steering_component.velocity_wanted = wanted_velocity
	end
end

local MAX_FRAMES_STUCK = 10

PlayerCharacterStateNetted._is_stuck = function (self, current_position)
	local is_stuck = false
	local previous_position = self._previous_position:unbox()
	local distance = Vector3.distance(previous_position, current_position)
	local min_drag_distance = 0.05
	local frames_with_no_movement = self._frames_with_no_movement or 0

	if distance < min_drag_distance then
		frames_with_no_movement = frames_with_no_movement + 1
		is_stuck = frames_with_no_movement >= MAX_FRAMES_STUCK
	else
		frames_with_no_movement = 0

		self._previous_position:store(current_position)
	end

	self._frames_with_no_movement = frames_with_no_movement

	return is_stuck
end

PlayerCharacterStateNetted._on_drag_completed = function (self, t)
	FirstPersonView.exit(t, self._first_person_mode_component)

	local locomotion_steering_component = self._locomotion_steering_component

	locomotion_steering_component.velocity_wanted = Vector3.zero()
	locomotion_steering_component.calculate_fall_velocity = true

	local disabled_character_state_component = self._disabled_character_state_component

	disabled_character_state_component.has_reached_drag_position = true
	self._frames_with_no_movement = 0
	self._previous_position = nil
end

PlayerCharacterStateNetted._add_buffs = function (self, t)
	local constants = self._constants
	local buff_extension = self._buff_extension

	if not self._damage_tick_buff_indexes then
		local _, local_index, component_index = buff_extension:add_externally_controlled_buff(constants.netted_damage_tick_buff, t)

		self._damage_tick_buff_indexes = {
			local_index = local_index,
			component_index = component_index,
		}
	end
end

PlayerCharacterStateNetted._remove_buffs = function (self)
	local buff_extension = self._buff_extension
	local damage_tick_buff_indexes = self._damage_tick_buff_indexes

	if damage_tick_buff_indexes then
		local local_index = damage_tick_buff_indexes.local_index
		local component_index = damage_tick_buff_indexes.component_index

		buff_extension:remove_externally_controlled_buff(local_index, component_index)

		self._damage_tick_buff_indexes = nil
	end
end

PlayerCharacterStateNetted._update_vo = function (self, t)
	if t <= self._next_vo_trigger_time_t then
		return
	end

	local vo_sequence = self._vo_sequence

	if vo_sequence == 1 then
		PlayerVoiceGrunts.trigger_voice(VCE_ALIAS, self._visual_loadout_extension, self._fx_extension, true)
	else
		local disabling_breed = self._disabling_breed

		Vo.player_pounced_by_special_event(self._unit, disabling_breed.name)
	end

	self._next_vo_trigger_time_t = t + DialogueSettings.netted_vo_interval_t
	self._vo_sequence = vo_sequence + 1
end

return PlayerCharacterStateNetted
