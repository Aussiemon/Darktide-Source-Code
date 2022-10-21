local Breeds = require("scripts/settings/breed/breeds")
local DialogueBreedSettings = require("scripts/settings/dialogue/dialogue_breed_settings")
local LevelProps = require("scripts/settings/level_prop/level_props")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local MasterItems = require("scripts/backend/master_items")
local MinionAttackSelection = require("scripts/utilities/minion_attack_selection/minion_attack_selection")
local MinionAttackSelectionTemplates = require("scripts/settings/minion_attack_selection/minion_attack_selection_templates")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local NetworkLookup = require("scripts/network_lookup/network_lookup")
local PhaseSelection = require("scripts/utilities/phases/phase_selection")
local Pickups = require("scripts/settings/pickup/pickups")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerCharacterStates = require("scripts/settings/player_character/player_character_states")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local PLAYER_AIM_CONSTRAINT_DISTANCE = 5

local function _position_rotation_from_game_object(session, object_id)
	local go_field = GameSession.game_object_field
	local position = go_field(session, object_id, "position")
	local rotation = nil

	if GameSession.has_game_object_field(session, object_id, "rotation") then
		rotation = go_field(session, object_id, "rotation")
	else
		local yaw = go_field(session, object_id, "yaw")
		local pitch = go_field(session, object_id, "pitch")
		local roll = 0
		rotation = Quaternion.from_yaw_pitch_roll(yaw, pitch, roll)
	end

	return position, rotation
end

local function _random_seeded_size_scale(seed, size_variation_range)
	local _, random_percentage = math.next_random(seed)
	local scale = math.lerp(size_variation_range[1], size_variation_range[2], random_percentage)

	return scale
end

local function _size_variation_pose_from_breed(position, rotation, size_variation_range, seed)
	local scale = _random_seeded_size_scale(seed, size_variation_range)
	local pose = Matrix4x4.from_quaternion_position(rotation, position)

	Matrix4x4.set_scale(pose, Vector3(scale, scale, scale))

	return pose
end

local function _breed_unit_name_position_rotation_from_game_object(session, object_id)
	local go_field = GameSession.game_object_field
	local breed_id = go_field(session, object_id, "breed_id")
	local breed_name = NetworkLookup.breed_names[breed_id]
	local breed = Breeds[breed_name]
	local unit_name = breed.base_unit
	local position, rotation = _position_rotation_from_game_object(session, object_id)
	local size_variation_range = breed.size_variation_range

	if size_variation_range then
		local random_seed = go_field(session, object_id, "random_seed")
		local pose = _size_variation_pose_from_breed(position, rotation, size_variation_range, random_seed)

		return unit_name, pose
	else
		return unit_name, position, rotation
	end
end

local function _player_unit_name_position_rotation_from_game_object(session, object_id)
	local go_field = GameSession.game_object_field
	local breed_id = go_field(session, object_id, "breed_id")
	local breed_name = NetworkLookup.breed_names[breed_id]
	local breed = Breeds[breed_name]
	local unit_name = breed.base_unit
	local local_player_id = go_field(session, object_id, "local_player_id")
	local owner_peer_id = go_field(session, object_id, "owner_peer_id")
	local player = Managers.player:player(owner_peer_id, local_player_id)
	local profile = player:profile()
	local profile_size = profile.personal and profile.personal.character_height
	local position, rotation = _position_rotation_from_game_object(session, object_id)
	local size_variation_range = breed.size_variation_range

	if profile_size then
		local pose = Matrix4x4.from_quaternion_position(rotation, position)

		Matrix4x4.set_scale(pose, Vector3(profile_size, profile_size, profile_size))

		return unit_name, pose
	elseif size_variation_range then
		local random_seed = go_field(session, object_id, "random_seed")
		local pose = _size_variation_pose_from_breed(position, rotation, size_variation_range, random_seed)

		return unit_name, pose
	else
		return unit_name, position, rotation
	end
end

local function _player_character_initial_items(game_mode_manager, profile, player)
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

		for i = 1, num_slots do
			local slot_name = human_controlled_initial_items_excluded_slots[i]
			initial_items[slot_name] = nil
		end
	end

	return initial_items
end

local function _broadphase_radius_and_categories(breed, side_id)
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side(side_id)
	local side_name = side:name()
	local broadphase_radius = breed.broadphase_radius
	local broadphase_categories = {
		side_name
	}

	if breed.broadphase_categories then
		table.append(broadphase_categories, breed.broadphase_categories)
	end

	return broadphase_radius, broadphase_categories
end

local function _pickup_broadphase_radius_and_categories(pickup_settings)
	local group_name = pickup_settings.group
	local radius = 1
	local categories = {
		"pickups",
		group_name
	}

	return radius, categories
end

local function _initialize_minion_specific_game_object_data(game_object_type, game_object_data)
	if game_object_type == "minion_daemonhost" then
		game_object_data.stage = 1
	end
end

local function _resolve_minion_attacks(init_data, breed, game_object_data, attack_selection_seed)
	local attack_selection_templates = breed.attack_selection_templates

	if attack_selection_templates == nil then
		return nil, nil, nil
	end

	local attack_selection_template_name = init_data.optional_attack_selection_template_name or MinionAttackSelection.match_template_by_tag(attack_selection_templates, "default")
	local attack_selection_template = MinionAttackSelectionTemplates[attack_selection_template_name]
	game_object_data.minion_attack_selection_template_id = NetworkLookup.minion_attack_selection_template_names[attack_selection_template_name]
	local combat_range_multi_config_key = attack_selection_template and attack_selection_template.combat_range_multi_config_key
	local selected_attack_names, used_weapon_slot_names = MinionAttackSelection.generate(attack_selection_template_name, attack_selection_seed)

	return attack_selection_template_name, selected_attack_names, used_weapon_slot_names, combat_range_multi_config_key
end

local function _resolve_minion_inventory(inventory_template, zone_id, used_weapon_slot_names, attack_selection_template_name, breed_name, inventory_seed)
	local inventory = nil
	inventory, inventory_seed = MinionVisualLoadout.resolve(inventory_template, zone_id, used_weapon_slot_names, breed_name, inventory_seed)

	return inventory, inventory_seed
end

local function _resolve_minion_inventory_and_attacks(init_data, breed, game_object_data, attack_selection_seed, inventory_seed)
	local mission = Managers.state.mission:mission()
	local zone_id = mission.zone_id
	local attack_selection_template_name, selected_attack_names, used_weapon_slot_names, combat_range_multi_config_key = _resolve_minion_attacks(init_data, breed, game_object_data, attack_selection_seed)
	local inventory = nil
	inventory, inventory_seed = _resolve_minion_inventory(breed.inventory, zone_id, used_weapon_slot_names, attack_selection_template_name, breed.name, inventory_seed)
	local phase_template = nil

	if breed.phase_template then
		phase_template = PhaseSelection.resolve(breed.phase_template, used_weapon_slot_names)
	end

	return inventory, inventory_seed, attack_selection_template_name, selected_attack_names, phase_template, combat_range_multi_config_key
end

local function _resolve_minion_husk_inventory(breed, game_session, game_object_id, attack_selection_seed, inventory_seed)
	local mission = Managers.state.mission:mission()
	local zone_id = mission.zone_id
	local used_weapon_slot_names = nil

	if GameSession.has_game_object_field(game_session, game_object_id, "minion_attack_selection_template_id") then
		local attack_selection_template_id = GameSession.game_object_field(game_session, game_object_id, "minion_attack_selection_template_id")
		local attack_selection_template_name = NetworkLookup.minion_attack_selection_template_names[attack_selection_template_id]
		local _, weapon_slot_names = MinionAttackSelection.generate(attack_selection_template_name, attack_selection_seed)
		used_weapon_slot_names = weapon_slot_names
	end

	local inventory = nil
	inventory, inventory_seed = MinionVisualLoadout.resolve(breed.inventory, zone_id, used_weapon_slot_names, breed.name, inventory_seed)

	return inventory, inventory_seed
