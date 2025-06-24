-- chunkname: @scripts/settings/talent/talent_settings.lua

local TalentSettingsOgryn = require("scripts/settings/talent/talent_settings_ogryn")
local TalentSettingsPsyker = require("scripts/settings/talent/talent_settings_psyker")
local TalentSettingsVeteran = require("scripts/settings/talent/talent_settings_veteran")
local TalentSettingsZealot = require("scripts/settings/talent/talent_settings_zealot")
local TalentSettingsClass05 = require("scripts/settings/talent/talent_settings_adamant")
local talent_settings = {}

table.merge(talent_settings, TalentSettingsOgryn)
table.merge(talent_settings, TalentSettingsPsyker)
table.merge(talent_settings, TalentSettingsVeteran)
table.merge(talent_settings, TalentSettingsZealot)
table.merge(talent_settings, TalentSettingsClass05)

return talent_settings
