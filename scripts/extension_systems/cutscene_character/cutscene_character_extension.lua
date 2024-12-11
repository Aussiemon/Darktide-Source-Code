-- chunkname: @scripts/extension_systems/cutscene_character/cutscene_character_extension.lua

local Breeds = require("scripts/settings/breed/breeds")
local CinematicSceneSettings = require("scripts/settings/cinematic_scene/cinematic_scene_settings")
local CinematicSceneTemplates = require("scripts/settings/cinematic_scene/cinematic_scene_templates")
local MasterItems = require("scripts/backend/master_items")
local UIProfileSpawner = require("scripts/managers/ui/ui_profile_spawner")
local UIUnitSpawner = require("scripts/managers/ui/ui_unit_spawner")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")
local CutsceneCharacterExtension = class("CutsceneCharacterExtension")
local AnimationType = {
	Inventory = 1,
	None = 0,
	Weapon = 2,
}

CutsceneCharacterExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._extension_manager = extension_init_context.extension_manager
	self._unit = unit
	self._is_server = extension_init_context.is_server
	self._cinematic_name = CinematicSceneSettings.CINEMATIC_NAMES.none
	self._character_type = "none"
	self._breed_name = "none"
	self._player_unique_id = nil
	self._prop_items = {}
	self._equip_slot_on_loadout_assign = ""

	local mission_manager = Managers.state.mission
	local mission_template = mission_manager and mission_manager:mission()

	self._mission_template = mission_template
	self._is_loading_profile = false
	self._activate_post_spawn_weapon_specific_walk_animation = false
	self._activate_post_spawn_inventory_specific_walk_animation = false

	local world = extension_init_context.world
	local unit_spawner = UIUnitSpawner:new(world)
	local level_unit_id = Unit.id_string(unit)
	local camera
	local force_highest_lod_step = true

	self._profile_spawner = UIProfileSpawner:new("CutsceneCharacterExtension_" .. level_unit_id, world, camera, unit_spawner, force_highest_lod_step, mission_template)
	self._inventory_animation_event = nil
	self._weapon_animation_event = nil
	self._current_state_machine = AnimationType.None
end

CutsceneCharacterExtension.destroy = function (self)
	self._profile_spawner:destroy()

	local cutscene_character_system = self._extension_manager:system("cutscene_character_system")

	cutscene_character_system:unregister_cutscene_character(self)
end

CutsceneCharacterExtension.setup_from_component = function (self, cinematic_name, character_type, breed_name, prop_items, slot, inventory_animation_event, equip_slot_on_loadout_assign)
	self._cinematic_name = cinematic_name
	self._character_type = character_type
	self._breed_name = breed_name
	self._prop_items = prop_items
	self._slot = slot
	self._equip_slot_on_loadout_assign = equip_slot_on_loadout_assign

	if cinematic_name ~= "none" and self:_check_valid_animation(cinematic_name, inventory_animation_event, AnimationType.Inventory) then
		self._inventory_animation_event = inventory_animation_event
	end

	local cutscene_character_system = self._extension_manager:system("cutscene_character_system")

	cutscene_character_system:register_cutscene_character(self)
end

CutsceneCharacterExtension.update = function (self, unit, dt, t)
	self._profile_spawner:update(dt, t)

	if self._is_loading_profile then
		local bypass_check_streaming = true

		if self._profile_spawner:spawned(bypass_check_streaming) then
			self._is_loading_profile = false

			if self._activate_post_spawn_weapon_specific_walk_animation then
				self:_start_weapon_specific_walk_animation()

				self._activate_post_spawn_weapon_specific_walk_animation = false
			end

			if self._activate_post_spawn_inventory_specific_walk_animation then
				self:_start_inventory_specific_walk_animation()

				self._activate_post_spawn_inventory_specific_walk_animation = false
			end
		end
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

	local available_animation_events
	local cinematic_template = CinematicSceneTemplates[cinematic_name]

	if animation_type == AnimationType.Inventory then
		available_animation_events = cinematic_template.available_inventory_animation_events
	elseif animation_type == AnimationType.Weapon then
		available_animation_events = cinematic_template.available_weapon_animation_events
	end

	local valid_animation = table.contains(available_animation_events, animation_event)

	return valid_animation
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
	local extension_manager = self._extension_manager
	local player_character_unit = self._unit
	local component_system = extension_manager:system("component_system")
	local player_customization_components = component_system:get_components(player_character_unit, "PlayerCustomization")

	self._equipped_weapon = nil

	if _check_component_amount(player_character_unit, player_customization_components, "PlayerCustomization") then
		local player_customization_component = player_customization_components[1]

		player_customization_component:unspawn_items()
	end
end

CutsceneCharacterExtension.has_player_assigned = function (self)
	return self._player_unique_id ~= nil or self._profile_spawner:loading()
end

local PROP_ITEMS = {}

