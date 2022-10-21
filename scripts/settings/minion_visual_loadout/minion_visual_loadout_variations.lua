local variations = {
	chaos_poxwalker = table.enum("default_1", "default_2", "default_3", "default_4", "default_5", "default_6", "default_7", "default_8", "default_9", "default_10"),
	chaos_newly_infected = table.enum("default_1", "default_2", "default_3", "default_4", "default_5", "default_6", "default_7", "default_8", "default_9", "default_10", "default_11", "default_12", "default_13", "default_14", "default_15", "default_16", "default_17", "default_18", "default_19", "default_20", "default_21", "default_22", "default_23", "default_24", "default_25", "default_26", "default_27", "default_28", "default_29", "default_30", "default_31", "default_32", "default_33", "default_34", "default_35", "default_36", "default_37", "default_38"),
	cultist_assault = table.enum("default_1", "default_2"),
	cultist_berzerker = table.enum("default_1", "default_2"),
	cultist_flamer = table.enum("default_1", "default_2"),
	chaos_hound = table.enum("default_1"),
	chaos_ogryn_bulwark = table.enum("default_1", "default_2", "default_3", "default_4", "default_5", "default_6", "default_7", "default_8", "default_9", "default_10", "default_11", "default_12"),
	chaos_ogryn_executor = table.enum("default_1"),
	chaos_ogryn_gunner = table.enum("default_1", "default_2", "default_3", "default_4", "default_5", "default_6"),
	chaos_plague_ogryn = table.enum("default_1"),
	chaos_plague_ogryn_sprayer = table.enum("default_1"),
	chaos_beast_of_nurgle = table.enum("default_1"),
	chaos_daemonhost = table.enum("default_1"),
	chaos_poxwalker_bomber = table.enum("default_1")
}

return settings("MinionVisualLoadoutVariations", variations)
