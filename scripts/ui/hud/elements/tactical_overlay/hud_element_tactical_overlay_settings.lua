local hud_element_tactical_overlay_settings = {}
local styles = {
	difficulty = {}
}
local difficulty = styles.difficulty
difficulty.difficulty_icon = {
	vertical_alignment = "top",
	spacing = 8,
	direction = 1,
	amount = 0,
	offset = {
		65,
		10,
		4
	},
	size = {
		18,
		40
	},
	color = {
		255,
		169,
		191,
		153
	}
}
difficulty.diffulty_icon_background = table.clone(difficulty.difficulty_icon)
local stat_diffulty_icon_background_style = difficulty.diffulty_icon_background
stat_diffulty_icon_background_style.color = Color.terminal_background(255, true)
stat_diffulty_icon_background_style.amount = 5
difficulty.diffulty_icon_background_frame = table.clone(difficulty.difficulty_icon)
local diffulty_icon_background_frame_style = difficulty.diffulty_icon_background_frame
diffulty_icon_background_frame_style.color = {
	255,
	169,
	191,
	153
}
diffulty_icon_background_frame_style.amount = 5
diffulty_icon_background_frame_style.offset = {
	65,
	10,
	5
}
hud_element_tactical_overlay_settings.styles = styles

return settings("HudElementTacticalOverlaySettings", hud_element_tactical_overlay_settings)
