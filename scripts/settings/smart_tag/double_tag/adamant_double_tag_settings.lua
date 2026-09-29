-- chunkname: @scripts/settings/smart_tag/double_tag/adamant_double_tag_settings.lua

local adamant_double_tag_settings = {
	resolve = function (tagger_unit, target_unit, target_type)
		if target_type ~= "breed" then
			return nil
		end

		local companion_spawner_extension = ScriptUnit.has_extension(tagger_unit, "companion_spawner_system")
		local companions = companion_spawner_extension and companion_spawner_extension:companion_units()

		if companions and #companions > 0 then
			return "enemy_companion_target"
		end

		return nil
	end,
}

return adamant_double_tag_settings
