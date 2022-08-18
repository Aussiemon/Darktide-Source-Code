local Breed = require("scripts/utilities/breed")
local NavigationCostSettings = require("scripts/settings/navigation/navigation_cost_settings")
local SmartObjectSettings = require("scripts/settings/navigation/smart_object_settings")

local function _init_breed_nav_settings(Breeds)
	local smart_object_templates = SmartObjectSettings.templates
	local fallback_smart_object_template = smart_object_templates.fallback
	local default_nav_cost_maps_bots = NavigationCostSettings.default_nav_cost_maps_bots
	local default_nav_cost_maps_minions = NavigationCostSettings.default_nav_cost_maps_minions
	local default_nav_tag_layers_bots = NavigationCostSettings.default_nav_tag_layers_bots
	local default_nav_tag_layers_minions = NavigationCostSettings.default_nav_tag_layers_minions

	for breed_name, breed_data in pairs(Breeds) do
		local is_player_character = Breed.is_player(breed_data)
		local default_nav_cost_maps = (is_player_character and default_nav_cost_maps_bots) or default_nav_cost_maps_minions
		local nav_cost_map_multipliers = breed_data.nav_cost_map_multipliers

		if nav_cost_map_multipliers then
			for cost_map_name, _ in pairs(nav_cost_map_multipliers) do
				fassert(default_nav_cost_maps[cost_map_name], "Unknown cost map %q in breed %q, either add it to default layers or remove it from breed.", cost_map_name, breed_name)
			end

			table.add_missing(nav_cost_map_multipliers, default_nav_cost_maps)
		else
			nav_cost_map_multipliers = table.clone(default_nav_cost_maps)
			breed_data.nav_cost_map_multipliers = nav_cost_map_multipliers
		end

		for cost_map_name, value in pairs(nav_cost_map_multipliers) do
			if value == NavigationCostSettings.IGNORE_NAV_COST_MAP_LAYER then
				nav_cost_map_multipliers[cost_map_name] = nil
			end
		end

		local default_nav_tag_layers = (is_player_character and default_nav_tag_layers_bots) or default_nav_tag_layers_minions
		local nav_tag_allowed_layers = breed_data.nav_tag_allowed_layers

		if nav_tag_allowed_layers then
			for layer_name, _ in pairs(nav_tag_allowed_layers) do
				fassert(default_nav_tag_layers[layer_name], "Unknown nav tag layer %q in breed %q, either add it to default layers or remove it from breed.", layer_name, breed_name)
			end

			table.add_missing(nav_tag_allowed_layers, default_nav_tag_layers)
		else
			breed_data.nav_tag_allowed_layers = table.clone(default_nav_tag_layers)
		end

		if not is_player_character and not breed_data.smart_object_template then
			breed_data.smart_object_template = fallback_smart_object_template
		end
	end
end

return _init_breed_nav_settings
