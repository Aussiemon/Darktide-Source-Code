-- chunkname: @scripts/ui/view_elements/view_element_wintrack_item_reward_overlay/view_element_wintrack_item_reward_overlay_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local view_element_wintrack_item_reward_overlay = {
	ignore_level_background = true,
	level_name = "content/levels/ui/title_screen/title_screen",
	level_up_delay = 0.1,
	shading_environment = "content/shading_environments/ui/ui_item_preview",
	timer_name = "ui",
	viewport_layer = 1,
	viewport_name = "ui_title_screen_viewport",
	viewport_type = "default_with_alpha",
	weapon_spawn_depth = 1.2,
	world_layer = 800,
	world_name = "ui_title_screen_world",
	effect_textures_by_rarity = {
		{
			glow = "content/ui/materials/effects/item_aquisition/glow_rarity_01",
			particle = "content/ui/materials/effects/item_aquisition/particles_rarity_01",
		},
		{
			glow = "content/ui/materials/effects/item_aquisition/glow_rarity_02",
			particle = "content/ui/materials/effects/item_aquisition/particles_rarity_02",
		},
		{
			glow = "content/ui/materials/effects/item_aquisition/glow_rarity_03",
			particle = "content/ui/materials/effects/item_aquisition/particles_rarity_03",
		},
		{
			glow = "content/ui/materials/effects/item_aquisition/glow_rarity_04",
			particle = "content/ui/materials/effects/item_aquisition/particles_rarity_04",
		},
		{
			glow = "content/ui/materials/effects/item_aquisition/glow_rarity_05",
			particle = "content/ui/materials/effects/item_aquisition/particles_rarity_05",
		},
		{
			glow = "content/ui/materials/effects/item_aquisition/glow_rarity_06",
			particle = "content/ui/materials/effects/item_aquisition/particles_rarity_06",
		},
	},
	sound_events_by_item_rarity = {
		UISoundEvents.wintrack_item_reward_overlay_in_rarity_1,
		UISoundEvents.wintrack_item_reward_overlay_in_rarity_2,
		UISoundEvents.wintrack_item_reward_overlay_in_rarity_3,
		UISoundEvents.wintrack_item_reward_overlay_in_rarity_4,
		UISoundEvents.wintrack_item_reward_overlay_in_rarity_5,
		UISoundEvents.wintrack_item_reward_overlay_in_rarity_6,
	},
}

return settings("ViewElementWintrackItemRewardOverlaySettings", view_element_wintrack_item_reward_overlay)
