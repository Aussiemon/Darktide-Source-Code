-- chunkname: @scripts/utilities/breed_resource_dependencies.lua

local BreedActions = require("scripts/settings/breed/breed_actions")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local ImpactFxResourceDependencies = require("scripts/settings/damage/impact_fx_resource_dependencies")
local ItemPackage = require("scripts/foundation/managers/package/utilities/item_package")
local BreedResourceDependencies = {}
local _resolve_recursive, _resolve_impact_fx
local TEMP_BREED_RESOURCE_PACKAGES = {}

BreedResourceDependencies.generate = function (breeds, item_definitions)
	local resource_packages, iterator_func = {}, pairs
	local temp_breed_names, temp_package_names

	for breed_name, breed_data in iterator_func(breeds, temp_breed_names) do
		_resolve_recursive(breed_data, item_definitions, TEMP_BREED_RESOURCE_PACKAGES)
		_resolve_impact_fx(breed_data, TEMP_BREED_RESOURCE_PACKAGES)

		local actions_data = BreedActions[breed_name]

		if actions_data then
			_resolve_recursive(actions_data, item_definitions, TEMP_BREED_RESOURCE_PACKAGES)
			_resolve_impact_fx(actions_data, TEMP_BREED_RESOURCE_PACKAGES)
		end

		local effect_template_names = breed_data.effect_template_names

		if effect_template_names then
			_resolve_recursive(effect_template_names, item_definitions, TEMP_BREED_RESOURCE_PACKAGES)
		end

		for resource_name, _ in iterator_func(TEMP_BREED_RESOURCE_PACKAGES, temp_package_names) do
			TEMP_BREED_RESOURCE_PACKAGES[resource_name] = nil
			resource_packages[resource_name] = true
		end
	end

	return resource_packages
end

local EFFECT_TEMPLATE_END_STRING = "effect_template_name"
local CONTENT_START_STRING = "content/"
local CONTENT_ITEM_START_STRING = "content/items/"
local CONTENT_UI_START_STRING = "content/ui/"
local WWISE_START_STRING = "wwise/"

local function _is_valid_resource_name(value)
	return string.starts_with(value, CONTENT_START_STRING) and not string.starts_with(value, CONTENT_UI_START_STRING) or string.starts_with(value, WWISE_START_STRING)
end

function _resolve_recursive(data, item_definitions, resource_packages)
	for key, value in pairs(data) do
		local value_type = type(value)

		if value_type == "string" then
			if _is_valid_resource_name(value) then
				if string.starts_with(value, CONTENT_ITEM_START_STRING) then
					ItemPackage.compile_item_dependencies(value, item_definitions, resource_packages)
				else
					resource_packages[value] = true
				end
			elseif string.ends_with(key, EFFECT_TEMPLATE_END_STRING) then
				local effect_template = EffectTemplates[value]

				_resolve_recursive(effect_template, item_definitions, resource_packages)
			end
		elseif value_type == "table" then
			_resolve_recursive(value, item_definitions, resource_packages)
		end
	end
end

function _resolve_impact_fx(data, resource_packages)
	local impact_fx_resource_packages = ImpactFxResourceDependencies.generate(data)

	for ii = 1, #impact_fx_resource_packages do
		local resource = impact_fx_resource_packages[ii]

		resource_packages[resource] = true
	end
end

return BreedResourceDependencies
