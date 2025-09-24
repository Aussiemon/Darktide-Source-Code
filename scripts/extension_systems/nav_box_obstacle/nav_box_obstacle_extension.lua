-- chunkname: @scripts/extension_systems/nav_box_obstacle/nav_box_obstacle_extension.lua

local NavBoxObstacleExtension = class("NavBoxObstacleExtension")

NavBoxObstacleExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._is_server = extension_init_context.is_server
	self._layer_names = {}
	self._world = extension_init_context.nav_world
	self._nav_world = extension_init_context.nav_world
end

NavBoxObstacleExtension.destroy = function (self)
	if self._box_obstacle then
		GwNavBoxObstacle.set_does_trigger_tagvolume(self._box_obstacle, false)
		GwNavBoxObstacle.remove_from_world(self._box_obstacle)
		GwNavBoxObstacle.destroy(self._box_obstacle)
	end

	if self._nav_cost_volume_id then
		local cost_map_id = Managers.state.nav_mesh:nav_cost_map_id("obstacle")

		Managers.state.nav_mesh:remove_nav_cost_map_volume(self._nav_cost_volume_id, cost_map_id)
	end
end

NavBoxObstacleExtension.setup_from_component = function (self, unit, box_center, box_extants, is_static, fake_with_cost)
	if fake_with_cost then
		self:_setup_nav_cost(unit, box_center:unbox(), box_extants:unbox())

		return
	end

	if is_static then
		ferror("[NavBoxObstacleExtension] cannot use a static obstacle at this time, use the fake cost instead")
		self:_setup_static_from_component(unit, box_center:unbox(), box_extants:unbox())

		return
	end

	ferror("[NavBoxObstacleExtension] dynamic obstacle not supported, use the fake cost instead")
	self:_setup_dynamic_from_component(unit, box_center:unbox(), box_extants:unbox())
end

NavBoxObstacleExtension._setup_static_from_component = function (self, unit, box_center, box_extants)
	local unit_xform = Unit.world_pose(unit, 1)
	local position = Matrix4x4.translation(unit_xform)

	Log.info("[NavBoxObstacleExtension]", "[Unit: %s] spawning static box obstacle at %s with extants %s", Unit.id_string(unit), Vector3.to_string(Matrix4x4.translation(unit_xform)), Vector3.to_string(box_extants))

	self._box_obstacle = GwNavBoxObstacle.create_exclusive(self._nav_world, position, box_center, box_extants)

	GwNavBoxObstacle.set_transform(self._box_obstacle, unit_xform)
	GwNavBoxObstacle.set_does_trigger_tagvolume(self._box_obstacle, true)
	GwNavBoxObstacle.add_to_world(self._box_obstacle)
end

NavBoxObstacleExtension._setup_dynamic_from_component = function (self, unit, box_center, box_extants)
	local unit_xform = Unit.world_pose(unit, 1)
	local position = Matrix4x4.translation(unit_xform)

	Log.info("[NavBoxObstacleExtension]", "[Unit: %s] spawning dynamic box obstacle at %s with extants %s", Unit.id_string(unit), Vector3.to_string(Matrix4x4.translation(unit_xform)), Vector3.to_string(box_extants))

	self._box_obstacle = GwNavBoxObstacle.create(self._nav_world, position, box_center, box_extants, false, Color.red(), 1, nil, nil)

	GwNavBoxObstacle.set_transform(self._box_obstacle, unit_xform)
	GwNavBoxObstacle.add_to_world(self._box_obstacle)
end

NavBoxObstacleExtension._setup_nav_cost = function (self, unit, box_center, box_extants)
	local transform = Unit.world_pose(unit, 1)
	local cost_multiplier = 200
	local cost_map_id = Managers.state.nav_mesh:nav_cost_map_id("obstacle")

	self._nav_cost_volume_id = Managers.state.nav_mesh:add_nav_cost_map_box_volume(transform, box_extants, cost_multiplier, cost_map_id)
end

return NavBoxObstacleExtension
