-- chunkname: @scripts/extension_systems/character_state_machine/character_states/player_character_state_dead.lua

require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local FirstPersonView = require("scripts/utilities/first_person_view")
local Interrupt = require("scripts/utilities/attack/interrupt")
local Luggable = require("scripts/utilities/luggable")
local Pocketable = require("scripts/utilities/pocketable")
local Vo = require("scripts/utilities/vo")
local PlayerCharacterStateDead = class("PlayerCharacterStateDead", "PlayerCharacterStateBase")
local SFX_SOURCE = "head"
local STINGER_ALIAS = "disabled_enter"
local STINGER_PROPERTIES = {
	stinger_type = "teammate_died"
}

PlayerCharacterStateDead.init = function (self, character_state_init_context, ...)
	PlayerCharacterStateDead.super.init(self, character_state_init_context, ...)

	self._time_to_despawn = 0
end

PlayerCharacterStateDead.on_enter = function (self, unit, dt, t, previous_state, params)
	FirstPersonView.exit(t, self._first_person_mode_component)

	self._locomotion_steering_component.velocity_wanted = Vector3.zero()

	local ignore_immunity = true
	local inventory_component = self._inventory_component
	local visual_loadout_extension = self._visual_loadout_extension
	local is_server = self._is_server
	local physics_world = self._physics_world

	Interrupt.ability_and_action(t, unit, "dead", nil, ignore_immunity)
	Luggable.drop_luggable(t, unit, inventory_component, visual_loadout_extension, true)
	Pocketable.drop_pocketable(t, physics_world, is_server, unit, inventory_component, visual_loadout_extension)

	local health_ext = ScriptUnit.extension(unit, "health_system")

	health_ext:kill()

	self._time_to_despawn = t + (params.time_to_despawn_corpse or 0)

	if not self._triggered_ragdoll then
		self._animation_extension:anim_event("ragdoll")
		Managers.state.player_unit_spawn:register_player_unit_ragdoll(unit)

		self._triggered_ragdoll = true
	end

	if is_server then
		self._fx_extension:trigger_gear_wwise_event_with_source(STINGER_ALIAS, STINGER_PROPERTIES, SFX_SOURCE, true, true)
	end

	Vo.player_death_event(unit)
end

PlayerCharacterStateDead.on_exit = function (self, unit, t, next_state)
	return
end

PlayerCharacterStateDead.pre_update = function (self, unit, dt, t)
	if not self._triggered_ragdoll then
		self._animation_extension:anim_event("ragdoll")
		Managers.state.player_unit_spawn:register_player_unit_ragdoll(unit)

		self._triggered_ragdoll = true
	end
end

PlayerCharacterStateDead.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	if not self._is_server then
		return
	end

	if self._time_to_despawn and t > self._time_to_despawn then
		Managers.state.player_unit_spawn:despawn_safe(self._player)

		self._time_to_despawn = nil
	end
end

return PlayerCharacterStateDead
