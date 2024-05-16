-- chunkname: @scripts/utilities/weapon_template_resource_dependencies.lua

local ImpactFxResourceDependencies = require("scripts/settings/damage/impact_fx_resource_dependencies")
local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")
local WeaponTemplateResourceDependencies = {}
local _resolve_data_recursive, _is_valid_resource_name_exclude_items
local _cached_templates = {}
local TEMP_RESOURCE_PACKAGES = {}

WeaponTemplateResourceDependencies.generate = function (weapon_template_name)
	local cached_resources = _cached_templates[weapon_template_name]

	if cached_resources then
		return cached_resources
	end

	local resource_packages = {}

	_cached_templates[weapon_template_name] = resource_packages

	local weapon_template = WeaponTemplates[weapon_template_name]

	_resolve_data_recursive(weapon_template, TEMP_RESOURCE_PACKAGES)

	local impact_fx_resource_packages = ImpactFxResourceDependencies.generate(weapon_template)

	for i = 1, #impact_fx_resource_packages do
		local resource = impact_fx_resource_packages[i]

		if _is_valid_resource_name_exclude_items(resource) then
			TEMP_RESOURCE_PACKAGES[resource] = true
		end
	end

	for resource_name, _ in pairs(TEMP_RESOURCE_PACKAGES) do
		TEMP_RESOURCE_PACKAGES[resource_name] = nil
		resource_packages[#resource_packages + 1] = resource_name
	end

	return resource_packages
end

local CONTENT_OGRYN_ANIMATION_MATRICE_DATA_1P = "content/characters/player/ogryn/first_person/animations/.*/.*"
local CONTENT_OGRYN_ANIMATION_MATRICE_DATA_3P = "content/characters/player/ogryn/third_person/animations/.*/.*"
local CONTENT_HUMAN_ANIMATION_MATRICE_DATA_1P = "content/characters/player/human/first_person/animations/.*/.*"
local CONTENT_HUMAN_ANIMATION_MATRICE_DATA_3P = "content/characters/player/human/third_person/animations/.*/.*"

local function _is_matrice_data(value)
	return string.match(value, CONTENT_OGRYN_ANIMATION_MATRICE_DATA_1P) or string.match(value, CONTENT_OGRYN_ANIMATION_MATRICE_DATA_3P) or string.match(value, CONTENT_HUMAN_ANIMATION_MATRICE_DATA_1P) or string.match(value, CONTENT_HUMAN_ANIMATION_MATRICE_DATA_3P)
end

local CONTENT_CHARACTERS_PLAYER = "content/characters/player/"

local function _is_valid_state_machine_resource(value)
	return string.starts_with(value, CONTENT_CHARACTERS_PLAYER) and not _is_matrice_data(value)
end

local WWISE_START_STRING_PLAYER = "wwise/events/player/"
local WWISE_START_STRING_WEAPON = "wwise/events/weapon/"

local function _is_valid_wwise_resource_name(value)
	return string.starts_with(value, WWISE_START_STRING_PLAYER) or string.starts_with(value, WWISE_START_STRING_WEAPON)
end

local CONTENT_FX_PARTICLES_WEAPONS = "content/fx/particles/weapons/"
local CONTENT_FX_PARTICLES_IMPACTS = "content/fx/particles/impacts/"
local CONTENT_FX_PARTICLES_ABILITIES = "content/fx/particles/abilities"
local CONTENT_FX_UNITS_WEAPONS = "content/fx/units/weapons/"
local CONTENT_FX_DECALS_BLOOD_BALL = "content/decals/blood_ball/"

local function _is_valid_fx_resource_name(value)
	return string.starts_with(value, CONTENT_FX_PARTICLES_WEAPONS) or string.starts_with(value, CONTENT_FX_PARTICLES_IMPACTS) or string.starts_with(value, CONTENT_FX_PARTICLES_ABILITIES) or string.starts_with(value, CONTENT_FX_UNITS_WEAPONS) or string.starts_with(value, CONTENT_FX_DECALS_BLOOD_BALL)
end

local function _is_valid_unit_resource(value)
	return string.starts_with(value, CONTENT_CHARACTERS_PLAYER) and not _is_matrice_data(value)
end

local function _is_valid_resource_name(value)
	return _is_valid_wwise_resource_name(value) or _is_valid_fx_resource_name(value) or _is_valid_state_machine_resource(value) or _is_valid_unit_resource(value)
end

local CONTENT_ITEM_START_STRING = "content/items/"

function _is_valid_resource_name_exclude_items(value)
	return not string.starts_with(value, CONTENT_ITEM_START_STRING) and _is_valid_resource_name(value)
end

local WWISE_START_STRING = "wwise/"

function _resolve_data_recursive(data, resource_packages)
	for _, value in pairs(data) do
		local value_type = type(value)

		if value_type == "string" then
			if _is_valid_resource_name_exclude_items(value) then
				resource_packages[value] = true

				if string.starts_with(value, WWISE_START_STRING) then
					local husk_event = string.format("%s_husk", value)

					if Application.can_get_resource("package", husk_event) then
						resource_packages[husk_event] = true
					end
				end
			end
		elseif value_type == "table" then
			local is_class = rawget(value, "__class_name") ~= nil

			if not is_class then
				_resolve_data_recursive(value, resource_packages)
			end
		end
	end
end

return WeaponTemplateResourceDependencies
