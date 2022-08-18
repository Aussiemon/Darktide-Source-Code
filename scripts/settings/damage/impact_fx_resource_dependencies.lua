local ImpactEffectSettings = require("scripts/settings/damage/impact_effect_settings")
local impact_fx_lookup = ImpactEffectSettings.impact_fx_lookup
local ImpactFxResourceDependencies = {}
local _fetch_impact_fx_lookups_recursive, _find_resources_recursive, _find_impact_decal_resources_recursive, _is_valid_resource, _is_valid_impact_decal_resource, _is_class = nil
local TEMP_RESOURCE_PACKAGES = Script.new_map(128)
local TEMP_IMPACT_FX_LOOKUPS = Script.new_map(16)

ImpactFxResourceDependencies.generate = function (data_table)
	local packages = {}

	table.clear(TEMP_IMPACT_FX_LOOKUPS)
	_fetch_impact_fx_lookups_recursive(data_table, TEMP_IMPACT_FX_LOOKUPS)
	table.clear(TEMP_RESOURCE_PACKAGES)
	_find_resources_recursive(TEMP_IMPACT_FX_LOOKUPS, TEMP_RESOURCE_PACKAGES)

	for resource_name, _ in pairs(TEMP_RESOURCE_PACKAGES) do
		TEMP_RESOURCE_PACKAGES[resource_name] = nil
		packages[#packages + 1] = resource_name
	end

	return packages
end

local _cached_templates = {}

ImpactFxResourceDependencies.impact_decal_units = function (id, data_table)
	local cached_resources = _cached_templates[id]

	if cached_resources then
		return cached_resources
	end

	local resource_packages = {}
	_cached_templates[id] = resource_packages

	table.clear(TEMP_IMPACT_FX_LOOKUPS)
	_fetch_impact_fx_lookups_recursive(data_table, TEMP_IMPACT_FX_LOOKUPS)
	table.clear(TEMP_RESOURCE_PACKAGES)
	_find_impact_decal_resources_recursive(TEMP_IMPACT_FX_LOOKUPS, TEMP_RESOURCE_PACKAGES)

	for resource_name, _ in pairs(TEMP_RESOURCE_PACKAGES) do
		TEMP_RESOURCE_PACKAGES[resource_name] = nil
		resource_packages[#resource_packages + 1] = resource_name
	end

	return resource_packages
end

function _fetch_impact_fx_lookups_recursive(data_table, impact_fx_map)
	for key, value in pairs(data_table) do
		if type(value) == "table" and not _is_class(value) then
			_fetch_impact_fx_lookups_recursive(value, impact_fx_map)
		elseif key == "damage_type" then
			impact_fx_map[value] = impact_fx_lookup[value]
		end
	end
end

function _find_resources_recursive(impact_fx_data, resource_packages)
	for _, value in pairs(impact_fx_data) do
		local value_type = type(value)

		if value_type == "table" then
			_find_resources_recursive(value, resource_packages)
		elseif value_type == "string" and _is_valid_resource(value) then
			resource_packages[value] = true
		end
	end
end

function _find_impact_decal_resources_recursive(impact_fx_data, resource_packages)
	for _, value in pairs(impact_fx_data) do
		local value_type = type(value)

		if value_type == "table" then
			_find_impact_decal_resources_recursive(value, resource_packages)
		elseif value_type == "string" and _is_valid_impact_decal_resource(value) then
			resource_packages[value] = true
		end
	end
end

local FX_RESOURCE = "content/fx/"
local DECALS_RESOURCE = "content/decals/"

local function _is_valid_fx_resource(resource)
	return string.starts_with(resource, FX_RESOURCE) or string.starts_with(resource, DECALS_RESOURCE)
end

local SFX_RESOURCE = "wwise/events/"

local function _is_valid_sfx_resource(resource)
	return string.starts_with(resource, SFX_RESOURCE)
end

local IMPACT_DECAL_RESOURCE = "content/fx/units/weapons/"

function _is_valid_impact_decal_resource(resource)
	return string.starts_with(resource, IMPACT_DECAL_RESOURCE)
end

function _is_valid_resource(resource)
	return _is_valid_fx_resource(resource) or _is_valid_sfx_resource(resource)
end

function _is_class(t)
	return rawget(t, "__class_name") ~= nil
end

return ImpactFxResourceDependencies
