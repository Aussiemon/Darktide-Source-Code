local WeaponTweaks = {}

local function create_new(damage_profiles, parent_template_name, template_overrides)
	local new_template = table.clone(damage_profiles[parent_template_name])

	for i = 1, #template_overrides do
		local overrides_table = template_overrides[i]
		local num_keys = #overrides_table - 1
		local entry = new_template

		for j = 1, num_keys do
			if j < num_keys then
				local key = overrides_table[j]
				entry = entry[key]
			else
				local key = overrides_table[j]
				local value = overrides_table[j + 1]
				entry[key] = value
			end
		end
	end

	return new_template
end

WeaponTweaks.extract_weapon_tweaks = function (path, templates, loaded_files)
	loaded_files[path] = true
	local data = require(path)
	local parent_base_templates = data.base_templates
	local overrides = data.overrides

	for name, damage_profile_data in upairs(parent_base_templates) do
		templates[name] = damage_profile_data
	end

	if overrides then
		for name, override in upairs(overrides) do
			local parent_template_name = override.parent_template_name
			local template_overrides = override.overrides
			templates[name] = create_new(parent_base_templates, parent_template_name, template_overrides)
		end
	end
end

return WeaponTweaks
