local experience_per_level_array = {
	0,
	500,
	585,
	670,
	755,
	840,
	925,
	1010,
	1095,
	1180,
	1265,
	1350,
	1435,
	1520,
	1605,
	1690,
	1775,
	1860,
	1945,
	2030,
	2115,
	2200,
	2285,
	2370,
	2455,
	2540,
	2625,
	2710,
	2795,
	2880,
	2965
}
local num_defined_levels = #experience_per_level_array
local total_defined_experience = 0

for i = 1, num_defined_levels, 1 do
	total_defined_experience = total_defined_experience + experience_per_level_array[i]
end

local experience_settings = {
	experience_per_level_array = experience_per_level_array,
	max_level_experience = total_defined_experience,
	max_level = num_defined_levels
}

return settings("PlayerExperienceSettings", experience_settings)
