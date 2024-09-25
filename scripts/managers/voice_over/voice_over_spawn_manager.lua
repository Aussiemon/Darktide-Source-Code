﻿-- chunkname: @scripts/managers/voice_over/voice_over_spawn_manager.lua

local DialogueBreedSettings = require("scripts/settings/dialogue/dialogue_breed_settings")
local LevelProps = require("scripts/settings/level_prop/level_props")
local Vo = require("scripts/utilities/vo")
local VoiceOverSpawnManager = class("VoiceOverSpawnManager")
local _default_vo_profile = "sergeant_a"

VoiceOverSpawnManager.init = function (self, is_server, mission_giver_vo_override)
	self._is_server = is_server
	self._level = nil
	self._unit_spawner_manager = Managers.state.unit_spawner
	self._voice_over_units = {}
	self.mission_giver_vo_override = mission_giver_vo_override
end

VoiceOverSpawnManager.on_gameplay_post_init = function (self, level)
	self._level = level

	local vo_classes_2d = DialogueBreedSettings.voice_classes_2d
	local mission_info = Managers.state.mission:mission()
	local mission_brief_vo = mission_info and mission_info.mission_brief_vo

	if mission_brief_vo then
		local mission_giver_packs = mission_brief_vo.mission_giver_packs

		if mission_giver_packs then
			local mission_giver = self:current_voice_profile()
			local pack = mission_giver_packs[mission_giver]

			if pack then
				vo_classes_2d = pack
			end
		end
	end

	local circumstance_info = Managers.state.circumstance:template()
	local additional_vo_units = circumstance_info.vo_units

	if additional_vo_units then
		for _, vo_class in pairs(additional_vo_units) do
			local num_vo_classes_2d = #vo_classes_2d

			vo_classes_2d[num_vo_classes_2d + 1] = vo_class
		end
	end

	for i = 1, #vo_classes_2d do
		local vo_class = vo_classes_2d[i]
		local breed_dialogue_settings = DialogueBreedSettings[vo_class]

		self:create_units(breed_dialogue_settings)
	end

	Vo.mission_giver_check_event()
end

VoiceOverSpawnManager.delete_units = function (self)
	local voice_over_units, unit_spawner_manager = self._voice_over_units, self._unit_spawner_manager

	for voice_profile, vo_unit in pairs(voice_over_units) do
		unit_spawner_manager:mark_for_deletion(vo_unit)

		voice_over_units[voice_profile] = nil
	end
end

VoiceOverSpawnManager.create_units = function (self, dialogue_breed_settings)
	local voice_profiles = dialogue_breed_settings.wwise_voices

	for _, voice_profile in pairs(voice_profiles) do
		self:create_unit(dialogue_breed_settings, voice_profile)
	end
end

VoiceOverSpawnManager.create_unit = function (self, dialogue_breed_settings, voice_profile, optional_position)
	local unit_spawner_manager = self._unit_spawner_manager
	local props_settings = LevelProps[dialogue_breed_settings.prop_name]
	local voice_over_settings = table.clone(props_settings)
	local unit_name = props_settings.unit_name
	local unit_template_name = props_settings.unit_template_name
	local vo_unit = unit_spawner_manager:spawn_network_unit(unit_name, unit_template_name, optional_position, nil, nil, voice_over_settings)
	local dialogue_extension = ScriptUnit.extension(vo_unit, "dialogue_system")

	dialogue_extension:set_voice_profile_data(dialogue_breed_settings.vo_class_name, dialogue_breed_settings.wwise_voice_switch_group, voice_profile)
	dialogue_extension:init_faction_memory(dialogue_breed_settings.dialogue_memory_faction_name)

	dialogue_extension._is_network_synced = dialogue_breed_settings.is_network_synced

	local voice_over_units = self._voice_over_units

	voice_over_units[voice_profile] = vo_unit

	if optional_position then
		return vo_unit
	end
end

VoiceOverSpawnManager.voice_over_unit = function (self, voice_profile)
	return self._voice_over_units[voice_profile]
end

VoiceOverSpawnManager.voice_over_units = function (self)
	return self._voice_over_units
end

VoiceOverSpawnManager.current_voice_profile = function (self)
	if self.mission_giver_vo_override and self.mission_giver_vo_override ~= "none" then
		return self.mission_giver_vo_override
	end

	local mission_info = Managers.state.mission:mission()
	local mission_brief_vo = mission_info and mission_info.mission_brief_vo
	local vo_profile = mission_brief_vo and mission_brief_vo.vo_profile

	return vo_profile or _default_vo_profile
end

return VoiceOverSpawnManager
