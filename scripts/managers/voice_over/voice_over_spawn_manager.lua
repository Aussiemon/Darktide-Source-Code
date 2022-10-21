local DialogueBreedSettings = require("scripts/settings/dialogue/dialogue_breed_settings")
local LevelProps = require("scripts/settings/level_prop/level_props")
local NetworkLookup = require("scripts/network_lookup/network_lookup")
local VoiceOverSpawnManager = class("VoiceOverSpawnManager")

VoiceOverSpawnManager.init = function (self, is_server)
	self._is_server = is_server
	self._level = nil
	self._unit_spawner_manager = Managers.state.unit_spawner
	self._voice_over_units = {}
end

VoiceOverSpawnManager.destroy = function (self)
	self._unit_spawner_manager = nil
end

VoiceOverSpawnManager.on_gameplay_post_init = function (self, level)
	fassert(self._is_server, "[VoiceOverSpawnManager] server only method.")

	self._level = level
	local vo_classes_2d = NetworkLookup.voice_classes_2d

	for i = 1, #vo_classes_2d do
		local vo_class = vo_classes_2d[i]
		local breed_dialogue_settings = DialogueBreedSettings[vo_class]

		self:_create_units(breed_dialogue_settings)
	end
end

VoiceOverSpawnManager.delete_units = function (self)
	local unit_spawner_manager = self._unit_spawner_manager

	for _, vo_unit in pairs(self._voice_over_units) do
		unit_spawner_manager:mark_for_deletion(vo_unit)
	end

	self._voice_over_units = {}
end

VoiceOverSpawnManager._create_units = function (self, dialogue_breed_settings)
	fassert(dialogue_breed_settings.prop_name, "[VoiceOverSpawnManager] Dialogue breed settings should contain prop_name.")

	local unit_spawner_manager = self._unit_spawner_manager
	local props_settings = LevelProps[dialogue_breed_settings.prop_name]
	local unit_name = props_settings.unit_name
	local unit_template_name = props_settings.unit_template_name
	local voice_over_settings = table.clone(props_settings)
	local voice_profiles = dialogue_breed_settings.wwise_voices

	for _, voice_profile in pairs(voice_profiles) do
		local vo_unit = unit_spawner_manager:spawn_network_unit(unit_name, unit_template_name, nil, nil, nil, voice_over_settings)
		local dialogue_extension = ScriptUnit.has_extension(vo_unit, "dialogue_system")

		dialogue_extension:set_voice_profile_data(dialogue_breed_settings.vo_class_name, voice_profile)
		dialogue_extension:init_faction_memory(dialogue_breed_settings.dialogue_memory_faction_name)

		dialogue_extension._is_network_synced = dialogue_breed_settings.is_network_synced
		self._voice_over_units[voice_profile] = vo_unit
	end
end

VoiceOverSpawnManager.voice_over_unit = function (self, voice_profile)
	return self._voice_over_units[voice_profile]
end

return VoiceOverSpawnManager
