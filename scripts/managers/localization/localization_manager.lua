-- chunkname: @scripts/managers/localization/localization_manager.lua

local LocalizationMacros = require("scripts/managers/localization/localization_macros")
local LocalizationManager = class("LocalizationManager")
local STRING_RESOURCE_NAMES = {
	"content/localization/ui",
	"content/localization/subtitles",
	"content/localization/items",
	"content/localization/path_of_trust/ui",
}
local ASSERT_ON_MISSING_LOC_PREFIX = false
local STRING_CACHE_EXPECTED_SIZE = 2048
local DEFAULT_LANGUAGE = "en"

local function xbox_format_locale(language_id)
	local supported_languages = {
		["de-at"] = "de",
		["de-ch"] = "de",
		["de-de"] = "de",
		["en-ae"] = "en",
		["en-au"] = "en",
		["en-ca"] = "en",
		["en-cz"] = "en",
		["en-gb"] = "en",
		["en-gr"] = "en",
		["en-hk"] = "en",
		["en-hu"] = "en",
		["en-ie"] = "en",
		["en-il"] = "en",
		["en-in"] = "en",
		["en-nz"] = "en",
		["en-sa"] = "en",
		["en-sg"] = "en",
		["en-sk"] = "en",
		["en-us"] = "en",
		["en-za"] = "en",
		["es-ar"] = "es",
		["es-cl"] = "es",
		["es-co"] = "es",
		["es-es"] = "es",
		["es-mx"] = "es",
		["fr-be"] = "fr",
		["fr-ca"] = "fr",
		["fr-ch"] = "fr",
		["fr-fr"] = "fr",
		["it-it"] = "it",
		["ja-jp"] = "ja",
		["ko-kr"] = "ko",
		["pl-pl"] = "pl",
		["pt-br"] = "pt-br",
		["ru-ru"] = "ru",
		["zh-cn"] = "zh-cn",
		["zh-hk"] = "zh-cn",
		["zh-mo"] = "zh-cn",
		["zh-sg"] = "zh-cn",
		["zh-tw"] = "zh-tw",
	}

	return supported_languages[string.lower(language_id)] or "en"
end

local function ps5_format_locale(language_id)
	local supported_languages = {
		["de-de"] = "de",
		["en-gb"] = "en",
		["en-us"] = "en",
		["es-419"] = "es",
		["es-es"] = "es",
		["fr-ca"] = "fr",
		["fr-fr"] = "fr",
		["it-it"] = "it",
		["ja-jp"] = "ja",
		["ko-kr"] = "ko",
		["pl-pl"] = "pl",
		["pt-br"] = "pt-br",
		["ru-ru"] = "ru",
		["zh-cn"] = "zh-cn",
		["zh-tw"] = "zh-tw",
	}

	return supported_languages[string.lower(language_id)] or "en"
end

local LOCALIZATION_MANAGER_STATUS = table.enum("empty", "loading", "ready")

local function _select_language()
	local language

	if PLATFORM == "win32" then
		language = Application.user_setting("language_id") or HAS_STEAM and Steam:language() or DEFAULT_LANGUAGE
	elseif PLATFORM == "ps5" then
		local locale = PS5.locale() or "error"

		language = ps5_format_locale(locale)
	elseif PLATFORM == "xb1" then
		local locale = XboxLive.locale() or "error"

		language = xbox_format_locale(locale)
	elseif PLATFORM == "xbs" then
		local locale = XboxLive.locale() or "error"

		language = xbox_format_locale(locale)
	elseif PLATFORM == "linux" then
		language = "en"
	end

	return language
end

Localize = Localize or false

LocalizationManager.init = function (self)
	self._backend_localizations = {}
	self._string_cache = Script.new_map(STRING_CACHE_EXPECTED_SIZE)

	local language = _select_language()

	self._original_language = language
	self._enable_string_tags = false
	self._language = language
	self._status = LOCALIZATION_MANAGER_STATUS.empty

	self:_set_resource_property_preference_order(language)
	rawset(_G, "Localize", function (key, no_cache, context)
		return self:localize(key, no_cache, context)
	end)
end

LocalizationManager.reset_cache = function (self)
	self._string_cache = Script.new_map(STRING_CACHE_EXPECTED_SIZE)
end

LocalizationManager.destroy = function (self)
	rawset(_G, "Localize", false)
end

