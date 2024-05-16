-- chunkname: @scripts/ui/hud/elements/personal_player_panel_hub/hud_element_personal_player_panel_hub_settings.lua

local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local hud_element_personal_player_panel_hub_settings = {
	size = {
		510,
		80,
	},
	icon_size = table.clone(ItemSlotSettings.slot_portrait_frame.item_icon_size),
	insignia_icon_size = table.clone(ItemSlotSettings.slot_insignia.item_icon_size),
	icon_bar_spacing = {
		10,
		0,
	},
	feature_list = {
		ammo = false,
		character_text = true,
		character_titles = true,
		coherency = false,
		corruption_text = false,
		health = false,
		health_text = false,
		insignia = true,
		level = true,
		name = true,
		player_color = false,
		pocketable = false,
		pocketable_small = false,
		portrait = true,
		respawn_timer = false,
		status_icon = false,
		throwables = false,
		toughness = false,
		toughness_hit_indicator = false,
		toughness_text = false,
		voip = true,
	},
}

return settings("HudElementPersonalPlayerPanelHubSettings", hud_element_personal_player_panel_hub_settings)
