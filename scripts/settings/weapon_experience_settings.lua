-- chunkname: @scripts/settings/weapon_experience_settings.lua

local experience_per_level_array = {
	0,
	200,
	400,
	600,
	650,
	700,
	750,
	800,
	850,
	900,
	1000,
	1100,
	1200,
	1300,
	1400,
	1500,
	1600,
	1700,
	1800,
	1900,
	2000,
	2100,
	2200,
	2300,
	2400,
	2500,
	2600,
	2700,
	2800,
	2900,
}
local num_defined_levels = #experience_per_level_array
local total_defined_experience = 0

for i = 1, num_defined_levels do
	total_defined_experience = total_defined_experience + experience_per_level_array[i]
end

local experience_accumulated_per_level = {}
local accumulated_exp = 0

for i = 1, num_defined_levels do
	accumulated_exp = accumulated_exp + experience_per_level_array[i]
	experience_accumulated_per_level[i] = accumulated_exp
end

local weapon_experience_settings = {
	experience_per_level_array = experience_accumulated_per_level,
	max_level_experience = total_defined_experience,
	max_level = num_defined_levels,
}

return settings("WeaponExperienceSettings", weapon_experience_settings)
