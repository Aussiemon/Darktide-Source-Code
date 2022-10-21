local MasterItems = require("scripts/backend/master_items")

local function weapon_template_tests(weapon_templates)
	local item_definitions = MasterItems.get_cached()

	for item_name, item in pairs(item_definitions) do
		local weapon_template_name = item.weapon_template

		if type(weapon_template_name) ~= "string" or weapon_template_name == "" then
			weapon_template_name = false
		end

		local workflow_state = item.workflow_state
		local testable = workflow_state == "FUNCTIONAL" or workflow_state == "SHIPPABLE" or workflow_state == "RELEASABLE"
		local unstable = workflow_state == "PROTOTYPE"
		local wip = workflow_state == "BLOCKOUT"

		if weapon_template_name then
			local weapon_template = weapon_templates[weapon_template_name]

			if not weapon_template and not testable then
				if unstable then
					-- Nothing
				elseif wip then
					Log.error("WeaponTemplateTests", "Weapon template %q defined for item %q with workflow state %q does not exist.", weapon_template_name, item_name, workflow_state)
				end
			end
		end
	end
end

return weapon_template_tests
