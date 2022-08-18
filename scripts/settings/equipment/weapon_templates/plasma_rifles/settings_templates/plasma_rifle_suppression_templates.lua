local suppression_templates = {}
local overrides = {}

table.make_unique(suppression_templates)
table.make_unique(overrides)

return {
	base_templates = suppression_templates,
	overrides = overrides
}
