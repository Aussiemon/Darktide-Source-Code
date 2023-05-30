require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local Assist = require("scripts/extension_systems/character_state_machine/character_states/utilities/assist")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CharacterStateAssistSettings = require("scripts/settings/character_state/character_state_assist_settings")
local DialogueSettings = require("scripts/settings/dialogue/dialogue_settings")
local FirstPersonView = require("scripts/utilities/first_person_view")
local ForceRotation = require("scripts/extension_systems/locomotion/utilities/force_rotation")
local HealthStateTransitions = require("scripts/extension_systems/character_state_machine/character_states/utilities/health_state_transitions")
local Interrupt = require("scripts/utilities/attack/interrupt")
local LagCompensation = require("scripts/utilities/lag_compensation")
local Luggable = require("scripts/utilities/luggable")
local PlayerUnitData = require("scripts/extension_systems/unit_data/utilities/player_unit_data")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local Vo = require("scripts/utilities/vo")
local Toughness = require("scripts/utilities/toughness/toughness")
local PlayerCharacterStateKnockedDown = class("PlayerCharacterStateKnockedDown", "PlayerCharacterStateBase")
local assist_anims = CharacterStateAssistSettings.anim_settings.knocked_down
local proc_events = BuffSettings.proc_events
local ANIM_EVENT_ON_ENTER = "knockdown_fall_front"
local DIALOGUE_EVENT = "knocked_down"
local INTERRUPT_REASON = "knocked_down"
local INVENTORY_SLOT_TO_WIELD = "slot_unarmed"
local LOOPING_SOUND_ALIAS = "knocked_down"
local SFX_SOURCE = "head"
local MOVE_METHOD = "script_driven"
local TENSION_TYPE = "knocked_down"
local STINGER_ENTER_ALIAS = "disabled_enter"
local STINGER_EXIT_ALIAS = "disabled_exit"
local STINGER_PROPERTIES = {
	stinger_type = "teammate_knocked_down"
}

PlayerCharacterStateKnockedDown.init = function (self, character_state_init_context, ...)
	PlayerCharacterStateKnockedDown.super.init(self, character_state_init_context, ...)

	local unit_data_extension = self._unit_data_extension
	local looping_sound_component_name = PlayerUnitData.looping_sound_component_name(LOOPING_SOUND_ALIAS)
	self._looping_sound_component = unit_data_extension:read_component(looping_sound_component_name)
	self._force_look_rotation_component = unit_data_extension:write_component("force_look_rotation")
	self._knocked_down_state_input = unit_data_extension:write_component("knocked_down_state_input")
	self._next_vo_trigger_time = 0
	self._vo_sequence = 0
	self._entered_state_t = nil
	self._time_disabled = nil
end

PlayerCharacterStateKnockedDown.extensions_ready = function (self, world, unit)
	PlayerCharacterStateKnockedDown.super.extensions_ready(self, world, unit)

	local is_server = self._is_server
	local game_session_or_nil = self._game_session
	local game_object_id_or_nil = self._game_object_id
	self._assist = Assist:new(assist_anims, is_server, unit, game_session_or_nil, game_object_id_or_nil, "saved")
end

PlayerCharacterStateKnockedDown.game_object_initialized = function (self, game_session, game_object_id)
	PlayerCharacterStateKnockedDown.super.game_object_initialized(self, game_session, game_object_id)
	self._assist:game_object_initialized(game_session, game_object_id)
end

