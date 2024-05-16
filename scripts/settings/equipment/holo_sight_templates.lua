-- chunkname: @scripts/settings/equipment/holo_sight_templates.lua

local holo_sight_templates = {}

holo_sight_templates.default = {
	ads_dot = 7,
	ads_ring = 3,
	hide_delay = 0.1,
	hip_dot = 1.8,
	hip_ring = 1.2,
	show_delay = 0.1,
}
holo_sight_templates.lasgun = {
	ads_dot = 7,
	ads_ring = 3,
	hide_delay = 0.1,
	hip_dot = 1.8,
	hip_ring = 1.2,
	show_delay = 0.1,
}
holo_sight_templates.laspistol = {
	ads_dot = 0,
	ads_ring = 1.5,
	hide_delay = 0.1,
	hip_dot = 0.2,
	hip_ring = 0.5,
	show_delay = 0.1,
}

for name, template in pairs(holo_sight_templates) do
	template.diff_ring = template.ads_ring - template.hip_ring
	template.diff_dot = template.ads_dot - template.hip_dot
end

return settings("HoloSightTemplates", holo_sight_templates)
