-- chunkname: @scripts/ui/hud/elements/crosshair/hud_element_crosshair_settings.lua

local shield_size = {
	31,
	38,
}
local hud_element_crosshair_settings = {
	center_offset = 200,
	half_distance = 2,
	hit_duration = 0.5,
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
		"scripts/ui/hud/elements/crosshair/templates/crosshair_template_assault",
		"scripts/ui/hud/elements/crosshair/templates/crosshair_template_bfg",
		"scripts/ui/hud/elements/crosshair/templates/crosshair_template_charge_up_ads",
		"scripts/ui/hud/elements/crosshair/templates/crosshair_template_charge_up",
		"scripts/ui/hud/elements/crosshair/templates/crosshair_template_cross",
		"scripts/ui/hud/elements/crosshair/templates/crosshair_template_dot",
		"scripts/ui/hud/elements/crosshair/templates/crosshair_template_flamer",
		"scripts/ui/hud/elements/crosshair/templates/crosshair_template_ironsight",
		"scripts/ui/hud/elements/crosshair/templates/crosshair_template_projectile_drop",
		"scripts/ui/hud/elements/crosshair/templates/crosshair_template_shotgun_wide",
		"scripts/ui/hud/elements/crosshair/templates/crosshair_template_shotgun",
		"scripts/ui/hud/elements/crosshair/templates/crosshair_template_spray_n_pray",
	},
	hit_indicator_colors = {
		blocked = {
			255,
			96,
			165,
			255,
		},
		damage_crit = {
			255,
			255,
			165,
			0,
		},
		damage_normal = {
			255,
			255,
			255,
			255,
		},
		death = {
			255,
			255,
			0,
			0,
		},
	},
}

return settings("HudElementCrosshairSettings", hud_element_crosshair_settings)
