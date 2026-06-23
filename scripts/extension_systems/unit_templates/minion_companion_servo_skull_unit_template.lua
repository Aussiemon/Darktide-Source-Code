-- chunkname: @scripts/extension_systems/unit_templates/minion_companion_servo_skull_unit_template.lua

local Breeds = require("scripts/settings/breed/breeds")
local NetworkLookup = require("scripts/network_lookup/network_lookup")
local UnitTemplate = require("scripts/extension_systems/unit_templates/utilities/unit_template")

local function _resolve_companion_inventory(breed, owner_unit, special_rule)
	local inventory = breed.inventory.default

	for ii = 1, #inventory do
		local loadout = inventory[ii]

		if loadout.availability_func(owner_unit, special_rule) then
			return loadout
		end
	end
end

local minion_companion_servo_skull_unit_template = {
	local_unit = function (unit_name, position, rotation, material, init_data, ...)
		local breed = init_data.breed

		unit_name = unit_name or breed.base_unit

		return unit_name, position, rotation, material
	end,
	husk_unit = UnitTemplate.breed_unit_name_position_rotation_from_game_object,
	game_object_type = function (init_data, ...)
		local breed = init_data.breed
		local breed_name = init_data.breed_name

		breed = breed or Breeds[breed_name]

		local game_object_type = breed.game_object_type

		return game_object_type
	end,
	local_init = function (unit, config, template_context, game_object_data, init_data, ...)
		local breed, side_id = init_data.breed, init_data.side_id
		local breed_name = breed.name

		breed = breed or Breeds[breed_name]

		local owner_unit = init_data.optional_owner_player_unit
		local owner_player = owner_unit and Managers.state.player_unit_spawn:owner(owner_unit)
		local random_seed = init_data.random_seed
		local next_seed, animation_seed, inventory_seed, buff_seed, movement_seed, _

		next_seed, animation_seed = math.random_seed(random_seed)
		next_seed, inventory_seed = math.random_seed(next_seed)
		next_seed, buff_seed = math.random_seed(next_seed)
		_, movement_seed = math.random_seed(next_seed)

		local behavior_tree_name = breed.behavior_tree_name
		local blackboard_component_config = breed.blackboard_component_config
		local behavior_extension_init_data = {
			breed = breed,
			behavior_tree_name = behavior_tree_name,
			owner_unit = init_data.optional_owner_player_unit,
		}

		config:add("BlackboardExtension", {
			component_config = blackboard_component_config,
		})
		config:add("CompanionBehaviorExtension", behavior_extension_init_data)

		if init_data.optional_companion_tag_extension then
			config:add("CompanionTagManagerServoSkullExtension", {
				breed = breed,
			})
		end

		config:add("MinionUnitDataExtension", {
			breed = breed,
		})
		config:add("SideExtension", {
			side_id = side_id,
			breed = breed,
		})
		config:add("MinionBuffExtension", {
			buff_seed = buff_seed,
			breed = breed,
		})
		config:add("MinionAnimationExtension", {
			breed = breed,
			random_seed = animation_seed,
		})
		config:add("MinionLocomotionExtension", {
			breed = breed,
		})
		config:add("MinionPerceptionExtension", {
			breed = breed,
		})
		config:add("MinionFxExtension", {
			breed = breed,
		})

		if breed.aim_config then
			config:add("MinionRangedAimExtension", {
				breed = breed,
			})
		end

		local special_rule = init_data.optional_special_rule
		local inventory = _resolve_companion_inventory(breed, owner_unit, special_rule)

		config:add("CompanionVisualLoadoutExtension", {
			breed = breed,
			owner_player = owner_player,
			random_seed = inventory_seed,
			inventory = inventory,
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

		if owner_player then
			Managers.state.player_unit_spawn:assign_unit_ownership(unit, owner_player)

			local owner_unit_companion_spawner_extension = ScriptUnit.has_extension(owner_unit, "companion_spawner_system")

			owner_unit_companion_spawner_extension:register_spawned_companion_unit(unit)
			config:add("FlyingCompanionMovementExtension", {
				breed = breed,
				random_seed = movement_seed,
			})
		end

		local owner_game_object_id = owner_unit and Managers.state.unit_spawner:game_object_id(owner_unit) or NetworkConstants.invalid_game_object_id

		game_object_data.owner_unit_id = owner_game_object_id
		game_object_data.side_id = side_id
		game_object_data.has_teleported = 1
		game_object_data.random_seed = random_seed
		game_object_data.companion_variant_special_rule_id = NetworkLookup.companion_variant_special_rules[special_rule]
		game_object_data.target_unit_id = NetworkConstants.invalid_game_object_id
	end,
	husk_init = function (unit, config, template_context, game_session, game_object_id, owner_id)
		local go_field = GameSession.game_object_field
		local side_id = go_field(game_session, game_object_id, "side_id")
		local breed_id = go_field(game_session, game_object_id, "breed_id")
		local random_seed = go_field(game_session, game_object_id, "random_seed")
		local companion_variant_special_rule_id = go_field(game_session, game_object_id, "companion_variant_special_rule_id")
		local breed_name = NetworkLookup.breed_names[breed_id]
		local breed = Breeds[breed_name]
		local owner_unit_id = go_field(game_session, game_object_id, "owner_unit_id")
		local owner_unit

		if owner_unit_id ~= NetworkConstants.invalid_game_object_id then
			owner_unit = Managers.state.unit_spawner:unit(owner_unit_id)
		end

		local owner_player = owner_unit and Managers.state.player_unit_spawn:owner(owner_unit)
		local next_seed, animation_seed, inventory_seed, buff_seed, movement_seed, _

		next_seed, animation_seed = math.random_seed(random_seed)
		next_seed, inventory_seed = math.random_seed(next_seed)
		next_seed, buff_seed = math.random_seed(next_seed)
		_, movement_seed = math.random_seed(next_seed)

		config:add("MinionUnitDataExtension", {
			breed = breed,
		})
		config:add("SideExtension", {
			side_id = side_id,
			breed = breed,
		})
		config:add("MinionBuffExtension", {
			buff_seed = buff_seed,
			breed = breed,
		})
		config:add("MinionAnimationExtension", {
			breed = breed,
			random_seed = animation_seed,
		})
		config:add("MinionHuskLocomotionExtension", {
			breed = breed,
		})
		config:add("MinionHuskNavigationExtension")
		config:add("MinionFxExtension", {
			breed = breed,
		})

		local companion_variant_special_rule = NetworkLookup.companion_variant_special_rules[companion_variant_special_rule_id]
		local inventory = _resolve_companion_inventory(breed, owner_unit, companion_variant_special_rule)

		if inventory then
			config:add("CompanionVisualLoadoutExtension", {
				breed = breed,
				owner_player = owner_player,
				random_seed = inventory_seed,
				inventory = inventory,
			})
		end

		config:add("FadeExtension")

		if breed.aim_config then
			config:add("MinionRangedHuskAimExtension", {
				breed = breed,
			})
		end

		if owner_player then
			Managers.state.player_unit_spawn:assign_unit_ownership(unit, owner_player)

			local owner_unit_companion_spawner_extension = ScriptUnit.has_extension(owner_unit, "companion_spawner_system")

			owner_unit_companion_spawner_extension:register_spawned_companion_unit(unit)
			config:add("FlyingCompanionHuskMovementExtension", {
				breed = breed,
				random_seed = movement_seed,
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

return minion_companion_servo_skull_unit_template
