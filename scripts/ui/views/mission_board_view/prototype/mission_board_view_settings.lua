local DialogueSpeakerVoiceSettings = require("scripts/settings/dialogue/dialogue_speaker_voice_settings")
local quickplay_quest_giver = DialogueSpeakerVoiceSettings.pilot_a
local MissionBoardViewSettings = {
	objective_fluff = {
		control_objective = {
			"content/ui/materials/fluff/hologram/mission_objective/control_01",
			"content/ui/materials/fluff/hologram/mission_objective/control_02",
			"content/ui/materials/fluff/hologram/mission_objective/control_03"
		},
		demolition_objective = {
			"content/ui/materials/fluff/hologram/mission_objective/demolition_01",
			"content/ui/materials/fluff/hologram/mission_objective/demolition_02",
			"content/ui/materials/fluff/hologram/mission_objective/demolition_03"
		},
		fortification_objective = {
			"content/ui/materials/fluff/hologram/mission_objective/fortification_01",
			"content/ui/materials/fluff/hologram/mission_objective/fortification_02",
			"content/ui/materials/fluff/hologram/mission_objective/fortification_03"
		},
		decode_objective = {
			"content/ui/materials/fluff/hologram/mission_objective/decode_01",
			"content/ui/materials/fluff/hologram/mission_objective/decode_02",
			"content/ui/materials/fluff/hologram/mission_objective/decode_03"
		},
		kill_objective = {
			"content/ui/materials/fluff/hologram/mission_objective/kill_01",
			"content/ui/materials/fluff/hologram/mission_objective/kill_02",
			"content/ui/materials/fluff/hologram/mission_objective/kill_03"
		},
		luggable_objective = {
			"content/ui/materials/fluff/hologram/mission_objective/luggable_01",
			"content/ui/materials/fluff/hologram/mission_objective/luggable_02",
			"content/ui/materials/fluff/hologram/mission_objective/luggable_03"
		}
	},
	fluff_frames = {
		"content/ui/materials/fluff/hologram/frames/fluff_frame_01",
		"content/ui/materials/fluff/hologram/frames/fluff_frame_02",
		"content/ui/materials/fluff/hologram/frames/fluff_frame_03",
		"content/ui/materials/fluff/hologram/frames/fluff_frame_04",
		"content/ui/materials/fluff/hologram/frames/fluff_frame_05",
		"content/ui/materials/fluff/hologram/frames/fluff_frame_06",
		"content/ui/materials/fluff/hologram/frames/fluff_frame_07",
		"content/ui/materials/fluff/hologram/frames/fluff_frame_08"
	},
	mission_positions = {
		{
			609.258301,
			790.492554,
			index = 1,
			length = 101.62399
		},
		{
			1074.599609,
			563.593506,
			index = 2,
			length = 275.554782
		},
		{
			1128.427368,
			766.991089,
			index = 3,
			length = 128.65103
		},
		{
			458.338348,
			830.267151,
			index = 4,
			length = 100.012572
		},
		{
			284.807129,
			210.682526,
			index = 5,
			length = 478.26218
		},
		{
			172.640961,
			399.762604,
			index = 6,
			length = 365.843064
		},
		{
			205.99408,
			734.919861,
			index = 7,
			length = 101.498319
		},
		{
			798.753357,
			818.516296,
			index = 8,
			length = 110.819481
		},
		{
			477.9823,
			239.91391,
			index = 9,
			length = 444.791068
		},
		{
			1003.620117,
			351.376862,
			index = 10,
			length = 194.371949
		},
		{
			964.510193,
			765.151245,
			index = 11,
			length = 83.151424
		},
		{
			354.896149,
			379.154327,
			index = 12,
			length = 399.220118
		},
		{
			865.816101,
			260.575684,
			index = 13,
			length = 548.384485
		}
	},
	flash_position = {
		704.213501,
		552.210754
	},
	quickplay_fake_mission = {
		position = {
			331.632019,
			614.118713
		},
		objective = {
			text = "loc_mission_board_quickplay_description",
			name = "loc_mission_board_quickplay_header",
			icon = "content/ui/materials/icons/mission_types/mission_type_09",
			npc_name = "// " .. Localize(quickplay_quest_giver.full_name),
			npc_image = quickplay_quest_giver.material_small
		}
	}
}

return MissionBoardViewSettings
