local talents_view_settings = {
	equip_button_text_equip = "loc_talents_button_equip",
	grid_num_columns = 11,
	grid_num_rows = 5,
	equip_button_action_equip = "talent_equip",
	equip_button_text_unequip = "loc_talents_button_unequip",
	equip_button_action_unequip = "talent_unequip",
	grid_gamepad_start_cell = {
		1,
		3
	},
	talent_groups = {
		combat = {
			blueprint = "talent_group_main_specialization",
			label = "loc_talents_category_combat",
			non_selectable_group = true,
			positions = {
				{
					6,
					1
				}
			}
		},
		tactical = {
			blueprint = "talent_group_tactical_aura",
			label = "loc_talents_category_tactical",
			non_selectable_group = true,
			positions = {
				{
					2,
					1
				}
			}
		},
		aura = {
			blueprint = "talent_group_tactical_aura",
			label = "loc_talents_category_coherency_aura",
			non_selectable_group = true,
			positions = {
				{
					4,
					1
				}
			}
		},
		passive = {
			blueprint = "talent_group_passive",
			label = "loc_talents_category_passive",
			even_talents_offset_x = -23,
			odd_talents_offset_x = 32,
			non_selectable_group = true,
			positions = {
				{
					9,
					1
				},
				{
					10,
					1
				},
				{
					8,
					1
				},
				{
					11,
					1
				}
			}
		},
		tier_1 = {
			blueprint = "talent_group_tier",
			blueprint_locked = "talent_group_tier_locked",
			positions = {
				{
					1,
					3
				},
				{
					1,
					4
				},
				{
					1,
					5
				}
			}
		},
		tier_2 = {
			blueprint = "talent_group_tier",
			blueprint_locked = "talent_group_tier_locked",
			positions = {
				{
					3,
					3
				},
				{
					3,
					4
				},
				{
					3,
					5
				}
			}
		},
		tier_3 = {
			blueprint = "talent_group_tier",
			blueprint_locked = "talent_group_tier_locked",
			positions = {
				{
					5,
					3
				},
				{
					5,
					4
				},
				{
					5,
					5
				}
			}
		},
		tier_4 = {
			blueprint = "talent_group_tier",
			blueprint_locked = "talent_group_tier_locked",
			positions = {
				{
					7,
					3
				},
				{
					7,
					4
				},
				{
					7,
					5
				}
			}
		},
		tier_5 = {
			blueprint = "talent_group_tier",
			blueprint_locked = "talent_group_tier_locked",
			positions = {
				{
					9,
					3
				},
				{
					9,
					4
				},
				{
					9,
					5
				}
			}
		},
		tier_6 = {
			blueprint = "talent_group_tier",
			blueprint_locked = "talent_group_tier_locked",
			positions = {
				{
					11,
					3
				},
				{
					11,
					4
				},
				{
					11,
					5
				}
			}
		}
	}
}

return settings("TalentsViewSettings", talents_view_settings)
