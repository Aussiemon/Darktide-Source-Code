local definition_path = "scripts/ui/views/loading_view/loading_view_definitions"
local LoadingViewSettings = require("scripts/ui/views/loading_view/loading_view_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local InputUtils = require("scripts/managers/input/input_utils")
local temp_loading_hints = {
	"loc_loading_hint_000",
	"loc_loading_hint_001",
	"loc_loading_hint_002",
	"loc_loading_hint_003",
	"loc_loading_hint_005",
	"loc_loading_hint_006",
	"loc_loading_hint_007",
	"loc_loading_hint_008",
	"loc_loading_hint_009",
	"loc_loading_hint_010",
	"loc_loading_hint_011",
	"loc_loading_hint_012",
	"loc_loading_hint_013",
	"loc_loading_hint_014",
	"loc_loading_hint_015",
	"loc_loading_hint_016",
	"loc_loading_hint_017",
	"loc_loading_hint_018",
	"loc_loading_hint_019",
	"loc_loading_hint_020",
	"loc_loading_hint_021",
	"loc_loading_hint_022",
	"loc_loading_hint_023",
	"loc_loading_hint_024",
	"loc_loading_hint_025",
	"loc_loading_hint_026",
	"loc_loading_hint_027",
	"loc_loading_hint_028",
	"loc_loading_hint_029",
	"loc_loading_hint_030",
	"loc_loading_hint_031",
	"loc_loading_hint_032",
	"loc_loading_hint_033",
	"loc_loading_hint_034",
	"loc_loading_hint_035",
	"loc_loading_hint_036",
	"loc_loading_hint_037",
	"loc_loading_hint_038",
	"loc_loading_hint_039",
	"loc_loading_hint_040",
	"loc_loading_hint_041",
	"loc_loading_hint_042",
	"loc_loading_hint_043",
	"loc_loading_hint_044",
	"loc_loading_hint_045",
	"loc_loading_hint_046",
	"loc_loading_hint_047",
	"loc_loading_hint_048",
	"loc_loading_hint_049",
	"loc_loading_hint_050",
	"loc_loading_hint_051",
	"loc_loading_hint_052",
	"loc_loading_hint_053",
	"loc_loading_hint_054",
	"loc_loading_hint_055",
	"loc_loading_hint_056",
	"loc_loading_hint_057",
	"loc_loading_hint_058",
	"loc_loading_hint_059",
	"loc_loading_hint_060",
	"loc_loading_hint_061",
	"loc_loading_hint_062",
	"loc_loading_hint_063",
	"loc_loading_hint_064",
	"loc_loading_hint_065",
	"loc_loading_hint_066",
	"loc_loading_hint_067",
	"loc_loading_hint_068",
	"loc_loading_hint_069",
	"loc_loading_hint_070",
	"loc_loading_hint_071",
	"loc_loading_hint_072",
	"loc_loading_hint_073",
	"loc_loading_hint_074",
	"loc_loading_hint_075",
	"loc_loading_hint_076",
	"loc_loading_hint_077",
	"loc_loading_hint_078",
	"loc_loading_hint_079",
	"loc_loading_hint_080",
	"loc_loading_hint_081",
	"loc_loading_hint_082",
	"loc_loading_hint_083",
	"loc_loading_hint_084",
	"loc_loading_hint_085",
	"loc_loading_hint_086",
	"loc_loading_hint_087",
	"loc_loading_hint_088",
	"loc_loading_hint_089",
	"loc_loading_hint_090",
	"loc_loading_hint_091",
	"loc_loading_hint_092",
	"loc_loading_hint_093",
	"loc_loading_hint_094",
	"loc_loading_hint_095",
	"loc_loading_hint_096",
	"loc_loading_hint_097",
	"loc_loading_hint_098",
	"loc_loading_hint_099",
	"loc_loading_hint_100",
	"loc_loading_hint_101",
	"loc_loading_hint_102",
	"loc_loading_hint_103",
	"loc_loading_hint_104",
	"loc_loading_hint_105",
	"loc_loading_hint_106",
	"loc_loading_hint_107",
	"loc_loading_hint_108",
	"loc_loading_hint_109",
	"loc_loading_hint_110",
	"loc_loading_hint_111",
	"loc_loading_hint_112",
	"loc_loading_hint_113",
	"loc_loading_hint_114",
	"loc_loading_hint_115",
	"loc_loading_hint_116",
	"loc_loading_hint_117",
	"loc_loading_hint_118",
	"loc_loading_hint_119",
	"loc_loading_hint_120",
	"loc_loading_hint_121",
	"loc_loading_hint_122",
	"loc_loading_hint_123",
	"loc_loading_hint_124",
	"loc_loading_hint_125",
	"loc_loading_hint_126",
	"loc_loading_hint_127",
	"loc_loading_hint_128",
	"loc_loading_hint_129",
	"loc_loading_hint_130",
	"loc_loading_hint_131",
	"loc_loading_hint_132",
	"loc_loading_hint_133",
	"loc_loading_hint_134",
	"loc_loading_hint_135",
	"loc_loading_hint_136",
	"loc_loading_hint_137",
	"loc_loading_hint_138",
	"loc_loading_hint_139",
	"loc_loading_hint_140",
	"loc_loading_hint_141",
	"loc_loading_hint_142",
	"loc_loading_hint_143",
	"loc_loading_hint_144",
	"loc_loading_hint_145",
	"loc_loading_hint_146",
	"loc_loading_hint_147",
	"loc_loading_hint_148",
	"loc_loading_hint_149",
	"loc_loading_hint_150",
	"loc_loading_hint_151",
	"loc_loading_hint_152",
	"loc_loading_hint_153",
	"loc_loading_hint_154",
	"loc_loading_hint_155",
	"loc_loading_hint_156",
	"loc_loading_hint_157",
	"loc_loading_hint_158",
	"loc_loading_hint_159",
	"loc_loading_hint_160",
	"loc_loading_hint_161",
	"loc_loading_hint_162",
	"loc_loading_hint_163",
	"loc_loading_hint_164",
	"loc_loading_hint_165",
	"loc_loading_hint_166",
	"loc_loading_hint_167",
	"loc_loading_hint_168",
	"loc_loading_hint_169",
	"loc_loading_hint_170",
	"loc_loading_hint_171",
	"loc_loading_hint_172",
	"loc_loading_hint_173",
	"loc_loading_hint_174",
	"loc_loading_hint_175",
	"loc_loading_hint_176",
	"loc_loading_hint_177",
	"loc_loading_hint_178",
	"loc_loading_hint_179",
	"loc_loading_hint_180",
	"loc_loading_hint_181",
	"loc_loading_hint_182",
	"loc_loading_hint_183",
	"loc_loading_hint_184",
	"loc_loading_hint_185",
	"loc_loading_hint_186",
	"loc_loading_hint_187",
	"loc_loading_hint_188",
	"loc_loading_hint_189",
	"loc_loading_hint_190",
	"loc_loading_hint_191",
	"loc_loading_hint_192",
	"loc_loading_hint_193",
	"loc_loading_hint_194",
	"loc_loading_hint_195",
	"loc_loading_hint_196",
	"loc_loading_hint_197",
	"loc_loading_hint_198",
	"loc_loading_hint_199",
	"loc_loading_hint_200",
	"loc_loading_hint_201",
	"loc_loading_hint_202",
	"loc_loading_hint_203",
	"loc_loading_hint_204",
	"loc_loading_hint_205",
	"loc_loading_hint_206",
	"loc_loading_hint_207",
	"loc_loading_hint_208",
	"loc_loading_hint_209",
	"loc_loading_hint_210",
	"loc_loading_hint_211",
	"loc_loading_hint_212",
	"loc_loading_hint_213",
	"loc_loading_hint_214",
	"loc_loading_hint_215",
	"loc_loading_hint_216",
	"loc_loading_hint_217",
	"loc_loading_hint_218",
	"loc_loading_hint_219",
	"loc_loading_hint_220",
	"loc_loading_hint_221",
	"loc_loading_hint_222",
	"loc_loading_hint_223",
	"loc_loading_hint_224",
	"loc_loading_hint_225",
	"loc_loading_hint_226",
	"loc_loading_hint_227",
	"loc_loading_hint_228",
	"loc_loading_hint_229",
	"loc_loading_hint_230",
	"loc_loading_hint_231",
	"loc_loading_hint_232",
	"loc_loading_hint_233",
	"loc_loading_hint_234",
	"loc_loading_hint_235",
	"loc_loading_hint_236",
	"loc_loading_hint_237",
	"loc_loading_hint_238",
	"loc_loading_hint_239",
	"loc_loading_hint_240",
	"loc_loading_hint_241",
	"loc_loading_hint_242",
	"loc_loading_hint_243",
	"loc_loading_hint_244",
	"loc_loading_hint_245",
	"loc_loading_hint_246",
	"loc_loading_hint_247",
	"loc_loading_hint_248",
	"loc_loading_hint_249",
	"loc_loading_hint_250",
	"loc_loading_hint_251",
	"loc_loading_hint_252",
	"loc_loading_hint_253",
	"loc_loading_hint_254",
	"loc_loading_hint_255",
	"loc_loading_hint_256",
	"loc_loading_hint_257",
	"loc_loading_hint_258",
	"loc_loading_hint_259",
	"loc_loading_hint_260",
	"loc_loading_hint_261",
	"loc_loading_hint_262",
	"loc_loading_hint_263",
	"loc_loading_hint_264",
	"loc_loading_hint_265",
	"loc_loading_hint_266",
	"loc_loading_hint_267",
	"loc_loading_hint_268",
	"loc_loading_hint_269",
	"loc_loading_hint_270",
	"loc_loading_hint_271",
	"loc_loading_hint_272",
	"loc_loading_hint_273",
	"loc_loading_hint_274",
	"loc_loading_hint_275",
	"loc_loading_hint_276",
	"loc_loading_hint_277",
	"loc_loading_hint_278",
	"loc_loading_hint_279",
	"loc_loading_hint_280",
	"loc_loading_hint_281",
	"loc_loading_hint_282",
	"loc_loading_hint_283",
	"loc_loading_hint_284",
	"loc_loading_hint_285",
	"loc_loading_hint_286",
	"loc_loading_hint_287",
	"loc_loading_hint_288",
	"loc_loading_hint_289",
	"loc_loading_hint_290",
	"loc_loading_hint_291",
	"loc_loading_hint_292",
	"loc_loading_hint_293",
	"loc_loading_hint_294",
	"loc_loading_hint_295",
	"loc_loading_hint_296",
	"loc_loading_hint_297",
	"loc_loading_hint_298",
	"loc_loading_hint_299",
	"loc_loading_hint_300",
	"loc_loading_hint_301",
	"loc_loading_hint_302",
	"loc_loading_hint_303",
	"loc_loading_hint_304",
	"loc_loading_hint_305",
	"loc_loading_hint_306",
	"loc_loading_hint_307",
	"loc_loading_hint_308",
	"loc_loading_hint_309",
	"loc_loading_hint_310"
}
local LoadingView = class("LoadingView", "BaseView")

LoadingView.init = function (self, settings, context)
	self._entry_duration = nil
	self._text_cycle_duration = nil
	self._update_hint_text = nil
	local definitions = require(definition_path)

	LoadingView.super.init(self, definitions, settings)

	self._can_exit = context and context.can_exit
	self._pass_draw = false
end

LoadingView.on_enter = function (self)
	LoadingView.super.on_enter(self)

	self._entry_duration = LoadingViewSettings.entry_duration

	self:_cycle_next_hint()
	self:_update_input_display()
	self:_register_event("event_on_active_input_changed", "event_on_input_changed")

	if Managers.loading.black_screen then
		Managers.loading:hide_instant_black_screen()
	end
end

LoadingView.draw = function (self, dt, t, input_service, layer)
	LoadingView.super.draw(self, dt, t, input_service, layer)
	Managers.ui:render_loading_icon()
end

LoadingView.can_exit = function (self)
	return self._can_exit
end

LoadingView.on_exit = function (self)
	LoadingView.super.on_exit(self)
end

LoadingView.event_on_input_changed = function (self)
	self:_update_input_display()
end

LoadingView._update_input_display = function (self)
	local text = "loc_next"
	local widgets_by_name = self._widgets_by_name
	local text_widget = widgets_by_name.hint_input_description
	local localized_text = self:_localize(text)
	local service_type = "View"
	local alias_name = "next"
	local color_tint_text = true
	local input_key = InputUtils.input_text_for_current_input_device(service_type, alias_name, color_tint_text)
	text_widget.content.text = input_key .. " " .. localized_text
end

LoadingView._widget_text_length = function (self, widget_id)
	local widget = self._widgets_by_name[widget_id]
	local scenegraph_id = widget.scenegraph_id
	local widget_width, widget_height = self:_scenegraph_size(scenegraph_id)
	local text = widget.content.text
	local text_style = widget.style.text
	local text_options = UIFonts.get_font_options_by_style(text_style)
	local text_length, _ = UIRenderer.text_size(self._ui_renderer, text, text_style.font_type, text_style.font_size, {
		widget_width,
		widget_height
	}, text_options)

	return text_length
end

LoadingView._handle_input = function (self, input_service)
	if input_service:get("next") then
		self:_cycle_next_hint()
	end
end

LoadingView._cycle_next_hint = function (self)
	if self._text_cycle_duration then
		return
	end

	self._text_cycle_duration = LoadingViewSettings.hint_text_update_duration
	self._update_hint_text = true
end

LoadingView._set_hint_text_opacity = function (self, opacity)
	local widget = self._widgets_by_name.hint_text
	widget.alpha_multiplier = opacity
end

LoadingView._update_next_hint = function (self)
	local num_hints = #temp_loading_hints
	self._hint_index = self._hint_index and self._hint_index % num_hints + 1 or math.random(1, num_hints)
	local next_hint = temp_loading_hints[self._hint_index]

	self:_set_hint_text(next_hint)

	self._update_hint_text = nil
end

LoadingView._set_hint_text = function (self, text)
	local widget = self._widgets_by_name.hint_text
	widget.content.text = self:_localize(text)
end

LoadingView._set_overlay_opacity = function (self, opacity)
	local widget = self._widgets_by_name.overlay
	widget.alpha_multiplier = opacity
end

LoadingView.update = function (self, dt, t, input_service)
	local entry_duration = self._entry_duration

	if entry_duration then
		entry_duration = math.max(entry_duration - dt, 0)

		self:_set_overlay_opacity(math.easeOutCubic(entry_duration / LoadingViewSettings.entry_duration))

		if entry_duration <= 0 then
			self._entry_duration = nil
		else
			self._entry_duration = entry_duration
		end
	end

	if self._text_cycle_duration and self._text_cycle_duration then
		local text_cycle_duration = self._text_cycle_duration - dt
		local progress = 1 - math.max(text_cycle_duration / LoadingViewSettings.hint_text_update_duration, 0)
		local cycle_progress = (progress * 2 - 1)^2

		if self._update_hint_text and progress > 0.48 then
			self:_update_next_hint()
		end

		self._text_cycle_duration = progress ~= 1 and text_cycle_duration or nil

		self:_set_hint_text_opacity(cycle_progress)
	end

	return LoadingView.super.update(self, dt, t, input_service)
end

return LoadingView
