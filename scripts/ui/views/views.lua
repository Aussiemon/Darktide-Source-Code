local MinigameSettings = require("scripts/settings/minigame/minigame_settings")
local Archetypes = require("scripts/settings/archetype/archetypes")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local TrainingGroundsSoundEvents = require("scripts/settings/training_grounds/training_grounds_sound_events")
local views = {
	system_view = {
		game_world_blur = 1.1,
		display_name = "loc_system_view_display_name",
		state_bound = true,
		path = "scripts/ui/views/system_view/system_view",
		package = "packages/ui/views/system_view/system_view",
		load_always = true,
		class = "SystemView",
		disable_game_world = false,
		load_in_hub = true,
		close_on_hotkey_pressed = false,
		enter_sound_events = {
			UISoundEvents.system_menu_enter
		},
		exit_sound_events = {
			UISoundEvents.system_menu_exit
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
		}
	},
	inbox_view = {
		state_bound = true,
		display_name = "loc_inbox_view_display_name",
		path = "scripts/ui/views/inbox_view/inbox_view",
		package = "packages/ui/views/inbox_view/inbox_view",
		class = "InboxView",
		disable_game_world = false,
		load_in_hub = true,
		game_world_blur = 1.1,
		enter_sound_events = {
			UISoundEvents.system_menu_enter
		},
		exit_sound_events = {
			UISoundEvents.system_menu_exit
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
		}
	},
	news_view = {
		package = "packages/ui/views/news_view/news_view",
		display_name = "loc_news_view_display_name",
		class = "NewsView",
		state_bound = true,
		game_world_blur = 1.1,
		path = "scripts/ui/views/news_view/news_view",
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
		}
	},
	options_view = {
		state_bound = true,
		display_name = "loc_options_view_display_name",
		path = "scripts/ui/views/options_view/options_view",
		package = "packages/ui/views/options_view/options_view",
		load_always = true,
		class = "OptionsView",
		disable_game_world = false,
		load_in_hub = true,
		game_world_blur = 1.1,
		enter_sound_events = {
			UISoundEvents.default_menu_enter
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
		}
	},
	character_appearance_view = {
		display_name = "loc_character_appearance_view_display_name",
		state_bound = true,
		use_transition_ui = true,
		path = "scripts/ui/views/character_appearance_view/character_appearance_view",
		package = "packages/ui/views/character_appearance_view/character_appearance_view",
		class = "CharacterAppearanceView",
		disable_game_world = true,
		game_world_blur = 1,
		levels = {
			"content/levels/ui/character_create/character_create"
		},
		enter_sound_events = {
			UISoundEvents.character_appearence_enter
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.appearance_menu
		},
		testify_flags = {
			ui_views = false
		}
	},
	inventory_background_view = {
		display_name = "loc_inventory_background_view_display_name",
		use_transition_ui = true,
		state_bound = true,
		path = "scripts/ui/views/inventory_background_view/inventory_background_view",
		package = "packages/ui/views/inventory_background_view/inventory_background_view",
		class = "InventoryBackgroundView",
		disable_game_world = true,
		load_in_hub = true,
		levels = {
			"content/levels/ui/inventory/inventory"
		},
		enter_sound_events = {
			UISoundEvents.default_menu_enter
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit
		},
		testify_flags = {
			ui_views = false
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
		},
		validation_function = function ()
			local game_mode_manager = Managers.state.game_mode

			if not game_mode_manager then
				return true
			end

			local game_mode_name = game_mode_manager:game_mode_name()
			local is_prologue_hub = game_mode_name == "prologue_hub"
			local played_basic_training = Managers.narrative:is_chapter_complete("onboarding", "play_training")
			local can_open_view = not is_prologue_hub or played_basic_training

			return can_open_view
		end
	},
	inventory_view = {
		parent_transition_view = "inventory_background_view",
		display_name = "loc_inventory_view_display_name",
		state_bound = true,
		path = "scripts/ui/views/inventory_view/inventory_view",
		package = "packages/ui/views/inventory_view/inventory_view",
		class = "InventoryView",
		disable_game_world = true,
		load_in_hub = true,
		dummy_data = {
			debug = true
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
		}
	},
	inventory_cosmetics_view = {
		display_name = "loc_inventory_cosmetics_view_display_name",
		state_bound = true,
		use_transition_ui = true,
		path = "scripts/ui/views/inventory_cosmetics_view/inventory_cosmetics_view",
		package = "packages/ui/views/inventory_cosmetics_view/inventory_cosmetics_view",
		class = "InventoryCosmeticsView",
		disable_game_world = true,
		load_in_hub = true,
		levels = {
			"content/levels/ui/cosmetics_preview/cosmetics_preview"
		},
		dummy_data = {
			debug = true
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
		},
		enter_sound_events = {
			UISoundEvents.default_menu_enter
		}
	},
	inventory_weapons_view = {
		display_name = "loc_inventory_weapons_view_display_name",
		state_bound = true,
		use_transition_ui = true,
		path = "scripts/ui/views/inventory_weapons_view/inventory_weapons_view",
		package = "packages/ui/views/inventory_weapons_view/inventory_weapons_view",
		class = "InventoryWeaponsView",
		disable_game_world = true,
		load_in_hub = true,
		levels = {
			"content/levels/ui/cosmetics_preview/cosmetics_preview"
		},
		dummy_data = {
			debug = true
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
		},
		enter_sound_events = {
			UISoundEvents.default_menu_enter
		}
	},
	inventory_weapon_details_view = {
		state_bound = true,
		display_name = "loc_inventory_weapon_details_view_display_name",
		use_transition_ui = false,
		path = "scripts/ui/views/inventory_weapon_details_view/inventory_weapon_details_view",
		package = "packages/ui/views/inventory_weapon_details_view/inventory_weapon_details_view",
		class = "InventoryWeaponDetailsView",
		disable_game_world = true,
		load_in_hub = true,
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
		},
		enter_sound_events = {
			UISoundEvents.default_menu_enter
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit
		}
	},
	inventory_weapon_cosmetics_view = {
		state_bound = true,
		display_name = "loc_inventory_weapon_cosmetics_view_display_name",
		use_transition_ui = true,
		path = "scripts/ui/views/inventory_weapon_cosmetics_view/inventory_weapon_cosmetics_view",
		package = "packages/ui/views/inventory_weapon_cosmetics_view/inventory_weapon_cosmetics_view",
		class = "InventoryWeaponCosmeticsView",
		disable_game_world = true,
		load_in_hub = true,
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
		},
		enter_sound_events = {
			UISoundEvents.default_menu_enter
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit
		}
	},
	talents_career_choice_view = {
		state_bound = true,
		display_name = "loc_talents_view_display_name",
		path = "scripts/ui/views/talents_career_choice_view/talents_career_choice_view",
		package = "packages/ui/views/talents_career_choice_view/talents_career_choice_view",
		class = "TalentsCareerChoiceView",
		disable_game_world = true,
		load_in_hub = true,
		game_world_blur = 4.1,
		testify_flags = {
			ui_views = false
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
		}
	},
	talents_view = {
		display_name = "loc_talents_view_display_name",
		state_bound = true,
		use_transition_ui = false,
		path = "scripts/ui/views/talents_view/talents_view",
		package = "packages/ui/views/talents_view/talents_view",
		class = "TalentsView",
		load_in_hub = true,
		game_world_blur = 4.1,
		dummy_data = {
			player_level = 20,
			player_specialization = "shock_trooper",
			debug = true,
			player_archetype = Archetypes.veteran
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
		}
	},
	account_profile_view = {
		display_name = "loc_account_profile_view_display_name",
		state_bound = true,
		use_transition_ui = true,
		path = "scripts/ui/views/account_profile_view/account_profile_view",
		package = "packages/ui/views/account_profile_view/account_profile_view",
		load_always = true,
		class = "AccountProfileView",
		disable_game_world = true,
		load_in_hub = true,
		game_world_blur = 1.1,
		levels = {
			"content/levels/ui/inventory/inventory"
		},
		enter_sound_events = {
			UISoundEvents.default_menu_enter
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
		}
	},
	achievements_view = {
		close_on_hotkey_pressed = false,
		display_name = "loc_achievements_view_display_name",
		use_transition_ui = true,
		path = "scripts/ui/views/achievements_view/achievements_view",
		package = "packages/ui/views/achievements_view/achievements_view",
		class = "AchievementsView",
		disable_game_world = true,
		load_in_hub = true,
		game_world_blur = 1.1,
		testify_flags = {
			ui_views = false
		}
	},
	class_selection_view = {
		state_bound = true,
		display_name = "loc_class_selection_view_display_name",
		use_transition_ui = true,
		path = "scripts/ui/views/class_selection_view/class_selection_view",
		package = "packages/ui/views/class_selection_view/class_selection_view",
		class = "ClassSelectionView",
		disable_game_world = false,
		game_world_blur = 1,
		levels = {
			"content/levels/ui/class_selection/class_selection_zealot/class_selection_zealot",
			"content/levels/ui/class_selection/class_selection_veteran/class_selection_veteran",
			"content/levels/ui/class_selection/class_selection_psyker/class_selection_psyker",
			"content/levels/ui/class_selection/class_selection_ogryn/class_selection_ogryn"
		},
		testify_flags = {
			ui_views = false
		},
		exit_sound_events = {
			UISoundEvents.character_create_exit
		}
	},
	debug_view = {
		package = "packages/ui/views/debug_view/debug_view",
		display_name = "loc_debug_view_display_name",
		class = "DebugView",
		disable_game_world = false,
		game_world_blur = 1,
		path = "scripts/ui/views/debug_view/debug_view",
		enter_sound_events = {
			UISoundEvents.default_menu_enter
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit
		}
	},
	splash_view = {
		package = "packages/ui/views/splash_view/splash_view",
		display_name = "loc_splash_view_display_name",
		class = "SplashView",
		state_bound = true,
		path = "scripts/ui/views/splash_view/splash_view",
		testify_flags = {
			ui_views = false
		}
	},
	video_view = {
		package = "packages/ui/views/video_view/video_view",
		display_name = "loc_video_view_display_name",
		class = "VideoView",
		use_transition_ui = true,
		load_in_hub = true,
		path = "scripts/ui/views/video_view/video_view",
		testify_flags = {
			ui_views = false
		}
	},
	title_view = {
		display_name = "loc_title_view_display_name",
		state_bound = true,
		use_transition_ui = true,
		path = "scripts/ui/views/title_view/title_view",
		package = "packages/ui/views/title_view/title_view",
		class = "TitleView",
		enter_sound_events = {
			UISoundEvents.title_screen_enter
		},
		exit_sound_events = {
			UISoundEvents.title_screen_exit
		},
		wwise_states = {
			music_game_state = WwiseGameSyncSettings.state_groups.music_game_state.title
		}
	},
	end_view = {
		load_in_hub = true,
		display_name = "loc_end_view_display_name",
		state_bound = true,
		use_transition_ui = true,
		path = "scripts/ui/views/end_view/end_view",
		package = "packages/ui/views/end_view/end_view",
		load_always = true,
		class = "EndView",
		disable_game_world = true,
		levels = {
			"content/levels/ui/end_of_round/ui_eor_background"
		},
		enter_sound_events = {
			UISoundEvents.end_screen_enter
		},
		exit_sound_events = {
			UISoundEvents.end_screen_exit
		}
	},
	end_player_view = {
		parent_transition_view = "end_view",
		display_name = "loc_end_player_view_display_name",
		state_bound = false,
		path = "scripts/ui/views/end_player_view/end_player_view",
		package = "packages/ui/views/end_player_view/end_player_view",
		load_always = false,
		class = "EndPlayerView",
		disable_game_world = false,
		load_in_hub = true
	},
	loading_view = {
		package = "packages/ui/views/loading_view/loading_view",
		load_always = true,
		class = "LoadingView",
		disable_game_world = true,
		use_transition_ui = true,
		load_in_hub = true,
		display_name = "loc_loading_view_display_name",
		path = "scripts/ui/views/loading_view/loading_view"
	},
	mission_intro_view = {
		display_name = "loc_mission_intro_view_display_name",
		use_transition_ui = true,
		path = "scripts/ui/views/mission_intro_view/mission_intro_view",
		package = "packages/ui/views/mission_intro_view/mission_intro_view",
		load_always = true,
		class = "MissionIntroView",
		disable_game_world = true,
		levels = {
			"content/levels/ui/mission_intro/mission_intro"
		},
		enter_sound_events = {
			UISoundEvents.mission_briefing_start
		},
		exit_sound_events = {
			UISoundEvents.mission_briefing_stop
		},
		wwise_states = {
			music_game_state = WwiseGameSyncSettings.state_groups.music_game_state.mission_briefing
		}
	},
	blank_view = {
		display_name = "loc_blank_view_display_name",
		class = "BlankView",
		disable_game_world = false,
		use_transition_ui = true,
		path = "scripts/ui/views/blank_view/blank_view",
		testify_flags = {
			ui_views = false
		}
	},
	cutscene_view = {
		display_name = "loc_cutscene_view_display_name",
		load_always = true,
		class = "CutsceneView",
		disable_game_world = false,
		use_transition_ui = true,
		path = "scripts/ui/views/cutscene_view/cutscene_view",
		testify_flags = {
			ui_views = false
		}
	},
	splash_video_view = {
		disable_game_world = true,
		display_name = "loc_splash_video_view_display_name",
		use_transition_ui = true,
		path = "scripts/ui/views/splash_video_view/splash_video_view",
		package = "packages/ui/views/splash_view/splash_view",
		load_always = true,
		class = "SplashVideoView",
		close_on_hotkey_pressed = true,
		dummy_data = {
			video_name = "content/videos/fatshark_splash",
			sound_name = "content/videos/fatshark_splash"
		},
		testify_flags = {
			ui_views = false
		}
	},
	mission_board_view = {
		state_bound = true,
		display_name = "loc_mission_board_view_display_name",
		use_transition_ui = true,
		path = "scripts/ui/views/mission_board_view/mission_board_view",
		package = "packages/ui/views/mission_board_view/mission_board_view",
		class = "MissionBoardView",
		disable_game_world = true,
		load_in_hub = true,
		levels = {
			"content/levels/ui/mission_board/mission_board"
		},
		enter_sound_events = {
			UISoundEvents.mission_board_enter
		},
		exit_sound_events = {
			UISoundEvents.mission_board_exit
		},
		wwise_states = {
			music_game_state = WwiseGameSyncSettings.state_groups.music_game_state.mission_board,
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
		},
		testify_flags = {
			ui_views = false
		}
	},
	lobby_view = {
		display_name = "loc_lobby_view_display_name",
		use_transition_ui = true,
		path = "scripts/ui/views/lobby_view/lobby_view",
		package = "packages/ui/views/lobby_view/lobby_view",
		class = "LobbyView",
		disable_game_world = true,
		load_in_hub = true,
		levels = {
			"content/levels/ui/lobby/lobby"
		},
		testify_flags = {
			ui_views = false
		},
		wwise_states = {
			music_game_state = WwiseGameSyncSettings.state_groups.music_game_state.loadout
		}
	},
	main_menu_view = {
		display_name = "loc_main_menu_view_display_name",
		parent_transition_view = "main_menu_background_view",
		path = "scripts/ui/views/main_menu_view/main_menu_view",
		package = "packages/ui/views/main_menu_view/main_menu_view",
		class = "MainMenuView",
		disable_game_world = true,
		enter_sound_events = {
			UISoundEvents.main_menu_enter
		},
		exit_sound_events = {
			UISoundEvents.main_menu_exit
		},
		testify_flags = {
			ui_views = false
		}
	},
	barber_vendor_background_view = {
		display_name = "loc_barber_vendor_background_view_display_name",
		state_bound = true,
		killswitch = "show_contracts",
		use_transition_ui = true,
		killswitch_unavailable_header = "loc_popup_unavailable_view_contract_header",
		killswitch_unavailable_description = "loc_popup_unavailable_view_contract_description",
		path = "scripts/ui/views/barber_vendor_background_view/barber_vendor_background_view",
		package = "packages/ui/views/barber_vendor_background_view/barber_vendor_background_view",
		load_in_hub = true,
		class = "ContractsBackgroundView",
		disable_game_world = true,
		levels = {
			"content/levels/ui/barber/barber",
			"content/levels/ui/barber_character_appearance/barber_character_appearance"
		},
		enter_sound_events = {
			UISoundEvents.barber_chirurgeon_on_enter
		},
		exit_sound_events = {
			UISoundEvents.barber_chirurgeon_on_exit
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.vendor_menu
		}
	},
	body_shop_view = {
		display_name = "loc_body_shop_view_display_name",
		state_bound = true,
		use_transition_ui = true,
		path = "scripts/ui/views/body_shop_view/body_shop_view",
		package = "packages/ui/views/body_shop_view/body_shop_view",
		class = "BodyShopView",
		disable_game_world = true,
		levels = {
			"content/levels/ui/character_create/character_create"
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.vendor_menu
		}
	},
	contracts_background_view = {
		display_name = "loc_contracts_background_view_display_name",
		state_bound = true,
		killswitch = "show_contracts",
		use_transition_ui = true,
		killswitch_unavailable_header = "loc_popup_unavailable_view_contract_header",
		killswitch_unavailable_description = "loc_popup_unavailable_view_contract_description",
		path = "scripts/ui/views/contracts_background_view/contracts_background_view",
		package = "packages/ui/views/contracts_background_view/contracts_background_view",
		load_in_hub = true,
		class = "ContractsBackgroundView",
		disable_game_world = true,
		levels = {
			"content/levels/ui/contracts_view/contracts_view"
		},
		enter_sound_events = {
			UISoundEvents.mark_vendor_on_enter
		},
		exit_sound_events = {
			UISoundEvents.mark_vendor_on_exit
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.vendor_menu
		}
	},
	contracts_view = {
		display_name = "loc_contracts_view_display_name",
		state_bound = true,
		disable_game_world = true,
		path = "scripts/ui/views/contracts_view/contracts_view",
		package = "packages/ui/views/contracts_view/contracts_view",
		class = "ContractsView",
		load_in_hub = true,
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.vendor_menu
		},
		testify_flags = {
			ui_views = false
		},
		enter_sound_events = {
			UISoundEvents.default_menu_enter
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit
		}
	},
	marks_vendor_view = {
		display_name = "loc_marks_vendor_view_display_name",
		state_bound = true,
		killswitch = "show_marks_store",
		killswitch_unavailable_header = "loc_popup_unavailable_view_marks_store_header",
		killswitch_unavailable_description = "loc_popup_unavailable_view_marks_store_description",
		path = "scripts/ui/views/marks_vendor_view/marks_vendor_view",
		package = "packages/ui/views/marks_vendor_view/marks_vendor_view",
		class = "MarksVendorView",
		disable_game_world = true,
		use_transition_ui = false,
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.vendor_menu
		},
		testify_flags = {
			ui_views = false
		},
		enter_sound_events = {
			UISoundEvents.default_menu_enter
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit
		}
	},
	marks_goods_vendor_view = {
		display_name = "loc_marks_vendor_view_display_name",
		state_bound = true,
		killswitch = "show_marks_store",
		killswitch_unavailable_header = "loc_popup_unavailable_view_marks_store_header",
		killswitch_unavailable_description = "loc_popup_unavailable_view_marks_store_description",
		path = "scripts/ui/views/marks_goods_vendor_view/marks_goods_vendor_view",
		package = "packages/ui/views/marks_goods_vendor_view/marks_goods_vendor_view",
		class = "MarksVendorView",
		disable_game_world = true,
		use_transition_ui = false,
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.vendor_menu
		},
		dummy_data = {
			debug = true
		},
		enter_sound_events = {
			UISoundEvents.default_menu_enter
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit
		}
	},
	credits_vendor_view = {
		display_name = "loc_credits_vendor_view_display_name",
		state_bound = true,
		killswitch = "show_contracts",
		killswitch_unavailable_header = "loc_popup_unavailable_view_credits_store_header",
		killswitch_unavailable_description = "loc_popup_unavailable_view_credits_store_description",
		path = "scripts/ui/views/credits_vendor_view/credits_vendor_view",
		package = "packages/ui/views/credits_vendor_view/credits_vendor_view",
		class = "CreditsVendorView",
		disable_game_world = true,
		use_transition_ui = false,
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.vendor_menu
		},
		testify_flags = {
			ui_views = false
		},
		enter_sound_events = {
			UISoundEvents.default_menu_enter
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit
		}
	},
	credits_vendor_background_view = {
		display_name = "loc_credits_vendor_background_view_display_name",
		state_bound = true,
		killswitch = "show_contracts",
		use_transition_ui = true,
		killswitch_unavailable_header = "loc_popup_unavailable_view_contract_header",
		killswitch_unavailable_description = "loc_popup_unavailable_view_contract_description",
		path = "scripts/ui/views/credits_vendor_background_view/credits_vendor_background_view",
		package = "packages/ui/views/credits_vendor_background_view/credits_vendor_background_view",
		load_in_hub = true,
		class = "ContractsBackgroundView",
		disable_game_world = true,
		levels = {
			"content/levels/ui/credits_vendor/credits_vendor"
		},
		enter_sound_events = {
			UISoundEvents.credits_vendor_on_enter
		},
		exit_sound_events = {
			UISoundEvents.credits_vendor_on_exit
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.vendor_menu
		}
	},
	main_menu_background_view = {
		package = "packages/ui/views/main_menu_background_view/main_menu_background_view",
		display_name = "loc_main_menu_background_view_display_name",
		class = "MainMenuBackgroundView",
		disable_game_world = true,
		use_transition_ui = true,
		path = "scripts/ui/views/main_menu_background_view/main_menu_background_view",
		levels = {
			"content/levels/ui/main_menu/main_menu"
		}
	},
	mission_voting_view = {
		state_bound = true,
		display_name = "loc_mission_voting_view",
		path = "scripts/ui/views/mission_voting_view/mission_voting_view",
		package = "packages/ui/views/mission_voting_view/mission_voting_view",
		load_always = true,
		class = "MissionVotingView",
		disable_game_world = false,
		load_in_hub = true,
		game_world_blur = 1,
		enter_sound_events = {
			UISoundEvents.mission_vote_popup_enter
		},
		testify_flags = {
			ui_views = false
		}
	},
	social_menu_view = {
		display_name = "loc_social_menu_view_display_name",
		use_transition_ui = true,
		state_bound = true,
		path = "scripts/ui/views/social_menu_view/social_menu_view",
		package = "packages/ui/views/social_menu_view/social_menu_view",
		load_always = true,
		class = "SocialMenuView",
		disable_game_world = true,
		load_in_hub = true,
		game_world_blur = 1.1,
		levels = {
			"content/levels/ui/inventory/inventory"
		},
		enter_sound_events = {
			UISoundEvents.default_menu_enter
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit
		},
		testify_flags = {
			ui_views = false
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
		}
	},
	social_menu_roster_view = {
		package = "packages/ui/views/social_menu_roster_view/social_menu_roster_view",
		display_name = "loc_social_menu_roster_view_display_name",
		class = "SocialMenuRosterView",
		state_bound = true,
		parent_transition_view = "social_menu_view",
		path = "scripts/ui/views/social_menu_roster_view/social_menu_roster_view",
		testify_flags = {
			ui_views = false
		}
	},
	scanner_display_view = {
		package = "packages/ui/views/scanner_display_view/scanner_display_view",
		display_name = "loc_scanner_display_name",
		class = "ScannerDisplayView",
		state_bound = true,
		allow_hud = true,
		path = "scripts/ui/views/scanner_display_view/scanner_display_view"
	},
	custom_settings_view = {
		package = "packages/ui/views/custom_settings_view/custom_settings_view",
		display_name = "loc_custom_settings_display_name",
		class = "CustomSettingsView",
		state_bound = true,
		path = "scripts/ui/views/custom_settings_view/custom_settings_view",
		testify_flags = {
			ui_views = false
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
		}
	},
	training_grounds_view = {
		display_name = "loc_training_grounds_view_display_name",
		state_bound = true,
		load_in_hub = true,
		use_transition_ui = true,
		path = "scripts/ui/views/training_grounds_view/training_grounds_view",
		package = "packages/ui/views/training_grounds_view/training_grounds_view",
		class = "TrainingGroundsView",
		disable_game_world = true,
		levels = {
			"content/levels/ui/training_grounds/training_grounds"
		},
		enter_sound_events = {
			TrainingGroundsSoundEvents.hub_pod_interact_enter
		},
		exit_sound_events = {
			TrainingGroundsSoundEvents.hub_pod_interact_exit
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.vendor_menu
		}
	},
	training_grounds_options_view = {
		package = "packages/ui/views/training_grounds_options_view/training_grounds_options_view",
		display_name = "loc_training_grounds_options_view_display_name",
		class = "TrainingGroundsOptionsView",
		disable_game_world = true,
		state_bound = true,
		path = "scripts/ui/views/training_grounds_options_view/training_grounds_options_view",
		levels = {
			"content/levels/ui/training_grounds/training_grounds"
		}
	},
	credits_view = {
		package = "packages/ui/views/credits_view/credits_view",
		display_name = "loc_credits_view_display_name",
		class = "CreditsView",
		disable_game_world = true,
		state_bound = true,
		path = "scripts/ui/views/credits_view/credits_view",
		testify_flags = {
			ui_views = false
		}
	}
}

