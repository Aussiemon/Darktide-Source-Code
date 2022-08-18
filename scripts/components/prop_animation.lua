local PropAnimation = component("PropAnimation")

PropAnimation.init = function (self, unit)
	local animation_extension = ScriptUnit.fetch_component_extension(unit, "animation_system")

	if animation_extension then
		local animation_variables = self:get_data(unit, "animation_variables")
		local state_machine_override = self:get_data(unit, "state_machine_override")

		animation_extension:setup_from_component(animation_variables, state_machine_override)
	end
end

PropAnimation.editor_init = function (self, unit)
	self:enable(unit)
end

PropAnimation.enable = function (self, unit)
	return
end

PropAnimation.disable = function (self, unit)
	return
end

PropAnimation.destroy = function (self, unit)
	return
end

PropAnimation.component_data = {
	state_machine_override = {
		ui_type = "resource",
		preview = false,
		value = "",
		ui_name = "State Machine Override",
		filter = "state_machine"
	},
	animation_variables = {
		ui_type = "text_box_array",
		size = 0,
		ui_name = "Animation Variables",
		category = "Animation Variables"
	},
	extensions = {
		"PropAnimationExtension"
	}
}

return PropAnimation
