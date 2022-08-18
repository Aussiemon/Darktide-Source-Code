local hitscan_templates = {}
local overrides = {}

table.make_unique(hitscan_templates)
table.make_unique(overrides)

return {
	base_templates = hitscan_templates,
	overrides = overrides
}
