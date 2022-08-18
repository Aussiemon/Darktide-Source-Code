local WeaponIconAlignment = component("WeaponIconAlignment")

WeaponIconAlignment.init = function (self, unit)
	return
end

WeaponIconAlignment.editor_init = function (self, unit)
	local in_editor = true
	local world = Unit.world(unit)
	self._item_definitions = self:_get_item_definitions(unit, world, in_editor)
end

WeaponIconAlignment.enable = function (self, unit)
	return
end

WeaponIconAlignment.get_item_definitions = function (self, unit)
	local item_definitions = {}

	if EditorMasterItems then
		EditorMasterItems.memoize(LocalLoader.get_items_from_metadata_db):next(function (data)
			self:enable(unit, data)
		end)
	else
		Log.error("WeaponIconAlignment", "EditorMasterItems not defined, missing master_items plugin?")
	end

	return item_definitions
end

WeaponIconAlignment.disable = function (self, unit)
	return
end

WeaponIconAlignment.destroy = function (self, unit)
	return
end

WeaponIconAlignment.update = function (self, unit, dt, t)
	return
end

WeaponIconAlignment.editor_update = function (self, unit, dt, t)
	return
end

WeaponIconAlignment.changed = function (self, unit)
	return
end

WeaponIconAlignment.editor_changed = function (self, unit)
	return
end

WeaponIconAlignment.editor_world_transform_modified = function (self, unit)
	return
end

WeaponIconAlignment.editor_selection_changed = function (self, unit, selected)
	return
end

WeaponIconAlignment.editor_reset_physics = function (self, unit)
	return
end

WeaponIconAlignment.editor_property_changed = function (self, unit)
	return
end

WeaponIconAlignment.editor_on_level_spawned = function (self, unit, level)
	return
end

WeaponIconAlignment.editor_on_set_debug_draw = function (self, enabled)
	return
end

WeaponIconAlignment.component_data = {}

return WeaponIconAlignment
