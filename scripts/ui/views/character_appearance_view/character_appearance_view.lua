-- chunkname: @scripts/ui/views/character_appearance_view/character_appearance_view.lua

local Definitions = require("scripts/ui/views/character_appearance_view/character_appearance_view_definitions")
local CharacterAppearanceViewSettings = require("scripts/ui/views/character_appearance_view/character_appearance_view_settings")
local Popups = require("scripts/utilities/ui/popups")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local UIProfileSpawner = require("scripts/managers/ui/ui_profile_spawner")
local MasterItems = require("scripts/backend/master_items")
local Breeds = require("scripts/settings/breed/breeds")
local ContentBlueprints = require("scripts/ui/views/character_appearance_view/character_appearance_view_content_blueprints")
local ScrollbarPassTemplates = require("scripts/ui/pass_templates/scrollbar_pass_templates")
local CharacterAppearanceViewFontStyle = require("scripts/ui/views/character_appearance_view/character_appearance_view_font_style")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ColorUtilities = require("scripts/utilities/ui/colors")
local SkinMaterialOverrides = require("scripts/settings/equipment/item_material_overrides/player_material_overrides_skin_colors")
local EyeMaterialOverrides = require("scripts/settings/equipment/item_material_overrides/player_material_overrides_eye_colors")
local HairMaterialOverrides = require("scripts/settings/equipment/item_material_overrides/player_material_overrides_hair_colors")
local HomePlanets = require("scripts/settings/character/home_planets")
local Childhood = require("scripts/settings/character/childhood")
local GrowingUp = require("scripts/settings/character/growing_up")
local FormativeEvent = require("scripts/settings/character/formative_event")
local Crimes = require("scripts/settings/character/crimes")
local Personalities = require("scripts/settings/character/personalities")
local Promise = require("scripts/foundation/utilities/promise")
local CharacterCreate = require("scripts/utilities/character_create")
local Items = require("scripts/utilities/items")
local DogFurOverrides = require("scripts/settings/equipment/item_material_overrides/player_material_overrides_dog_fur_color")
local DogSkinOverrides = require("scripts/settings/equipment/item_material_overrides/player_material_overrides_dog_skin_colors")
local DogCoatOverrides = require("scripts/settings/equipment/item_material_overrides/player_material_overrides_dog_coat_masks")
local DogOptionRestrictions = require("scripts/settings/character/companion_dog_restrictrions")
local APPEARANCE_GRID_TEMPLATES = {
	single = {
		grid_columns = 1,
	},
	double = {
		grid_columns = 2,
	},
	triple = {
		grid_columns = 3,
	},
}
local BREED_TO_EVENT_SUFFIX = {
	human = "human",
	ogryn = "ogryn",
}
local choices_presentation = {
	home_planet = {
		choice_title = "loc_character_birthplace_planet_title_name",
		description = "loc_character_creator_home_planet_introduction",
		icon_texture = "content/ui/textures/icons/generic/placeholder_childhood",
		title = "loc_character_create_title_home_planet",
		top_icon_texture = "content/ui/materials/icons/character_creator/home_planet",
	},
	childhood = {
		choice_title = "loc_character_childhood_title_name",
		description = "loc_character_creator_childhood_introduction",
		icon_texture = "content/ui/textures/icons/generic/placeholder_childhood",
		title = "loc_character_childhood_title_name",
		top_icon_texture = "content/ui/materials/icons/character_creator/childhood",
	},
	growing_up = {
		choice_title = "loc_character_growing_up_title_name",
		description = "loc_character_creator_growing_up_introduction",
		icon_texture = "content/ui/textures/icons/generic/placeholder_growingup",
		title = "loc_character_growing_up_title_name",
		top_icon_texture = "content/ui/materials/icons/character_creator/growth",
	},
	formative_event = {
		choice_title = "loc_character_event_title_name",
		description = "loc_character_creator_formative_event_introduction",
		icon_texture = "content/ui/textures/icons/generic/placeholder_formative",
		title = "loc_character_event_title_name",
		top_icon_texture = "content/ui/materials/icons/character_creator/accomplishment",
	},
	appearance = {
		choice_title = "loc_character_create_title_commendations",
		description = "loc_character_creator_commendations_introduction",
		icon_texture = "content/ui/textures/icons/generic/placeholder_formative",
		title = "loc_character_create_title_appearance",
		top_icon_texture = "content/ui/materials/icons/character_creator/appearence",
	},
	personality = {
		choice_title = "loc_character_create_title_commendations",
		description = "loc_character_creator_personality_introduction",
		icon_texture = "content/ui/textures/icons/generic/placeholder_childhood",
		title = "loc_character_create_title_personality",
		top_icon_texture = "content/ui/materials/icons/character_creator/personality",
	},
	crime = {
		choice_title = "loc_character_create_title_commendations",
		description = "loc_character_creator_sentence_introduction",
		icon_texture = "content/ui/textures/icons/generic/placeholder_childhood",
		title = "loc_character_create_title_crime",
		top_icon_texture = "content/ui/materials/icons/character_creator/sentence",
	},
}
local adamant_choices_presentation = {
	home_planet = {
		choice_title = "loc_character_birthplace_planet_title_name",
		description = "loc_character_creator_home_planet_introduction",
		icon_texture = "content/ui/textures/icons/generic/placeholder_childhood",
		title = "loc_character_create_title_home_planet",
		top_icon_texture = "content/ui/materials/icons/character_creator/home_planet",
	},
	childhood = {
		choice_title = "loc_character_childhood_title_name",
		description = "loc_character_creator_early_life_introduction",
		icon_texture = "content/ui/textures/icons/generic/placeholder_childhood",
		title = "loc_character_create_title_early_life",
		top_icon_texture = "content/ui/materials/icons/character_creator/childhood",
	},
	growing_up = {
		choice_title = "loc_character_growing_up_title_name",
		description = "loc_character_creator_key_event_introduction",
		icon_texture = "content/ui/textures/icons/generic/placeholder_growingup",
		title = "loc_character_create_title_key_event",
		top_icon_texture = "content/ui/materials/icons/character_creator/growth",
	},
	formative_event = {
		choice_title = "loc_character_event_title_name",
		description = "loc_character_creator_commendations_introduction",
		icon_texture = "content/ui/textures/icons/generic/placeholder_formative",
		title = "loc_character_create_title_commendations",
		top_icon_texture = "content/ui/materials/icons/character_creator/accomplishment",
	},
	appearance = {
		choice_title = "loc_character_create_title_commendations",
		description = "loc_character_creator_commendations_introduction",
		icon_texture = "content/ui/textures/icons/generic/placeholder_formative",
		title = "loc_character_create_title_appearance",
		top_icon_texture = "content/ui/materials/icons/character_creator/appearence",
	},
	personality = {
		choice_title = "loc_character_create_title_commendations",
		description = "loc_character_creator_personality_introduction",
		icon_texture = "content/ui/textures/icons/generic/placeholder_childhood",
		title = "loc_character_create_title_personality",
		top_icon_texture = "content/ui/materials/icons/character_creator/personality",
	},
	companion_appearance = {
		choice_title = "loc_character_create_title_commendations",
		description = "loc_character_creator_commendations_introduction",
		icon_texture = "content/ui/textures/icons/generic/placeholder_formative",
		title = "loc_character_create_title_appearance",
		top_icon_texture = "content/ui/materials/icons/character_creator/companion_appearence",
	},
	crime = {
		choice_title = "loc_character_create_title_commendations",
		description = "loc_character_creator_precinct_introduction",
		icon_texture = "content/ui/textures/icons/generic/placeholder_childhood",
		title = "loc_character_create_title_precinct",
		top_icon_texture = "content/ui/materials/icons/character_creator/sentence",
	},
}
local eye_types = {
	{
		icon_texture = "content/ui/textures/icons/appearances/eyes/eyes_r1_l1",
		name = "no_blind",
		sort_order = 1,
		search_params = {
			eye_blindness = 0,
			scalera_brightness = 1,
		},
	},
	{
		icon_texture = "content/ui/textures/icons/appearances/eyes/eyes_r0_l1",
		name = "blind_left",
		sort_order = 2,
		search_params = {
			eye_blindness = 2,
			scalera_brightness = 1,
		},
	},
	{
		icon_texture = "content/ui/textures/icons/appearances/eyes/eyes_r1_l0",
		name = "blind_right",
		sort_order = 3,
		search_params = {
			eye_blindness = 1,
			scalera_brightness = 1,
		},
	},
	{
		icon_texture = "content/ui/textures/icons/appearances/eyes/eyes_r0_l0",
		name = "blind_both",
		sort_order = 4,
		search_params = {
			eye_blindness = 3,
			scalera_brightness = 1,
		},
	},
	{
		icon_texture = "content/ui/textures/icons/appearances/eyes/eyes_r2_l2",
		name = "black_scalera",
		sort_order = 5,
		search_params = {
			eye_blindness = 0,
			scalera_brightness = 0,
		},
	},
}

local function continue_validation_item_slots(self, slots)
	for i = 1, #slots do
		local slot = slots[i]
		local selected_option = self._gamepad_focused_loadout and self._gamepad_focused_loadout[slot] and self._gamepad_focused_loadout[slot].original_value or self._character_create:slot_item(slot)
		local option = {
			value = selected_option,
		}
		local available = self._character_create:is_option_available(option)

		if not available then
			return false
		end
	end

	return true
end

local function add_gamepad_focused_slots(self, slot, option, optional_revert_function, optional_callback_function)
	self._gamepad_focused_loadout = self._gamepad_focused_loadout or {}

	local stored_option = self._character_create:slot_item(slot)

	self._gamepad_focused_loadout[slot] = self._gamepad_focused_loadout[slot] or {
		original_value = stored_option,
		revert_func = optional_revert_function or function ()
			local option = self._gamepad_focused_loadout[slot].original_value

			self._character_create:set_item_per_slot(slot, option)
		end,
		callback_function = optional_callback_function,
	}

	self._character_create:set_item_per_slot(slot, option)
end

local function remove_gamepad_focused_slots(self, slot, revert)
	if self._gamepad_focused_loadout and self._gamepad_focused_loadout[slot] then
		local original_value = self._gamepad_focused_loadout[slot].original_value

		if revert and self._gamepad_focused_loadout[slot].revert_func then
			self._gamepad_focused_loadout[slot].revert_func()
		end

		local callback_function = self._gamepad_focused_loadout[slot].callback_function

		self._gamepad_focused_loadout[slot] = nil

		if callback_function then
			callback_function(original_value)
		end
	end
end

local function get_eye_type_index_by_option(option)
	local override_name = option.material_overrides[1]
	local override_data = override_name and EyeMaterialOverrides[override_name] and EyeMaterialOverrides[override_name].property_overrides

	if override_data then
		for i = 1, #eye_types do
			local eye_type = eye_types[i]
			local search_params = eye_type.search_params

			if search_params then
				local found = true

				for name, value in pairs(search_params) do
					local override_value = override_data[name] and override_data[name][1]

					if override_value and value ~= override_value then
						found = false

						break
					end
				end

				if found then
					return i
				end
			end
		end
	end

	return 1
end

local function sort_by_order(appearance_a, appearance_b)
	if appearance_a.sort_order and appearance_b.sort_order then
		return appearance_a.sort_order < appearance_b.sort_order
	else
		return false
	end
end

local function sort_by_string_name(appearance_a, appearance_b)
	if appearance_a.dev_name and appearance_b.dev_name then
		return appearance_a.dev_name < appearance_b.dev_name
	else
		return false
	end
end

local CharacterAppearanceView = class("CharacterAppearanceView", "BaseView")

CharacterAppearanceView.init = function (self, settings, context)
	self._character_create = context.character_create
	self._context = context
	self._parent = context and context.parent

	if self._parent and self._parent.set_active_view_instance then
		self._parent:set_active_view_instance(self)
	end

	self._force_character_creation = context.force_character_creation
	self._is_barber_appearance = context.is_barber_appearance
	self._is_barber_companion_appearance = context.is_barber_companion_appearance
	self._is_barber_mindwipe = context.is_barber_mindwipe
	self._is_barber = context.is_barber_appearance or context.is_barber_mindwipe or context.is_barber_companion_appearance
	self._waiting_for_transform = false

	CharacterAppearanceView.super.init(self, Definitions, settings, context)

	if context.pass_draw ~= nil then
		self._pass_draw = context.pass_draw
	end

	if context.pass_input ~= nil then
		self._pass_input = context.pass_input
	end
end

CharacterAppearanceView.on_enter = function (self)
	self._character_create_promise = Promise:new()

	self._character_create_promise:next(function ()
		local input_manager = Managers.input
		local name = self.__class_name

		if not self._no_cursor then
			input_manager:push_cursor(name)

			self._cursor_pushed = true
		end

		self._update_scenegraph = true
		self._entered = true

		local enter_sound_events = self._settings.enter_sound_events

		if enter_sound_events then
			for i = 1, #enter_sound_events do
				local sound_event = enter_sound_events[i]

				self:_play_sound(sound_event)
			end
		end

		Managers.telemetry_events:open_view(self.view_name, false)

		self._profile_versions = table.clone(self._character_create:profile_value_versions())
		self._pages = self:_get_pages()
		self._page_grids = {}

		self:_register_event("update_character_sync_state", "_event_profile_sync_changed")

		local is_syncing = self._parent and self._parent._character_is_syncing or false

		self:_event_profile_sync_changed(is_syncing)
		self:_create_offscreen_renderer()
		self:_setup_input_legend()
		self:_setup_button_callbacks()
		self:_setup_profile_background()
		self:_create_page_indicators()

		self._character_name_status = {
			custom = false,
		}
		self._companion_name_status = {
			custom = false,
		}

		if not self._is_barber then
			self._character_create:reset_backstory()
		end

		if self._is_barber_mindwipe then
			self._page_open_vo = {
				[2] = CharacterAppearanceViewSettings.vo_event_mindwipe_backstory,
				[5] = CharacterAppearanceViewSettings.vo_event_mindwipe_body_type,
				[6] = CharacterAppearanceViewSettings.vo_event_mindwipe_personality,
			}

			local parent = self._parent

			if parent then
				parent:play_vo_events(CharacterAppearanceViewSettings.vo_event_mindwipe_select, "training_ground_psyker_a", nil, 0.2)
			end
		end

		self._character_create:reset_backstory()

		self._fade_animation_id = self:_start_animation("on_level_switch")

		self:_open_page(1)

		self._character_create_promise = nil
	end)

	if not self._character_create then
		local item_definitions = MasterItems.get_cached()
		local player = Managers.player:local_player(1)
		local profile = player:profile()

		self._original_name = player:name()
		self._original_companion_name = player:companion_name()
		self._original_loadout = table.clone_instance(profile.loadout)
		self._original_height = profile.personal and profile.personal.character_height
		self._fetch_all_profiles_promise = Managers.data_service.profiles:fetch_all_profiles():next(function (data)
			self._character_create = CharacterCreate:new(item_definitions, data.gear, profile)

			self._character_create_promise:resolve()

			self._fetch_all_profiles_promise = nil
		end):catch(function (error)
			self._character_create = CharacterCreate:new(item_definitions, {}, profile)

			self._character_create_promise:resolve()

			self._fetch_all_profiles_promise = nil
		end)
	else
		self._character_create_promise:resolve()
	end
end

CharacterAppearanceView._archetype_page_data = function (self)
	local profile = self._character_create:profile()
	local archetype = profile.archetype and profile.archetype.name

	if archetype == "adamant" then
		return adamant_choices_presentation
	else
		return choices_presentation
	end
end

