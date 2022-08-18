local MaterialQuery = require("scripts/utilities/material_query")
local Footstep = {
	trigger_material_footstep = function (sound_alias, wwise_world, physics_world, source_id, unit, node, query_from, query_to, optional_set_speed_parameter, optional_set_first_person_parameter)
		local hit, material, position, normal, hit_unit, hit_actor = MaterialQuery.query_material(physics_world, query_from, query_to, sound_alias)

		if hit and material then
			Unit.set_data(unit, "cache_material", material)
		end

		if not hit then
			local cached_material = Unit.get_data(unit, "cache_material")
			material = cached_material
		end

		local wwise_playing_id = nil

		if sound_alias then
			if not source_id or source_id == nil then
				source_id = WwiseWorld.make_auto_source(wwise_world, unit, node)
			end

			if material then
				WwiseWorld.set_switch(wwise_world, "surface_material", material, source_id)
			else
				WwiseWorld.set_switch(wwise_world, "surface_material", "default", source_id)
			end

			if optional_set_speed_parameter then
				local locomotion_ext = ScriptUnit.extension(unit, "locomotion_system")
				local move_speed = locomotion_ext:move_speed()

				WwiseWorld.set_source_parameter(wwise_world, source_id, "foley_speed", move_speed)
			end

			if optional_set_first_person_parameter then
				local first_person_extension = ScriptUnit.extension(unit, "first_person_system")
				local first_person_mode = first_person_extension:is_in_first_person_mode()
				local parameter_value = first_person_mode and 1 or 0

				WwiseWorld.set_source_parameter(wwise_world, source_id, "first_person_mode", parameter_value)
			end

			local fx_extension = ScriptUnit.extension(unit, "fx_system")
			local external_properties = nil
			wwise_playing_id = fx_extension:trigger_gear_wwise_event(sound_alias, external_properties, source_id)
		end

		if material == "water_puddle" or material == "water_deep" then
			material = "water"

			if ALIVE[unit] then
				Managers.state.world_interaction:add_world_interaction(material, unit)
			end
		end

		return wwise_playing_id
	end
}

return Footstep
