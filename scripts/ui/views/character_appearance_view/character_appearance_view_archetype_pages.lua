-- chunkname: @scripts/ui/views/character_appearance_view/character_appearance_view_archetype_pages.lua

local ArchetypeSettings = require("scripts/settings/archetype/archetype_settings")
local SET_TO_NIL = {}
local DEFAULT_PAGES = {
	home_planet = {
		description = "loc_character_creator_home_planet_introduction",
		icon_texture = "content/ui/textures/icons/generic/placeholder_childhood",
		title = "loc_character_create_title_home_planet",
		top_icon_texture = "content/ui/materials/icons/character_creator/home_planet",
	},
	childhood = {
		description = "loc_character_creator_childhood_introduction",
		icon_texture = "content/ui/textures/icons/generic/placeholder_childhood",
		title = "loc_character_childhood_title_name",
		top_icon_texture = "content/ui/materials/icons/character_creator/childhood",
	},
	growing_up = {
		description = "loc_character_creator_growing_up_introduction",
		icon_texture = "content/ui/textures/icons/generic/placeholder_growingup",
		title = "loc_character_growing_up_title_name",
		top_icon_texture = "content/ui/materials/icons/character_creator/growth",
	},
	formative_event = {
		description = "loc_character_creator_formative_event_introduction",
		icon_texture = "content/ui/textures/icons/generic/placeholder_formative",
		title = "loc_character_event_title_name",
		top_icon_texture = "content/ui/materials/icons/character_creator/accomplishment",
	},
	appearance = {
		description = "loc_character_creator_commendations_introduction",
		icon_texture = "content/ui/textures/icons/generic/placeholder_formative",
		title = "loc_character_create_title_appearance",
		top_icon_texture = "content/ui/materials/icons/character_creator/appearence",
	},
	personality = {
		description = "loc_character_creator_personality_introduction",
		icon_texture = "content/ui/textures/icons/generic/placeholder_childhood",
		title = "loc_character_create_title_personality",
		top_icon_texture = "content/ui/materials/icons/character_creator/personality",
	},
	voice = {
		description = "loc_character_creator_voice_introduction",
		icon_texture = "content/ui/textures/icons/generic/placeholder_childhood",
		title = "loc_character_create_title_voice",
		top_icon_texture = "content/ui/materials/icons/character_creator/personality",
	},
	crime = {
		description = "loc_character_creator_sentence_introduction",
		icon_texture = "content/ui/textures/icons/generic/placeholder_childhood",
		title = "loc_character_create_title_crime",
		top_icon_texture = "content/ui/materials/icons/character_creator/sentence",
	},
}
local ARCHETYPE_OVERRIDES = {
	adamant = {
		childhood = {
			description = "loc_character_creator_early_life_introduction",
			icon_texture = "content/ui/textures/icons/generic/placeholder_childhood",
			title = "loc_character_create_title_early_life",
			top_icon_texture = "content/ui/materials/icons/character_creator/childhood",
		},
		growing_up = {
			description = "loc_character_creator_key_event_introduction",
			icon_texture = "content/ui/textures/icons/generic/placeholder_growingup",
			title = "loc_character_create_title_key_event",
			top_icon_texture = "content/ui/materials/icons/character_creator/growth",
		},
		formative_event = {
			description = "loc_character_creator_commendations_introduction",
			icon_texture = "content/ui/textures/icons/generic/placeholder_formative",
			title = "loc_character_create_title_commendations",
			top_icon_texture = "content/ui/materials/icons/character_creator/accomplishment",
		},
		companion_appearance = {
			description = "loc_character_creator_commendations_introduction",
			icon_texture = "content/ui/textures/icons/generic/placeholder_formative",
			title = "loc_character_create_title_appearance",
			top_icon_texture = "content/ui/materials/icons/character_creator/companion_appearence",
		},
		crime = {
			description = "loc_character_creator_precinct_introduction",
			icon_texture = "content/ui/textures/icons/generic/placeholder_childhood",
			title = "loc_character_create_title_precinct",
			top_icon_texture = "content/ui/materials/icons/character_creator/sentence",
		},
	},
	broker = {
		home_planet = {
			description = "loc_character_creator_gang_introduction",
			icon_texture = "content/ui/textures/icons/generic/placeholder_childhood",
			title = "loc_character_create_title_gang",
			top_icon_texture = "content/ui/materials/icons/character_creator/home_planet_broker",
		},
	},
	cryptic = {
		appearance = {
			top_icon_texture = "content/ui/materials/icons/character_creator/appearence_cryptic",
		},
		childhood = {
			description = "loc_character_creator_bio_origin_introduction",
			title = "loc_character_create_title_bio_origin",
		},
		growing_up = {
			description = "loc_character_creator_pre_ascension_introduction",
			title = "loc_character_create_title_pre_ascension",
		},
		formative_event = {
			description = "loc_character_creator_first_conflict_introduction",
			title = "loc_character_create_title_first_conflict",
		},
		crime = {
			description = "loc_character_creator_rise_to_prominence_introduction",
			title = "loc_character_create_title_rise_to_prominence",
		},
		home_planet = {
			description = "loc_character_creator_forge_world_introduction",
			icon_texture = "content/ui/textures/icons/generic/placeholder_childhood",
			title = "loc_character_create_title_forge_world",
			top_icon_texture = "content/ui/materials/icons/character_creator/home_planet",
		},
	},
	ogryn = {
		appearance = {
			top_icon_texture = "content/ui/materials/icons/character_creator/appearence_ogryn",
		},
	},
}
local EMPTY_TABLE = {}
local character_appearance_view_archetype_pages = {}

for archetype_name, _ in pairs(ArchetypeSettings.archetype_names) do
	local pages = table.clone(DEFAULT_PAGES)
	local overrides = ARCHETYPE_OVERRIDES[archetype_name] or EMPTY_TABLE

	for page_name, choice_overrides in pairs(overrides) do
		if pages[page_name] then
			table.merge(pages[page_name], choice_overrides)
		else
			pages[page_name] = table.clone(choice_overrides)
		end

		for override_key, override_value in pairs(choice_overrides) do
			if override_value == SET_TO_NIL then
				pages[page_name][override_key] = nil
			end
		end
	end

	character_appearance_view_archetype_pages[archetype_name] = pages
end

return settings("CharacterAppearanceViewArchetypePages", character_appearance_view_archetype_pages)
