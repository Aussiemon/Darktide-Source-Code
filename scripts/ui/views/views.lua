-- chunkname: @scripts/ui/views/views.lua

local Archetypes = require("scripts/settings/archetype/archetypes")
local MinigameSettings = require("scripts/settings/minigame/minigame_settings")
local TrainingGroundsSoundEvents = require("scripts/settings/training_grounds/training_grounds_sound_events")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local views = {
	system_view = {
		class = "SystemView",
		close_on_hotkey_pressed = false,
		disable_game_world = false,
		display_name = "loc_system_view_display_name",
		game_world_blur = 1.1,
		load_always = true,
		load_in_hub = true,
		package = "packages/ui/views/system_view/system_view",
		path = "scripts/ui/views/system_view/system_view",
		state_bound = true,
		enter_sound_events = {
			UISoundEvents.system_menu_enter,
		},
		exit_sound_events = {
			UISoundEvents.system_menu_exit,
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu,
		},
	},
	inbox_view = {
		class = "InboxView",
		disable_game_world = false,
		display_name = "loc_inbox_view_display_name",
		game_world_blur = 1.1,
		load_in_hub = true,
		package = "packages/ui/views/inbox_view/inbox_view",
		path = "scripts/ui/views/inbox_view/inbox_view",
		state_bound = true,
		enter_sound_events = {
			UISoundEvents.system_menu_enter,
		},
		exit_sound_events = {
			UISoundEvents.system_menu_exit,
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu,
		},
	},
	news_view = {
		class = "NewsView",
		display_name = "loc_news_view_display_name",
		package = "packages/ui/views/news_view/news_view",
		path = "scripts/ui/views/news_view/news_view",
		state_bound = true,
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu,
		},
	},
	player_character_options_view = {
		class = "PlayerCharacterOptionsView",
		close_on_hotkey_pressed = true,
		disable_game_world = false,
		display_name = "loc_player_character_options_view_display_name",
		game_world_blur = 1.1,
		load_in_hub = true,
		package = "packages/ui/views/player_character_options_view/player_character_options_view",
		path = "scripts/ui/views/player_character_options_view/player_character_options_view",
		state_bound = true,
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu,
		},
		enter_sound_events = {
			UISoundEvents.default_menu_enter,
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit,
		},
	},
	discard_items_view = {
		class = "DiscardItemsView",
		close_on_hotkey_pressed = true,
		disable_game_world = false,
		display_name = "loc_discard_items_view_display_name",
		game_world_blur = 1.1,
		load_in_hub = true,
		package = "packages/ui/views/discard_items_view/discard_items_view",
		path = "scripts/ui/views/discard_items_view/discard_items_view",
		state_bound = true,
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu,
		},
		enter_sound_events = {
			UISoundEvents.default_menu_enter,
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit,
		},
	},
	options_view = {
		class = "OptionsView",
		disable_game_world = false,
		display_name = "loc_options_view_display_name",
		game_world_blur = 1.1,
		load_always = true,
		load_in_hub = true,
		package = "packages/ui/views/options_view/options_view",
		path = "scripts/ui/views/options_view/options_view",
		state_bound = true,
		enter_sound_events = {
			UISoundEvents.default_menu_enter,
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit,
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu,
		},
	},
	character_appearance_view = {
		class = "CharacterAppearanceView",
		disable_game_world = true,
		display_name = "loc_character_appearance_view_display_name",
		game_world_blur = 1,
		load_in_hub = true,
		package = "packages/ui/views/character_appearance_view/character_appearance_view",
		path = "scripts/ui/views/character_appearance_view/character_appearance_view",
		state_bound = true,
		use_transition_ui = true,
		levels = {
			"content/levels/ui/character_create/character_create",
		},
		enter_sound_events = {
			UISoundEvents.character_appearence_enter,
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.appearance_menu,
		},
		testify_flags = {
			ui_views = false,
		},
	},
	inventory_background_view = {
		class = "InventoryBackgroundView",
		disable_game_world = true,
		display_name = "loc_inventory_background_view_display_name",
		load_in_hub = true,
		package = "packages/ui/views/inventory_background_view/inventory_background_view",
		path = "scripts/ui/views/inventory_background_view/inventory_background_view",
		state_bound = true,
		use_transition_ui = true,
		levels = {
			"content/levels/ui/inventory/inventory",
		},
		enter_sound_events = {
			UISoundEvents.default_menu_enter,
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit,
		},
		testify_flags = {
			ui_views = false,
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu,
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
		end,
	},
	inventory_view = {
		class = "InventoryView",
		disable_game_world = true,
		display_name = "loc_inventory_view_display_name",
		load_in_hub = true,
		package = "packages/ui/views/inventory_view/inventory_view",
		parent_transition_view = "inventory_background_view",
		path = "scripts/ui/views/inventory_view/inventory_view",
		state_bound = true,
		dummy_data = {
			debug = true,
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu,
		},
	},
	inventory_cosmetics_view = {
		class = "InventoryCosmeticsView",
		disable_game_world = true,
		display_name = "loc_inventory_cosmetics_view_display_name",
		load_in_hub = true,
		package = "packages/ui/views/inventory_cosmetics_view/inventory_cosmetics_view",
		path = "scripts/ui/views/inventory_cosmetics_view/inventory_cosmetics_view",
		state_bound = true,
		use_transition_ui = true,
		levels = {
			"content/levels/ui/cosmetics_preview/cosmetics_preview",
		},
		dummy_data = {
			debug = true,
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu,
		},
		enter_sound_events = {
			UISoundEvents.default_menu_enter,
		},
	},
	inventory_weapons_view = {
		class = "InventoryWeaponsView",
		disable_game_world = true,
		display_name = "loc_inventory_weapons_view_display_name",
		load_in_hub = true,
		package = "packages/ui/views/inventory_weapons_view/inventory_weapons_view",
		path = "scripts/ui/views/inventory_weapons_view/inventory_weapons_view",
		state_bound = true,
		use_transition_ui = true,
		levels = {
			"content/levels/ui/cosmetics_preview/cosmetics_preview",
		},
		dummy_data = {
			debug = true,
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu,
		},
		enter_sound_events = {
			UISoundEvents.default_menu_enter,
		},
	},
	inventory_weapon_details_view = {
		class = "InventoryWeaponDetailsView",
		disable_game_world = true,
		display_name = "loc_inventory_weapon_details_view_display_name",
		load_in_hub = true,
		package = "packages/ui/views/inventory_weapon_details_view/inventory_weapon_details_view",
		path = "scripts/ui/views/inventory_weapon_details_view/inventory_weapon_details_view",
		state_bound = true,
		use_transition_ui = false,
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu,
		},
		enter_sound_events = {
			UISoundEvents.default_menu_enter,
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit,
		},
	},
	cosmetics_inspect_view = {
		class = "CosmeticsInspectView",
		disable_game_world = true,
		load_in_hub = true,
		package = "packages/ui/views/cosmetics_inspect_view/cosmetics_inspect_view",
		path = "scripts/ui/views/cosmetics_inspect_view/cosmetics_inspect_view",
		state_bound = true,
		use_transition_ui = true,
		levels = {
			"content/levels/ui/cosmetics_preview/cosmetics_preview",
		},
		dummy_data = {
			debug = true,
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu,
		},
		enter_sound_events = {
			UISoundEvents.default_menu_enter,
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit,
		},
	},
	inventory_weapon_cosmetics_view = {
		class = "InventoryWeaponCosmeticsView",
		disable_game_world = true,
		display_name = "loc_inventory_weapon_cosmetics_view_display_name",
		load_in_hub = true,
		package = "packages/ui/views/inventory_weapon_cosmetics_view/inventory_weapon_cosmetics_view",
		path = "scripts/ui/views/inventory_weapon_cosmetics_view/inventory_weapon_cosmetics_view",
		state_bound = true,
		use_transition_ui = true,
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu,
		},
		enter_sound_events = {
			UISoundEvents.default_menu_enter,
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit,
		},
	},
	account_profile_view = {
		class = "AccountProfileView",
		disable_game_world = true,
		display_name = "loc_account_profile_view_display_name",
		game_world_blur = 1.1,
		load_always = true,
		load_in_hub = true,
		package = "packages/ui/views/account_profile_view/account_profile_view",
		path = "scripts/ui/views/account_profile_view/account_profile_view",
		state_bound = true,
		use_transition_ui = true,
		levels = {
			"content/levels/ui/inventory/inventory",
		},
		enter_sound_events = {
			UISoundEvents.default_menu_enter,
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit,
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu,
		},
	},
	class_selection_view = {
		class = "ClassSelectionView",
		disable_game_world = false,
		display_name = "loc_class_selection_view_display_name",
		game_world_blur = 1,
		package = "packages/ui/views/class_selection_view/class_selection_view",
		path = "scripts/ui/views/class_selection_view/class_selection_view",
		state_bound = true,
		use_transition_ui = true,
		levels = {
			"content/levels/ui/class_selection/class_selection_zealot/class_selection_zealot",
			"content/levels/ui/class_selection/class_selection_veteran/class_selection_veteran",
			"content/levels/ui/class_selection/class_selection_psyker/class_selection_psyker",
			"content/levels/ui/class_selection/class_selection_ogryn/class_selection_ogryn",
		},
		testify_flags = {
			ui_views = false,
		},
		exit_sound_events = {
			UISoundEvents.character_create_exit,
		},
	},
	debug_view = {
		class = "DebugView",
		disable_game_world = false,
		display_name = "loc_debug_view_display_name",
		game_world_blur = 1,
		package = "packages/ui/views/debug_view/debug_view",
		path = "scripts/ui/views/debug_view/debug_view",
		enter_sound_events = {
			UISoundEvents.default_menu_enter,
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit,
		},
	},
	splash_view = {
		class = "SplashView",
		display_name = "loc_splash_view_display_name",
		package = "packages/ui/views/splash_view/splash_view",
		path = "scripts/ui/views/splash_view/splash_view",
		state_bound = true,
		testify_flags = {
			ui_views = false,
		},
	},
	video_view = {
		class = "VideoView",
		display_name = "loc_video_view_display_name",
		load_in_hub = true,
		package = "packages/ui/views/video_view/video_view",
		path = "scripts/ui/views/video_view/video_view",
		state_bound = true,
		use_transition_ui = true,
		wwise_state_query = true,
		testify_flags = {
			ui_views = false,
		},
	},
	title_view = {
		class = "TitleView",
		display_name = "loc_title_view_display_name",
		package = "packages/ui/views/title_view/title_view",
		path = "scripts/ui/views/title_view/title_view",
		state_bound = true,
		use_transition_ui = true,
		enter_sound_events = {
			UISoundEvents.title_screen_enter,
		},
		exit_sound_events = {
			UISoundEvents.title_screen_exit,
		},
		wwise_states = {
			music_game_state = WwiseGameSyncSettings.state_groups.music_game_state.title,
		},
	},
	end_view = {
		class = "EndView",
		disable_game_world = true,
		display_name = "loc_end_view_display_name",
		load_always = true,
		load_in_hub = true,
		package = "packages/ui/views/end_view/end_view",
		path = "scripts/ui/views/end_view/end_view",
		state_bound = true,
		use_transition_ui = true,
		levels = {
			"content/levels/ui/end_of_round/ui_eor_background",
		},
		enter_sound_events = {
			UISoundEvents.end_screen_enter,
		},
		exit_sound_events = {
			UISoundEvents.end_screen_exit,
		},
	},
	end_player_view = {
		class = "EndPlayerView",
		disable_game_world = false,
		display_name = "loc_end_player_view_display_name",
		load_always = false,
		load_in_hub = true,
		package = "packages/ui/views/end_player_view/end_player_view",
		parent_transition_view = "end_view",
		path = "scripts/ui/views/end_player_view/end_player_view",
		state_bound = false,
	},
	loading_view = {
		class = "LoadingView",
		disable_game_world = true,
		display_name = "loc_loading_view_display_name",
		dynamic_package_folder = "packages/ui/views/loading_view/",
		load_always = true,
		load_in_hub = true,
		package = "packages/ui/views/loading_view/loading_view",
		path = "scripts/ui/views/loading_view/loading_view",
		use_transition_ui = true,
		backgrounds = {
			"loading_screen_background",
		},
	},
	mission_intro_view = {
		class = "MissionIntroView",
		disable_game_world = true,
		display_name = "loc_mission_intro_view_display_name",
		load_always = true,
		package = "packages/ui/views/mission_intro_view/mission_intro_view",
		path = "scripts/ui/views/mission_intro_view/mission_intro_view",
		use_transition_ui = true,
		levels = {
			"content/levels/ui/mission_intro/mission_intro",
		},
		enter_sound_events = {
			UISoundEvents.mission_briefing_start,
		},
		exit_sound_events = {
			UISoundEvents.mission_briefing_stop,
		},
		wwise_states = {
			music_game_state = WwiseGameSyncSettings.state_groups.music_game_state.mission_briefing,
		},
	},
	blank_view = {
		class = "BlankView",
		disable_game_world = false,
		display_name = "loc_blank_view_display_name",
		path = "scripts/ui/views/blank_view/blank_view",
		use_transition_ui = true,
		testify_flags = {
			ui_views = false,
		},
	},
	cutscene_view = {
		class = "CutsceneView",
		disable_game_world = false,
		display_name = "loc_cutscene_view_display_name",
		load_always = true,
		path = "scripts/ui/views/cutscene_view/cutscene_view",
		use_transition_ui = true,
		testify_flags = {
			ui_views = false,
		},
	},
	splash_video_view = {
		class = "SplashVideoView",
		close_on_hotkey_pressed = true,
		disable_game_world = true,
		display_name = "loc_splash_video_view_display_name",
		load_always = true,
		package = "packages/ui/views/splash_view/splash_view",
		path = "scripts/ui/views/splash_video_view/splash_video_view",
		use_transition_ui = true,
		dummy_data = {
			sound_name = "content/videos/fatshark_splash",
			video_name = "content/videos/fatshark_splash",
		},
		testify_flags = {
			ui_views = false,
		},
	},
	mission_board_view = {
		class = "MissionBoardView",
		disable_game_world = true,
		display_name = "loc_mission_board_view_display_name",
		load_in_hub = true,
		package = "packages/ui/views/mission_board_view/mission_board_view",
		path = "scripts/ui/views/mission_board_view/mission_board_view",
		state_bound = true,
		use_transition_ui = true,
		levels = {
			"content/levels/ui/mission_board/mission_board",
		},
		enter_sound_events = {
			UISoundEvents.mission_board_enter,
		},
		exit_sound_events = {
			UISoundEvents.mission_board_exit,
		},
		wwise_states = {
			music_game_state = WwiseGameSyncSettings.state_groups.music_game_state.mission_board,
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu,
		},
	},
	lobby_view = {
		class = "LobbyView",
		disable_game_world = true,
		display_name = "loc_lobby_view_display_name",
		load_in_hub = true,
		package = "packages/ui/views/lobby_view/lobby_view",
		path = "scripts/ui/views/lobby_view/lobby_view",
		use_transition_ui = true,
		levels = {
			"content/levels/ui/lobby/lobby",
		},
		testify_flags = {
			ui_views = false,
		},
		wwise_states = {
			music_game_state = WwiseGameSyncSettings.state_groups.music_game_state.loadout,
		},
	},
	main_menu_view = {
		class = "MainMenuView",
		disable_game_world = true,
		display_name = "loc_main_menu_view_display_name",
		package = "packages/ui/views/main_menu_view/main_menu_view",
		parent_transition_view = "main_menu_background_view",
		path = "scripts/ui/views/main_menu_view/main_menu_view",
		enter_sound_events = {
			UISoundEvents.main_menu_enter,
		},
		exit_sound_events = {
			UISoundEvents.main_menu_exit,
		},
		testify_flags = {
			ui_views = false,
		},
	},
	barber_vendor_background_view = {
		class = "ContractsBackgroundView",
		disable_game_world = true,
		display_name = "loc_barber_vendor_background_view_display_name",
		killswitch = "show_contracts",
		killswitch_unavailable_description = "loc_popup_unavailable_view_contract_description",
		killswitch_unavailable_header = "loc_popup_unavailable_view_contract_header",
		load_in_hub = true,
		package = "packages/ui/views/barber_vendor_background_view/barber_vendor_background_view",
		path = "scripts/ui/views/barber_vendor_background_view/barber_vendor_background_view",
		state_bound = true,
		use_transition_ui = true,
		levels = {
			"content/levels/ui/barber/barber",
			"content/levels/ui/barber_character_appearance/barber_character_appearance",
			"content/levels/ui/barber_character_mindwipe/barber_character_mindwipe",
		},
		enter_sound_events = {
			UISoundEvents.barber_chirurgeon_on_enter,
		},
		exit_sound_events = {
			UISoundEvents.barber_chirurgeon_on_exit,
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.vendor_menu,
		},
	},
	body_shop_view = {
		class = "BodyShopView",
		disable_game_world = true,
		display_name = "loc_body_shop_view_display_name",
		load_in_hub = true,
		package = "packages/ui/views/body_shop_view/body_shop_view",
		path = "scripts/ui/views/body_shop_view/body_shop_view",
		state_bound = true,
		use_transition_ui = true,
		levels = {
			"content/levels/ui/character_create/character_create",
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.vendor_menu,
		},
	},
	contracts_background_view = {
		class = "ContractsBackgroundView",
		disable_game_world = true,
		display_name = "loc_contracts_background_view_display_name",
		killswitch = "show_contracts",
		killswitch_unavailable_description = "loc_popup_unavailable_view_contract_description",
		killswitch_unavailable_header = "loc_popup_unavailable_view_contract_header",
		load_in_hub = true,
		package = "packages/ui/views/contracts_background_view/contracts_background_view",
		path = "scripts/ui/views/contracts_background_view/contracts_background_view",
		state_bound = true,
		use_transition_ui = true,
		levels = {
			"content/levels/ui/contracts_view/contracts_view",
		},
		enter_sound_events = {
			UISoundEvents.mark_vendor_on_enter,
		},
		exit_sound_events = {
			UISoundEvents.mark_vendor_on_exit,
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.vendor_menu,
		},
	},
	contracts_view = {
		class = "ContractsView",
		disable_game_world = true,
		display_name = "loc_contracts_view_display_name",
		load_in_hub = true,
		package = "packages/ui/views/contracts_view/contracts_view",
		path = "scripts/ui/views/contracts_view/contracts_view",
		state_bound = true,
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.vendor_menu,
		},
		testify_flags = {
			ui_views = false,
		},
		enter_sound_events = {
			UISoundEvents.default_menu_enter,
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit,
		},
	},
	marks_vendor_view = {
		class = "MarksVendorView",
		disable_game_world = true,
		display_name = "loc_marks_vendor_view_display_name",
		killswitch = "show_marks_store",
		killswitch_unavailable_description = "loc_popup_unavailable_view_marks_store_description",
		killswitch_unavailable_header = "loc_popup_unavailable_view_marks_store_header",
		load_in_hub = true,
		package = "packages/ui/views/marks_vendor_view/marks_vendor_view",
		path = "scripts/ui/views/marks_vendor_view/marks_vendor_view",
		state_bound = true,
		use_transition_ui = false,
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.vendor_menu,
		},
		testify_flags = {
			ui_views = false,
		},
		enter_sound_events = {
			UISoundEvents.default_menu_enter,
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit,
		},
	},
	marks_goods_vendor_view = {
		class = "MarksVendorView",
		disable_game_world = true,
		display_name = "loc_marks_vendor_view_display_name",
		killswitch = "show_marks_store",
		killswitch_unavailable_description = "loc_popup_unavailable_view_marks_store_description",
		killswitch_unavailable_header = "loc_popup_unavailable_view_marks_store_header",
		load_in_hub = true,
		package = "packages/ui/views/marks_goods_vendor_view/marks_goods_vendor_view",
		path = "scripts/ui/views/marks_goods_vendor_view/marks_goods_vendor_view",
		state_bound = true,
		use_transition_ui = false,
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.vendor_menu,
		},
		dummy_data = {
			debug = true,
		},
		enter_sound_events = {
			UISoundEvents.default_menu_enter,
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit,
		},
	},
	credits_vendor_view = {
		class = "CreditsVendorView",
		disable_game_world = true,
		display_name = "loc_credits_vendor_view_display_name",
		killswitch = "show_contracts",
		killswitch_unavailable_description = "loc_popup_unavailable_view_credits_store_description",
		killswitch_unavailable_header = "loc_popup_unavailable_view_credits_store_header",
		load_in_hub = true,
		package = "packages/ui/views/credits_vendor_view/credits_vendor_view",
		path = "scripts/ui/views/credits_vendor_view/credits_vendor_view",
		state_bound = true,
		use_transition_ui = false,
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.vendor_menu,
		},
		testify_flags = {
			ui_views = false,
		},
		enter_sound_events = {
			UISoundEvents.default_menu_enter,
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit,
		},
	},
	credits_vendor_background_view = {
		class = "ContractsBackgroundView",
		disable_game_world = true,
		display_name = "loc_credits_vendor_background_view_display_name",
		killswitch = "show_contracts",
		killswitch_unavailable_description = "loc_popup_unavailable_view_contract_description",
		killswitch_unavailable_header = "loc_popup_unavailable_view_contract_header",
		load_in_hub = true,
		package = "packages/ui/views/credits_vendor_background_view/credits_vendor_background_view",
		path = "scripts/ui/views/credits_vendor_background_view/credits_vendor_background_view",
		state_bound = true,
		use_transition_ui = true,
		levels = {
			"content/levels/ui/credits_vendor/credits_vendor",
		},
		enter_sound_events = {
			UISoundEvents.credits_vendor_on_enter,
		},
		exit_sound_events = {
			UISoundEvents.credits_vendor_on_exit,
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.vendor_menu,
		},
	},
	story_mission_background_view = {
		class = "StoryMissionBackgroundView",
		disable_game_world = true,
		display_name = "loc_story_mission_background_view_display_name",
		load_in_hub = true,
		package = "packages/ui/views/story_mission_background_view/story_mission_background_view",
		path = "scripts/ui/views/story_mission_background_view/story_mission_background_view",
		state_bound = true,
		use_transition_ui = true,
		levels = {
			"content/levels/ui/story_mission_background/story_mission_background",
		},
		enter_sound_events = {
			UISoundEvents.story_mission_enter,
		},
		exit_sound_events = {
			UISoundEvents.story_mission_exit,
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.story_mission_menu,
		},
	},
	main_menu_background_view = {
		class = "MainMenuBackgroundView",
		disable_game_world = true,
		display_name = "loc_main_menu_background_view_display_name",
		load_in_hub = true,
		package = "packages/ui/views/main_menu_background_view/main_menu_background_view",
		path = "scripts/ui/views/main_menu_background_view/main_menu_background_view",
		use_transition_ui = true,
		levels = {
			"content/levels/ui/main_menu/main_menu",
		},
	},
	mission_voting_view = {
		class = "MissionVotingView",
		disable_game_world = false,
		display_name = "loc_mission_voting_view",
		game_world_blur = 1,
		load_always = true,
		load_in_hub = true,
		package = "packages/ui/views/mission_voting_view/mission_voting_view",
		path = "scripts/ui/views/mission_voting_view/mission_voting_view",
		state_bound = true,
		enter_sound_events = {
			UISoundEvents.mission_vote_popup_enter,
		},
		testify_flags = {
			ui_views = false,
		},
	},
	social_menu_view = {
		class = "SocialMenuView",
		disable_game_world = true,
		display_name = "loc_social_menu_view_display_name",
		game_world_blur = 1.1,
		load_always = true,
		load_in_hub = true,
		package = "packages/ui/views/social_menu_view/social_menu_view",
		path = "scripts/ui/views/social_menu_view/social_menu_view",
		state_bound = true,
		use_transition_ui = true,
		levels = {
			"content/levels/ui/inventory/inventory",
		},
		enter_sound_events = {
			UISoundEvents.default_menu_enter,
		},
		exit_sound_events = {
			UISoundEvents.default_menu_exit,
		},
		testify_flags = {
			ui_views = false,
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu,
		},
	},
	social_menu_roster_view = {
		class = "SocialMenuRosterView",
		display_name = "loc_social_menu_roster_view_display_name",
		load_always = true,
		load_in_hub = true,
		package = "packages/ui/views/social_menu_roster_view/social_menu_roster_view",
		parent_transition_view = "social_menu_view",
		path = "scripts/ui/views/social_menu_roster_view/social_menu_roster_view",
		state_bound = true,
		testify_flags = {
			ui_views = false,
		},
	},
	scanner_display_view = {
		allow_hud = true,
		class = "ScannerDisplayView",
		display_name = "loc_scanner_display_name",
		package = "packages/ui/views/scanner_display_view/scanner_display_view",
		path = "scripts/ui/views/scanner_display_view/scanner_display_view",
		state_bound = true,
	},
	custom_settings_view = {
		class = "CustomSettingsView",
		display_name = "loc_custom_settings_display_name",
		package = "packages/ui/views/custom_settings_view/custom_settings_view",
		path = "scripts/ui/views/custom_settings_view/custom_settings_view",
		state_bound = true,
		testify_flags = {
			ui_views = false,
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.ingame_menu,
		},
	},
	training_grounds_view = {
		class = "TrainingGroundsView",
		disable_game_world = true,
		display_name = "loc_training_grounds_view_display_name",
		load_in_hub = true,
		package = "packages/ui/views/training_grounds_view/training_grounds_view",
		path = "scripts/ui/views/training_grounds_view/training_grounds_view",
		state_bound = true,
		use_transition_ui = true,
		levels = {
			"content/levels/ui/training_grounds/training_grounds",
		},
		enter_sound_events = {
			TrainingGroundsSoundEvents.hub_pod_interact_enter,
		},
		exit_sound_events = {
			TrainingGroundsSoundEvents.hub_pod_interact_exit,
		},
		wwise_states = {
			options = WwiseGameSyncSettings.state_groups.options.vendor_menu,
		},
	},
	training_grounds_options_view = {
		class = "TrainingGroundsOptionsView",
		disable_game_world = true,
		display_name = "loc_training_grounds_options_view_display_name",
		load_in_hub = true,
		package = "packages/ui/views/training_grounds_options_view/training_grounds_options_view",
		path = "scripts/ui/views/training_grounds_options_view/training_grounds_options_view",
		state_bound = true,
		levels = {
			"content/levels/ui/training_grounds/training_grounds",
		},
	},
	credits_view = {
		class = "CreditsView",
		disable_game_world = true,
		display_name = "loc_credits_view_display_name",
		load_in_hub = true,
		package = "packages/ui/views/credits_view/credits_view",
		path = "scripts/ui/views/credits_view/credits_view",
		state_bound = true,
		testify_flags = {
			ui_views = false,
		},
		wwise_states = {
			music_game_state = WwiseGameSyncSettings.state_groups.music_game_state.credits,
			options = WwiseGameSyncSettings.state_groups.options.credits,
		},
	},
	talent_builder_view = {
		class = "TalentBuilderView",
		disable_game_world = true,
		display_name = "loc_talent_builder_view_display_name",
		load_in_hub = true,
		package = "packages/ui/views/talent_builder_view/talent_builder_view",
		path = "scripts/ui/views/talent_builder_view/talent_builder_view",
		state_bound = true,
		testify_flags = {
			ui_views = false,
		},
		enter_sound_events = {
			UISoundEvents.talent_menu_enter,
		},
		exit_sound_events = {
			UISoundEvents.talent_menu_exit,
		},
	},
}

