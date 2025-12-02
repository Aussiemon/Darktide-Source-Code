-- chunkname: @scripts/settings/character/crimes.lua

local CRIMES_ADAMANT = require("scripts/settings/character/crimes_adamant")
local CRIMES_BROKER = require("scripts/settings/character/crimes_broker")
local CRIMES_OGRYN = require("scripts/settings/character/crimes_ogryn")
local CRIMES_PSYKER = require("scripts/settings/character/crimes_psyker")
local CRIMES_SHARED = require("scripts/settings/character/crimes_shared")
local crime_options = {}

table.append(crime_options, CRIMES_SHARED)
table.append(crime_options, CRIMES_PSYKER)
table.append(crime_options, CRIMES_OGRYN)
table.append(crime_options, CRIMES_ADAMANT)
table.append(crime_options, CRIMES_BROKER)

local crime_options_by_id = {}

for i = 1, #crime_options do
	local crime_option = crime_options[i]
	local id = string.format("option_%d", i)

	crime_option.id = id
	crime_options_by_id[id] = crime_option
end

return settings("Crimes", crime_options_by_id)
