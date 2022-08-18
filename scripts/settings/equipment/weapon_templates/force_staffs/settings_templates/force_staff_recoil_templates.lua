local recoil_templates = {}
local overrides = {}

table.make_unique(recoil_templates)
table.make_unique(overrides)

return {
	base_templates = recoil_templates,
	overrides = overrides
}
