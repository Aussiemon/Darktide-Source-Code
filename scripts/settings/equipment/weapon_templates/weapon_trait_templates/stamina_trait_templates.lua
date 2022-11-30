local stamina_trait_templates = {
	stamina_lasgun_killshot_01 = {
		{
			"sprint_cost_per_second",
			1
		}
	},
	stamina_autogun_standard_01 = {
		{
			"sprint_cost_per_second",
			1
		}
	},
	thunderhammer_p1_m1_defence_stat = {
		{
			"sprint_cost_per_second",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"block_cost_default",
			"inner",
			{
				max = 1,
				min = 0
			}
		},
		{
			"block_cost_default",
			"outer",
			{
				max = 1,
				min = 0
			}
		},
		{
			"push_cost",
			{
				max = 1,
				min = 0
			}
		}
	},
	ogryn_club_p1_m1_defence_stat = {
		{
			"sprint_cost_per_second",
			{
				max = 0.75,
				min = 0.25
			}
		},
		{
			"block_cost_default",
			"inner",
			{
				max = 1,
				min = 0
			}
		},
		{
			"block_cost_default",
			"outer",
			{
				max = 1,
				min = 0
			}
		},
		{
			"push_cost",
			{
				max = 1,
				min = 0
			}
		}
	},
	thunderhammer_p1_m1_defence_perk = {
		{
			"sprint_cost_per_second",
			0.05
		},
		{
			"block_cost",
			0.05
		},
		{
			"push_cost",
			0.05
		}
	}
}

return stamina_trait_templates
