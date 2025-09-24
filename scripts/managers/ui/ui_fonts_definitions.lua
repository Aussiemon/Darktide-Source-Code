-- chunkname: @scripts/managers/ui/ui_fonts_definitions.lua

local FONT_TYPES = table.enum("serif", "sans_serif")
local definitions = {
	base_path = "content/ui/fonts/",
	custom_font = "darktide_custom_regular",
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
		machine_medium = FONT_TYPES.sans_serif,
		trim_mono_light = FONT_TYPES.sans_serif,
		trim_mono_medium = FONT_TYPES.sans_serif,
		trim_mono_bold = FONT_TYPES.sans_serif,
	},
	locale_specific_fonts = {
		ja = {
			machine_medium = "noto_sans_jp_black",
			package = "packages/ui/fonts/slug_ja",
			[FONT_TYPES.sans_serif] = "noto_sans_jp_bold",
			[FONT_TYPES.serif] = "noto_sans_jp_black",
		},
		ko = {
			machine_medium = "noto_sans_kr_black",
			package = "packages/ui/fonts/slug_ko",
			[FONT_TYPES.sans_serif] = "noto_sans_kr_bold",
			[FONT_TYPES.serif] = "noto_sans_kr_black",
		},
		ru = {
			[FONT_TYPES.serif] = "friz_quadrata",
			[FONT_TYPES.sans_serif] = "proxima_nova_bold",
		},
		["zh-cn"] = {
			machine_medium = "noto_sans_sc_black",
			package = "packages/ui/fonts/slug_zh_cn",
			[FONT_TYPES.sans_serif] = "noto_sans_sc_bold",
			[FONT_TYPES.serif] = "noto_sans_sc_black",
		},
		["zh-tw"] = {
			machine_medium = "noto_sans_tc_black",
			package = "packages/ui/fonts/slug_zh_tw",
			[FONT_TYPES.sans_serif] = {
				"noto_sans_tc_bold",
				"noto_sans_sc_bold",
			},
			[FONT_TYPES.serif] = {
				"noto_sans_tc_black",
				"noto_sans_sc_black",
			},
		},
	},
}

return definitions
