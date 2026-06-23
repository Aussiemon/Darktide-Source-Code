-- chunkname: @scripts/extension_systems/unit_templates/utilities/unit_template.lua

local Breeds = require("scripts/settings/breed/breeds")
local MasterItems = require("scripts/backend/master_items")
local MinionAttackSelection = require("scripts/utilities/minion_attack_selection/minion_attack_selection")
local MinionAttackSelectionTemplates = require("scripts/settings/minion_attack_selection/minion_attack_selection_templates")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local PhaseSelection = require("scripts/utilities/phases/phase_selection")
local PlayerHeight = require("scripts/utilities/player_height")
local UnitTemplate = {}

local function _random_seeded_size_scale(seed, size_variation_range)
	local _, random_percentage = math.next_random(seed)
	local scale = math.lerp(size_variation_range[1], size_variation_range[2], random_percentage)

	return scale
end

local function _resolve_minion_inventory(inventory_template, zone_id, used_weapon_slot_names, attack_selection_template_name, breed_name, inventory_seed)
	local inventory

	inventory, inventory_seed = MinionVisualLoadout.resolve(inventory_template, zone_id, used_weapon_slot_names, breed_name, inventory_seed)

	return inventory, inventory_seed
end

UnitTemplate.position_rotation_from_game_object = function (session, object_id)
	local go_field = GameSession.game_object_field
	local position = go_field(session, object_id, "position")
	local rotation

	if GameSession.has_game_object_field(session, object_id, "rotation") then
		rotation = go_field(session, object_id, "rotation")
	else
		local yaw, pitch, roll = go_field(session, object_id, "yaw"), go_field(session, object_id, "pitch"), 0

		rotation = Quaternion.from_yaw_pitch_roll(yaw, pitch, roll)
	end

	return position, rotation
end

UnitTemplate.player_unit_name_position_rotation_from_game_object = function (session, object_id)
	local go_field = GameSession.game_object_field
	local breed_id = go_field(session, object_id, "breed_id")
	local breed_name = NetworkLookup.breed_names[breed_id]
	local breed = Breeds[breed_name]
	local unit_name = breed.base_unit
	local local_player_id = go_field(session, object_id, "local_player_id")
	local owner_peer_id = go_field(session, object_id, "owner_peer_id")
	local player = Managers.player:player(owner_peer_id, local_player_id)
	local profile = player:profile()
	local position, rotation = UnitTemplate.position_rotation_from_game_object(session, object_id)
	local random_seed = go_field(session, object_id, "random_seed")
	local third_person_scale = PlayerHeight.player_character_third_person_scale(breed, profile, random_seed)

	if third_person_scale ~= 1 then
		local pose = Matrix4x4.from_quaternion_position(rotation, position)

		Matrix4x4.set_scale(pose, Vector3(third_person_scale, third_person_scale, third_person_scale))

		return unit_name, pose
	end

	return unit_name, position, rotation
end

UnitTemplate.player_character_initial_items = function (game_mode_manager, profile, player)
	local initial_items = {}
	local archetype = profile.archetype
	local archetype_name = archetype.name
	local game_mode_settings = game_mode_manager:settings()
	local default_items = MasterItems.default_inventory(archetype_name, game_mode_settings)

	for slot_name, item in pairs(default_items) do
		initial_items[slot_name] = item
	end

	local visual_loadout = profile.visual_loadout

	for slot_name, item in pairs(visual_loadout) do
		initial_items[slot_name] = item
	end

	local human_controlled_initial_items_excluded_slots = game_mode_settings.human_controlled_initial_items_excluded_slots

	if human_controlled_initial_items_excluded_slots and player:is_human_controlled() then
		local num_slots = #human_controlled_initial_items_excluded_slots

		for ii = 1, num_slots do
			local slot_name = human_controlled_initial_items_excluded_slots[ii]

			initial_items[slot_name] = nil
		end
	end

	return initial_items
end

UnitTemplate.broadphase_radius_and_categories = function (breed, side_id)
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side(side_id)
	local side_name = side:name()
	local broadphase_radius, breed_type = breed.broadphase_radius, breed.breed_type
	local broadphase_categories = {
		side_name,
		breed_type,
	}

	if breed.broadphase_categories then
		table.append(broadphase_categories, breed.broadphase_categories)
	end

	return broadphase_radius, broadphase_categories
end

UnitTemplate.force_third_person_mode = function ()
	local force_third_person_mode = Managers.state.mission:force_third_person_mode()

	return force_third_person_mode
end

UnitTemplate.use_third_person_hub_camera = function ()
	local use_third_person_hub_camera = Managers.state.game_mode:use_third_person_hub_camera()

	return use_third_person_hub_camera
end

UnitTemplate.size_variation_pose_from_breed = function (position, rotation, size_variation_range, seed)
	local scale = _random_seeded_size_scale(seed, size_variation_range)
	local pose = Matrix4x4.from_quaternion_position(rotation, position)

	Matrix4x4.set_scale(pose, Vector3(scale, scale, scale))

	return pose
