-- chunkname: @scripts/ui/hud/elements/emote_wheel/hud_element_emote_wheel_settings.lua

local hud_element_emote_wheel_settings = {
	anim_speed = 25,
	max_radius = 190,
	min_radius = 185,
	scan_delay = 0.2,
	wheel_slots = 8,
}

return settings("HudElementEmoteWheelSettings", hud_element_emote_wheel_settings)
