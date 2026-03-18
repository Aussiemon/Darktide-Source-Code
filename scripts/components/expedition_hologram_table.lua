-- chunkname: @scripts/components/expedition_hologram_table.lua

local ExpeditionHologramTable = component("ExpeditionHologramTable")

ExpeditionHologramTable.init = function (self, unit)
	Unit.set_material_layer(unit, "hologram_wave_02", true)
	Unit.set_material_layer(unit, "hologram_wave_03", true)
	Unit.set_material_layer(unit, "hologram_wave_04", true)
end

ExpeditionHologramTable.editor_init = function (self, unit)
	self:init(unit)
end

ExpeditionHologramTable.enable = function (self, unit)
	return
end

ExpeditionHologramTable.disable = function (self, unit)
	return
end

ExpeditionHologramTable.destroy = function (self, unit)
	return
end

ExpeditionHologramTable.editor_validate = function (self, unit)
	return true, ""
end

ExpeditionHologramTable.update = function (self, unit, dt, t)
	return
end

ExpeditionHologramTable.editor_update = function (self, unit, dt, t)
	return
end

ExpeditionHologramTable.changed = function (self, unit)
	return
end

ExpeditionHologramTable.editor_changed = function (self, unit)
	return
end

ExpeditionHologramTable.editor_world_transform_modified = function (self, unit)
	return
end

ExpeditionHologramTable.editor_selection_changed = function (self, unit, selected)
	return
end

ExpeditionHologramTable.editor_reset_physics = function (self, unit)
	return
end

ExpeditionHologramTable.editor_property_changed = function (self, unit)
	return
end

ExpeditionHologramTable.editor_on_mission_changed = function (self, unit)
	return
end

ExpeditionHologramTable.editor_on_level_spawned = function (self, unit)
	return
end

ExpeditionHologramTable.editor_toggle_debug_draw = function (self, enable)
	return
end

ExpeditionHologramTable.editor_toggle_visibility_state = function (self, visible)
	return
end

ExpeditionHologramTable.editor_toggle_gizmo_visibility_state = function (self, visible)
	return
end

ExpeditionHologramTable.component_data = {
	inputs = {},
	extensions = {},
}

return ExpeditionHologramTable
