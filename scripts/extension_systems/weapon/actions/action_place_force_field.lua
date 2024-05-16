﻿-- chunkname: @scripts/extension_systems/weapon/actions/action_place_force_field.lua

require("scripts/extension_systems/weapon/actions/action_place_base")

local BuffSettings = require("scripts/settings/buff/buff_settings")
local Vo = require("scripts/utilities/vo")
local proc_events = BuffSettings.proc_events
local ActionPlaceForceField = class("ActionPlaceForceField", "ActionPlaceBase")

ActionPlaceForceField._calculate_placement_data = function (self)
	local owner_unit = self._player_unit
	local position = POSITION_LOOKUP[owner_unit]
	local rotation = Unit.local_rotation(owner_unit, 1)
	local downward_raycast_position = position + Vector3.up()
	local _, _, _, _, actor = PhysicsWorld.raycast(self._physics_world, downward_raycast_position, Vector3.down(), 2, "closest", "types", "both", "collision_filter", "filter_player_place_deployable")
	local unit_hit

	if actor then
		unit_hit = Actor.unit(actor)
	end

	if unit_hit then
		local unit_spawner_manager = Managers.state.unit_spawner
		local game_object_id = unit_spawner_manager:game_object_id(unit_hit)
		local level_index = unit_spawner_manager:level_index(unit_hit)

		if not game_object_id and not level_index then
			unit_hit = nil
		end
	end

	return true, position, rotation, unit_hit
end

ActionPlaceForceField._place_unit = function (self, action_settings, position, rotation, placed_on_unit)
	local vo_tag = action_settings.vo_tag

	if vo_tag then
		Vo.play_combat_ability_event(self._player_unit, vo_tag)
	end

	local use_ability_charge = action_settings.use_ability_charge

	if use_ability_charge then
		self:_use_ability_charge()
	end

	local owner_unit = self._player_unit
	local unit_name = action_settings.functional_unit
	local husk_unit_name = action_settings.functional_unit
	local unit_template = "force_field"
	local material
	local unit = Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template, position, rotation, material, husk_unit_name, placed_on_unit, owner_unit)

	self._force_field_unit = unit
	self._placed_unit = true
	self._placed_position = Vector3Box(position)
	self._placed_rotation = QuaternionBox(rotation)
end

ActionPlaceForceField.finish = function (self, reason, data, t, time_in_action)
	ActionPlaceForceField.super.finish(self, reason, data, t, time_in_action)

	if self._placed_unit then
		local position = self._placed_position:unbox()
		local rotation = self._placed_rotation:unbox()
		local buff_extension = ScriptUnit.extension(self._player_unit, "buff_system")
		local param_table = buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.unit = self._player_unit
			param_table.position = Vector3Box(position)
			param_table.rotation = QuaternionBox(rotation)
			param_table.force_field_unit = self._force_field_unit

			buff_extension:add_proc_event(proc_events.on_combat_ability, param_table)
		end

		self._placed_unit = false
	end
end

return ActionPlaceForceField
