local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local view_element_wintrack_item_reward_overlay = {
	world_name = "ui_title_screen_world",
	viewport_type = "default_with_alpha",
	ignore_level_background = true,
	timer_name = "ui",
	level_up_delay = 0.1,
	viewport_name = "ui_title_screen_viewport",
	viewport_layer = 1,
	world_layer = 800,
	level_name = "content/levels/ui/title_screen/title_screen",
	weapon_spawn_depth = 1.2,
	shading_environment = "content/shading_environments/ui/ui_item_preview",
	effect_textures_by_rarity = {
		{
			glow = "content/ui/materials/effects/item_aquisition/glow_rarity_01",
			particle = "content/ui/materials/effects/item_aquisition/particles_rarity_01"
		},
		{
			glow = "content/ui/materials/effects/item_aquisition/glow_rarity_02",
			particle = "content/ui/materials/effects/item_aquisition/particles_rarity_02"
		},
		{
			glow = "content/ui/materials/effects/item_aquisition/glow_rarity_03",
			particle = "content/ui/materials/effects/item_aquisition/particles_rarity_03"
		},
		{
			glow = "content/ui/materials/effects/item_aquisition/glow_rarity_04",
			particle = "content/ui/materials/effects/item_aquisition/particles_rarity_04"
		},
		{
			glow = "content/ui/materials/effects/item_aquisition/glow_rarity_05",
			particle = "content/ui/materials/effects/item_aquisition/particles_rarity_05"
		},
		{
			glow = "content/ui/materials/effects/item_aquisition/glow_rarity_06",
			particle = "content/ui/materials/effects/item_aquisition/particles_rarity_06"
		}
	},
	sound_events_by_item_rarity = {
		UISoundEvents.wintrack_item_reward_overlay_in_rarity_1,
		UISoundEvents.wintrack_item_reward_overlay_in_rarity_2,
		UISoundEvents.wintrack_item_reward_overlay_in_rarity_3,
		UISoundEvents.wintrack_item_reward_overlay_in_rarity_4,
		UISoundEvents.wintrack_item_reward_overlay_in_rarity_5,
		UISoundEvents.wintrack_item_reward_overlay_in_rarity_6
	}
}

return settings("ViewElementWintrackItemRewardOverlaySettings", view_element_wintrack_item_reward_overlay)
