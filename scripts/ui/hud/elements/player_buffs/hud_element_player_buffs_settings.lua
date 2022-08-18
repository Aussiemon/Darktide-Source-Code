local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")

local function _get_hud_color(key, alpha)
	local color = table.clone(UIHudSettings[key])

	if alpha then
		color[1] = alpha
	end

	return color
end

local hud_element_player_buffs_settings = {
	horizontal_spacing = 42,
	max_buffs = 20,
	events = {
		{
			"event_player_buff_added",
			"event_player_buff_added"
		},
		{
			"event_player_buff_removed",
			"event_player_buff_removed"
		}
	},
	positive_colors = {
		icon = {
			255,
			255,
			255,
			255
		},
		frame = _get_hud_color("color_tint_main_2", 255)
	},
	negative_colors = {
		icon = {
			255,
			255,
			255,
			255
		},
		frame = _get_hud_color("color_tint_alert_2", 255)
	},
	inactive_colors = {
		icon = Color.ui_grey_medium(255, true),
		frame = Color.ui_grey_medium(255, true),
		text = Color.ui_grey_medium(255, true)
	}
}

return settings("HudElementPlayerBuffsSettings", hud_element_player_buffs_settings)
