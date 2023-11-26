﻿-- chunkname: @scripts/settings/dialogue/mission_giver_vo_settings.lua

local MissionGiverVoSettings = {}

MissionGiverVoSettings.overrides = table.enum("sergeant_a", "pilot_a", "tech_priest_a", "explicator_a", "purser_a", "contract_vendor_a", "sergeant_b", "none")

return settings("MissionGiverVoSettings", MissionGiverVoSettings)
