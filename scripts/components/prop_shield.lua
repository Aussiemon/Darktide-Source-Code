-- chunkname: @scripts/components/prop_shield.lua

local PropShield = component("PropShield")

PropShield.init = function (self, unit)
	self._unit = unit

	local shield_extension = ScriptUnit.fetch_component_extension(unit, "shield_system")

	if shield_extension then
		local actor_names = self:get_data(unit, "actor_names")

		shield_extension:setup_from_component(actor_names)
	end
end

PropShield.editor_init = function (self, unit)
	return
end

PropShield.editor_validate = function (self, unit)
	return true, ""
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
		size = 0,
		ui_name = "Shield Actors",
		ui_type = "text_box_array",
		values = {},
	},
	extensions = {
		"PropShieldExtension",
	},
}

return PropShield
