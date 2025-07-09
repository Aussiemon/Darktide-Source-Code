-- chunkname: @scripts/settings/mutator/mutator_mininion_visual_overrides_settings.lua

local MutatorMinionVisualOverrideSettings = {}
local MinionGibbingTemplates = require("scripts/managers/minion/minion_gibbing_templates")

MutatorMinionVisualOverrideSettings.rotten_armor = {
	renegade_executor = {
		item_slot_data = {
			slot_head = {
				items = {
					"content/items/characters/minions/chaos_traitor_guard/attachments_gear/executor_helmet_01_a_rotten",
				},
			},
			slot_upperbody = {
				items = {
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_rotten",
				},
			},
			slot_variation_gear = {
				items = {
					"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_elite_a_rotten",
				},
			},
			slot_lowerbody = {
				items = {
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_rotten",
				},
			},
		},
		has_gib_override = MinionGibbingTemplates.renegade_executor_gibbing_rotten_armor,
	},
	renegade_berzerker = {
		item_slot_data = {
			slot_head = {
				items = {
					"content/items/characters/minions/chaos_traitor_guard/attachments_gear/traitor_guard_captain_helmet_02_rotten",
				},
			},
			slot_upperbody = {
				items = {
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/upperbody_a_berserker_rotten",
				},
			},
			slot_variation_gear = {
				items = {
					"content/items/characters/minions/chaos_traitor_guard/attachments_gear/melee_elite_a_berserker_rotten",
				},
			},
			slot_lowerbody = {
				items = {
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/lowerbody_b_berserker_rotten",
				},
			},
		},
		has_gib_override = MinionGibbingTemplates.renegade_berzerker_gibbing_rotten_armor,
	},
	chaos_ogryn_executor = {
		item_slot_data = {
			slot_head_attachment = {
				items = {
					"content/items/characters/minions/chaos_ogryn/attachments_gear/bulwark_helmet_01_rotten",
				},
			},
			slot_base_lowerbody = {
				items = {
					"content/items/characters/minions/chaos_ogryn/attachments_base/lowerbody_a_rotten",
				},
			},
			slot_gear_attachment = {
				items = {
					"content/items/characters/minions/chaos_ogryn/attachments_gear/melee_b_rotten",
				},
			},
			slot_base_arms = {
				items = {
					"content/items/characters/minions/chaos_ogryn/attachments_base/arms_a_rotten",
				},
			},
		},
		has_gib_override = MinionGibbingTemplates.chaos_ogryn_executor_gibbing_rotten_armor,
	},
}
MutatorMinionVisualOverrideSettings.head_parasite = {
	default = {
		item_slot_data = {
			slot_head = {
				items = {
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b",
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_01",
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/face_01_b_tattoo_02",
				},
			},
			slot_face = {
				items = {
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/tentacle_head_01_skin_01",
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/tentacle_head_02_skin_01",
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/tentacle_head_03_skin_01",
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/tentacle_head_01",
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/tentacle_head_02",
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/tentacle_head_03",
				},
			},
		},
	},
	ogryn = {
		item_slot_data = {
			slot_head_attachment = {
				items = {
					"content/items/characters/minions/chaos_ogryn/attachments_base/head_a",
					"content/items/characters/minions/chaos_ogryn/attachments_base/head_b",
				},
			},
			slot_head = {
				items = {
					"content/items/characters/minions/chaos_ogryn/attachments_base/tentacle_head_01",
					"content/items/characters/minions/chaos_ogryn/attachments_base/tentacle_head_02",
					"content/items/characters/minions/chaos_ogryn/attachments_base/tentacle_head_01_var_01",
					"content/items/characters/minions/chaos_ogryn/attachments_base/tentacle_head_02_var_01",
				},
			},
		},
	},
	poxwalker = {
		item_slot_data = {
			slot_head = {
				items = {
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/tentacle_head_01_skin_01",
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/tentacle_head_02_skin_01",
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/tentacle_head_03_skin_01",
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/tentacle_head_01",
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/tentacle_head_02",
					"content/items/characters/minions/chaos_traitor_guard/attachments_base/tentacle_head_03",
				},
			},
		},
	},
}

return MutatorMinionVisualOverrideSettings
