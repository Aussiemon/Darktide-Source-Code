-- chunkname: @scripts/settings/dialogue/mission_giver_vo_settings.lua

local MissionGiverVoSettings = {}

MissionGiverVoSettings.overrides = table.enum("armourer_b", "boon_vendor_a", "boon_vendor_s", "commissar_a", "contract_vendor_a", "enginseer_a", "explicator_a", "interrogator_a", "pilot_a", "purser_a", "sergeant_a", "sergeant_b", "sergeant_c", "shipmistress_a", "tech_priest_a", "tech_priest_b", "training_ground_psyker_a", "none")

return settings("MissionGiverVoSettings", MissionGiverVoSettings)
