-- chunkname: @scripts/utilities/local_profile_backend_parser.lua

local Archetypes = require("scripts/settings/archetype/archetypes")
local PlayerSpecialization = require("scripts/utilities/player_specialization/player_specialization")
local LocalProfileBackendParser = {}

LocalProfileBackendParser.parse_profile = function (profile, character_id)
	profile.character_id = character_id

	local loadout = profile.loadout
	local loadout_item_data = {}
	local loadout_item_ids = {}

	for slot_name, master_item in pairs(loadout) do
		loadout_item_data[slot_name] = {
			id = master_item.name
		}
		loadout_item_ids[slot_name] = master_item.name .. slot_name
	end

	profile.loadout_item_ids = loadout_item_ids
	profile.loadout_item_data = loadout_item_data

	if not profile.selected_nodes then
		profile.selected_nodes = {}
	end

	profile.talent_points = profile.talent_points or 0

	if not profile.talents then
		profile.talents = {}
	end

	local archetype_name = profile.archetype
	local archetype = Archetypes[archetype_name]
	local talents = profile.talents
	local num_talents = #talents

	for i = num_talents, 1, -1 do
		local talent_name = talents[i]
		local segments = string.split(talent_name, "--")
		local selected_name = segments[1] or talent_name
		local tier = tonumber(segments[2]) or 0

		talents[selected_name] = tier
		talents[i] = nil
	end

	PlayerSpecialization.add_archetype_base_talents(archetype, profile.talents)
end

return LocalProfileBackendParser
