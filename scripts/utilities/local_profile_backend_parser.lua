local LocalProfileBackendParser = {
	parse_profile = function (profile, character_id)
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
	end
}

return LocalProfileBackendParser