PlayerCharacterStateKnockedDown.on_enter = function (self, unit, dt, t, previous_state, params)
	local is_server = self._is_server
	local animation_extension = self._animation_extension
	local fx_extension = self._fx_extension
	local health_extension = self._health_extension
	local looping_sound_component = self._looping_sound_component
	local inventory_component = self._inventory_component
	local visual_loadout_extension = self._visual_loadout_extension

	self:_init_vo(t)
	self:_stop_movement(t)
	self:_enter_third_person_mode(t)

	self._entered_state_t = t
	self._time_disabled = is_server and 0 or nil

	Interrupt.ability_and_action(t, unit, INTERRUPT_REASON, nil)
	Luggable.drop_luggable(t, unit, inventory_component, visual_loadout_extension, true)
	PlayerUnitVisualLoadout.wield_slot(INVENTORY_SLOT_TO_WIELD, unit, t)
	animation_extension:anim_event(ANIM_EVENT_ON_ENTER)

	if not looping_sound_component.is_playing then
		fx_extension:trigger_looping_wwise_event(LOOPING_SOUND_ALIAS, SFX_SOURCE)
	end

	if is_server then
		self:_add_buffs(t)
		health_extension:entered_knocked_down()
		Managers.state.pacing:add_tension_type(TENSION_TYPE, unit)

		local num_wounds = 1

		health_extension:remove_wounds(num_wounds)

		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local player_units = side.valid_player_units

		for i = 1, #player_units do
			local player_unit = player_units[i]
			local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
			local param_table = buff_extension:request_proc_event_param_table()

			if param_table then
				param_table.downed_unit = unit

				buff_extension:add_proc_event(proc_events.on_ally_knocked_down, param_table)
			end
		end

		self._fx_extension:trigger_gear_wwise_event_with_source(STINGER_ENTER_ALIAS, STINGER_PROPERTIES, SFX_SOURCE, true, true)
	end

	self._assist:reset()
end

PlayerCharacterStateKnockedDown.on_exit = function (self, unit, t, next_state)
	local is_server = self._is_server
	local fx_extension = self._fx_extension
	local health_extension = self._health_extension
	local inventory_component = self._inventory_component
	local knocked_down_state_input = self._knocked_down_state_input
	local looping_sound_component = self._looping_sound_component

	self:_exit_third_person_mode(t)

	if next_state ~= "dead" and inventory_component.wielded_slot == "slot_unarmed" then
		PlayerUnitVisualLoadout.wield_previous_slot(inventory_component, unit, t)
	end

	if looping_sound_component.is_playing then
		fx_extension:stop_looping_wwise_event(LOOPING_SOUND_ALIAS)
	end

	knocked_down_state_input.knock_down = false

	if is_server and (next_state == "walking" or next_state == "warp_grabbed") then
		self:_remove_buffs()
		health_extension:exited_knocked_down()
	end

	if is_server and next_state == "walking" then
		self._fx_extension:trigger_exclusive_gear_wwise_event(STINGER_EXIT_ALIAS, STINGER_PROPERTIES)
	end

	if is_server then
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local player = player_unit_spawn_manager:owner(unit)
		local is_player_alive = player:unit_is_alive()

		if is_player_alive then
			local rescued_by_player = true
			local state_name = "knocked_down"
			local time_in_captivity = t - self._entered_state_t

			Managers.telemetry_events:player_exits_captivity(player, rescued_by_player, state_name, time_in_captivity)

			local stat_manager = Managers.stats

			if stat_manager.can_record_stats() then
				stat_manager:record_exit_disabled_character_state(state_name, self._time_disabled)
			end

			local ignore_state_block = true

			Toughness.recover_max_toughness(unit, "exit_knock_down", ignore_state_block)
		end

		self._entered_state_t = nil
		self._time_disabled = nil
	end

	self._assist:stop()
end

PlayerCharacterStateKnockedDown.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	self:_update_vo(t)

	local assist = self._assist
	local assist_done = assist:update(dt, t)

	if self._is_server and not assist:in_progress() then
		self._time_disabled = self._time_disabled + dt
	end

	local unit_data_extension = self._unit_data_extension
	local interactee_component = unit_data_extension:read_component("interactee")
	local interactor_unit = interactee_component.interactor_unit

	if interactor_unit then
		self._last_interactor_unit = interactor_unit
	end

	return self:_check_transition(unit, dt, t, next_state_params, assist_done)
end

PlayerCharacterStateKnockedDown._check_transition = function (self, unit, dt, t, next_state_params, assist_done)
	local unit_data_extension = self._unit_data_extension
	local health_transition = HealthStateTransitions.poll(unit_data_extension, next_state_params)

	if health_transition then
		return health_transition
	end

	local disabled_state_input = unit_data_extension:read_component("disabled_state_input")

	if disabled_state_input.wants_disable and disabled_state_input.disabling_unit then
		local disabling_type = disabled_state_input.disabling_type

		if disabling_type == "warp_grabbed" then
			return "warp_grabbed"
		end
	end

	if assist_done then
		return "walking"
	end

	return nil
