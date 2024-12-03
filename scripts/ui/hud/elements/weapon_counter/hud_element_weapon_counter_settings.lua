-- chunkname: @scripts/ui/hud/elements/weapon_counter/hud_element_weapon_counter_settings.lua

local shield_size = {
	31,
	38,
}
local hud_element_weapon_counter_settings = {
	center_offset = 200,
	half_distance = 1,
	max_glow_alpha = 130,
	spacing = 0,
	size = shield_size,
	area_size = {
		shield_size[1] * 12,
		shield_size[2],
	},
	glow_size = {
		29,
		29,
	},
	templates = {
		"scripts/ui/hud/elements/weapon_counter/templates/weapon_counter_template_kill_charges",
		"scripts/ui/hud/elements/weapon_counter/templates/weapon_counter_template_overheat_lockout",
	},
}

return settings("HudElementWeaponCounterSettings", hud_element_weapon_counter_settings)
