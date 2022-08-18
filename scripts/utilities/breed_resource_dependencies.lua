local BreedActions = require("scripts/settings/breed/breed_actions")
local ItemPackage = require("scripts/foundation/managers/package/utilities/item_package")
local BreedResourceDependencies = {}
local TEMP_BREED_RESOURCE_PACKAGES = {}

BreedResourceDependencies.generate = function (breeds, item_definitions)
	local resource_packages = {}
	local iterator_func = pairs
	local temp_breed_names, temp_package_names = nil

	for breed_name, breed_data in iterator_func(breeds, temp_breed_names) do
		BreedResourceDependencies._resolve_recursive(breed_data, item_definitions, TEMP_BREED_RESOURCE_PACKAGES)

		local actions_data = BreedActions[breed_name]

		if actions_data then
			BreedResourceDependencies._resolve_recursive(actions_data, item_definitions, TEMP_BREED_RESOURCE_PACKAGES)
		end

		for resource_name, _ in iterator_func(TEMP_BREED_RESOURCE_PACKAGES, temp_package_names) do
			TEMP_BREED_RESOURCE_PACKAGES[resource_name] = nil
			resource_packages[resource_name] = true
		end
	end

	return resource_packages
end

local CONTENT_START_STRING = "content/"
local CONTENT_ITEM_START_STRING = "content/items/"
local CONTENT_UI_START_STRING = "content/ui/"
local CONTENT_IMPACT_PARTICLE_START_STRING = "content/fx/particles/impacts/"
local WWISE_START_STRING = "wwise/"

local function _is_valid_resource_name(value)
	return (string.starts_with(value, CONTENT_START_STRING) and not string.starts_with(value, CONTENT_UI_START_STRING) and not string.starts_with(value, CONTENT_IMPACT_PARTICLE_START_STRING)) or string.starts_with(value, WWISE_START_STRING)
end

BreedResourceDependencies._resolve_recursive = function (data, item_definitions, resource_packages)
	for _, value in pairs(data) do
		local value_type = type(value)

		if value_type == "string" then
			if _is_valid_resource_name(value) then
				if string.starts_with(value, CONTENT_ITEM_START_STRING) then
					ItemPackage.compile_item_dependencies(value, item_definitions, resource_packages)
				else
					resource_packages[value] = true
				end
			end
		elseif value_type == "table" then
			BreedResourceDependencies._resolve_recursive(value, item_definitions, resource_packages)
		end
	end
end

return BreedResourceDependencies
