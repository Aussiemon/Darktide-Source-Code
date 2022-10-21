local AiBrain = require("scripts/extension_systems/behavior/ai_brain")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionBehaviorExtension = class("MinionBehaviorExtension")

MinionBehaviorExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	local blackboard = BLACKBOARDS[unit]
	self._blackboard = blackboard
	self._unit = unit
	local breed = extension_init_data.breed
	self._breed = breed
	self._nearby_units_broadphase_config = breed.nearby_units_broadphase_config
	local game_session = Managers.state.game_session:game_session()
	local world = extension_init_context.world
	local physics_world = extension_init_context.physics_world
	local selected_attack_names_or_nil = extension_init_data.selected_attack_names

	self:_init_blackboard_components(blackboard, breed, unit, world, physics_world, game_session, selected_attack_names_or_nil)

	local behavior_tree_name = extension_init_data.behavior_tree_name

	self:_init_brain(unit, breed, blackboard, behavior_tree_name)
end

MinionBehaviorExtension._init_brain = function (self, unit, breed, blackboard, behavior_tree_name)
	local behavior_system = Managers.state.extension:system("behavior_system")
	local behavior_tree = behavior_system:behavior_tree(behavior_tree_name)
	self._brain = AiBrain:new(unit, breed, blackboard, behavior_tree)
end

MinionBehaviorExtension.override_brain = function (self, behavior_tree_name, t)
	self._brain:shutdown_behavior_tree(t, false)
	self:_init_brain(self._unit, self._breed, self._blackboard, behavior_tree_name)
end

MinionBehaviorExtension._init_blackboard_components = function (self, blackboard, breed, unit, world, physics_world, game_session, optional_selected_attack_names)
	local spawn_component = Blackboard.write_component(blackboard, "spawn")
	spawn_component.unit = unit
	spawn_component.world = world
	spawn_component.physics_world = physics_world
	spawn_component.game_session = game_session
	spawn_component.game_object_id = -math.huge
	spawn_component.is_exiting_spawner = false
	spawn_component.spawner_unit = nil
	spawn_component.anim_translation_scale_factor = 1
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	behavior_component.move_state = ""
	local component_config = Blackboard.component_config(blackboard)
	local available_attacks_fields = component_config.available_attacks

	if available_attacks_fields then
		local available_attacks_component = Blackboard.write_component(blackboard, "available_attacks")

		for field_name, _ in pairs(available_attacks_fields) do
			local is_available = optional_selected_attack_names[field_name] or false
			available_attacks_component[field_name] = is_available
		end
	end

	local nearby_units_broadphase_config = self._nearby_units_broadphase_config

	if nearby_units_broadphase_config then
		local nearby_units_broadphase_component = Blackboard.write_component(blackboard, "nearby_units_broadphase")
		nearby_units_broadphase_component.num_units = 0
		nearby_units_broadphase_component.next_broadphase_t = 0
		self._nearby_units_broadphase_component = nearby_units_broadphase_component
	end
end

MinionBehaviorExtension.game_object_initialized = function (self, game_session, game_object_id)
	local blackboard = self._blackboard
	local spawn_component = Blackboard.write_component(blackboard, "spawn")
	spawn_component.game_object_id = game_object_id
end

MinionBehaviorExtension.destroy = function (self)
	local time_manager = Managers.time
	local t = time_manager:time("gameplay")

	self._brain:destroy(t)
end

local BROADPHASE_RESULTS = {}
local FULL_FOV = math.degrees_to_radians(360)

MinionBehaviorExtension.update_nearby_units_broadphase = function (self, unit, blackboard, dt, t)
	local nearby_units_broadphase_component = self._nearby_units_broadphase_component
	local next_broadphase_t = nearby_units_broadphase_component.next_broadphase_t

	if t < next_broadphase_t then
		return
	end

	local broadphase_config = self._nearby_units_broadphase_config
	local interval = broadphase_config.interval
	nearby_units_broadphase_component.next_broadphase_t = t + interval
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local relation = broadphase_config.relation
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]
	local target_side_names = side:relation_side_names(relation)
	local from = POSITION_LOOKUP[unit]
	local angle = broadphase_config.angle
	local radius = broadphase_config.radius
	local num_results = broadphase:query(from, radius, BROADPHASE_RESULTS, target_side_names)

	if angle and angle < FULL_FOV then
		local num_units = 0
		local rotation = Unit.world_rotation(unit, 1)
		local forward = Quaternion.forward(rotation)

		for i = 1, num_results do
			local hit_unit = BROADPHASE_RESULTS[i]

			if hit_unit ~= unit then
				local to = POSITION_LOOKUP[hit_unit]
				local direction = Vector3.normalize(to - from)
				local length_sq = Vector3.length_squared(direction)

				if length_sq ~= 0 then
					local angle_to_target = Vector3.angle(direction, forward)

					if angle_to_target < angle then
						num_units = num_units + 1
					end
				end
			end
		end

		nearby_units_broadphase_component.num_units = num_units
	else
		nearby_units_broadphase_component.num_units = num_results
	end
end

MinionBehaviorExtension.update = function (self, unit, dt, t, ...)
	local brain = self._brain

	if brain:active() then
		brain:update(unit, dt, t)
	end
end

MinionBehaviorExtension.brain = function (self)
	return self._brain
end

MinionBehaviorExtension.running_action = function (self)
	return self._brain:running_action()
end

return MinionBehaviorExtension
