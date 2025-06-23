-- chunkname: @scripts/settings/ability/archetype_talents/talents/base_talents.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local stat_buffs = BuffSettings.stat_buffs
local base_talents = {
	archetype = "none",
	talents = {
		base_stamina_regen_delay_1 = {
			description = "loc_talent_stamina_regen_delay_desc",
			name = "Reduced Stamina Regeneration Delay by 0.25s",
			display_name = "loc_talent_stamina_regen_delay",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_3_2",
			format_values = {
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "reduced_stamina_regen_delay_1",
						prefix = "+",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.stamina_regeneration_delay
						}
					},
					value_manipulation = function (value)
						return math.abs(value)
					end
				}
			},
			passive = {
				buff_template_name = "reduced_stamina_regen_delay_1",
				identifier = "reduced_stamina_regen_delay_1"
			}
		},
		base_stamina_regen_delay_2 = {
			description = "loc_talent_stamina_regen_delay_desc",
			name = "Reduced Stamina Regeneration Delay by 0.25s",
			display_name = "loc_talent_stamina_regen_delay",
			icon = "content/ui/textures/icons/talents/veteran_2/veteran_2_tier_3_2",
			format_values = {
				duration = {
					format_type = "number",
					find_value = {
						buff_template_name = "reduced_stamina_regen_delay_2",
						prefix = "+",
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.stamina_regeneration_delay
						}
					},
					value_manipulation = function (value)
						return math.abs(value)
					end
				}
			},
			passive = {
				buff_template_name = "reduced_stamina_regen_delay_2",
				identifier = "reduced_stamina_regen_delay_2"
			}
		},
		base_toughness_node_buff_low_1 = {
			description = "loc_talent_toughness_boost_low_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_toughness_boost_low",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "number",
					find_value = {
						buff_template_name = "player_toughness_node_buff_low_1",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_toughness_node_buff_low_1",
				identifier = "player_toughness_node_buff_low_1"
			}
		},
		base_toughness_node_buff_low_2 = {
			description = "loc_talent_toughness_boost_low_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_toughness_boost_low",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "number",
					find_value = {
						buff_template_name = "player_toughness_node_buff_low_2",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_toughness_node_buff_low_2",
				identifier = "player_toughness_node_buff_low_2"
			}
		},
		base_toughness_node_buff_low_3 = {
			description = "loc_talent_toughness_boost_low_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_toughness_boost_low",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "number",
					find_value = {
						buff_template_name = "player_toughness_node_buff_low_3",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_toughness_node_buff_low_3",
				identifier = "player_toughness_node_buff_low_3"
			}
		},
		base_toughness_node_buff_low_4 = {
			description = "loc_talent_toughness_boost_low_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_toughness_boost_low",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "number",
					find_value = {
						buff_template_name = "player_toughness_node_buff_low_4",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_toughness_node_buff_low_4",
				identifier = "player_toughness_node_buff_low_4"
			}
		},
		base_toughness_node_buff_low_5 = {
			description = "loc_talent_toughness_boost_low_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_toughness_boost_low",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "number",
					find_value = {
						buff_template_name = "player_toughness_node_buff_low_5",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_toughness_node_buff_low_5",
				identifier = "player_toughness_node_buff_low_5"
			}
		},
		base_toughness_node_buff_medium_1 = {
			description = "loc_talent_toughness_boost_medium_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_toughness_boost_medium",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "number",
					find_value = {
						buff_template_name = "player_toughness_node_buff_medium_1",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_toughness_node_buff_medium_1",
				identifier = "player_toughness_node_buff_medium_1"
			}
		},
		base_toughness_node_buff_medium_2 = {
			description = "loc_talent_toughness_boost_medium_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_toughness_boost_medium",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "number",
					find_value = {
						buff_template_name = "player_toughness_node_buff_medium_2",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_toughness_node_buff_medium_2",
				identifier = "player_toughness_node_buff_medium_2"
			}
		},
		base_toughness_node_buff_medium_3 = {
			description = "loc_talent_toughness_boost_medium_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_toughness_boost_medium",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "number",
					find_value = {
						buff_template_name = "player_toughness_node_buff_medium_3",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_toughness_node_buff_medium_3",
				identifier = "player_toughness_node_buff_medium_3"
			}
		},
		base_toughness_node_buff_medium_4 = {
			description = "loc_talent_toughness_boost_medium_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_toughness_boost_medium",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "number",
					find_value = {
						buff_template_name = "player_toughness_node_buff_medium_4",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_toughness_node_buff_medium_4",
				identifier = "player_toughness_node_buff_medium_4"
			}
		},
		base_toughness_node_buff_medium_5 = {
			description = "loc_talent_toughness_boost_medium_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_toughness_boost_medium",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "number",
					find_value = {
						buff_template_name = "player_toughness_node_buff_medium_5",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_toughness_node_buff_medium_5",
				identifier = "player_toughness_node_buff_medium_5"
			}
		},
		base_toughness_damage_reduction_node_buff_low_1 = {
			description = "loc_talent_toughness_damage_reduction_low_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_toughness_damage_reduction_low",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_toughness_damage_reduction_node_buff_low_1",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "player_toughness_damage_reduction_node_buff_low_1",
				identifier = "player_toughness_damage_reduction_node_buff_low_1"
			}
		},
		base_toughness_damage_reduction_node_buff_low_2 = {
			description = "loc_talent_toughness_damage_reduction_low_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_toughness_damage_reduction_low",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_toughness_damage_reduction_node_buff_low_2",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "player_toughness_damage_reduction_node_buff_low_2",
				identifier = "player_toughness_damage_reduction_node_buff_low_2"
			}
		},
		base_toughness_damage_reduction_node_buff_low_3 = {
			description = "loc_talent_toughness_damage_reduction_low_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_toughness_damage_reduction_low",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_toughness_damage_reduction_node_buff_low_3",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "player_toughness_damage_reduction_node_buff_low_3",
				identifier = "player_toughness_damage_reduction_node_buff_low_3"
			}
		},
		base_toughness_damage_reduction_node_buff_low_4 = {
			description = "loc_talent_toughness_damage_reduction_low_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_toughness_damage_reduction_low",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_toughness_damage_reduction_node_buff_low_4",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "player_toughness_damage_reduction_node_buff_low_4",
				identifier = "player_toughness_damage_reduction_node_buff_low_4"
			}
		},
		base_toughness_damage_reduction_node_buff_low_5 = {
			description = "loc_talent_toughness_damage_reduction_low_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_toughness_damage_reduction_low",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_toughness_damage_reduction_node_buff_low_5",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "player_toughness_damage_reduction_node_buff_low_5",
				identifier = "player_toughness_damage_reduction_node_buff_low_5"
			}
		},
		base_toughness_damage_reduction_node_buff_medium_1 = {
			description = "loc_talent_toughness_damage_reduction_medium_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_toughness_damage_reduction_medium",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_toughness_damage_reduction_node_buff_medium_1",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "player_toughness_damage_reduction_node_buff_medium_1",
				identifier = "player_toughness_damage_reduction_node_buff_medium_1"
			}
		},
		base_toughness_damage_reduction_node_buff_medium_2 = {
			description = "loc_talent_toughness_damage_reduction_medium_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_toughness_damage_reduction_medium",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_toughness_damage_reduction_node_buff_medium_2",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "player_toughness_damage_reduction_node_buff_medium_2",
				identifier = "player_toughness_damage_reduction_node_buff_medium_2"
			}
		},
		base_toughness_damage_reduction_node_buff_medium_3 = {
			description = "loc_talent_toughness_damage_reduction_medium_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_toughness_damage_reduction_medium",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_toughness_damage_reduction_node_buff_medium_3",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "player_toughness_damage_reduction_node_buff_medium_3",
				identifier = "player_toughness_damage_reduction_node_buff_medium_3"
			}
		},
		base_toughness_damage_reduction_node_buff_medium_4 = {
			description = "loc_talent_toughness_damage_reduction_medium_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_toughness_damage_reduction_medium",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_toughness_damage_reduction_node_buff_medium_4",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "player_toughness_damage_reduction_node_buff_medium_4",
				identifier = "player_toughness_damage_reduction_node_buff_medium_4"
			}
		},
		base_toughness_damage_reduction_node_buff_medium_5 = {
			description = "loc_talent_toughness_damage_reduction_medium_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_toughness_damage_reduction_medium",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_toughness_damage_reduction_node_buff_medium_5",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "player_toughness_damage_reduction_node_buff_medium_5",
				identifier = "player_toughness_damage_reduction_node_buff_medium_5"
			}
		},
		base_ranged_toughness_damage_reduction_node_buff_medium_1 = {
			description = "loc_talent_ranged_toughness_damage_reduction_medium_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_ranged_toughness_damage_reduction_medium",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_ranged_toughness_damage_reduction_node_buff_medium_1",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ranged_toughness_damage_taken_modifier
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "player_ranged_toughness_damage_reduction_node_buff_medium_1",
				identifier = "player_ranged_toughness_damage_reduction_node_buff_medium_1"
			}
		},
		base_ranged_toughness_damage_reduction_node_buff_medium_2 = {
			description = "loc_talent_ranged_toughness_damage_reduction_medium_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_ranged_toughness_damage_reduction_medium",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_ranged_toughness_damage_reduction_node_buff_medium_2",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ranged_toughness_damage_taken_modifier
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "player_ranged_toughness_damage_reduction_node_buff_medium_2",
				identifier = "player_ranged_toughness_damage_reduction_node_buff_medium_2"
			}
		},
		base_ranged_toughness_damage_reduction_node_buff_medium_3 = {
			description = "loc_talent_ranged_toughness_damage_reduction_medium_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_ranged_toughness_damage_reduction_medium",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_ranged_toughness_damage_reduction_node_buff_medium_3",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ranged_toughness_damage_taken_modifier
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "player_ranged_toughness_damage_reduction_node_buff_medium_3",
				identifier = "player_ranged_toughness_damage_reduction_node_buff_medium_3"
			}
		},
		base_ranged_toughness_damage_reduction_node_buff_medium_4 = {
			description = "loc_talent_ranged_toughness_damage_reduction_medium_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_ranged_toughness_damage_reduction_medium",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_ranged_toughness_damage_reduction_node_buff_medium_4",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ranged_toughness_damage_taken_modifier
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "player_ranged_toughness_damage_reduction_node_buff_medium_4",
				identifier = "player_ranged_toughness_damage_reduction_node_buff_medium_4"
			}
		},
		base_ranged_toughness_damage_reduction_node_buff_medium_5 = {
			description = "loc_talent_ranged_toughness_damage_reduction_medium_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_ranged_toughness_damage_reduction_medium",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_ranged_toughness_damage_reduction_node_buff_medium_5",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ranged_toughness_damage_taken_modifier
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "player_toughness_damage_reduction_node_buff_medium_5",
				identifier = "player_toughness_damage_reduction_node_buff_medium_5"
			}
		},
		base_melee_toughness_damage_reduction_node_buff_medium_1 = {
			description = "loc_talent_melee_toughness_damage_reduction_medium_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_melee_toughness_damage_reduction_medium",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_melee_toughness_damage_reduction_node_buff_medium_1",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "player_melee_toughness_damage_reduction_node_buff_medium_1",
				identifier = "player_melee_toughness_damage_reduction_node_buff_medium_1"
			}
		},
		base_melee_toughness_damage_reduction_node_buff_medium_2 = {
			description = "loc_talent_melee_toughness_damage_reduction_medium_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_melee_toughness_damage_reduction_medium",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_melee_toughness_damage_reduction_node_buff_medium_2",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "player_melee_toughness_damage_reduction_node_buff_medium_2",
				identifier = "player_melee_toughness_damage_reduction_node_buff_medium_2"
			}
		},
		base_melee_toughness_damage_reduction_node_buff_medium_3 = {
			description = "loc_talent_melee_toughness_damage_reduction_medium_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_melee_toughness_damage_reduction_medium",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_melee_toughness_damage_reduction_node_buff_medium_3",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "player_melee_toughness_damage_reduction_node_buff_medium_3",
				identifier = "player_melee_toughness_damage_reduction_node_buff_medium_3"
			}
		},
		base_melee_toughness_damage_reduction_node_buff_medium_4 = {
			description = "loc_talent_melee_toughness_damage_reduction_medium_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_melee_toughness_damage_reduction_medium",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_melee_toughness_damage_reduction_node_buff_medium_4",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "player_melee_toughness_damage_reduction_node_buff_medium_4",
				identifier = "player_melee_toughness_damage_reduction_node_buff_medium_4"
			}
		},
		base_melee_toughness_damage_reduction_node_buff_medium_5 = {
			description = "loc_talent_melee_toughness_damage_reduction_medium_desc",
			name = "[dev] toughness bonus",
			display_name = "loc_talent_melee_toughness_damage_reduction_medium",
			format_values = {
				toughness = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_melee_toughness_damage_reduction_node_buff_medium_5",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_damage_taken_modifier
						}
					},
					value_manipulation = function (value)
						return math.abs(value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "player_toughness_damage_reduction_node_buff_medium_5",
				identifier = "player_toughness_damage_reduction_node_buff_medium_5"
			}
		},
		base_melee_damage_node_buff_low_1 = {
			description = "loc_talent_melee_damage_boost_low_desc",
			name = "[dev] melee_damage bonus",
			display_name = "loc_talent_melee_damage_boost_low",
			format_values = {
				melee_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_melee_damage_node_buff_low_1",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_melee_damage_node_buff_low_1",
				identifier = "player_melee_damage_node_buff_low_1"
			}
		},
		base_melee_damage_node_buff_low_2 = {
			description = "loc_talent_melee_damage_boost_low_desc",
			name = "[dev] melee_damage bonus",
			display_name = "loc_talent_melee_damage_boost_low",
			format_values = {
				melee_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_melee_damage_node_buff_low_2",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_melee_damage_node_buff_low_2",
				identifier = "player_melee_damage_node_buff_low_2"
			}
		},
		base_melee_damage_node_buff_low_3 = {
			description = "loc_talent_melee_damage_boost_low_desc",
			name = "[dev] melee_damage bonus",
			display_name = "loc_talent_melee_damage_boost_low",
			format_values = {
				melee_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_melee_damage_node_buff_low_3",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_melee_damage_node_buff_low_3",
				identifier = "player_melee_damage_node_buff_low_3"
			}
		},
		base_melee_damage_node_buff_low_4 = {
			description = "loc_talent_melee_damage_boost_low_desc",
			name = "[dev] melee_damage bonus",
			display_name = "loc_talent_melee_damage_boost_low",
			format_values = {
				melee_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_melee_damage_node_buff_low_4",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_melee_damage_node_buff_low_4",
				identifier = "player_melee_damage_node_buff_low_4"
			}
		},
		base_melee_damage_node_buff_low_5 = {
			description = "loc_talent_melee_damage_boost_low_desc",
			name = "[dev] melee_damage bonus",
			display_name = "loc_talent_melee_damage_boost_low",
			format_values = {
				melee_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_melee_damage_node_buff_low_5",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_melee_damage_node_buff_low_5",
				identifier = "player_melee_damage_node_buff_low_5"
			}
		},
		base_impact_node_buff_medium_1 = {
			description = "loc_talent_impact_boost_medium_desc",
			name = "[dev] impact bonus",
			display_name = "loc_talent_impact_boost_medium",
			format_values = {
				impact = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_impact_node_buff_medium_1",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.impact_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_impact_node_buff_medium_1",
				identifier = "player_impact_node_buff_medium_1"
			}
		},
		base_cleave_node_buff_medium_1 = {
			description = "loc_talent_cleave_boost_medium_desc",
			name = "[dev] cleave bonus",
			display_name = "loc_talent_cleave_boost_medium",
			format_values = {
				cleave = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_cleave_node_buff_medium_1",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.max_hit_mass_attack_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_cleave_node_buff_medium_1",
				identifier = "player_cleave_node_buff_medium_1"
			}
		},
		base_melee_damage_node_buff_medium_1 = {
			description = "loc_talent_melee_damage_boost_medium_desc",
			name = "[dev] melee_damage bonus",
			display_name = "loc_talent_melee_damage_boost_medium",
			format_values = {
				melee_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_melee_damage_node_buff_medium_1",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_melee_damage_node_buff_medium_1",
				identifier = "player_melee_damage_node_buff_medium_1"
			}
		},
		base_melee_damage_node_buff_medium_2 = {
			description = "loc_talent_melee_damage_boost_medium_desc",
			name = "[dev] melee_damage bonus",
			display_name = "loc_talent_melee_damage_boost_medium",
			format_values = {
				melee_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_melee_damage_node_buff_medium_2",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_melee_damage_node_buff_medium_2",
				identifier = "player_melee_damage_node_buff_medium_2"
			}
		},
		base_melee_damage_node_buff_medium_3 = {
			description = "loc_talent_melee_damage_boost_medium_desc",
			name = "[dev] melee_damage bonus",
			display_name = "loc_talent_melee_damage_boost_medium",
			format_values = {
				melee_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_melee_damage_node_buff_medium_3",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_melee_damage_node_buff_medium_3",
				identifier = "player_melee_damage_node_buff_medium_3"
			}
		},
		base_melee_damage_node_buff_medium_4 = {
			description = "loc_talent_melee_damage_boost_medium_desc",
			name = "[dev] melee_damage bonus",
			display_name = "loc_talent_melee_damage_boost_medium",
			format_values = {
				melee_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_melee_damage_node_buff_medium_4",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_melee_damage_node_buff_medium_4",
				identifier = "player_melee_damage_node_buff_medium_4"
			}
		},
		base_melee_damage_node_buff_medium_5 = {
			description = "loc_talent_melee_damage_boost_medium_desc",
			name = "[dev] melee_damage bonus",
			display_name = "loc_talent_melee_damage_boost_medium",
			format_values = {
				melee_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_melee_damage_node_buff_medium_5",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_melee_damage_node_buff_medium_5",
				identifier = "player_melee_damage_node_buff_medium_5"
			}
		},
		base_melee_heavy_damage_node_buff_low_1 = {
			description = "loc_talent_melee_heavy_damage_low_desc",
			name = "[dev] melee_heavy_damage bonus",
			display_name = "loc_talent_melee_heavy_damage_low",
			format_values = {
				melee_heavy_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_melee_heavy_damage_node_buff_low_1",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_heavy_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_melee_heavy_damage_node_buff_low_1",
				identifier = "player_melee_heavy_damage_node_buff_low_1"
			}
		},
		base_melee_heavy_damage_node_buff_low_2 = {
			description = "loc_talent_melee_heavy_damage_low_desc",
			name = "[dev] melee_heavy_damage bonus",
			display_name = "loc_talent_melee_heavy_damage_low",
			format_values = {
				melee_heavy_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_melee_heavy_damage_node_buff_low_2",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_heavy_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_melee_heavy_damage_node_buff_low_2",
				identifier = "player_melee_heavy_damage_node_buff_low_2"
			}
		},
		base_melee_heavy_damage_node_buff_low_3 = {
			description = "loc_talent_melee_heavy_damage_low_desc",
			name = "[dev] melee_heavy_damage bonus",
			display_name = "loc_talent_melee_heavy_damage_low",
			format_values = {
				melee_heavy_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_melee_heavy_damage_node_buff_low_3",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_heavy_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_melee_heavy_damage_node_buff_low_3",
				identifier = "player_melee_heavy_damage_node_buff_low_3"
			}
		},
		base_melee_heavy_damage_node_buff_low_4 = {
			description = "loc_talent_melee_heavy_damage_low_desc",
			name = "[dev] melee_heavy_damage bonus",
			display_name = "loc_talent_melee_heavy_damage_low",
			format_values = {
				melee_heavy_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_melee_heavy_damage_node_buff_low_4",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_heavy_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_melee_heavy_damage_node_buff_low_4",
				identifier = "player_melee_heavy_damage_node_buff_low_4"
			}
		},
		base_melee_heavy_damage_node_buff_low_5 = {
			description = "loc_talent_melee_heavy_damage_low_desc",
			name = "[dev] melee_heavy_damage bonus",
			display_name = "loc_talent_melee_heavy_damage_low",
			format_values = {
				melee_heavy_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_melee_heavy_damage_node_buff_low_5",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_heavy_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_melee_heavy_damage_node_buff_low_5",
				identifier = "player_melee_heavy_damage_node_buff_low_5"
			}
		},
		base_melee_heavy_damage_node_buff_medium_1 = {
			description = "loc_talent_melee_heavy_damage_medium_desc",
			name = "[dev] melee_heavy_damage bonus",
			display_name = "loc_talent_melee_heavy_damage_medium",
			format_values = {
				melee_heavy_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_melee_heavy_damage_node_buff_medium_1",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_heavy_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_melee_heavy_damage_node_buff_medium_1",
				identifier = "player_melee_heavy_damage_node_buff_medium_1"
			}
		},
		base_melee_heavy_damage_node_buff_medium_2 = {
			description = "loc_talent_melee_heavy_damage_medium_desc",
			name = "[dev] melee_heavy_damage bonus",
			display_name = "loc_talent_melee_heavy_damage_medium",
			format_values = {
				melee_heavy_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_melee_heavy_damage_node_buff_medium_2",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_heavy_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_melee_heavy_damage_node_buff_medium_2",
				identifier = "player_melee_heavy_damage_node_buff_medium_2"
			}
		},
		base_melee_heavy_damage_node_buff_medium_3 = {
			description = "loc_talent_melee_heavy_damage_medium_desc",
			name = "[dev] melee_heavy_damage bonus",
			display_name = "loc_talent_melee_heavy_damage_medium",
			format_values = {
				melee_heavy_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_melee_heavy_damage_node_buff_medium_3",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_heavy_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_melee_heavy_damage_node_buff_medium_3",
				identifier = "player_melee_heavy_damage_node_buff_medium_3"
			}
		},
		base_melee_heavy_damage_node_buff_medium_4 = {
			description = "loc_talent_melee_heavy_damage_medium_desc",
			name = "[dev] melee_heavy_damage bonus",
			display_name = "loc_talent_melee_heavy_damage_medium",
			format_values = {
				melee_heavy_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_melee_heavy_damage_node_buff_medium_4",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_heavy_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_melee_heavy_damage_node_buff_medium_4",
				identifier = "player_melee_heavy_damage_node_buff_medium_4"
			}
		},
		base_melee_heavy_damage_node_buff_medium_5 = {
			description = "loc_talent_melee_heavy_damage_medium_desc",
			name = "[dev] melee_heavy_damage bonus",
			display_name = "loc_talent_melee_heavy_damage_medium",
			format_values = {
				melee_heavy_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_melee_heavy_damage_node_buff_medium_5",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.melee_heavy_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_melee_heavy_damage_node_buff_medium_5",
				identifier = "player_melee_heavy_damage_node_buff_medium_5"
			}
		},
		base_ranged_damage_node_buff_low_1 = {
			description = "loc_talent_ranged_damage_low_desc",
			name = "[dev] ranged_damage bonus",
			display_name = "loc_talent_ranged_damage_low",
			format_values = {
				ranged_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_ranged_damage_node_buff_low_1",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ranged_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_ranged_damage_node_buff_low_1",
				identifier = "player_ranged_damage_node_buff_low_1"
			}
		},
		base_ranged_damage_node_buff_low_2 = {
			description = "loc_talent_ranged_damage_low_desc",
			name = "[dev] ranged_damage bonus",
			display_name = "loc_talent_ranged_damage_low",
			format_values = {
				ranged_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_ranged_damage_node_buff_low_2",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ranged_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_ranged_damage_node_buff_low_2",
				identifier = "player_ranged_damage_node_buff_low_2"
			}
		},
		base_ranged_damage_node_buff_low_3 = {
			description = "loc_talent_ranged_damage_low_desc",
			name = "[dev] ranged_damage bonus",
			display_name = "loc_talent_ranged_damage_low",
			format_values = {
				ranged_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_ranged_damage_node_buff_low_3",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ranged_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_ranged_damage_node_buff_low_3",
				identifier = "player_ranged_damage_node_buff_low_3"
			}
		},
		base_ranged_damage_node_buff_low_4 = {
			description = "loc_talent_ranged_damage_low_desc",
			name = "[dev] ranged_damage bonus",
			display_name = "loc_talent_ranged_damage_low",
			format_values = {
				ranged_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_ranged_damage_node_buff_low_4",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ranged_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_ranged_damage_node_buff_low_4",
				identifier = "player_ranged_damage_node_buff_low_4"
			}
		},
		base_ranged_damage_node_buff_low_5 = {
			description = "loc_talent_ranged_damage_low_desc",
			name = "[dev] ranged_damage bonus",
			display_name = "loc_talent_ranged_damage_low",
			format_values = {
				ranged_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_ranged_damage_node_buff_low_5",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ranged_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_ranged_damage_node_buff_low_5",
				identifier = "player_ranged_damage_node_buff_low_5"
			}
		},
		base_ranged_damage_node_buff_medium_1 = {
			description = "loc_talent_ranged_damage_medium_desc",
			name = "[dev] ranged_damage bonus",
			display_name = "loc_talent_ranged_damage_medium",
			format_values = {
				ranged_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_ranged_damage_node_buff_medium_1",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ranged_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_ranged_damage_node_buff_medium_1",
				identifier = "player_ranged_damage_node_buff_medium_1"
			}
		},
		base_ranged_damage_node_buff_medium_2 = {
			description = "loc_talent_ranged_damage_medium_desc",
			name = "[dev] ranged_damage bonus",
			display_name = "loc_talent_ranged_damage_medium",
			format_values = {
				ranged_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_ranged_damage_node_buff_medium_2",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ranged_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_ranged_damage_node_buff_medium_2",
				identifier = "player_ranged_damage_node_buff_medium_2"
			}
		},
		base_ranged_damage_node_buff_medium_3 = {
			description = "loc_talent_ranged_damage_medium_desc",
			name = "[dev] ranged_damage bonus",
			display_name = "loc_talent_ranged_damage_medium",
			format_values = {
				ranged_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_ranged_damage_node_buff_medium_3",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ranged_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_ranged_damage_node_buff_medium_3",
				identifier = "player_ranged_damage_node_buff_medium_3"
			}
		},
		base_ranged_damage_node_buff_medium_4 = {
			description = "loc_talent_ranged_damage_medium_desc",
			name = "[dev] ranged_damage bonus",
			display_name = "loc_talent_ranged_damage_medium",
			format_values = {
				ranged_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_ranged_damage_node_buff_medium_4",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ranged_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_ranged_damage_node_buff_medium_4",
				identifier = "player_ranged_damage_node_buff_medium_4"
			}
		},
		base_ranged_damage_node_buff_medium_5 = {
			description = "loc_talent_ranged_damage_medium_desc",
			name = "[dev] ranged_damage bonus",
			display_name = "loc_talent_ranged_damage_medium",
			format_values = {
				ranged_damage = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_ranged_damage_node_buff_medium_5",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ranged_damage
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_ranged_damage_node_buff_medium_5",
				identifier = "player_ranged_damage_node_buff_medium_5"
			}
		},
		base_armor_pen_node_buff_low_1 = {
			description = "loc_talent_armor_pen_low_desc",
			name = "[dev] armor_pen bonus",
			display_name = "loc_talent_armor_pen_low",
			format_values = {
				rending = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_armor_pen_node_buff_low_1",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.rending_multiplier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_armor_pen_node_buff_low_1",
				identifier = "player_armor_pen_node_buff_low_1"
			}
		},
		base_armor_pen_node_buff_low_2 = {
			description = "loc_talent_armor_pen_low_desc",
			name = "[dev] armor_pen bonus",
			display_name = "loc_talent_armor_pen_low",
			format_values = {
				rending = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_armor_pen_node_buff_low_2",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.rending_multiplier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_armor_pen_node_buff_low_2",
				identifier = "player_armor_pen_node_buff_low_2"
			}
		},
		base_armor_pen_node_buff_low_3 = {
			description = "loc_talent_armor_pen_low_desc",
			name = "[dev] armor_pen bonus",
			display_name = "loc_talent_armor_pen_low",
			format_values = {
				rending = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_armor_pen_node_buff_low_3",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.rending_multiplier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_armor_pen_node_buff_low_3",
				identifier = "player_armor_pen_node_buff_low_3"
			}
		},
		base_armor_pen_node_buff_low_4 = {
			description = "loc_talent_armor_pen_low_desc",
			name = "[dev] armor_pen bonus",
			display_name = "loc_talent_armor_pen_low",
			format_values = {
				rending = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_armor_pen_node_buff_low_4",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.rending_multiplier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_armor_pen_node_buff_low_4",
				identifier = "player_armor_pen_node_buff_low_4"
			}
		},
		base_armor_pen_node_buff_low_5 = {
			description = "loc_talent_armor_pen_low_desc",
			name = "[dev] armor_pen bonus",
			display_name = "loc_talent_armor_pen_low",
			format_values = {
				rending = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_armor_pen_node_buff_low_5",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.rending_multiplier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_armor_pen_node_buff_low_5",
				identifier = "player_armor_pen_node_buff_low_5"
			}
		},
		base_reload_speed_node_buff_low_1 = {
			description = "loc_talent_reload_speed_low_desc",
			name = "[dev] reload_speed bonus",
			display_name = "loc_talent_reload_speed_low",
			format_values = {
				reload_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_reload_speed_node_buff_low_1",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.reload_speed
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_reload_speed_node_buff_low_1",
				identifier = "player_reload_speed_node_buff_low_1"
			}
		},
		base_reload_speed_node_buff_low_2 = {
			description = "loc_talent_reload_speed_low_desc",
			name = "[dev] reload_speed bonus",
			display_name = "loc_talent_reload_speed_low",
			format_values = {
				reload_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_reload_speed_node_buff_low_2",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.reload_speed
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_reload_speed_node_buff_low_2",
				identifier = "player_reload_speed_node_buff_low_2"
			}
		},
		base_reload_speed_node_buff_low_3 = {
			description = "loc_talent_reload_speed_low_desc",
			name = "[dev] reload_speed bonus",
			display_name = "loc_talent_reload_speed_low",
			format_values = {
				reload_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_reload_speed_node_buff_low_3",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.reload_speed
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_reload_speed_node_buff_low_3",
				identifier = "player_reload_speed_node_buff_low_3"
			}
		},
		base_reload_speed_node_buff_low_4 = {
			description = "loc_talent_reload_speed_low_desc",
			name = "[dev] reload_speed bonus",
			display_name = "loc_talent_reload_speed_low",
			format_values = {
				reload_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_reload_speed_node_buff_low_4",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.reload_speed
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_reload_speed_node_buff_low_4",
				identifier = "player_reload_speed_node_buff_low_4"
			}
		},
		base_reload_speed_node_buff_low_5 = {
			description = "loc_talent_reload_speed_low_desc",
			name = "[dev] reload_speed bonus",
			display_name = "loc_talent_reload_speed_low",
			format_values = {
				reload_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_reload_speed_node_buff_low_5",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.reload_speed
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_reload_speed_node_buff_low_5",
				identifier = "player_reload_speed_node_buff_low_5"
			}
		},
		base_reload_speed_node_buff_medium_1 = {
			description = "loc_talent_reload_speed_medium_desc",
			name = "[dev] reload_speed bonus",
			display_name = "loc_talent_reload_speed_medium",
			format_values = {
				reload_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_reload_speed_node_buff_medium_1",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.reload_speed
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_reload_speed_node_buff_medium_1",
				identifier = "player_reload_speed_node_buff_medium_1"
			}
		},
		base_reload_speed_node_buff_medium_2 = {
			description = "loc_talent_reload_speed_medium_desc",
			name = "[dev] reload_speed bonus",
			display_name = "loc_talent_reload_speed_medium",
			format_values = {
				reload_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_reload_speed_node_buff_medium_2",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.reload_speed
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_reload_speed_node_buff_medium_2",
				identifier = "player_reload_speed_node_buff_medium_2"
			}
		},
		base_reload_speed_node_buff_medium_3 = {
			description = "loc_talent_reload_speed_medium_desc",
			name = "[dev] reload_speed bonus",
			display_name = "loc_talent_reload_speed_medium",
			format_values = {
				reload_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_reload_speed_node_buff_medium_3",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.reload_speed
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_reload_speed_node_buff_medium_3",
				identifier = "player_reload_speed_node_buff_medium_3"
			}
		},
		base_reload_speed_node_buff_medium_4 = {
			description = "loc_talent_reload_speed_medium_desc",
			name = "[dev] reload_speed bonus",
			display_name = "loc_talent_reload_speed_medium",
			format_values = {
				reload_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_reload_speed_node_buff_medium_4",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.reload_speed
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_reload_speed_node_buff_medium_4",
				identifier = "player_reload_speed_node_buff_medium_4"
			}
		},
		base_reload_speed_node_buff_medium_5 = {
			description = "loc_talent_reload_speed_medium_desc",
			name = "[dev] reload_speed bonus",
			display_name = "loc_talent_reload_speed_medium",
			format_values = {
				reload_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_reload_speed_node_buff_medium_5",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.reload_speed
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_ranged_damage_node_buff_medium_5",
				identifier = "player_ranged_damage_node_buff_medium_5"
			}
		},
		base_suppression_node_buff_low_1 = {
			description = "loc_talent_suppression_low_desc",
			name = "[dev] suppression bonus",
			display_name = "loc_talent_suppression_low",
			format_values = {
				suppression = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_suppression_node_buff_low_1",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.suppression_dealt
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_suppression_node_buff_low_1",
				identifier = "player_suppression_node_buff_low_1"
			}
		},
		base_suppression_node_buff_low_2 = {
			description = "loc_talent_suppression_low_desc",
			name = "[dev] suppression bonus",
			display_name = "loc_talent_suppression_low",
			format_values = {
				suppression = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_suppression_node_buff_low_2",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.suppression_dealt
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_suppression_node_buff_low_2",
				identifier = "player_suppression_node_buff_low_2"
			}
		},
		base_suppression_node_buff_low_3 = {
			description = "loc_talent_suppression_low_desc",
			name = "[dev] suppression bonus",
			display_name = "loc_talent_suppression_low",
			format_values = {
				suppression = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_suppression_node_buff_low_3",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.suppression_dealt
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_suppression_node_buff_low_3",
				identifier = "player_suppression_node_buff_low_3"
			}
		},
		base_suppression_node_buff_low_4 = {
			description = "loc_talent_suppression_low_desc",
			name = "[dev] suppression bonus",
			display_name = "loc_talent_suppression_low",
			format_values = {
				suppression = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_suppression_node_buff_low_4",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.suppression_dealt
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_suppression_node_buff_low_4",
				identifier = "player_suppression_node_buff_low_4"
			}
		},
		base_suppression_node_buff_low_5 = {
			description = "loc_talent_suppression_low_desc",
			name = "[dev] suppression bonus",
			display_name = "loc_talent_suppression_low",
			format_values = {
				suppression = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_suppression_node_buff_low_5",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.suppression_dealt
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_suppression_node_buff_low_5",
				identifier = "player_suppression_node_buff_low_5"
			}
		},
		base_stamina_node_buff_low_1 = {
			description = "loc_talent_stamina_low_desc",
			name = "[dev] stamina bonus",
			display_name = "loc_talent_stamina_low",
			format_values = {
				stamina = {
					prefix = "+",
					format_type = "number",
					find_value = {
						buff_template_name = "player_stamina_node_buff_low_1",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.stamina_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_stamina_node_buff_low_1",
				identifier = "player_stamina_node_buff_low_1"
			}
		},
		base_stamina_node_buff_low_2 = {
			description = "loc_talent_stamina_low_desc",
			name = "[dev] stamina bonus",
			display_name = "loc_talent_stamina_low",
			format_values = {
				stamina = {
					prefix = "+",
					format_type = "number",
					find_value = {
						buff_template_name = "player_stamina_node_buff_low_2",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.stamina_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_stamina_node_buff_low_2",
				identifier = "player_stamina_node_buff_low_2"
			}
		},
		base_stamina_node_buff_low_3 = {
			description = "loc_talent_stamina_low_desc",
			name = "[dev] stamina bonus",
			display_name = "loc_talent_stamina_low",
			format_values = {
				stamina = {
					prefix = "+",
					format_type = "number",
					find_value = {
						buff_template_name = "player_stamina_node_buff_low_3",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.stamina_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_stamina_node_buff_low_3",
				identifier = "player_stamina_node_buff_low_3"
			}
		},
		base_stamina_node_buff_low_4 = {
			description = "loc_talent_stamina_low_desc",
			name = "[dev] stamina bonus",
			display_name = "loc_talent_stamina_low",
			format_values = {
				stamina = {
					prefix = "+",
					format_type = "number",
					find_value = {
						buff_template_name = "player_stamina_node_buff_low_4",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.stamina_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_stamina_node_buff_low_4",
				identifier = "player_stamina_node_buff_low_4"
			}
		},
		base_stamina_node_buff_low_5 = {
			description = "loc_talent_stamina_low_desc",
			name = "[dev] stamina bonus",
			display_name = "loc_talent_stamina_low",
			format_values = {
				stamina = {
					prefix = "+",
					format_type = "number",
					find_value = {
						buff_template_name = "player_stamina_node_buff_low_5",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.stamina_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_stamina_node_buff_low_5",
				identifier = "player_stamina_node_buff_low_5"
			}
		},
		base_health_node_buff_low_1 = {
			description = "loc_talent_health_low_desc",
			name = "[dev] health bonus",
			display_name = "loc_talent_health_low",
			format_values = {
				health = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_health_node_buff_low_1",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.max_health_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_health_node_buff_low_1",
				identifier = "player_health_node_buff_low_1"
			}
		},
		base_health_node_buff_low_2 = {
			description = "loc_talent_health_low_desc",
			name = "[dev] health bonus",
			display_name = "loc_talent_health_low",
			format_values = {
				health = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_health_node_buff_low_2",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.max_health_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_health_node_buff_low_2",
				identifier = "player_health_node_buff_low_2"
			}
		},
		base_health_node_buff_low_3 = {
			description = "loc_talent_health_low_desc",
			name = "[dev] health bonus",
			display_name = "loc_talent_health_low",
			format_values = {
				health = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_health_node_buff_low_3",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.max_health_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_health_node_buff_low_3",
				identifier = "player_health_node_buff_low_3"
			}
		},
		base_health_node_buff_low_4 = {
			description = "loc_talent_health_low_desc",
			name = "[dev] health bonus",
			display_name = "loc_talent_health_low",
			format_values = {
				health = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_health_node_buff_low_4",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.max_health_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_health_node_buff_low_4",
				identifier = "player_health_node_buff_low_4"
			}
		},
		base_health_node_buff_low_5 = {
			description = "loc_talent_health_low_desc",
			name = "[dev] health bonus",
			display_name = "loc_talent_health_low",
			format_values = {
				health = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_health_node_buff_low_5",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.max_health_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_health_node_buff_low_5",
				identifier = "player_health_node_buff_low_5"
			}
		},
		base_health_node_buff_medium_1 = {
			description = "loc_talent_health_medium_desc",
			name = "[dev] health bonus",
			display_name = "loc_talent_health_medium",
			format_values = {
				health = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_health_node_buff_medium_1",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.max_health_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_health_node_buff_medium_1",
				identifier = "player_health_node_buff_medium_1"
			}
		},
		base_health_node_buff_medium_2 = {
			description = "loc_talent_health_medium_desc",
			name = "[dev] health bonus",
			display_name = "loc_talent_health_medium",
			format_values = {
				health = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_health_node_buff_medium_2",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.max_health_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_health_node_buff_medium_2",
				identifier = "player_health_node_buff_medium_2"
			}
		},
		base_health_node_buff_medium_3 = {
			description = "loc_talent_health_medium_desc",
			name = "[dev] health bonus",
			display_name = "loc_talent_health_medium",
			format_values = {
				health = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_health_node_buff_medium_3",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.max_health_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_health_node_buff_medium_3",
				identifier = "player_health_node_buff_medium_3"
			}
		},
		base_health_node_buff_medium_4 = {
			description = "loc_talent_health_medium_desc",
			name = "[dev] health bonus",
			display_name = "loc_talent_health_medium",
			format_values = {
				health = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_health_node_buff_medium_4",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.max_health_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_health_node_buff_medium_4",
				identifier = "player_health_node_buff_medium_4"
			}
		},
		base_health_node_buff_medium_5 = {
			description = "loc_talent_health_medium_desc",
			name = "[dev] health bonus",
			display_name = "loc_talent_health_medium",
			format_values = {
				health = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_health_node_buff_medium_5",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.max_health_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_health_node_buff_medium_5",
				identifier = "player_health_node_buff_medium_5"
			}
		},
		base_crit_chance_node_buff_low_1 = {
			description = "loc_talent_crit_chance_low_desc",
			name = "[dev] crit_chance bonus",
			display_name = "loc_talent_crit_chance_low",
			format_values = {
				crit_chance = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_crit_chance_node_buff_low_1",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.critical_strike_chance
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_crit_chance_node_buff_low_1",
				identifier = "player_crit_chance_node_buff_low_1"
			}
		},
		base_crit_chance_node_buff_low_2 = {
			description = "loc_talent_crit_chance_low_desc",
			name = "[dev] crit_chance bonus",
			display_name = "loc_talent_crit_chance_low",
			format_values = {
				crit_chance = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_crit_chance_node_buff_low_2",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.critical_strike_chance
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_crit_chance_node_buff_low_2",
				identifier = "player_crit_chance_node_buff_low_2"
			}
		},
		base_crit_chance_node_buff_low_3 = {
			description = "loc_talent_crit_chance_low_desc",
			name = "[dev] crit_chance bonus",
			display_name = "loc_talent_crit_chance_low",
			format_values = {
				crit_chance = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_crit_chance_node_buff_low_3",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.critical_strike_chance
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_crit_chance_node_buff_low_3",
				identifier = "player_crit_chance_node_buff_low_3"
			}
		},
		base_crit_chance_node_buff_low_4 = {
			description = "loc_talent_crit_chance_low_desc",
			name = "[dev] crit_chance bonus",
			display_name = "loc_talent_crit_chance_low",
			format_values = {
				crit_chance = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_crit_chance_node_buff_low_4",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.critical_strike_chance
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_crit_chance_node_buff_low_4",
				identifier = "player_crit_chance_node_buff_low_4"
			}
		},
		base_crit_chance_node_buff_low_5 = {
			description = "loc_talent_crit_chance_low_desc",
			name = "[dev] crit_chance bonus",
			display_name = "loc_talent_crit_chance_low",
			format_values = {
				crit_chance = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_crit_chance_node_buff_low_5",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.critical_strike_chance
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_crit_chance_node_buff_low_5",
				identifier = "player_crit_chance_node_buff_low_5"
			}
		},
		base_movement_speed_node_buff_low_1 = {
			description = "loc_talent_movement_speed_low_desc",
			name = "[dev] movement_speed bonus",
			display_name = "loc_talent_movement_speed_low",
			format_values = {
				movement_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_movement_speed_node_buff_low_1",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.movement_speed
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_movement_speed_node_buff_low_1",
				identifier = "player_movement_speed_node_buff_low_1"
			}
		},
		base_movement_speed_node_buff_low_2 = {
			description = "loc_talent_movement_speed_low_desc",
			name = "[dev] movement_speed bonus",
			display_name = "loc_talent_movement_speed_low",
			format_values = {
				movement_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_movement_speed_node_buff_low_2",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.movement_speed
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_movement_speed_node_buff_low_2",
				identifier = "player_movement_speed_node_buff_low_2"
			}
		},
		base_movement_speed_node_buff_low_3 = {
			description = "loc_talent_movement_speed_low_desc",
			name = "[dev] movement_speed bonus",
			display_name = "loc_talent_movement_speed_low",
			format_values = {
				movement_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_movement_speed_node_buff_low_3",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.movement_speed
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_movement_speed_node_buff_low_3",
				identifier = "player_movement_speed_node_buff_low_3"
			}
		},
		base_movement_speed_node_buff_low_4 = {
			description = "loc_talent_movement_speed_low_desc",
			name = "[dev] movement_speed bonus",
			display_name = "loc_talent_movement_speed_low",
			format_values = {
				movement_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_movement_speed_node_buff_low_4",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.movement_speed
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_movement_speed_node_buff_low_4",
				identifier = "player_movement_speed_node_buff_low_4"
			}
		},
		base_movement_speed_node_buff_low_5 = {
			description = "loc_talent_movement_speed_low_desc",
			name = "[dev] movement_speed bonus",
			display_name = "loc_talent_movement_speed_low",
			format_values = {
				movement_speed = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_movement_speed_node_buff_low_5",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.movement_speed
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_movement_speed_node_buff_low_5",
				identifier = "player_movement_speed_node_buff_low_5"
			}
		},
		base_coherency_regen_node_buff_low_1 = {
			description = "loc_talent_coherency_regen_low_desc",
			name = "[dev] coherency_regen bonus",
			display_name = "loc_talent_coherency_regen_low",
			format_values = {
				coherency_regen = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_coherency_regen_node_buff_low_1",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_regen_rate_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_coherency_regen_node_buff_low_1",
				identifier = "player_coherency_regen_node_buff_low_1"
			}
		},
		base_coherency_regen_node_buff_low_2 = {
			description = "loc_talent_coherency_regen_low_desc",
			name = "[dev] coherency_regen bonus",
			display_name = "loc_talent_coherency_regen_low",
			format_values = {
				coherency_regen = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_coherency_regen_node_buff_low_2",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_regen_rate_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_coherency_regen_node_buff_low_2",
				identifier = "player_coherency_regen_node_buff_low_2"
			}
		},
		base_coherency_regen_node_buff_low_3 = {
			description = "loc_talent_coherency_regen_low_desc",
			name = "[dev] coherency_regen bonus",
			display_name = "loc_talent_coherency_regen_low",
			format_values = {
				coherency_regen = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_coherency_regen_node_buff_low_3",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_regen_rate_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_coherency_regen_node_buff_low_3",
				identifier = "player_coherency_regen_node_buff_low_3"
			}
		},
		base_coherency_regen_node_buff_low_4 = {
			description = "loc_talent_coherency_regen_low_desc",
			name = "[dev] coherency_regen bonus",
			display_name = "loc_talent_coherency_regen_low",
			format_values = {
				coherency_regen = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_coherency_regen_node_buff_low_4",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_regen_rate_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_coherency_regen_node_buff_low_4",
				identifier = "player_coherency_regen_node_buff_low_4"
			}
		},
		base_coherency_regen_node_buff_low_5 = {
			description = "loc_talent_coherency_regen_low_desc",
			name = "[dev] coherency_regen bonus",
			display_name = "loc_talent_coherency_regen_low",
			format_values = {
				coherency_regen = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_coherency_regen_node_buff_low_5",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.toughness_regen_rate_modifier
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_coherency_regen_node_buff_low_5",
				identifier = "player_coherency_regen_node_buff_low_5"
			}
		},
		base_warp_charge_node_buff_low_1 = {
			description = "loc_talent_warp_charge_low_desc",
			name = "[dev] warp_charge bonus",
			display_name = "loc_talent_warp_charge_low",
			format_values = {
				warp_charge = {
					prefix = "-",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_warp_charge_node_buff_low_1",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.warp_charge_amount
						}
					},
					value_manipulation = function (value)
						return (1 - value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "player_warp_charge_node_buff_low_1",
				identifier = "player_warp_charge_node_buff_low_1"
			}
		},
		base_warp_charge_node_buff_low_2 = {
			description = "loc_talent_warp_charge_low_desc",
			name = "[dev] warp_charge bonus",
			display_name = "loc_talent_warp_charge_low",
			format_values = {
				warp_charge = {
					prefix = "-",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_warp_charge_node_buff_low_2",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.warp_charge_amount
						}
					},
					value_manipulation = function (value)
						return (1 - value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "player_warp_charge_node_buff_low_2",
				identifier = "player_warp_charge_node_buff_low_2"
			}
		},
		base_warp_charge_node_buff_low_3 = {
			description = "loc_talent_warp_charge_low_desc",
			name = "[dev] warp_charge bonus",
			display_name = "loc_talent_warp_charge_low",
			format_values = {
				warp_charge = {
					prefix = "-",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_warp_charge_node_buff_low_3",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.warp_charge_amount
						}
					},
					value_manipulation = function (value)
						return (1 - value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "player_warp_charge_node_buff_low_3",
				identifier = "player_warp_charge_node_buff_low_3"
			}
		},
		base_warp_charge_node_buff_low_4 = {
			description = "loc_talent_warp_charge_low_desc",
			name = "[dev] warp_charge bonus",
			display_name = "loc_talent_warp_charge_low",
			format_values = {
				warp_charge = {
					prefix = "-",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_warp_charge_node_buff_low_4",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.warp_charge_amount
						}
					},
					value_manipulation = function (value)
						return (1 - value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "player_warp_charge_node_buff_low_4",
				identifier = "player_warp_charge_node_buff_low_4"
			}
		},
		base_warp_charge_node_buff_low_5 = {
			description = "loc_talent_warp_charge_low_desc",
			name = "[dev] warp_charge bonus",
			display_name = "loc_talent_warp_charge_low",
			format_values = {
				warp_charge = {
					prefix = "-",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_warp_charge_node_buff_low_5",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.warp_charge_amount
						}
					},
					value_manipulation = function (value)
						return (1 - value) * 100
					end
				}
			},
			passive = {
				buff_template_name = "player_warp_charge_node_buff_low_5",
				identifier = "player_warp_charge_node_buff_low_5"
			}
		},
		base_wounds_node_buff_1 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_wounds_node_buff_1",
				identifier = "base_wounds_node_buff"
			}
		},
		base_wounds_node_buff_2 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_wounds_node_buff_2",
				identifier = "base_wounds_node_buff"
			}
		},
		base_max_warp_charge_node_buff_1 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_max_warp_charge_node_buff_1",
				identifier = "base_max_warp_charge_node_buff"
			}
		},
		base_max_warp_charge_node_buff_2 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_max_warp_charge_node_buff_2",
				identifier = "base_max_warp_charge_node_buff"
			}
		},
		base_dodge_count_node_buff_1 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_dodge_count_node_buff_1",
				identifier = "base_dodge_count_node_buff"
			}
		},
		base_dodge_count_node_buff_2 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_dodge_count_node_buff_2",
				identifier = "base_dodge_count_node_buff"
			}
		},
		base_max_ammo_node_buff_1 = {
			description = "loc_talent_max_ammo_low_desc",
			name = "",
			display_name = "loc_talent_max_ammo_low",
			format_values = {
				ammo = {
					prefix = "+",
					format_type = "percentage",
					find_value = {
						buff_template_name = "player_max_ammo_node_buff_1",
						tier = true,
						find_value_type = "buff_template",
						path = {
							"stat_buffs",
							stat_buffs.ammo_reserve_capacity
						}
					}
				}
			},
			passive = {
				buff_template_name = "player_max_ammo_node_buff_1",
				identifier = "base_max_ammo_node_buff"
			}
		},
		base_max_ammo_node_buff_2 = {
			description = "loc_talent_max_ammo_low_desc",
			name = "",
			display_name = "loc_talent_max_ammo_low",
			passive = {
				buff_template_name = "player_max_ammo_node_buff_2",
				identifier = "base_max_ammo_node_buff"
			}
		},
		base_coherency_regen_node_buff_1 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_coherency_regen_node_buff_1",
				identifier = "coherency_regen_node_buff"
			}
		},
		base_coherency_regen_node_buff_2 = {
			description = "",
			name = "",
			display_name = "",
			passive = {
				buff_template_name = "player_coherency_regen_node_buff_2",
				identifier = "coherency_regen_node_buff"
			}
		}
	}
}

return base_talents