LocalizationManager._set_resource_property_preference_order = function (self, language)
	if language == DEFAULT_LANGUAGE then
		Application.set_resource_property_preference_order(DEFAULT_LANGUAGE)
	else
		Application.set_resource_property_preference_order(language, DEFAULT_LANGUAGE)
	end
end

LocalizationManager.setup_localizers = function (self, strings_package_id)
	self._package_id = strings_package_id

	print("[LocalizationManager] Setup localizers")

	local num_string_resources = #STRING_RESOURCE_NAMES
	local localizers = Script.new_array(num_string_resources)

	for i = 1, num_string_resources do
		local resource_name = STRING_RESOURCE_NAMES[i]

		localizers[i] = Localizer(resource_name)
	end

	self._localizers = localizers
	self._status = LOCALIZATION_MANAGER_STATUS.ready
end

LocalizationManager._teardown_localizers = function (self)
	print("[LocalizationManager] Tearing down localizers")

	self._localizers = nil

	local package_manager = Managers.package

	package_manager:release(self._package_id)

	self._package_id = nil
	self._status = LOCALIZATION_MANAGER_STATUS.empty
end

LocalizationManager._lookup = function (self, key)
	local localizers = self._localizers

	for ii = 1, #localizers do
		local localizer = localizers[ii]
		local loc_str

		if self._lookup_with_tag ~= nil and self._enable_string_tags then
			loc_str = self:_lookup_with_tag(localizer, key)
		else
			loc_str = Localizer.lookup(localizer, key)
		end

		if loc_str then
			return loc_str
		end
	end

	return self._backend_localizations[key]
end

LocalizationManager.append_backend_localizations = function (self, localizations)
	local backend_localizations = self._backend_localizations

	for key, str in pairs(localizations) do
		backend_localizations[key] = str
	end
end

local function _handle_error(key, err)
	local display_message = string.format("<unlocalized %q: %s>", key, err)

	return display_message
end

LocalizationManager.localize = function (self, key, no_cache, context)
	local string_cache = self._string_cache

	if not no_cache and string_cache[key] then
		return string_cache[key]
	end

	if self._status ~= LOCALIZATION_MANAGER_STATUS.ready then
		return ""
	end

	local raw_str = self:_lookup(key)

	if not raw_str then
		return _handle_error(key, "string not found")
	end

	if string.sub(key, 1, 4) ~= "loc_" then
		if ASSERT_ON_MISSING_LOC_PREFIX then
			ferror("[LocalizationManager] Localized string %s is missing 'loc_' prefix", key)
		else
			return _handle_error(key, "missing 'loc_' prefix")
		end
	end

	local str, err = self:_process_string(key, raw_str, context)

	if err then
		return _handle_error(key, err)
	end

	string_cache[key] = str

	return str
end

local function _apply_macro_callback(key, errors, macro_name, macro_param)
	local macro_func = LocalizationMacros[macro_name]

	if not macro_func then
		errors[#errors + 1] = string.format("macro %q not found", macro_name)

		return ""
	end

	if macro_param == "" then
		macro_param = nil
	end

	return macro_func(macro_param)
end

local function _apply_interpolation_callback(string_key, errors, context, context_key, format)
	local context_value = context and context[context_key]

	if not context_value then
		Log.error("LocalizationManager", "Missing context value for key %q in %s", context_key, string_key)

		format = "%s"
		context_value = string.format("\"%s:undefined\"", context_key)
	end

	if format == "" then
		return tostring(context_value)
	end

	local success, result = pcall(string.format, format, context_value)

	if success then
		return result
	else
		errors[#errors + 1] = string.format("string.format() failed on context.%s", context_key)

		return ""
	end
end

local _error_table = {}

LocalizationManager._process_string = function (self, key, raw_str, context)
	table.clear(_error_table)

	raw_str = string.gsub(raw_str, "%$([%a%d_]*):*([%a%d,_]*)%$", callback(_apply_macro_callback, key, _error_table))
	raw_str = string.gsub(raw_str, "{([%a%d_]*):*([%a%d%.%%]*)}", callback(_apply_interpolation_callback, key, _error_table, context))

	local error_string = #_error_table > 0 and table.concat(_error_table, "; ") or nil

	return raw_str, error_string
end

LocalizationManager.exists = function (self, key)
	return self:_lookup(key) ~= nil
end

LocalizationManager.language = function (self)
	return self._language
end

return LocalizationManager