local function _declare_view(name, settings)
	views[name] = settings
end

_declare_view("store_view", require("scripts/ui/views/store_view/store_view_declaration_settings"))
_declare_view("store_item_detail_view", require("scripts/ui/views/store_item_detail_view/store_item_detail_view_declaration_settings"))
_declare_view("credits_goods_vendor_view", require("scripts/ui/views/credits_goods_vendor_view/credits_goods_vendor_view_declaration_settings"))
_declare_view("crafting_view", require("scripts/ui/views/crafting_view/crafting_view_declaration_settings"))
_declare_view("crafting_modify_view", require("scripts/ui/views/crafting_modify_view/crafting_modify_view_declaration_settings"))
_declare_view("crafting_upgrade_item_view", require("scripts/ui/views/crafting_upgrade_item_view/crafting_upgrade_item_view_declaration_settings"))
_declare_view("crafting_extract_trait_view", require("scripts/ui/views/crafting_extract_trait_view/crafting_extract_trait_view_declaration_settings"))
_declare_view("crafting_replace_trait_view", require("scripts/ui/views/crafting_replace_trait_view/crafting_replace_trait_view_declaration_settings"))
_declare_view("crafting_modify_options_view", require("scripts/ui/views/crafting_modify_options_view/crafting_modify_options_view_declaration_settings"))
_declare_view("crafting_replace_perk_view", require("scripts/ui/views/crafting_replace_perk_view/crafting_replace_perk_view_declaration_settings"))
_declare_view("crafting_mechanicus_modify_view", require("scripts/ui/views/crafting_mechanicus_modify_view/crafting_mechanicus_modify_view_declaration_settings"))
_declare_view("crafting_mechanicus_barter_items_view", require("scripts/ui/views/crafting_mechanicus_barter_items_view/crafting_mechanicus_barter_items_view_declaration_settings"))
_declare_view("crafting_mechanicus_upgrade_item_view", require("scripts/ui/views/crafting_mechanicus_upgrade_item_view/crafting_mechanicus_upgrade_item_view_declaration_settings"))
_declare_view("crafting_mechanicus_replace_trait_view", require("scripts/ui/views/crafting_mechanicus_replace_trait_view/crafting_mechanicus_replace_trait_view_declaration_settings"))
_declare_view("crafting_mechanicus_replace_perk_view", require("scripts/ui/views/crafting_mechanicus_replace_perk_view/crafting_mechanicus_replace_perk_view_declaration_settings"))
_declare_view("crafting_mechanicus_modify_options_view", require("scripts/ui/views/crafting_mechanicus_modify_options_view/crafting_mechanicus_modify_options_view_declaration_settings"))
_declare_view("crafting_mechanicus_upgrade_expertise_view", require("scripts/ui/views/crafting_mechanicus_upgrade_expertise_view/crafting_mechanicus_upgrade_expertise_view_declaration_settings"))
_declare_view("masteries_overview_view", require("scripts/ui/views/masteries_overview_view/masteries_overview_view_declaration_settings"))
_declare_view("mastery_view", require("scripts/ui/views/mastery_view/mastery_view_declaration_settings"))
_declare_view("inventory_weapon_marks_view", require("scripts/ui/views/inventory_weapon_marks_view/inventory_weapon_marks_view_declaration_settings"))
_declare_view("cosmetics_vendor_view", require("scripts/ui/views/cosmetics_vendor_view/cosmetics_vendor_view_declaration_settings"))
_declare_view("cosmetics_vendor_background_view", require("scripts/ui/views/cosmetics_vendor_background_view/cosmetics_vendor_background_view_declaration_settings"))
_declare_view("story_mission_lore_view", require("scripts/ui/views/story_mission_lore_view/story_mission_lore_view_declaration_settings"))
_declare_view("story_mission_play_view", require("scripts/ui/views/story_mission_play_view/story_mission_play_view_declaration_settings"))
_declare_view("group_finder_view", require("scripts/ui/views/group_finder_view/group_finder_view_declaration_settings"))
_declare_view("penance_overview_view", require("scripts/ui/views/penance_overview_view/penance_overview_view_declaration_settings"))

for view_name, settings in pairs(views) do
	settings.name = view_name
	settings.close_on_hotkey_pressed = settings.close_on_hotkey_pressed ~= false
	settings.close_on_hotkey_gamepad = settings.close_on_hotkey_gamepad == true
end

return settings("Views", views)
