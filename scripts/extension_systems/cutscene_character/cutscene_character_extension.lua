local CinematicSceneSettings = require("scripts/settings/cinematic_scene/cinematic_scene_settings")
local MasterItems = require("scripts/backend/master_items")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")
local CutsceneCharacterExtension = class("CutsceneCharacterExtension")

CutsceneCharacterExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	self._is_server = extension_init_context.is_server
	self._cinematic_name = CinematicSceneSettings.CINEMATIC_NAMES.none
	self._character_type = "none"
	self._breed_name = "none"
	self._player_unique_id = nil
	self._prop_items = {}
end

CutsceneCharacterExtension.destroy = function (self)
	if Managers.state and Managers.state.extension then
		local cutscene_character_system = Managers.state.extension:system("cutscene_character_system")

		cutscene_character_system:unregister_cutscene_character(self)
	end
end

CutsceneCharacterExtension.setup_from_component = function (self, cinematic_name, character_type, breed_name, prop_items, slot)
	self._cinematic_name = cinematic_name
	self._character_type = character_type
	self._breed_name = breed_name
	self._prop_items = prop_items
	self._slot = slot

	if Managers.state and Managers.state.extension then
		local cutscene_character_system = Managers.state.extension:system("cutscene_character_system")

		cutscene_character_system:register_cutscene_character(self)
	end
end

CutsceneCharacterExtension.cinematic_name = function (self)
	return self._cinematic_name
end

CutsceneCharacterExtension.character_type = function (self)
	return self._character_type
end

CutsceneCharacterExtension.breed_name = function (self)
	return self._breed_name
end

CutsceneCharacterExtension.slot = function (self)
	return self._slot
end

CutsceneCharacterExtension._is_valid_for_cutscene = function (self, cinematic_name)
	local character_cinematic_name = self._cinematic_name
	local character_type = self._character_type
	local breed_name = self._breed_name
	local valid_character = character_type == "player" and breed_name ~= "none"
	local valid_cinematic = character_cinematic_name ~= CinematicSceneSettings.CINEMATIC_NAMES.none and character_cinematic_name == cinematic_name

	return valid_character and valid_cinematic
end

local NUM_CPT_PER_UNIT = 1

local function _check_component_amount(unit, components, component_name)
	if table.size(components) ~= NUM_CPT_PER_UNIT then
		Log.warning("[CutsceneCharacterExtension]", "Incorrect amount(%d / %d) of ScriptComponent('%s') for Unit(%s. %s)", table.size(components), NUM_CPT_PER_UNIT, component_name, unit, Unit.id_string(unit))

		return false
	end

	return true
end

CutsceneCharacterExtension._clear_loadout = function (self)
	if not Managers.state or not Managers.state.extension then
		return
	end

	local player_character_unit = self._unit
	local component_system = Managers.state.extension:system("component_system")
	local player_customization_components = component_system:get_components(player_character_unit, "PlayerCustomization")

	if _check_component_amount(player_character_unit, player_customization_components, "PlayerCustomization") then
		local player_customization_component = player_customization_components[1]

		player_customization_component:unspawn_items()

		return true
	end

	return false
end

local prop_items = {}

CutsceneCharacterExtension._set_loadout = function (self, items)
	if not Managers.state or not Managers.state.extension then
		return
	end

	local player_character_unit = self._unit
	local component_system = Managers.state.extension:system("component_system")
	local player_customization_components = component_system:get_components(player_character_unit, "PlayerCustomization")

	if _check_component_amount(player_character_unit, player_customization_components, "PlayerCustomization") then
		local player_customization_component = player_customization_components[1]
		local mission_manager = Managers.state.mission
		local mission_template = mission_manager and mission_manager:mission()
		local items_list = {}

		table.table_to_array(items, items_list, true)
		player_customization_component:spawn_items(items_list, mission_template)
		table.clear(prop_items)

		local prop_item_names = self._prop_items
		local item_definitions = MasterItems.get_cached()

		for i = 1, #prop_item_names, 1 do
			local item_name = prop_item_names[i]
			prop_items[i] = rawget(item_definitions, item_name)
		end

		player_customization_component:spawn_items(prop_items, mission_template)

		return true
	end

	return false
end

CutsceneCharacterExtension.has_player_assigned = function (self)
	return self._player_unique_id ~= nil
end

CutsceneCharacterExtension.assign_player_loadout = function (self, player_unique_id, items)
	if self:_set_loadout(items) then
		self._player_unique_id = player_unique_id
	end
end

CutsceneCharacterExtension.unassign_player_loadout = function (self)
	if self:_clear_loadout() then
		self._player_unique_id = nil
	end
end

CutsceneCharacterExtension.override_animation_state_machine = function (self, weapon, animation_event)
	local weapon_template = WeaponTemplates[weapon.weapon_template]
	local state_machine_3p, _ = WeaponTemplate.state_machines(weapon_template, self._breed_name)

	Unit.set_animation_state_machine(self._unit, state_machine_3p)
	Unit.enable_animation_state_machine(self._unit)

	self._animation_state_machine_overwritten = true
	self._walking_animation = animation_event
end

CutsceneCharacterExtension.start_weapon_specific_walk_animation = function (self)
	if self._animation_state_machine_overwritten and self._walking_animation then
		Unit.animation_event(self._unit, self._walking_animation)
	end
end

return CutsceneCharacterExtension