CharacterAppearanceView._get_pages = function (self)
	local profile = self._character_create:profile()
	local archetype = profile.archetype and profile.archetype.name
	local planet_page = {
		name = "home_planet",
		on_enter = function (page)
			local widgets, widgets_by_name = self:_create_planet_widgets()

			self:_setup_page_widgets(widgets, widgets_by_name)

			local grids = page.grids

			if grids then
				for i = 1, #grids do
					local grid = grids[i]

					self:_populate_page_grid(i, grid)
				end
			end

			self._backstory_selection_page = true
		end,
		on_leave = function (page)
			if self._planet_background_animation_id then
				self:_stop_animation(self._planet_background_animation_id)

				self._planet_background_animation_id = nil
			end

			self:_destroy_page_widgets()

			self._backstory_selection_page = false
		end,
		grids = {
			{
				template = "button",
				init = function (grid_index, grid_data)
					return self:_generate_main_grid_widgets(grid_index, grid_data)
				end,
				options = function ()
					return self:_get_planet_options()
				end,
				selected_option = function ()
					local option = self._character_create:planet()

					return option and option.id
				end,
				on_reset = callback(self._character_create, "set_planet", nil),
				description = Localize(self:_archetype_page_data().home_planet.description),
				top_frame = function (grid, grid_size, grid_scenegraph)
					local page_data = self:_archetype_page_data().home_planet
					local passes = {
						{
							pass_type = "texture",
							style_id = "top_frame",
							value = "content/ui/materials/frames/character_creator_top",
							value_id = "top_frame",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "texture",
							style_id = "top_frame_extra",
							value = "content/ui/materials/effects/character_creator_top_candles",
							value_id = "top_frame_extra",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "text",
							style_id = "text_title",
							value_id = "text_title",
							value = Utf8.upper(Localize(page_data.title)),
							style = table.merge(table.clone(CharacterAppearanceViewFontStyle.header_text_style), {
								offset = {
									0,
									150,
									3,
								},
							}),
						},
						{
							pass_type = "texture",
							style_id = "icon",
							value_id = "icon",
							value = page_data.top_icon_texture,
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								size = {
									100,
									100,
								},
								offset = {
									0,
									30,
									2,
								},
							},
						},
					}
					local size = {
						485,
						230,
					}
					local offset = {
						-(size[1] - grid_size[1]) * 0.5,
						25 - size[2],
						0,
					}
					local definition = UIWidget.create_definition(passes, grid_scenegraph, nil, size)

					definition.offset = offset

					return definition
				end,
			},
		},
	}
	local childhood_page = {
		name = "childhood",
		on_enter = function (page)
			local widgets, widgets_by_name = self:_create_childhood_widgets()

			self:_setup_page_widgets(widgets, widgets_by_name)

			local grids = page.grids

			if grids then
				for i = 1, #grids do
					local grid = grids[i]

					self:_populate_page_grid(1, grid)
				end
			end

			self._backstory_selection_page = true
		end,
		on_leave = function (page)
			self:_destroy_page_widgets()

			self._backstory_selection_page = false
		end,
		grids = {
			{
				template = "button",
				init = function (grid_index, grid_data)
					return self:_generate_main_grid_widgets(grid_index, grid_data)
				end,
				options = function ()
					return self:_get_childhood_options()
				end,
				selected_option = function ()
					local option = self._character_create:childhood()

					return option and option.id
				end,
				on_reset = callback(self._character_create, "set_childhood"),
				description = Localize(self:_archetype_page_data().childhood.description),
				top_frame = function (grid, grid_size, grid_scenegraph)
					local page_data = self:_archetype_page_data().childhood
					local passes = {
						{
							pass_type = "texture",
							style_id = "top_frame",
							value = "content/ui/materials/frames/character_creator_top",
							value_id = "top_frame",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "texture",
							style_id = "top_frame_extra",
							value = "content/ui/materials/effects/character_creator_top_candles",
							value_id = "top_frame_extra",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "text",
							style_id = "text_title",
							value_id = "text_title",
							value = Utf8.upper(Localize(page_data.title)),
							style = table.merge(table.clone(CharacterAppearanceViewFontStyle.header_text_style), {
								offset = {
									0,
									150,
									3,
								},
							}),
						},
						{
							pass_type = "texture",
							style_id = "icon",
							value_id = "icon",
							value = page_data.top_icon_texture,
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								size = {
									100,
									100,
								},
								offset = {
									0,
									30,
									2,
								},
							},
						},
					}
					local size = {
						485,
						230,
					}
					local offset = {
						-(size[1] - grid_size[1]) * 0.5,
						25 - size[2],
						0,
					}
					local definition = UIWidget.create_definition(passes, grid_scenegraph, nil, size)

					definition.offset = offset

					return definition
				end,
			},
		},
	}
	local growing_up_page = {
		name = "growing_up",
		on_enter = function (page)
			local widgets, widgets_by_name = self:_create_growing_up_widgets()

			self:_setup_page_widgets(widgets, widgets_by_name)

			local grids = page.grids

			if grids then
				for i = 1, #grids do
					local grid = grids[i]

					self:_populate_page_grid(1, grid)
				end
			end

			self._backstory_selection_page = true
		end,
		on_leave = function (page)
			self:_destroy_page_widgets()

			self._backstory_selection_page = false
		end,
		grids = {
			{
				template = "button",
				init = function (grid_index, grid_data)
					return self:_generate_main_grid_widgets(grid_index, grid_data)
				end,
				options = function ()
					return self:_get_growing_up_options()
				end,
				selected_option = function ()
					local option = self._character_create:growing_up()

					return option and option.id
				end,
				on_reset = callback(self._character_create, "set_growing_up", nil),
				description = Localize(self:_archetype_page_data().growing_up.description),
				top_frame = function (grid, grid_size, grid_scenegraph)
					local page_data = self:_archetype_page_data().growing_up
					local passes = {
						{
							pass_type = "texture",
							style_id = "top_frame",
							value = "content/ui/materials/frames/character_creator_top",
							value_id = "top_frame",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "texture",
							style_id = "top_frame_extra",
							value = "content/ui/materials/effects/character_creator_top_candles",
							value_id = "top_frame_extra",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "text",
							style_id = "text_title",
							value_id = "text_title",
							value = Utf8.upper(Localize(page_data.title)),
							style = table.merge(table.clone(CharacterAppearanceViewFontStyle.header_text_style), {
								offset = {
									0,
									150,
									3,
								},
							}),
						},
						{
							pass_type = "texture",
							style_id = "icon",
							value_id = "icon",
							value = page_data.top_icon_texture,
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								size = {
									100,
									100,
								},
								offset = {
									0,
									30,
									2,
								},
							},
						},
					}
					local size = {
						485,
						230,
					}
					local offset = {
						-(size[1] - grid_size[1]) * 0.5,
						25 - size[2],
						0,
					}
					local definition = UIWidget.create_definition(passes, grid_scenegraph, nil, size)

					definition.offset = offset

					return definition
				end,
			},
		},
	}
	local formative_event_page = {
		name = "formative_event",
		show_character = false,
		show_companion = false,
		on_enter = function (page)
			local widgets, widgets_by_name = self:_create_formative_event_widgets()

			self:_setup_page_widgets(widgets, widgets_by_name)

			local grids = page.grids

			if grids then
				for i = 1, #grids do
					local grid = grids[i]

					self:_populate_page_grid(1, grid)
				end
			end

			self._backstory_selection_page = true
		end,
		on_leave = function (page)
			self:_destroy_page_widgets()

			self._backstory_selection_page = false
		end,
		grids = {
			{
				template = "button",
				init = function (grid_index, grid_data)
					return self:_generate_main_grid_widgets(grid_index, grid_data)
				end,
				options = function ()
					return self:_get_formative_event_options()
				end,
				selected_option = function ()
					local option = self._character_create:formative_event()

					return option and option.id
				end,
				on_reset = callback(self._character_create, "set_formative_event", nil),
				description = Localize(self:_archetype_page_data().formative_event.description),
				top_frame = function (page, grid_size, grid_scenegraph)
					local page_data = self:_archetype_page_data().formative_event
					local passes = {
						{
							pass_type = "texture",
							style_id = "top_frame",
							value = "content/ui/materials/frames/character_creator_top",
							value_id = "top_frame",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "texture",
							style_id = "top_frame_extra",
							value = "content/ui/materials/effects/character_creator_top_candles",
							value_id = "top_frame_extra",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "text",
							style_id = "text_title",
							value_id = "text_title",
							value = Utf8.upper(Localize(page_data.title)),
							style = table.merge(table.clone(CharacterAppearanceViewFontStyle.header_text_style), {
								offset = {
									0,
									150,
									3,
								},
							}),
						},
						{
							pass_type = "texture",
							style_id = "icon",
							value_id = "icon",
							value = page_data.top_icon_texture,
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								size = {
									100,
									100,
								},
								offset = {
									0,
									30,
									2,
								},
							},
						},
					}
					local size = {
						485,
						230,
					}
					local offset = {
						-(size[1] - grid_size[1]) * 0.5,
						25 - size[2],
						0,
					}
					local definition = UIWidget.create_definition(passes, grid_scenegraph, nil, size)

					definition.offset = offset

					return definition
				end,
			},
		},
	}
	local appearance_page = {
		name = "appearance",
		show_character = true,
		show_companion = false,
		on_enter = function (page)
			local widgets, widgets_by_name = self:_create_appearance_widgets()

			self:_setup_page_widgets(widgets, widgets_by_name)
			self:_update_appearance_background()
			self:_toggle_continue_alternative_action(true)

			local grids = page.grids

			if grids then
				for i = 1, #grids do
					local grid = grids[i]

					self:_populate_page_grid(1, grid)
				end
			end
		end,
		on_leave = function (page)
			self:_toggle_continue_alternative_action(false)
			self:_set_camera()
			self:_destroy_page_widgets()

			self._apperance_option_selected_index = nil
		end,
		update = function ()
			if self._is_barber_appearance then
				local no_modifications = true
				local profile = self._character_create and self._character_create:profile()
				local loadout = profile and profile.loadout

				if loadout then
					local items = {
						slot_body_face = loadout.slot_body_face,
						slot_body_face_tattoo = loadout.slot_body_face_tattoo,
						slot_body_face_scar = loadout.slot_body_face_scar,
						slot_body_face_hair = loadout.slot_body_face_hair,
						slot_body_hair = loadout.slot_body_hair,
						slot_body_tattoo = loadout.slot_body_tattoo,
						slot_body_hair_color = loadout.slot_body_hair_color,
						slot_body_skin_color = loadout.slot_body_skin_color,
						slot_body_eye_color = loadout.slot_body_eye_color,
					}

					no_modifications = not self:_filter_changed_items(items)
				end

				self:_update_continue_button("slot_modifications", no_modifications)
			end
		end,
		grids = {
			{
				template = "category_button",
				init = function (grid_index, grid_data)
					grid_data.focused_on_gamepad_navigation = true

					return self:_generate_main_grid_widgets(grid_index, grid_data)
				end,
				options = function ()
					return self:_get_appearance_options()
				end,
				selected_option = function ()
					return self._apperance_option_selected_index
				end,
				top_frame = function (page, grid_size, grid_scenegraph)
					local page_data = self:_archetype_page_data().appearance
					local passes = {
						{
							pass_type = "texture",
							style_id = "top_frame",
							value = "content/ui/materials/frames/character_creator_top",
							value_id = "top_frame",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "texture",
							style_id = "top_frame_extra",
							value = "content/ui/materials/effects/character_creator_top_candles",
							value_id = "top_frame_extra",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "text",
							style_id = "text_title",
							value_id = "text_title",
							value = Utf8.upper(Localize(page_data.title)),
							style = table.merge(table.clone(CharacterAppearanceViewFontStyle.header_text_style), {
								offset = {
									0,
									150,
									3,
								},
							}),
						},
						{
							pass_type = "texture",
							style_id = "icon",
							value_id = "icon",
							value = page_data.top_icon_texture,
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								size = {
									100,
									100,
								},
								offset = {
									0,
									30,
									2,
								},
							},
						},
					}
					local size = {
						485,
						230,
					}
					local offset = {
						-(size[1] - grid_size[1]) * 0.5,
						25 - size[2],
						0,
					}
					local definition = UIWidget.create_definition(passes, grid_scenegraph, nil, size)

					definition.offset = offset

					return definition
				end,
			},
		},
	}
	local companion_appearance_page = {
		name = "companion_appearance",
		show_character = false,
		on_enter = function (page)
			self:_toggle_continue_alternative_action(true)

			local widgets, widgets_by_name = self:_create_appearance_widgets()

			self:_setup_page_widgets(widgets, widgets_by_name)
			self:_update_appearance_background()

			local grids = page.grids

			if grids then
				for i = 1, #grids do
					local grid = grids[i]

					self:_populate_page_grid(1, grid)
				end
			end
		end,
		on_leave = function (page)
			self:_toggle_continue_alternative_action(false)
			self:_destroy_page_widgets()

			self._apperance_option_selected_index = nil
		end,
		grids = {
			{
				template = "category_button",
				init = function (grid_index, grid_data)
					grid_data.focused_on_gamepad_navigation = true

					return self:_generate_main_grid_widgets(grid_index, grid_data)
				end,
				options = function ()
					return self:_get_companion_appearance_options()
				end,
				selected_option = function ()
					return self._apperance_option_selected_index
				end,
				top_frame = function (page, grid_size, grid_scenegraph)
					local page_data = self:_archetype_page_data().companion_appearance
					local passes = {
						{
							pass_type = "texture",
							style_id = "top_frame",
							value = "content/ui/materials/frames/character_creator_top",
							value_id = "top_frame",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "texture",
							style_id = "top_frame_extra",
							value = "content/ui/materials/effects/character_creator_top_candles",
							value_id = "top_frame_extra",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "text",
							style_id = "text_title",
							value_id = "text_title",
							value = Utf8.upper(Localize("loc_arbites_customization_dog_title")),
							style = table.merge(table.clone(CharacterAppearanceViewFontStyle.header_text_style), {
								offset = {
									0,
									150,
									3,
								},
							}),
						},
						{
							pass_type = "texture",
							style_id = "icon",
							value_id = "icon",
							value = page_data.top_icon_texture,
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								size = {
									100,
									100,
								},
								offset = {
									0,
									30,
									2,
								},
							},
						},
					}
					local size = {
						485,
						230,
					}
					local offset = {
						-(size[1] - grid_size[1]) * 0.5,
						25 - size[2],
						0,
					}
					local definition = UIWidget.create_definition(passes, grid_scenegraph, nil, size)

					definition.offset = offset

					return definition
				end,
			},
		},
		show_companion = archetype == "adamant" and not self._is_barber_mindwipe,
		update = function ()
			if self._is_barber_appearance then
				local no_modifications = true
				local profile = self._character_create and self._character_create:profile()
				local loadout = profile and profile.loadout

				if loadout then
					local items = {
						slot_companion_body_skin_color = loadout.slot_companion_body_skin_color,
						slot_companion_body_fur_color = loadout.slot_companion_body_fur_color,
						slot_companion_body_coat_pattern = loadout.slot_companion_body_coat_pattern,
					}

					no_modifications = not self:_filter_changed_items(items)
				end

				self:_update_continue_button("slot_modifications", no_modifications)
			end
		end,
	}
	local personality_page = {
		name = "personality",
		show_character = true,
		show_companion = false,
		on_enter = function (page, previous_page)
			local grids = page.grids

			if grids then
				for i = 1, #grids do
					local grid = grids[i]

					self:_populate_page_grid(1, grid)
				end
			end

			if self._is_barber_mindwipe and previous_page.index < page.index then
				self._in_barber_chair = true

				self._profile_spawner:disable_rotation_input(self._in_barber_chair)
			end
		end,
		on_leave = function (page, next_page)
			self:_play_sound(UISoundEvents.character_appearence_stop_voice_preview)

			if self._is_barber_mindwipe and next_page.index < page.index then
				self._in_barber_chair = false

				self._profile_spawner:disable_rotation_input(self._in_barber_chair)
			end
		end,
		grids = {
			{
				template = "personality_button",
				init = function (grid_index, grid_data)
					return self:_generate_main_grid_widgets(grid_index, grid_data)
				end,
				options = function ()
					return self:_get_personality_options()
				end,
				selected_option = function ()
					local option = self._character_create:personality()

					return option and option.id
				end,
				description = Localize(self:_archetype_page_data().personality.description),
				top_frame = function (page, grid_size, grid_scenegraph)
					local page_data = self:_archetype_page_data().personality
					local passes = {
						{
							pass_type = "texture",
							style_id = "top_frame",
							value = "content/ui/materials/frames/character_creator_top",
							value_id = "top_frame",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "texture",
							style_id = "top_frame_extra",
							value = "content/ui/materials/effects/character_creator_top_candles",
							value_id = "top_frame_extra",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "text",
							style_id = "text_title",
							value_id = "text_title",
							value = Utf8.upper(Localize(page_data.title)),
							style = table.merge(table.clone(CharacterAppearanceViewFontStyle.header_text_style), {
								offset = {
									0,
									150,
									3,
								},
							}),
						},
						{
							pass_type = "texture",
							style_id = "icon",
							value_id = "icon",
							value = page_data.top_icon_texture,
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								size = {
									100,
									100,
								},
								offset = {
									0,
									30,
									2,
								},
							},
						},
					}
					local size = {
						485,
						230,
					}
					local offset = {
						-(size[1] - grid_size[1]) * 0.5,
						25 - size[2],
						0,
					}
					local definition = UIWidget.create_definition(passes, grid_scenegraph, nil, size)

					definition.offset = offset

					return definition
				end,
			},
		},
	}
	local crime_page = {
		gear_visible = true,
		name = "crime",
		show_character = true,
		on_enter = function (page, previous_page)
			local grids = page.grids

			if grids then
				for i = 1, #grids do
					local grid = grids[i]

					self:_populate_page_grid(1, grid)
				end
			end

			if previous_page.index < page.index and not self._is_barber_mindwipe then
				self._character_create:set_gear_visible(true)
			end
		end,
		on_leave = function (page, next_page)
			if next_page.index < page.index and not self._is_barber_mindwipe then
				self._character_create:set_gear_visible(false)
			end
		end,
		grids = {
			{
				template = "button",
				init = function (grid_index, grid_data)
					return self:_generate_main_grid_widgets(grid_index, grid_data)
				end,
				options = function ()
					return self:_get_crime_options()
				end,
				selected_option = function ()
					local option = self._character_create:crime()

					return option and option.id
				end,
				description = Localize(self:_archetype_page_data().crime.description),
				top_frame = function (page, grid_size, grid_scenegraph)
					local page_data = self:_archetype_page_data().crime
					local passes = {
						{
							pass_type = "texture",
							style_id = "top_frame",
							value = "content/ui/materials/frames/character_creator_top",
							value_id = "top_frame",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "texture",
							style_id = "top_frame_extra",
							value = "content/ui/materials/effects/character_creator_top_candles",
							value_id = "top_frame_extra",
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								offset = {
									0,
									0,
									2,
								},
							},
						},
						{
							pass_type = "text",
							style_id = "text_title",
							value_id = "text_title",
							value = Utf8.upper(Localize(page_data.title)),
							style = table.merge(table.clone(CharacterAppearanceViewFontStyle.header_text_style), {
								offset = {
									0,
									150,
									3,
								},
							}),
						},
						{
							pass_type = "texture",
							style_id = "icon",
							value_id = "icon",
							value = page_data.top_icon_texture,
							style = {
								horizontal_alignment = "center",
								vertical_alignment = "top",
								size = {
									100,
									100,
								},
								offset = {
									0,
									30,
									2,
								},
							},
						},
					}
					local size = {
						485,
						230,
					}
					local offset = {
						-(size[1] - grid_size[1]) * 0.5,
						25 - size[2],
						0,
					}
					local definition = UIWidget.create_definition(passes, grid_scenegraph, nil, size)

					definition.offset = offset

					return definition
				end,
			},
		},
		show_companion = archetype == "adamant" and not self._is_barber_mindwipe,
		on_continue = function (page)
			return self:_fetch_suggested_names()
		end,
	}
	local name_page = {
		gear_visible = true,
		name = "name",
		show_character = true,
		show_companion = archetype == "adamant" and not self._is_barber_mindwipe,
		on_enter = function (page)
			self:_toggle_continue_alternative_action(true)

			local grids = page.grids

			if grids then
				for i = 1, #grids do
					local grid = grids[i]

					self:_populate_page_grid(1, grid)
				end
			end

			self:_pan_camera()

			local support_widgets = self._page_grids and self._page_grids[1] and self._page_grids[1].support_widgets_by_name
			local input_widget = support_widgets and support_widgets.name_input
			local name = input_widget and input_widget.content.input_text

			if input_widget and name then
				self:_check_input_errors(input_widget, name)
			end
		end,
		on_leave = function (page, next_page)
			self:_toggle_continue_alternative_action(false)

			if next_page.index < page.index then
				self:_pan_camera(true)
			end
		end,
		update = function ()
			local support_widgets = self._page_grids and self._page_grids[1] and self._page_grids[1].support_widgets_by_name
			local input_widget = support_widgets and support_widgets.name_input

			if input_widget then
				if self._using_cursor_navigation then
					input_widget.content.hotspot.is_selected = false
					input_widget.content.hotspot.is_focused = false
				else
					input_widget.content.hotspot.is_selected = true
					input_widget.content.hotspot.is_focused = true
				end
			end
		end,
		on_continue = function (page)
			if not self._character_name_status.custom then
				return
			end

			self:_show_loading_awaiting_validation(true)

			local name = self._character_create:name()

			return self._character_create:check_name(name):next(function (data)
				self:_show_loading_awaiting_validation(false)

				if data.permitted == false then
					local support_widgets = self._page_grids and self._page_grids[1] and self._page_grids[1].support_widgets_by_name
					local error_widget = support_widgets and support_widgets.error
					local input_widget = support_widgets and support_widgets.name_input

					if error_widget then
						error_widget.content.text = input_widget and input_widget.content.error_message or ""
					end

					return false
				end

				return true
			end):catch(function (error)
				self:_show_loading_awaiting_validation(false)

				return false
			end)
		end,
		grids = {
			{
				init = function (grid_index, grid_data)
					return self:_generate_final_page_widgets(grid_index, grid_data)
				end,
			},
		},
	}
	local name_companion_page = {
		gear_visible = true,
		name = "name_companion",
		show_character = true,
		show_companion = archetype == "adamant" and not self._is_barber_mindwipe,
		on_enter = function (page)
			self:_toggle_continue_alternative_action(true)

			local grids = page.grids

			if grids then
				for i = 1, #grids do
					local grid = grids[i]

					self:_populate_page_grid(1, grid)
				end
			end

			local support_widgets = self._page_grids and self._page_grids[1] and self._page_grids[1].support_widgets_by_name
			local input_widget = support_widgets and support_widgets.companion_name_input
			local name = input_widget and input_widget.content.input_text

			if input_widget and name then
				self:_check_input_errors(input_widget, name)
			end
		end,
		update = function ()
			local support_widgets = self._page_grids and self._page_grids[1] and self._page_grids[1].support_widgets_by_name
			local input_widget = support_widgets and support_widgets.companion_name_input

			if input_widget then
				if self._using_cursor_navigation then
					input_widget.content.hotspot.is_selected = false
					input_widget.content.hotspot.is_focused = false
				else
					input_widget.content.hotspot.is_selected = true
					input_widget.content.hotspot.is_focused = true
				end
			end
		end,
		on_leave = function ()
			self:_toggle_continue_alternative_action(false)
		end,
		on_continue = function (page)
			if not self._companion_name_status.custom then
				return
			end

			self:_show_loading_awaiting_validation(true)

			local name = self._character_create:companion_name()

			return self._character_create:check_companion_name(name):next(function (data)
				self:_show_loading_awaiting_validation(false)

				if data.permitted == false then
					local support_widgets = self._page_grids and self._page_grids[1] and self._page_grids[1].support_widgets_by_name
					local error_widget = support_widgets and support_widgets.error
					local input_widget = support_widgets and support_widgets.companion_name_input

					if error_widget then
						error_widget.content.text = input_widget and input_widget.content.error_message or ""
					end

					return false
				end

				return true
			end):catch(function (error)
				self:_show_loading_awaiting_validation(false)

				return false
			end)
		end,
		grids = {
			{
				init = function (grid_index, grid_data)
					return self:_generate_final_page_widgets(grid_index, grid_data, true)
				end,
			},
		},
	}
	local pages

	if self._is_barber_appearance then
		pages = {
			appearance_page,
		}
	elseif self._is_barber_companion_appearance then
		pages = {
			companion_appearance_page,
		}
	elseif archetype == "adamant" and self._is_barber_mindwipe then
		pages = {
			planet_page,
			childhood_page,
			growing_up_page,
			formative_event_page,
			appearance_page,
			personality_page,
			crime_page,
			name_page,
			name_companion_page,
		}
	elseif archetype == "adamant" then
		pages = {
			planet_page,
			childhood_page,
			growing_up_page,
			formative_event_page,
			appearance_page,
			personality_page,
			companion_appearance_page,
			crime_page,
			name_page,
			name_companion_page,
		}
	else
		pages = {
			planet_page,
			childhood_page,
			growing_up_page,
			formative_event_page,
			appearance_page,
			personality_page,
			crime_page,
			name_page,
		}
	end

	for i = 1, #pages do
		pages[i].index = i
	end

	return pages
end

CharacterAppearanceView._setup_page_widgets = function (self, widgets, widgets_by_name)
	self:_destroy_page_widgets()

	self._page_widgets = widgets
	self._page_widgets_by_name = widgets_by_name
end

CharacterAppearanceView._create_planet_widgets = function (self)
	local material = "content/ui/materials/base/ui_default_base"
	local textures = {
		{
			value = "content/ui/textures/backgrounds/backstory/home_planet_1",
			position = {
				0,
				0,
			},
			size = {
				2754,
				1600,
			},
		},
		{
			value = "content/ui/textures/backgrounds/backstory/home_planet_2",
			position = {
				2754,
				0,
			},
			size = {
				2754,
				1600,
			},
		},
		{
			value = "content/ui/textures/backgrounds/backstory/home_planet_3",
			position = {
				0,
				1600,
			},
			size = {
				2754,
				1600,
			},
		},
		{
			value = "content/ui/textures/backgrounds/backstory/home_planet_4",
			position = {
				2754,
				1600,
			},
			size = {
				2754,
				1600,
			},
		},
	}
	local background_planet_passes = {}

	for i = 1, #textures do
		local texture = textures[i]

		background_planet_passes[#background_planet_passes + 1] = {
			pass_type = "texture",
			value_id = "background_" .. i,
			style_id = "background_" .. i,
			value = material,
			style = {
				size = texture.size,
				offset = {
					texture.position[1],
					texture.position[2],
					0,
				},
				material_values = {
					texture_map = texture.value,
				},
			},
		}
	end

	local background_planet_definitions = UIWidget.create_definition(background_planet_passes, "screen", nil, {
		5508,
		3200,
	})
	local background_planet_widget = self:_create_widget("background_planet", background_planet_definitions)
	local planet_passes = {}
	local planet_widgets_by_name = {}

	for id, data in pairs(HomePlanets) do
		local name = id
		local planet_image = data.image
		local planet_size = planet_image.size
		local planet_position = data.position
		local planet_pass = {
			pass_type = "texture",
			value = "content/ui/materials/base/ui_default_base",
			value_id = name,
			style_id = name,
			style = {
				offset = {
					planet_position[1],
					planet_position[2],
					3,
				},
				size = planet_size,
				size_addition = {
					-planet_size[1],
					-planet_size[2],
				},
				material_values = {
					texture_map = planet_image.path,
				},
			},
		}

		planet_passes[#planet_passes + 1] = planet_pass
	end

	local planets_definition = UIWidget.create_definition(planet_passes, "screen")
	local planet_widget = self:_create_widget("home_planets", planets_definition)
	local widgets = {
		background_planet_widget,
		planet_widget,
	}
	local widgets_by_name = {
		background = background_planet_widget,
		planets = planet_widget,
	}

	return widgets, widgets_by_name
end

CharacterAppearanceView._create_childhood_widgets = function (self)
	local widgets = {}
	local material = "content/ui/materials/backgrounds/backstory/childhood"
	local textures = {
		{
			size = {
				1920,
				1080,
			},
			position = {
				0,
				0,
			},
		},
	}
	local background_passes = {}

	background_passes[#background_passes + 1] = {
		pass_type = "rect",
		style = {
			color = Color.black(255, true),
		},
	}

	for i = 1, #textures do
		local texture = textures[i]

		background_passes[#background_passes + 1] = {
			pass_type = "texture",
			value_id = "background_" .. i,
			style_id = "background_" .. i,
			value = material,
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = texture.size,
				offset = {
					texture.position[1],
					texture.position[2],
					0,
				},
			},
		}
	end

	local background_definitions = UIWidget.create_definition(background_passes, "screen")
	local widget = self:_create_widget("background_page", background_definitions)
	local widgets = {
		widget,
	}
	local widgets_by_name = {
		background = widget,
	}

	return widgets, widgets_by_name
end

CharacterAppearanceView._create_growing_up_widgets = function (self)
	local widgets = {}
	local material = "content/ui/materials/backgrounds/backstory/growing_up"
	local textures = {
		{
			size = {
				1920,
				1080,
			},
			position = {
				0,
				0,
			},
		},
	}
	local background_passes = {}

	background_passes[#background_passes + 1] = {
		pass_type = "rect",
		style = {
			color = Color.black(255, true),
		},
	}

	for i = 1, #textures do
		local texture = textures[i]

		background_passes[#background_passes + 1] = {
			pass_type = "texture",
			value_id = "background_" .. i,
			style_id = "background_" .. i,
			value = material,
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = texture.size,
				offset = {
					texture.position[1],
					texture.position[2],
					0,
				},
			},
		}
	end

	local background_definitions = UIWidget.create_definition(background_passes, "screen")
	local widget = self:_create_widget("background_page", background_definitions)
	local widgets = {
		widget,
	}
	local widgets_by_name = {
		background = widget,
	}

	return widgets
end

CharacterAppearanceView._create_formative_event_widgets = function (self)
	local widgets = {}
	local material = "content/ui/materials/backgrounds/backstory/formative_event"
	local textures = {
		{
			size = {
				1920,
				1080,
			},
			position = {
				0,
				0,
			},
		},
	}
	local background_passes = {}

	background_passes[#background_passes + 1] = {
		pass_type = "rect",
		style = {
			color = Color.black(255, true),
		},
	}

	for i = 1, #textures do
		local texture = textures[i]

		background_passes[#background_passes + 1] = {
			pass_type = "texture",
			value_id = "background_" .. i,
			style_id = "background_" .. i,
			value = material,
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = texture.size,
				offset = {
					texture.position[1],
					texture.position[2],
					0,
				},
			},
		}
	end

	local background_definitions = UIWidget.create_definition(background_passes, "screen")
	local widget = self:_create_widget("background_page", background_definitions)
	local widgets = {
		widget,
	}
	local widgets_by_name = {
		background = widget,
	}

	return widgets
end

CharacterAppearanceView._create_appearance_widgets = function (self)
	local background_definiton = UIWidget.create_definition({
		{
			pass_type = "texture",
			style_id = "top_frame",
			value = "content/ui/materials/dividers/horizontal_frame_big_upper",
			value_id = "top_frame",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top",
				size = {
					nil,
					36,
				},
				offset = {
					0,
					-18,
					1,
				},
			},
		},
		{
			pass_type = "texture",
			style_id = "background",
			value = "content/ui/materials/backgrounds/terminal_basic",
			value_id = "background",
			style = {
				horizontal_alignment = "center",
				scale_to_material = true,
				vertical_alignment = "top",
				color = Color.terminal_grid_background(nil, true),
				size_addition = {
					20,
					30,
				},
				offset = {
					0,
					-15,
					0,
				},
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/dividers/horizontal_frame_big_lower",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				size = {
					nil,
					36,
				},
				offset = {
					0,
					18,
					2,
				},
			},
		},
	}, "grid_2_pivot", nil, {
		0,
		0,
	})
	local widget = self:_create_widget("background_appearance", background_definiton)
	local widgets = {
		widget,
	}
	local widgets_by_name = {
		background = widget,
	}

	return widgets, widgets_by_name
