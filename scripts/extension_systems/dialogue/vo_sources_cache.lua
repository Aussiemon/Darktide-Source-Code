local DialogueSettings = require("scripts/settings/dialogue/dialogue_settings")
local VOSourcesCache = class("VOSourcesCache")

VOSourcesCache.init = function (self)
	self._vo_sources = {}
	self._default_voice_template = "empty_voice_template"
	self._rule_files_loaded = {}
end

VOSourcesCache.add_rule_file = function (self, rule_file_name)
	if table.contains(self._rule_files_loaded, rule_file_name) then
		return
	end

	self._rule_files_loaded[rule_file_name] = true

	for voice_template, _ in pairs(self._vo_sources) do
		local vo_source_target = DialogueSettings.default_voSources_path .. rule_file_name .. "_" .. voice_template

		if Application.can_get_resource("lua", vo_source_target) then
			table.merge(self._vo_sources[voice_template], require(vo_source_target))
		end
	end
end

VOSourcesCache.get_vo_source = function (self, voice_template)
	fassert(voice_template, "VOSourcesCache: must be a string and can't be nil")
	Log.debug("VOSourcesCache", "voice_template %s requested", voice_template)

	if self._vo_sources[voice_template] ~= nil then
		return self._vo_sources[voice_template]
	end

	self._vo_sources[voice_template] = {}

	for rule_file, _ in pairs(self._rule_files_loaded) do
		local vo_sources_target = DialogueSettings.default_voSources_path .. rule_file .. "_" .. voice_template

		if Application.can_get_resource("lua", vo_sources_target) then
			table.merge(self._vo_sources[voice_template], require(vo_sources_target))
		end
	end

	return self._vo_sources[voice_template]
end

VOSourcesCache.get_default_voice_profile = function (self)
	return self._default_voice_template, self:get_vo_source(self._default_voice_template)
end

VOSourcesCache.destroy = function (self)
	self._vo_sources = nil
	self._default_voice_template = nil
	self._rule_files_loaded = nil
end

return VOSourcesCache
