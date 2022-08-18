local font_names = {
	"arial",
	"itc_novarese_medium",
	"itc_novarese_bold",
	"proxima_nova_light",
	"proxima_nova_medium",
	"proxima_nova_bold",
	"friz_quadrata",
	"rexlia"
}
local special_character_fonts = {
	"content/ui/fonts/darktide_custom_regular"
}
local definitions = {}

for i = 1, #font_names, 1 do
	local name = font_names[i]
	local path = table.append({
		"content/ui/fonts/" .. name
	}, special_character_fonts)
	definitions[name] = {
		path = path,
		render_flags = Gui.MultiLine + Gui.FormatDirectives
	}
	definitions[name .. "_no_render_flags"] = {
		path = path
	}
	definitions[name .. "_masked"] = {
		path = path,
		render_flags = Gui.MultiLine + Gui.Masked + Gui.FormatDirectives
	}
	definitions[name .. "_write_mask"] = {
		path = path,
		render_flags = Gui.MultiLine + Gui.WriteMask + Gui.FormatDirectives
	}
end

return definitions
