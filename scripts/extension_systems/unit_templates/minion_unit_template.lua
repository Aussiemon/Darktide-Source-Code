-- chunkname: @scripts/extension_systems/unit_templates/minion_unit_template.lua

local Breeds = require("scripts/settings/breed/breeds")
local DialogueBreedSettings = require("scripts/settings/dialogue/dialogue_breed_settings")
local NetworkLookup = require("scripts/network_lookup/network_lookup")
local UnitTemplate = require("scripts/extension_systems/unit_templates/utilities/unit_template")

local function _initialize_breed_specific_game_object_data(game_object_type, game_object_data)
	if game_object_type == "minion_daemonhost" then
		game_object_data.stage = 1
	end

	if game_object_type == "minion_ritualist" then
		game_object_data.effect_template_variation_id = -1
		game_object_data.level_unit_id = NetworkConstants.invalid_level_unit_id
	end
end

local minion_unit_template = {
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
		local breed, side_id = init_data.breed, init_data.side_id
		local broadphase_radius, broadphase_categories = UnitTemplate.broadphase_radius_and_categories(breed, side_id)
		local blackboard_component_config = breed.blackboard_component_config
		local breed_name, behavior_tree_name = breed.name, breed.behavior_tree_name
		local spawn_buffs = breed.spawn_buffs
		local random_seed = init_data.random_seed
		local next_seed, animation_seed, inventory_seed, buff_seed, attack_selection_seed, boss_seed, voice_selection_seed, _

		next_seed, animation_seed = math.random_seed(random_seed)
		next_seed, inventory_seed = math.random_seed(next_seed)
		next_seed, buff_seed = math.random_seed(next_seed)
		next_seed, attack_selection_seed = math.random_seed(next_seed)
		next_seed, boss_seed = math.random_seed(next_seed)
		_, voice_selection_seed = math.random_seed(next_seed)

		config:add("BlackboardExtension", {
			component_config = blackboard_component_config,
		})
		config:add("BroadphaseExtension", {
			moving = true,
			radius = broadphase_radius,
			categories = broadphase_categories,
		})

		if breed.aim_config then
			config:add("MinionRangedAimExtension", {
				breed = breed,
			})
		end

		config:add("MinionUnitDataExtension", {
			breed = breed,
		})

		if breed.attack_intensity_cooldowns then
			config:add("MinionAttackIntensityExtension", {
				breed = breed,
			})
		end

		config:add("MinionBuffExtension", {
			buff_seed = buff_seed,
			breed = breed,
			initial_buffs = spawn_buffs,
		})

		local inventory, attack_selection_template_name, selected_attack_names, phase_template, combat_range_multi_config_key

		inventory, inventory_seed, attack_selection_template_name, selected_attack_names, phase_template, combat_range_multi_config_key = UnitTemplate.resolve_minion_inventory_and_attacks(init_data, breed, game_object_data, attack_selection_seed, inventory_seed)

		config:add("MinionAnimationExtension", {
			breed = breed,
			random_seed = animation_seed,
		})

		if inventory then
			config:add("MinionVisualLoadoutExtension", {
				breed = breed,
				random_seed = inventory_seed,
				inventory = inventory,
			})
		end

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

		local optional_mission_objective_id = init_data.optional_mission_objective_id

		if optional_mission_objective_id then
			config:add("MissionObjectiveTargetExtension")
		end

		if breed.uses_script_components then
			config:add("ComponentExtension")
		end

		local should_perception_be_disabled = Managers.state.game_mode:should_disable_minion_perception()
		local optional_aggro_state, optional_target_unit = init_data.optional_aggro_state, init_data.optional_target_unit

		config:add("MinionPerceptionExtension", {
			breed = breed,
			aggro_state = optional_aggro_state,
			target_unit = optional_target_unit,
			is_perception_disabled = should_perception_be_disabled,
		})

		if breed.cover_config then
			config:add("CoverUserExtension", {
				breed = breed,
				side_id = side_id,
			})
		end

		if breed.combat_vector_config then
			config:add("CombatVectorUserExtension", {
				breed = breed,
			})
		end

		local optional_group_id = init_data.optional_group_id

		if optional_group_id then
			config:add("MinionGroupExtension", {
				breed = breed,
				group_id = optional_group_id,
			})

			game_object_data.group_id = optional_group_id
		end

		if breed.suppress_config then
			config:add("MinionSuppressionExtension", {
				breed = breed,
			})
		end

		local has_health_bar = breed.has_health_bar

		has_health_bar = has_health_bar or DevParameters.show_health_bars_on_elite_and_specials and (breed.tags.elite or breed.tags.special)

		local health_modifier = init_data.optional_health_modifier or 1
		local health = Managers.state.difficulty:get_minion_max_health(breed_name) * health_modifier
		local hit_mass = breed.hit_mass

		if type(hit_mass) == "table" then
			hit_mass = Managers.state.difficulty:get_table_entry_by_challenge(hit_mass)
		end

		local is_unkillable, is_invulnerable = false, false

		config:add("HealthExtension", {
			health = health,
			has_health_bar = has_health_bar,
			hit_mass = hit_mass,
			is_unkillable = is_unkillable,
			is_invulnerable = is_invulnerable,
		})
		config:add("MinionVolumeEventExtension")

		if breed.shield_template then
			config:add("MinionShieldExtension", {
				breed = breed,
			})
		end

		if breed.summon_minions_template then
			config:add("SummonedMinionsExtension", {
				breed = breed,
			})
		end

		if breed.slot_template then
			config:add("SlotUserExtension", {
				breed = breed,
			})
		end

		config:add("MinionProximityExtension", {
			side_id = side_id,
			breed = breed,
		})

		if not breed.always_update_unit then
			config:add("PhysicsUnitProximityActorExtension", {
				time_caching_enabled = true,
			})
		end

		if breed.look_at_tag then
			config:add("PointOfInterestTargetExtension", {
				is_dynamic = true,
				tag = breed.look_at_tag,
				view_distance = breed.look_at_distance,
			})
		end

		local dialogue_settings = DialogueBreedSettings[breed_name]

		if dialogue_settings.has_dialogue_extension then
			config:add("DialogueExtension", {
				local_player = false,
				breed = breed,
				seed = voice_selection_seed,
			})
		end

		if breed.toughness_template then
			local start_depleted = false

			if init_data.optional_void_shield_start_depleted then
				start_depleted = true
			end

			config:add("MinionToughnessExtension", {
				breed = breed,
				start_depleted = start_depleted,
			})
		end

		if breed.is_boss then
			local start_depleted = false

			if init_data.optional_void_shield_start_depleted then
				start_depleted = true
			end

			config:add("BossExtension", {
				breed = breed,
				seed = boss_seed,
				start_depleted = start_depleted,
			})
		end

		if breed.use_wounds then
			config:add("WoundsExtension", {
				breed = breed,
			})
		end

		config:add("FadeExtension")

		if breed.smart_tag_target_type then
			config:add("SmartTagExtension", {
				target_type = breed.smart_tag_target_type,
			})
			config:add("MinionOutlineExtension", {
				breed = breed,
			})
		else
			config:add("MinionOutlineExtension", {
				breed = breed,
			})
		end

		local behavior_extension_init_data = {
			breed = breed,
			behavior_tree_name = behavior_tree_name,
			selected_attack_names = selected_attack_names,
		}

		behavior_extension_init_data.owning_auto_event_id = init_data.optional_owning_auto_event_id
		behavior_extension_init_data.group_target = init_data.optional_group_target

		if breed.combat_range_data then
			behavior_extension_init_data.phase_template = phase_template
			behavior_extension_init_data.combat_range_multi_config_key = combat_range_multi_config_key

			config:add("CombatRangeUserBehaviorExtension", behavior_extension_init_data)
		else
			config:add("MinionBehaviorExtension", behavior_extension_init_data)
		end

		if breed.weakspot_config then
			config:add("WeakspotExtension", {
				breed = breed,
			})
		end

		if breed.dissolve_config then
			config:add("MinionDissolveExtension", {
				breed = breed,
			})
		end

		if breed.tokens then
			config:add("TokenExtension", {
				breed = breed,
			})
		end

		if breed.flee_settings then
			config:add("FleeExtension", {
				breed = breed,
			})
		end

		local scripted_animation_settings = breed.scripted_animation_settings

		if scripted_animation_settings then
			local extension_name = scripted_animation_settings.extension_name

			config:add(extension_name, {
				breed = breed,
			})
		end

		local game_object_type = breed.game_object_type

		_initialize_breed_specific_game_object_data(game_object_type, game_object_data)

		local breed_id = NetworkLookup.breed_names[breed_name]
		local rotation = Unit.local_rotation(unit, 1)

		game_object_data.breed_id = breed_id
		game_object_data.position = Unit.local_position(unit, 1)

		if Network.object_has_field(game_object_type, "rotation") then
			game_object_data.rotation = rotation
		else
			game_object_data.yaw, game_object_data.pitch = Quaternion.yaw(rotation), Quaternion.pitch(rotation)
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
		local broadphase_radius, broadphase_categories = UnitTemplate.broadphase_radius_and_categories(breed, side_id)
		local next_seed, animation_seed, inventory_seed, buff_seed, attack_selection_seed, boss_seed, voice_selection_seed, _

		next_seed, animation_seed = math.random_seed(random_seed)
		next_seed, inventory_seed = math.random_seed(next_seed)
		next_seed, buff_seed = math.random_seed(next_seed)
		next_seed, attack_selection_seed = math.random_seed(next_seed)
		next_seed, boss_seed = math.random_seed(next_seed)
		_, voice_selection_seed = math.random_seed(next_seed)

		config:add("BroadphaseExtension", {
			moving = true,
			radius = broadphase_radius,
			categories = broadphase_categories,
		})
		config:add("MinionUnitDataExtension", {
			breed = breed,
		})

		if breed.aim_config then
			config:add("MinionRangedHuskAimExtension", {
				breed = breed,
			})
		end

		local inventory

		inventory, inventory_seed = UnitTemplate.resolve_minion_husk_inventory(breed, game_session, game_object_id, attack_selection_seed, inventory_seed)

		config:add("MinionAnimationExtension", {
			breed = breed,
			random_seed = animation_seed,
		})

		if inventory then
			config:add("MinionVisualLoadoutExtension", {
				breed = breed,
				random_seed = inventory_seed,
				inventory = inventory,
			})
		end

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
		config:add("MinionBuffExtension", {
			buff_seed = buff_seed,
			breed = breed,
		})

		if GameSession.has_game_object_field(game_session, game_object_id, "group_id") then
			local group_id = go_field(game_session, game_object_id, "group_id")

			config:add("MinionGroupExtension", {
				breed = breed,
				group_id = group_id,
			})
		end

		if breed.suppress_config then
			config:add("MinionSuppressionHuskExtension", {
				breed = breed,
			})
		end

		local has_health_bar = breed.has_health_bar

		config:add("HuskHealthExtension", {
			has_health_bar = has_health_bar,
		})

		if breed.shield_template then
			config:add("MinionHuskShieldExtension", {
				breed = breed,
			})
		end

		if breed.toughness_template then
			config:add("MinionToughnessHuskExtension", {
				breed = breed,
			})
		end

		if breed.is_boss then
			config:add("BossExtension", {
				breed = breed,
				seed = boss_seed,
			})
		end

		if breed.use_wounds then
			config:add("WoundsExtension", {
				breed = breed,
			})
		end

		config:add("MinionProximityExtension", {
			side_id = side_id,
			breed = breed,
		})

		if not breed.always_update_unit then
			config:add("PhysicsUnitProximityActorExtension", {
				time_caching_enabled = false,
			})
		end

		config:add("MissionObjectiveTargetExtension")

		if breed.uses_script_components then
			config:add("ComponentExtension")
		end

		local dialogue_settings = DialogueBreedSettings[breed_name]

		if dialogue_settings.has_dialogue_extension then
			config:add("DialogueExtension", {
				local_player = false,
				breed = breed,
				seed = voice_selection_seed,
			})
		end

		config:add("FadeExtension")

		if breed.dissolve_config then
			config:add("MinionDissolveExtension", {
				breed = breed,
			})
		end

		if breed.tokens then
			config:add("TokenExtension", {
				breed = breed,
			})
		end

		local scripted_animation_settings = breed.scripted_animation_settings

		if scripted_animation_settings then
			local extension_name = scripted_animation_settings.extension_name

			config:add(extension_name, {
				breed = breed,
			})
		end

		if breed.smart_tag_target_type then
			config:add("SmartTagExtension", {
				target_type = breed.smart_tag_target_type,
			})
			config:add("MinionOutlineExtension", {
				breed = breed,
			})
		else
			config:add("MinionOutlineExtension", {
				breed = breed,
			})
		end
	end,
	pre_unit_destroyed = function (unit)
		Managers.state.decal:remove_linked_decals(unit)
	end,
}

return minion_unit_template
