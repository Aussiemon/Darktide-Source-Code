local HazardProp = component("HazardProp")

HazardProp.init = function (self, unit, is_server)
	self._is_server = is_server
	local hazard_prop_extension = ScriptUnit.fetch_component_extension(unit, "hazard_prop_system")

	if hazard_prop_extension then
		local hazard_shape = self:get_data(unit, "hazard_shape")

		hazard_prop_extension:setup_from_component(hazard_shape)

		self._hazard_prop_extension = hazard_prop_extension
	end
end

HazardProp.editor_init = function (self, unit)
	return
end

HazardProp.enable = function (self, unit)
	return
end

HazardProp.disable = function (self, unit)
	return
end

HazardProp.destroy = function (self, unit)
	return
end

HazardProp.events.add_damage = function (self, damage_amount, hit_actor, attack_direction)
	local hazard_prop_extension = self._hazard_prop_extension

	if self._is_server and hazard_prop_extension then
		hazard_prop_extension:damage(damage_amount, hit_actor, attack_direction)
	end
end

HazardProp.component_data = {
	extensions = {
		"HazardPropExtension"
	},
	hazard_shape = {
		value = "barrel",
		ui_type = "combo_box",
		ui_name = "Collider Setup",
		options_keys = {
			"barrel/canister/pipe",
			"sphere"
		},
		options_values = {
			"barrel",
			"sphere"
		}
	}
}

return HazardProp
