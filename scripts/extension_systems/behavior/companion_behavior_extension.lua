-- chunkname: @scripts/extension_systems/behavior/companion_behavior_extension.lua

local AiBrain = require("scripts/extension_systems/behavior/ai_brain")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local CompanionBehaviorExtension = class("CompanionBehaviorExtension")

CompanionBehaviorExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	self._unit = unit
	self._nav_world = extension_init_context.nav_world
	self._player = extension_init_data.player

	local blackboard, world, physics_world = BLACKBOARDS[unit], extension_init_context.world, extension_init_context.physics_world
	local breed = extension_init_data.breed

	self._breed = breed
	self._blackboard = blackboard

	local game_session = Managers.state.game_session:game_session()
	local selected_attack_names_or_nil = extension_init_data.selected_attack_names
	local owner_unit_or_nil = extension_init_data.owner_unit
	local group_target = extension_init_data.group_target
	local owning_auto_event_id = extension_init_data.owning_auto_event_id

	self:_init_blackboard_components(blackboard, breed, unit, world, physics_world, game_session, selected_attack_names_or_nil, owner_unit_or_nil, group_target, owning_auto_event_id)

	local b_tree_name = extension_init_data.behavior_tree_name

	self:_init_brain(unit, breed, blackboard, b_tree_name)
end

CompanionBehaviorExtension._init_brain = function (self, unit, breed, blackboard, behavior_tree_name)
	local behavior_system = Managers.state.extension:system("behavior_system")
	local behavior_tree = behavior_system:behavior_tree(behavior_tree_name)

	self._brain = AiBrain:new(unit, breed, blackboard, behavior_tree, self)
end

CompanionBehaviorExtension.behavior_state_event = function (self, state_name)
	self._brain:state_event(state_name)
end

CompanionBehaviorExtension._init_blackboard_components = function (self, blackboard, breed, unit, world, physics_world, game_session, optional_selected_attack_names, optional_owner_unit, group_target, owning_auto_event_id)
	local spawn_component = Blackboard.write_component(blackboard, "spawn")

	spawn_component.unit = unit
	spawn_component.world = world
	spawn_component.physics_world = physics_world
	spawn_component.game_session = game_session
	spawn_component.game_object_id = -math.huge
	spawn_component.is_exiting_spawner = false
	spawn_component.spawner_unit = nil
	spawn_component.spawner_spawn_index = -1
	spawn_component.anim_translation_scale_factor = 1
	spawn_component.spawn_source = "default"

	if Blackboard.has_component(blackboard, "group_data") then
		local group_data_component = Blackboard.write_component(blackboard, "group_data")

		group_data_component.group_target = group_target
		group_data_component.owning_auto_event_id = owning_auto_event_id or ""
	end

	if Blackboard.has_component(blackboard, "weapon_malfunction") then
		local weapon_malfunction_component = Blackboard.write_component(blackboard, "weapon_malfunction")

		weapon_malfunction_component.is_malfunctioning = false
		weapon_malfunction_component.refresh_malfunctioning_time = false
		weapon_malfunction_component.malfunctioning_time = 0
		weapon_malfunction_component.malfunction_buff_id = -1
	end

	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	behavior_component.move_state = ""
	behavior_component.is_out_of_bound = false

	if optional_owner_unit then
		behavior_component.owner_unit = optional_owner_unit
	end
end

CompanionBehaviorExtension.game_object_initialized = function (self, game_session, game_object_id)
	local blackboard = self._blackboard
	local spawn_component = Blackboard.write_component(blackboard, "spawn")

	spawn_component.game_object_id = game_object_id
end

CompanionBehaviorExtension.destroy = function (self)
	local time_manager = Managers.time
	local t = time_manager:time("gameplay")

	self._brain:destroy(t)
end

CompanionBehaviorExtension.extensions_ready = function (self, world, unit)
	return
end

CompanionBehaviorExtension.update = function (self, unit, dt, t, ...)
	self._brain:update(unit, dt, t)
end

CompanionBehaviorExtension.brain = function (self)
	return self._brain
end

CompanionBehaviorExtension.running_action = function (self)
	return self._brain:running_action()
end

return CompanionBehaviorExtension
