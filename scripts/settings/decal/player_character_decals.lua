-- chunkname: @scripts/settings/decal/player_character_decals.lua

local PlayerCharacterDecals = {}
local decal_aliases = require("scripts/settings/decal/player_character_decal_aliases")

PlayerCharacterDecals.decal_aliases = decal_aliases

local decal_names = {}

local function _extract_decal_names(decals)
	for switch_value, decal_name in pairs(decals) do
		if type(decal_name) == "table" then
			_extract_decal_names(decal_name)
		else
			decal_names[decal_name] = true
		end
	end
end

for alias, config in pairs(decal_aliases) do
	local decals = config.decals

	_extract_decal_names(decals)
end

PlayerCharacterDecals.decal_names = decal_names

PlayerCharacterDecals.resolve_decal = function (decal_alias, properties, optional_external_properties)
	local settings = PlayerCharacterDecals.decal_aliases[decal_alias]

	if settings then
		local decals = settings.decals
		local extents = settings.extents
		local switches = settings.switch
		local default_switch_properties = settings.default_switch_properties
		local no_default = settings.no_default
		local num_switches = #switches

		if num_switches == 0 then
			return true, decals.default, extents.default
		end

		for ii = 1, num_switches do
			local switch_name = switches[ii]
			local switch_property = properties[switch_name] or optional_external_properties and optional_external_properties[switch_name] or default_switch_properties and default_switch_properties[switch_name]

			if switch_property and decals[switch_property] then
				decals = decals[switch_property]
				extents = extents[switch_property]
			elseif not no_default then
				decals = decals.default
				extents = extents.default
			end

			if type(decals) == "string" then
				return true, decals, extents
			end
		end
	else
		Log.warning("PlayerCharacterDecals", "No decal alias named %q", decal_alias)
	end

	local allow_default = settings and not settings.no_default

	return allow_default, allow_default and settings.decals.default, allow_default and settings.extents.default
end

local function _valid_decals_recursive(decals, relevant_decals)
	for _, decal_or_decals in pairs(decals) do
		if type(decal_or_decals) == "string" then
			relevant_decals[decal_or_decals] = true
		else
			_valid_decals_recursive(decal_or_decals, relevant_decals)
		end
	end
end

local temp_relevant_decals = {}

PlayerCharacterDecals.find_relevant_decals = function (profile_properties)
	table.clear(temp_relevant_decals)

	for decal_alias, settings in pairs(PlayerCharacterDecals.decal_aliases) do
		local decals = settings.decals
		local switches = settings.switch
		local no_default = settings.no_default
		local num_switches = #switches

		if num_switches == 0 then
			local resource_name = decals.default

			temp_relevant_decals[resource_name] = true
		else
			for ii = 1, num_switches do
				local switch_name = switches[ii]
				local switch_property = profile_properties[switch_name]

				if switch_property then
					local default_decals = decals.default

					decals = decals[switch_property] or default_decals or decals
				else
					_valid_decals_recursive(decals, temp_relevant_decals)

					break
				end

				if type(decals) == "string" then
					temp_relevant_decals[decals] = true

					break
				end
			end
		end
	end

	return temp_relevant_decals
end

return PlayerCharacterDecals