end

UnitTemplate.breed_unit_name_position_rotation_from_game_object = function (session, object_id)
	local go_field = GameSession.game_object_field
	local breed_id = go_field(session, object_id, "breed_id")
	local breed_name = NetworkLookup.breed_names[breed_id]
	local breed = Breeds[breed_name]
	local unit_name = breed.base_unit
	local position, rotation = UnitTemplate.position_rotation_from_game_object(session, object_id)
	local size_variation_range = breed.size_variation_range

	if size_variation_range then
		local random_seed = go_field(session, object_id, "random_seed")
		local pose = UnitTemplate.size_variation_pose_from_breed(position, rotation, size_variation_range, random_seed)

		return unit_name, pose
	end

	return unit_name, position, rotation
end

UnitTemplate.resolve_minion_attacks = function (init_data, breed, game_object_data, attack_selection_seed)
	local attack_selection_templates = breed.attack_selection_templates

	if attack_selection_templates == nil then
		return nil, nil, nil
	end

	local attack_selection_template_name = init_data.optional_attack_selection_template_name or MinionAttackSelection.match_template_by_tag(attack_selection_templates, "default")
	local attack_selection_template = MinionAttackSelectionTemplates[attack_selection_template_name]

	game_object_data.minion_attack_selection_template_id = NetworkLookup.minion_attack_selection_template_names[attack_selection_template_name]

	local mutator_attack_selection_template_override_plasma = Managers.state.mutator:mutator("mutator_attack_selection_template_override_plasma")

	if mutator_attack_selection_template_override_plasma then
		attack_selection_template_name = "renegade_captain_plasma_pistol"
		game_object_data.minion_attack_selection_template_id = NetworkLookup.minion_attack_selection_template_names[attack_selection_template_name]
	end

	local combat_range_multi_config_key = attack_selection_template and attack_selection_template.combat_range_multi_config_key
	local selected_attack_names, used_weapon_slot_names = MinionAttackSelection.generate(attack_selection_template_name, attack_selection_seed)

	return attack_selection_template_name, selected_attack_names, used_weapon_slot_names, combat_range_multi_config_key
end

UnitTemplate.resolve_minion_inventory_and_attacks = function (init_data, breed, game_object_data, attack_selection_seed, inventory_seed)
	local mission = Managers.state.mission:mission()
	local zone_id = mission.zone_id
	local game_mode_name = Managers.state.game_mode:game_mode_name()

	if game_mode_name == "expedition" then
		zone_id = "dust"
	end

	if breed.has_havoc_inventory_override and (Managers.state.game_mode:game_mode():extension("havoc") or Managers.state.mutator:mutator("mutator_enable_twin_havoc_inventory") or game_mode_name == "expedition") then
		zone_id = breed.has_havoc_inventory_override
	end

	local attack_selection_template_name, selected_attack_names, used_weapon_slot_names, combat_range_multi_config_key = UnitTemplate.resolve_minion_attacks(init_data, breed, game_object_data, attack_selection_seed)
	local inventory

	if breed.inventory then
		inventory, inventory_seed = _resolve_minion_inventory(breed.inventory, zone_id, used_weapon_slot_names, attack_selection_template_name, breed.name, inventory_seed)
	end

	local phase_template

	if breed.phase_template then
		phase_template = PhaseSelection.resolve(breed.phase_template, used_weapon_slot_names)
	end

	return inventory, inventory_seed, attack_selection_template_name, selected_attack_names, phase_template, combat_range_multi_config_key
end

UnitTemplate.resolve_minion_husk_inventory = function (breed, game_session, game_object_id, attack_selection_seed, inventory_seed)
	local mission = Managers.state.mission:mission()
	local zone_id = mission.zone_id

	if breed.has_havoc_inventory_override and (Managers.state.game_mode:game_mode():extension("havoc") or Managers.state.mutator:mutator("mutator_enable_twin_havoc_inventory")) then
		zone_id = breed.has_havoc_inventory_override
	end

	local game_mode_manager = Managers.state.game_mode
	local game_mode = game_mode_manager:game_mode()
	local game_mode_name = game_mode:name()

	if game_mode_name == "expedition" then
		zone_id = "dust"
	end

	local used_weapon_slot_names

	if GameSession.has_game_object_field(game_session, game_object_id, "minion_attack_selection_template_id") then
		local attack_selection_template_id = GameSession.game_object_field(game_session, game_object_id, "minion_attack_selection_template_id")
		local attack_selection_template_name = NetworkLookup.minion_attack_selection_template_names[attack_selection_template_id]
		local _, weapon_slot_names = MinionAttackSelection.generate(attack_selection_template_name, attack_selection_seed)

		used_weapon_slot_names = weapon_slot_names
	end

	local inventory

	if breed.inventory then
		inventory, inventory_seed = MinionVisualLoadout.resolve(breed.inventory, zone_id, used_weapon_slot_names, breed.name, inventory_seed)
	end

	return inventory, inventory_seed
end

return UnitTemplate
