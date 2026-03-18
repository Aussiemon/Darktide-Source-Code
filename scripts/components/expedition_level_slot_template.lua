-- chunkname: @scripts/components/expedition_level_slot_template.lua

local ExpeditionLevelSlotTemplate = component("ExpeditionLevelSlotTemplate")

ExpeditionLevelSlotTemplate.init = function (self, unit)
	return
end

ExpeditionLevelSlotTemplate.editor_init = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	self._unit = unit
	self._world = Unit.world(unit)
	self._gizmo_visible = false

	local level_size = self:get_data(unit, "level_size")
	local node_index = Unit.node(unit, "ap_preview_gizmos")
	local size = tonumber(string.sub(level_size, -2)) * 0.5
	local extents = Vector3(size, size, 1)

	Unit.set_local_scale(unit, node_index, extents)
	Unit.set_vector4_for_material(unit, "gizmo_bounds", "color", Color(1, 1, 0, 0.4))
end

ExpeditionLevelSlotTemplate.enable = function (self, unit)
	return
end

ExpeditionLevelSlotTemplate.disable = function (self, unit)
	return
end

ExpeditionLevelSlotTemplate.destroy = function (self, unit)
	return
end

ExpeditionLevelSlotTemplate.editor_destroy = function (self, unit)
	return
end

ExpeditionLevelSlotTemplate.editor_validate = function (self, unit)
	return true, ""
end

ExpeditionLevelSlotTemplate.update = function (self, unit, dt, t)
	return
end

ExpeditionLevelSlotTemplate.editor_update = function (self, unit, dt, t)
	return
end

ExpeditionLevelSlotTemplate.changed = function (self, unit)
	return
end

ExpeditionLevelSlotTemplate.editor_changed = function (self, unit)
	return
end

ExpeditionLevelSlotTemplate.editor_world_transform_modified = function (self, unit)
	return
end

ExpeditionLevelSlotTemplate.editor_selection_changed = function (self, unit, selected)
	return
end

ExpeditionLevelSlotTemplate.editor_reset_physics = function (self, unit)
	return
end

ExpeditionLevelSlotTemplate.editor_property_changed = function (self, unit)
	return
end

ExpeditionLevelSlotTemplate.editor_on_mission_changed = function (self, unit)
	return
end

ExpeditionLevelSlotTemplate.editor_on_level_spawned = function (self, unit)
	return
end

ExpeditionLevelSlotTemplate.editor_toggle_debug_draw = function (self, enable)
	self._should_debug_draw = enable
end

ExpeditionLevelSlotTemplate.editor_toggle_visibility_state = function (self, visible)
	return
end

ExpeditionLevelSlotTemplate.editor_toggle_gizmo_visibility_state = function (self, visible)
	self._gizmo_visible = visible
end

ExpeditionLevelSlotTemplate.component_data = {
	level_size = {
		ui_name = "Level Size",
		ui_type = "combo_box",
		value = "level_size_32",
		options_keys = {
			"16",
			"32",
			"48",
			"64",
		},
		options_values = {
			"level_size_16",
			"level_size_32",
			"level_size_48",
			"level_size_64",
		},
	},
}

return ExpeditionLevelSlotTemplate
