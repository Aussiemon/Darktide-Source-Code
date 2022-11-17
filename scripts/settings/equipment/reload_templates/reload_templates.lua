local reload_templates = {}

local function _create_reload_template_entry(path)
	local reload_template_data = require(path)
	local reload_template_name = reload_template_data.name
	reload_templates[reload_template_name] = reload_template_data
end

_create_reload_template_entry("scripts/settings/equipment/reload_templates/autogun_reload_template")
_create_reload_template_entry("scripts/settings/equipment/reload_templates/autogun_ak_reload_template")
_create_reload_template_entry("scripts/settings/equipment/reload_templates/autopistol_reload_template")
_create_reload_template_entry("scripts/settings/equipment/reload_templates/basic_reload_template")
_create_reload_template_entry("scripts/settings/equipment/reload_templates/bolter_reload_template")
_create_reload_template_entry("scripts/settings/equipment/reload_templates/flamer_reload_template")
_create_reload_template_entry("scripts/settings/equipment/reload_templates/lasgun_reload_template")
_create_reload_template_entry("scripts/settings/equipment/reload_templates/lasgun_elysian_reload_template")
_create_reload_template_entry("scripts/settings/equipment/reload_templates/laspistol_reload_template")
_create_reload_template_entry("scripts/settings/equipment/reload_templates/ogryn_gauntlet_reload_template")
_create_reload_template_entry("scripts/settings/equipment/reload_templates/ogryn_thumper_reload_template")
_create_reload_template_entry("scripts/settings/equipment/reload_templates/plasma_rifle_reload_template")
_create_reload_template_entry("scripts/settings/equipment/reload_templates/rippergun_reload_template")
_create_reload_template_entry("scripts/settings/equipment/reload_templates/heavy_stubber_twin_linked_reload_template")

for reload_template_name, reload_template in pairs(reload_templates) do
	local states = reload_template.states

	for i = 1, #states do
		local state_name = states[i]
		local state = reload_template[state_name]
		state.state_index = i
	end
end

return settings("ReloadTemplates", reload_templates)
