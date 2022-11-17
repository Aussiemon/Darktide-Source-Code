local holo_sight_templates = {
	default = {
		hip_ring = 1.2,
		hide_delay = 0.1,
		show_delay = 0.1,
		ads_ring = 3,
		ads_dot = 7,
		hip_dot = 1.8
	},
	lasgun = {
		hip_ring = 1.2,
		hide_delay = 0.1,
		show_delay = 0.1,
		ads_ring = 3,
		ads_dot = 7,
		hip_dot = 1.8
	},
	laspistol = {
		hip_ring = 0.5,
		hide_delay = 0.1,
		show_delay = 0.1,
		ads_ring = 1.5,
		ads_dot = 0,
		hip_dot = 0.2
	}
}

for name, template in pairs(holo_sight_templates) do
	template.diff_ring = template.ads_ring - template.hip_ring
	template.diff_dot = template.ads_dot - template.hip_dot
end

return settings("HoloSightTemplates", holo_sight_templates)
