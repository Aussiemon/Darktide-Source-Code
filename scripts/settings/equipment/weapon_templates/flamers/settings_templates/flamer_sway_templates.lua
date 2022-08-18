local sway_templates = {}
local overrides = {}

table.make_unique(sway_templates)
table.make_unique(overrides)

return {
	base_templates = sway_templates,
	overrides = overrides
}
