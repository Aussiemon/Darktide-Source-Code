-- chunkname: @scripts/ui/hud/elements/personal_player_panel_hub/hud_element_personal_player_panel_hub_settings.lua

local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local hud_element_personal_player_panel_hub_settings = {
	size = {
		510,
		80
	},
	icon_size = table.clone(ItemSlotSettings.slot_portrait_frame.item_icon_size),
	insignia_icon_size = table.clone(ItemSlotSettings.slot_insignia.item_icon_size),
	icon_bar_spacing = {
		10,
		0
	},
	feature_list = {
		coherency = false,
		name = true,
		pocketable = false,
		character_text = true,
		respawn_timer = false,
		pocketable_small = false,
		corruption_text = false,
		toughness_hit_indicator = false,
		character_titles = true,
		player_color = false,
		ammo = false,
		throwables = false,
		toughness = false,
		level = true,
		portrait = true,
		voip = true,
		health_text = false,
		status_icon = false,
		health = false,
		toughness_text = false,
		insignia = true
	}
}

return settings("HudElementPersonalPlayerPanelHubSettings", hud_element_personal_player_panel_hub_settings)
