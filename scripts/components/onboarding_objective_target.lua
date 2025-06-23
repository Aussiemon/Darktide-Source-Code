-- chunkname: @scripts/components/onboarding_objective_target.lua

local OnboardingObjectiveTarget = component("OnboardingObjectiveTarget")

OnboardingObjectiveTarget.init = function (self, unit)
	self._unit = unit

	self:enable(unit)
end

OnboardingObjectiveTarget.editor_validate = function (self, unit)
	return true, ""
end

OnboardingObjectiveTarget.enable = function (self, unit)
	return
end

OnboardingObjectiveTarget.disable = function (self, unit)
	return
end

OnboardingObjectiveTarget.destroy = function (self, unit)
	return
end

OnboardingObjectiveTarget.is_primary_marker = function (self)
	return self:get_data(self._unit, "primary_marker")
end

OnboardingObjectiveTarget.component_data = {
	primary_marker = {
		ui_type = "check_box",
		value = false,
		ui_name = "Primary Marker"
	},
	extensions = {}
}

return OnboardingObjectiveTarget
