require("scripts/extension_systems/weapon/actions/action_place")

local ActionPlaceForceField = class("ActionPlaceForceField", "ActionPlace")

ActionPlaceForceField._place_unit = function (self, action_settings)
	local action_component = self._action_component
	local owner_unit = self._player_unit
	local self_cast = action_settings.self_cast
	local position, rotation, placed_on_unit = nil

	if self_cast then
		position = POSITION_LOOKUP[owner_unit]
		rotation = Unit.local_rotation(owner_unit, 1)
		local downward_raycast_position = position + Vector3.up()
		local _, hit_position, _, _, actor = PhysicsWorld.raycast(self._physics_world, downward_raycast_position, Vector3.down(), 2, "closest", "types", "both", "collision_filter", "filter_player_place_deployable")
		local unit_hit = nil

		if actor then
			unit_hit = Actor.unit(actor)
		end

		placed_on_unit = unit_hit
	else
		position = action_component.position
		rotation = action_component.rotation
		placed_on_unit = action_component.placed_on_unit
	end

	local unit_name = action_settings.functional_unit
	local husk_unit_name = action_settings.functional_unit
	local unit_template = "force_field"
	local material = nil

	Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template, position, rotation, material, husk_unit_name, placed_on_unit, owner_unit)
end

return ActionPlaceForceField