end

PlayerCharacterStateKnockedDown._init_vo = function (self, t)
	local unit = self._unit
	self._next_vo_trigger_time = t + 1
	self._vo_sequence = 1

	Vo.knocked_down_multiple_times_event(unit)
end

PlayerCharacterStateKnockedDown._update_vo = function (self, t)
	if t <= self._next_vo_trigger_time then
		return
	end

	local dialogue_system = self._dialogue_system
	local vo_sequence = self._vo_sequence
	local event_data = dialogue_system.input:get_event_data_payload()
	event_data.sequence_no = vo_sequence

	dialogue_system.input:trigger_dialogue_event(DIALOGUE_EVENT, event_data)

	self._next_vo_trigger_time = t + DialogueSettings.knocked_down_vo_interval
	self._vo_sequence = vo_sequence + 1
end

PlayerCharacterStateKnockedDown._stop_movement = function (self, t)
	local first_person = self._first_person_component
	local locomotion_force_rotation = self._locomotion_force_rotation_component
	local locomotion_steering = self._locomotion_steering_component
	locomotion_steering.calculate_fall_velocity = true
	locomotion_steering.velocity_wanted = Vector3.zero()
	locomotion_steering.move_method = MOVE_METHOD
	local forced_rotation = Quaternion.look(Vector3.flat(Quaternion.forward(first_person.rotation)))

	if not locomotion_force_rotation.use_force_rotation then
		ForceRotation.start(locomotion_force_rotation, locomotion_steering, forced_rotation, forced_rotation, t, 0)
	end
end

PlayerCharacterStateKnockedDown._enter_third_person_mode = function (self, t)
	local first_person_mode_component = self._first_person_mode_component

	FirstPersonView.exit(t, first_person_mode_component)
end

PlayerCharacterStateKnockedDown._exit_third_person_mode = function (self, t)
	local unit = self._unit
	local locomotion_force_rotation = self._locomotion_force_rotation_component
	local first_person_extension = self._first_person_extension
	local first_person_mode_component = self._first_person_mode_component

	if locomotion_force_rotation.use_force_rotation then
		ForceRotation.stop(locomotion_force_rotation)
	end

	local look_rotation = first_person_extension:extrapolated_rotation()

	Unit.set_local_rotation(unit, 1, look_rotation)

	local rewind_ms = LagCompensation.rewind_ms(self._is_server, self._is_local_unit, self._player)

	FirstPersonView.enter(t, first_person_mode_component, rewind_ms)
end

PlayerCharacterStateKnockedDown._add_buffs = function (self, t)
	local constants = self._constants
	local buff_extension = self._buff_extension

	if not self._damage_reduction_buff_indexes then
		local _, local_index, component_index = buff_extension:add_externally_controlled_buff(constants.knocked_down_damage_reduction_buff, t)
		self._damage_reduction_buff_indexes = {
			local_index = local_index,
			component_index = component_index
		}
	end

	if not self._damage_tick_buff_indexes then
		local _, local_index, component_index = buff_extension:add_externally_controlled_buff(constants.knocked_down_damage_tick_buff, t)
		self._damage_tick_buff_indexes = {
			local_index = local_index,
			component_index = component_index
		}
	end
end

PlayerCharacterStateKnockedDown._remove_buffs = function (self)
	local buff_extension = self._buff_extension
	local damage_reduction_buff_indexes = self._damage_reduction_buff_indexes

	if damage_reduction_buff_indexes then
		local local_index = damage_reduction_buff_indexes.local_index
		local component_index = damage_reduction_buff_indexes.component_index

		buff_extension:remove_externally_controlled_buff(local_index, component_index)

		self._damage_reduction_buff_indexes = nil
	end

	local damage_tick_buff_indexes = self._damage_tick_buff_indexes

	if damage_tick_buff_indexes then
		local local_index = damage_tick_buff_indexes.local_index
		local component_index = damage_tick_buff_indexes.component_index

		buff_extension:remove_externally_controlled_buff(local_index, component_index)

		self._damage_tick_buff_indexes = nil
	end
end

return PlayerCharacterStateKnockedDown
