-- chunkname: @scripts/ui/hud/elements/smart_tagging/hud_element_smart_tagging_settings.lua

local hud_element_smart_tagging_settings = {
	anim_speed = 8,
	min_radius = 185,
	wheel_slots = 8,
	max_radius = 190,
	cursor_tag_radius = 10,
	scan_delay = 0.2
}

return settings("HudElementSmartTaggingSettings", hud_element_smart_tagging_settings)
