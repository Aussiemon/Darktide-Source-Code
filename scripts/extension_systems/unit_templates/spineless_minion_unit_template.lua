-- chunkname: @scripts/extension_systems/unit_templates/spineless_minion_unit_template.lua

local Breeds = require("scripts/settings/breed/breeds")
local NetworkLookup = require("scripts/network_lookup/network_lookup")
local UnitTemplate = require("scripts/extension_systems/unit_templates/utilities/unit_template")

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
	local position, rotation = UnitTemplate.position_rotation_from_game_object(session, object_id)
	local size_variation_range = breed.size_variation_range

	if size_variation_range then
		local random_seed = go_field(session, object_id, "random_seed")
		local pose = _size_variation_pose_from_breed(position, rotation, size_variation_range, random_seed)

		return unit_name, pose
	else
		return unit_name, position, rotation
	end
end

local function _broadphase_radius_and_categories(breed, side_id)
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

local spineless_minion_unit_template = {
	local_unit = function (unit_name, position, rotation, material, init_data, ...)
		local breed, random_seed = init_data.breed, init_data.random_seed

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
		local breed, side_id = init_data.breed, init_data.side_id
		local broadphase_radius, broadphase_categories = _broadphase_radius_and_categories(breed, side_id)
		local blackboard_component_config = breed.blackboard_component_config
		local breed_name, behavior_tree_name = breed.name, breed.behavior_tree_name
		local spawn_buffs = breed.spawn_buffs
		local random_seed = init_data.random_seed
		local game_object_type = breed.game_object_type
		local breed_id = NetworkLookup.breed_names[breed_name]
		local rotation = Unit.local_rotation(unit, 1)

		game_object_data.breed_id = breed_id
		game_object_data.position = Unit.local_position(unit, 1)

		if Network.object_has_field(game_object_type, "rotation") then
			game_object_data.rotation = rotation
		end

		local game_time = Managers.time:time("gameplay")

		game_object_data.spawn_time = game_time
		game_object_data.side_id = side_id
		game_object_data.has_teleported = 1
		game_object_data.random_seed = random_seed
		game_object_data.target_unit_id = NetworkConstants.invalid_game_object_id

		config:add("BlackboardExtension", {
			component_config = blackboard_component_config,
		})
		config:add("BroadphaseExtension", {
			moving = true,
			radius = broadphase_radius,
			categories = broadphase_categories,
		})
		config:add("MinionUnitDataExtension", {
			breed = breed,
		})
		config:add("MinionNavigationExtension", {
			breed = breed,
		})
		config:add("SideExtension", {
			side_id = side_id,
			breed = breed,
		})
		config:add("MinionLocomotionExtension", {
			breed = breed,
		})

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

		local behavior_extension_init_data = {
			selected_attack_names = nil,
			breed = breed,
			behavior_tree_name = behavior_tree_name,
		}

		config:add("MinionBehaviorExtension", behavior_extension_init_data)

		local optional_target_unit = init_data.optional_target_unit

		if breed.vortex_template then
			config:add("MinionVortexExtension", {
				breed = breed,
				target_unit = optional_target_unit,
				spawn_time = game_time,
			})
		end

		if breed.name == "nurgle_flies" then
			config:add("MinionNurgleFliesExtension", {
				breed = breed,
				target_unit = optional_target_unit,
				spawn_time = game_time,
			})
		end

		config:add("ComponentExtension")
		config:parse_unit(unit)
	end,
	husk_init = function (unit, config, template_context, game_session, game_object_id, owner_id)
		local go_field = GameSession.game_object_field
		local side_id = go_field(game_session, game_object_id, "side_id")
		local breed_id = go_field(game_session, game_object_id, "breed_id")
		local breed_name = NetworkLookup.breed_names[breed_id]
		local breed = Breeds[breed_name]
		local broadphase_radius, broadphase_categories = _broadphase_radius_and_categories(breed, side_id)

		config:add("BroadphaseExtension", {
			moving = true,
			radius = broadphase_radius,
			categories = broadphase_categories,
		})
		config:add("MinionUnitDataExtension", {
			breed = breed,
		})
		config:add("SideExtension", {
			side_id = side_id,
			breed = breed,
		})
		config:add("MinionHuskLocomotionExtension", {
			breed = breed,
		})
		config:add("MinionHuskNavigationExtension")

		local has_health_bar = breed.has_health_bar

		config:add("HuskHealthExtension", {
			has_health_bar = has_health_bar,
		})

		local spawn_time = go_field(game_session, game_object_id, "spawn_time")

		if breed.vortex_template then
			config:add("MinionVortexExtension", {
				breed = breed,
				spawn_time = spawn_time,
			})
		end

		if breed.name == "nurgle_flies" then
			config:add("MinionNurgleFliesExtension", {
				breed = breed,
				spawn_time = spawn_time,
			})
		end

		config:add("ComponentExtension")
		config:parse_unit(unit)
	end,
}

return spineless_minion_unit_template
