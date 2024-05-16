-- chunkname: @scripts/ui/hud/elements/smart_tagging/hud_element_smart_tagging_settings.lua

local hud_element_smart_tagging_settings = {
	anim_speed = 8,
	cursor_tag_radius = 10,
	max_radius = 190,
	min_radius = 185,
	scan_delay = 0.2,
	wheel_slots = 8,
}

return settings("HudElementSmartTaggingSettings", hud_element_smart_tagging_settings)
