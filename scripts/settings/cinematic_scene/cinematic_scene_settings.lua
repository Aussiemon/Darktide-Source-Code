-- chunkname: @scripts/settings/cinematic_scene/cinematic_scene_settings.lua

local CinematicSceneSettings = {}

CinematicSceneSettings.CINEMATIC_NAMES = table.enum("intro_abc", "outro_win", "outro_fail", "cutscene_1", "cutscene_2", "cutscene_3", "cutscene_4", "cutscene_5", "cutscene_5_hub", "cutscene_6", "cutscene_7", "cutscene_8", "cutscene_9", "cutscene_10", "path_of_trust_01", "path_of_trust_02", "path_of_trust_03", "path_of_trust_04", "path_of_trust_05", "path_of_trust_06", "path_of_trust_07", "path_of_trust_08", "path_of_trust_09", "traitor_captain_intro", "hub_location_intro_barber", "hub_location_intro_mission_board", "hub_location_intro_training_grounds", "hub_location_intro_contracts", "hub_location_intro_crafting", "hub_location_intro_gun_shop", "none")

return settings("CinematicSceneSettings", CinematicSceneSettings)
