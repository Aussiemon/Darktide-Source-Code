-- chunkname: @scripts/settings/talent/talent_settings.lua

local TalentSettingsClass05 = require("scripts/settings/talent/talent_settings_adamant")
local TalentSettingsOgryn = require("scripts/settings/talent/talent_settings_ogryn")
local TalentSettingsPsyker = require("scripts/settings/talent/talent_settings_psyker")
local TalentSettingsShared = require("scripts/settings/talent/talent_settings_shared")
local TalentSettingsVeteran = require("scripts/settings/talent/talent_settings_veteran")
local TalentSettingsZealot = require("scripts/settings/talent/talent_settings_zealot")
local talent_settings = {}

table.merge(talent_settings, TalentSettingsClass05)
table.merge(talent_settings, TalentSettingsOgryn)
table.merge(talent_settings, TalentSettingsPsyker)
table.merge(talent_settings, TalentSettingsShared)
table.merge(talent_settings, TalentSettingsVeteran)
table.merge(talent_settings, TalentSettingsZealot)

return talent_settings