end

CharacterAppearanceView._destroy_page_widgets = function (self)
	if self._page_widgets then
		for i = 1, #self._page_widgets do
			local widget = self._page_widgets[i]
			local widget_name = widget.name

			self:_unregister_widget_name(widget_name)
		end
	end

	self._page_widgets = nil
	self._page_widgets_by_name = nil
end

CharacterAppearanceView._get_childhood_options = function (self)
	local childhood = self._character_create:childhood_options()
	local childhood_options = {}

	for id, option in pairs(childhood) do
		childhood_options[#childhood_options + 1] = {
			data = option,
			text = Localize(option.display_name),
			value = id,
			on_pressed_function = function ()
				self._character_create:set_childhood(id)

				local grid_index = 2
				local grid_data = {
					init = function ()
						return self:_generate_backstory_grid_widgets(grid_index, option)
					end,
				}

				self:_populate_page_grid(grid_index, grid_data)
			end,
		}
	end

	return childhood_options
end

CharacterAppearanceView._get_growing_up_options = function (self)
	local growing_up = self._character_create:growing_up_options()
	local growing_up_options = {}

	for id, option in pairs(growing_up) do
		growing_up_options[#growing_up_options + 1] = {
			data = option,
			text = Localize(option.display_name),
			value = id,
			on_pressed_function = function ()
				self._character_create:set_growing_up(id)

				local grid_index = 2
				local grid_data = {
					init = function ()
						return self:_generate_backstory_grid_widgets(grid_index, option)
					end,
				}

				self:_populate_page_grid(grid_index, grid_data)
			end,
		}
	end

	return growing_up_options
end

CharacterAppearanceView._get_formative_event_options = function (self)
	local formative_events = self._character_create:formative_event_options()
	local formative_events_options = {}

	for id, option in pairs(formative_events) do
		formative_events_options[#formative_events_options + 1] = {
			data = option,
			text = Localize(option.display_name),
			value = id,
			on_pressed_function = function ()
				self._character_create:set_formative_event(id)

				local grid_index = 2
				local grid_data = {
					init = function ()
						return self:_generate_backstory_grid_widgets(grid_index, option)
					end,
				}

				self:_populate_page_grid(grid_index, grid_data)
			end,
		}
	end

	return formative_events_options
end

CharacterAppearanceView._create_offscreen_renderer = function (self)
	local view_name = self.view_name
	local world_layer = 10
	local world_name = self.__class_name .. "_ui_offscreen_world"
	local world = Managers.ui:create_world(world_name, world_layer, nil, view_name)
	local viewport_name = "offscreen_viewport"
	local viewport_type = "overlay_offscreen"
	local viewport_layer = 1
	local viewport = Managers.ui:create_viewport(world, viewport_name, viewport_type, viewport_layer)
	local renderer_name = self.__class_name .. "offscreen_renderer"

	self._offscreen_renderer = Managers.ui:create_renderer(renderer_name, world)
	self._offscreen_world = {
		name = world_name,
		world = world,
		viewport = viewport,
		viewport_name = viewport_name,
		renderer_name = renderer_name,
	}
end

CharacterAppearanceView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 10)

	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

CharacterAppearanceView._setup_button_callbacks = function (self)
	self._widgets_by_name.continue_button.content.hotspot.pressed_callback = callback(self, "_on_continue_pressed")
end

CharacterAppearanceView._setup_profile_background = function (self)
	local profile = self._character_create:profile()
	local selected_archetype = profile.archetype
	local selected_archetype_name = selected_archetype.name

	self._widgets_by_name.corners.content.left_upper = UISettings.inventory_frames_by_archetype[selected_archetype_name].right_upper
	self._widgets_by_name.corners.content.right_upper = UISettings.inventory_frames_by_archetype[selected_archetype_name].right_upper
	self._widgets_by_name.corners.content.left_lower = UISettings.inventory_frames_by_archetype[selected_archetype_name].left_lower
	self._widgets_by_name.corners.content.right_lower = UISettings.inventory_frames_by_archetype[selected_archetype_name].right_lower
end

CharacterAppearanceView.event_register_character_spawn_point = function (self, spawn_point_unit)
	self:_unregister_event("event_register_character_spawn_point")

	self._spawn_point_unit = spawn_point_unit

	local spawn_position = Unit.world_position(spawn_point_unit, 1)

	self._spawn_point_position = Vector3.to_array(spawn_position)

	self:_spawn_profile(spawn_point_unit)
end

CharacterAppearanceView.event_register_companion_spawn_point = function (self, spawn_point_unit)
	self:_unregister_event("event_register_companion_spawn_point")

	local spawn_position = Unit.world_position(spawn_point_unit, 1)

	self._companion_spawn_point_position = Vector3.to_array(spawn_position)
end

CharacterAppearanceView._spawn_profile = function (self, spawn_point_unit, optional_state_machine, optional_animation_event)
	local spawn_position = Unit.world_position(spawn_point_unit, 1)
	local spawn_rotation = Unit.world_rotation(spawn_point_unit, 1)
	local profile = self._character_create:profile()
	local height = self._character_create:height()
	local scale = Vector3.one() * height

	if self._is_barber_mindwipe and self._in_barber_chair then
		scale = Vector3.one()
	end

	local active_page_number = self._active_page_number
	local active_page = self._pages[self._active_page_number]
	local show_character = active_page.show_character
	local show_companion = active_page.show_companion

	if self._profile_spawner then
		self._profile_spawner:destroy()

		self._profile_spawner = nil
	end

	local world = self._world_spawner:world()
	local camera = self._world_spawner:camera()
	local unit_spawner = self._world_spawner:unit_spawner()

	if show_companion or show_character then
		self._profile_spawner = UIProfileSpawner:new("CharacterAppearanceView", world, camera, unit_spawner)

		local companion_data = {}

		if self._companion_spawn_point_position then
			companion_data.position = Vector3.from_array(self._companion_spawn_point_position)
		end

		self._profile_spawner:spawn_profile(profile, spawn_position, spawn_rotation, scale, nil, nil, nil, nil, nil, nil, nil, nil, companion_data)
		self._profile_spawner:toggle_companion(show_companion)
		self._profile_spawner:toggle_character(show_character)

		local archetype_settings = profile.archetype
		local archetype_name = archetype_settings.name
		local breed_name = archetype_settings.breed
		local breed_settings = Breeds[breed_name]
		local character_creation_state_machine = breed_settings.character_creation_state_machine
		local animations_per_archetype = CharacterAppearanceViewSettings.animations_per_archetype
		local animations_settings = animations_per_archetype[archetype_name]
		local animation_event = animations_settings.initial_event

		if optional_state_machine == nil then
			self._profile_spawner:assign_state_machine(character_creation_state_machine, animation_event)
		elseif optional_animation_event ~= nil then
			self._profile_spawner:assign_state_machine(optional_state_machine, optional_animation_event)
		end
	end
end

CharacterAppearanceView._on_continue_pressed = function (self)
	if not self._using_cursor_navigation then
		self:_play_sound(UISoundEvents.character_appearence_confirm)
	end

	local active_page_number = self._active_page_number
	local active_page = self._pages[self._active_page_number]
	local continue_promise

	self:_update_continue_button("continue_validation", true)

	if active_page.on_continue then
		continue_promise = active_page.on_continue(active_page)
	end

	continue_promise = continue_promise or Promise.resolved(true)

	continue_promise:next(function (result)
		self:_update_continue_button("continue_validation", false)

		if result then
			local next_page_index = active_page_number + 1
			local next_page = self._pages[next_page_index]

			if next_page then
				self:_open_page(next_page_index)
			else
				self:_show_final_popup()
			end
		end
	end)
end

CharacterAppearanceView._show_final_popup = function (self)
	local context

	if self._is_barber_mindwipe then
		local parent = self._parent
		local mindwipe_cost = parent._cost
		local balance_amount = parent._balance

		context = {
			description_text = "loc_popup_description_barber_finalise_mindwipe",
			title_text = "loc_popup_header_barber_finalise_mindwipe",
			description_text_params = {
				cost = mindwipe_cost,
				balance = balance_amount,
			},
			options = {
				{
					close_on_pressed = true,
					stop_exit_sound = true,
					text = "loc_barber_vendor_confirm_button",
					on_pressed_sound = UISoundEvents.finalize_creation_confirm,
					callback = callback(function ()
						if not self.__deleted then
							local character_create = self._character_create
							local height = character_create:height()
							local player = Managers.player:local_player(1)
							local real_character_id = player:character_id()

							self._confirm_popup_id = nil

							local operation_cost = parent:get_mindwipe_cost()

							character_create:transform(real_character_id, operation_cost)

							self._waiting_for_transform = true
						end
					end),
				},
				{
					close_on_pressed = true,
					hotkey = "back",
					template_type = "terminal_button_small",
					text = "loc_popup_button_cancel",
					callback = callback(function ()
						self._confirm_popup_id = nil
					end),
				},
			},
		}
	elseif self._is_barber_appearance or self._is_barber_companion_appearance then
		context = {
			description_text = "loc_popup_description_barber_finalise_changes",
			title_text = "loc_popup_header_barber_finalise_changes",
			options = {
				{
					close_on_pressed = true,
					stop_exit_sound = true,
					text = "loc_barber_vendor_confirm_button",
					on_pressed_sound = UISoundEvents.finalize_creation_confirm,
					callback = callback(function ()
						if not self.__deleted then
							local character_create = self._character_create
							local height = character_create:height()
							local profile = character_create and character_create:profile()
							local loadout = profile and profile.loadout

							if loadout then
								local items = {
									slot_body_face = loadout.slot_body_face,
									slot_body_face_tattoo = loadout.slot_body_face_tattoo,
									slot_body_face_scar = loadout.slot_body_face_scar,
									slot_body_face_hair = loadout.slot_body_face_hair,
									slot_body_hair = loadout.slot_body_hair,
									slot_body_tattoo = loadout.slot_body_tattoo,
									slot_body_hair_color = loadout.slot_body_hair_color,
									slot_body_skin_color = loadout.slot_body_skin_color,
									slot_body_eye_color = loadout.slot_body_eye_color,
									slot_companion_body_coat_pattern = loadout.slot_companion_body_coat_pattern,
									slot_companion_body_fur_color = loadout.slot_companion_body_fur_color,
									slot_companion_body_skin_color = loadout.slot_companion_body_skin_color,
								}
								local changed_items = self:_filter_changed_items(items)

								if changed_items then
									Items.equip_slot_master_items(changed_items)
								end

								local player = Managers.player:local_player(1)
								local real_profile = player:profile()
								local real_unit = player.player_unit
								local character_id = real_profile.character_id

								if height ~= self._original_height then
									Managers.backend.interfaces.characters:set_character_height(character_id, height)
									Unit.set_local_scale(real_unit, 1, Vector3.one() * height)
								end
							end

							local parent = self._parent

							if parent then
								parent:play_vo_events(CharacterAppearanceViewSettings.vo_event_vendor_purchase, "barber_a", nil, 1.7)

								parent._active_view_instance = nil

								parent:_handle_back_pressed()
							end

							self._confirm_popup_id = nil
						end
					end),
				},
				{
					close_on_pressed = true,
					hotkey = "back",
					template_type = "terminal_button_small",
					text = "loc_popup_button_cancel",
					callback = callback(function ()
						self._confirm_popup_id = nil
					end),
				},
			},
		}
	else
		context = {
			description_text = "loc_popup_description_create_character",
			title_text = "loc_popup_header_create_character",
			options = {
				{
					close_on_pressed = true,
					stop_exit_sound = true,
					text = "loc_character_create_confirm_play_prologue",
					on_pressed_sound = UISoundEvents.finalize_creation_confirm,
					callback = callback(function ()
						if not self.__deleted then
							local skip_onboarding = false

							self._confirm_popup_id = nil

							Managers.event:trigger("event_create_new_character_continue", skip_onboarding)
						end
					end),
				},
			},
		}

		if Managers.data_service.account:has_completed_onboarding() then
			context.options[#context.options + 1] = {
				close_on_pressed = true,
				stop_exit_sound = true,
				text = "loc_character_create_confirm_skip_prologue",
				on_pressed_sound = UISoundEvents.finalize_creation_confirm,
				callback = callback(function ()
					if not self.__deleted then
						local skip_onboarding = true

						self._confirm_popup_id = nil

						Managers.event:trigger("event_create_new_character_continue", skip_onboarding)
					end
				end),
			}
		end

		context.options[#context.options + 1] = {
			close_on_pressed = true,
			hotkey = "back",
			template_type = "terminal_button_small",
			text = "loc_popup_button_cancel",
			callback = callback(function ()
				if not self.__deleted then
					self._confirm_popup_id = nil
				end
			end),
		}
	end

	Managers.event:trigger("event_show_ui_popup", context, function (id)
		self._confirm_popup_id = id
	end)
end

CharacterAppearanceView._open_page = function (self, index)
	self._navigation = {}

	local current_page = self._pages[self._active_page_number]

	if current_page and current_page.on_leave then
		current_page.on_leave(current_page, self._pages[index])
	end

	self:_clear_continue_disable_data()

	for i = 1, #self._page_grids do
		self:_destroy_page_grid(i)
	end

	local previous_index = self._active_page_number
	local previous_page = previous_index and self._pages[previous_index]

	self._active_page_number = index
	self._active_page_name = self._pages[self._active_page_number].name

	local new_page = self._pages[index]
	local prev_show_character = previous_page and previous_page.show_character
	local current_show_character = new_page.show_character
	local prev_show_companion = previous_page and previous_page.show_companion
	local current_show_companion = new_page.show_companion
	local changed_show_character = prev_show_character ~= current_show_character
	local changed_show_companion = prev_show_companion ~= current_show_companion
	local use_level_mindwipe = self._is_barber_mindwipe and previous_page and new_page.name == "personality" and previous_index < index
	local remove_level_mindwipe = self._is_barber_mindwipe and previous_page and previous_page.name == "personality" and index < previous_index
	local switch_level_mindwipe = use_level_mindwipe or remove_level_mindwipe
	local spawn_changed_state = changed_show_character or changed_show_companion or switch_level_mindwipe

	if spawn_changed_state then
		if current_show_character or current_show_companion or switch_level_mindwipe then
			if self._fade_animation_id then
				self:_stop_animation(self._fade_animation_id)
			end

			self._fade_animation_id = self:_start_animation("on_level_switch")

			if not self._world_spawner or switch_level_mindwipe then
				self:_destroy_background()
				self:_setup_background_world()
			else
				self:_spawn_profile(self._spawn_point_unit)
			end
		elseif self._profile_spawner then
			self:_destroy_background()
		end
	end

	if new_page.on_enter then
		new_page.on_enter(new_page, previous_page)
	end

	if self._is_barber_mindwipe then
		local page_open_vo = self._page_open_vo[index]

		if page_open_vo then
			local parent = self._parent

			if parent then
				parent:play_vo_events(page_open_vo, "training_ground_psyker_a", nil, 0.8)
			end

			self._page_open_vo[index] = nil
		end
	end

	self:_change_page_indicator(index)

	local selected_index

	if self._page_grids[1] and self._page_grids[1].widgets then
		for i = 1, #self._page_grids[1].widgets do
			local widget = self._page_grids[1].widgets[i]

			if widget.content.element_selected then
				selected_index = i

				break
			end
		end
	end

	self:_check_widget_choice_detail_visibility()
end

CharacterAppearanceView._move_background_to_position = function (self, planet, skip_animation)
	local planets_widget = self._page_widgets_by_name.planets
	local background_widget = self._page_widgets_by_name.background
	local planets_widget_content = planets_widget.content
	local start_planet = planets_widget_content.current_planet
	local end_planet = planets_widget_content.new_planet

	if planet == end_planet then
		return
	end

	local animation_params = self._home_planet_animation_params

	if not animation_params then
		animation_params = {
			start_background_position = {},
			end_background_position = {},
			start_planet_position = {},
			end_planet_position = {},
		}
		self._home_planet_animation_params = animation_params
	end

	local planet_offset_on_screen_x, planet_offset_on_screen_y = unpack(CharacterAppearanceViewSettings.planet_offset)
	local start_position_x, start_position_y, background_start_position_x, background_start_position_y, start_planet_position_x, start_planet_position_y
	local scale = 1
	local ratio = 1
	local is_animation_active = self._planet_background_animation_id and self:_is_animation_active(self._planet_background_animation_id)

	if start_planet and not is_animation_active then
		start_position_x, start_position_y = unpack(start_planet.position)

		local start_planet_size = start_planet.image.size

		start_planet_position_x = start_position_x - planet_offset_on_screen_x + start_planet_size[1] / 2
		start_planet_position_y = start_position_y - planet_offset_on_screen_y + start_planet_size[2] / 2
		background_start_position_x = planet_offset_on_screen_x - start_position_x
		background_start_position_y = planet_offset_on_screen_y - start_position_y
	else
		background_start_position_x = background_widget.content.original_offset and background_widget.content.original_offset[1] or background_widget.offset[1]
		background_start_position_y = background_widget.content.original_offset and background_widget.content.original_offset[2] or background_widget.offset[2]
		start_planet_position_x = -1 * (planets_widget.content.original_offset and planets_widget.content.original_offset[1] or planets_widget.offset[1])
		start_planet_position_y = -1 * (planets_widget.content.original_offset and planets_widget.content.original_offset[2] or planets_widget.offset[2])
	end

	local planet_size = planet.image.size
	local end_position_x, end_position_y = unpack(planet.position)
	local end_planet_position_x = end_position_x - planet_offset_on_screen_x + planet_size[1] / 2
	local end_planet_position_y = end_position_y - planet_offset_on_screen_y + planet_size[2] / 2
	local background_end_position_x = planet_offset_on_screen_x - end_position_x
	local background_end_position_y = planet_offset_on_screen_y - end_position_y

	if skip_animation then
		background_widget.offset[1] = background_end_position_x * scale * ratio
		background_widget.offset[2] = background_end_position_y * scale * ratio
		planets_widget.offset[1] = -(end_planet_position_x * scale) * ratio
		planets_widget.offset[2] = -(end_planet_position_y * scale) * ratio
		planets_widget_content.current_planet = planet
		planets_widget_content.new_planet = planet

		local planet_style = planets_widget.style[planet.id]

		planet_style.visible = true
		planet_style.size_addition[1] = 0
		planet_style.size_addition[2] = 0
	else
		animation_params.start_background_position[1] = background_start_position_x * scale * ratio
		animation_params.start_background_position[2] = background_start_position_y * scale * ratio
		animation_params.end_background_position[1] = background_end_position_x * scale * ratio
		animation_params.end_background_position[2] = background_end_position_y * scale * ratio
		animation_params.start_planet_position[1] = start_planet_position_x * scale * ratio
		animation_params.start_planet_position[2] = start_planet_position_y * scale * ratio
		animation_params.end_planet_position[1] = end_planet_position_x * scale * ratio
		animation_params.end_planet_position[2] = end_planet_position_y * scale * ratio
		animation_params.target_planet = planet
		planets_widget_content.new_planet = planet

		if self._planet_background_animation_id and self:_is_animation_active(self._planet_background_animation_id) then
			self:_stop_animation(self._planet_background_animation_id)

			self._planet_background_animation_id = nil
		end

		self._planet_background_animation_id = self:_start_animation("on_planet_select", {
			home_planets = planets_widget,
			background_planet = background_widget,
		}, animation_params)
	end
end