local function _declare_view(name, settings)
	views[name] = settings
end

_declare_view("store_view", require("scripts/ui/views/store_view/store_view_declaration_settings"))
_declare_view("store_item_detail_view", require("scripts/ui/views/store_item_detail_view/store_item_detail_view_declaration_settings"))
_declare_view("account_profile_win_tracks_view", require("scripts/ui/views/account_profile_win_tracks_view/account_profile_win_tracks_declaration_settings"))
_declare_view("crafting_view", require("scripts/ui/views/crafting_view/crafting_view_declaration_settings"))
_declare_view("crafting_modify_view", require("scripts/ui/views/crafting_modify_view/crafting_modify_view_declaration_settings"))
_declare_view("crafting_upgrade_item_view", require("scripts/ui/views/crafting_upgrade_item_view/crafting_upgrade_item_view_declaration_settings"))
_declare_view("crafting_reroll_perk_view", require("scripts/ui/views/crafting_reroll_perk_view/crafting_reroll_perk_view_declaration_settings"))
_declare_view("crafting_extract_trait_view", require("scripts/ui/views/crafting_extract_trait_view/crafting_extract_trait_view_declaration_settings"))
_declare_view("crafting_replace_trait_view", require("scripts/ui/views/crafting_replace_trait_view/crafting_replace_trait_view_declaration_settings"))
_declare_view("crafting_modify_options_view", require("scripts/ui/views/crafting_modify_options_view/crafting_modify_options_view_declaration_settings"))
_declare_view("crafting_fuse_view", require("scripts/ui/views/crafting_fuse_view/crafting_fuse_view_declaration_settings"))

for view_name, settings in pairs(views) do
	settings.name = view_name

	if settings.close_on_hotkey_pressed == nil then
		settings.close_on_hotkey_pressed = true
	end
end

return settings("Views", views)
