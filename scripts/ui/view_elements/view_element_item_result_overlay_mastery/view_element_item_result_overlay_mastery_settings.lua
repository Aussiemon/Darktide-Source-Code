-- chunkname: @scripts/ui/view_elements/view_element_item_result_overlay_mastery/view_element_item_result_overlay_mastery_settings.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local view_element_item_result_overlay_mastery_settings = {
	level_up_delay = 0.1,
	shading_environment = "content/shading_environments/ui/ui_item_preview",
	weapon_spawn_depth = 1.2,
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
		UISoundEvents.item_result_overlay_reward_in_rarity_1,
		UISoundEvents.item_result_overlay_reward_in_rarity_2,
		UISoundEvents.item_result_overlay_reward_in_rarity_3,
		UISoundEvents.item_result_overlay_reward_in_rarity_4,
		UISoundEvents.item_result_overlay_reward_in_rarity_5,
		UISoundEvents.item_result_overlay_reward_in_rarity_6,
	},
}

return settings("ViewElementItemResultOverlayMasterySettings", view_element_item_result_overlay_mastery_settings)
