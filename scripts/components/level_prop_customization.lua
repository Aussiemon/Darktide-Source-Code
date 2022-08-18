local LevelPropCustomization = component("LevelPropCustomization")

LevelPropCustomization.init = function (self, unit)
	self:enable(unit)

	self._unit = unit
	self._world = Unit.world(self._unit)
	self._child_units = {}

	self:_spawn_children()
end

LevelPropCustomization.get_navgen_units = function (self)
	return self._child_units
end

LevelPropCustomization.editor_world_transform_modified = function (self, unit)
	self:_unspawn_children()
	self:_spawn_children()
end

LevelPropCustomization.destroy = function (self, unit)
	self:_unspawn_children()
end

LevelPropCustomization._spawn_children = function (self)
	local unit = self._unit
	local children_unit_spawn_info = self:get_data(unit, "children_units")

	for _, child_unit_spawn_info in ipairs(children_unit_spawn_info) do
		local child_unit_name = child_unit_spawn_info.child_unit

		if child_unit_name ~= "" then
			local parent_node_name = child_unit_spawn_info.parent_node_name
			local parent_node = 1

			if parent_node_name and Unit.has_node(unit, parent_node_name) then
				parent_node = Unit.node(unit, parent_node_name)
			end

			local parent_pose = Unit.world_pose(unit, parent_node)
			local child_pose = Matrix4x4.identity()
			local child_scale = child_unit_spawn_info.child_scale:unbox()

			Matrix4x4.set_scale(child_pose, child_scale)

			local full_pose = Matrix4x4.multiply(child_pose, parent_pose)
			local world = self._world
			local child_unit = nil

			if child_unit_spawn_info.is_static then
				child_unit = World.spawn_unit_ex(world, child_unit_name, nil, full_pose, nil, true)
			else
				child_unit = World.spawn_unit_ex(world, child_unit_name, nil, full_pose)

				self:_destroy_actors(child_unit)
				World.link_unit(world, child_unit, 1, unit, parent_node)
				Unit.set_local_scale(child_unit, 1, child_scale)
			end

			if not child_unit_spawn_info.cast_shadows then
				Unit.set_unit_objects_visibility(child_unit, false, false, VisibilityContexts.SHADOW_CASTER_CONTEXT)
			end

			fassert(child_unit, "[LevelPropCustomization] Could not spawn child unit.")
			table.insert(self._child_units, child_unit)
		end
	end
end

LevelPropCustomization._destroy_actors = function (self, unit)
	for ii = 1, Unit.num_actors(unit), 1 do
		Unit.destroy_actor(unit, ii)
	end
end

LevelPropCustomization._unspawn_children = function (self)
	for _, child_unit in ipairs(self._child_units) do
		local world = self._world

		World.unlink_unit(world, child_unit)
		World.destroy_unit(world, child_unit)
	end

	table.clear(self._child_units)
end

LevelPropCustomization.enable = function (self, unit)
	return
end

LevelPropCustomization.disable = function (self, unit)
	return
end

LevelPropCustomization.editor_property_changed = function (self, unit)
	self:_unspawn_children()
	self:_spawn_children()
end

LevelPropCustomization.component_data = {
	children_units = {
		ui_type = "struct_array",
		ui_name = "Linked Units",
		definition = {
			parent_node_name = {
				ui_type = "text_box",
				value = "",
				ui_name = "Node Name",
				category = "Parent"
			},
			child_unit = {
				ui_type = "resource",
				preview = true,
				category = "Child",
				value = "",
				ui_name = "Unit",
				filter = "unit"
			},
			child_scale = {
				ui_type = "vector",
				category = "Child",
				ui_name = "Scale",
				step = 0.1,
				value = Vector3Box(1, 1, 1)
			},
			is_static = {
				ui_type = "check_box",
				value = true,
				ui_name = "Static",
				category = "Child"
			},
			cast_shadows = {
				ui_type = "check_box",
				value = true,
				ui_name = "Cast Shadows",
				category = "Child"
			}
		},
		control_order = {
			"parent_node_name",
			"child_unit",
			"child_scale",
			"is_static",
			"cast_shadows"
		}
	}
}

return LevelPropCustomization
