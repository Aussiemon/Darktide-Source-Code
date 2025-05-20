-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/communication_hack_device_interface.lua

local LevelProps = require("scripts/settings/level_prop/level_props")
local PlayerUnitData = require("scripts/extension_systems/unit_data/utilities/player_unit_data")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local CommunicationHackInterfaceDevice = class("CommunicationHackInterfaceDevice")
local SINUS_LOOPING_SOUND_ALIAS = "sfx_minigame_sinus_loop"
local SINUS_LOOPING_SOUND_ALIAS_A = "sfx_minigame_sinus_loop_a"
local SINUS_LOOPING_SOUND_ALIAS_B = "sfx_minigame_sinus_loop_b"
local FX_SOURCE_NAME = "_speaker"

CommunicationHackInterfaceDevice.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	local is_server = context.is_server
	local is_husk = context.is_husk
	local owner_unit = context.owner_unit

	self._is_server = is_server
	self._game_object_id = NetworkConstants.invalid_game_object_id
	self._interface_unit = nil

	if is_server then
		local unit_data_extension = ScriptUnit.extension(context.owner_unit, "unit_data_system")

		self._minigame_character_state_component = unit_data_extension:write_component("minigame_character_state")

		local props_settings = LevelProps.minigame_interface
		local unit_spawner_manager = Managers.state.unit_spawner
		local interface_unit_name = props_settings.unit_name
		local interface_unit, game_object_id = unit_spawner_manager:spawn_network_unit(interface_unit_name, "level_prop", nil, nil, nil, props_settings)

		self._game_object_id = game_object_id
		self._interface_unit = interface_unit

		if not is_husk then
			self._wwise_world = context.wwise_world
			self._fx_source_name = fx_sources[FX_SOURCE_NAME]
			self._is_husk = is_husk
			self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")

			local minigame_extension = ScriptUnit.fetch_component_extension(interface_unit, "minigame_system")
			local minigame_type = minigame_extension:minigame_type()

			self._sinus_looping_sound_components = {}

			if minigame_type == "frequency" then
				self._play_sinus_loop = true

				local owner_unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
				local sinus_looping_sound_component_name = PlayerUnitData.looping_sound_component_name(SINUS_LOOPING_SOUND_ALIAS)

				self._sinus_looping_sound_components[SINUS_LOOPING_SOUND_ALIAS] = owner_unit_data_extension:read_component(sinus_looping_sound_component_name)

				local sinus_looping_sound_component_name_a = PlayerUnitData.looping_sound_component_name(SINUS_LOOPING_SOUND_ALIAS_A)

				self._sinus_looping_sound_components[SINUS_LOOPING_SOUND_ALIAS_A] = owner_unit_data_extension:read_component(sinus_looping_sound_component_name_a)

				local sinus_looping_sound_component_name_b = PlayerUnitData.looping_sound_component_name(SINUS_LOOPING_SOUND_ALIAS_B)

				self._sinus_looping_sound_components[SINUS_LOOPING_SOUND_ALIAS_B] = owner_unit_data_extension:read_component(sinus_looping_sound_component_name_b)
			end
		end
	end
end

CommunicationHackInterfaceDevice.destroy = function (self)
	if self._is_server then
		self._minigame_character_state_component.interface_level_unit_id = NetworkConstants.invalid_level_unit_id
		self._minigame_character_state_component.interface_game_object_id = NetworkConstants.invalid_game_object_id
		self._minigame_character_state_component.interface_is_level_unit = true
		self._minigame_character_state_component.pocketable_device_active = false

		local unit_spawner_manager = Managers.state.unit_spawner

		unit_spawner_manager:mark_for_deletion(self._interface_unit)

		self._interface_unit = nil

		if not self._is_husk and self._play_sinus_loop then
			for alias, sound_component in pairs(self._sinus_looping_sound_components) do
				if sound_component.is_playing then
					self._fx_extension:stop_looping_wwise_event(alias)
				end
			end
		end
	end
end

CommunicationHackInterfaceDevice.wield = function (self)
	if self._is_server then
		self._minigame_character_state_component.interface_level_unit_id = NetworkConstants.invalid_level_unit_id
		self._minigame_character_state_component.interface_game_object_id = self._game_object_id
		self._minigame_character_state_component.interface_is_level_unit = false
		self._minigame_character_state_component.pocketable_device_active = false

		if not self._is_husk and self._play_sinus_loop then
			local fx_extension = self._fx_extension
			local fx_source_name = self._fx_source_name

			for alias, sound_component in pairs(self._sinus_looping_sound_components) do
				if not sound_component.is_playing then
					fx_extension:trigger_looping_wwise_event(alias, fx_source_name)
				end
			end
		end
	end
end

CommunicationHackInterfaceDevice.unwield = function (self)
	if self._is_server then
		self._minigame_character_state_component.interface_level_unit_id = NetworkConstants.invalid_level_unit_id
		self._minigame_character_state_component.interface_game_object_id = NetworkConstants.invalid_game_object_id
		self._minigame_character_state_component.interface_is_level_unit = true
		self._minigame_character_state_component.pocketable_device_active = false

		if not self._is_husk and self._play_sinus_loop then
			for alias, sound_component in pairs(self._sinus_looping_sound_components) do
				if sound_component.is_playing then
					self._fx_extension:stop_looping_wwise_event(alias)
				end
			end
		end
	end
end

CommunicationHackInterfaceDevice.fixed_update = function (self, unit, dt, t, frame)
	return
end

CommunicationHackInterfaceDevice.update = function (self, unit, dt, t)
	return
end

CommunicationHackInterfaceDevice.update_first_person_mode = function (self, first_person_mode)
	return
end

implements(CommunicationHackInterfaceDevice, WieldableSlotScriptInterface)

return CommunicationHackInterfaceDevice