end

local function _force_third_person_mode()
	local force_third_person_mode = Managers.state.game_mode:force_third_person_mode()

	return force_third_person_mode
end

local function _use_third_person_hub_camera()
	local use_third_person_hub_camera = Managers.state.game_mode:use_third_person_hub_camera()

	return use_third_person_hub_camera
end

local unit_templates = {}
unit_templates.player_character = {
	local_unit = function (unit_name, position, rotation, material, player, breed, side_id, optional_starting_state, input_handler, random_seed, ...)
		unit_name = unit_name or breed.base_unit
		local profile = player:profile()
		local profile_size = profile.personal and profile.personal.character_height
		local size_variation_range = breed.size_variation_range

		if profile_size then
			local pose = Matrix4x4.from_quaternion_position(rotation, position)

			Matrix4x4.set_scale(pose, Vector3(profile_size, profile_size, profile_size))

			return unit_name, pose, material
		elseif size_variation_range then
			local pose = _size_variation_pose_from_breed(position, rotation, size_variation_range, random_seed)

			return unit_name, pose, material
		else
			return unit_name, position, rotation, material
		end
	end,
	husk_unit = _player_unit_name_position_rotation_from_game_object,
	game_object_type = function (player)
		return "player_unit"
	end,
	local_init = function (unit, config, template_context, game_object_data, player, breed, side_id, optional_starting_state, input_handler, random_seed, optional_damage, optional_permanent_damage, ...)
		local is_server = template_context.is_server
		local profile = player:profile()
		local archetype = profile.archetype
		local specialization = profile.specialization
		local talents = profile.talents
		local game_mode_manager = Managers.state.game_mode
		local initial_items = _player_character_initial_items(game_mode_manager, profile, player)
		local mission = Managers.state.mission:mission()

		assert(is_server, "Can't create local player unit other than on server.")

		local broadphase_radius, broadphase_categories = _broadphase_radius_and_categories(breed, side_id)
		local size_scale = 1
		local profile_size = profile.personal and profile.personal.character_height
		local size_variation_range = breed.size_variation_range

		if profile_size then
			size_scale = profile_size
		elseif size_variation_range then
			size_scale = _random_seeded_size_scale(random_seed, size_variation_range)
		end

		local first_person_size_scale = breed.first_person_size or size_scale
		local next_seed, recoil_seed, buff_seed, spread_seed, character_state_seed, critical_strike_seed = nil
		next_seed, recoil_seed = math.random_seed(random_seed)
		next_seed, buff_seed = math.random_seed(next_seed)
		next_seed, spread_seed = math.random_seed(next_seed)
		next_seed, character_state_seed = math.random_seed(next_seed)
		next_seed, critical_strike_seed = math.random_seed(next_seed)
		local package_synchronizer_client = Managers.package_synchronization:synchronizer_client()
		local force_third_person_mode = _force_third_person_mode()
		local use_third_person_hub_camera = _use_third_person_hub_camera()
		local default_wielded_slot_name = game_mode_manager:default_wielded_slot_name()
		local starting_character_state = game_mode_manager:starting_character_state_name() or optional_starting_state or "walking"
		local blackboard_component_config = breed.blackboard_component_config
		local behavior_tree_name = breed.behavior_tree_name

		config:add("BlackboardExtension", {
			component_config = blackboard_component_config
		})

		local is_local_unit = not player.remote
		local is_human_controlled = player:is_human_controlled()

		config:add("BroadphaseExtension", {
			radius = broadphase_radius,
			categories = broadphase_categories
		})
		config:add("PlayerUnitDataExtension", {
			player = player,
			breed = breed,
			is_local_unit = is_local_unit,
			archetype = archetype
		})
		config:add("PlayerUnitAttackIntensityExtension")
		config:add("AuthoritativePlayerUnitAnimationExtension", {
			player = player,
			breed = breed,
			is_local_unit = is_local_unit
		})
		config:add("PlayerUnitInputExtension", {
			player = player,
			input_handler = input_handler
		})
		config:add("BotNavigationExtension", {
			nav_tag_allowed_layers = breed.nav_tag_allowed_layers,
			nav_cost_map_multipliers = breed.nav_cost_map_multipliers,
			player = player
		})
		config:add("PlayerUnitLocomotionExtension", {
			player = player,
			is_local_unit = is_local_unit,
			player_character_constants = PlayerCharacterConstants,
			breed = breed
		})
		config:add("PlayerUnitFxExtension", {
			is_local_unit = is_local_unit,
			player = player,
			breed = breed
		})
		config:add("PlayerUnitFirstPersonExtension", {
			player = player,
			is_local_unit = is_local_unit,
			unit_name = breed.first_person_unit,
			heights = breed.heights,
			pose_scale = first_person_size_scale,
			force_third_person_mode = force_third_person_mode
		})
		config:add("PlayerUnitCameraExtension", {
			is_local_unit = is_local_unit,
			breed = breed,
			use_third_person_hub_camera = use_third_person_hub_camera
		})
		config:add("PlayerUnitActionInputExtension")

		local spawn_buffs = breed.spawn_buffs

		config:add("PlayerUnitBuffExtension", {
			player = player,
			is_local_unit = is_local_unit,
			buff_seed = buff_seed,
			breed = breed,
			initial_buffs = spawn_buffs
		})
		config:add("PlayerUnitWeaponExtension", {
			player = player,
			is_local_unit = is_local_unit,
			is_server = is_server,
			critical_strike_seed = critical_strike_seed
		})
		config:add("PlayerUnitWeaponSpreadExtension", {
			spread_seed = spread_seed
		})
		config:add("PlayerUnitWeaponRecoilExtension", {
			player = player,
			recoil_seed = recoil_seed,
			is_local_unit = is_local_unit
		})
		config:add("PlayerUnitGadgetExtension", {
			player = player,
			is_local_unit = is_local_unit,
			is_server = is_server
		})
		config:add("DialogueActorExtension", {
			breed = breed,
			local_player = is_local_unit,
			faction = breed.faction_name,
			selected_voice = profile.selected_voice
		})
		config:add("DialogueContextExtension", {
			breed = breed
		})
		config:add("PlayerUnitVisualLoadoutExtension", {
			player = player,
			is_local_unit = is_local_unit,
			is_server = is_server,
			archetype = archetype,
			selected_voice = profile.selected_voice,
			slot_configuration = PlayerCharacterConstants.slot_configuration,
			initial_items = initial_items,
			package_synchronizer_client = package_synchronizer_client,
			mission = mission,
			default_wielded_slot_name = default_wielded_slot_name
		})
		config:add("PlayerUnitAbilityExtension", {
			is_local_unit = is_local_unit,
			is_server = is_server
		})
		config:add("PlayerSuppressionExtension", {
			is_local_unit = is_local_unit,
			player = player
		})

		if game_mode_manager:is_vaulting_allowed() then
			config:add("PlayerUnitLedgeFinderExtension", {
				ledge_finder_tweak_data = breed.ledge_finder_tweak_data
			})
		end

		config:add("CharacterStateMachineExtension", {
			player = player,
			state_class_list = PlayerCharacterStates,
			start_state = starting_character_state,
			breed = breed,
			player_character_constants = PlayerCharacterConstants,
			is_local_unit = is_local_unit,
			initial_seed = character_state_seed
		})
		config:add("SideExtension", {
			is_player_unit = true,
			side_id = side_id,
			is_human_unit = is_human_controlled,
			breed = breed
		})
		config:add("BotPerceptionExtension", {
			player = player,
			breed = breed
		})
		config:add("PlayerGroupExtension", {
			side_id = side_id,
			player = player
		})

		if Managers.state.game_mode:use_hub_aim_extension() then
			config:add("PlayerUnitHubAimExtension", {
				torso_aim_weight_name = "chest_aim_weight",
				aim_constraint_target_name = "aim_constraint_target",
				head_aim_weight_name = "head_aim_weight",
				aim_constraint_target_torso_name = "aim_constraint_target_torso",
				aim_constraint_distance = PLAYER_AIM_CONSTRAINT_DISTANCE
			})
		else
			config:add("PlayerUnitAimExtension", {
				aim_constraint_target_name = "aim_constraint_target",
				aim_constraint_distance = PLAYER_AIM_CONSTRAINT_DISTANCE
			})
		end

		if (not is_local_unit or not is_human_controlled) and not Managers.state.game_mode:disable_hologram() then
			config:add("PlayerUnitHologramExtension", {
				breed_name = breed.name
			})
		end

		local health = archetype.health
		local knocked_down_health = archetype.knocked_down_health
		local wounds = Managers.state.difficulty:player_wounds(archetype.name)
		local is_unkillable = false
		local is_invulnerable = false
		local toughness_template = archetype.toughness

		config:add("PlayerUnitHealthExtension", {
			health = health,
			knocked_down_health = knocked_down_health,
			wounds = wounds,
			is_unkillable = is_unkillable,
			is_invulnerable = is_invulnerable,
			optional_damage = optional_damage,
			optional_permanent_damage = optional_permanent_damage
		})
		config:add("PlayerUnitToughnessExtension", {
			toughness_template = toughness_template,
			is_local_unit = is_local_unit,
			is_human_controlled = is_human_controlled
		})
		config:add("InteractorExtension", {
			player = player
		})
		config:add("PlayerInteracteeExtension", {
			interaction_contexts = PlayerCharacterConstants.player_interactions,
			is_local_unit = is_local_unit
		})
		config:add("PlayerVolumeEventExtension")
		config:add("PlayerUnitPlaceholderHudExtension", {
			is_local_unit = is_local_unit,
			player = player,
			is_human_controlled = is_human_controlled
		})
		config:add("SlotExtension")
		config:add("PointOfInterestObserverExtension", {
			view_angle = math.pi / 32
		})
		config:add("PlayerProximityExtension", {
			side_id = side_id,
			breed = breed
		})
		config:add("ComponentExtension")
		config:add("PlayerUnitDarknessExtension", {
			intensity = 0.04
		})
		config:add("PhysicsUnitProximityObserverExtension", {
			player = player
		})

		if is_human_controlled then
			config:add("PlayerUnitMusicParameterExtension")
		end

		config:add("PlayerUnitSmartTargetingExtension", {
			player = player,
			is_server = is_server,
			is_local_unit = is_local_unit
		})
		config:add("PlayerVisibilityExtension", {
			player = player
		})
		config:add("SmartTagExtension", {})
		config:add("PlayerUnitOutlineExtension", {
			is_local_unit = is_local_unit,
			is_human_controlled = is_human_controlled
		})
		config:add("FadeExtension")
		config:add("UnitCoherencyExtension", {
			coherency_settings = PlayerCharacterConstants.coherency
		})
		config:add("PlayerUnitSpecializationExtension", {
			player = player,
			archetype = archetype,
			specialization_name = specialization,
			talents = talents,
			is_local_unit = is_local_unit
		})
		config:add("BotBehaviorExtension", {
			breed = breed,
			player = player,
			behavior_tree_name = behavior_tree_name,
			optional_gestalts = profile.bot_gestalts
		})

		if is_human_controlled then
			config:add("PlayerUnitMoodExtension", {
				player = player
			})
		end

		local breed_name = breed.name
		local breed_id = NetworkLookup.breed_names[breed_name]
		game_object_data.owner_peer_id = player:peer_id()
		game_object_data.local_player_id = player:local_player_id()
		game_object_data.side_id = side_id
		game_object_data.breed_id = breed_id
		game_object_data.random_seed = random_seed
		local player_unit_spawn_manager = Managers.state.player_unit_spawn

		player_unit_spawn_manager:assign_unit_ownership(unit, player, true)
	end,
	husk_init = function (unit, config, template_context, game_session, game_object_id, owner_id)
		local go_field = GameSession.game_object_field
		local local_player_id = go_field(game_session, game_object_id, "local_player_id")
		local owner_peer_id = go_field(game_session, game_object_id, "owner_peer_id")
		local breed_id = go_field(game_session, game_object_id, "breed_id")
		local random_seed = go_field(game_session, game_object_id, "random_seed")
		local breed_name = NetworkLookup.breed_names[breed_id]
		local breed = Breeds[breed_name]
		local player = Managers.player:player(owner_peer_id, local_player_id)
		local side_id = GameSession.game_object_field(game_session, game_object_id, "side_id")
		local is_human_controlled = player:is_human_controlled()
		local is_server = template_context.is_server
		local profile = player:profile()
		local archetype = profile.archetype
		local game_mode_manager = Managers.state.game_mode
		local initial_items = _player_character_initial_items(game_mode_manager, profile, player)
		local mission = Managers.state.mission:mission()
		local specialization = profile.specialization
		local talents = profile.talents
		local size_scale = 1
		local profile_size = profile.personal and profile.personal.character_height
		local size_variation_range = breed.size_variation_range

		if profile_size then
			size_scale = profile_size
		elseif size_variation_range then
			size_scale = _random_seeded_size_scale(random_seed, size_variation_range)
		end

		local package_synchronizer_client = Managers.package_synchronization:synchronizer_client()
		local toughness_template = archetype.toughness

		if not is_server and player.remote then
			config:add("PlayerHuskDataExtension", {
				player = player,
				breed = breed,
				archetype = archetype
			})
			config:add("PlayerUnitFxExtension", {
				is_local_unit = false,
				player = player,
				breed = breed
			})
			config:add("PlayerHuskFirstPersonExtension", {
				player = player,
				unit_name = breed.first_person_unit,
				heights = breed.heights
			})
			config:add("PlayerHuskAnimationExtension")
			config:add("PlayerHuskLocomotionExtension", {
				player = player,
				breed = breed
			})
			config:add("PlayerHuskCameraExtension", {
				is_local_unit = false
			})
			config:add("DialogueActorExtension", {
				local_player = false,
				breed = breed,
				faction = breed.faction_name,
				selected_voice = profile.selected_voice
			})
			config:add("PlayerHuskVisualLoadoutExtension", {
				player = player,
				slot_configuration = PlayerCharacterConstants.slot_configuration,
				archetype = archetype,
				selected_voice = profile.selected_voice,
				package_synchronizer_client = package_synchronizer_client,
				mission = mission
			})

			if Managers.state.game_mode:use_hub_aim_extension() then
				config:add("PlayerHuskHubAimExtension", {
					torso_aim_weight_name = "chest_aim_weight",
					aim_constraint_target_name = "aim_constraint_target",
					head_aim_weight_name = "head_aim_weight",
					aim_constraint_target_torso_name = "aim_constraint_target_torso",
					aim_constraint_distance = PLAYER_AIM_CONSTRAINT_DISTANCE
				})
			else
				config:add("PlayerHuskAimExtension", {
					aim_constraint_target_name = "aim_constraint_target",
					aim_constraint_distance = PLAYER_AIM_CONSTRAINT_DISTANCE
				})
			end

			if not Managers.state.game_mode:disable_hologram() then
				config:add("PlayerUnitHologramExtension", {
					breed_name = breed.name
				})
			end

			local wounds = Managers.state.difficulty:player_wounds(archetype.name)

			config:add("PlayerHuskHealthExtension", {
				is_local_unit = false,
				wounds = wounds
			})
			config:add("PlayerSuppressionExtension", {
				is_local_unit = false,
				player = player
			})
			config:add("PlayerHuskToughnessExtension", {
				is_local_unit = false,
				toughness_template = toughness_template
			})
			config:add("PlayerUnitDarknessExtension", {
				intensity = 0.04
			})
			config:add("PhysicsUnitProximityObserverExtension", {
				player = player
			})
			config:add("PlayerInteracteeExtension", {
				is_local_unit = false,
				interaction_contexts = PlayerCharacterConstants.player_interactions
			})
			config:add("SideExtension", {
				is_player_unit = true,
				is_human_unit = true,
				side_id = side_id,
				breed = breed
			})
			config:add("PlayerHuskBuffExtension", {
				is_local_unit = false,
				player = player
			})

			if is_human_controlled then
				config:add("PlayerHuskMusicParameterExtension")
			end

			config:add("PlayerVisibilityExtension", {
				player = player
			})
			config:add("SmartTagExtension", {})
			config:add("PlayerUnitOutlineExtension", {
				is_human_controlled = true,
				is_local_unit = false
			})
			config:add("HuskCoherencyExtension")
			config:add("PlayerHuskSpecializationExtension", {
				is_local_unit = false,
				player = player,
				archetype = archetype,
				specialization_name = specialization,
				talents = talents
			})
			config:add("PlayerUnitMoodExtension", {
				player = player
			})
			config:add("FadeExtension")

			local player_unit_spawn_manager = Managers.state.player_unit_spawn

			player_unit_spawn_manager:assign_unit_ownership(unit, player, true)
		else
			local broadphase_radius, broadphase_categories = _broadphase_radius_and_categories(breed, side_id)
			local rotation = Unit.local_rotation(unit, 1)
			local pitch = Quaternion.pitch(rotation)
			local yaw = Quaternion.yaw(rotation)

			player:set_orientation(yaw, pitch, 0)

			local next_seed, recoil_seed, buff_seed, spread_seed, character_state_seed, critical_strike_seed = nil
			next_seed, recoil_seed = math.random_seed(random_seed)
			next_seed, buff_seed = math.random_seed(next_seed)
			next_seed, spread_seed = math.random_seed(next_seed)
			next_seed, character_state_seed = math.random_seed(next_seed)
			next_seed, critical_strike_seed = math.random_seed(next_seed)
			local force_third_person_mode = _force_third_person_mode()
			local use_third_person_hub_camera = _use_third_person_hub_camera()
			local default_wielded_slot_name = game_mode_manager:default_wielded_slot_name()
			local starting_character_state = game_mode_manager:starting_character_state_name() or "walking"
			local is_local_unit = true
			local input_handler = player.input_handler

			config:add("BroadphaseExtension", {
				radius = broadphase_radius,
				categories = broadphase_categories
			})
			config:add("PlayerUnitDataExtension", {
				player = player,
				breed = breed,
				is_local_unit = is_local_unit,
				archetype = archetype
			})
			config:add("PlayerUnitAnimationExtension")
			config:add("PlayerUnitInputExtension", {
				player = player,
				input_handler = input_handler
			})
			config:add("PlayerUnitLocomotionExtension", {
				player = player,
				is_local_unit = is_local_unit,
				player_character_constants = PlayerCharacterConstants,
				breed = breed
			})
			config:add("PlayerUnitFxExtension", {
				is_local_unit = is_local_unit,
				player = player,
				breed = breed
			})
			config:add("PlayerUnitFirstPersonExtension", {
				player = player,
				is_local_unit = is_local_unit,
				unit_name = breed.first_person_unit,
				heights = breed.heights,
				pose_scale = size_scale,
				force_third_person_mode = force_third_person_mode
			})
			config:add("PlayerUnitCameraExtension", {
				is_local_unit = is_local_unit,
				breed = breed,
				use_third_person_hub_camera = use_third_person_hub_camera
			})
			config:add("SideExtension", {
				is_player_unit = true,
				is_human_unit = true,
				side_id = side_id,
				breed = breed
			})
			config:add("PlayerUnitActionInputExtension")
			config:add("PlayerUnitBuffExtension", {
				player = player,
				is_local_unit = is_local_unit,
				buff_seed = buff_seed,
				breed = breed
			})
			config:add("PlayerUnitWeaponExtension", {
				is_server = false,
				player = player,
				is_local_unit = is_local_unit,
				critical_strike_seed = critical_strike_seed
			})
			config:add("PlayerUnitWeaponSpreadExtension", {
				spread_seed = spread_seed
			})
			config:add("PlayerUnitWeaponRecoilExtension", {
				player = player,
				recoil_seed = recoil_seed,
				is_local_unit = is_local_unit
			})
			config:add("PlayerUnitGadgetExtension", {
				player = player,
				is_local_unit = is_local_unit,
				is_server = is_server
			})
			config:add("DialogueActorExtension", {
				local_player = true,
				breed = breed,
				faction = breed.faction_name,
				selected_voice = profile.selected_voice
			})
			config:add("DialogueContextExtension", {
				breed = breed
			})
			config:add("PlayerUnitVisualLoadoutExtension", {
				is_server = false,
				player = player,
				is_local_unit = is_local_unit,
				archetype = archetype,
				selected_voice = profile.selected_voice,
				slot_configuration = PlayerCharacterConstants.slot_configuration,
				initial_items = initial_items,
				package_synchronizer_client = package_synchronizer_client,
				mission = mission,
				default_wielded_slot_name = default_wielded_slot_name
			})
			config:add("PlayerUnitAbilityExtension", {
				is_server = false,
				is_local_unit = is_local_unit,
				equipped_abilities = profile.abilities
			})
			config:add("PlayerSuppressionExtension", {
				is_local_unit = is_local_unit,
				player = player
			})

			if game_mode_manager:is_vaulting_allowed() then
				config:add("PlayerUnitLedgeFinderExtension", {
					ledge_finder_tweak_data = breed.ledge_finder_tweak_data
				})
			end

			config:add("CharacterStateMachineExtension", {
				player = player,
				state_class_list = PlayerCharacterStates,
				start_state = starting_character_state,
				breed = breed,
				player_character_constants = PlayerCharacterConstants,
				is_local_unit = is_local_unit,
				initial_seed = character_state_seed
			})

			if Managers.state.game_mode:use_hub_aim_extension() then
				config:add("PlayerUnitHubAimExtension", {
					torso_aim_weight_name = "chest_aim_weight",
					aim_constraint_target_name = "aim_constraint_target",
					head_aim_weight_name = "head_aim_weight",
					aim_constraint_target_torso_name = "aim_constraint_target_torso",
					aim_constraint_distance = PLAYER_AIM_CONSTRAINT_DISTANCE
				})
			else
				config:add("PlayerUnitAimExtension", {
					aim_constraint_target_name = "aim_constraint_target",
					aim_constraint_distance = PLAYER_AIM_CONSTRAINT_DISTANCE
				})
			end

			local wounds = Managers.state.difficulty:player_wounds(archetype.name)

			config:add("PlayerHuskHealthExtension", {
				wounds = wounds,
				is_local_unit = is_local_unit
			})
			config:add("PlayerHuskToughnessExtension", {
				toughness_template = toughness_template,
				is_local_unit = is_local_unit
			})
			config:add("InteractorExtension", {
				player = player
			})
			config:add("PlayerUnitPlaceholderHudExtension", {
				is_human_controlled = true,
				is_local_unit = is_local_unit,
				player = player
			})
			config:add("PlayerProximityExtension", {
				side_id = side_id,
				breed = breed
			})
			config:add("ComponentExtension")
			config:add("PlayerUnitDarknessExtension", {
				intensity = 0.04
			})
			config:add("PhysicsUnitProximityObserverExtension", {
				player = player
			})
			config:add("PlayerInteracteeExtension", {
				interaction_contexts = PlayerCharacterConstants.player_interactions,
				is_local_unit = is_local_unit
			})
			config:add("PlayerHuskMusicParameterExtension")
			config:add("PlayerUnitSmartTargetingExtension", {
				player = player,
				is_server = is_server,
				is_local_unit = is_local_unit
			})
			config:add("PlayerVisibilityExtension", {
				player = player
			})
			config:add("SmartTagExtension", {})
			config:add("HuskCoherencyExtension")
			config:add("PlayerUnitOutlineExtension", {
				is_human_controlled = true,
				is_local_unit = is_local_unit
			})
			config:add("PlayerUnitMoodExtension", {
				player = player
			})
			config:add("FadeExtension")
			config:add("PlayerHuskSpecializationExtension", {
				player = player,
				archetype = archetype,
				specialization_name = specialization,
				talents = talents,
				is_local_unit = is_local_unit
			})

			local player_unit_spawn_manager = Managers.state.player_unit_spawn

			player_unit_spawn_manager:assign_unit_ownership(unit, player, true)
		end
	end,
	pre_unit_destroyed = function (unit)
		local player_unit_spawn_manager = Managers.state.player_unit_spawn

		player_unit_spawn_manager:relinquish_unit_ownership(unit)
	end,
	unit_spawned = function (unit)
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local player = player_unit_spawn_manager:owner(unit)

		fassert(player, "Set player ownership not done.")
	end
}
unit_templates.minion = {
	local_unit = function (unit_name, position, rotation, material, init_data, ...)
		local breed = init_data.breed
		local random_seed = init_data.random_seed
		unit_name = unit_name or breed.base_unit
		local size_variation_range = breed.size_variation_range

		if size_variation_range then
			local pose = _size_variation_pose_from_breed(position, rotation, size_variation_range, random_seed)

			return unit_name, pose, material
		else
			return unit_name, position, rotation, material
		end
	end,
	husk_unit = _breed_unit_name_position_rotation_from_game_object,
	game_object_type = function (init_data, ...)
		local breed = init_data.breed
		local game_object_type = breed.game_object_type

		return game_object_type
	end,
	local_init = function (unit, config, template_context, game_object_data, init_data, ...)
		local breed = init_data.breed
		local side_id = init_data.side_id
		local broadphase_radius, broadphase_categories = _broadphase_radius_and_categories(breed, side_id)
		local blackboard_component_config = breed.blackboard_component_config
		local breed_name = breed.name
		local behavior_tree_name = breed.behavior_tree_name
		local spawn_buffs = breed.spawn_buffs
		local random_seed = init_data.random_seed
		local next_seed, animation_seed, inventory_seed, buff_seed, attack_selection_seed, boss_seed = nil
		next_seed, animation_seed = math.random_seed(random_seed)
		next_seed, inventory_seed = math.random_seed(next_seed)
		next_seed, buff_seed = math.random_seed(next_seed)
		next_seed, attack_selection_seed = math.random_seed(next_seed)
		next_seed, boss_seed = math.random_seed(next_seed)

		config:add("BlackboardExtension", {
			component_config = blackboard_component_config
		})
		config:add("BroadphaseExtension", {
			radius = broadphase_radius,
			categories = broadphase_categories
		})

		if breed.aim_config then
			config:add("MinionRangedAimExtension", {
				breed = breed
			})
		end

		config:add("MinionUnitDataExtension", {
			breed = breed
		})

		if breed.attack_intensity_cooldowns then
			config:add("MinionAttackIntensityExtension", {
				breed = breed
			})
		end

		config:add("MinionBuffExtension", {
			buff_seed = buff_seed,
			breed = breed,
			initial_buffs = spawn_buffs
		})

		local inventory, attack_selection_template_name, selected_attack_names, phase_template, combat_range_multi_config_key = nil
		inventory, inventory_seed, attack_selection_template_name, selected_attack_names, phase_template, combat_range_multi_config_key = _resolve_minion_inventory_and_attacks(init_data, breed, game_object_data, attack_selection_seed, inventory_seed)

		config:add("MinionAnimationExtension", {
			breed = breed,
			random_seed = animation_seed
		})
		config:add("MinionFxExtension")
		config:add("MinionVisualLoadoutExtension", {
			breed = breed,
			random_seed = inventory_seed,
			inventory = inventory
		})
		config:add("MinionLocomotionExtension", {
			breed = breed
		})
		config:add("MinionNavigationExtension", {
			breed = breed
		})
		config:add("SideExtension", {
			side_id = side_id,
			breed = breed
		})

		local optional_mission_objective_id = init_data.optional_mission_objective_id

		if optional_mission_objective_id then
			config:add("MissionObjectiveTargetExtension")
		end

		if breed.uses_script_components then
			config:add("ComponentExtension")
		end

		local optional_aggro_state = init_data.optional_aggro_state
		local optional_target_unit = init_data.optional_target_unit

		config:add("MinionPerceptionExtension", {
			breed = breed,
			aggro_state = optional_aggro_state,
			target_unit = optional_target_unit
		})

		if breed.cover_config then
			config:add("CoverUserExtension", {
				breed = breed,
				side_id = side_id
			})
		end

		if breed.combat_vector_config then
			config:add("CombatVectorUserExtension", {
				breed = breed
			})
		end

		local optional_group_id = init_data.optional_group_id

		if optional_group_id then
			config:add("MinionGroupExtension", {
				breed = breed,
				group_id = optional_group_id
			})

			game_object_data.group_id = optional_group_id
		end

		if breed.suppress_config then
			config:add("MinionSuppressionExtension", {
				breed = breed
			})
		end

		local has_health_bar = breed.has_health_bar
		local health = Managers.state.difficulty:get_minion_max_health(breed_name)
		local is_unkillable = false
		local is_invulnerable = false

		config:add("HealthExtension", {
			health = health,
			has_health_bar = has_health_bar,
			is_unkillable = is_unkillable,
			is_invulnerable = is_invulnerable
		})
		config:add("MinionVolumeEventExtension")

		if breed.shield_template then
			config:add("MinionShieldExtension", {
				breed = breed
			})
		end

		if breed.slot_template then
			config:add("SlotUserExtension", {
				breed = breed
			})
		end

		config:add("AIProximityExtension", {
			side_id = side_id,
			breed = breed
		})
		config:add("PhysicsUnitProximityActorExtension", {
			time_caching_enabled = true
		})

		if breed.look_at_tag then
			config:add("PointOfInterestTargetExtension", {
				is_dynamic = true,
				tag = breed.look_at_tag,
				view_distance = breed.look_at_distance
			})
		end

		local dialogue_settings = DialogueBreedSettings[breed_name]

		if dialogue_settings and dialogue_settings.has_dialogue_extension then
			config:add("DialogueActorExtension", {
				local_player = false,
				breed = breed
			})
		end

		if breed.toughness_template then
			config:add("MinionToughnessExtension", {
				breed = breed
			})
		end

		if breed.is_boss then
			config:add("BossExtension", {
				breed = breed,
				seed = boss_seed
			})
		end

		if breed.use_wounds then
			config:add("WoundsExtension", {
				breed = breed
			})
		end

		config:add("FadeExtension")

		if breed.smart_tag_target_type then
			config:add("SmartTagExtension", {
				target_type = breed.smart_tag_target_type
			})
			config:add("MinionOutlineExtension")
		end

		local behavior_extension_init_data = {
			breed = breed,
			behavior_tree_name = behavior_tree_name,
			selected_attack_names = selected_attack_names
		}

		if breed.combat_range_data then
			behavior_extension_init_data.phase_template = phase_template
			behavior_extension_init_data.combat_range_multi_config_key = combat_range_multi_config_key

			config:add("CombatRangeUserBehaviorExtension", behavior_extension_init_data)
		else
			config:add("MinionBehaviorExtension", behavior_extension_init_data)
		end

		local game_object_type = breed.game_object_type

		_initialize_minion_specific_game_object_data(game_object_type, game_object_data)

		local breed_id = NetworkLookup.breed_names[breed_name]
		local rotation = Unit.local_rotation(unit, 1)
		game_object_data.breed_id = breed_id
		game_object_data.position = Unit.local_position(unit, 1)

		if Network.object_has_field(game_object_type, "rotation") then
			game_object_data.rotation = rotation
		else
			game_object_data.pitch = Quaternion.pitch(rotation)
			game_object_data.yaw = Quaternion.yaw(rotation)
		end

		game_object_data.side_id = side_id
		game_object_data.has_teleported = 1
		game_object_data.random_seed = random_seed
		game_object_data.target_unit_id = NetworkConstants.invalid_game_object_id
	end,
	husk_init = function (unit, config, template_context, game_session, game_object_id, owner_id)
		local go_field = GameSession.game_object_field
		local side_id = go_field(game_session, game_object_id, "side_id")
		local breed_id = go_field(game_session, game_object_id, "breed_id")
		local random_seed = go_field(game_session, game_object_id, "random_seed")
		local breed_name = NetworkLookup.breed_names[breed_id]
		local breed = Breeds[breed_name]
		local broadphase_radius, broadphase_categories = _broadphase_radius_and_categories(breed, side_id)
		local next_seed, animation_seed, inventory_seed, buff_seed, attack_selection_seed, boss_seed = nil
		next_seed, animation_seed = math.random_seed(random_seed)
		next_seed, inventory_seed = math.random_seed(next_seed)
		next_seed, buff_seed = math.random_seed(next_seed)
		next_seed, attack_selection_seed = math.random_seed(next_seed)
		next_seed, boss_seed = math.random_seed(next_seed)

		config:add("BroadphaseExtension", {
			radius = broadphase_radius,
			categories = broadphase_categories
		})
		config:add("MinionUnitDataExtension", {
			breed = breed
		})

		if breed.aim_config then
			config:add("MinionRangedHuskAimExtension", {
				breed = breed
			})
		end

		local inventory = nil
		inventory, inventory_seed = _resolve_minion_husk_inventory(breed, game_session, game_object_id, attack_selection_seed, inventory_seed)

		config:add("MinionAnimationExtension", {
			breed = breed,
			random_seed = animation_seed
		})
		config:add("MinionFxExtension")
		config:add("MinionVisualLoadoutExtension", {
			breed = breed,
			random_seed = inventory_seed,
			inventory = inventory
		})
		config:add("MinionHuskLocomotionExtension", {
			breed = breed
		})
		config:add("SideExtension", {
			side_id = side_id,
			breed = breed
		})
		config:add("MinionBuffExtension", {
			buff_seed = buff_seed,
			breed = breed
		})

		if GameSession.has_game_object_field(game_session, game_object_id, "group_id") then
			local group_id = go_field(game_session, game_object_id, "group_id")

			config:add("MinionGroupExtension", {
				breed = breed,
				group_id = group_id
			})
		end

		if breed.suppress_config then
			config:add("MinionSuppressionHuskExtension", {
				breed = breed
			})
		end

		local has_health_bar = breed.has_health_bar

		config:add("HuskHealthExtension", {
			has_health_bar = has_health_bar
		})

		if breed.shield_template then
			config:add("MinionHuskShieldExtension", {
				breed = breed
			})
		end

		if breed.toughness_template then
			config:add("MinionToughnessHuskExtension", {
				breed = breed
			})
		end

		if breed.is_boss then
			config:add("BossExtension", {
				breed = breed,
				seed = boss_seed
			})
		end

		if breed.use_wounds then
			config:add("WoundsExtension", {
				breed = breed
			})
		end

		config:add("AIProximityExtension", {
			side_id = side_id,
			breed = breed
		})
		config:add("PhysicsUnitProximityActorExtension", {
			time_caching_enabled = false
		})
		config:add("MissionObjectiveTargetExtension")

		if breed.uses_script_components then
			config:add("ComponentExtension")
		end

		local dialogue_settings = DialogueBreedSettings[breed_name]

		if dialogue_settings and dialogue_settings.has_dialogue_extension then
			config:add("DialogueActorExtension", {
				local_player = false,
				breed = breed
			})
		end

		config:add("FadeExtension")

		if breed.smart_tag_target_type then
			config:add("SmartTagExtension", {
				target_type = breed.smart_tag_target_type
			})
			config:add("MinionOutlineExtension")
		end
	end
}
unit_templates.liquid_area = {
	local_unit = function (nil_unit_name, position, ...)
		local unit_name = "content/liquid_area/empty_unit/empty_unit"

		return unit_name, position
	end,
	husk_unit = function (session, object_id)
		local unit_name = "content/liquid_area/empty_unit/empty_unit"
		local position = GameSession.game_object_field(session, object_id, "position")

		return unit_name, position
	end,
	game_object_type = function (...)
		return "liquid_area"
	end,
	local_init = function (unit, config, template_context, game_object_data, liquid_area_template, flow_direction_or_nil, optional_source_unit, optional_max_liquid, optional_liquid_paint_id, optional_source_item)
		local source_unit = optional_source_unit

		config:add("LiquidAreaExtension", {
			template = liquid_area_template,
			flow_direction_or_nil = flow_direction_or_nil,
			source_unit = source_unit,
			optional_max_liquid = optional_max_liquid,
			optional_liquid_paint_id = optional_liquid_paint_id,
			optional_source_item = optional_source_item
		})

		local liquid_area_template_name = liquid_area_template.name
		game_object_data.position = Unit.local_position(unit, 1)
		game_object_data.liquid_area_template_id = NetworkLookup.liquid_area_template_names[liquid_area_template_name]
	end,
	husk_init = function (unit, config, template_context, game_session, game_object_id, owner_id)
		local liquid_area_template_id = GameSession.game_object_field(game_session, game_object_id, "liquid_area_template_id")
		local liquid_area_template_name = NetworkLookup.liquid_area_template_names[liquid_area_template_id]
		local liquid_area_template = LiquidAreaTemplates[liquid_area_template_name]

		config:add("HuskLiquidAreaExtension", {
			template = liquid_area_template
		})
	end
}
unit_templates.level_prop = {
	local_unit = function (unit_name, position, rotation, material, prop_settings, placed_on_unit, spawn_interaction_cooldown)
		unit_name = unit_name or prop_settings.unit_name

		return unit_name, position, rotation, material
	end,
	husk_unit = function (session, object_id)
		local prop_id = GameSession.game_object_field(session, object_id, "prop_id")
		local prop_name = NetworkLookup.level_props_names[prop_id]
		local prop_settings = LevelProps[prop_name]
		local unit_name = prop_settings.unit_name
		local position, rotation = _position_rotation_from_game_object(session, object_id)

		return unit_name, position, rotation
	end,
	game_object_type = function (prop_settings)
		local game_object_type = prop_settings.game_object_type

		return game_object_type
	end,
	local_init = function (unit, config, template_context, game_object_data, prop_settings)
		config:parse_unit(unit)

		local prop_name = prop_settings.name
		local prop_id = NetworkLookup.level_props_names[prop_name]
		game_object_data.prop_id = prop_id
		game_object_data.position = Unit.local_position(unit, 1)
		game_object_data.rotation = Unit.local_rotation(unit, 1)
	end,
	husk_init = function (unit, config, template_context, game_session, game_object_id, owner_id)
		config:parse_unit(unit)
	end
}
unit_templates.pickup = {
	local_unit = function (unit_name, position, rotation, material, pickup_settings, ...)
		unit_name = unit_name or pickup_settings.unit_name

		return unit_name, position, rotation, material
	end,
	husk_unit = function (session, object_id)
		local pickup_id = GameSession.game_object_field(session, object_id, "pickup_id")
		local pickup_name = NetworkLookup.pickup_names[pickup_id]
		local pickup_settings = Pickups.by_name[pickup_name]
		local unit_name = pickup_settings.unit_name
		local position, rotation = _position_rotation_from_game_object(session, object_id)

		return unit_name, position, rotation
	end,
	game_object_type = function (pickup_settings)
		local game_object_type = pickup_settings.game_object_type

		return game_object_type
	end,
	local_init = function (unit, config, template_context, game_object_data, pickup_settings, placed_on_unit, spawn_interaction_cooldown)
		local is_server = template_context.is_server

		assert(is_server, "Can't create unit other than on server.")

		local pickup_name = pickup_settings.name

		Unit.set_data(unit, "pickup_type", pickup_name)

		local radius, categories = _pickup_broadphase_radius_and_categories(pickup_settings)

		config:add("BroadphaseExtension", {
			radius = radius,
			categories = categories
		})

		local projectile_template_name_id = nil
		local pickup_group = pickup_settings.group

		if pickup_group == "luggable" then
			local projectile_template = pickup_settings.projectile_template
			local projectile_template_name = projectile_template.name
			projectile_template_name_id = NetworkLookup.projectile_template_names[projectile_template_name]
			local inventory_item = pickup_settings.inventory_item
			local item_definitions = MasterItems.get_cached()
			local item = item_definitions[inventory_item]

			config:add("MissionObjectiveTargetExtension")
			config:add("ProjectileUnitLocomotionExtension", {
				handle_oob_despawning = false,
				projectile_template_name = projectile_template_name,
				optional_item = item
			})
			config:add("LuggableExtension")
			config:add("TriggerVolumeEventExtension")
		elseif pickup_group == "side_mission_collect" then
			config:add("MissionObjectiveTargetExtension")
			config:add("SideMissionPickupExtension")
		elseif pickup_group == "ammo" then
			config:add("DeployableUnitLocomotionExtension", {
				placed_on_unit = placed_on_unit
			})

			if placed_on_unit then
				local _, placed_on_unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(placed_on_unit)
				game_object_data.placed_on_unit_id = placed_on_unit_id
			end
		end

		if pickup_group ~= "luggable" then
			config:add("PickupAnimationExtension")
		end

		config:add("InteracteeExtension", {
			interaction_type = pickup_settings.interaction_type,
			spawn_interaction_cooldown = spawn_interaction_cooldown,
			override_context = {
				description = pickup_settings.description,
				interaction_icon = pickup_settings.interaction_icon
			}
		})
		config:add("PointOfInterestTargetExtension", {
			tag = pickup_settings.look_at_tag,
			view_distance = pickup_settings.look_at_distance
		})

		if pickup_settings.smart_tag_target_type then
			config:add("SmartTagExtension", {
				target_type = pickup_settings.smart_tag_target_type,
				auto_tag_on_spawn = pickup_settings.auto_tag_on_spawn
			})
		end

		config:add("ComponentExtension")

		local pickup_id = NetworkLookup.pickup_names[pickup_name]
		game_object_data.pickup_id = pickup_id
		game_object_data.position = Unit.local_position(unit, 1)

		if pickup_group ~= "luggable" then
			game_object_data.charges = pickup_settings.num_charges or 1
		elseif pickup_group == "luggable" then
			game_object_data.projectile_template_id = projectile_template_name_id
		end

		local rotation = Unit.local_rotation(unit, 1)
		local game_object_type = pickup_settings.game_object_type

		if Network.object_has_field(game_object_type, "rotation") then
			game_object_data.rotation = rotation
		else
			game_object_data.yaw = Quaternion.yaw(rotation)
			game_object_data.pitch = Quaternion.pitch(rotation)
		end

		local spawn_flow_event = pickup_settings.spawn_flow_event

		if spawn_flow_event then
			Unit.flow_event(unit, spawn_flow_event)
		end
	end,
	husk_init = function (unit, config, template_context, game_session, game_object_id, owner_id)
		local go_field = GameSession.game_object_field
		local pickup_id = go_field(game_session, game_object_id, "pickup_id")
		local pickup_name = NetworkLookup.pickup_names[pickup_id]

		Unit.set_data(unit, "pickup_type", pickup_name)

		local pickup_settings = Pickups.by_name[pickup_name]
		local radius, categories = _pickup_broadphase_radius_and_categories(pickup_settings)

		config:add("BroadphaseExtension", {
			radius = radius,
			categories = categories
		})

		local pickup_group = pickup_settings.group

		if pickup_group == "luggable" then
			local projectile_template_name_id = go_field(game_session, game_object_id, "projectile_template_id")
			local projectile_template_name = NetworkLookup.projectile_template_names[projectile_template_name_id]
			local inventory_item = pickup_settings.inventory_item
			local item_definitions = MasterItems.get_cached()
			local item = item_definitions[inventory_item]

			config:add("MissionObjectiveTargetExtension")
			config:add("ProjectileHuskLocomotionExtension", {
				projectile_template_name = projectile_template_name,
				optional_item = item
			})
			config:add("LuggableExtension")
		elseif pickup_group == "side_mission_collect" then
			config:add("MissionObjectiveTargetExtension")
			config:add("SideMissionPickupExtension")
		elseif pickup_group == "ammo" then
			config:add("DeployableHuskLocomotionExtension", {})
		end

		if pickup_group ~= "luggable" then
			config:add("PickupAnimationExtension")
		end

		config:add("InteracteeExtension", {
			interaction_type = pickup_settings.interaction_type,
			override_context = {
				description = pickup_settings.description,
				interaction_icon = pickup_settings.interaction_icon
			}
		})

		if pickup_settings.smart_tag_target_type then
			config:add("SmartTagExtension", {
				target_type = pickup_settings.smart_tag_target_type
			})
		end

		config:add("ComponentExtension")

		local spawn_flow_event = pickup_settings.spawn_flow_event

		if spawn_flow_event then
			Unit.flow_event(unit, spawn_flow_event)
		end
	end
}
unit_templates.item_projectile = {
	local_unit = function (unit_name, position, rotation, material, item)
		unit_name = unit_name or item.base_unit

		return unit_name, position, rotation
	end,
	husk_unit = function (session, object_id)
		local item_definitions = MasterItems.get_cached()
		local item_id = GameSession.game_object_field(session, object_id, "item_id")
		local item_name = NetworkLookup.player_item_names[item_id]
		local item = item_definitions[item_name]
		local unit_name = item.base_unit
		local position, rotation = _position_rotation_from_game_object(session, object_id)

		return unit_name, position, rotation
	end,
	game_object_type = function ()
		return "item_projectile"
	end,
	local_init = function (unit, config, template_context, game_object_data, item, projectile_template, starting_state, direction, speed, momentum_or_angular_velocity, owner_unit, is_critical_strike, origin_item_slot, charge_level, target_unit, target_position, weapon_item_or_nil)
		local is_server = template_context.is_server

		assert(is_server, "Can't create unit other than on server.")

		if owner_unit then
			local side_extension = ScriptUnit.has_extension(owner_unit, "side_system")

			if side_extension then
				local side_id = side_extension.side_id

				config:add("SideExtension", {
					side_id = side_id
				})
			end

			local owner = Managers.state.player_unit_spawn:owner(owner_unit)

			if owner then
				Managers.state.player_unit_spawn:assign_unit_ownership(unit, owner)
			end

			local owner_weapon_extension = ScriptUnit.has_extension(owner_unit, "weapon_system")

			if owner_weapon_extension then
				local damage_profile_lerp_values = owner_weapon_extension:damage_profile_lerp_values()
				local explosion_template_lerp_values = owner_weapon_extension:explosion_template_lerp_values()

				config:add("ProjectileUnitWeaponExtension", {
					damage_profile_lerp_values = damage_profile_lerp_values,
					explosion_template_lerp_values = explosion_template_lerp_values
				})
			end
		end

		config:add("ProjectileDamageExtension", {
			projectile_template = projectile_template,
			owner_unit = owner_unit,
			charge_level = charge_level,
			is_critical_strike = is_critical_strike,
			origin_item_slot = origin_item_slot,
			weapon_item_or_nil = weapon_item_or_nil or item
		})

		local item_name = item.name
		local item_id = NetworkLookup.player_item_names[item_name]
		local projectile_template_name = projectile_template.name
		local projectile_template_name_id = NetworkLookup.projectile_template_names[projectile_template_name]

		config:add("ProjectileFxExtension", {
			projectile_template_name = projectile_template_name
		})
		config:add("ProjectileUnitLocomotionExtension", {
			handle_oob_despawning = true,
			starting_state = starting_state,
			projectile_template_name = projectile_template_name,
			direction = direction,
			speed = speed,
			momentum_or_angular_velocity = momentum_or_angular_velocity,
			owner_unit = owner_unit,
			target_unit = target_unit,
			target_position = target_position,
			optional_item = item
		})

		game_object_data.item_id = item_id
		game_object_data.projectile_template_id = projectile_template_name_id
		local spawn_flow_event = projectile_template.spawn_flow_event

		if spawn_flow_event then
			Unit.flow_event(unit, spawn_flow_event)
		end
	end,
	husk_init = function (unit, config, template_context, game_session, game_object_id, owner_id)
		local go_field = GameSession.game_object_field
		local projectile_template_name_id = go_field(game_session, game_object_id, "projectile_template_id")
		local projectile_template_name = NetworkLookup.projectile_template_names[projectile_template_name_id]
		local item_definitions = MasterItems.get_cached()
		local item_id = go_field(game_session, game_object_id, "item_id")
		local item_name = NetworkLookup.player_item_names[item_id]
		local item = item_definitions[item_name]

		config:add("ProjectileFxExtension", {
			projectile_template_name = projectile_template_name
		})
		config:add("ProjectileHuskLocomotionExtension", {
			hide_until_initial_interpolation_start = true,
			projectile_template_name = projectile_template_name,
			optional_item = item
		})

		local projectile_template = ProjectileTemplates[projectile_template_name]
		local spawn_flow_event = projectile_template.spawn_flow_event

		if spawn_flow_event then
			Unit.flow_event(unit, spawn_flow_event)
		end
	end,
	pre_unit_destroyed = function (unit)
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local has_owner = player_unit_spawn_manager:owner(unit) ~= nil

		if has_owner then
			player_unit_spawn_manager:relinquish_unit_ownership(unit)
		end
	end
}
unit_templates.medical_crate_deployable = {
	local_unit = function (unit_name, position, rotation, material, ...)
		unit_name = "content/pickups/pocketables/medical_crate/deployable_medical_crate"

		return unit_name, position, rotation, material
	end,
	husk_unit = function (session, object_id)
		local unit_name = "content/pickups/pocketables/medical_crate/deployable_medical_crate"
		local position, rotation = _position_rotation_from_game_object(session, object_id)

		return unit_name, position, rotation
	end,
	game_object_type = function ()
		return "medical_crate_deployable"
	end,
	local_init = function (unit, config, template_context, game_object_data, side_id, deployable, placed_on_unit)
		local is_server = template_context.is_server

		assert(is_server, "Can't create unit other than on server.")
		Unit.set_data(unit, "deployable_type", "medical_crate")

		local radius = 1
		local categories = {
			"health",
			"deployable"
		}

		config:add("BroadphaseExtension", {
			radius = radius,
			categories = categories
		})
		config:add("SideExtension", {
			side_id = side_id
		})

		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase
		local relation_init_data = {
			allied = {
				proximity_radius = deployable.proximity_radius,
				stickiness_limit = deployable.stickiness_limit,
				stickiness_time = deployable.stickiness_time,
				logic = {
					{
						use_as_job = true,
						class_name = "ProximityHeal",
						init_data = deployable.proximity_heal_init_data
					}
				}
			}
		}

		config:add("SideRelationProximityExtension", {
			broadphase = broadphase,
			relation_init_data = relation_init_data
		})
		config:add("PointOfInterestTargetExtension", {
			tag = "healthstation"
		})
		config:add("ComponentExtension")
		config:add("SmartTagExtension", {
			target_type = "medical_crate_deployable",
			auto_tag_on_spawn = true
		})
		config:add("DeployableUnitLocomotionExtension", {
			placed_on_unit = placed_on_unit
		})

		game_object_data.side_id = side_id
		game_object_data.position = Unit.local_position(unit, 1)
		game_object_data.rotation = Unit.local_rotation(unit, 1)

		if placed_on_unit then
			local _, placed_on_unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(placed_on_unit)
			game_object_data.placed_on_unit_id = placed_on_unit_id
		end

		Unit.flow_event(unit, "lua_deploy")
	end,
	husk_init = function (unit, config, template_context, game_session, game_object_id, owner_id)
		local go_field = GameSession.game_object_field
		local side_id = go_field(game_session, game_object_id, "side_id")

		config:add("SideExtension", {
			side_id = side_id
		})
		config:add("ComponentExtension")
		config:add("HuskCoherencyExtension")
		config:add("SmartTagExtension", {
			target_type = "medical_crate_deployable"
		})
		config:add("DeployableHuskLocomotionExtension", {})
		Unit.flow_event(unit, "lua_deploy")
	end,
	unit_spawned = function (unit, template_context, game_object_data_or_session, is_husk, ...)
		if not is_husk then
			local job_class = ScriptUnit.extension(unit, "proximity_system")

			Managers.state.unit_job:register(unit, job_class)
		end
	end
}
unit_templates.force_field = {
	local_unit = function (unit_name, position, rotation, ...)
		local rotation = Quaternion.from_yaw_pitch_roll(Quaternion.yaw(rotation), 0, 0)

		return unit_name, position, rotation
	end,
	husk_unit = function (session, object_id)
		local unit_name_id = GameSession.game_object_field(session, object_id, "unit_name_id")
		local unit_name = NetworkLookup.force_field_unit_names[unit_name_id]
		local position, rotation = _position_rotation_from_game_object(session, object_id)

		return unit_name, position, rotation
	end,
	game_object_type = function ()
		return "force_field"
	end,
	local_init = function (unit, config, template_context, game_object_data, husk_unit_name, placed_on_unit, owner_unit)
		local is_server = template_context.is_server

		assert(is_server, "Can't create unit other than on server.")
		config:add("DeployableUnitLocomotionExtension", {
			placed_on_unit = placed_on_unit
		})
		config:add("ForceFieldExtension", {
			owner_unit = owner_unit
		})

		local rotation = Unit.local_rotation(unit, 1)
		game_object_data.unit_name_id = NetworkLookup.force_field_unit_names[husk_unit_name]
		game_object_data.position = Unit.local_position(unit, 1)
		game_object_data.yaw = Quaternion.yaw(rotation)
		game_object_data.pitch = 0

		if placed_on_unit then
			local _, placed_on_unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(placed_on_unit)
			game_object_data.placed_on_unit_id = placed_on_unit_id
		end

		if owner_unit then
			local _, owner_unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(owner_unit)
			game_object_data.owner_unit_id = owner_unit_id
		end
	end,
	husk_init = function (unit, config, template_context, game_session, game_object_id, owner_id)
		config:add("DeployableHuskLocomotionExtension", {})
		config:add("ForceFieldExtension", {})
	end,
	unit_spawned = function (unit, template_context, game_object_data_or_session, is_husk, ...)
		return
	end
}

return unit_templates
