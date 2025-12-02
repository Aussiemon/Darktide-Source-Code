-- chunkname: @scripts/settings/dlc/dlc_settings.lua

dlc_settings = {
	dlcs = {},
	durable_dlcs = {},
	also_grants = {},
	client_predicted_includes_platforms = {
		[Backend.AUTH_METHOD_NONE] = true,
		[Backend.AUTH_METHOD_STEAM] = true,
		[Backend.AUTH_METHOD_XBOXLIVE] = false,
		[Backend.AUTH_METHOD_PSN] = false,
		[Backend.AUTH_METHOD_DEV_USER] = true,
		[Backend.AUTH_METHOD_AWS] = true,
	},
}

local function _create_dlc_entry(script_path)
	local dlc = require(script_path)

	dlc_settings.dlcs[dlc.dlc_id] = dlc
end

_create_dlc_entry("scripts/settings/dlc/archetypes/adamant_deluxe_dlc_settings")
_create_dlc_entry("scripts/settings/dlc/archetypes/adamant_dlc_settings")
_create_dlc_entry("scripts/settings/dlc/archetypes/broker_cosmetic_dlc_settings")
_create_dlc_entry("scripts/settings/dlc/archetypes/broker_deluxe_dlc_settings")
_create_dlc_entry("scripts/settings/dlc/archetypes/broker_dlc_settings")

local also_grants = dlc_settings.also_grants

for dlc_id, dlc in pairs(dlc_settings.dlcs) do
	also_grants[dlc_id] = also_grants[dlc_id] or {}

	local includes = dlc.includes

	if includes then
		for i = 1, #includes do
			local included_dlc = includes[i]

			also_grants[included_dlc] = also_grants[included_dlc] or {}

			table.insert(also_grants[included_dlc], dlc_id)
		end
	end
end

return settings("DLCSettings", dlc_settings)
