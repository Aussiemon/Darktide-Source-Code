local Breed = require("scripts/utilities/breed")

local function _init_breed_settings(Breeds)
	for breed_name, breed_data in pairs(Breeds) do
		if Breed.is_minion(breed_data) then
			local line_of_sight_data = breed_data.line_of_sight_data

			for i = 1, #line_of_sight_data, 1 do
				local data = line_of_sight_data[i]
				data.num_offsets = #data.offsets
			end
		end
	end
end

return _init_breed_settings
