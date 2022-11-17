local CinematicSceneSettings = require("scripts/settings/cinematic_scene/cinematic_scene_settings")
local MasterItems = require("scripts/backend/master_items")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")
local CinematicSceneTemplates = require("scripts/settings/cinematic_scene/cinematic_scene_templates")
local Breeds = require("scripts/settings/breed/breeds")
local CutsceneCharacterExtension = class("CutsceneCharacterExtension")
local AnimationType = {
	Weapon = 2,
	Inventory = 1,
	None = 0
}

CutsceneCharacterExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	self._is_server = extension_init_context.is_server
	self._cinematic_name = CinematicSceneSettings.CINEMATIC_NAMES.none
	self._character_type = "none"
	self._breed_name = "none"
	self._player_unique_id = nil
	self._prop_items = {}
	self._resource_list = {}
	self._packages_loading = 0
	self._inventory_animation_event = nil
	self._weapon_animation_event = nil
	self._current_state_machine = AnimationType.None
end

CutsceneCharacterExtension.destroy = function (self)
	if Managers.state and Managers.state.extension then
		local cutscene_character_system = Managers.state.extension:system("cutscene_character_system")

		cutscene_character_system:unregister_cutscene_character(self)
	end
end

CutsceneCharacterExtension.setup_from_component = function (self, cinematic_name, character_type, breed_name, prop_items, slot, inventory_animation_event)
	self._cinematic_name = cinematic_name
	self._character_type = character_type
	self._breed_name = breed_name
	self._prop_items = prop_items
	self._slot = slot

	if cinematic_name ~= "none" and self:_check_valid_animation(cinematic_name, inventory_animation_event, AnimationType.Inventory) then
		self._inventory_animation_event = inventory_animation_event
	end

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

CutsceneCharacterExtension._check_valid_animation = function (self, cinematic_name, animation_event, animation_type)
	if not animation_event or animation_event == "none" then
		return false
	end

	local available_animation_events = nil
	local cinematic_template = CinematicSceneTemplates[cinematic_name]

	if animation_type == AnimationType.Inventory then
		available_animation_events = cinematic_template.available_inventory_animation_events
	elseif animation_type == AnimationType.Weapon then
		available_animation_events = cinematic_template.available_weapon_animation_events
	end

	local valid_animation = table.contains(available_animation_events, animation_event)

	return valid_animation
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
	self._equipped_weapon = nil

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
		local slot_equip_order = PlayerCharacterConstants.slot_equip_order
		local items_by_slot_order = {}

		for slot, item in pairs(items) do
			local order = table.find(slot_equip_order, slot)
			items_by_slot_order[order] = item
		end

		local keys_ordered = {}

		table.keys(items_by_slot_order, keys_ordered)
		table.sort(keys_ordered)

		local items_list = {}

		for index, keys in ipairs(keys_ordered) do
			items_list[index] = items_by_slot_order[keys]
		end

		player_customization_component:spawn_items(items_list, mission_template)
		table.clear(prop_items)

		local prop_item_names = self._prop_items
		local item_definitions = MasterItems.get_cached()

		for i = 1, #prop_item_names do
			local item_name = prop_item_names[i]
			prop_items[i] = rawget(item_definitions, item_name)
		end

		player_customization_component:spawn_items(prop_items, mission_template)

		local slot_body_face_unit = player_customization_component:unit_in_slot("slot_body_face")

		if slot_body_face_unit then
			for slot, item in pairs(items) do
				if item and item.hide_eyebrows ~= nil then
					local hide_eyebrows = item.hide_eyebrows

					Unit.set_visibility(slot_body_face_unit, "eyebrows", not hide_eyebrows, true)
				end

				if item and item.hide_beard ~= nil then
					local hide_beard = item.hide_beard

					Unit.set_visibility(slot_body_face_unit, "beard", not hide_beard, true)
				end
			end
		end

		return true
	end

	return false
end

CutsceneCharacterExtension.has_player_assigned = function (self)
	return self._player_unique_id ~= nil or self._packages_loading > 0
end

CutsceneCharacterExtension._on_package_loaded = function (self, player_unique_id, items, id)
	self._resource_list[id] = true
	self._packages_loading = self._packages_loading - 1

	if self._packages_loading == 0 then
		if self:_set_loadout(items) then
			self._player_unique_id = player_unique_id
		else
			local package_manager = Managers.package

			for package_id, _ in pairs(self._resource_list) do
				package_manager:release(package_id)
			end
		end
	end
end

CutsceneCharacterExtension.assign_player_loadout = function (self, player_unique_id, items)
	local on_load_callback = callback(self, "_on_package_loaded", player_unique_id, items)
	local profile = Managers.player:player_from_unique_id(player_unique_id):profile()
	local package_manager = Managers.package
	local package_synchronizer_client = Managers.package_synchronization:synchronizer_client()
	local packages = package_synchronizer_client:resolve_profile_packages(profile)

	for alias, package_data in pairs(packages) do
		for package, _ in pairs(package_data.dependencies) do
			local id = package_manager:load(package, "CutsceneCharacterExtension", on_load_callback, true)
			self._resource_list[id] = false
			self._packages_loading = self._packages_loading + 1
		end
	end
end

CutsceneCharacterExtension.unassign_player_loadout = function (self)
	if self:_clear_loadout() then
		local package_manager = Managers.package

		for id, _ in pairs(self._resource_list) do
			package_manager:release(id)
		end

		table.clear(self._resource_list)

		self._player_unique_id = nil
		self._packages_loading = 0
	end
end

CutsceneCharacterExtension.set_equipped_weapon = function (self, weapon)
	self._equipped_weapon = weapon
end

CutsceneCharacterExtension.set_weapon_animation_event = function (self, animation_event)
	if self:_check_valid_animation(self._cinematic_name, animation_event, AnimationType.Weapon) then
		self._weapon_animation_event = animation_event
	end
end

CutsceneCharacterExtension.start_weapon_specific_walk_animation = function (self)
	if self._weapon_animation_event and self:has_player_assigned() then
		local unit = self._unit
		local event = self._weapon_animation_event

		if self._current_state_machine ~= AnimationType.Weapon then
			local weapon_template = WeaponTemplates[self._equipped_weapon.weapon_template]
			local state_machine_3p, _ = WeaponTemplate.state_machines(weapon_template, self._breed_name)

			Unit.set_animation_state_machine(unit, state_machine_3p)
			Unit.enable_animation_state_machine(unit)

			self._current_state_machine = AnimationType.Weapon
		end

		if Unit.has_animation_event(unit, event) then
			Unit.animation_event(unit, event)
		else
			Log.error(CutsceneCharacterExtension.DEBUG_TAG, "No animation event called %q in state machine, using fallback weapon?", event)
		end
	end
end

CutsceneCharacterExtension.start_inventory_specific_walk_animation = function (self)
	if self._inventory_animation_event and self:has_player_assigned() then
		if self._current_state_machine ~= AnimationType.Inventory then
			local breed = Breeds[self._breed_name]

			Unit.set_animation_state_machine(self._unit, breed.inventory_state_machine)
			Unit.enable_animation_state_machine(self._unit)
			Unit.animation_event(self._unit, self._equipped_weapon.inventory_animation_event)

			self._current_state_machine = AnimationType.Inventory
		end

		if self._inventory_animation_event ~= "unready_idle" then
			Unit.animation_event(self._unit, self._inventory_animation_event)
		end
	end
end

return CutsceneCharacterExtension
