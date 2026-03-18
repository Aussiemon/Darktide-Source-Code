-- chunkname: @scripts/settings/equipment/tests/weapon_item_tests.lua

local MasterItems = require("scripts/backend/master_items")
local UiSettings = require("scripts/settings/ui/ui_settings")
local ui_weapon_patterns_settings = UiSettings.weapon_patterns
local _check_weapon_template, _check_mastery_settings
local workflow_states_to_check = {
	FUNCTIONAL = true,
	PROTOTYPE = true,
	RELEASABLE = true,
	SHIPPABLE = true,
}

local function _weapon_item_tests(weapon_templates)
	local item_definitions = MasterItems.get_cached()

	for _, item in pairs(item_definitions) do
		_check_weapon_template(weapon_templates, item)
		_check_mastery_settings(item)
	end
end

function _check_weapon_template(weapon_templates, item)
	local weapon_template_name = item.weapon_template

	weapon_template_name = type(weapon_template_name) == "string" and weapon_template_name ~= "" and weapon_template_name

	local item_name = item.name
	local workflow_state = item.workflow_state

	if weapon_template_name then
		local weapon_template = weapon_templates[weapon_template_name]

		if weapon_template or workflow_states_to_check[workflow_state] then
			-- Nothing
		elseif workflow_state then
			Log.error("WeaponItemTests", "Weapon template %q defined for item %q with workflow state %q does not exist.", weapon_template_name, item_name, workflow_state)
		end
	end
end

function _check_mastery_settings(item)
	local parent_pattern = item.parent_pattern
	local item_name = item.name
	local workflow_state = item.workflow_state

	if workflow_states_to_check[workflow_state] and parent_pattern and parent_pattern ~= "" then
		-- Nothing
	end
end

return _weapon_item_tests
