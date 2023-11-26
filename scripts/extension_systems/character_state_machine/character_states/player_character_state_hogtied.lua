-- chunkname: @scripts/extension_systems/character_state_machine/character_states/player_character_state_hogtied.lua

require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local Assist = require("scripts/extension_systems/character_state_machine/character_states/utilities/assist")
local CharacterStateAssistSettings = require("scripts/settings/character_state/character_state_assist_settings")
local FirstPersonView = require("scripts/utilities/first_person_view")
local ForceRotation = require("scripts/extension_systems/locomotion/utilities/force_rotation")
local LagCompensation = require("scripts/utilities/lag_compensation")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local PlayerCharacterStateHogtied = class("PlayerCharacterStateHogtied", "PlayerCharacterStateBase")
local assist_anims = CharacterStateAssistSettings.anim_settings.hogtied
local ANIM_EVENT_ON_ENTER = "captured_idle"
local ANIM_EVENT_ON_FRIENDLIES_CLOSE = "captured_close"
local INVENTORY_SLOT_TO_WIELD_ON_ENTER = "slot_unarmed"
local INVENTORY_SLOT_TO_WIELD_ON_EXIT = "slot_primary"
local STINGER_EXIT_ALIAS = "disabled_exit"
local STINGER_PROPERTIES = {
	stinger_type = "hogtied"
}

PlayerCharacterStateHogtied.init = function (self, character_state_init_context, ...)
	PlayerCharacterStateHogtied.super.init(self, character_state_init_context, ...)

	self._hogtied_state_input = self._unit_data_extension:write_component("hogtied_state_input")
	self._entered_state_t = nil
end

PlayerCharacterStateHogtied.extensions_ready = function (self, world, unit)
	PlayerCharacterStateHogtied.super.extensions_ready(self, world, unit)

	local is_server = self._is_server
	local game_session_or_nil = self._game_session
	local game_object_id_or_nil = self._game_object_id

	self._assist = Assist:new(assist_anims, is_server, unit, game_session_or_nil, game_object_id_or_nil, "rescued")
end

PlayerCharacterStateHogtied.game_object_initialized = function (self, game_session, game_object_id)
	PlayerCharacterStateHogtied.super.game_object_initialized(self, game_session, game_object_id)
	self._assist:game_object_initialized(game_session, game_object_id)
end

PlayerCharacterStateHogtied.on_enter = function (self, unit, dt, t, previous_state, params)
	FirstPersonView.exit(t, self._first_person_mode_component)
	PlayerUnitVisualLoadout.wield_slot(INVENTORY_SLOT_TO_WIELD_ON_ENTER, unit, t)

	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(ANIM_EVENT_ON_ENTER)
	self._assist:reset()

	local first_person_component = self._first_person_component
	local locomotion_force_rotation_component = self._locomotion_force_rotation_component
	local locomotion_steering_component = self._locomotion_steering_component
	local forced_rotation = Quaternion.look(Vector3.flat(Quaternion.forward(first_person_component.rotation)))

	ForceRotation.start(locomotion_force_rotation_component, locomotion_steering_component, forced_rotation, forced_rotation, t, 0)

	self._entered_state_t = t
end

PlayerCharacterStateHogtied.on_exit = function (self, unit, t, next_state)
	local rewind_ms = LagCompensation.rewind_ms(self._is_server, self._is_local_unit, self._player)

	FirstPersonView.enter(t, self._first_person_mode_component, rewind_ms)

	local inventory_component = self._inventory_component

	if inventory_component.wielded_slot == "slot_unarmed" then
		PlayerUnitVisualLoadout.wield_slot(INVENTORY_SLOT_TO_WIELD_ON_EXIT, unit, t)
	end

	self._hogtied_state_input.hogtie = false

	self._assist:stop()

	local locomotion_force_rotation_component = self._locomotion_force_rotation_component

	if locomotion_force_rotation_component.use_force_rotation then
		ForceRotation.stop(locomotion_force_rotation_component)
	end

	local is_server = self._is_server

	if is_server then
		self._fx_extension:trigger_exclusive_gear_wwise_event(STINGER_EXIT_ALIAS, STINGER_PROPERTIES)

		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local player = player_unit_spawn_manager:owner(unit)
		local is_player_alive = player:unit_is_alive()

		if is_player_alive then
			local rescued_by_player = true
			local state_name = "hogtied"
			local time_in_captivity = t - self._entered_state_t

			Managers.telemetry_events:player_exits_captivity(player, rescued_by_player, state_name, time_in_captivity)
		end

		self._entered_state_t = nil
	end
end

PlayerCharacterStateHogtied.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	local assist_done = self._assist:update(dt, t)

	self:_update_close_friendlies(unit)

	return self:_check_transition(unit, dt, t, next_state_params, assist_done)
end

PlayerCharacterStateHogtied._check_transition = function (self, unit, dt, t, next_state_params, assist_done)
	if assist_done then
		return "walking"
	end

	return nil
end

PlayerCharacterStateHogtied._update_close_friendlies = function (self, unit)
	local coherency_extension = ScriptUnit.has_extension(unit, "coherency_system")
	local in_coherence_units = coherency_extension:in_coherence_units()
	local num_non_hogtied_nearby_friendlies = 0

	for in_coherence_unit, _ in pairs(in_coherence_units) do
		local unit_data_extension = ScriptUnit.extension(in_coherence_unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")
		local is_hogtied = PlayerUnitStatus.is_hogtied(character_state_component)

		if not is_hogtied then
			num_non_hogtied_nearby_friendlies = num_non_hogtied_nearby_friendlies + 1
		end
	end

	local inventory_component = self._inventory_component

	if inventory_component.wielded_slot == "slot_unarmed" then
		if num_non_hogtied_nearby_friendlies >= 1 and not self._played_close_animation then
			local animation_extension = ScriptUnit.extension(unit, "animation_system")

			animation_extension:anim_event(ANIM_EVENT_ON_FRIENDLIES_CLOSE)

			self._played_close_animation = true
		elseif num_non_hogtied_nearby_friendlies == 0 and self._played_close_animation then
			local animation_extension = ScriptUnit.extension(unit, "animation_system")

			animation_extension:anim_event(ANIM_EVENT_ON_ENTER)

			self._played_close_animation = false
		end
	end
end

return PlayerCharacterStateHogtied
