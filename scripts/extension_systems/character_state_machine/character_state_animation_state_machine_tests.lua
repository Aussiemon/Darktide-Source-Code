local MasterItems = require("scripts/backend/master_items")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")
local REQUIRED_EVENTS = {
	"slide_in",
	"slide_out",
	"dodge_bwd",
	"dodge_right",
	"dodge_left",
	"dodge_end"
}
local VARIABLE_BOUNDS = {
	attack_speed = {
		min = NetworkConstants.action_time_scale.min,
		max = NetworkConstants.action_time_scale.max
	}
}

local function _init_and_run_tests(unit_1p, breed_name, world)
	local item_definitions = MasterItems.get_cached()

	for item_name, item in pairs(item_definitions) do
		local breeds = item.breeds
		local weapon_template_name = item.weapon_template

		if type(weapon_template_name) ~= "string" or weapon_template_name == "" then
			weapon_template_name = false
		end

		local workflow_state = item.workflow_state
		local testable = workflow_state == "FUNCTIONAL" or workflow_state == "SHIPPABLE" or workflow_state == "RELEASABLE"
		local unstable = workflow_state == "PROTOTYPE"
		local valid_breed = breeds and table.contains(breeds, breed_name)

		if weapon_template_name and (testable or unstable) and valid_breed then
			local weapon_template = WeaponTemplates[weapon_template_name]
			local _, state_machine_1p = WeaponTemplate.state_machines(weapon_template, breed_name)

			Unit.set_animation_state_machine(unit_1p, state_machine_1p)

			local has_events_error = false
			local error_events = ""

			for ii = 1, #REQUIRED_EVENTS do
				if not Unit.has_animation_event(unit_1p, REQUIRED_EVENTS[ii]) then
					has_events_error = true
					error_events = error_events .. "\n" .. REQUIRED_EVENTS[ii]
				end
			end

			local has_bounds_error = false
			local error_bounds = ""

			if Unit.animation_get_variable_min_max then
				for variable_name, bounds in pairs(VARIABLE_BOUNDS) do
					local variable_index = Unit.animation_find_variable(unit_1p, variable_name)

					if variable_index then
						local state_machine_min, state_machine_max = Unit.animation_get_variable_min_max(unit_1p, variable_index)
						local min = bounds.min
						local max = bounds.max

						if min < state_machine_min then
							has_bounds_error = true
							error_bounds = string.format("%s\n%s", error_bounds, string.format("%q %f is higher than required lower value of %f", variable_name, state_machine_min, min))
						end

						if state_machine_max < max then
							has_bounds_error = true
							error_bounds = string.format("%s\n%s", error_bounds, string.format("%q %f is lower than required upper value of %f", variable_name, state_machine_max, max))
						end
					end
				end
			end

			if has_bounds_error then
				Log.debug("CharacterStateAnimationStateMachineTests", "Variable bounds validation failed for %q%s", state_machine_1p, error_bounds)
			end
		end
	end
end

return _init_and_run_tests
