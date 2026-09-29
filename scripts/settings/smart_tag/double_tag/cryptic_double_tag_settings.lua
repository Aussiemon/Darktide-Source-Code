-- chunkname: @scripts/settings/smart_tag/double_tag/cryptic_double_tag_settings.lua

local cryptic_double_tag_settings = {
	resolve = function (tagger_unit, target_unit, target_type)
		local companion_spawner_extension = ScriptUnit.has_extension(tagger_unit, "companion_spawner_system")
		local companions = companion_spawner_extension and companion_spawner_extension:companion_units()

		if not companions or #companions == 0 then
			return nil
		end

		if target_type == "breed" then
			return "servo_skull_enemy_companion_target"
		end

		if target_type == "hack" then
			local interactee_extension = ScriptUnit.has_extension(target_unit, "interactee_system")

			if not interactee_extension then
				return nil
			end

			local interactee_interaction_type = interactee_extension:interaction_type()

			if interactee_interaction_type ~= "decoding" then
				return nil
			end

			local can_interact = interactee_extension:can_interact(target_unit, interactee_interaction_type)

			if can_interact then
				return "hacking_over_here_companion"
			end
		end

		return nil
	end,
}

return cryptic_double_tag_settings