CharacterAppearanceView._create_page_indicators = function (self)
	if self._page_indicator_widgets then
		for i = 1, #self._page_indicator_widgets do
			local widget = self._page_indicator_widgets[i]

			self:_unregister_widget_name(widget.name)
		end
	end

	local num_pages = #self._pages

	if num_pages < 2 then
		return
	end

	local page_indicator_widgets = {}
	local indicator_z_index = 50
	local page_indicator_frame_definition = UIWidget.create_definition({
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/dividers/skull_rendered_left_02",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				size = {
					78,
					18,
				},
				offset = {
					-78,
					0,
					indicator_z_index,
				},
				uvs = {
					{
						1,
						0,
					},
					{
						0,
						1,
					},
				},
			},
		},
		{
			pass_type = "texture_uv",
			value = "content/ui/materials/dividers/skull_rendered_left_02",
			style = {
				horizontal_alignment = "right",
				vertical_alignment = "center",
				size = {
					78,
					18,
				},
				offset = {
					78,
					0,
					indicator_z_index,
				},
			},
		},
	}, "page_indicator")
	local page_indicator_frame_widget = self:_create_widget("page_indicator_frame", page_indicator_frame_definition)

	page_indicator_widgets[#page_indicator_widgets + 1] = page_indicator_frame_widget

	local width = 15
	local spacing = 10
	local total_width = spacing
	local page_indicator_definition = UIWidget.create_definition(ButtonPassTemplates.page_indicator_terminal, "page_indicator", nil, {
		20,
		20,
	})

	for i = 1, num_pages do
		local name = "page_indicator_" .. i
		local widget = self:_create_widget(name, page_indicator_definition)

		widget.offset[1] = total_width
		widget.offset[3] = indicator_z_index
		total_width = total_width + width + spacing
		page_indicator_widgets[#page_indicator_widgets + 1] = widget
	end

	self:_set_scenegraph_size("page_indicator", total_width, nil)

	self._page_indicator_widgets = page_indicator_widgets
end

CharacterAppearanceView._change_page_indicator = function (self, index)
	local page_indicator_widgets = self._page_indicator_widgets

	if not page_indicator_widgets or #page_indicator_widgets == 0 then
		return
	end

	local indicator_position = 1

	for i = 2, #page_indicator_widgets do
		local widget = page_indicator_widgets[i]

		widget.content.hotspot.is_focused = indicator_position == index
		indicator_position = indicator_position + 1
	end
end

CharacterAppearanceView._event_profile_sync_changed = function (self, is_active)
	self:_show_loading_character(is_active)
end

CharacterAppearanceView._show_loading_character = function (self, is_active)
	self._loading_overlay_visible = is_active

	if is_active then
		self._widgets_by_name.loading_overlay.content.text = ""
	end

	self._widgets_by_name.loading_overlay.content.visible = is_active
end

CharacterAppearanceView.update = function (self, dt, t, input_service)
	if self.closing_view or not self._entered then
		return
	end

	local continue_disabled = false

	if self._fade_animation_id and self:_is_animation_completed(self._fade_animation_id) then
		self._fade_animation_id = nil
	end

	for i = 1, #self._page_grids do
		local page_grids = self._page_grids[i]
		local grid = page_grids.grid

		if grid then
			grid:update(dt, t)

			local widgets = page_grids.widgets

			for j = 1, #widgets do
				local widget = widgets[j]
				local content = widget.content
				local element = content.element
				local visible = grid:is_widget_visible(widget)
				local template_name = element and element.template
				local template = template_name and ContentBlueprints[template_name]
				local unload_func = template and template.unload_icon
				local load_func = template and template.load_icon

				if not visible and content.loads_icon and content.icon_load_id and unload_func then
					unload_func(self, widget, element)
				elseif visible and content.loads_icon and not content.icon_load_id and load_func then
					load_func(self, widget, element)
				end

				if visible and template and template.update then
					template.update(self, widget, dt, t)
				end

				local option = widget.content.option

				if option and option.continue_validation then
					local available = option.continue_validation()
					local show_warning = not available

					widget.content.show_warning = not available or nil

					if not available then
						continue_disabled = true
					end
				else
					widget.content.show_warning = nil
				end
			end
		end
	end

	self:_update_continue_button("widget_validation", continue_disabled)

	local page = self._pages[self._active_page_number]

	if page.update then
		page.update()
	end

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end

	local profile_spawner = self._profile_spawner

	if profile_spawner then
		profile_spawner:update(dt, t, input_service)

		local is_spawned = profile_spawner:spawned()

		if is_spawned and self._character_spawned_next_frame then
			self._character_spawned_next_frame = false

			self:_show_loading_character(false)
		elseif (page.show_character or page.show_companion) and not is_spawned and not self._character_spawned_next_frame and not self._loading_overlay_visible and not self._is_character_showing then
			self:_show_loading_character(true)
		end

		if (page.show_character or page.show_companion) and not self._is_character_showing and is_spawned then
			local original_scale = profile_spawner:character_scale()
			local profile_height = self._character_create:height()
			local head_world_position = Vector3.to_array(profile_spawner:node_world_position("j_head"))
			local spawn_position = self._spawn_point_position
			local default_head_z_position = head_world_position[3] - spawn_position[3]
			local starting_scale_diff = 1 + (1 - original_scale[3])

			self._default_head_z_position = default_head_z_position * starting_scale_diff

			self:_set_character_height(profile_height)

			self._is_character_showing = true
			self._character_spawned_next_frame = true

			self:_set_camera(nil, nil, 0)
		end

		local level = self._level

		if is_spawned then
			if self._is_barber_mindwipe and level then
				local character_unit = profile_spawner:spawned_character_unit()

				Level.set_flow_variable(level, "lua_character_unit", character_unit)

				local breed_name = self._character_create:breed()

				if breed_name == "ogryn" then
					Level.trigger_event(level, "lua_character_spawned_ogryn")
				else
					Level.trigger_event(level, "lua_character_spawned_human")
				end
			end

			self._level = nil
		end
	end

	if self._in_barber_chair and self._twitching_time then
		self._twitching_time = self._twitching_time - dt

		if self._twitching_time <= 0 then
			local animation_event = "pose_fear"

			profile_spawner:assign_face_animation_event(animation_event)

			self._twitching_time = nil
		end
	end

	if not page.show_character and not page.show_companion and self._is_character_showing then
		self._is_character_showing = false
	end

	if self._is_barber_mindwipe and self._waiting_for_transform then
		local character_create = self._character_create
		local transform_complete = character_create:get_transformation_complete()

		if transform_complete then
			local parent = self._parent

			if transform_complete.success then
				parent:_update_wallets()
				parent:play_vo_events(CharacterAppearanceViewSettings.vo_event_mindwipe_conclusion, "training_ground_psyker_a", nil, 0.5)

				local height = character_create:height()
				local player = Managers.player:local_player(1)
				local real_unit = player.player_unit

				Unit.set_local_scale(real_unit, 1, Vector3.one() * height)

				local mission_board_service = Managers.data_service.mission_board
				local narrative_manager = Managers.narrative
				local is_eligable = mission_board_service and mission_board_service:get_is_character_eligible_to_skip_campaign()
				local not_already_completed_campaign = narrative_manager and not narrative_manager:is_story_complete("main_story")

				if is_eligable and not_already_completed_campaign then
					local character_id = player and player:character_id()
					local account_id = player and player:account_id()

					narrative_manager:complete_chapter_by_name("main_story", "km_station")
					Popups.skip_player_journey.mind_wipe(nil, function ()
						if mission_board_service then
							Managers.telemetry_events:player_journey_popup_play_journey("mind_wipe", true)
							mission_board_service:skip_and_unlock_campaign(account_id, character_id):next(function (data)
								return mission_board_service:set_character_has_been_shown_skip_campaign_popup(account_id, character_id)
							end)
						end
					end, function ()
						if mission_board_service then
							Managers.telemetry_events:player_journey_popup_play_journey("mind_wipe", false)

							return mission_board_service:set_character_has_been_shown_skip_campaign_popup(account_id, character_id)
						end
					end)
				end
			else
				local context = {
					description_text = "loc_crafting_failure",
					title_text = "loc_popup_header_error",
					options = {
						{
							close_on_pressed = true,
							stop_exit_sound = true,
							text = "loc_barber_vendor_confirm_button",
							on_pressed_sound = UISoundEvents.default_click,
						},
					},
				}

				Managers.event:trigger("event_show_ui_popup", context)
			end

			parent._active_view_instance = nil

			parent:_handle_back_pressed()

			self._waiting_for_transform = false

			local viewport_name = "ui_credits_vendor_world_viewport"

			parent._world_spawner:set_listener(viewport_name)
		end
	end

	return CharacterAppearanceView.super.update(self, dt, t, input_service)
end

CharacterAppearanceView._update_continue_button = function (self, check_id, disabled)
	local widget = self._widgets_by_name.continue_button

	widget.content.disabled_by = widget.content.disabled_by or {}
	widget.content.disabled_by[check_id] = disabled or nil

	local is_continue_disabled = not table.is_empty(widget.content.disabled_by)
	local continue_button_action_display_name, continue_button_text

	continue_button_action_display_name = self._backstory_selection_page and "loc_character_backstory_selection" or self._active_page_number == #self._pages and (self._is_barber and "loc_button_barber_confirm" or "loc_character_create_finish") or "loc_character_create_advance"
	continue_button_text = Localize(continue_button_action_display_name)
	widget.content.original_text = Utf8.upper(continue_button_text)
	widget.content.hotspot.disabled = is_continue_disabled
end

CharacterAppearanceView._clear_continue_disable_data = function (self)
	self._widgets_by_name.continue_button.content.disabled_by = nil
end

CharacterAppearanceView._toggle_continue_alternative_action = function (self, use_alternative)
	self._widgets_by_name.continue_button.content.gamepad_action = use_alternative and "secondary_action_pressed" or "confirm_pressed"
end

CharacterAppearanceView.draw = function (self, dt, t, input_service, layer)
	if self.closing_view or not self._entered then
		return
	end

	for i = 1, #self._page_grids do
		local page_grid = self._page_grids[i]

		if page_grid then
			local grid = page_grid.grid
			local widgets = page_grid.widgets
			local support_widgets = page_grid.support_widgets
			local interaction_widget = page_grid.support_widgets_by_name and page_grid.support_widgets_by_name.interaction
			local is_grid_hovered = not self._using_cursor_navigation or interaction_widget and interaction_widget.content.hotspot.is_hover or false

			UIRenderer.begin_pass(self._offscreen_renderer, self._ui_scenegraph, input_service, dt, self._render_settings)

			if widgets then
				for j = 1, #widgets do
					local widget = widgets[j]

					if grid and grid:is_widget_visible(widget) then
						UIWidget.draw(widget, self._offscreen_renderer)

						local hotspot = widget.content.hotspot

						if hotspot then
							hotspot.force_disabled = false
						end
					end
				end
			end

			UIRenderer.end_pass(self._offscreen_renderer)
			UIRenderer.begin_pass(self._ui_renderer, self._ui_scenegraph, input_service, dt, self._render_settings)

			if support_widgets then
				for j = 1, #support_widgets do
					local widget = support_widgets[j]

					if not widget.content.is_grid_widget then
						UIWidget.draw(widget, self._ui_renderer)
					end
				end
			end

			UIRenderer.end_pass(self._ui_renderer)
		end
	end

	CharacterAppearanceView.super.draw(self, dt, t, input_service, layer)
end

CharacterAppearanceView._draw_widgets = function (self, dt, t, input_service, ui_renderer)
	CharacterAppearanceView.super._draw_widgets(self, dt, t, input_service, ui_renderer)

	local page_indicator_widgets = self._page_indicator_widgets

	if page_indicator_widgets and #page_indicator_widgets > 0 then
		for i = 1, #page_indicator_widgets do
			local widget = page_indicator_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	local page_widgets = self._page_widgets

	if page_widgets and #page_widgets > 0 then
		for i = 1, #page_widgets do
			local widget = page_widgets[i]

			UIWidget.draw(widget, ui_renderer)

			if widget.content.template_type then
				local template = ContentBlueprints.blueprints[widget.content.template_type]

				if template and template.update then
					template.update(self, widget)
				end
			end
		end
	end
end

CharacterAppearanceView._on_close_pressed = function (self)
	if not self._using_cursor_navigation and self._navigation.grid and self._navigation.grid > 1 and (self._active_page_name == "appearance" or self._active_page_name == "companion_appearance") then
		local current_navigation_position = self._apperance_option_selected_index or 1

		self:_remove_all_focus()
		self:_update_navigation(1, current_navigation_position, true)
	elseif self._active_page_number > 1 then
		local previous_index = self._active_page_number - 1

		self:_open_page(previous_index)
	elseif self._is_barber then
		self._parent._active_view_instance = nil

		self._parent:_handle_back_pressed()
	else
		Managers.event:trigger("event_create_new_character_back")
	end
end

CharacterAppearanceView._destroy_renderer = function (self)
	if self._offscreen_renderer then
		self._offscreen_renderer = nil
	end

	local world_data = self._offscreen_world

	if world_data then
		Managers.ui:destroy_renderer(world_data.renderer_name)
		ScriptWorld.destroy_viewport(world_data.world, world_data.viewport_name)
		Managers.ui:destroy_world(world_data.world)

		world_data = nil
	end
end

CharacterAppearanceView._destroy_background = function (self)
	if self._profile_spawner then
		self._profile_spawner:destroy()

		self._profile_spawner = nil
	end

	if self._world_spawner then
		if self._world_spawner._level then
			Level.trigger_level_shutdown(self._world_spawner._level)
		end

		self._world_spawner:destroy()

		self._world_spawner = nil
	end
end

CharacterAppearanceView.on_exit = function (self)
	if self._confirm_popup_id then
		Managers.event:trigger("event_remove_ui_popup", self._confirm_popup_id)

		self._confirm_popup_id = nil
	end

	if self._character_create_promise then
		self._character_create_promise:cancel()

		self._character_create_promise = nil
	end

	if self._fetch_all_profiles_promise then
		self._fetch_all_profiles_promise:cancel()

		self._fetch_all_profiles_promise = nil
	end

	CharacterAppearanceView.super.on_exit(self)
	self:_destroy_background()
	self:_destroy_renderer()
	Managers.event:unregister(self, "update_character_sync_state")
end

CharacterAppearanceView._get_planet_options = function (self)
	local planets = self._character_create:planet_options()
	local planet_options = {}

	for id, option in pairs(planets) do
		planet_options[#planet_options + 1] = {
			data = option,
			text = Localize(option.display_name),
			value = id,
			on_pressed_function = function (grid_index, widget, pressed_options)
				local skip_animation = pressed_options and (pressed_options.skip_animation or pressed_options.initialization_press)

				self._character_create:set_planet(id)
				self:_move_background_to_position(option, skip_animation)

				local grid_index = 2
				local grid_data = {
					init = function ()
						return self:_generate_backstory_grid_widgets(grid_index, option)
					end,
				}

				self:_populate_page_grid(grid_index, grid_data)
			end,
		}
	end

	return planet_options
end

CharacterAppearanceView._generate_appearance_grid_widgets = function (self, grid_index, grid_data)
	local grid_template_name = grid_data.grid_template or "triple"
	local grid_template = APPEARANCE_GRID_TEMPLATES[grid_template_name]
	local grid_columns = grid_template and grid_template.grid_columns or 3
	local template_type = grid_data.template
	local template = ContentBlueprints[template_type]
	local grid_start_name = "grid_" .. grid_index .. "_"
	local grid_scenegraph = grid_start_name .. "pivot"
	local grid_area_scenegraph = grid_start_name .. "area"
	local grid_content_scenegraph = grid_start_name .. "content"
	local grid_scrollbar_scenegraph = grid_start_name .. "scrollbar"
	local size = template.size
	local pass_template = template.pass_template
	local init = template.init
	local options = grid_data.options
	local num_widgets = #options
	local ui_scenegraph = self._ui_scenegraph
	local grid_spacing = {
		10,
		10,
	}
	local grid_width = template.size[1] * grid_columns + grid_spacing[1] * (grid_columns - 1)
	local grids_margin = 20
	local grid_background_margin = 40
	local page = self._pages[self._active_page_number]
	local max_area_height = CharacterAppearanceViewSettings.area_grid_size[2]
	local area_height = max_area_height
	local widgets = {}
	local alignment_list = {}

	for i = 1, num_widgets do
		local option = options[i]
		local name = grid_start_name .. "option_" .. i

		if self._widgets_by_name[name] then
			self:_unregister_widget_name(name)
		end

		local visible, available, reason, reason_display_name = self:_check_valid_option(option)

		if visible then
			local pass_template = template.pass_template
			local size = template.size
			local widget_definition = UIWidget.create_definition(pass_template, grid_content_scenegraph, nil, size)
			local widget = self:_create_widget(name, widget_definition)

			if template.init then
				template.init(self, widget, grid_data, option, grid_index, "_on_entry_pressed")
			end

			widget.offset = {
				0,
				0,
				4,
			}
			widget.content.option = option

			self:_add_widget_restrictions(widget, available, reason, reason_display_name)

			widgets[#widgets + 1] = widget
			alignment_list[#alignment_list + 1] = widget
		end
	end

	local prev_grid_size = {
		0,
		0,
	}
	local prev_grid_position = {
		0,
		0,
	}
	local prev_grid_margin = grids_margin

	if grid_index > 1 then
		local prev_index = grid_index - 1

		if prev_index == 1 then
			prev_grid_margin = 40
		end

		local prev_grid = self._page_grids[prev_index]

		prev_grid_size = self._page_grids[prev_index] and self._page_grids[prev_index].size or prev_grid_size
		prev_grid_position = self._page_grids[prev_index] and self._page_grids[prev_index].position or prev_grid_position
	end

	local position_margin = grid_index == 1 and grid_background_margin * 0.5 or 0
	local grid_height_reduction = grid_index == 1 and grid_background_margin or 0
	local start_x_position = prev_grid_position[1] + prev_grid_size[1] + prev_grid_margin + position_margin
	local start_y_position = prev_grid_position[2] + position_margin
	local grid_position = {
		start_x_position,
		start_y_position,
	}
	local scrollbar_added_width = 15
	local grid_size = {
		grid_width + scrollbar_added_width,
		math.max(400, prev_grid_size[2]) - grid_height_reduction,
	}
	local support_widget_definitions = {
		scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.terminal_scrollbar, grid_scrollbar_scenegraph, {
			using_custom_gamepad_navigation = true,
		}),
		interaction = UIWidget.create_definition({
			{
				content_id = "hotspot",
				pass_type = "hotspot",
			},
		}, grid_area_scenegraph),
		mask = UIWidget.create_definition({
			{
				pass_type = "texture",
				value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					color = {
						255,
						255,
						255,
						255,
					},
					offset = {
						0,
						0,
						5,
					},
					size_addition = {
						10,
						10,
					},
				},
			},
		}, grid_area_scenegraph),
	}
	local support_widgets = {}

	for name, definition in pairs(support_widget_definitions) do
		local widget_name = grid_start_name .. name

		if self._widgets_by_name[widget_name] then
			self:_unregister_widget_name(widget_name)
		end

		local widget = self:_create_widget(widget_name, definition)

		if name == "mask" then
			widget.offset = {
				widget.offset[1] - 10,
				widget.offset[2] - 10,
				widget.offset[3],
			}
		end

		widget.offset = {
			widget.offset[1],
			widget.offset[2],
			widget.offset[3] + 4,
		}
		support_widgets[name] = widget
	end

	local grid_widgets = {
		widgets = widgets,
		alignment_list = alignment_list,
		support_widgets = support_widgets,
		grid_data = {
			focused_on_gamepad_navigation = true,
			grid_size = grid_size,
			grid_scenegraph = grid_scenegraph,
			grid_content_scenegraph = grid_content_scenegraph,
			grid_area_scenegraph = grid_area_scenegraph,
			grid_scrollbar_scenegraph = grid_scrollbar_scenegraph,
			grid_position = grid_position,
			grid_spacing = grid_spacing,
		},
	}

	return grid_widgets.widgets, grid_widgets.alignment_list, grid_widgets.support_widgets, grid_widgets.grid_data
end

CharacterAppearanceView._update_appearance_background = function (self)
	local widget = self._page_widgets_by_name.background

	if widget then
		local size = {
			0,
			0,
		}
		local prev_x_position
		local x_margin = 0

		for i = 2, #self._page_grids do
			local page_grid = self._page_grids[i]

			if not table.is_empty(page_grid) then
				local grid_size = page_grid.size or {
					0,
					0,
				}
				local grid_position = page_grid.position or {
					0,
					0,
				}

				size[1] = size[1] + grid_size[1]
				size[2] = math.max(size[2], grid_size[2])

				if prev_x_position then
					x_margin = x_margin + (grid_position[1] - prev_x_position)
				end

				prev_x_position = grid_position[1] + grid_size[1]
			end
		end

		if size[1] == 0 then
			widget.content.visible = false
		else
			size[1] = size[1] + x_margin + 25
			size[2] = size[2] + 20
			widget.content.visible = true
		end

		widget.content.size = size
		widget.offset = {
			-20,
			-20,
			0,
		}
	end
end

CharacterAppearanceView._generate_backstory_grid_widgets = function (self, grid_index, grid_data)
	local widgets = {}
	local alignment_list = {}
	local grid_start_name = "grid_" .. grid_index .. "_"
	local grid_scenegraph = grid_start_name .. "pivot"
	local grid_area_scenegraph = grid_start_name .. "area"
	local grid_content_scenegraph = grid_start_name .. "content"
	local title_font_style = CharacterAppearanceViewFontStyle.option_title_style
	local description_font_style = CharacterAppearanceViewFontStyle.description_style
	local option_title = Utf8.upper(Localize(grid_data.display_name))
	local option_description = Localize(grid_data.description)
	local content_width = 440
	local background_margin = {
		40,
		40,
	}
	local background_size = {
		content_width + background_margin[1] * 2,
		0,
	}
	local title_font_style_options = UIFonts.get_font_options_by_style(title_font_style)
	local description_font_style_options = UIFonts.get_font_options_by_style(description_font_style)
	local effect_margin = 100
	local text_margin = 20
	local _, title_height = UIRenderer.text_size(self._ui_renderer, option_title, title_font_style.font_type, title_font_style.font_size, {
		content_width,
		0,
	}, title_font_style_options)
	local _, description_height = UIRenderer.text_size(self._ui_renderer, option_description, description_font_style.font_type, description_font_style.font_size, {
		content_width,
		0,
	}, description_font_style_options)
	local backstory_info_tamplates = {}

	backstory_info_tamplates[#backstory_info_tamplates + 1] = {
		size = {
			background_size[1],
			20,
		},
	}
	backstory_info_tamplates[#backstory_info_tamplates + 1] = {
		size = {
			background_size[1],
			title_height,
		},
		pass_template = {
			{
				pass_type = "text",
				style_id = "option_title",
				value_id = "option_title",
				value = option_title,
				style = table.merge(table.clone(title_font_style), {
					size = {
						content_width,
						title_height,
					},
					offset = {
						background_margin[1],
						0,
						1,
					},
				}),
			},
		},
	}
	backstory_info_tamplates[#backstory_info_tamplates + 1] = {
		size = {
			background_size[1],
			20,
		},
	}
	backstory_info_tamplates[#backstory_info_tamplates + 1] = {
		size = {
			background_size[1],
			description_height,
		},
		pass_template = {
			{
				pass_type = "text",
				style_id = "option_description",
				value_id = "option_description",
				value = option_description,
				style = table.merge(table.clone(description_font_style), {
					size = {
						content_width,
						description_height,
					},
					offset = {
						background_margin[1],
						0,
						1,
					},
				}),
			},
		},
	}

	if grid_data.unlocks then
		local effect_title_font_style = CharacterAppearanceViewFontStyle.effect_title_style
		local option_effect_title = Localize("loc_character_title_unlocks")
		local effect_title_font_style_options = UIFonts.get_font_options_by_style(effect_title_font_style)
		local _, effect_title_height = UIRenderer.text_size(self._ui_renderer, option_effect_title, effect_title_font_style.font_type, effect_title_font_style.font_size, {
			content_width,
			0,
		}, effect_title_font_style_options)

		backstory_info_tamplates[#backstory_info_tamplates + 1] = {
			size = {
				background_size[1],
				40,
			},
		}
		backstory_info_tamplates[#backstory_info_tamplates + 1] = {
			size = {
				background_size[1],
				effect_title_height + 15,
			},
			pass_template = {
				{
					pass_type = "text",
					style_id = "option_effect_title",
					value_id = "option_effect_title",
					value = option_effect_title,
					style = table.merge(table.clone(effect_title_font_style), {
						size = {
							content_width,
							effect_title_height,
						},
						offset = {
							background_margin[1],
							0,
							1,
						},
					}),
				},
				{
					pass_type = "rect",
					style_id = "baseline",
					style = {
						vertical_alignment = "bottom",
						color = Color.terminal_corner(255, true),
						size = {
							content_width,
							2,
						},
						offset = {
							background_margin[1],
							0,
							1,
						},
					},
				},
			},
		}

		local margin = 20
		local start_offset_y = 0
		local start_margin = 50
		local start_pos_height = background_size[2] + start_margin

		backstory_info_tamplates[#backstory_info_tamplates + 1] = {
			size = {
				background_size[1],
				20,
			},
		}

		for i = 1, #grid_data.unlocks do
			local unlock = grid_data.unlocks[i]
			local text_style = CharacterAppearanceViewFontStyle.reward_description_no_icon_style
			local style = UIFonts.get_font_options_by_style(text_style)
			local _, text_height = UIRenderer.text_size(self._ui_renderer, Localize(unlock.text), text_style.font_type, text_style.font_size, {
				content_width,
				2000,
			}, style)

			backstory_info_tamplates[#backstory_info_tamplates + 1] = {
				size = {
					background_size[1],
					text_height,
				},
				pass_template = {
					{
						pass_type = "text",
						style_id = "title",
						value_id = "title",
						value = Localize(unlock.text),
						style = table.merge(table.clone(text_style), {
							size = {
								content_width,
								text_height,
							},
							offset = {
								background_margin[1],
								0,
								1,
							},
						}),
					},
				},
			}
		end
	end

	backstory_info_tamplates[#backstory_info_tamplates + 1] = {
		size = {
			background_margin[1],
			30,
		},
	}

	local total_height = 0

	for i = 1, #backstory_info_tamplates do
		local template = backstory_info_tamplates[i]
		local widget
		local size = template.size

		total_height = total_height + size[2]

		if template.pass_template then
			local definition = UIWidget.create_definition(template.pass_template, grid_scenegraph, nil, size)

			widget = self:_create_widget(grid_start_name .. "widget_" .. i, definition)
		end

		if widget then
			widgets[#widgets + 1] = widget
			alignment_list[#alignment_list + 1] = widget
		else
			widgets[#widgets + 1] = nil
			alignment_list[#alignment_list + 1] = {
				size = size,
			}
		end
	end

	background_size[2] = total_height

	local support_widget_definitions = {
		grid_background = UIWidget.create_definition({
			{
				pass_type = "texture",
				style_id = "top_frame",
				value = "content/ui/materials/dividers/horizontal_frame_big_upper",
				value_id = "top_frame",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "top",
					size = {
						nil,
						36,
					},
					offset = {
						0,
						-18,
						1,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "background",
				value = "content/ui/materials/backgrounds/terminal_basic",
				value_id = "background",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "top",
					color = Color.terminal_grid_background(nil, true),
					size_addition = {
						20,
						30,
					},
					offset = {
						0,
						-15,
						0,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "bottom_frame",
				value = "content/ui/materials/dividers/horizontal_frame_big_lower",
				value_id = "bottom_frame",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "bottom",
					size = {
						nil,
						36,
					},
					offset = {
						0,
						18,
						1,
					},
				},
			},
		}, grid_scenegraph, nil, background_size),
		mask = UIWidget.create_definition({
			{
				pass_type = "texture",
				value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					color = {
						255,
						255,
						255,
						255,
					},
					offset = {
						0,
						0,
						5,
					},
					size_addition = {
						10,
						10,
					},
				},
			},
		}, grid_area_scenegraph, nil, background_size),
	}
	local support_widgets = {}

	for name, definition in pairs(support_widget_definitions) do
		local widget = self:_create_widget(grid_start_name .. "support_widget_" .. name, definition)

		widget.offset = {
			widget.offset[1],
			widget.offset[2],
			widget.offset[3] + 4,
		}
		support_widgets[name] = widget
	end

	local grid_1_size = self._page_grids[1] and self._page_grids[1].size or {
		0,
		0,
	}
	local grid_1_position = self._page_grids[1] and self._page_grids[1].position or {
		0,
		0,
	}
	local start_x_position = grid_1_position[1] + grid_1_size[1] + 40
	local start_y_position = grid_1_position[2] + grid_1_size[2] - background_size[2]
	local grid_position = {
		start_x_position,
		start_y_position,
	}
	local grid_data = {
		grid_size = background_size,
		grid_position = grid_position,
		grid_scenegraph = grid_scenegraph,
		grid_area_scenegraph = grid_area_scenegraph,
		grid_content_scenegraph = grid_content_scenegraph,
	}

	return widgets, alignment_list, support_widgets, {
		size = background_size,
		grid_scenegraph = grid_scenegraph,
		grid_position = grid_position,
	}
end

CharacterAppearanceView._generate_main_grid_widgets = function (self, grid_index, grid_data)
	local template_type = grid_data.template
	local focused_on_gamepad_navigation = grid_data.focused_on_gamepad_navigation
	local template = ContentBlueprints[template_type]
	local grid_start_name = "grid_" .. grid_index .. "_"
	local grid_scenegraph = grid_start_name .. "pivot"
	local grid_area_scenegraph = grid_start_name .. "area"
	local grid_content_scenegraph = grid_start_name .. "content"
	local grid_scrollbar_scenegraph = grid_start_name .. "scrollbar"
	local size = template.size
	local pass_template = template.pass_template
	local init = template.init
	local options = grid_data.options()
	local num_widgets = #options
	local spacing = {
		0,
		0,
	}
	local ui_scenegraph = self._ui_scenegraph
	local scenegraph_spacing = {
		50,
	}
	local mask_margin = {
		30,
		30,
	}
	local prev_scenegraph_size = {
		0,
		0,
	}
	local prev_scenegraph_position = {
		0,
		0,
	}
	local scrollbar_diff = 35
	local max_widgets_per_column = num_widgets
	local grid_visible_widgets = num_widgets
	local total_columns = 1
	local added_spacing = 0
	local grid_margin = 5
	local page = self._pages[self._active_page_number]
	local max_area_height = CharacterAppearanceViewSettings.area_grid_size[2]
	local area_height = max_area_height
	local description_text_size = 0
	local widgets = {}
	local alignment_list = {}
	local grid_size = {
		480,
		600,
	}

	for i = 1, num_widgets do
		local option = options[i]
		local visible, available, reason, reason_display_name = self:_check_valid_option(option)

		if visible then
			local name = grid_start_name .. "option_" .. i
			local pass_template = template.pass_template
			local size = template.size
			local widget_definition = UIWidget.create_definition(pass_template, grid_content_scenegraph, nil, size)
			local widget = self:_create_widget(name, widget_definition)

			if template.init then
				template.init(self, widget, grid_data, option, grid_index, "_on_entry_pressed")
			end

			widget.offset = {
				0,
				0,
				4,
			}
			widget.content.option = option

			self:_add_widget_restrictions(widget, available, reason, reason_display_name)

			widgets[#widgets + 1] = widget
			alignment_list[#alignment_list + 1] = {
				horizontal_alignment = "center",
				size = {
					grid_size[1],
					size[2],
				},
				name = name,
			}
		end
	end

	local profile = self._character_create:profile()
	local selected_archetype = profile.archetype
	local widget_definitions = {
		scrollbar = UIWidget.create_definition(ScrollbarPassTemplates.terminal_scrollbar, grid_scrollbar_scenegraph, {
			using_custom_gamepad_navigation = true,
		}),
		interaction = UIWidget.create_definition({
			{
				content_id = "hotspot",
				pass_type = "hotspot",
			},
		}, grid_area_scenegraph),
		mask = UIWidget.create_definition({
			{
				pass_type = "texture",
				value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					color = {
						255,
						255,
						255,
						255,
					},
					offset = {
						0,
						0,
						5,
					},
					size_addition = {
						10,
						10,
					},
				},
			},
		}, grid_area_scenegraph),
		grid_background = UIWidget.create_definition({
			{
				pass_type = "texture",
				style_id = "background",
				value = "content/ui/materials/backgrounds/terminal_basic",
				value_id = "background",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "top",
					color = Color.terminal_grid_background(nil, true),
					size_addition = {
						20,
						30,
					},
					offset = {
						0,
						-15,
						0,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "class_background",
				value_id = "class_background",
				value = selected_archetype.archetype_icon_large,
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					color = Color.black(80, true),
					size = {
						nil,
						480,
					},
					offset = {
						0,
						0,
						0,
					},
				},
			},
			{
				pass_type = "texture",
				value = "content/ui/materials/dividers/horizontal_frame_big_lower",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "bottom",
					size = {
						nil,
						36,
					},
					offset = {
						0,
						18,
						2,
					},
				},
			},
		}, grid_scenegraph, nil, grid_size),
	}

	if grid_data.description then
		widget_definitions.grid_description = UIWidget.create_definition({
			{
				pass_type = "text",
				style_id = "text",
				value = "",
				value_id = "text",
				style = CharacterAppearanceViewFontStyle.list_description_style,
			},
			{
				pass_type = "texture",
				value = "content/ui/materials/dividers/horizontal_frame_big_middle",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "bottom",
					size = {
						nil,
						44,
					},
					offset = {
						0,
						22,
						1,
					},
				},
			},
		}, grid_scenegraph, nil, {
			grid_size[1],
			40,
		})
	end

	if grid_data.top_frame then
		widget_definitions.grid_top = grid_data.top_frame(page, grid_size, grid_scenegraph)
	else
		widget_definitions.grid_top = UIWidget.create_definition({
			{
				pass_type = "texture",
				style_id = "top_frame",
				value = "content/ui/materials/dividers/horizontal_frame_big_upper",
				value_id = "top_frame",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "top",
					size = {
						nil,
						36,
					},
					offset = {
						0,
						-18,
						2,
					},
				},
			},
		}, grid_scenegraph, nil, {
			grid_size[1],
			36,
		})
	end

	local grid_background_widget, grid_top_widget, grid_description_widget
	local support_widgets = {}

	for name, definition in pairs(widget_definitions) do
		local widget_name = grid_start_name .. name

		if self._widgets_by_name[widget_name] then
			self:_unregister_widget_name(widget_name)
		end

		local widget = self:_create_widget(widget_name, definition)

		if name == "grid_background" then
			grid_background_widget = widget
		end

		if name == "grid_top" then
			grid_top_widget = widget
		end

		if name == "grid_description" then
			grid_description_widget = widget
		end

		widget.offset = {
			widget.offset[1],
			widget.offset[2],
			widget.offset[3] + 4,
		}
		support_widgets[name] = widget
	end

	local description_text_size = 0

	if grid_data.description then
		local text = grid_data.description
		local style_name = "list_description_style"
		local font_style = CharacterAppearanceViewFontStyle[style_name]
		local style = UIFonts.get_font_options_by_style(font_style)
		local x_offset = 20
		local text_size = {
			grid_description_widget.content.size[1] - x_offset * 2,
			grid_description_widget.content.size[2],
		}
		local text_width, text_height = UIRenderer.text_size(self._ui_renderer, text, font_style.font_type, font_style.font_size, text_size, style)
		local text_margin = 15

		text_height = text_height + text_margin * 2
		grid_description_widget.content.size[2] = text_height
		grid_description_widget.style.text.size = {
			text_size[1],
			text_height,
		}
		grid_description_widget.content.text = text
		description_text_size = text_height
	end

	local grid_data = {
		grid_size = grid_size,
		grid_top_padding = description_text_size + 10,
		grid_scenegraph = grid_scenegraph,
		grid_area_scenegraph = grid_area_scenegraph,
		grid_content_scenegraph = grid_content_scenegraph,
		grid_scrollbar_scenegraph = grid_scrollbar_scenegraph,
		grid_position = {
			25,
			200,
		},
		focused_on_gamepad_navigation = focused_on_gamepad_navigation,
	}

	return widgets, alignment_list, support_widgets, grid_data
end

CharacterAppearanceView._add_widget_restrictions = function (self, widget, available, reason, reason_display_name)
	if not reason then
		return
	end

	widget.alpha_multiplier = available == false and 0.5 or 1

	local choice_info = choices_presentation[reason]

	if widget.style.choice_icon then
		widget.content.use_choice_icon = true
		widget.style.choice_icon.material_values = {
			texture_map = choice_info.icon_texture,
		}
	end

	widget.content.choice_data = {
		visible = not not reason,
		available = available,
		reason = reason,
		reason_display_name = reason_display_name,
	}
end

CharacterAppearanceView._destroy_page_grid = function (self, index)
	if self._page_grids[index] then
		local page_grid = self._page_grids[index]
		local widgets = page_grid.widgets

		if widgets then
			for i = 1, #widgets do
				local widget = widgets[i]
				local widget_name = widget.name
				local content = widget.content
				local element = content.element
				local template_name = element and element.template
				local template = template_name and ContentBlueprints[template_name]
				local unload_func = template and template.unload_icon

				if content.loads_icon and content.icon_load_id and unload_func then
					unload_func(self, widget, element)
				end

				self:_unregister_widget_name(widget_name)
			end
		end

		local support_widgets = page_grid.support_widgets

		if support_widgets then
			for i = 1, #support_widgets do
				local widget = support_widgets[i]

				if not widget.content.is_grid_widget then
					local widget_name = widget.name

					self:_unregister_widget_name(widget_name)
				end
			end
		end

		self._page_grids[index] = nil
	end
end

CharacterAppearanceView._populate_page_grid = function (self, index, grid_data, on_present_callback)
	local first_page_grid_generated = index == 1 and not self._page_grids[index]

	self:_destroy_page_grid(index)

	local grid_widgets, grid_alignment_list, grid_support_widgets, generated_data = grid_data.init(index, grid_data)

	if not grid_widgets then
		return
	end

	local support_widgets = {}

	for name, widget in pairs(grid_support_widgets) do
		support_widgets[#support_widgets + 1] = widget
	end

	local ui_scenegraph = self._ui_scenegraph
	local grid_scenegraph = generated_data.grid_scenegraph
	local grid_area_scenegraph = generated_data.grid_area_scenegraph
	local grid_content_scenegraph = generated_data.grid_content_scenegraph
	local grid_scrollbar_scenegraph = generated_data.grid_scrollbar_scenegraph
	local direction = generated_data and generated_data.grid_direction or grid_data.grid_direction or "down"
	local spacing = generated_data and generated_data.grid_spacing or grid_data.grid_spacing or {
		0,
		0,
	}
	local top_padding = generated_data and generated_data.grid_top_padding or grid_data.grid_top_padding or 0
	local size = generated_data and generated_data.grid_size or grid_data.grid_size or {
		0,
		0,
	}
	local focused_on_gamepad_navigation = generated_data and generated_data.focused_on_gamepad_navigation

	if generated_data.grid_position then
		local grid_position = generated_data.grid_position

		self:_set_scenegraph_position(grid_scenegraph, grid_position[1], grid_position[2])
	end

	self:_set_scenegraph_size(grid_scenegraph, size[1], size[2])

	local grid_size = {
		size[1],
		size[2] - top_padding,
	}

	if grid_area_scenegraph then
		if generated_data.grid_position then
			local grid_position = generated_data.grid_position

			self:_set_scenegraph_position(grid_area_scenegraph, 0, top_padding)
		end

		self:_set_scenegraph_size(grid_area_scenegraph, grid_size[1], grid_size[2])
	end

	if grid_content_scenegraph then
		self:_set_scenegraph_size(grid_content_scenegraph, grid_size[1], grid_size[2])
	end

	local grid = UIWidgetGrid:new(grid_widgets, grid_alignment_list, ui_scenegraph, grid_area_scenegraph, direction, spacing, nil, nil, nil, nil, nil, nil, nil, grid_size)
	local scrollbar_widget = grid_support_widgets.scrollbar

	if scrollbar_widget then
		if grid_scrollbar_scenegraph then
			self:_set_scenegraph_size(grid_scrollbar_scenegraph, 7, grid_size[2] - 20)
		end

		grid:assign_scrollbar(scrollbar_widget, grid_content_scenegraph, grid_area_scenegraph)
		grid:set_scrollbar_progress(0)
	end

	local position_x, position_y = self:_scenegraph_position(grid_scenegraph)

	self:_force_update_scenegraph()

	self._page_grids[index] = {
		id = math.uuid(),
		widgets = grid_widgets,
		grid = grid,
		support_widgets = support_widgets,
		support_widgets_by_name = grid_support_widgets,
		size = size,
		position = {
			position_x,
			position_y,
		},
		grid_data = grid_data,
		focused_on_gamepad_navigation = focused_on_gamepad_navigation,
	}

	local options = grid_data.options and grid_data.options()

	if options and not table.is_empty(options) then
		local has_selected_option = not not grid_data.selected_option

		if has_selected_option then
			local value = grid_data.selected_option()
			local widget_index_to_select = 1
			local option_to_select = options[widget_index_to_select]

			if value then
				local is_item = type(value) == "table" and (not not value.gear_id or not not value.always_owned)

				for i = 1, #options do
					local option = options[i]
					local is_equal

					if is_item then
						is_equal = option.value.name == value.name
					else
						is_equal = option.value == value
					end

					if is_equal then
						option_to_select = option
						widget_index_to_select = i

						break
					end
				end
			end

			local pressed_options = {
				initialization_press = true,
				ignore_navigation_update = not first_page_grid_generated,
			}

			if grid_data.init_pressed_options and type(grid_data.init_pressed_options) == "table" then
				table.merge(pressed_options, grid_data.init_pressed_options)
			end

			self:_on_entry_pressed(grid_widgets[widget_index_to_select], option_to_select, index, pressed_options)
		end
	end

	if on_present_callback then
		on_present_callback(index, options)
	end
end

CharacterAppearanceView._on_entry_pressed = function (self, current_widget, option, grid_index, pressed_options)
	local page_grid = self._page_grids[grid_index]
	local on_pressed_function = option.on_pressed_function
	local on_focused_function = option.on_focused_function
	local focused_on_gamepad_navigation = page_grid.focused_on_gamepad_navigation
	local initial_press = pressed_options and pressed_options.initialization_press
	local first_press_on_page = initial_press and not pressed_options.ignore_navigation_update
	local from_navigation = pressed_options and pressed_options.from_navigation
	local is_gamepad_navigation = not self._using_cursor_navigation

	page_grid.selected_widget = current_widget

	local widget_index = page_grid.grid:index_by_widget(current_widget)
	local original_grid_id = self._page_grids[grid_index].id

	if not pressed_options or not pressed_options.ignore_navigation_update then
		self:_update_navigation(grid_index, widget_index)
	end

	local new_grid_id = self._page_grids[grid_index].id

	if original_grid_id ~= new_grid_id then
		return
	end

	if not initial_press then
		self:_remove_all_focus()
		self:_check_widget_choice_detail_visibility(grid_index, widget_index)
	end

	local scrollbar_animation_progress = page_grid.grid:get_scrollbar_percentage_by_index(widget_index)

	if is_gamepad_navigation and focused_on_gamepad_navigation and from_navigation then
		page_grid.grid:focus_grid_index(widget_index, scrollbar_animation_progress, true)
	elseif on_pressed_function then
		page_grid.grid:select_grid_index(widget_index, scrollbar_animation_progress, true)

		if is_gamepad_navigation and (first_press_on_page or not initial_press) then
			page_grid.grid:focus_grid_index(widget_index, scrollbar_animation_progress, true)
		end
	end

	if is_gamepad_navigation and from_navigation and focused_on_gamepad_navigation and on_focused_function then
		on_focused_function(grid_index, current_widget, pressed_options)
	elseif on_pressed_function then
		on_pressed_function(grid_index, current_widget, pressed_options)
	end
end

CharacterAppearanceView._setup_background_world = function (self)
	local breed_name = self._character_create:breed()
	local event_suffix = BREED_TO_EVENT_SUFFIX[breed_name] or breed_name
	local default_camera_event_id = "event_register_character_appearance_default_camera_" .. event_suffix

	self[default_camera_event_id] = function (self, camera_unit)
		self._default_camera_unit = camera_unit

		local viewport_name = CharacterAppearanceViewSettings.viewport_name
		local viewport_type = CharacterAppearanceViewSettings.viewport_type
		local viewport_layer = CharacterAppearanceViewSettings.viewport_layer
		local shading_environment = CharacterAppearanceViewSettings.shading_environment

		if self._is_barber then
			shading_environment = CharacterAppearanceViewSettings.barber_shading_environment
		end

		self._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)
		self:_unregister_event(default_camera_event_id)
	end

	self:_register_event(default_camera_event_id)

	self._camera_by_slot_id = {}

	for slot_name, slot in pairs(ItemSlotSettings) do
		if slot.slot_type == "body" then
			local item_camera_event_id = "event_register_character_appearance_camera_" .. event_suffix .. "_" .. slot_name

			self[item_camera_event_id] = function (self, camera_unit)
				self._camera_by_slot_id[slot_name] = camera_unit
				self._camera_zoomed = self:_is_camera_zoomed(slot_name)

				self:_unregister_event(item_camera_event_id)
			end

			self:_register_event(item_camera_event_id)
		end
	end

	self:_register_event("event_register_character_spawn_point")
	self:_register_event("event_register_companion_spawn_point")

	if self._is_barber_mindwipe then
		local spawn_point_event_id = "event_register_character_spawn_point_" .. event_suffix

		self[spawn_point_event_id] = function (self, spawn_point_unit)
			self._spawn_point_unit = spawn_point_unit

			if breed_name == "ogryn" then
				self:_spawn_profile(spawn_point_unit, "content/characters/player/ogryn/third_person/animations/menu/mindwipe", "idle")
			else
				self:_spawn_profile(spawn_point_unit, "content/characters/player/human/third_person/animations/menu/mindwipe", "idle")
			end

			self:_unregister_event(spawn_point_event_id)
		end

		self:_register_event(spawn_point_event_id)
	end

	local world_name = CharacterAppearanceViewSettings.world_name
	local world_layer = CharacterAppearanceViewSettings.world_layer
	local world_timer_name = CharacterAppearanceViewSettings.timer_name

	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)

	local level_name, store_level

	if self._is_barber_mindwipe and self._active_page_name == "personality" then
		level_name = CharacterAppearanceViewSettings.barber_mindwipe_level_name
		store_level = true
	elseif self._is_barber then
		level_name = CharacterAppearanceViewSettings.barber_level_name
	else
		level_name = CharacterAppearanceViewSettings.level_name
	end

	self._world_spawner:spawn_level(level_name)

	if store_level then
		self._level = self._world_spawner:level()
	end
end

CharacterAppearanceView._is_camera_zoomed = function (self, camera_focus)
	return camera_focus == "slot_body_face"
end

CharacterAppearanceView._set_character_height = function (self, scale_factor)
	self._profile_spawner:set_character_scale(scale_factor)
	self._character_create:set_height(scale_factor)
end

CharacterAppearanceView._filter_changed_items = function (self, items)
	local original_loadout = self._original_loadout
	local filtered_items = {}
	local identical = true

	for slot, item in pairs(items) do
		local original_item = original_loadout[slot]

		if item.name ~= original_item.name then
			filtered_items[slot] = item
			identical = false
		end
	end

	if not identical then
		return filtered_items
	end
end

CharacterAppearanceView._get_appearance_options = function (self)
	local appearance_options = {}
	local gender_options = self._character_create:gender_options()

	if gender_options and #gender_options > 1 and not self._is_barber_appearance then
		appearance_options[#appearance_options + 1] = {
			icon = "content/ui/materials/icons/item_types/body_types",
			text = Localize("loc_gender"),
			on_pressed_function = function (grid_index, widget, pressed_options)
				local options = self:_get_appearance_category_options({
					{
						grid_template = "single",
						slot_name = "slot_body",
						template = "icon",
						type = "gender",
						options = gender_options,
					},
				})

				for i = 1, #options do
					local option = options[i]
					local grid_index = 1 + i
					local grid_data = {
						init = function ()
							return self:_generate_appearance_grid_widgets(grid_index, option)
						end,
						selected_option = function ()
							if option.selected_option then
								return option.selected_option()
							end
						end,
						options = function ()
							return option.options
						end,
					}

					self:_populate_page_grid(grid_index, grid_data)
				end
			end,
		}
	end

	local face_item_options = self._character_create:slot_item_options("slot_body_face")
	local skin_color_options = self._character_create:slot_item_options("slot_body_skin_color")

	if face_item_options and #face_item_options > 1 then
		table.sort(face_item_options, sort_by_string_name)
		table.sort(face_item_options, sort_by_order)
		table.sort(skin_color_options, sort_by_order)

		appearance_options[#appearance_options + 1] = {
			camera_focus = "slot_body_face",
			icon = "content/ui/materials/icons/item_types/face_types",
			continue_validation = function ()
				local slots = {
					"slot_body_face",
					"slot_body_skin_color",
				}

				return continue_validation_item_slots(self, slots)
			end,
			text = Localize("loc_face"),
			on_pressed_function = function (grid_index, widget, pressed_options)
				local options = self:_get_appearance_category_options({
					{
						grid_template = "triple",
						slot_name = "slot_body_face",
						template = "slot_icon",
						options = face_item_options,
					},
					{
						grid_template = "double",
						slot_name = "slot_body_skin_color",
						template = "icon_small_texture_hsv",
						type = "skin_color",
						options = skin_color_options,
					},
				})

				for i = 1, #options do
					local option = options[i]
					local grid_index = 1 + i
					local grid_data = {
						init = function ()
							return self:_generate_appearance_grid_widgets(grid_index, option)
						end,
						selected_option = function ()
							if option.selected_option then
								return option.selected_option()
							end
						end,
						options = function ()
							return option.options
						end,
					}

					self:_populate_page_grid(grid_index, grid_data)
				end
			end,
		}
	end

	local eye_color_options = self._character_create:slot_item_options("slot_body_eye_color")

	local function sort_eye_color_by_type()
		local colors_eye_black_scalera = {}
		local colors_eye_blind_left = {}
		local colors_eye_blind_right = {}
		local colors_eye_blind_both = {}
		local colors_eye = {}

		for j = 1, #eye_color_options do
			local eye_color = eye_color_options[j]
			local index = get_eye_type_index_by_option(eye_color)

			if eye_types[index].name == "black_scalera" then
				colors_eye_black_scalera[#colors_eye_black_scalera + 1] = eye_color
			elseif eye_types[index].name == "blind_left" then
				colors_eye_blind_left[#colors_eye_blind_left + 1] = eye_color
			elseif eye_types[index].name == "blind_right" then
				colors_eye_blind_right[#colors_eye_blind_right + 1] = eye_color
			elseif eye_types[index].name == "blind_both" then
				colors_eye_blind_both[#colors_eye_blind_both + 1] = eye_color
			else
				colors_eye[#colors_eye + 1] = eye_color
			end
		end

		local result = {
			no_blind = colors_eye,
			blind_left = colors_eye_blind_left,
			blind_right = colors_eye_blind_right,
			blind_both = colors_eye_blind_both,
			black_scalera = colors_eye_black_scalera,
		}

		return result
	end

	if eye_color_options and #eye_color_options > 1 then
		appearance_options[#appearance_options + 1] = {
			camera_focus = "slot_body_face",
			icon = "content/ui/materials/icons/item_types/eye_color",
			continue_validation = function ()
				local slots = {
					"slot_body_eye_color",
				}

				return continue_validation_item_slots(self, slots)
			end,
			text = Localize("loc_eye_color"),
			on_pressed_function = function (grid_index, widget, pressed_options)
				self._eye_options_by_type = sort_eye_color_by_type()

				local current_option = self._character_create:slot_item("slot_body_eye_color")
				local index = get_eye_type_index_by_option(current_option)
				local filtered_eye_types = {}

				for type_name, data in pairs(self._eye_options_by_type) do
					if #data > 0 then
						for i = 1, #eye_types do
							if type_name == eye_types[i].name then
								filtered_eye_types[#filtered_eye_types + 1] = eye_types[i]

								break
							end
						end
					end
				end

				local filtered_eye_colors = self._eye_options_by_type[eye_types[index].name]

				table.sort(filtered_eye_types, sort_by_order)
				table.sort(filtered_eye_colors, sort_by_order)

				local options = self:_get_appearance_category_options({
					{
						grid_template = "single",
						slot_name = "slot_body_eye_color",
						template = "icon",
						type = "eye_type",
						options = filtered_eye_types,
					},
					{
						grid_template = "double",
						slot_name = "slot_body_eye_color",
						template = "icon_small_texture_hsv",
						type = "eye_color",
						options = filtered_eye_colors,
					},
				})

				for i = 1, #options do
					local option = options[i]
					local grid_index = 1 + i
					local grid_data = {
						init = function ()
							return self:_generate_appearance_grid_widgets(grid_index, option)
						end,
						selected_option = function ()
							if option.selected_option then
								return option.selected_option()
							end
						end,
						options = function ()
							return option.options
						end,
					}

					self:_populate_page_grid(grid_index, grid_data)
				end
			end,
		}
	end

	local hair_item_options = self._character_create:slot_item_options("slot_body_hair")
	local hair_color_options = self._character_create:slot_item_options("slot_body_hair_color")

	if hair_item_options and #hair_item_options > 1 then
		table.sort(hair_item_options, sort_by_string_name)
		table.sort(hair_item_options, sort_by_order)
		table.sort(hair_color_options, sort_by_order)

		appearance_options[#appearance_options + 1] = {
			camera_focus = "slot_body_face",
			icon = "content/ui/materials/icons/item_types/hair_styles",
			continue_validation = function ()
				local slots = {
					"slot_body_hair",
					"slot_body_hair_color",
				}

				return continue_validation_item_slots(self, slots)
			end,
			text = Localize("loc_hair"),
			on_pressed_function = function (grid_index, widget, pressed_options)
				local options = self:_get_appearance_category_options({
					{
						grid_template = "triple",
						slot_name = "slot_body_hair",
						template = "slot_icon",
						options = hair_item_options,
					},
					{
						grid_template = "double",
						slot_name = "slot_body_hair_color",
						template = "icon_small_texture",
						type = "hair_color",
						options = hair_color_options,
					},
				})

				for i = 1, #options do
					local option = options[i]
					local grid_index = 1 + i
					local grid_data = {
						init = function ()
							return self:_generate_appearance_grid_widgets(grid_index, option)
						end,
						selected_option = function ()
							if option.selected_option then
								return option.selected_option()
							end
						end,
						options = function ()
							return option.options
						end,
					}

					self:_populate_page_grid(grid_index, grid_data)
				end
			end,
		}
	end

	local face_hair_options = self._character_create:slot_item_options("slot_body_face_hair")
	local facial_hair_color_options = self._character_create:slot_item_options("slot_body_hair_color")

	if face_hair_options and #face_hair_options > 1 then
		table.sort(face_hair_options, sort_by_string_name)
		table.sort(face_hair_options, sort_by_order)
		table.sort(facial_hair_color_options, sort_by_order)

		appearance_options[#appearance_options + 1] = {
			camera_focus = "slot_body_face",
			icon = "content/ui/materials/icons/item_types/facial_hair_styles",
			continue_validation = function ()
				local slots = {
					"slot_body_face_hair",
					"slot_body_hair_color",
				}

				return continue_validation_item_slots(self, slots)
			end,
			text = Localize("loc_face_hair"),
			on_pressed_function = function (grid_index, widget, pressed_options)
				local options = self:_get_appearance_category_options({
					{
						grid_template = "triple",
						slot_name = "slot_body_face_hair",
						template = "slot_icon",
						options = face_hair_options,
					},
					{
						grid_template = "double",
						slot_name = "slot_body_hair_color",
						template = "icon_small_texture",
						type = "hair_color",
						options = facial_hair_color_options,
					},
				})

				for i = 1, #options do
					local option = options[i]
					local grid_index = 1 + i
					local grid_data = {
						init = function ()
							return self:_generate_appearance_grid_widgets(grid_index, option)
						end,
						selected_option = function ()
							if option.selected_option then
								return option.selected_option()
							end
						end,
						options = function ()
							return option.options
						end,
					}

					self:_populate_page_grid(grid_index, grid_data)
				end
			end,
		}
	end

	local face_tattoo_options = self._character_create:slot_item_options("slot_body_face_tattoo")

	if face_tattoo_options and #face_tattoo_options > 1 then
		table.sort(face_tattoo_options, sort_by_string_name)
		table.sort(face_tattoo_options, sort_by_order)

		appearance_options[#appearance_options + 1] = {
			camera_focus = "slot_body_face",
			icon = "content/ui/materials/icons/item_types/face_tattoos",
			continue_validation = function ()
				local slots = {
					"slot_body_face_tattoo",
				}

				return continue_validation_item_slots(self, slots)
			end,
			text = Localize("loc_face_tattoo"),
			on_pressed_function = function (grid_index, widget, pressed_options)
				local options = self:_get_appearance_category_options({
					{
						grid_template = "triple",
						icon_background = "content/ui/textures/icons/appearances/backgrounds/face_tattoos",
						no_option = true,
						slot_name = "slot_body_face_tattoo",
						template = "icon",
						options = face_tattoo_options,
					},
				})

				for i = 1, #options do
					local option = options[i]
					local grid_index = 1 + i
					local grid_data = {
						init = function ()
							return self:_generate_appearance_grid_widgets(grid_index, option)
						end,
						selected_option = function ()
							if option.selected_option then
								return option.selected_option()
							end
						end,
						options = function ()
							return option.options
						end,
					}

					self:_populate_page_grid(grid_index, grid_data)
				end
			end,
		}
	end

	local body_tattoo_options = self._character_create:slot_item_options("slot_body_tattoo")

	if body_tattoo_options and #body_tattoo_options > 1 then
		table.sort(body_tattoo_options, sort_by_string_name)
		table.sort(body_tattoo_options, sort_by_order)

		appearance_options[#appearance_options + 1] = {
			icon = "content/ui/materials/icons/item_types/body_tattoos",
			continue_validation = function ()
				local slots = {
					"slot_body_tattoo",
				}

				return continue_validation_item_slots(self, slots)
			end,
			text = Localize("loc_body_tattoo"),
			on_pressed_function = function (grid_index, widget, pressed_options)
				local options = self:_get_appearance_category_options({
					{
						grid_template = "triple",
						icon_background = "content/ui/textures/icons/appearances/backgrounds/body_tattoos",
						no_option = true,
						slot_name = "slot_body_tattoo",
						template = "icon",
						options = body_tattoo_options,
					},
				})

				for i = 1, #options do
					local option = options[i]
					local grid_index = 1 + i
					local grid_data = {
						init = function ()
							return self:_generate_appearance_grid_widgets(grid_index, option)
						end,
						selected_option = function ()
							if option.selected_option then
								return option.selected_option()
							end
						end,
						options = function ()
							return option.options
						end,
					}

					self:_populate_page_grid(grid_index, grid_data)
				end
			end,
		}
	end

	local face_scar_options = self._character_create:slot_item_options("slot_body_face_scar")

	if face_scar_options and #face_scar_options > 1 then
		table.sort(face_scar_options, sort_by_string_name)
		table.sort(face_scar_options, sort_by_order)

		appearance_options[#appearance_options + 1] = {
			camera_focus = "slot_body_face",
			icon = "content/ui/materials/icons/item_types/scars",
			continue_validation = function ()
				local slots = {
					"slot_body_face_scar",
				}

				return continue_validation_item_slots(self, slots)
			end,
			text = Localize("loc_face_scar"),
			on_pressed_function = function (grid_index, widget, pressed_options)
				local options = self:_get_appearance_category_options({
					{
						grid_template = "triple",
						icon_background = "content/ui/textures/icons/appearances/backgrounds/scars",
						no_option = true,
						slot_name = "slot_body_face_scar",
						template = "icon",
						options = face_scar_options,
					},
				})

				for i = 1, #options do
					local option = options[i]
					local grid_index = 1 + i
					local grid_data = {
						init = function ()
							return self:_generate_appearance_grid_widgets(grid_index, option)
						end,
						selected_option = function ()
							if option.selected_option then
								return option.selected_option()
							end
						end,
						options = function ()
							return option.options
						end,
					}

					self:_populate_page_grid(grid_index, grid_data)
				end
			end,
		}
	end

	appearance_options[#appearance_options + 1] = {
		icon = "content/ui/materials/icons/item_types/height",
		text = Localize("loc_body_height"),
		on_pressed_function = function (grid_index, widget, pressed_options)
			local options = self:_get_appearance_category_options({
				{
					grid_template = "single",
					template = "vertical_slider",
					type = "height",
				},
			})

			for i = 1, #options do
				local option = options[i]
				local grid_index = 1 + i
				local grid_data = {
					init = function ()
						return self:_generate_appearance_grid_widgets(grid_index, option)
					end,
					options = function ()
						return option.options
					end,
				}

				self:_populate_page_grid(grid_index, grid_data, function ()
					self:_set_camera_height_option(nil)
				end)
			end
		end,
	}

	for i = 1, #appearance_options do
		local appearance_option = appearance_options[i]

		appearance_option.value = i

		local appearance_function = appearance_option.on_pressed_function

		appearance_option.on_pressed_function = function (grid_index, widget, pressed_options)
			if i == self._apperance_option_selected_index then
				return
			end

			for j = 2, #self._page_grids do
				self:_destroy_page_grid(j)
			end

			self._apperance_option_selected_index = i

			self:_set_camera(appearance_option.camera_focus)
			appearance_function(widget, pressed_options)
			self:_update_appearance_background()
		end

		appearance_option.on_focused_function = function (grid_index, widget)
			return
		end
	end

	return appearance_options
end

CharacterAppearanceView._get_companion_appearance_options = function (self)
	local appearance_options = {}
	local dog_fur_options = self._character_create:slot_item_options("slot_companion_body_fur_color")
	local dog_skin_options = self._character_create:slot_item_options("slot_companion_body_skin_color")
	local selected_fur_option = self._character_create:slot_item("slot_companion_body_fur_color")
	local filtered_dog_fur_options = {}

	for i = 1, #dog_fur_options do
		local dog_fur_option = dog_fur_options[i]

		if DogOptionRestrictions[dog_fur_option.dev_name] then
			filtered_dog_fur_options[#filtered_dog_fur_options + 1] = dog_fur_option
		end
	end

	local fur_skin_from_fur = DogOptionRestrictions[selected_fur_option.dev_name] or {}
	local filtered_dog_skin_options = {}
	local dog_skin_from_dev_name = {}

	for i = 1, #dog_skin_options do
		local dog_skin_option = dog_skin_options[i]

		dog_skin_from_dev_name[dog_skin_option.dev_name] = dog_skin_option
	end

	for i = 1, #fur_skin_from_fur do
		local skin_dev_name = fur_skin_from_fur[i]

		filtered_dog_skin_options[#filtered_dog_skin_options + 1] = dog_skin_from_dev_name[skin_dev_name]
	end

	table.sort(filtered_dog_fur_options, sort_by_string_name)
	table.sort(filtered_dog_fur_options, sort_by_order)
	table.sort(filtered_dog_skin_options, sort_by_order)
	table.sort(filtered_dog_skin_options, sort_by_string_name)

	appearance_options[#appearance_options + 1] = {
		icon = "content/ui/materials/icons/item_types/fur_color",
		text = Localize("loc_character_creator_mastiff_fur"),
		on_pressed_function = function (grid_index, widget, pressed_options)
			local options = self:_get_appearance_category_options({
				{
					grid_template = "double",
					slot_name = "slot_companion_body_fur_color",
					template = "icon",
					type = "dog_fur",
					options = filtered_dog_fur_options,
				},
				{
					grid_template = "double",
					slot_name = "slot_companion_body_skin_color",
					template = "icon_small_texture_hsv",
					type = "dog_skin",
					options = filtered_dog_skin_options,
				},
			})

			for i = 1, #options do
				local option = options[i]
				local grid_index = 1 + i
				local grid_data = {
					init = function ()
						return self:_generate_appearance_grid_widgets(grid_index, option)
					end,
					selected_option = function ()
						if option.selected_option then
							return option.selected_option()
						end
					end,
					options = function ()
						return option.options
					end,
				}

				self:_populate_page_grid(grid_index, grid_data)
			end
		end,
	}

	local dog_coat_options = self._character_create:slot_item_options("slot_companion_body_coat_pattern")

	table.sort(dog_coat_options, sort_by_string_name)
	table.sort(dog_coat_options, sort_by_order)

	appearance_options[#appearance_options + 1] = {
		icon = "content/ui/materials/icons/item_types/fur_pattern",
		text = Localize("loc_arbites_customization_dog_pattern"),
		on_pressed_function = function (grid_index, widget, pressed_options)
			local options = self:_get_appearance_category_options({
				{
					grid_template = "single",
					icon_background = "content/ui/textures/icons/appearances/dog/fur_pattern",
					no_option = true,
					slot_name = "slot_companion_body_coat_pattern",
					template = "icon",
					type = "dog_coat",
					options = dog_coat_options,
				},
			})

			for i = 1, #options do
				local option = options[i]
				local grid_index = 1 + i
				local grid_data = {
					init = function ()
						return self:_generate_appearance_grid_widgets(grid_index, option)
					end,
					selected_option = function ()
						if option.selected_option then
							return option.selected_option()
						end
					end,
					options = function ()
						return option.options
					end,
				}

				self:_populate_page_grid(grid_index, grid_data)
			end
		end,
	}

	for i = 1, #appearance_options do
		local appearance_option = appearance_options[i]

		appearance_option.value = i

		local appearance_function = appearance_option.on_pressed_function

		appearance_option.on_pressed_function = function (grid_index, widget, pressed_options)
			if i == self._apperance_option_selected_index then
				return
			end

			for j = 2, #self._page_grids do
				self:_destroy_page_grid(j)
			end

			self._apperance_option_selected_index = i

			appearance_function(widget, pressed_options)
			self:_update_appearance_background()
		end

		appearance_option.on_focused_function = function (grid_index, widget)
			return
		end
	end

	return appearance_options
end

local selected_data_slot = {}

CharacterAppearanceView._get_appearance_category_options = function (self, category_entry_options)
	local grids = {}

	local function add_eye_color_grid(eye_color_options, init_pressed_options)
		table.sort(eye_color_options, sort_by_order)

		local options = self:_get_appearance_category_options({
			{
				grid_template = "double",
				slot_name = "slot_body_eye_color",
				template = "icon_small_texture_hsv",
				type = "eye_color",
				options = eye_color_options,
			},
		})

		for i = 1, #options do
			local option = options[i]
			local grid_index = 2 + i
			local grid_data = {
				init = function ()
					return self:_generate_appearance_grid_widgets(grid_index, option)
				end,
				selected_option = function ()
					if option.selected_option then
						return option.selected_option()
					end
				end,
				options = function ()
					return option.options
				end,
				init_pressed_options = init_pressed_options,
			}

			self:_populate_page_grid(grid_index, grid_data)
		end
	end

	local function eye_items_by_selected_type(current_option)
		local eye_options = self._eye_options_by_type[current_option.name]
		local selected_option = eye_options[1]
		local ignored_params = current_option.search_params
		local current_eye_option = self._character_create:slot_item("slot_body_eye_color")
		local current_override_name = current_eye_option.material_overrides[1]
		local current_override_data = current_override_name and EyeMaterialOverrides[current_override_name] and EyeMaterialOverrides[current_override_name].property_overrides

		for k = 1, #eye_options do
			local found = true
			local eye_option = eye_options[k]
			local override_name = eye_option.material_overrides[1]
			local override_data = override_name and EyeMaterialOverrides[override_name] and EyeMaterialOverrides[override_name].property_overrides

			for name, override_values in pairs(override_data) do
				if not ignored_params[name] then
					for l = 1, #override_values do
						local override_value = override_values[l]
						local current_eye_override_value = current_override_data[name] and current_override_data[name][l]

						if not current_eye_override_value or override_value and current_eye_override_value ~= override_value then
							found = false

							break
						end
					end
				end
			end

			if found then
				selected_option = eye_option

				break
			end
		end

		return eye_options, selected_option
	end

	local function add_dog_skin_grid(dog_skin_options, init_pressed_options)
		table.sort(dog_skin_options, sort_by_order)
		table.sort(dog_skin_options, sort_by_string_name)

		local options = self:_get_appearance_category_options({
			{
				grid_template = "double",
				icon_background = "content/ui/textures/icons/appearances/backgrounds/scars",
				slot_name = "slot_companion_body_skin_color",
				template = "icon_small_texture_hsv",
				type = "dog_skin",
				options = dog_skin_options,
			},
		})

		for i = 1, #options do
			local option = options[i]
			local grid_index = 2 + i
			local grid_data = {
				init = function ()
					return self:_generate_appearance_grid_widgets(grid_index, option)
				end,
				selected_option = function ()
					if option.selected_option then
						return option.selected_option()
					end
				end,
				options = function ()
					return option.options
				end,
				init_pressed_options = init_pressed_options,
			}

			self:_populate_page_grid(grid_index, grid_data)
		end
	end

	local function dog_skin_items_by_selected_pattern(selected_fur_option)
		local dog_skin_options = self._character_create:slot_item_options("slot_companion_body_skin_color")
		local fur_skin_from_fur = DogOptionRestrictions[selected_fur_option.dev_name] or {}
		local filtered_dog_skin_options = {}
		local dog_skin_from_dev_name = {}

		for i = 1, #dog_skin_options do
			local dog_skin_option = dog_skin_options[i]

			dog_skin_from_dev_name[dog_skin_option.dev_name] = dog_skin_option
		end

		for i = 1, #fur_skin_from_fur do
			local skin_dev_name = fur_skin_from_fur[i]

			filtered_dog_skin_options[#filtered_dog_skin_options + 1] = dog_skin_from_dev_name[skin_dev_name]
		end

		return filtered_dog_skin_options
	end

	for i = 1, #category_entry_options do
		local category_entry_option = category_entry_options[i]
		local entry_type = category_entry_option.type
		local entry_options = category_entry_option.options
		local entry_slot_name = category_entry_option.slot_name
		local entry_type_template = category_entry_option.template
		local entry_type_grid_template = category_entry_option.grid_template
		local entry_no_option = category_entry_option.no_option
		local entry_icon_background = category_entry_option.icon_background
		local entry_enter = category_entry_option.on_enter
		local entry_leave = category_entry_option.on_leave
		local continue_validation = category_entry_option.validation
		local options = {}

		grids[i] = {
			focused_on_gamepad_navigation = true,
			continue_validation = continue_validation,
			template = entry_type_template,
			slot_name = entry_slot_name,
			options = options,
			grid_template = entry_type_grid_template,
			on_enter = entry_enter,
			on_leave = entry_leave,
			no_option = entry_no_option,
			icon_background = entry_icon_background,
			type = entry_type,
		}

		if entry_type == "gender" then
			local gender_presentation = {
				female = "content/ui/textures/icons/appearances/body_types/feminine",
				male = "content/ui/textures/icons/appearances/body_types/masculine",
			}

			for j = 1, #entry_options do
				local option = entry_options[j]

				options[#options + 1] = {
					on_pressed_function = function (grid_index, widget, pressed_options)
						if option ~= self._character_create:gender() then
							self._character_create:set_gender(option)

							local page = self._pages[self._active_page_number]
							local grids = page.grids

							if grids then
								for i = 1, #grids do
									local grid = grids[i]

									self:_populate_page_grid(1, grid)
								end
							end
						end
					end,
					value = option,
					icon_texture = gender_presentation[option],
					on_focused_function = function (widget)
						return
					end,
				}
			end

			grids[i].selected_option = function ()
				return self._character_create:gender()
			end
		elseif entry_type == "skin_color" then
			for j = 1, #entry_options do
				local option = entry_options[j]
				local skin_override = SkinMaterialOverrides[option.material_overrides[1]]
				local property_overrides = skin_override.property_overrides
				local hsv_skin = property_overrides.hsv_skin

				options[#options + 1] = {
					color = hsv_skin,
					value = option,
					on_pressed_function = function (grid_index, widget, pressed_options)
						self._character_create:set_item_per_slot(entry_slot_name, option)
						remove_gamepad_focused_slots(self, entry_slot_name)
						self:_update_icons()
					end,
					on_focused_function = function (grid_index, widget)
						add_gamepad_focused_slots(self, entry_slot_name, option)
					end,
				}
			end

			grids[i].selected_option = function ()
				return self._character_create:slot_item(entry_slot_name)
			end
			grids[i].texture = "content/ui/materials/icons/appearances/skin_color"
		elseif entry_type == "eye_type" then
			for j = 1, #entry_options do
				local option = entry_options[j]

				options[#options + 1] = {
					value = option,
					icon_texture = option.icon_texture,
					on_pressed_function = function (grid_index, widget, pressed_options)
						local eye_options, selected_option = eye_items_by_selected_type(option)

						if not selected_option then
							return
						end

						self._character_create:set_item_per_slot(entry_slot_name, selected_option)
						remove_gamepad_focused_slots(self, entry_slot_name)
						add_eye_color_grid(eye_options)
					end,
					on_focused_function = function (grid_index, widget)
						local new_eye_options, selected_option = eye_items_by_selected_type(option)

						if not selected_option then
							return
						end

						add_gamepad_focused_slots(self, entry_slot_name, selected_option, nil, function (original_option)
							local eye_type_index = get_eye_type_index_by_option(original_option)
							local eye_type_option = eye_types[eye_type_index]
							local new_eye_options, selected_option = eye_items_by_selected_type(eye_type_option)

							if selected_option then
								local var_3_0

								if self._navigation.grid == 3 then
									var_3_0 = {
										grid_index = self._navigation.grid,
										widget_index = self._navigation.index,
									}
								else
									var_3_0 = false
								end

								goto label_3_0

								var_3_0 = true

								local init_pressed_options = var_3_0

								::label_3_0::

								add_eye_color_grid(new_eye_options, {
									force_focus_navigation = self._navigation.previous_grid ~= self._navigation.grid and self._navigation.grid == 3,
								})
							end
						end)
						add_eye_color_grid(new_eye_options, {
							from_eye_type_focused = true,
						})
					end,
				}
			end

			grids[i].selected_option = function ()
				local option = self._character_create:slot_item(entry_slot_name)
				local index = get_eye_type_index_by_option(option)
				local selected_eye_type = eye_types[index]
				local selected_eye_type_name = selected_eye_type and selected_eye_type.name

				for j = 1, #entry_options do
					local entry_option = entry_options[j]

					if entry_option.name == selected_eye_type_name then
						return entry_option
					end
				end
			end
		elseif entry_type == "eye_color" then
			for j = 1, #entry_options do
				local option = entry_options[j]
				local eye_override = EyeMaterialOverrides[option.material_overrides[1]]
				local property_overrides = eye_override.property_overrides
				local hsv_eye = property_overrides.hsv_eye

				options[#options + 1] = {
					value = option,
					color = hsv_eye,
					on_pressed_function = function (grid_index, widget, pressed_options)
						local page_grid = self._page_grids[grid_index]

						if pressed_options and pressed_options.force_focus_navigation then
							local previous_grid = self._navigation.previous_grid
							local previous_index = self._navigation.previous_index

							self._navigation.previous_grid = self._navigation.grid
							self._navigation.previous_index = self._navigation.index
							self._navigation.grid = previous_grid
							self._navigation.index = previous_index

							self:_grid_navigation("right")
						elseif not pressed_options or not pressed_options.from_eye_type_focused then
							self._character_create:set_item_per_slot(entry_slot_name, option)
							remove_gamepad_focused_slots(self, entry_slot_name)
						end
					end,
					on_focused_function = function (grid_index, widget, pressed_options)
						if pressed_options and pressed_options.from_eye_type_focused then
							return
						end

						add_gamepad_focused_slots(self, entry_slot_name, option)
					end,
				}
			end

			grids[i].texture = "content/ui/materials/icons/appearances/eye_color"
			grids[i].selected_option = function ()
				return self._character_create:slot_item(entry_slot_name)
			end
		elseif entry_type == "hair_color" then
			for j = 1, #entry_options do
				local option = entry_options[j]
				local skin_override = HairMaterialOverrides[option.material_overrides[1]]
				local property_overrides = skin_override.property_overrides
				local hair_rgb = property_overrides.hair_rgb
				local color = {
					255,
					hair_rgb[1] * 255,
					hair_rgb[2] * 255,
					hair_rgb[3] * 255,
				}

				options[#options + 1] = {
					color = color,
					value = option,
					on_pressed_function = function (grid_index, widget, pressed_options)
						self._character_create:set_item_per_slot(entry_slot_name, option)
						remove_gamepad_focused_slots(self, entry_slot_name)
						self:_update_icons()
					end,
					on_focused_function = function (grid_index, widget)
						add_gamepad_focused_slots(self, entry_slot_name, option)
					end,
				}
			end

			grids[i].selected_option = function ()
				return self._character_create:slot_item(entry_slot_name)
			end
			grids[i].texture = "content/ui/materials/icons/appearances/hair_color"
		elseif entry_type == "dog_fur" then
			for name, option in pairs(entry_options) do
				local overrides = option.material_overrides and DogFurOverrides[option.material_overrides[1]]
				local texture_overrides = overrides and overrides.texture_overrides
				local texture = texture_overrides and texture_overrides.fur_color_gradient.resource or ""

				options[#options + 1] = {
					value = option,
					icon_texture = texture,
					on_pressed_function = function (grid_index, widget, pressed_options)
						self._character_create:set_item_per_slot(entry_slot_name, option)
						remove_gamepad_focused_slots(self, entry_slot_name)

						local skin_options = dog_skin_items_by_selected_pattern(option)

						add_dog_skin_grid(skin_options)
					end,
					on_focused_function = function (grid_index, widget)
						add_gamepad_focused_slots(self, entry_slot_name, option, nil, function (original_option)
							local dog_fur_option = self._character_create:slot_item(entry_slot_name)
							local skin_options = dog_skin_items_by_selected_pattern(dog_fur_option)
							local var_3_0

							if self._navigation.grid == 3 then
								var_3_0 = {
									grid_index = self._navigation.grid,
									widget_index = self._navigation.index,
								}
							else
								var_3_0 = false
							end

							goto label_3_0

							var_3_0 = true

							local init_pressed_options = var_3_0

							::label_3_0::

							remove_gamepad_focused_slots(self, "slot_companion_body_skin_color")
							add_dog_skin_grid(skin_options, {
								force_focus_navigation = self._navigation.previous_grid ~= self._navigation.grid and self._navigation.grid == 3,
							})
						end)

						local skin_options = dog_skin_items_by_selected_pattern(option)

						add_dog_skin_grid(skin_options, {
							from_dog_fur_focused = true,
						})
					end,
				}
			end

			grids[i].selected_option = function ()
				return self._character_create:slot_item(entry_slot_name)
			end
		elseif entry_type == "dog_skin" then
			for name, option in pairs(entry_options) do
				local overrides = option.material_overrides and DogSkinOverrides[option.material_overrides[1]]
				local property_overrides = overrides and overrides.property_overrides
				local hsv_skin = property_overrides and property_overrides.skin_hsv or {
					0,
					0,
					0,
				}

				options[#options + 1] = {
					color = hsv_skin,
					value = option,
					on_pressed_function = function (grid_index, widget, pressed_options)
						if pressed_options and pressed_options.force_focus_navigation then
							local previous_grid = self._navigation.previous_grid
							local previous_index = self._navigation.previous_index

							self._navigation.previous_grid = self._navigation.grid
							self._navigation.previous_index = self._navigation.index
							self._navigation.grid = previous_grid
							self._navigation.index = previous_index

							self:_grid_navigation("right")
						elseif not pressed_options or not pressed_options.from_dog_fur_focused then
							self._character_create:set_item_per_slot(entry_slot_name, option)
							remove_gamepad_focused_slots(self, entry_slot_name)
						else
							add_gamepad_focused_slots(self, entry_slot_name, option)
						end
					end,
					on_focused_function = function (grid_index, widget, pressed_options)
						if pressed_options and pressed_options.from_dog_fur_focused then
							return
						end

						add_gamepad_focused_slots(self, entry_slot_name, option)
					end,
				}
			end

			grids[i].texture = "content/ui/materials/icons/appearances/skin_color"
			grids[i].selected_option = function ()
				return self._character_create:slot_item(entry_slot_name)
			end
		elseif entry_type == "height" then
			options[#options + 1] = {
				on_value_updated = function (value)
					local height_range = self._character_create:get_height_values_range()
					local min_height = height_range.min
					local max_height = height_range.max
					local scale_factor = math.lerp(min_height, max_height, value)
					local fmtStr = string.format("%%0.%sf", 3)

					scale_factor = string.format(fmtStr, scale_factor)
					scale_factor = tonumber(scale_factor)

					self:_set_character_height(scale_factor)
					self:_set_camera(nil, nil, 0)
				end,
			}
		elseif entry_type == "dog_coat" then
			for name, option in pairs(entry_options) do
				local index = #options + 1
				local icon_texture

				if entry_no_option then
					if index == 1 then
						icon_texture = "content/ui/textures/icons/appearances/no_option"
					else
						icon_texture = string.format("content/ui/textures/icons/appearances/roman_numerals/%d", index - 1)
					end
				else
					icon_texture = string.format("content/ui/textures/icons/appearances/roman_numerals/%d", index)
				end

				options[index] = {
					value = option,
					icon_texture = icon_texture,
					on_pressed_function = function (grid_index, widget, pressed_options)
						self._character_create:set_item_per_slot(entry_slot_name, option)
						remove_gamepad_focused_slots(self, entry_slot_name)
					end,
					on_focused_function = function (grid_index, widget)
						add_gamepad_focused_slots(self, entry_slot_name, option)
					end,
				}
			end

			grids[i].selected_option = function ()
				return self._character_create:slot_item(entry_slot_name)
			end
		else
			for j = 1, #entry_options do
				local option = entry_options[j]
				local index = #options + 1
				local icon_texture

				if entry_no_option then
					if index == 1 then
						icon_texture = "content/ui/textures/icons/appearances/no_option"
					else
						icon_texture = string.format("content/ui/textures/icons/appearances/roman_numerals/%d", index - 1)
					end
				else
					icon_texture = string.format("content/ui/textures/icons/appearances/roman_numerals/%d", index)
				end

				options[index] = {
					value = option,
					icon_texture = icon_texture,
					on_pressed_function = function (grid_index, widget, pressed_options)
						self._character_create:set_item_per_slot(entry_slot_name, option)
						remove_gamepad_focused_slots(self, entry_slot_name)
						self:_update_icons()
					end,
					on_focused_function = function (grid_index, widget)
						add_gamepad_focused_slots(self, entry_slot_name, option)
					end,
				}
			end

			grids[i].selected_option = function ()
				return self._character_create:slot_item(entry_slot_name)
			end
		end
	end

	return grids
end

CharacterAppearanceView._check_valid_option = function (self, option)
	if option and type(option.data) ~= "table" and type(option.value) ~= "table" then
		return true
	end

	local value = option.data or option
	local visible = true
	local available = true
	local reason, reason_display_name

	visible = self._character_create:is_option_visible(value)

	if visible then
		available, reason, reason_display_name = self._character_create:is_option_available(value)
	end

	return visible, available, reason, reason_display_name
end

CharacterAppearanceView._randomize_character_appearance = function (self)
	self._character_create:randomize_presets()
	self:_update_selection()
	self:_update_icons()
end

CharacterAppearanceView._update_selection = function (self)
	for i = 1, #self._page_grids do
		local page_grid = self._page_grids[i]
		local selected_option_func = page_grid.grid_data and page_grid.grid_data.selected_option

		if selected_option_func then
			local selected_option = selected_option_func()
			local widgets = page_grid.widgets

			if selected_option and widgets then
				for j = 1, #widgets do
					local widget = widgets[j]
					local widget_option = widget.content.option

					if selected_option == widget_option.value then
						page_grid.grid:select_widget(widget, false, true)

						break
					end
				end
			end
		end
	end
end

CharacterAppearanceView._update_icons = function (self)
	for i = 1, #self._page_grids do
		local grid = self._page_grids[i]
		local widgets = grid.widgets

		if widgets then
			for j = 1, #grid.widgets do
				local widget = grid.widgets[j]
				local element = widget.content.element
				local template_name = element and element.template
				local template = template_name and ContentBlueprints[template_name]
				local update_func = template and template.update_icon

				if widget.content.icon_load_id and update_func then
					update_func(self, widget, element)
				end
			end
		end
	end
end

CharacterAppearanceView._get_personality_options = function (self)
	local personalities = self._character_create:personality_options()
	local personality_options = {}

	local function on_personality_voice_trigger(personality_settings, widget)
		local world = Managers.ui:world()
		local wwise_world = Managers.world:wwise_world(world)
		local sample_sound_event = personality_settings.sample_sound_event

		for i = 1, #self._page_grids[1].widgets do
			local widget = self._page_grids[1].widgets[i]
			local sound_id = widget.content.sound_id

			if sound_id and WwiseWorld.is_playing(wwise_world, sound_id) then
				WwiseWorld.stop_event(wwise_world, sound_id)

				widget.content.sound_id = nil
			end
		end

		self:_play_sound(UISoundEvents.character_appearence_stop_voice_preview)

		widget.content.sound_id = self:_play_sound(sample_sound_event)
	end

	for id, option in pairs(personalities) do
		personality_options[#personality_options + 1] = {
			continue_validation = function ()
				local current_personality = self._character_create:personality()

				if current_personality and current_personality.id == id then
					return self._character_create:is_option_available(current_personality)
				end

				return true
			end,
			data = option,
			text = Localize(option.display_name),
			value = id,
			on_pressed_function = function (grid_index, widget, pressed_options)
				self._character_create:set_personality(id)

				local skip_voice = pressed_options and (pressed_options.skip_voice or pressed_options.initialization_press)

				if not skip_voice then
					on_personality_voice_trigger(option, widget)
				end

				local grid_index = 2
				local grid_data = {
					init = function ()
						return self:_generate_backstory_grid_widgets(grid_index, option)
					end,
				}

				self:_populate_page_grid(grid_index, grid_data)
			end,
		}
	end

	return personality_options
end

CharacterAppearanceView._get_crime_options = function (self)
	local crimes = self._character_create:crime_options()
	local crime_options = {}

	for id, option in pairs(crimes) do
		crime_options[#crime_options + 1] = {
			data = option,
			text = Localize(option.display_name),
			value = id,
			on_pressed_function = function (grid_index, widget, pressed_options)
				self._character_create:set_crime(id)

				local grid_index = 2
				local grid_data = {
					init = function ()
						return self:_generate_backstory_grid_widgets(grid_index, option)
					end,
				}

				self:_populate_page_grid(grid_index, grid_data)
			end,
		}
	end

	return crime_options
end

CharacterAppearanceView._pan_camera = function (self, revert)
	local world_spawner = self._world_spawner
	local dx = 0
	local profile = self._character_create:profile()
	local selected_archetype = profile.archetype.name

	if not revert and selected_archetype == "ogryn" then
		dx = self._is_barber_mindwipe and 1.5 or 1.7
	elseif not revert then
		dx = self._is_barber_mindwipe and 0.85 or 1.2
	end

	local time = 1.5
	local func_ptr = math.easeOutCubic

	world_spawner:set_target_camera_offset_for_axis("dx", dx, time, func_ptr)
end

CharacterAppearanceView._generate_final_page_widgets = function (self, grid_index, grid_data, is_companion)
	local grid_start_name = "grid_" .. grid_index .. "_"
	local grid_scenegraph = grid_start_name .. "pivot"
	local grid_area_scenegraph = grid_start_name .. "area"
	local grid_content_scenegraph = grid_start_name .. "content"
	local templates = {}
	local background_size = {
		660,
		0,
	}
	local grid_margin = 30
	local grid_size = {
		background_size[1] - grid_margin * 2,
		0,
	}
	local spacing = {
		10,
		0,
	}
	local text_style = CharacterAppearanceViewFontStyle.randomize_button_text_style
	local randomize_text = Utf8.upper(Localize("loc_randomize"))
	local style = UIFonts.get_font_options_by_style(text_style)
	local text_width, text_height = UIRenderer.text_size(self._ui_renderer, randomize_text, text_style.font_type, text_style.font_size, {
		math.huge,
		500,
	}, style)
	local icon_width = 30
	local text_margin = 15
	local button_margin = {
		40,
		0,
	}
	local randomize_size = {
		text_width + 100,
		60,
	}
	local randomize_button_width = 300
	local input_width = grid_size[1] - randomize_size[1] - spacing[1]
	local input_name_template, input_template

	if not is_companion then
		input_name_template = {
			size = {
				grid_size[1],
				30,
			},
			pass_template = {
				{
					pass_type = "text",
					style_id = "text",
					value_id = "text",
					value = Localize("loc_character_create_title_name"),
					style = CharacterAppearanceViewFontStyle.header_final_title_style,
				},
				{
					pass_type = "rect",
					style_id = "baseline",
					style = {
						vertical_alignment = "bottom",
						color = Color.terminal_corner(255, true),
						size = {
							nil,
							2,
						},
					},
				},
			},
		}

		local template_type = "name_input"
		local template = ContentBlueprints[template_type]
		local pass_template = template.pass_template
		local character_name = self._character_create:name()

		if character_name == "" or character_name == nil then
			if self._original_name then
				self._character_create:set_name(self._original_name)
			else
				self:_randomize_character_name()
			end
		end

		character_name = self._character_create:name()
		input_template = {
			support_widget_name = "name_input",
			size = {
				input_width,
				60,
			},
			pass_template = template.pass_template,
			init = function (parent, widget, element)
				template.init(parent, widget, element)
				parent:_update_character_name(widget, element.initial_name)
			end,
			element = {
				max_length = 18,
				initial_name = character_name,
				template = template_type,
				error_message = Localize("loc_character_create_name_validation_failed_message"),
				on_update_function = function (parent, widget)
					local name = type(widget.content.input_text) == "string" and widget.content.input_text ~= "" and widget.content.input_text or widget.content.selected_text or ""

					if self._character_create:name() ~= name then
						parent:_update_character_custom_name(widget, name)
					end
				end,
			},
		}
	else
		input_name_template = {
			size = {
				grid_size[1],
				30,
			},
			pass_template = {
				{
					pass_type = "text",
					style_id = "text",
					value_id = "text",
					value = Localize("loc_character_creator_mastiff_name"),
					style = CharacterAppearanceViewFontStyle.header_final_title_style,
				},
				{
					pass_type = "rect",
					style_id = "baseline",
					style = {
						vertical_alignment = "bottom",
						color = Color.terminal_corner(255, true),
						size = {
							nil,
							2,
						},
					},
				},
			},
		}

		local template_type = "name_input"
		local template = ContentBlueprints[template_type]
		local pass_template = template.pass_template
		local companion_character_name = self._character_create:companion_name()

		if companion_character_name == "" or companion_character_name == nil then
			if self._original_companion_name then
				self._character_create:set_companion_name(self._original_companion_name)
			else
				self:_randomize_companion_name()
			end
		end

		companion_character_name = self._character_create:companion_name()
		input_template = {
			support_widget_name = "companion_name_input",
			size = {
				input_width,
				60,
			},
			pass_template = template.pass_template,
			init = function (parent, widget, element)
				template.init(parent, widget, element)
				parent:_update_companion_name(widget, element.initial_name)
			end,
			element = {
				max_length = 15,
				initial_name = companion_character_name,
				template = template_type,
				error_message = Localize("loc_character_create_name_validation_failed_message_companion"),
				on_update_function = function (parent, widget)
					local name = type(widget.content.input_text) == "string" and widget.content.input_text ~= "" and widget.content.input_text or widget.content.selected_text or ""

					if self._character_create:companion_name() ~= name then
						parent:_update_companion_custom_name(widget, name)
					end
				end,
			},
		}
	end

	local function randomize_button_template(is_companion)
		return {
			size = randomize_size,
			pass_template = {
				{
					content_id = "hotspot",
					pass_type = "hotspot",
					content = {
						on_hover_sound = UISoundEvents.default_mouse_hover,
						on_pressed_sound = UISoundEvents.default_click,
					},
				},
				{
					pass_type = "texture",
					style_id = "icon",
					value = "content/ui/materials/base/ui_default_base",
					value_id = "icon",
					style = {
						vertical_alignment = "center",
						hover_color = Color.terminal_frame_selected(255, true),
						default_color = Color.terminal_text_body(255, true),
						color = Color.terminal_text_body(255, true),
						size = {
							30,
							30,
						},
						material_values = {
							texture_map = "content/ui/textures/icons/generic/randomize",
						},
						offset = {
							20,
							0,
							2,
						},
					},
					change_function = function (content, style, _, dt)
						local default_color = style.default_color
						local hover_color = style.hover_color
						local color = style.color
						local hotspot = content.hotspot
						local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

						ColorUtilities.color_lerp(default_color, hover_color, progress, color)

						style.hdr = progress == 1
					end,
					visibility_function = function (content, style)
						return self._using_cursor_navigation
					end,
				},
				{
					pass_type = "texture",
					style_id = "background_gradient",
					value = "content/ui/materials/masks/gradient_horizontal_sides_dynamic_02",
					style = {
						horizontal_alignment = "center",
						offset = {
							0,
							0,
							3,
						},
						size_addition = {
							-10,
							0,
						},
						default_color = Color.terminal_frame(nil, true),
						hover_color = Color.terminal_frame_selected(nil, true),
						color = Color.terminal_text_body(255, true),
					},
					change_function = function (content, style, _, dt)
						local default_color = style.default_color
						local hover_color = style.hover_color
						local color = style.color
						local hotspot = content.hotspot
						local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

						ColorUtilities.color_lerp(default_color, hover_color, progress, color)

						style.hdr = progress == 1
					end,
					visibility_function = function (content, style)
						return content.hotspot.is_focused or content.hotspot.is_hover
					end,
				},
				{
					pass_type = "texture",
					style_id = "frame",
					value = "content/ui/materials/frames/frame_tile_2px",
					style = {
						horizontal_alignment = "center",
						scale_to_material = true,
						vertical_alignment = "center",
						size_addition = {
							-10,
							0,
						},
						default_color = Color.terminal_frame(nil, true),
						hover_color = Color.terminal_frame_selected(nil, true),
						color = Color.terminal_text_body(255, true),
						offset = {
							0,
							0,
							4,
						},
					},
					change_function = function (content, style, _, dt)
						local default_color = style.default_color
						local hover_color = style.hover_color
						local color = style.color
						local hotspot = content.hotspot
						local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

						ColorUtilities.color_lerp(default_color, hover_color, progress, color)

						style.hdr = progress == 1
					end,
				},
				{
					pass_type = "texture",
					style_id = "corner",
					value = "content/ui/materials/frames/frame_corner_2px",
					style = {
						horizontal_alignment = "center",
						scale_to_material = true,
						vertical_alignment = "center",
						size_addition = {
							-10,
							0,
						},
						default_color = Color.terminal_corner(nil, true),
						hover_color = Color.terminal_corner_selected(nil, true),
						color = Color.terminal_text_body(255, true),
						offset = {
							0,
							0,
							5,
						},
					},
					change_function = function (content, style, _, dt)
						local default_color = style.default_color
						local hover_color = style.hover_color
						local color = style.color
						local hotspot = content.hotspot
						local progress = math.max(hotspot.anim_focus_progress, hotspot.anim_hover_progress)

						ColorUtilities.color_lerp(default_color, hover_color, progress, color)

						style.hdr = progress == 1
					end,
				},
				{
					pass_type = "text",
					style_id = "text",
					value = "",
					value_id = "text",
					style = CharacterAppearanceViewFontStyle.randomize_button_text_style,
					change_function = function (content, style)
						ButtonPassTemplates.default_button_text_change_function(content, style)

						local original_offset = CharacterAppearanceViewFontStyle.randomize_button_text_style.offset[1]

						style.offset[1] = self._using_cursor_navigation and original_offset or 24
					end,
				},
			},
			init = function (parent, widget, element)
				widget.content.ignore_navigation = true

				widget.content.hotspot.pressed_callback = function ()
					if not self._using_cursor_navigation then
						self:_play_sound(UISoundEvents.character_appearence_option_pressed)
					end

					local input_widget = parent._page_grids and parent._page_grids[1] and parent._page_grids[1].support_widgets_by_name

					if is_companion then
						input_widget = input_widget and input_widget.companion_name_input

						self:_randomize_companion_name(input_widget)
					else
						input_widget = input_widget and input_widget.name_input

						self:_randomize_character_name(input_widget)
					end
				end
			end,
			content = {
				gamepad_action = "hotkey_menu_special_2",
				original_text = randomize_text,
			},
		}
	end

	local backstory_text = self:_generate_final_backstory_text()
	local backstory_font_style = CharacterAppearanceViewFontStyle.description_style
	local backstory_style = UIFonts.get_font_options_by_style(backstory_font_style)
	local backstory_text_width, backstory_text_height = UIRenderer.text_size(self._ui_renderer, backstory_text, backstory_font_style.font_type, backstory_font_style.font_size, {
		grid_size[1],
		0,
	}, backstory_style)
	local backstory_size = {
		grid_size[1],
		backstory_text_height + 10,
	}
	local backstory_text_template = {
		size = backstory_size,
		pass_template = {
			{
				pass_type = "text",
				style_id = "text",
				value_id = "text",
				value = backstory_text,
				style = backstory_font_style,
			},
		},
	}

	templates[#templates + 1] = input_name_template
	templates[#templates + 1] = {
		size = {
			grid_size[1],
			15,
		},
	}
	templates[#templates + 1] = input_template
	templates[#templates + 1] = randomize_button_template(is_companion)
	templates[#templates + 1] = {
		size = {
			grid_size[1],
			20,
		},
	}

	if not is_companion then
		templates[#templates + 1] = backstory_text_template
	end

	local widgets = {}
	local support_widgets = {}
	local alignment_list = {}
	local total_height = 0
	local accumulated_width = 0
	local accumulated_height = 0

	for i = 1, #templates do
		local template = templates[i]
		local widget
		local size = template.size

		accumulated_width = accumulated_width + size[1]
		accumulated_height = math.max(accumulated_height, size[2])

		local next_width = templates[i + 1] and templates[i + 1].size[1] or 0

		if accumulated_width + next_width > grid_size[1] then
			total_height = total_height + accumulated_height
			accumulated_height = 0
			accumulated_width = 0
		end

		if template.pass_template then
			local template_content = template.content
			local definition = UIWidget.create_definition(template.pass_template, grid_scenegraph, template_content, size)

			widget = self:_create_widget(grid_start_name .. "widget_" .. i, definition)

			if template.init then
				template.init(self, widget, template.element)
			end
		end

		if widget then
			widgets[#widgets + 1] = widget
			alignment_list[#alignment_list + 1] = widget

			local support_widget_name = template.support_widget_name

			if support_widget_name then
				support_widgets[support_widget_name] = widget
				widget.content.is_grid_widget = true
			end
		else
			widgets[#widgets + 1] = nil
			alignment_list[#alignment_list + 1] = {
				size = size,
			}
		end
	end

	if accumulated_width > 0 then
		total_height = total_height + accumulated_height
	end

	background_size[2] = total_height + grid_margin * 2
	grid_size[2] = total_height

	local support_widget_definitions = {
		grid_background = UIWidget.create_definition({
			{
				pass_type = "texture",
				style_id = "top_frame",
				value = "content/ui/materials/dividers/horizontal_frame_big_upper",
				value_id = "top_frame",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "top",
					size = {
						nil,
						36,
					},
					offset = {
						0,
						-18,
						1,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "background",
				value = "content/ui/materials/backgrounds/terminal_basic",
				value_id = "background",
				style = {
					horizontal_alignment = "center",
					scale_to_material = true,
					vertical_alignment = "top",
					color = Color.terminal_grid_background(nil, true),
					size_addition = {
						20,
						30,
					},
					offset = {
						0,
						-15,
						0,
					},
				},
			},
			{
				pass_type = "texture",
				style_id = "bottom_frame",
				value = "content/ui/materials/dividers/horizontal_frame_big_lower",
				value_id = "bottom_frame",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "bottom",
					size = {
						nil,
						36,
					},
					offset = {
						0,
						18,
						1,
					},
				},
			},
		}, grid_scenegraph, nil, background_size),
		mask = UIWidget.create_definition({
			{
				pass_type = "texture",
				value = "content/ui/materials/offscreen_masks/ui_overlay_offscreen_straight_blur",
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					color = {
						255,
						255,
						255,
						255,
					},
					offset = {
						0,
						0,
						5,
					},
					size_addition = {
						20,
						20,
					},
				},
			},
		}, grid_area_scenegraph, nil, background_size),
		error = UIWidget.create_definition({
			{
				pass_type = "text",
				style_id = "text",
				value = "",
				value_id = "text",
				style = CharacterAppearanceViewFontStyle.error_style,
			},
		}, "error_input", nil, {
			374,
		}),
	}

	for name, definition in pairs(support_widget_definitions) do
		local widget = self:_create_widget(grid_start_name .. "support_widget_" .. name, definition)

		if name == "grid_background" then
			widget.offset = {
				widget.offset[1] - grid_margin,
				widget.offset[2] - grid_margin,
				widget.offset[3] + 4,
			}
		end

		widget.offset = {
			widget.offset[1],
			widget.offset[2],
			widget.offset[3] + 4,
		}
		support_widgets[name] = widget
	end

	local grid_position = {
		self._ui_scenegraph.canvas.size[1] - background_size[1] + grid_margin,
		50 + grid_margin,
	}
	local grid_data = {
		grid_size = background_size,
		grid_position = grid_position,
		grid_scenegraph = grid_scenegraph,
		grid_area_scenegraph = grid_area_scenegraph,
		grid_content_scenegraph = grid_content_scenegraph,
		grid_spacing = spacing,
	}

	return widgets, alignment_list, support_widgets, grid_data
end

CharacterAppearanceView._generate_final_backstory_text = function (self)
	local planet_snippet = self._character_create:planet().story_snippet
	local childhood_snippet = self._character_create:childhood().story_snippet
	local growing_up_snippet = self._character_create:growing_up().story_snippet
	local formative_event_snippet = self._character_create:formative_event().story_snippet
	local crime_snippet = self._character_create:crime().story_snippet
	local end_snippet = Localize("loc_character_backstory_snippet")
	local profile = self._character_create:profile()
	local archetype = profile.archetype and profile.archetype.name

	if archetype == "adamant" then
		end_snippet = Localize("loc_character_backstory_snippet_adamant")
	end

	if self._is_barber_mindwipe then
		end_snippet = Localize("loc_character_backstory_snippet_mindwipe")
	end

	local backstory_text = string.format("%s %s %s %s\n\n%s\n\n%s", Localize(planet_snippet), Localize(childhood_snippet), Localize(growing_up_snippet), Localize(formative_event_snippet), Localize(crime_snippet), end_snippet)

	return backstory_text
end

CharacterAppearanceView._randomize_character_name = function (self, input_widget)
	local name = self._character_create:randomize_name()

	self._character_create:set_name(name)

	self._character_name_status.custom = false

	if input_widget then
		self:_stop_name_input(input_widget)

		input_widget.content.input_text = name
	end

	local error_widget = self._page_grids and self._page_grids[1] and self._page_grids[1].support_widgets_by_name and self._page_grids[1].support_widgets_by_name.error

	if error_widget then
		self:_check_input_errors(error_widget, name)
	end
end

CharacterAppearanceView._randomize_companion_name = function (self, input_widget)
	local name = self._character_create:randomize_companion_name()

	self._character_create:set_companion_name(name)

	self._companion_name_status.custom = false

	if input_widget then
		self:_stop_name_input(input_widget)

		input_widget.content.input_text = name
	end

	local error_widget = self._page_grids and self._page_grids[1] and self._page_grids[1].support_widgets_by_name and self._page_grids[1].support_widgets_by_name.error

	if error_widget then
		self:_check_input_errors(error_widget, name)
	end
end

CharacterAppearanceView._set_camera = function (self, camera_focus, no_height_compensation, time)
	time = time or 1
	self._disable_zoom = false

	local in_barber_chair = self._in_barber_chair
	local slot_camera_unit = self._camera_by_slot_id[camera_focus]

	self._focus_camera_unit = slot_camera_unit

	local world_spawner = self._world_spawner
	local func_ptr = math.easeOutCubic
	local is_camera_zoomed = self:_is_camera_zoomed(camera_focus)
	local camera_zoom_changed = self._camera_zoomed ~= is_camera_zoomed
	local profile = self._character_create:profile()
	local archetype_settings = profile.archetype
	local archetype_name = archetype_settings.name

	if camera_zoom_changed then
		local animations_per_archetype = CharacterAppearanceViewSettings.animations_per_archetype
		local animations_settings = animations_per_archetype[archetype_name]
		local animation_event = is_camera_zoomed and animations_settings.events.head or animations_settings.events.body

		if not in_barber_chair then
			self._profile_spawner:assign_animation_event(animation_event)
		end

		self._camera_zoomed = is_camera_zoomed
	end

	local boxed_camera_start_position = world_spawner:boxed_camera_start_position()
	local default_camera_world_position = Vector3.from_array(boxed_camera_start_position)
	local boxed_camera_start_rotation = world_spawner:boxed_camera_start_rotation()
	local default_camera_world_rotation = boxed_camera_start_rotation:unbox()
	local target_world_position = slot_camera_unit and Unit.world_position(slot_camera_unit, 1) or default_camera_world_position
	local target_world_rotation = slot_camera_unit and Unit.world_rotation(slot_camera_unit, 1) or default_camera_world_rotation

	do
		local x, y, z = target_world_position.x, target_world_position.y, target_world_position.z

		if no_height_compensation then
			local model_height_difference = archetype_name == "ogryn" and -0.2 or 0

			z = z + model_height_difference
		else
			local height = self._character_create:height()

			z = z * height
		end

		world_spawner:set_target_camera_position(x, y, z, time, func_ptr)
	end

	world_spawner:set_target_camera_rotation(target_world_rotation, time, func_ptr)
end

CharacterAppearanceView._zoom_camera = function (self)
	local slot_name

	slot_name = (not self._camera_zoomed or nil) and "slot_body_face"

	self:_set_camera(slot_name)
end

CharacterAppearanceView._check_widget_choice_detail_visibility = function (self, grid_index, widget_index)
	local page_grid = self._page_grids[grid_index]
	local widget = page_grid and page_grid.widgets[widget_index]
	local presentation_data = widget and widget.content and widget.content.choice_data

	if not presentation_data then
		self._widgets_by_name.choice_detail.content.visible = false

		return
	end

	local available = presentation_data.available
	local reason = presentation_data.reason
	local reason_display_name = presentation_data.reason_display_name and Localize(presentation_data.reason_display_name)
	local choice_info = reason and choices_presentation[reason]

	if reason then
		self._widgets_by_name.choice_detail.content.visible = true
		self._widgets_by_name.choice_detail.content.available = available
	else
		self._widgets_by_name.choice_detail.content.visible = false
	end

	if choice_info then
		self._widgets_by_name.choice_detail.content.use_choice_icon = true
		self._widgets_by_name.choice_detail.style.choice_icon.material_values = {
			texture_map = choice_info.icon_texture,
		}

		if reason_display_name then
			self._widgets_by_name.choice_detail.content.text = Localize("loc_character_create_choice_reason", true, {
				description = Localize(choice_info.title),
				choice = reason_display_name,
			})
		else
			self._widgets_by_name.choice_detail.content.text = ""
		end

		local grid_position = page_grid.position
		local grid_size = page_grid.size

		self:_set_scenegraph_position("choice_detail", grid_position[1], grid_position[2] + grid_size[2] + 20)
	else
		self._widgets_by_name.choice_detail.content.use_choice_icon = false
		self._widgets_by_name.choice_detail.content.text = ""
	end
end

CharacterAppearanceView._set_camera_height_option = function (self, camera_focus)
	self:_set_camera(camera_focus, true)

	self._disable_zoom = true

	local time = 1
	local func_ptr = math.easeOutCubic
	local profile = self._character_create:profile()
	local selected_archetype = profile.archetype.name
	local world_spawner = self._world_spawner

	if selected_archetype == "ogryn" then
		world_spawner:set_target_camera_offset_for_axis("dy", -0.5, time, func_ptr)
	else
		world_spawner:set_target_camera_offset_for_axis("dy", -0.5, time, func_ptr)
	end
end

CharacterAppearanceView._fetch_suggested_names = function (self)
	local profile = self._character_create:profile()
	local selected_archetype = profile.archetype.name
	local selected_gender = self._character_create:gender()

	if self._character_name_status.archetype ~= selected_archetype or self._character_name_status.gender ~= selected_gender then
		self._character_name_status.archetype = selected_archetype
		self._character_name_status.gender = selected_gender

		return self._character_create:_fetch_suggested_names_by_profile():next(function ()
			return true
		end):catch(function ()
			return true
		end)
	else
		return Promise.resolved(true)
	end
end

CharacterAppearanceView._check_input_errors = function (self, widget, name)
	local input_error = true
	local string_empty = name and #name < 3

	if not name then
		string_empty = true
	end

	input_error = string_empty

	self:_update_continue_button("input_error", input_error)

	local error_widget = self._page_grids and self._page_grids[1] and self._page_grids[1].support_widgets_by_name and self._page_grids[1].support_widgets_by_name.error

	if error_widget then
		error_widget.content.text = input_error and widget.content.error_message or ""
	end
end

CharacterAppearanceView._update_character_custom_name = function (self, widget, name)
	self._character_name_status.custom = true

	self:_update_character_name(widget, name)
end

CharacterAppearanceView._update_character_name = function (self, widget, name)
	self:_check_input_errors(widget, name)
	self._character_create:set_name(name)
end

CharacterAppearanceView._update_companion_custom_name = function (self, widget, name)
	self._companion_name_status.custom = true

	self:_update_companion_name(widget, name)
end

CharacterAppearanceView._update_companion_name = function (self, widget, name)
	self:_check_input_errors(widget, name)
	self._character_create:set_companion_name(name)
end

CharacterAppearanceView._stop_name_input = function (self, input_widget)
	if input_widget then
		local content = input_widget.content

		content.selected_text = nil
		content._selection_start = nil
		content._selection_end = nil
		content.is_writing = false
	end
end

CharacterAppearanceView._show_loading_awaiting_validation = function (self, is_active)
	self._loading_overlay_visible = is_active

	if is_active then
		self._widgets_by_name.loading_overlay.content.text = Localize("loc_character_create_await_validation")
	end

	self._widgets_by_name.loading_overlay.content.visible = is_active
end

CharacterAppearanceView._handle_input = function (self, input_service)
	if input_service:get("navigate_up_continuous") then
		self:_grid_navigation("up")
	elseif input_service:get("navigate_down_continuous") then
		self:_grid_navigation("down")
	elseif input_service:get("navigate_left_continuous") then
		self:_grid_navigation("left")
	elseif input_service:get("navigate_right_continuous") then
		self:_grid_navigation("right")
	elseif not self._using_cursor_navigation then
		local used_input = false
		local continue_widget = self._widgets_by_name.continue_button

		if continue_widget then
			local action_input = continue_widget.content.gamepad_action

			if input_service:get(action_input) and not continue_widget.content.hotspot.disabled then
				continue_widget.content.hotspot:pressed_callback()

				used_input = true
			end
		end

		local support_widgets = self._page_grids and self._page_grids[1] and self._page_grids[1].support_widgets_by_name

		if not used_input then
			local name_input_widget = support_widgets.name_input

			if name_input_widget and input_service:get("hotkey_menu_special_2") then
				self:_randomize_character_name(name_input_widget)
			end
		end

		if not used_input then
			local companion_name_input_widget = support_widgets.companion_name_input

			if companion_name_input_widget and input_service:get("hotkey_menu_special_2") then
				self:_randomize_companion_name(companion_name_input_widget)
			end
		end
	end
end

CharacterAppearanceView._grid_navigation = function (self, direction)
	local widgets_data = {}
	local current_grid_index = self._navigation.grid
	local current_widget_index = self._navigation.index
	local current_widget_data

	for i = 1, #self._page_grids do
		local grid = self._page_grids[i].grid
		local grid_widgets = self._page_grids[i].widgets
		local grid_position = self._page_grids[i].position

		if grid_widgets then
			for j = 1, #grid_widgets do
				local grid_widget = grid_widgets[j]
				local hotspot = grid_widget.content.hotspot
				local is_visible = current_grid_index == i and true or grid:is_widget_visible(grid_widget)
				local is_visible = true

				if hotspot and is_visible then
					local size = grid_widget.content.size
					local offset = grid_widget.offset
					local index = #widgets_data + 1
					local widget_data = {
						index = index,
						grid_index = i,
						widget_index = j,
						position = {
							grid_position[1] + offset[1] + size[1] * 0.5,
							grid_position[2] + offset[2] + size[2] * 0.5,
						},
						size = size,
					}

					if i == current_grid_index and j == current_widget_index then
						current_widget_data = widget_data
					end

					widgets_data[index] = widget_data
				end
			end
		end
	end

	current_widget_data = current_widget_data or widgets_data[1]

	local selected_widget_data
	local current_x_position = current_widget_data.position[1]
	local current_y_position = current_widget_data.position[2]
	local current_x_size = current_widget_data.size[1]
	local current_y_size = current_widget_data.size[2]

	if direction == "left" then
		table.sort(widgets_data, function (a, b)
			return a.position[1] > b.position[1]
		end)

		for i = 1, #widgets_data do
			local widget_data = widgets_data[i]

			if widget_data.index == current_widget_data.index then
				local closest_value, closest_x_distance, closest_y_distance

				for j = i + 1, #widgets_data do
					local next_widget_data = widgets_data[j]
					local next_x_position = next_widget_data.position[1]
					local next_y_position = next_widget_data.position[2]
					local next_x_size = current_widget_data.size[1]
					local x_distance = math.abs(current_x_position - next_x_position)
					local not_selected_vertically = x_distance > current_x_size * 0.5

					if not_selected_vertically and (not closest_x_distance or x_distance < closest_x_distance) then
						closest_x_distance = x_distance
					end

					if closest_x_distance == x_distance then
						local y_distance = math.abs(current_y_position - next_y_position)

						if not closest_y_distance or y_distance < closest_y_distance then
							closest_y_distance = y_distance
							selected_widget_data = next_widget_data
						end
					end
				end

				break
			end
		end
	elseif direction == "right" then
		table.sort(widgets_data, function (a, b)
			return a.position[1] < b.position[1]
		end)

		for i = 1, #widgets_data do
			local widget_data = widgets_data[i]

			if widget_data.index == current_widget_data.index then
				local closest_value, closest_x_distance, closest_y_distance

				for j = i + 1, #widgets_data do
					local next_widget_data = widgets_data[j]
					local next_x_position = next_widget_data.position[1]
					local next_y_position = next_widget_data.position[2]
					local next_x_size = current_widget_data.size[1]
					local x_distance = math.abs(current_x_position - next_x_position)
					local not_selected_vertically = x_distance > current_x_size * 0.5

					if not_selected_vertically and (not closest_x_distance or x_distance < closest_x_distance) then
						closest_x_distance = x_distance
					end

					if closest_x_distance == x_distance then
						local y_distance = math.abs(current_y_position - next_y_position)

						if not closest_y_distance or y_distance < closest_y_distance then
							closest_y_distance = y_distance
							selected_widget_data = next_widget_data
						end
					end
				end

				break
			end
		end
	elseif direction == "up" then
		table.sort(widgets_data, function (a, b)
			return a.position[2] > b.position[2]
		end)

		for i = 1, #widgets_data do
			local widget_data = widgets_data[i]

			if widget_data.index == current_widget_data.index then
				local closest_value, closest_x_distance, closest_y_distance

				for j = i + 1, #widgets_data do
					local next_widget_data = widgets_data[j]
					local next_x_position = next_widget_data.position[1]
					local next_y_position = next_widget_data.position[2]
					local next_x_size = current_widget_data.size[1]
					local next_y_size = current_widget_data.size[2]
					local current_grid_index = current_widget_data.grid_index
					local next_grid_index = next_widget_data.grid_index
					local x_distance = math.abs(current_x_position - next_x_position)
					local y_distance = current_y_position - (next_y_position + next_y_size * 0.5)
					local is_same_grid = current_grid_index == next_grid_index

					if y_distance > 0 and is_same_grid and (not closest_x_distance or x_distance <= closest_x_distance) then
						if not closest_x_distance or x_distance < closest_x_distance then
							closest_y_distance = nil
						end

						if not closest_y_distance or y_distance < closest_y_distance then
							closest_y_distance = y_distance
							closest_x_distance = x_distance
							selected_widget_data = next_widget_data
						end
					end
				end

				break
			end
		end
	elseif direction == "down" then
		table.sort(widgets_data, function (a, b)
			return a.position[2] < b.position[2]
		end)

		for i = 1, #widgets_data do
			local widget_data = widgets_data[i]

			if widget_data.index == current_widget_data.index then
				local closest_value, closest_x_distance, closest_y_distance

				for j = i + 1, #widgets_data do
					local next_widget_data = widgets_data[j]
					local next_x_position = next_widget_data.position[1]
					local next_y_position = next_widget_data.position[2]
					local next_x_size = current_widget_data.size[1]
					local next_y_size = current_widget_data.size[2]
					local current_grid_index = current_widget_data.grid_index
					local next_grid_index = next_widget_data.grid_index
					local x_distance = math.abs(current_x_position - next_x_position)
					local y_distance = next_y_position - next_y_size * 0.5 - current_y_position
					local is_same_grid = current_grid_index == next_grid_index

					if y_distance > 0 and is_same_grid and (not closest_x_distance or x_distance <= closest_x_distance) then
						if not closest_x_distance or x_distance < closest_x_distance then
							closest_y_distance = nil
						end

						if not closest_y_distance or y_distance < closest_y_distance then
							closest_y_distance = y_distance
							closest_x_distance = x_distance
							selected_widget_data = next_widget_data
						end
					end
				end

				break
			end
		end
	end

	if selected_widget_data then
		local grid_index = selected_widget_data.grid_index
		local widget_index = selected_widget_data.widget_index
		local is_moving_back_to_first_grid = (self._active_page_name == "appearance" or self._active_page_name == "companion_appearance") and grid_index == 1 and self._navigation.grid and self._navigation.grid > 1

		if is_moving_back_to_first_grid then
			widget_index = self._apperance_option_selected_index
		end

		local page_grid = self._page_grids[grid_index]
		local widget = page_grid.widgets[widget_index]

		if not widget.content.ignore_navigation then
			if widget.content.hotspot.pressed_callback and not widget.content.ignore_pressed_on_navigation then
				widget.content.hotspot.pressed_callback({
					from_navigation = true,
				})
			elseif widget.content.ignore_pressed_on_navigation then
				self:_update_navigation(grid_index, widget_index)
			end
		end
	end
end

CharacterAppearanceView._update_navigation = function (self, grid_index, widget_index, apply_focus)
	local changed_grid = grid_index ~= self._navigation.grid

	self._navigation.previous_grid = self._navigation.grid
	self._navigation.previous_index = self._navigation.index
	self._navigation.grid = grid_index
	self._navigation.index = widget_index

	if changed_grid then
		self:_revert_all_gamepad_focused_loadout()
	end

	if apply_focus then
		local page_grid = self._page_grids[grid_index]

		if page_grid and page_grid.focused_on_gamepad_navigation then
			local scrollbar_animation_progress = page_grid.grid:get_scrollbar_percentage_by_index(widget_index)

			page_grid.grid:focus_grid_index(widget_index, scrollbar_animation_progress, true)
		end
	end
end

CharacterAppearanceView._on_navigation_input_changed = function (self)
	CharacterAppearanceView.super._on_navigation_input_changed(self)
	self:_revert_all_gamepad_focused_loadout()

	if self._using_cursor_navigation then
		self:_remove_all_focus()
	else
		local grid_index = self._navigation.grid
		local widget_index = self._navigation.index

		if grid_index and widget_index and self._page_grids[grid_index] then
			self._page_grids[grid_index].grid:focus_grid_index(widget_index)
		end
	end
end

CharacterAppearanceView._revert_all_gamepad_focused_loadout = function (self)
	if self._gamepad_focused_loadout then
		for slot, _ in pairs(self._gamepad_focused_loadout) do
			remove_gamepad_focused_slots(self, slot, true)
		end
	end

	for i = 1, #self._page_grids do
		local page_grid = self._page_grids[i]
		local selected_widget_index = page_grid.grid and page_grid.grid:selected_grid_index()

		if selected_widget_index then
			self:_check_widget_choice_detail_visibility(i, selected_widget_index)
		end
	end
end

CharacterAppearanceView._remove_all_focus = function (self)
	for i = 1, #self._page_grids do
		local page_grid = self._page_grids[i]

		if page_grid.grid then
			page_grid.grid:focus_grid_index(nil)
		end
	end
end

CharacterAppearanceView.dialogue_system = function (self)
	if self._is_barber then
		return self._parent:dialogue_system()
	else
		return nil
	end
end

return CharacterAppearanceView
