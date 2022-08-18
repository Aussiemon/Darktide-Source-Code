local MinigameSettings = require("scripts/settings/minigame/minigame_settings")
local Archetypes = require("scripts/settings/archetype/archetypes")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
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
		state_bound = true,
		display_name = "loc_character_appearance_view_display_name",
		use_transition_ui = true,
		path = "scripts/ui/views/character_appearance_view/character_appearance_view",
		package = "packages/ui/views/character_appearance_view/character_appearance_view",
		class = "CharacterAppearanceView",
		disable_game_world = false,
		game_world_blur = 1,
		levels = {
			"content/levels/ui/character_create/character_create"
		},
		enter_sound_events = {
			UISoundEvents.character_appearence_enter
		},
		testify_flags = {
			ui_views = false
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
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
		}
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
		}
	},
	inventory_weapon_details_view = {
		display_name = "loc_inventory_weapon_details_view_display_name",
		state_bound = true,
		use_transition_ui = true,
		path = "scripts/ui/views/inventory_weapon_details_view/inventory_weapon_details_view",
		package = "packages/ui/views/inventory_weapon_details_view/inventory_weapon_details_view",
		class = "InventoryWeaponDetailsView",
		disable_game_world = true,
		load_in_hub = true,
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
		}
	},
	inventory_weapon_cosmetics_view = {
		display_name = "loc_inventory_weapon_cosmetics_view_display_name",
		state_bound = true,
		use_transition_ui = true,
		path = "scripts/ui/views/inventory_weapon_cosmetics_view/inventory_weapon_cosmetics_view",
		package = "packages/ui/views/inventory_weapon_cosmetics_view/inventory_weapon_cosmetics_view",
		class = "InventoryWeaponCosmeticsView",
		disable_game_world = true,
		load_in_hub = true,
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
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
		exit_sound_events = {
			UISoundEvents.character_create_exit
		},
		testify_flags = {
			ui_views = false
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
		path = "scripts/ui/views/splash_view/splash_view"
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
		state_bound = false,
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
		package = "packages/ui/views/blank_view/blank_view",
		display_name = "loc_blank_view_display_name",
		class = "BlankView",
		disable_game_world = false,
		use_transition_ui = true,
		path = "scripts/ui/views/blank_view/blank_view"
	},
	cutscene_view = {
		package = "packages/ui/views/cutscene_view/cutscene_view",
		load_always = true,
		class = "CutsceneView",
		disable_game_world = false,
		display_name = "loc_cutscene_view_display_name",
		use_transition_ui = true,
		path = "scripts/ui/views/cutscene_view/cutscene_view",
		testify_flags = {
			ui_views = false
		}
	},
	splash_video_view = {
		package = "packages/ui/views/splash_video_view/splash_video_view",
		load_always = true,
		class = "SplashVideoView",
		disable_game_world = false,
		display_name = "loc_splash_video_view_display_name",
		path = "scripts/ui/views/splash_video_view/splash_video_view",
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
		path = "scripts/ui/views/mission_board_view_v2/mission_board_view",
		package = "packages/ui/views/mission_board_view/mission_board_view_v2",
		class = "MissionBoardView",
		disable_game_world = true,
		load_in_hub = true,
		levels = {
			"content/levels/ui/mission_board_v2/mission_board_v2"
		},
		wwise_states = {
			music_game_state = WwiseGameSyncSettings.state_groups.music_game_state.mission_board
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
	body_shop_view = {
		display_name = "loc_body_shop_view_display_name",
		state_bound = true,
		use_transition_ui = true,
		path = "scripts/ui/views/body_shop_view/body_shop_view",
		package = "packages/ui/views/body_shop_view/body_shop_view",
		class = "BodyShopView",
		disable_game_world = true,
		levels = {
			"content/levels/ui/crafting_view/crafting_view"
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
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
			UISoundEvents.default_menu_enter
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
		}
	},
	contracts_view = {
		package = "packages/ui/views/contracts_view/contracts_view",
		display_name = "loc_contracts_view_display_name",
		class = "ContractsView",
		disable_game_world = true,
		state_bound = true,
		load_in_hub = true,
		path = "scripts/ui/views/contracts_view/contracts_view",
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
		}
	},
	marks_vendor_view = {
		use_transition_ui = false,
		display_name = "loc_marks_vendor_view_display_name",
		state_bound = true,
		killswitch = "show_marks_store",
		killswitch_unavailable_header = "loc_popup_unavailable_view_marks_store_header",
		killswitch_unavailable_description = "loc_popup_unavailable_view_marks_store_description",
		path = "scripts/ui/views/marks_vendor_view/marks_vendor_view",
		package = "packages/ui/views/marks_vendor_view/marks_vendor_view",
		class = "MarksVendorView",
		disable_game_world = true,
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
		}
	},
	credits_vendor_view = {
		use_transition_ui = false,
		display_name = "loc_credits_vendor_view_display_name",
		state_bound = true,
		killswitch = "show_contracts",
		killswitch_unavailable_header = "loc_popup_unavailable_view_credits_store_header",
		killswitch_unavailable_description = "loc_popup_unavailable_view_credits_store_description",
		path = "scripts/ui/views/credits_vendor_view/credits_vendor_view",
		package = "packages/ui/views/credits_vendor_view/credits_vendor_view",
		class = "CreditsVendorView",
		disable_game_world = true,
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
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
			UISoundEvents.default_menu_enter
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
		}
	},
	premium_vendor_view = {
		display_name = "loc_premium_vendor_view_display_name",
		killswitch = "show_premium_store",
		state_bound = true,
		use_transition_ui = true,
		killswitch_unavailable_header = "loc_popup_unavailable_view_premium_store_header",
		killswitch_unavailable_description = "loc_popup_unavailable_view_premium_store_description",
		path = "scripts/ui/views/premium_vendor_view/premium_vendor_view",
		package = "packages/ui/views/vendor_view/vendor_view",
		class = "PremiumVendorView",
		disable_game_world = true,
		levels = {
			"content/levels/ui/vendor_view/vendor_view"
		},
		testify_flags = {
			ui_views = false
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
		}
	},
	training_ground_view = {
		package = "packages/ui/views/training_ground_view/training_ground_view",
		display_name = "loc_training_ground_view_display_name",
		class = "TrainingGroundView",
		disable_game_world = true,
		use_transition_ui = true,
		state_bound = true,
		path = "scripts/ui/views/training_ground_view/training_ground_view",
		levels = {
			"content/levels/ui/training_ground_view/training_ground_view"
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
		state_bound = true,
		use_transition_ui = true,
		path = "scripts/ui/views/social_menu_view/social_menu_view",
		package = "packages/ui/views/social_menu_view/social_menu_view",
		load_always = true,
		class = "SocialMenuView",
		disable_game_world = false,
		load_in_hub = true,
		game_world_blur = 1.1,
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
		parent_transition_view = "social_menu_view",
		state_bound = true,
		path = "scripts/ui/views/social_menu_roster_view/social_menu_roster_view",
		testify_flags = {
			ui_views = false
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu
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
	}
}

local function _declare_view(name, settings)
	assert(not views[name], "Trying to declare view settings with a name that is already taken")

	views[name] = settings
end

for view_name, settings in pairs(views) do
	settings.name = view_name

	if settings.close_on_hotkey_pressed == nil then
		settings.close_on_hotkey_pressed = true
	end
end

return views
