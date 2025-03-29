-- chunkname: @scripts/settings/ability/archetype_talents/talents/base_talents.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local stat_buffs = BuffSettings.stat_buffs
local base_talents = {
	archetype = "none",
	talents = {
		base_stamina_regen_delay_1 = {
			description = "loc_talent_stamina_regen_delay_desc",
			display_name = "loc_talent_stamina_regen_delay",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_3_2",
			name = "Reduced Stamina Regeneration Delay by 0.25s",
			format_values = {
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "reduced_stamina_regen_delay_1",
						find_value_type = "buff_template",
						prefix = "+",
						path = {
							"stat_buffs",
							stat_buffs.stamina_regeneration_delay,
						},
					},
					value_manipulation = function (value)
						return math.abs(value)
					end,
				},
			},
			passive = {
				buff_template_name = "reduced_stamina_regen_delay_1",
				identifier = "reduced_stamina_regen_delay_1",
			},
		},
		base_stamina_regen_delay_2 = {
			description = "loc_talent_stamina_regen_delay_desc",
			display_name = "loc_talent_stamina_regen_delay",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_3_2",
			name = "Reduced Stamina Regeneration Delay by 0.25s",
			format_values = {
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "reduced_stamina_regen_delay_2",
						find_value_type = "buff_template",
						prefix = "+",
						path = {
							"stat_buffs",
							stat_buffs.stamina_regeneration_delay,
						},
					},
					value_manipulation = function (value)
						return math.abs(value)
					end,
				},
			},
			passive = {
				buff_template_name = "reduced_stamina_regen_delay_2",
				identifier = "reduced_stamina_regen_delay_2",
			},
		},
		base_toughness_node_buff_low_1 = {
			description = "loc_talent_toughness_boost_low_desc",
			display_name = "loc_talent_toughness_boost_low",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "number",
					prefix = "+",
					find_value = {
						buff_template_name = "player_toughness_node_buff_low_1",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_toughness_node_buff_low_1",
				identifier = "player_toughness_node_buff_low_1",
			},
		},
		base_toughness_node_buff_low_2 = {
			description = "loc_talent_toughness_boost_low_desc",
			display_name = "loc_talent_toughness_boost_low",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "number",
					prefix = "+",
					find_value = {
						buff_template_name = "player_toughness_node_buff_low_2",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_toughness_node_buff_low_2",
				identifier = "player_toughness_node_buff_low_2",
			},
		},
		base_toughness_node_buff_low_3 = {
			description = "loc_talent_toughness_boost_low_desc",
			display_name = "loc_talent_toughness_boost_low",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "number",
					prefix = "+",
					find_value = {
						buff_template_name = "player_toughness_node_buff_low_3",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_toughness_node_buff_low_3",
				identifier = "player_toughness_node_buff_low_3",
			},
		},
		base_toughness_node_buff_low_4 = {
			description = "loc_talent_toughness_boost_low_desc",
			display_name = "loc_talent_toughness_boost_low",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "number",
					prefix = "+",
					find_value = {
						buff_template_name = "player_toughness_node_buff_low_4",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_toughness_node_buff_low_4",
				identifier = "player_toughness_node_buff_low_4",
			},
		},
		base_toughness_node_buff_low_5 = {
			description = "loc_talent_toughness_boost_low_desc",
			display_name = "loc_talent_toughness_boost_low",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "number",
					prefix = "+",
					find_value = {
						buff_template_name = "player_toughness_node_buff_low_5",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_toughness_node_buff_low_5",
				identifier = "player_toughness_node_buff_low_5",
			},
		},
		base_toughness_node_buff_medium_1 = {
			description = "loc_talent_toughness_boost_medium_desc",
			display_name = "loc_talent_toughness_boost_medium",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "number",
					prefix = "+",
					find_value = {
						buff_template_name = "player_toughness_node_buff_medium_1",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_toughness_node_buff_medium_1",
				identifier = "player_toughness_node_buff_medium_1",
			},
		},
		base_toughness_node_buff_medium_2 = {
			description = "loc_talent_toughness_boost_medium_desc",
			display_name = "loc_talent_toughness_boost_medium",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "number",
					prefix = "+",
					find_value = {
						buff_template_name = "player_toughness_node_buff_medium_2",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_toughness_node_buff_medium_2",
				identifier = "player_toughness_node_buff_medium_2",
			},
		},
		base_toughness_node_buff_medium_3 = {
			description = "loc_talent_toughness_boost_medium_desc",
			display_name = "loc_talent_toughness_boost_medium",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "number",
					prefix = "+",
					find_value = {
						buff_template_name = "player_toughness_node_buff_medium_3",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_toughness_node_buff_medium_3",
				identifier = "player_toughness_node_buff_medium_3",
			},
		},
		base_toughness_node_buff_medium_4 = {
			description = "loc_talent_toughness_boost_medium_desc",
			display_name = "loc_talent_toughness_boost_medium",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "number",
					prefix = "+",
					find_value = {
						buff_template_name = "player_toughness_node_buff_medium_4",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_toughness_node_buff_medium_4",
				identifier = "player_toughness_node_buff_medium_4",
			},
		},
		base_toughness_node_buff_medium_5 = {
			description = "loc_talent_toughness_boost_medium_desc",
			display_name = "loc_talent_toughness_boost_medium",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "number",
					prefix = "+",
					find_value = {
						buff_template_name = "player_toughness_node_buff_medium_5",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_toughness_node_buff_medium_5",
				identifier = "player_toughness_node_buff_medium_5",
			},
		},
		base_toughness_damage_reduction_node_buff_low_1 = {
			description = "loc_talent_toughness_damage_reduction_low_desc",
			display_name = "loc_talent_toughness_damage_reduction_low",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_toughness_damage_reduction_node_buff_low_1",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier,
						},
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "player_toughness_damage_reduction_node_buff_low_1",
				identifier = "player_toughness_damage_reduction_node_buff_low_1",
			},
		},
		base_toughness_damage_reduction_node_buff_low_2 = {
			description = "loc_talent_toughness_damage_reduction_low_desc",
			display_name = "loc_talent_toughness_damage_reduction_low",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_toughness_damage_reduction_node_buff_low_2",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier,
						},
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "player_toughness_damage_reduction_node_buff_low_2",
				identifier = "player_toughness_damage_reduction_node_buff_low_2",
			},
		},
		base_toughness_damage_reduction_node_buff_low_3 = {
			description = "loc_talent_toughness_damage_reduction_low_desc",
			display_name = "loc_talent_toughness_damage_reduction_low",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_toughness_damage_reduction_node_buff_low_3",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier,
						},
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "player_toughness_damage_reduction_node_buff_low_3",
				identifier = "player_toughness_damage_reduction_node_buff_low_3",
			},
		},
		base_toughness_damage_reduction_node_buff_low_4 = {
			description = "loc_talent_toughness_damage_reduction_low_desc",
			display_name = "loc_talent_toughness_damage_reduction_low",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_toughness_damage_reduction_node_buff_low_4",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier,
						},
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "player_toughness_damage_reduction_node_buff_low_4",
				identifier = "player_toughness_damage_reduction_node_buff_low_4",
			},
		},
		base_toughness_damage_reduction_node_buff_low_5 = {
			description = "loc_talent_toughness_damage_reduction_low_desc",
			display_name = "loc_talent_toughness_damage_reduction_low",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_toughness_damage_reduction_node_buff_low_5",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier,
						},
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "player_toughness_damage_reduction_node_buff_low_5",
				identifier = "player_toughness_damage_reduction_node_buff_low_5",
			},
		},
		base_toughness_damage_reduction_node_buff_medium_1 = {
			description = "loc_talent_toughness_damage_reduction_medium_desc",
			display_name = "loc_talent_toughness_damage_reduction_medium",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_toughness_damage_reduction_node_buff_medium_1",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier,
						},
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "player_toughness_damage_reduction_node_buff_medium_1",
				identifier = "player_toughness_damage_reduction_node_buff_medium_1",
			},
		},
		base_toughness_damage_reduction_node_buff_medium_2 = {
			description = "loc_talent_toughness_damage_reduction_medium_desc",
			display_name = "loc_talent_toughness_damage_reduction_medium",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_toughness_damage_reduction_node_buff_medium_2",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier,
						},
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "player_toughness_damage_reduction_node_buff_medium_2",
				identifier = "player_toughness_damage_reduction_node_buff_medium_2",
			},
		},
		base_toughness_damage_reduction_node_buff_medium_3 = {
			description = "loc_talent_toughness_damage_reduction_medium_desc",
			display_name = "loc_talent_toughness_damage_reduction_medium",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_toughness_damage_reduction_node_buff_medium_3",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier,
						},
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "player_toughness_damage_reduction_node_buff_medium_3",
				identifier = "player_toughness_damage_reduction_node_buff_medium_3",
			},
		},
		base_toughness_damage_reduction_node_buff_medium_4 = {
			description = "loc_talent_toughness_damage_reduction_medium_desc",
			display_name = "loc_talent_toughness_damage_reduction_medium",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_toughness_damage_reduction_node_buff_medium_4",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier,
						},
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "player_toughness_damage_reduction_node_buff_medium_4",
				identifier = "player_toughness_damage_reduction_node_buff_medium_4",
			},
		},
		base_toughness_damage_reduction_node_buff_medium_5 = {
			description = "loc_talent_toughness_damage_reduction_medium_desc",
			display_name = "loc_talent_toughness_damage_reduction_medium",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_toughness_damage_reduction_node_buff_medium_5",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier,
						},
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "player_toughness_damage_reduction_node_buff_medium_5",
				identifier = "player_toughness_damage_reduction_node_buff_medium_5",
			},
		},
		base_ranged_toughness_damage_reduction_node_buff_medium_1 = {
			description = "loc_talent_ranged_toughness_damage_reduction_medium_desc",
			display_name = "loc_talent_ranged_toughness_damage_reduction_medium",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_ranged_toughness_damage_reduction_node_buff_medium_1",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.ranged_toughness_damage_taken_modifier,
						},
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "player_ranged_toughness_damage_reduction_node_buff_medium_1",
				identifier = "player_ranged_toughness_damage_reduction_node_buff_medium_1",
			},
		},
		base_ranged_toughness_damage_reduction_node_buff_medium_2 = {
			description = "loc_talent_ranged_toughness_damage_reduction_medium_desc",
			display_name = "loc_talent_ranged_toughness_damage_reduction_medium",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_ranged_toughness_damage_reduction_node_buff_medium_2",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.ranged_toughness_damage_taken_modifier,
						},
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "player_ranged_toughness_damage_reduction_node_buff_medium_2",
				identifier = "player_ranged_toughness_damage_reduction_node_buff_medium_2",
			},
		},
		base_ranged_toughness_damage_reduction_node_buff_medium_3 = {
			description = "loc_talent_ranged_toughness_damage_reduction_medium_desc",
			display_name = "loc_talent_ranged_toughness_damage_reduction_medium",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_ranged_toughness_damage_reduction_node_buff_medium_3",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.ranged_toughness_damage_taken_modifier,
						},
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "player_ranged_toughness_damage_reduction_node_buff_medium_3",
				identifier = "player_ranged_toughness_damage_reduction_node_buff_medium_3",
			},
		},
		base_ranged_toughness_damage_reduction_node_buff_medium_4 = {
			description = "loc_talent_ranged_toughness_damage_reduction_medium_desc",
			display_name = "loc_talent_ranged_toughness_damage_reduction_medium",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_ranged_toughness_damage_reduction_node_buff_medium_4",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.ranged_toughness_damage_taken_modifier,
						},
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "player_ranged_toughness_damage_reduction_node_buff_medium_4",
				identifier = "player_ranged_toughness_damage_reduction_node_buff_medium_4",
			},
		},
		base_ranged_toughness_damage_reduction_node_buff_medium_5 = {
			description = "loc_talent_ranged_toughness_damage_reduction_medium_desc",
			display_name = "loc_talent_ranged_toughness_damage_reduction_medium",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_ranged_toughness_damage_reduction_node_buff_medium_5",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.ranged_toughness_damage_taken_modifier,
						},
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "player_toughness_damage_reduction_node_buff_medium_5",
				identifier = "player_toughness_damage_reduction_node_buff_medium_5",
			},
		},
		base_melee_toughness_damage_reduction_node_buff_medium_1 = {
			description = "loc_talent_melee_toughness_damage_reduction_medium_desc",
			display_name = "loc_talent_melee_toughness_damage_reduction_medium",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_melee_toughness_damage_reduction_node_buff_medium_1",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier,
						},
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "player_melee_toughness_damage_reduction_node_buff_medium_1",
				identifier = "player_melee_toughness_damage_reduction_node_buff_medium_1",
			},
		},
		base_melee_toughness_damage_reduction_node_buff_medium_2 = {
			description = "loc_talent_melee_toughness_damage_reduction_medium_desc",
			display_name = "loc_talent_melee_toughness_damage_reduction_medium",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_melee_toughness_damage_reduction_node_buff_medium_2",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier,
						},
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "player_melee_toughness_damage_reduction_node_buff_medium_2",
				identifier = "player_melee_toughness_damage_reduction_node_buff_medium_2",
			},
		},
		base_melee_toughness_damage_reduction_node_buff_medium_3 = {
			description = "loc_talent_melee_toughness_damage_reduction_medium_desc",
			display_name = "loc_talent_melee_toughness_damage_reduction_medium",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_melee_toughness_damage_reduction_node_buff_medium_3",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier,
						},
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "player_melee_toughness_damage_reduction_node_buff_medium_3",
				identifier = "player_melee_toughness_damage_reduction_node_buff_medium_3",
			},
		},
		base_melee_toughness_damage_reduction_node_buff_medium_4 = {
			description = "loc_talent_melee_toughness_damage_reduction_medium_desc",
			display_name = "loc_talent_melee_toughness_damage_reduction_medium",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_melee_toughness_damage_reduction_node_buff_medium_4",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier,
						},
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "player_melee_toughness_damage_reduction_node_buff_medium_4",
				identifier = "player_melee_toughness_damage_reduction_node_buff_medium_4",
			},
		},
		base_melee_toughness_damage_reduction_node_buff_medium_5 = {
			description = "loc_talent_melee_toughness_damage_reduction_medium_desc",
			display_name = "loc_talent_melee_toughness_damage_reduction_medium",
			name = "[dev] toughness bonus",
			format_values = {
				toughness = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_melee_toughness_damage_reduction_node_buff_medium_5",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier,
						},
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "player_toughness_damage_reduction_node_buff_medium_5",
				identifier = "player_toughness_damage_reduction_node_buff_medium_5",
			},
		},
		base_melee_damage_node_buff_low_1 = {
			description = "loc_talent_melee_damage_boost_low_desc",
			display_name = "loc_talent_melee_damage_boost_low",
			name = "[dev] melee_damage bonus",
			format_values = {
				melee_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_melee_damage_node_buff_low_1",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.melee_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_melee_damage_node_buff_low_1",
				identifier = "player_melee_damage_node_buff_low_1",
			},
		},
		base_melee_damage_node_buff_low_2 = {
			description = "loc_talent_melee_damage_boost_low_desc",
			display_name = "loc_talent_melee_damage_boost_low",
			name = "[dev] melee_damage bonus",
			format_values = {
				melee_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_melee_damage_node_buff_low_2",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.melee_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_melee_damage_node_buff_low_2",
				identifier = "player_melee_damage_node_buff_low_2",
			},
		},
		base_melee_damage_node_buff_low_3 = {
			description = "loc_talent_melee_damage_boost_low_desc",
			display_name = "loc_talent_melee_damage_boost_low",
			name = "[dev] melee_damage bonus",
			format_values = {
				melee_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_melee_damage_node_buff_low_3",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.melee_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_melee_damage_node_buff_low_3",
				identifier = "player_melee_damage_node_buff_low_3",
			},
		},
		base_melee_damage_node_buff_low_4 = {
			description = "loc_talent_melee_damage_boost_low_desc",
			display_name = "loc_talent_melee_damage_boost_low",
			name = "[dev] melee_damage bonus",
			format_values = {
				melee_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_melee_damage_node_buff_low_4",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.melee_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_melee_damage_node_buff_low_4",
				identifier = "player_melee_damage_node_buff_low_4",
			},
		},
		base_melee_damage_node_buff_low_5 = {
			description = "loc_talent_melee_damage_boost_low_desc",
			display_name = "loc_talent_melee_damage_boost_low",
			name = "[dev] melee_damage bonus",
			format_values = {
				melee_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_melee_damage_node_buff_low_5",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.melee_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_melee_damage_node_buff_low_5",
				identifier = "player_melee_damage_node_buff_low_5",
			},
		},
		base_melee_damage_node_buff_medium_1 = {
			description = "loc_talent_melee_damage_boost_medium_desc",
			display_name = "loc_talent_melee_damage_boost_medium",
			name = "[dev] melee_damage bonus",
			format_values = {
				melee_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_melee_damage_node_buff_medium_1",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.melee_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_melee_damage_node_buff_medium_1",
				identifier = "player_melee_damage_node_buff_medium_1",
			},
		},
		base_melee_damage_node_buff_medium_2 = {
			description = "loc_talent_melee_damage_boost_medium_desc",
			display_name = "loc_talent_melee_damage_boost_medium",
			name = "[dev] melee_damage bonus",
			format_values = {
				melee_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_melee_damage_node_buff_medium_2",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.melee_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_melee_damage_node_buff_medium_2",
				identifier = "player_melee_damage_node_buff_medium_2",
			},
		},
		base_melee_damage_node_buff_medium_3 = {
			description = "loc_talent_melee_damage_boost_medium_desc",
			display_name = "loc_talent_melee_damage_boost_medium",
			name = "[dev] melee_damage bonus",
			format_values = {
				melee_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_melee_damage_node_buff_medium_3",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.melee_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_melee_damage_node_buff_medium_3",
				identifier = "player_melee_damage_node_buff_medium_3",
			},
		},
		base_melee_damage_node_buff_medium_4 = {
			description = "loc_talent_melee_damage_boost_medium_desc",
			display_name = "loc_talent_melee_damage_boost_medium",
			name = "[dev] melee_damage bonus",
			format_values = {
				melee_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_melee_damage_node_buff_medium_4",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.melee_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_melee_damage_node_buff_medium_4",
				identifier = "player_melee_damage_node_buff_medium_4",
			},
		},
		base_melee_damage_node_buff_medium_5 = {
			description = "loc_talent_melee_damage_boost_medium_desc",
			display_name = "loc_talent_melee_damage_boost_medium",
			name = "[dev] melee_damage bonus",
			format_values = {
				melee_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_melee_damage_node_buff_medium_5",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.melee_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_melee_damage_node_buff_medium_5",
				identifier = "player_melee_damage_node_buff_medium_5",
			},
		},
		base_melee_heavy_damage_node_buff_low_1 = {
			description = "loc_talent_melee_heavy_damage_low_desc",
			display_name = "loc_talent_melee_heavy_damage_low",
			name = "[dev] melee_heavy_damage bonus",
			format_values = {
				melee_heavy_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_melee_heavy_damage_node_buff_low_1",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.melee_heavy_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_melee_heavy_damage_node_buff_low_1",
				identifier = "player_melee_heavy_damage_node_buff_low_1",
			},
		},
		base_melee_heavy_damage_node_buff_low_2 = {
			description = "loc_talent_melee_heavy_damage_low_desc",
			display_name = "loc_talent_melee_heavy_damage_low",
			name = "[dev] melee_heavy_damage bonus",
			format_values = {
				melee_heavy_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_melee_heavy_damage_node_buff_low_2",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.melee_heavy_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_melee_heavy_damage_node_buff_low_2",
				identifier = "player_melee_heavy_damage_node_buff_low_2",
			},
		},
		base_melee_heavy_damage_node_buff_low_3 = {
			description = "loc_talent_melee_heavy_damage_low_desc",
			display_name = "loc_talent_melee_heavy_damage_low",
			name = "[dev] melee_heavy_damage bonus",
			format_values = {
				melee_heavy_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_melee_heavy_damage_node_buff_low_3",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.melee_heavy_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_melee_heavy_damage_node_buff_low_3",
				identifier = "player_melee_heavy_damage_node_buff_low_3",
			},
		},
		base_melee_heavy_damage_node_buff_low_4 = {
			description = "loc_talent_melee_heavy_damage_low_desc",
			display_name = "loc_talent_melee_heavy_damage_low",
			name = "[dev] melee_heavy_damage bonus",
			format_values = {
				melee_heavy_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_melee_heavy_damage_node_buff_low_4",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.melee_heavy_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_melee_heavy_damage_node_buff_low_4",
				identifier = "player_melee_heavy_damage_node_buff_low_4",
			},
		},
		base_melee_heavy_damage_node_buff_low_5 = {
			description = "loc_talent_melee_heavy_damage_low_desc",
			display_name = "loc_talent_melee_heavy_damage_low",
			name = "[dev] melee_heavy_damage bonus",
			format_values = {
				melee_heavy_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_melee_heavy_damage_node_buff_low_5",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.melee_heavy_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_melee_heavy_damage_node_buff_low_5",
				identifier = "player_melee_heavy_damage_node_buff_low_5",
			},
		},
		base_melee_heavy_damage_node_buff_medium_1 = {
			description = "loc_talent_melee_heavy_damage_medium_desc",
			display_name = "loc_talent_melee_heavy_damage_medium",
			name = "[dev] melee_heavy_damage bonus",
			format_values = {
				melee_heavy_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_melee_heavy_damage_node_buff_medium_1",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.melee_heavy_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_melee_heavy_damage_node_buff_medium_1",
				identifier = "player_melee_heavy_damage_node_buff_medium_1",
			},
		},
		base_melee_heavy_damage_node_buff_medium_2 = {
			description = "loc_talent_melee_heavy_damage_medium_desc",
			display_name = "loc_talent_melee_heavy_damage_medium",
			name = "[dev] melee_heavy_damage bonus",
			format_values = {
				melee_heavy_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_melee_heavy_damage_node_buff_medium_2",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.melee_heavy_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_melee_heavy_damage_node_buff_medium_2",
				identifier = "player_melee_heavy_damage_node_buff_medium_2",
			},
		},
		base_melee_heavy_damage_node_buff_medium_3 = {
			description = "loc_talent_melee_heavy_damage_medium_desc",
			display_name = "loc_talent_melee_heavy_damage_medium",
			name = "[dev] melee_heavy_damage bonus",
			format_values = {
				melee_heavy_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_melee_heavy_damage_node_buff_medium_3",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.melee_heavy_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_melee_heavy_damage_node_buff_medium_3",
				identifier = "player_melee_heavy_damage_node_buff_medium_3",
			},
		},
		base_melee_heavy_damage_node_buff_medium_4 = {
			description = "loc_talent_melee_heavy_damage_medium_desc",
			display_name = "loc_talent_melee_heavy_damage_medium",
			name = "[dev] melee_heavy_damage bonus",
			format_values = {
				melee_heavy_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_melee_heavy_damage_node_buff_medium_4",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.melee_heavy_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_melee_heavy_damage_node_buff_medium_4",
				identifier = "player_melee_heavy_damage_node_buff_medium_4",
			},
		},
		base_melee_heavy_damage_node_buff_medium_5 = {
			description = "loc_talent_melee_heavy_damage_medium_desc",
			display_name = "loc_talent_melee_heavy_damage_medium",
			name = "[dev] melee_heavy_damage bonus",
			format_values = {
				melee_heavy_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_melee_heavy_damage_node_buff_medium_5",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.melee_heavy_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_melee_heavy_damage_node_buff_medium_5",
				identifier = "player_melee_heavy_damage_node_buff_medium_5",
			},
		},
		base_ranged_damage_node_buff_low_1 = {
			description = "loc_talent_ranged_damage_low_desc",
			display_name = "loc_talent_ranged_damage_low",
			name = "[dev] ranged_damage bonus",
			format_values = {
				ranged_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_ranged_damage_node_buff_low_1",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.ranged_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_ranged_damage_node_buff_low_1",
				identifier = "player_ranged_damage_node_buff_low_1",
			},
		},
		base_ranged_damage_node_buff_low_2 = {
			description = "loc_talent_ranged_damage_low_desc",
			display_name = "loc_talent_ranged_damage_low",
			name = "[dev] ranged_damage bonus",
			format_values = {
				ranged_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_ranged_damage_node_buff_low_2",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.ranged_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_ranged_damage_node_buff_low_2",
				identifier = "player_ranged_damage_node_buff_low_2",
			},
		},
		base_ranged_damage_node_buff_low_3 = {
			description = "loc_talent_ranged_damage_low_desc",
			display_name = "loc_talent_ranged_damage_low",
			name = "[dev] ranged_damage bonus",
			format_values = {
				ranged_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_ranged_damage_node_buff_low_3",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.ranged_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_ranged_damage_node_buff_low_3",
				identifier = "player_ranged_damage_node_buff_low_3",
			},
		},
		base_ranged_damage_node_buff_low_4 = {
			description = "loc_talent_ranged_damage_low_desc",
			display_name = "loc_talent_ranged_damage_low",
			name = "[dev] ranged_damage bonus",
			format_values = {
				ranged_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_ranged_damage_node_buff_low_4",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.ranged_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_ranged_damage_node_buff_low_4",
				identifier = "player_ranged_damage_node_buff_low_4",
			},
		},
		base_ranged_damage_node_buff_low_5 = {
			description = "loc_talent_ranged_damage_low_desc",
			display_name = "loc_talent_ranged_damage_low",
			name = "[dev] ranged_damage bonus",
			format_values = {
				ranged_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_ranged_damage_node_buff_low_5",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.ranged_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_ranged_damage_node_buff_low_5",
				identifier = "player_ranged_damage_node_buff_low_5",
			},
		},
		base_ranged_damage_node_buff_medium_1 = {
			description = "loc_talent_ranged_damage_medium_desc",
			display_name = "loc_talent_ranged_damage_medium",
			name = "[dev] ranged_damage bonus",
			format_values = {
				ranged_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_ranged_damage_node_buff_medium_1",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.ranged_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_ranged_damage_node_buff_medium_1",
				identifier = "player_ranged_damage_node_buff_medium_1",
			},
		},
		base_ranged_damage_node_buff_medium_2 = {
			description = "loc_talent_ranged_damage_medium_desc",
			display_name = "loc_talent_ranged_damage_medium",
			name = "[dev] ranged_damage bonus",
			format_values = {
				ranged_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_ranged_damage_node_buff_medium_2",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.ranged_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_ranged_damage_node_buff_medium_2",
				identifier = "player_ranged_damage_node_buff_medium_2",
			},
		},
		base_ranged_damage_node_buff_medium_3 = {
			description = "loc_talent_ranged_damage_medium_desc",
			display_name = "loc_talent_ranged_damage_medium",
			name = "[dev] ranged_damage bonus",
			format_values = {
				ranged_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_ranged_damage_node_buff_medium_3",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.ranged_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_ranged_damage_node_buff_medium_3",
				identifier = "player_ranged_damage_node_buff_medium_3",
			},
		},
		base_ranged_damage_node_buff_medium_4 = {
			description = "loc_talent_ranged_damage_medium_desc",
			display_name = "loc_talent_ranged_damage_medium",
			name = "[dev] ranged_damage bonus",
			format_values = {
				ranged_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_ranged_damage_node_buff_medium_4",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.ranged_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_ranged_damage_node_buff_medium_4",
				identifier = "player_ranged_damage_node_buff_medium_4",
			},
		},
		base_ranged_damage_node_buff_medium_5 = {
			description = "loc_talent_ranged_damage_medium_desc",
			display_name = "loc_talent_ranged_damage_medium",
			name = "[dev] ranged_damage bonus",
			format_values = {
				ranged_damage = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_ranged_damage_node_buff_medium_5",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.ranged_damage,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_ranged_damage_node_buff_medium_5",
				identifier = "player_ranged_damage_node_buff_medium_5",
			},
		},
		base_armor_pen_node_buff_low_1 = {
			description = "loc_talent_armor_pen_low_desc",
			display_name = "loc_talent_armor_pen_low",
			name = "[dev] armor_pen bonus",
			format_values = {
				rending = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_armor_pen_node_buff_low_1",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.rending_multiplier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_armor_pen_node_buff_low_1",
				identifier = "player_armor_pen_node_buff_low_1",
			},
		},
		base_armor_pen_node_buff_low_2 = {
			description = "loc_talent_armor_pen_low_desc",
			display_name = "loc_talent_armor_pen_low",
			name = "[dev] armor_pen bonus",
			format_values = {
				rending = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_armor_pen_node_buff_low_2",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.rending_multiplier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_armor_pen_node_buff_low_2",
				identifier = "player_armor_pen_node_buff_low_2",
			},
		},
		base_armor_pen_node_buff_low_3 = {
			description = "loc_talent_armor_pen_low_desc",
			display_name = "loc_talent_armor_pen_low",
			name = "[dev] armor_pen bonus",
			format_values = {
				rending = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_armor_pen_node_buff_low_3",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.rending_multiplier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_armor_pen_node_buff_low_3",
				identifier = "player_armor_pen_node_buff_low_3",
			},
		},
		base_armor_pen_node_buff_low_4 = {
			description = "loc_talent_armor_pen_low_desc",
			display_name = "loc_talent_armor_pen_low",
			name = "[dev] armor_pen bonus",
			format_values = {
				rending = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_armor_pen_node_buff_low_4",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.rending_multiplier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_armor_pen_node_buff_low_4",
				identifier = "player_armor_pen_node_buff_low_4",
			},
		},
		base_armor_pen_node_buff_low_5 = {
			description = "loc_talent_armor_pen_low_desc",
			display_name = "loc_talent_armor_pen_low",
			name = "[dev] armor_pen bonus",
			format_values = {
				rending = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_armor_pen_node_buff_low_5",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.rending_multiplier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_armor_pen_node_buff_low_5",
				identifier = "player_armor_pen_node_buff_low_5",
			},
		},
		base_reload_speed_node_buff_low_1 = {
			description = "loc_talent_reload_speed_low_desc",
			display_name = "loc_talent_reload_speed_low",
			name = "[dev] reload_speed bonus",
			format_values = {
				reload_speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_reload_speed_node_buff_low_1",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.reload_speed,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_reload_speed_node_buff_low_1",
				identifier = "player_reload_speed_node_buff_low_1",
			},
		},
		base_reload_speed_node_buff_low_2 = {
			description = "loc_talent_reload_speed_low_desc",
			display_name = "loc_talent_reload_speed_low",
			name = "[dev] reload_speed bonus",
			format_values = {
				reload_speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_reload_speed_node_buff_low_2",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.reload_speed,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_reload_speed_node_buff_low_2",
				identifier = "player_reload_speed_node_buff_low_2",
			},
		},
		base_reload_speed_node_buff_low_3 = {
			description = "loc_talent_reload_speed_low_desc",
			display_name = "loc_talent_reload_speed_low",
			name = "[dev] reload_speed bonus",
			format_values = {
				reload_speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_reload_speed_node_buff_low_3",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.reload_speed,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_reload_speed_node_buff_low_3",
				identifier = "player_reload_speed_node_buff_low_3",
			},
		},
		base_reload_speed_node_buff_low_4 = {
			description = "loc_talent_reload_speed_low_desc",
			display_name = "loc_talent_reload_speed_low",
			name = "[dev] reload_speed bonus",
			format_values = {
				reload_speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_reload_speed_node_buff_low_4",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.reload_speed,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_reload_speed_node_buff_low_4",
				identifier = "player_reload_speed_node_buff_low_4",
			},
		},
		base_reload_speed_node_buff_low_5 = {
			description = "loc_talent_reload_speed_low_desc",
			display_name = "loc_talent_reload_speed_low",
			name = "[dev] reload_speed bonus",
			format_values = {
				reload_speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_reload_speed_node_buff_low_5",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.reload_speed,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_reload_speed_node_buff_low_5",
				identifier = "player_reload_speed_node_buff_low_5",
			},
		},
		base_reload_speed_node_buff_medium_1 = {
			description = "loc_talent_reload_speed_medium_desc",
			display_name = "loc_talent_reload_speed_medium",
			name = "[dev] reload_speed bonus",
			format_values = {
				reload_speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_reload_speed_node_buff_medium_1",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.reload_speed,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_reload_speed_node_buff_medium_1",
				identifier = "player_reload_speed_node_buff_medium_1",
			},
		},
		base_reload_speed_node_buff_medium_2 = {
			description = "loc_talent_reload_speed_medium_desc",
			display_name = "loc_talent_reload_speed_medium",
			name = "[dev] reload_speed bonus",
			format_values = {
				reload_speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_reload_speed_node_buff_medium_2",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.reload_speed,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_reload_speed_node_buff_medium_2",
				identifier = "player_reload_speed_node_buff_medium_2",
			},
		},
		base_reload_speed_node_buff_medium_3 = {
			description = "loc_talent_reload_speed_medium_desc",
			display_name = "loc_talent_reload_speed_medium",
			name = "[dev] reload_speed bonus",
			format_values = {
				reload_speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_reload_speed_node_buff_medium_3",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.reload_speed,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_reload_speed_node_buff_medium_3",
				identifier = "player_reload_speed_node_buff_medium_3",
			},
		},
		base_reload_speed_node_buff_medium_4 = {
			description = "loc_talent_reload_speed_medium_desc",
			display_name = "loc_talent_reload_speed_medium",
			name = "[dev] reload_speed bonus",
			format_values = {
				reload_speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_reload_speed_node_buff_medium_4",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.reload_speed,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_reload_speed_node_buff_medium_4",
				identifier = "player_reload_speed_node_buff_medium_4",
			},
		},
		base_reload_speed_node_buff_medium_5 = {
			description = "loc_talent_reload_speed_medium_desc",
			display_name = "loc_talent_reload_speed_medium",
			name = "[dev] reload_speed bonus",
			format_values = {
				reload_speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_reload_speed_node_buff_medium_5",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.reload_speed,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_ranged_damage_node_buff_medium_5",
				identifier = "player_ranged_damage_node_buff_medium_5",
			},
		},
		base_suppression_node_buff_low_1 = {
			description = "loc_talent_suppression_low_desc",
			display_name = "loc_talent_suppression_low",
			name = "[dev] suppression bonus",
			format_values = {
				suppression = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_suppression_node_buff_low_1",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.suppression_dealt,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_suppression_node_buff_low_1",
				identifier = "player_suppression_node_buff_low_1",
			},
		},
		base_suppression_node_buff_low_2 = {
			description = "loc_talent_suppression_low_desc",
			display_name = "loc_talent_suppression_low",
			name = "[dev] suppression bonus",
			format_values = {
				suppression = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_suppression_node_buff_low_2",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.suppression_dealt,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_suppression_node_buff_low_2",
				identifier = "player_suppression_node_buff_low_2",
			},
		},
		base_suppression_node_buff_low_3 = {
			description = "loc_talent_suppression_low_desc",
			display_name = "loc_talent_suppression_low",
			name = "[dev] suppression bonus",
			format_values = {
				suppression = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_suppression_node_buff_low_3",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.suppression_dealt,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_suppression_node_buff_low_3",
				identifier = "player_suppression_node_buff_low_3",
			},
		},
		base_suppression_node_buff_low_4 = {
			description = "loc_talent_suppression_low_desc",
			display_name = "loc_talent_suppression_low",
			name = "[dev] suppression bonus",
			format_values = {
				suppression = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_suppression_node_buff_low_4",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.suppression_dealt,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_suppression_node_buff_low_4",
				identifier = "player_suppression_node_buff_low_4",
			},
		},
		base_suppression_node_buff_low_5 = {
			description = "loc_talent_suppression_low_desc",
			display_name = "loc_talent_suppression_low",
			name = "[dev] suppression bonus",
			format_values = {
				suppression = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_suppression_node_buff_low_5",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.suppression_dealt,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_suppression_node_buff_low_5",
				identifier = "player_suppression_node_buff_low_5",
			},
		},
		base_stamina_node_buff_low_1 = {
			description = "loc_talent_stamina_low_desc",
			display_name = "loc_talent_stamina_low",
			name = "[dev] stamina bonus",
			format_values = {
				stamina = {
					format_type = "number",
					prefix = "+",
					find_value = {
						buff_template_name = "player_stamina_node_buff_low_1",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.stamina_modifier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_stamina_node_buff_low_1",
				identifier = "player_stamina_node_buff_low_1",
			},
		},
		base_stamina_node_buff_low_2 = {
			description = "loc_talent_stamina_low_desc",
			display_name = "loc_talent_stamina_low",
			name = "[dev] stamina bonus",
			format_values = {
				stamina = {
					format_type = "number",
					prefix = "+",
					find_value = {
						buff_template_name = "player_stamina_node_buff_low_2",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.stamina_modifier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_stamina_node_buff_low_2",
				identifier = "player_stamina_node_buff_low_2",
			},
		},
		base_stamina_node_buff_low_3 = {
			description = "loc_talent_stamina_low_desc",
			display_name = "loc_talent_stamina_low",
			name = "[dev] stamina bonus",
			format_values = {
				stamina = {
					format_type = "number",
					prefix = "+",
					find_value = {
						buff_template_name = "player_stamina_node_buff_low_3",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.stamina_modifier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_stamina_node_buff_low_3",
				identifier = "player_stamina_node_buff_low_3",
			},
		},
		base_stamina_node_buff_low_4 = {
			description = "loc_talent_stamina_low_desc",
			display_name = "loc_talent_stamina_low",
			name = "[dev] stamina bonus",
			format_values = {
				stamina = {
					format_type = "number",
					prefix = "+",
					find_value = {
						buff_template_name = "player_stamina_node_buff_low_4",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.stamina_modifier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_stamina_node_buff_low_4",
				identifier = "player_stamina_node_buff_low_4",
			},
		},
		base_stamina_node_buff_low_5 = {
			description = "loc_talent_stamina_low_desc",
			display_name = "loc_talent_stamina_low",
			name = "[dev] stamina bonus",
			format_values = {
				stamina = {
					format_type = "number",
					prefix = "+",
					find_value = {
						buff_template_name = "player_stamina_node_buff_low_5",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.stamina_modifier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_stamina_node_buff_low_5",
				identifier = "player_stamina_node_buff_low_5",
			},
		},
		base_health_node_buff_low_1 = {
			description = "loc_talent_health_low_desc",
			display_name = "loc_talent_health_low",
			name = "[dev] health bonus",
			format_values = {
				health = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_health_node_buff_low_1",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.max_health_modifier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_health_node_buff_low_1",
				identifier = "player_health_node_buff_low_1",
			},
		},
		base_health_node_buff_low_2 = {
			description = "loc_talent_health_low_desc",
			display_name = "loc_talent_health_low",
			name = "[dev] health bonus",
			format_values = {
				health = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_health_node_buff_low_2",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.max_health_modifier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_health_node_buff_low_2",
				identifier = "player_health_node_buff_low_2",
			},
		},
		base_health_node_buff_low_3 = {
			description = "loc_talent_health_low_desc",
			display_name = "loc_talent_health_low",
			name = "[dev] health bonus",
			format_values = {
				health = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_health_node_buff_low_3",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.max_health_modifier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_health_node_buff_low_3",
				identifier = "player_health_node_buff_low_3",
			},
		},
		base_health_node_buff_low_4 = {
			description = "loc_talent_health_low_desc",
			display_name = "loc_talent_health_low",
			name = "[dev] health bonus",
			format_values = {
				health = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_health_node_buff_low_4",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.max_health_modifier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_health_node_buff_low_4",
				identifier = "player_health_node_buff_low_4",
			},
		},
		base_health_node_buff_low_5 = {
			description = "loc_talent_health_low_desc",
			display_name = "loc_talent_health_low",
			name = "[dev] health bonus",
			format_values = {
				health = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_health_node_buff_low_5",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.max_health_modifier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_health_node_buff_low_5",
				identifier = "player_health_node_buff_low_5",
			},
		},
		base_health_node_buff_medium_1 = {
			description = "loc_talent_health_medium_desc",
			display_name = "loc_talent_health_medium",
			name = "[dev] health bonus",
			format_values = {
				health = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_health_node_buff_medium_1",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.max_health_modifier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_health_node_buff_medium_1",
				identifier = "player_health_node_buff_medium_1",
			},
		},
		base_health_node_buff_medium_2 = {
			description = "loc_talent_health_medium_desc",
			display_name = "loc_talent_health_medium",
			name = "[dev] health bonus",
			format_values = {
				health = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_health_node_buff_medium_2",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.max_health_modifier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_health_node_buff_medium_2",
				identifier = "player_health_node_buff_medium_2",
			},
		},
		base_health_node_buff_medium_3 = {
			description = "loc_talent_health_medium_desc",
			display_name = "loc_talent_health_medium",
			name = "[dev] health bonus",
			format_values = {
				health = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_health_node_buff_medium_3",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.max_health_modifier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_health_node_buff_medium_3",
				identifier = "player_health_node_buff_medium_3",
			},
		},
		base_health_node_buff_medium_4 = {
			description = "loc_talent_health_medium_desc",
			display_name = "loc_talent_health_medium",
			name = "[dev] health bonus",
			format_values = {
				health = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_health_node_buff_medium_4",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.max_health_modifier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_health_node_buff_medium_4",
				identifier = "player_health_node_buff_medium_4",
			},
		},
		base_health_node_buff_medium_5 = {
			description = "loc_talent_health_medium_desc",
			display_name = "loc_talent_health_medium",
			name = "[dev] health bonus",
			format_values = {
				health = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_health_node_buff_medium_5",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.max_health_modifier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_health_node_buff_medium_5",
				identifier = "player_health_node_buff_medium_5",
			},
		},
		base_crit_chance_node_buff_low_1 = {
			description = "loc_talent_crit_chance_low_desc",
			display_name = "loc_talent_crit_chance_low",
			name = "[dev] crit_chance bonus",
			format_values = {
				crit_chance = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_crit_chance_node_buff_low_1",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.critical_strike_chance,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_crit_chance_node_buff_low_1",
				identifier = "player_crit_chance_node_buff_low_1",
			},
		},
		base_crit_chance_node_buff_low_2 = {
			description = "loc_talent_crit_chance_low_desc",
			display_name = "loc_talent_crit_chance_low",
			name = "[dev] crit_chance bonus",
			format_values = {
				crit_chance = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_crit_chance_node_buff_low_2",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.critical_strike_chance,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_crit_chance_node_buff_low_2",
				identifier = "player_crit_chance_node_buff_low_2",
			},
		},
		base_crit_chance_node_buff_low_3 = {
			description = "loc_talent_crit_chance_low_desc",
			display_name = "loc_talent_crit_chance_low",
			name = "[dev] crit_chance bonus",
			format_values = {
				crit_chance = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_crit_chance_node_buff_low_3",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.critical_strike_chance,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_crit_chance_node_buff_low_3",
				identifier = "player_crit_chance_node_buff_low_3",
			},
		},
		base_crit_chance_node_buff_low_4 = {
			description = "loc_talent_crit_chance_low_desc",
			display_name = "loc_talent_crit_chance_low",
			name = "[dev] crit_chance bonus",
			format_values = {
				crit_chance = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_crit_chance_node_buff_low_4",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.critical_strike_chance,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_crit_chance_node_buff_low_4",
				identifier = "player_crit_chance_node_buff_low_4",
			},
		},
		base_crit_chance_node_buff_low_5 = {
			description = "loc_talent_crit_chance_low_desc",
			display_name = "loc_talent_crit_chance_low",
			name = "[dev] crit_chance bonus",
			format_values = {
				crit_chance = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_crit_chance_node_buff_low_5",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.critical_strike_chance,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_crit_chance_node_buff_low_5",
				identifier = "player_crit_chance_node_buff_low_5",
			},
		},
		base_movement_speed_node_buff_low_1 = {
			description = "loc_talent_movement_speed_low_desc",
			display_name = "loc_talent_movement_speed_low",
			name = "[dev] movement_speed bonus",
			format_values = {
				movement_speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_movement_speed_node_buff_low_1",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.movement_speed,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_movement_speed_node_buff_low_1",
				identifier = "player_movement_speed_node_buff_low_1",
			},
		},
		base_movement_speed_node_buff_low_2 = {
			description = "loc_talent_movement_speed_low_desc",
			display_name = "loc_talent_movement_speed_low",
			name = "[dev] movement_speed bonus",
			format_values = {
				movement_speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_movement_speed_node_buff_low_2",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.movement_speed,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_movement_speed_node_buff_low_2",
				identifier = "player_movement_speed_node_buff_low_2",
			},
		},
		base_movement_speed_node_buff_low_3 = {
			description = "loc_talent_movement_speed_low_desc",
			display_name = "loc_talent_movement_speed_low",
			name = "[dev] movement_speed bonus",
			format_values = {
				movement_speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_movement_speed_node_buff_low_3",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.movement_speed,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_movement_speed_node_buff_low_3",
				identifier = "player_movement_speed_node_buff_low_3",
			},
		},
		base_movement_speed_node_buff_low_4 = {
			description = "loc_talent_movement_speed_low_desc",
			display_name = "loc_talent_movement_speed_low",
			name = "[dev] movement_speed bonus",
			format_values = {
				movement_speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_movement_speed_node_buff_low_4",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.movement_speed,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_movement_speed_node_buff_low_4",
				identifier = "player_movement_speed_node_buff_low_4",
			},
		},
		base_movement_speed_node_buff_low_5 = {
			description = "loc_talent_movement_speed_low_desc",
			display_name = "loc_talent_movement_speed_low",
			name = "[dev] movement_speed bonus",
			format_values = {
				movement_speed = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_movement_speed_node_buff_low_5",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.movement_speed,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_movement_speed_node_buff_low_5",
				identifier = "player_movement_speed_node_buff_low_5",
			},
		},
		base_coherency_regen_node_buff_low_1 = {
			description = "loc_talent_coherency_regen_low_desc",
			display_name = "loc_talent_coherency_regen_low",
			name = "[dev] coherency_regen bonus",
			format_values = {
				coherency_regen = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_coherency_regen_node_buff_low_1",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness_regen_rate_modifier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_coherency_regen_node_buff_low_1",
				identifier = "player_coherency_regen_node_buff_low_1",
			},
		},
		base_coherency_regen_node_buff_low_2 = {
			description = "loc_talent_coherency_regen_low_desc",
			display_name = "loc_talent_coherency_regen_low",
			name = "[dev] coherency_regen bonus",
			format_values = {
				coherency_regen = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_coherency_regen_node_buff_low_2",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness_regen_rate_modifier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_coherency_regen_node_buff_low_2",
				identifier = "player_coherency_regen_node_buff_low_2",
			},
		},
		base_coherency_regen_node_buff_low_3 = {
			description = "loc_talent_coherency_regen_low_desc",
			display_name = "loc_talent_coherency_regen_low",
			name = "[dev] coherency_regen bonus",
			format_values = {
				coherency_regen = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_coherency_regen_node_buff_low_3",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness_regen_rate_modifier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_coherency_regen_node_buff_low_3",
				identifier = "player_coherency_regen_node_buff_low_3",
			},
		},
		base_coherency_regen_node_buff_low_4 = {
			description = "loc_talent_coherency_regen_low_desc",
			display_name = "loc_talent_coherency_regen_low",
			name = "[dev] coherency_regen bonus",
			format_values = {
				coherency_regen = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_coherency_regen_node_buff_low_4",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness_regen_rate_modifier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_coherency_regen_node_buff_low_4",
				identifier = "player_coherency_regen_node_buff_low_4",
			},
		},
		base_coherency_regen_node_buff_low_5 = {
			description = "loc_talent_coherency_regen_low_desc",
			display_name = "loc_talent_coherency_regen_low",
			name = "[dev] coherency_regen bonus",
			format_values = {
				coherency_regen = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_coherency_regen_node_buff_low_5",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.toughness_regen_rate_modifier,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_coherency_regen_node_buff_low_5",
				identifier = "player_coherency_regen_node_buff_low_5",
			},
		},
		base_warp_charge_node_buff_low_1 = {
			description = "loc_talent_warp_charge_low_desc",
			display_name = "loc_talent_warp_charge_low",
			name = "[dev] warp_charge bonus",
			format_values = {
				warp_charge = {
					format_type = "percentage",
					prefix = "-",
					find_value = {
						buff_template_name = "player_warp_charge_node_buff_low_1",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.warp_charge_amount,
						},
					},
					value_manipulation = function (value)
						return (1 - value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "player_warp_charge_node_buff_low_1",
				identifier = "player_warp_charge_node_buff_low_1",
			},
		},
		base_warp_charge_node_buff_low_2 = {
			description = "loc_talent_warp_charge_low_desc",
			display_name = "loc_talent_warp_charge_low",
			name = "[dev] warp_charge bonus",
			format_values = {
				warp_charge = {
					format_type = "percentage",
					prefix = "-",
					find_value = {
						buff_template_name = "player_warp_charge_node_buff_low_2",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.warp_charge_amount,
						},
					},
					value_manipulation = function (value)
						return (1 - value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "player_warp_charge_node_buff_low_2",
				identifier = "player_warp_charge_node_buff_low_2",
			},
		},
		base_warp_charge_node_buff_low_3 = {
			description = "loc_talent_warp_charge_low_desc",
			display_name = "loc_talent_warp_charge_low",
			name = "[dev] warp_charge bonus",
			format_values = {
				warp_charge = {
					format_type = "percentage",
					prefix = "-",
					find_value = {
						buff_template_name = "player_warp_charge_node_buff_low_3",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.warp_charge_amount,
						},
					},
					value_manipulation = function (value)
						return (1 - value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "player_warp_charge_node_buff_low_3",
				identifier = "player_warp_charge_node_buff_low_3",
			},
		},
		base_warp_charge_node_buff_low_4 = {
			description = "loc_talent_warp_charge_low_desc",
			display_name = "loc_talent_warp_charge_low",
			name = "[dev] warp_charge bonus",
			format_values = {
				warp_charge = {
					format_type = "percentage",
					prefix = "-",
					find_value = {
						buff_template_name = "player_warp_charge_node_buff_low_4",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.warp_charge_amount,
						},
					},
					value_manipulation = function (value)
						return (1 - value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "player_warp_charge_node_buff_low_4",
				identifier = "player_warp_charge_node_buff_low_4",
			},
		},
		base_warp_charge_node_buff_low_5 = {
			description = "loc_talent_warp_charge_low_desc",
			display_name = "loc_talent_warp_charge_low",
			name = "[dev] warp_charge bonus",
			format_values = {
				warp_charge = {
					format_type = "percentage",
					prefix = "-",
					find_value = {
						buff_template_name = "player_warp_charge_node_buff_low_5",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.warp_charge_amount,
						},
					},
					value_manipulation = function (value)
						return (1 - value) * 100
					end,
				},
			},
			passive = {
				buff_template_name = "player_warp_charge_node_buff_low_5",
				identifier = "player_warp_charge_node_buff_low_5",
			},
		},
		base_wounds_node_buff_1 = {
			description = "",
			display_name = "",
			name = "",
			passive = {
				buff_template_name = "player_wounds_node_buff_1",
				identifier = "base_wounds_node_buff",
			},
		},
		base_wounds_node_buff_2 = {
			description = "",
			display_name = "",
			name = "",
			passive = {
				buff_template_name = "player_wounds_node_buff_2",
				identifier = "base_wounds_node_buff",
			},
		},
		base_max_warp_charge_node_buff_1 = {
			description = "",
			display_name = "",
			name = "",
			passive = {
				buff_template_name = "player_max_warp_charge_node_buff_1",
				identifier = "base_max_warp_charge_node_buff",
			},
		},
		base_max_warp_charge_node_buff_2 = {
			description = "",
			display_name = "",
			name = "",
			passive = {
				buff_template_name = "player_max_warp_charge_node_buff_2",
				identifier = "base_max_warp_charge_node_buff",
			},
		},
		base_dodge_count_node_buff_1 = {
			description = "",
			display_name = "",
			name = "",
			passive = {
				buff_template_name = "player_dodge_count_node_buff_1",
				identifier = "base_dodge_count_node_buff",
			},
		},
		base_dodge_count_node_buff_2 = {
			description = "",
			display_name = "",
			name = "",
			passive = {
				buff_template_name = "player_dodge_count_node_buff_2",
				identifier = "base_dodge_count_node_buff",
			},
		},
		base_max_ammo_node_buff_1 = {
			description = "loc_talent_max_ammo_low_desc",
			display_name = "loc_talent_max_ammo_low",
			name = "",
			format_values = {
				ammo = {
					format_type = "percentage",
					prefix = "+",
					find_value = {
						buff_template_name = "player_max_ammo_node_buff_1",
						find_value_type = "buff_template",
						tier = true,
						path = {
							"stat_buffs",
							stat_buffs.ammo_reserve_capacity,
						},
					},
				},
			},
			passive = {
				buff_template_name = "player_max_ammo_node_buff_1",
				identifier = "base_max_ammo_node_buff",
			},
		},
		base_max_ammo_node_buff_2 = {
			description = "loc_talent_max_ammo_low_desc",
			display_name = "loc_talent_max_ammo_low",
			name = "",
			passive = {
				buff_template_name = "player_max_ammo_node_buff_2",
				identifier = "base_max_ammo_node_buff",
			},
		},
		base_coherency_regen_node_buff_1 = {
			description = "",
			display_name = "",
			name = "",
			passive = {
				buff_template_name = "player_coherency_regen_node_buff_1",
				identifier = "coherency_regen_node_buff",
			},
		},
		base_coherency_regen_node_buff_2 = {
			description = "",
			display_name = "",
			name = "",
			passive = {
				buff_template_name = "player_coherency_regen_node_buff_2",
				identifier = "coherency_regen_node_buff",
			},
		},
	},
}

return base_talents
