-- chunkname: @scripts/extension_systems/cutscene_character/cutscene_companion_extension.lua

local Breeds = require("scripts/settings/breed/breeds")
local CinematicSceneSettings = require("scripts/settings/cinematic_scene/cinematic_scene_settings")
local CinematicSceneTemplates = require("scripts/settings/cinematic_scene/cinematic_scene_templates")
local MasterItems = require("scripts/backend/master_items")
local UIProfileSpawner = require("scripts/managers/ui/ui_profile_spawner")
local UIUnitSpawner = require("scripts/managers/ui/ui_unit_spawner")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")
local CutsceneCompanionExtension = class("CutsceneCompanionExtension")

CutsceneCompanionExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._extension_manager = extension_init_context.extension_manager
	self._unit = unit
	self._is_server = extension_init_context.is_server
	self._cinematic_name = CinematicSceneSettings.CINEMATIC_NAMES.none
	self._breed_name = "none"
	self._player_unique_id = nil
end

CutsceneCompanionExtension.destroy = function (self)
	local breed_name = self._breed_name
	local cutscene_character_system = self._extension_manager:system("cutscene_character_system")

	cutscene_character_system:unregister_cutscene_companion(self)
end

CutsceneCompanionExtension.setup_from_component = function (self, cinematic_name, breed_name, slot, starting_animation_event, walking_animation_event)
	self._cinematic_name = cinematic_name
	self._breed_name = breed_name
	self._slot = slot
	self._starting_animation_event = starting_animation_event ~= "" and starting_animation_event or nil
	self._walking_animation_event = walking_animation_event ~= "" and walking_animation_event or "to_walk"

	local cutscene_character_system = self._extension_manager:system("cutscene_character_system")

	cutscene_character_system:register_cutscene_companion(self)
	self:set_visibility(false)
end

CutsceneCompanionExtension.set_visibility = function (self, visibility)
	Unit.set_unit_visibility(self._unit, visibility, true)
end

CutsceneCompanionExtension.unit = function (self)
	return self._unit
end

CutsceneCompanionExtension.has_player_assigned = function (self)
	return self._player_unique_id ~= nil
end

CutsceneCompanionExtension.cinematic_name = function (self)
	return self._cinematic_name
end

CutsceneCompanionExtension.breed_name = function (self)
	return self._breed_name
end

CutsceneCompanionExtension.breed = function (self)
	return Breeds[self._breed_name]
end

CutsceneCompanionExtension.slot = function (self)
	return self._slot
end

CutsceneCompanionExtension.assign_player_unique_id = function (self, player_unique_id)
	self._player_unique_id = player_unique_id

	self:trigger_starting_animation_event()
	self:set_visibility(true)
end

CutsceneCompanionExtension.unassign_player_loadout = function (self)
	self._player_unique_id = nil
end

CutsceneCompanionExtension.trigger_starting_animation_event = function (self)
	local unit = self._unit
	local event = self._starting_animation_event

	if self:has_player_assigned() and event then
		Unit.enable_animation_state_machine(unit)
		Unit.animation_event(unit, event)
	end
end

CutsceneCompanionExtension.trigger_walk_animation_event = function (self)
	local unit = self._unit
	local event = self._walking_animation_event

	if self:has_player_assigned() and event and Unit.has_animation_event(unit, event) then
		Unit.enable_animation_state_machine(unit)
		Unit.animation_event(unit, event)
	end
end

return CutsceneCompanionExtension
