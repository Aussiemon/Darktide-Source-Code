-- chunkname: @scripts/ui/views/player_survey_view/player_survey_view_dummy_data.lua

return {
	id = "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
	valid_from = os.time() - 3600,
	valid_to = os.time() + 86400,
	questions = {
		{
			choice_count_max = 1,
			choice_count_min = 1,
			id = "question_1",
			title_text_localized = "Are you happy with Darktide?",
			type = "choice",
			choices = {
				{
					id = "choice_1",
					text_localized = "Praise the Emperor, Yes! Praise the Emperor, Yes! Praise the Emperor, Yes! Praise the Emperor, Yes!",
				},
				{
					id = "choice_2",
					text_localized = "Heretically, No!",
				},
			},
		},
		{
			choice_count_max = 1,
			choice_count_min = 1,
			id = "question_2",
			title_text_localized = "Is Darktide a hard game?",
			type = "choice",
			choices = {
				{
					id = "choice_1",
					text_localized = "Lol no",
				},
				{
					id = "choice_2",
					text_localized = "Yeah kinda",
				},
				{
					id = "choice_3",
					text_localized = "I cried",
				},
			},
		},
		{
			choice_count_max = 3,
			choice_count_min = 1,
			id = "question_3",
			subtitle_text_localized = "Please select at least %d to %d",
			title_text_localized = "What are your favorite classes?",
			type = "choice",
			choices = {
				{
					id = "choice_1",
					text_localized = "Zealot",
				},
				{
					id = "choice_2",
					text_localized = "Veteran",
				},
				{
					id = "choice_3",
					text_localized = "Psyker",
				},
				{
					id = "choice_4",
					text_localized = "Ogryn",
				},
				{
					id = "choice_5",
					text_localized = "Arbitrator",
				},
			},
		},
		{
			choice_count_max = 6,
			choice_count_min = 0,
			id = "question_4",
			subtitle_text_localized = "Please select up to %d",
			title_text_localized = "What are your favorite event rewards?",
			type = "choice",
			choices = {
				{
					id = "choice_1",
					text_localized = "RASHUNS!",
				},
				{
					id = "choice_2",
					text_localized = "Frames",
				},
				{
					id = "choice_3",
					text_localized = "Titles",
				},
				{
					id = "choice_4",
					text_localized = "Aquilas",
				},
				{
					id = "choice_5",
					text_localized = "Helmets",
				},
				{
					id = "choice_6",
					text_localized = "Weapon Marks",
				},
			},
		},
	},
}
