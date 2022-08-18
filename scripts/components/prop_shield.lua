local PropShield = component("PropShield")

PropShield.init = function (self, unit)
	self._unit = unit
	local pickup_spawner_extension = ScriptUnit.fetch_component_extension(unit, "shield_system")

	if pickup_spawner_extension then
		local actor_names = self:get_data(unit, "actor_names")

		pickup_spawner_extension:setup_from_component(actor_names)
	end
end

PropShield.editor_init = function (self, unit)
	return
end

PropShield.enable = function (self, unit)
	return
end

PropShield.disable = function (self, unit)
	return
end

PropShield.destroy = function (self, unit)
	return
end

PropShield.component_data = {
	actor_names = {
		ui_type = "text_box_array",
		size = 0,
		ui_name = "Shield Actors",
		values = {}
	},
	extensions = {
		"PropShieldExtension"
	}
}

return PropShield
