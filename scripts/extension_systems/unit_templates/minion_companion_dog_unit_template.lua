-- chunkname: @scripts/extension_systems/unit_templates/minion_companion_dog_unit_template.lua

local Breeds = require("scripts/settings/breed/breeds")
local DialogueBreedSettings = require("scripts/settings/dialogue/dialogue_breed_settings")
local NetworkLookup = require("scripts/network_lookup/network_lookup")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local UnitTemplate = require("scripts/extension_systems/unit_templates/utilities/unit_template")
local minion_companion_dog_unit_template = {
	local_unit = function (unit_name, position, rotation, material, init_data, ...)
		local breed, random_seed = init_data.breed, init_data.random_seed

		unit_name = unit_name or breed.base_unit

		local size_variation_range = breed.size_variation_range

		if size_variation_range then
			local pose = UnitTemplate.size_variation_pose_from_breed(position, rotation, size_variation_range, random_seed)

			return unit_name, pose, material
		else
			return unit_name, position, rotation, material
		end
	end,
	husk_unit = UnitTemplate.breed_unit_name_position_rotation_from_game_object,
	game_object_type = function (init_data, ...)
		local breed = init_data.breed
		local game_object_type = breed.game_object_type

		return game_object_type
	end,
	local_init = function (unit, config, template_context, game_object_data, init_data, ...)
		local is_in_hub = Managers.state.game_mode:is_social_hub() or Managers.state.game_mode:is_prologue_hub()
		local breed, side_id = init_data.breed, init_data.side_id
		local broadphase_radius, broadphase_categories = UnitTemplate.broadphase_radius_and_categories(breed, side_id)
		local blackboard_component_config = is_in_hub and breed.blackboard_component_config_hub or breed.blackboard_component_config
		local breed_name, behavior_tree_name = breed.name, is_in_hub and breed.behavior_tree_name_hub or breed.behavior_tree_name
		local spawn_buffs = breed.spawn_buffs
		local owner_unit = init_data.optional_owner_player_unit
		local owner_player = init_data.optional_owner_player
		local random_seed = init_data.random_seed
		local next_seed, animation_seed, buff_seed, voice_selection_seed, _

		next_seed, animation_seed = math.random_seed(random_seed)
		next_seed, buff_seed = math.random_seed(next_seed)
		_, voice_selection_seed = math.random_seed(next_seed)

		config:add("BlackboardExtension", {
			component_config = blackboard_component_config,
		})
		config:add("BroadphaseExtension", {
			moving = true,
			radius = broadphase_radius,
			categories = broadphase_categories,
		})
		config:add("MinionAnimationExtension", {
			breed = breed,
			random_seed = animation_seed,
			is_in_hub = is_in_hub,
		})
		config:add("CompanionVisualLoadoutExtension", {
			breed = breed,
			owner_player = owner_player,
		})
		config:add("MinionFxExtension", {
			breed = breed,
		})
		config:add("MinionLocomotionExtension", {
			breed = breed,
		})
		config:add("MinionNavigationExtension", {
			breed = breed,
		})
		config:add("SideExtension", {
			side_id = side_id,
			breed = breed,
		})
		config:add("MinionUnitDataExtension", {
			breed = breed,
		})
		config:add("CompanionCoherencyExtension", {
			owner_player = owner_player,
			coherency_settings = PlayerCharacterConstants.coherency,
		})

		if not is_in_hub then
			config:add("CompanionTagManagerDogExtension", {
				breed = breed,
			})
		end

		if is_in_hub then
			config:add("InteracteeExtension", {
				interaction_type = "companion_hub_interact",
				is_local_unit = false,
				override_context = {},
			})
		end

		local behavior_extension_init_data = {
			breed = breed,
			behavior_tree_name = behavior_tree_name,
			owner_unit = init_data.optional_owner_player_unit,
		}

		config:add("MinionBehaviorExtension", behavior_extension_init_data)

		if not is_in_hub then
			config:add("CompanionOutlineExtension", {
				breed = breed,
				owner_unit = owner_unit,
				owner_player = owner_player,
			})
		end

		config:add("MinionBuffExtension", {
			buff_seed = buff_seed,
			breed = breed,
			initial_buffs = spawn_buffs,
		})

		local optional_aggro_state, optional_target_unit = init_data.optional_aggro_state, init_data.optional_target_unit

		config:add("MinionPerceptionExtension", {
			breed = breed,
			aggro_state = optional_aggro_state,
			target_unit = optional_target_unit,
		})

		local dialogue_settings = DialogueBreedSettings[breed_name]

		if dialogue_settings.has_dialogue_extension then
			config:add("DialogueExtension", {
				local_player = false,
				breed = breed,
				seed = voice_selection_seed,
			})
		end

		if breed.aim_config then
			config:add("MinionRangedAimExtension", {
				breed = breed,
			})
		end

		config:add("MinionProximityExtension", {
			side_id = side_id,
			breed = breed,
		})
		config:add("FadeExtension")

		local game_object_type = breed.game_object_type
		local breed_id = NetworkLookup.breed_names[breed_name]
		local rotation = Unit.local_rotation(unit, 1)

		game_object_data.breed_id = breed_id
		game_object_data.position = Unit.local_position(unit, 1)

		if Network.object_has_field(game_object_type, "rotation") then
			game_object_data.rotation = rotation
		else
			game_object_data.yaw, game_object_data.pitch = Quaternion.yaw(rotation), Quaternion.pitch(rotation)
		end

		local owner = owner_unit and Managers.state.player_unit_spawn:owner(owner_unit)

		if owner then
			Managers.state.player_unit_spawn:assign_unit_ownership(unit, owner)

			local owner_unit_companion_spawner_extension = ScriptUnit.has_extension(owner_unit, "companion_spawner_system")

			owner_unit_companion_spawner_extension:register_spawned_companion_unit(unit)
		end

		local owner_game_object_id = owner_unit and Managers.state.unit_spawner:game_object_id(owner_unit) or NetworkConstants.invalid_game_object_id

		game_object_data.owner_unit_id = owner_game_object_id
		game_object_data.side_id = side_id
		game_object_data.has_teleported = 1
		game_object_data.random_seed = random_seed
		game_object_data.target_unit_id = NetworkConstants.invalid_game_object_id
	end,
	husk_init = function (unit, config, template_context, game_session, game_object_id, owner_id)
		local is_in_hub = Managers.state.game_mode:is_social_hub() or Managers.state.game_mode:is_prologue_hub()
		local go_field = GameSession.game_object_field
		local side_id = go_field(game_session, game_object_id, "side_id")
		local breed_id = go_field(game_session, game_object_id, "breed_id")
		local random_seed = go_field(game_session, game_object_id, "random_seed")
		local breed_name = NetworkLookup.breed_names[breed_id]
		local breed = Breeds[breed_name]
		local broadphase_radius, broadphase_categories = UnitTemplate.broadphase_radius_and_categories(breed, side_id)
		local owner_unit_id = go_field(game_session, game_object_id, "owner_unit_id")
		local owner_unit

		if owner_unit_id ~= NetworkConstants.invalid_game_object_id then
			owner_unit = Managers.state.unit_spawner:unit(owner_unit_id)
		end

		local owner_player = owner_unit and Managers.state.player_unit_spawn:owner(owner_unit)
		local next_seed, animation_seed, buff_seed, voice_selection_seed, _

		next_seed, animation_seed = math.random_seed(random_seed)
		next_seed, buff_seed = math.random_seed(next_seed)
		_, voice_selection_seed = math.random_seed(next_seed)

		config:add("MinionAnimationExtension", {
			breed = breed,
			random_seed = animation_seed,
			is_in_hub = is_in_hub,
		})
		config:add("CompanionVisualLoadoutExtension", {
			breed = breed,
			owner_player = owner_player,
		})
		config:add("MinionFxExtension", {
			breed = breed,
		})
		config:add("MinionHuskLocomotionExtension", {
			breed = breed,
		})
		config:add("MinionHuskNavigationExtension")
		config:add("SideExtension", {
			side_id = side_id,
			breed = breed,
		})
		config:add("MinionUnitDataExtension", {
			breed = breed,
		})

		if not is_in_hub then
			config:add("CompanionOutlineExtension", {
				breed = breed,
				owner_player = owner_player,
			})
		end

		config:add("BroadphaseExtension", {
			moving = true,
			radius = broadphase_radius,
			categories = broadphase_categories,
		})

		if is_in_hub then
			config:add("InteracteeExtension", {
				interaction_type = "companion_hub_interact",
				is_local_unit = false,
				override_context = {},
			})
		end

		if breed.aim_config then
			config:add("MinionRangedHuskAimExtension", {
				breed = breed,
			})
		end

		if owner_player then
			Managers.state.player_unit_spawn:assign_unit_ownership(unit, owner_player)

			local owner_unit_companion_spawner_extension = ScriptUnit.has_extension(owner_unit, "companion_spawner_system")

			owner_unit_companion_spawner_extension:register_spawned_companion_unit(unit)
		end

		config:add("MinionBuffExtension", {
			buff_seed = buff_seed,
			breed = breed,
		})
		config:add("MinionProximityExtension", {
			side_id = side_id,
			breed = breed,
		})
		config:add("FadeExtension")

		local dialogue_settings = DialogueBreedSettings[breed_name]

		if dialogue_settings.has_dialogue_extension then
			config:add("DialogueExtension", {
				local_player = false,
				breed = breed,
				seed = voice_selection_seed,
			})
		end
	end,
	pre_unit_destroyed = function (unit)
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local has_owner = player_unit_spawn_manager:owner(unit) ~= nil

		if has_owner then
			player_unit_spawn_manager:relinquish_unit_ownership(unit)
		end
	end,
}

return minion_companion_dog_unit_template
