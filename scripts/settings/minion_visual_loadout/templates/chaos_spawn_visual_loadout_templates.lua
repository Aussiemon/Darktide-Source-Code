local templates = {
	chaos_spawn = {}
}
local basic_chaos_spawn_template = {
	slots = {
		slot_body = {
			items = {
				"content/items/characters/minions/chaos_spawn/attachments_base/body"
			}
		},
		slot_attachment = {
			items = {
				"content/items/characters/minions/chaos_spawn/attachments_gear/attachment_01"
			}
		},
		envrionmental_override = {
			is_material_override_slot = true,
			items = {
				"content/items/characters/minions/generic_items/empty_minion_item"
			}
		}
	}
}
local default_1 = table.clone(basic_chaos_spawn_template)
templates.chaos_spawn.default = {
	default_1
}

return templates
