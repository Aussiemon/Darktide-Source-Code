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

			local has_error = false
			local error_string = ""

			for i = 1, #REQUIRED_EVENTS do
				if not Unit.has_animation_event(unit_1p, REQUIRED_EVENTS[i]) then
					has_error = true
					error_string = error_string .. "\n" .. REQUIRED_EVENTS[i]
				end
			end

			fassert(not has_error, "Missing the following events %s\nin %q", error_string, state_machine_1p)
		end
	end
end

return _init_and_run_tests
