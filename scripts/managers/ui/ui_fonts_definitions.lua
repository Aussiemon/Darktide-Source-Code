local FONT_TYPES = table.enum("serif", "sans_serif")
local definitions = {
	custom_font = "darktide_custom_regular",
	base_path = "content/ui/fonts/",
	FontTypes = FONT_TYPES,
	fonts = {
		arial = FONT_TYPES.sans_serif,
		itc_novarese_medium = FONT_TYPES.serif,
		itc_novarese_bold = FONT_TYPES.serif,
		proxima_nova_light = FONT_TYPES.sans_serif,
		proxima_nova_medium = FONT_TYPES.sans_serif,
		proxima_nova_bold = FONT_TYPES.sans_serif,
		friz_quadrata = FONT_TYPES.serif,
		rexlia = FONT_TYPES.sans_serif,
		machine_medium = FONT_TYPES.sans_serif
	},
	locale_specific_fonts = {
		ja = {
			package = "packages/ui/fonts/slug_ja",
			machine_medium = "noto_sans_jp_black",
			[FONT_TYPES.sans_serif] = "noto_sans_jp_bold",
			[FONT_TYPES.serif] = "noto_serif_jp_bold"
		},
		ko = {
			package = "packages/ui/fonts/slug_ko",
			machine_medium = "noto_sans_kr_black",
			[FONT_TYPES.sans_serif] = "noto_sans_kr_bold",
			[FONT_TYPES.serif] = "noto_serif_kr_bold"
		},
		ru = {
			[FONT_TYPES.serif] = "friz_quadrata"
		},
		["zh-cn"] = {
			package = "packages/ui/fonts/slug_zh_cn",
			machine_medium = "noto_sans_sc_black",
			[FONT_TYPES.sans_serif] = "noto_sans_sc_bold",
			[FONT_TYPES.serif] = "noto_serif_sc_bold"
		},
		["zh-tw"] = {
			package = "packages/ui/fonts/slug_zh_tw",
			machine_medium = "noto_sans_tc_black",
			[FONT_TYPES.sans_serif] = "noto_sans_tc_bold",
			[FONT_TYPES.serif] = "noto_sans_tc_black"
		}
	}
}

return definitions