CutsceneCharacterExtension.assign_player_loadout = function (self, player_unique_id, items)
	local cinematic_name = self._cinematic_name
	local cinematic_template = CinematicSceneTemplates[cinematic_name]
	local ignored_slots = cinematic_template.ignored_slots
	local equip_slot = self._equip_slot_on_loadout_assign
	local ignore_wield_on_assigned = equip_slot == ""

	for j = 1, #ignored_slots do
		local ignored_slot_name = ignored_slots[j]

		self._profile_spawner:ignore_slot(ignored_slot_name)

		if equip_slot ~= "" and ignored_slot_name == equip_slot then
			ignore_wield_on_assigned = true
		end
	end

	if equip_slot ~= "" and not ignore_wield_on_assigned then
		self._profile_spawner:wield_slot(equip_slot)
	end

	local profile = Managers.player:player_from_unique_id(player_unique_id):profile()
	local unit = self._unit
	local position = Unit.world_position(unit, 1)
	local rotation = Unit.world_rotation(unit, 1)
	local scale = Unit.world_scale(unit, 1)
	local animation_event, face_animation_event
	local force_highest_mip = true
	local disable_hair_state_machine = false
	local state_machine
	local ignore_state_machine = true
	local mission_template = self._mission_template
	local face_state_machine_key = mission_template and mission_template.face_state_machine_key

	self._profile_spawner:spawn_profile(profile, position, rotation, scale, state_machine, animation_event, face_state_machine_key, face_animation_event, force_highest_mip, disable_hair_state_machine, unit, ignore_state_machine)
	self:_load_props()

	self._player_unique_id = player_unique_id
	self._is_loading_profile = true
end

CutsceneCharacterExtension._load_props = function (self)
	table.clear(PROP_ITEMS)

	local prop_item_names = self._prop_items
	local item_definitions = MasterItems.get_cached()

	for i = 1, #prop_item_names do
		local item_name = prop_item_names[i]

		PROP_ITEMS[i] = rawget(item_definitions, item_name)
	end

	local extension_manager = self._extension_manager
	local component_system = extension_manager:system("component_system")
	local player_character_unit = self._unit
	local player_customization_components = component_system:get_components(player_character_unit, "PlayerCustomization")

	if _check_component_amount(player_character_unit, player_customization_components, "PlayerCustomization") then
		local player_customization_component = player_customization_components[1]
		local mission_manager = Managers.state.mission
		local mission_template = mission_manager and mission_manager:mission()

		player_customization_component:spawn_items(PROP_ITEMS, mission_template)
	end
end

CutsceneCharacterExtension.unassign_player_loadout = function (self)
	if self._current_state_machine ~= AnimationType.None then
		local unit = self._unit

		Unit.disable_animation_state_machine(unit)

		self._current_state_machine = AnimationType.None
	end

	self:_clear_loadout()
	self._profile_spawner:reset()

	self._player_unique_id = nil
end

CutsceneCharacterExtension.set_equipped_weapon = function (self, weapon)
	self._equipped_weapon = weapon
end

CutsceneCharacterExtension.wield_slot = function (self, slot_name)
	self._profile_spawner:wield_slot(slot_name)
end

CutsceneCharacterExtension.set_weapon_animation_event = function (self, animation_event)
	if self:_check_valid_animation(self._cinematic_name, animation_event, AnimationType.Weapon) then
		self._weapon_animation_event = animation_event
	end
end

CutsceneCharacterExtension.start_weapon_specific_walk_animation = function (self)
	if self._weapon_animation_event and self:has_player_assigned() then
		local bypass_check_streaming = true

		if self._profile_spawner:spawned(bypass_check_streaming) then
			self:_start_weapon_specific_walk_animation()

			self._activate_post_spawn_weapon_specific_walk_animation = false
		else
			self._activate_post_spawn_weapon_specific_walk_animation = true
		end
	end
end

CutsceneCharacterExtension._start_weapon_specific_walk_animation = function (self)
	local unit = self._unit
	local event = self._weapon_animation_event

	if self._current_state_machine ~= AnimationType.Weapon then
		local weapon_template = WeaponTemplates[self._equipped_weapon.weapon_template]
		local state_machine_3p, _ = WeaponTemplate.state_machines(weapon_template, self._breed_name)

		Unit.set_animation_state_machine(unit, state_machine_3p)

		self._current_state_machine = AnimationType.Weapon
	end

	if Unit.has_animation_event(unit, event) then
		Unit.animation_event(unit, event)
	else
		Log.error(CutsceneCharacterExtension.DEBUG_TAG, "No animation event called %q in state machine, using fallback weapon?", event)
	end
end

CutsceneCharacterExtension.start_inventory_specific_walk_animation = function (self)
	if self._inventory_animation_event and self:has_player_assigned() then
		local bypass_check_streaming = true

		if self._profile_spawner:spawned(bypass_check_streaming) then
			self:_start_inventory_specific_walk_animation()

			self._activate_post_spawn_inventory_specific_walk_animation = false
		else
			self._activate_post_spawn_inventory_specific_walk_animation = true
		end
	end
end

CutsceneCharacterExtension._start_inventory_specific_walk_animation = function (self)
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

CutsceneCharacterExtension.unit_3p_from_slot = function (self, slot_id)
	return self._profile_spawner:unit_3p_from_slot(slot_id)
end

return CutsceneCharacterExtension
