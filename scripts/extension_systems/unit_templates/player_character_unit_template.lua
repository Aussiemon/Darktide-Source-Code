-- chunkname: @scripts/extension_systems/unit_templates/player_character_unit_template.lua

local BreedBlackboardComponentTemplates = require("scripts/settings/breed/breed_blackboard_component_templates")
local Breeds = require("scripts/settings/breed/breeds")
local NetworkLookup = require("scripts/network_lookup/network_lookup")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerCharacterStates = require("scripts/settings/player_character/player_character_states")
local PlayerHeight = require("scripts/utilities/player_height")
local TalentLayoutParser = require("scripts/ui/views/talent_builder_view/utilities/talent_layout_parser")
local UnitTemplate = require("scripts/extension_systems/unit_templates/utilities/unit_template")
local GAME_OBJECT_TYPE = "player_unit"
local PLAYER_AIM_CONSTRAINT_DISTANCE = 5
local player_character_unit_template = {
	local_unit = function (unit_name, position, rotation, material, player, breed, side_id, optional_starting_state, input_handler, random_seed, ...)
		unit_name = unit_name or breed.base_unit

		local profile = player:profile()
		local third_person_scale = PlayerHeight.player_character_third_person_scale(breed, profile, random_seed)

		if third_person_scale ~= 1 then
			local pose = Matrix4x4.from_quaternion_position(rotation, position)

			Matrix4x4.set_scale(pose, Vector3(third_person_scale, third_person_scale, third_person_scale))

			return unit_name, pose, material
		else
			return unit_name, position, rotation, material
		end
	end,
	husk_unit = UnitTemplate.player_unit_name_position_rotation_from_game_object,
	game_object_type = function (player)
		return GAME_OBJECT_TYPE
	end,
	local_init = function (unit, config, template_context, game_object_data, player, breed, side_id, optional_starting_state, input_handler, random_seed, optional_damage, optional_permanent_damage, ...)
		local is_server = template_context.is_server
		local profile = player:profile()
		local archetype = profile.archetype
		local talents = profile.talents

		if not profile.is_local_profile then
			local active_layouts = TalentLayoutParser.archetype_layouts(archetype)

			talents = TalentLayoutParser.validate_talent_layouts(talents, active_layouts, false)
		end

		local game_mode_manager = Managers.state.game_mode
		local initial_items = UnitTemplate.player_character_initial_items(game_mode_manager, profile, player)
		local mission = Managers.state.mission:mission()
		local broadphase_radius, broadphase_categories = UnitTemplate.broadphase_radius_and_categories(breed, side_id)
		local first_person_heights = PlayerHeight.player_character_first_person_heights(breed, profile, random_seed)
		local next_seed, recoil_seed, buff_seed, spread_seed, character_state_seed, critical_strike_seed, _

		next_seed, recoil_seed = math.random_seed(random_seed)
		next_seed, buff_seed = math.random_seed(next_seed)
		next_seed, spread_seed = math.random_seed(next_seed)
		next_seed, character_state_seed = math.random_seed(next_seed)
		_, critical_strike_seed = math.random_seed(next_seed)

		local package_synchronizer_client = Managers.package_synchronization:synchronizer_client()
		local force_third_person_mode = UnitTemplate.force_third_person_mode()
		local use_third_person_hub_camera = UnitTemplate.use_third_person_hub_camera()
		local default_wielded_slot_name = game_mode_manager:default_wielded_slot_name()
		local starting_character_state = game_mode_manager:starting_character_state_name() or optional_starting_state or "walking"
		local is_local_unit, is_human_controlled = not player.remote, player:is_human_controlled()
		local blackboard_component_config, behavior_tree_name

		blackboard_component_config, behavior_tree_name = breed.blackboard_component_config, breed.behavior_tree_name

		config:add("BlackboardExtension", {
			component_config = blackboard_component_config,
		})
		config:add("BroadphaseExtension", {
			moving = true,
			radius = broadphase_radius,
			categories = broadphase_categories,
		})
		config:add("PlayerUnitDataExtension", {
			player = player,
			breed = breed,
			is_local_unit = is_local_unit,
			archetype = archetype,
		})
		config:add("PlayerUnitAttackIntensityExtension")
		config:add("AuthoritativePlayerUnitAnimationExtension", {
			player = player,
			breed = breed,
			is_local_unit = is_local_unit,
		})
		config:add("PlayerUnitInputExtension", {
			player = player,
			input_handler = input_handler,
			is_local_unit = is_local_unit,
		})
		config:add("BotNavigationExtension", {
			nav_tag_allowed_layers = breed.nav_tag_allowed_layers,
			nav_cost_map_multipliers = breed.nav_cost_map_multipliers,
			player = player,
		})
		config:add("PlayerUnitLocomotionExtension", {
			player = player,
			is_local_unit = is_local_unit,
			player_character_constants = PlayerCharacterConstants,
			breed = breed,
		})
		config:add("PlayerUnitFxExtension", {
			is_local_unit = is_local_unit,
			player = player,
			breed = breed,
		})
		config:add("PlayerUnitFirstPersonExtension", {
			player = player,
			is_local_unit = is_local_unit,
			unit_name = breed.first_person_unit,
			heights = first_person_heights,
			force_third_person_mode = force_third_person_mode,
			breed = breed,
		})
		config:add("PlayerUnitCameraExtension", {
			is_local_unit = is_local_unit,
			breed = breed,
			use_third_person_hub_camera = use_third_person_hub_camera,
		})
		config:add("PlayerUnitActionInputExtension", {
			is_social_hub = false,
		})

		local spawn_buffs = breed.spawn_buffs

		config:add("PlayerUnitBuffExtension", {
			player = player,
			is_local_unit = is_local_unit,
			buff_seed = buff_seed,
			breed = breed,
			initial_buffs = spawn_buffs,
		})
		config:add("PlayerUnitWeaponExtension", {
			player = player,
			is_local_unit = is_local_unit,
			is_human_unit = is_human_controlled,
			is_server = is_server,
			critical_strike_seed = critical_strike_seed,
		})
		config:add("PlayerUnitWeaponSpreadExtension", {
			spread_seed = spread_seed,
		})
		config:add("PlayerUnitWeaponRecoilExtension", {
			player = player,
			recoil_seed = recoil_seed,
			is_local_unit = is_local_unit,
		})
		config:add("PlayerUnitGadgetExtension", {
			player = player,
			is_local_unit = is_local_unit,
			is_server = is_server,
		})
		config:add("DialogueExtension", {
			breed = breed,
			local_player = is_local_unit,
			faction = breed.faction_name,
			selected_voice = profile.selected_voice,
		})
		config:add("DialogueContextExtension", {
			breed = breed,
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
			default_wielded_slot_name = default_wielded_slot_name,
		})
		config:add("PlayerUnitAbilityExtension", {
			is_local_unit = is_local_unit,
			is_server = is_server,
			player = player,
		})
		config:add("PlayerSuppressionExtension", {
			is_local_unit = is_local_unit,
			player = player,
		})

		if game_mode_manager:is_vaulting_allowed() then
			config:add("PlayerUnitLedgeFinderExtension", {
				ledge_finder_tweak_data = breed.ledge_finder_tweak_data,
			})
		end

		config:add("CharacterStateMachineExtension", {
			player = player,
			state_class_list = PlayerCharacterStates,
			start_state = starting_character_state,
			breed = breed,
			player_character_constants = PlayerCharacterConstants,
			is_local_unit = is_local_unit,
			initial_seed = character_state_seed,
		})
		config:add("SideExtension", {
			is_player_unit = true,
			side_id = side_id,
			is_human_unit = is_human_controlled,
			breed = breed,
		})
		config:add("BotPerceptionExtension", {
			player = player,
			breed = breed,
		})
		config:add("PlayerGroupExtension", {
			side_id = side_id,
			player = player,
		})
		config:add("PlayerUnitAimExtension", {
			aim_constraint_target_name = "aim_constraint_target",
			aim_constraint_distance = PLAYER_AIM_CONSTRAINT_DISTANCE,
		})

		if (not is_local_unit or not is_human_controlled) and not Managers.state.game_mode:disable_hologram() then
			config:add("PlayerUnitHologramExtension", {
				breed = breed,
			})
		end

		local archetype_name = archetype.name
		local health = archetype.health
		local knocked_down_health = archetype.knocked_down_health
		local wounds = Managers.state.difficulty:player_wounds(archetype_name)
		local is_unkillable = false
		local is_invulnerable = false
		local toughness_template = archetype.toughness

		config:add("PlayerUnitHealthExtension", {
			player = player,
			health = health,
			knocked_down_health = knocked_down_health,
			wounds = wounds,
			is_unkillable = is_unkillable,
			is_invulnerable = is_invulnerable,
			optional_damage = optional_damage,
			optional_permanent_damage = optional_permanent_damage,
		})
		config:add("PlayerUnitToughnessExtension", {
			toughness_template = toughness_template,
			is_local_unit = is_local_unit,
			is_human_controlled = is_human_controlled,
		})
		config:add("InteractorExtension", {
			player = player,
		})
		config:add("PlayerInteracteeExtension", {
			interaction_contexts = PlayerCharacterConstants.player_interactions,
			is_local_unit = is_local_unit,
		})
		config:add("PlayerVolumeEventExtension")
		config:add("SlotExtension")
		config:add("PointOfInterestObserverExtension", {
			view_angle = math.pi / 32,
		})
		config:add("PlayerProximityExtension", {
			side_id = side_id,
			breed = breed,
		})
		config:add("ComponentExtension")
		config:add("PlayerUnitDarknessExtension", {
			intensity = 0.04,
		})
		config:add("PhysicsUnitProximityObserverExtension", {
			player = player,
		})

		if is_human_controlled then
			config:add("PlayerUnitMusicParameterExtension")
		end

		config:add("PlayerUnitSmartTargetingExtension", {
			is_social_hub = false,
			player = player,
			is_server = is_server,
			is_local_unit = is_local_unit,
		})
		config:add("PlayerVisibilityExtension", {
			player = player,
		})
		config:add("SmartTagExtension", {})
		config:add("PlayerUnitOutlineExtension", {
			is_local_unit = is_local_unit,
			is_human_controlled = is_human_controlled,
		})
		config:add("FadeExtension")
		config:add("UnitCoherencyExtension", {
			player = player,
			coherency_settings = PlayerCharacterConstants.coherency,
		})
		config:add("PlayerUnitTalentExtension", {
			player = player,
			archetype = archetype,
			talents = talents,
			is_local_unit = is_local_unit,
		})
		config:add("CompanionSpawnerExtension", {
			player = player,
			archetype = archetype,
			is_local_unit = is_local_unit,
		})
		config:add("BotBehaviorExtension", {
			breed = breed,
			player = player,
			behavior_tree_name = behavior_tree_name,
			optional_gestalts = profile.bot_gestalts,
		})

		if is_human_controlled then
			config:add("PlayerUnitMoodExtension", {
				player = player,
			})
		end

		local breed_name = breed.name
		local breed_id = NetworkLookup.breed_names[breed_name]

		game_object_data.owner_peer_id = player:peer_id()
		game_object_data.local_player_id = player:local_player_id()
		game_object_data.side_id = side_id
		game_object_data.breed_id = breed_id
		game_object_data.random_seed = random_seed
		game_object_data.warp_grabbed_execution_time = NetworkConstants.max_fixed_frame_time

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
		local initial_items = UnitTemplate.player_character_initial_items(game_mode_manager, profile, player)
		local mission = Managers.state.mission:mission()
		local talents = profile.talents
		local first_person_heights = PlayerHeight.player_character_first_person_heights(breed, profile, random_seed)
		local package_synchronizer_client = Managers.package_synchronization:synchronizer_client()
		local toughness_template = archetype.toughness
		local broadphase_radius, broadphase_categories = UnitTemplate.broadphase_radius_and_categories(breed, side_id)

		if not is_server and player.remote then
			config:add("BroadphaseExtension", {
				moving = true,
				radius = broadphase_radius,
				categories = broadphase_categories,
			})
			config:add("PlayerHuskDataExtension", {
				player = player,
				breed = breed,
				archetype = archetype,
			})
			config:add("PlayerUnitFxExtension", {
				is_local_unit = false,
				player = player,
				breed = breed,
			})
			config:add("PlayerHuskFirstPersonExtension", {
				player = player,
				unit_name = breed.first_person_unit,
				heights = first_person_heights,
				breed = breed,
			})
			config:add("PlayerHuskAnimationExtension")
			config:add("PlayerHuskLocomotionExtension", {
				player = player,
				breed = breed,
			})
			config:add("PlayerHuskCameraExtension", {
				is_local_unit = false,
			})
			config:add("DialogueExtension", {
				local_player = false,
				breed = breed,
				faction = breed.faction_name,
				selected_voice = profile.selected_voice,
			})
			config:add("PlayerHuskVisualLoadoutExtension", {
				player = player,
				slot_configuration = PlayerCharacterConstants.slot_configuration,
				archetype = archetype,
				selected_voice = profile.selected_voice,
				package_synchronizer_client = package_synchronizer_client,
				mission = mission,
			})
			config:add("PlayerHuskAbilityExtension", {
				is_local_unit = false,
				is_server = is_server,
			})
			config:add("PlayerHuskAimExtension", {
				aim_constraint_target_name = "aim_constraint_target",
				aim_constraint_distance = PLAYER_AIM_CONSTRAINT_DISTANCE,
			})

			if not Managers.state.game_mode:disable_hologram() then
				config:add("PlayerUnitHologramExtension", {
					breed = breed,
				})
			end

			local archetype_name = archetype.name
			local wounds = Managers.state.difficulty:player_wounds(archetype_name)

			config:add("PlayerHuskHealthExtension", {
				is_local_unit = false,
				wounds = wounds,
			})
			config:add("PlayerSuppressionExtension", {
				is_local_unit = false,
				player = player,
			})
			config:add("PlayerHuskToughnessExtension", {
				is_local_unit = false,
				toughness_template = toughness_template,
			})
			config:add("PlayerUnitDarknessExtension", {
				intensity = 0.04,
			})
			config:add("PhysicsUnitProximityObserverExtension", {
				player = player,
			})
			config:add("PlayerInteracteeExtension", {
				is_local_unit = false,
				interaction_contexts = PlayerCharacterConstants.player_interactions,
			})
			config:add("SideExtension", {
				is_human_unit = true,
				is_player_unit = true,
				side_id = side_id,
				breed = breed,
			})
			config:add("PlayerHuskBuffExtension", {
				is_local_unit = false,
				player = player,
			})

			if is_human_controlled then
				config:add("PlayerHuskMusicParameterExtension")
			end

			config:add("PlayerVisibilityExtension", {
				player = player,
			})
			config:add("SmartTagExtension", {})
			config:add("PlayerUnitOutlineExtension", {
				is_human_controlled = true,
				is_local_unit = false,
			})
			config:add("HuskCoherencyExtension")
			config:add("PlayerHuskTalentExtension", {
				is_local_unit = false,
				player = player,
				archetype = archetype,
				talents = talents,
				package_synchronizer_client = package_synchronizer_client,
			})
			config:add("PlayerUnitMoodExtension", {
				player = player,
			})
			config:add("FadeExtension")
			config:add("CompanionSpawnerExtension", {
				is_local_unit = false,
				player = player,
				archetype = archetype,
			})

			local player_unit_spawn_manager = Managers.state.player_unit_spawn

			player_unit_spawn_manager:assign_unit_ownership(unit, player, true)
		else
			local rotation = Unit.local_rotation(unit, 1)
			local pitch = Quaternion.pitch(rotation)
			local yaw = Quaternion.yaw(rotation)

			player:set_orientation(yaw, pitch, 0)

			local next_seed, recoil_seed, buff_seed, spread_seed, character_state_seed, critical_strike_seed, _

			next_seed, recoil_seed = math.random_seed(random_seed)
			next_seed, buff_seed = math.random_seed(next_seed)
			next_seed, spread_seed = math.random_seed(next_seed)
			next_seed, character_state_seed = math.random_seed(next_seed)
			_, critical_strike_seed = math.random_seed(next_seed)

			local force_third_person_mode = UnitTemplate.force_third_person_mode()
			local use_third_person_hub_camera = UnitTemplate.use_third_person_hub_camera()
			local default_wielded_slot_name = game_mode_manager:default_wielded_slot_name()
			local starting_character_state = game_mode_manager:starting_character_state_name() or "walking"
			local is_local_unit = true
			local input_handler = player.input_handler

			config:add("BroadphaseExtension", {
				moving = true,
				radius = broadphase_radius,
				categories = broadphase_categories,
			})
			config:add("PlayerUnitDataExtension", {
				player = player,
				breed = breed,
				is_local_unit = is_local_unit,
				archetype = archetype,
			})
			config:add("PlayerUnitAnimationExtension")
			config:add("PlayerUnitInputExtension", {
				player = player,
				input_handler = input_handler,
				is_local_unit = is_local_unit,
			})
			config:add("PlayerUnitLocomotionExtension", {
				player = player,
				is_local_unit = is_local_unit,
				player_character_constants = PlayerCharacterConstants,
				breed = breed,
			})
			config:add("PlayerUnitFxExtension", {
				is_local_unit = is_local_unit,
				player = player,
				breed = breed,
			})
			config:add("PlayerUnitFirstPersonExtension", {
				player = player,
				is_local_unit = is_local_unit,
				unit_name = breed.first_person_unit,
				heights = first_person_heights,
				force_third_person_mode = force_third_person_mode,
				breed = breed,
			})
			config:add("PlayerUnitCameraExtension", {
				is_local_unit = is_local_unit,
				breed = breed,
				use_third_person_hub_camera = use_third_person_hub_camera,
			})
			config:add("SideExtension", {
				is_human_unit = true,
				is_player_unit = true,
				side_id = side_id,
				breed = breed,
			})
			config:add("PlayerUnitActionInputExtension", {
				is_social_hub = false,
			})
			config:add("PlayerUnitBuffExtension", {
				player = player,
				is_local_unit = is_local_unit,
				buff_seed = buff_seed,
				breed = breed,
			})
			config:add("PlayerUnitWeaponExtension", {
				is_server = false,
				player = player,
				is_local_unit = is_local_unit,
				is_human_unit = is_human_controlled,
				critical_strike_seed = critical_strike_seed,
			})
			config:add("PlayerUnitWeaponSpreadExtension", {
				spread_seed = spread_seed,
			})
			config:add("PlayerUnitWeaponRecoilExtension", {
				player = player,
				recoil_seed = recoil_seed,
				is_local_unit = is_local_unit,
			})
			config:add("PlayerUnitGadgetExtension", {
				player = player,
				is_local_unit = is_local_unit,
				is_server = is_server,
			})
			config:add("DialogueExtension", {
				local_player = true,
				breed = breed,
				faction = breed.faction_name,
				selected_voice = profile.selected_voice,
			})
			config:add("DialogueContextExtension", {
				breed = breed,
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
				default_wielded_slot_name = default_wielded_slot_name,
			})
			config:add("PlayerUnitAbilityExtension", {
				is_server = false,
				is_local_unit = is_local_unit,
				equipped_abilities = profile.abilities,
				player = player,
			})
			config:add("PlayerSuppressionExtension", {
				is_local_unit = is_local_unit,
				player = player,
			})

			if game_mode_manager:is_vaulting_allowed() then
				config:add("PlayerUnitLedgeFinderExtension", {
					ledge_finder_tweak_data = breed.ledge_finder_tweak_data,
				})
			end

			config:add("CharacterStateMachineExtension", {
				player = player,
				state_class_list = PlayerCharacterStates,
				start_state = starting_character_state,
				breed = breed,
				player_character_constants = PlayerCharacterConstants,
				is_local_unit = is_local_unit,
				initial_seed = character_state_seed,
			})
			config:add("PlayerUnitAimExtension", {
				aim_constraint_target_name = "aim_constraint_target",
				aim_constraint_distance = PLAYER_AIM_CONSTRAINT_DISTANCE,
			})

			local archetype_name = archetype.name
			local wounds = Managers.state.difficulty:player_wounds(archetype_name)

			config:add("PlayerHuskHealthExtension", {
				wounds = wounds,
				is_local_unit = is_local_unit,
			})
			config:add("PlayerHuskToughnessExtension", {
				toughness_template = toughness_template,
				is_local_unit = is_local_unit,
			})
			config:add("InteractorExtension", {
				player = player,
			})
			config:add("PlayerProximityExtension", {
				side_id = side_id,
				breed = breed,
			})
			config:add("ComponentExtension")
			config:add("PlayerUnitDarknessExtension", {
				intensity = 0.04,
			})
			config:add("PhysicsUnitProximityObserverExtension", {
				player = player,
			})
			config:add("PlayerInteracteeExtension", {
				interaction_contexts = PlayerCharacterConstants.player_interactions,
				is_local_unit = is_local_unit,
			})
			config:add("PlayerHuskMusicParameterExtension")
			config:add("PlayerUnitSmartTargetingExtension", {
				is_social_hub = false,
				player = player,
				is_server = is_server,
				is_local_unit = is_local_unit,
			})
			config:add("PlayerVisibilityExtension", {
				player = player,
			})
			config:add("SmartTagExtension", {})
			config:add("HuskCoherencyExtension")
			config:add("PlayerUnitOutlineExtension", {
				is_human_controlled = true,
				is_local_unit = is_local_unit,
			})
			config:add("PlayerUnitMoodExtension", {
				player = player,
			})
			config:add("FadeExtension")
			config:add("PlayerHuskTalentExtension", {
				player = player,
				archetype = archetype,
				talents = talents,
				is_local_unit = is_local_unit,
				package_synchronizer_client = package_synchronizer_client,
			})
			config:add("CompanionSpawnerExtension", {
				player = player,
				archetype = archetype,
				is_local_unit = is_local_unit,
			})

			local player_unit_spawn_manager = Managers.state.player_unit_spawn

			player_unit_spawn_manager:assign_unit_ownership(unit, player, true)
		end
	end,
	local_unit_spawned = function (unit, template_context, game_object_data, player, breed, side_id, optional_starting_state, input_handler, random_seed, optional_damage, optional_permanent_damage, ...)
		return
	end,
	husk_unit_spawned = function (unit, template_context, game_session, game_object_id, owner_id)
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local player = player_unit_spawn_manager:owner(unit)
	end,
	pre_unit_destroyed = function (unit)
		local player_unit_spawn_manager = Managers.state.player_unit_spawn

		player_unit_spawn_manager:relinquish_unit_ownership(unit)
	end,
}

return player_character_unit_template
