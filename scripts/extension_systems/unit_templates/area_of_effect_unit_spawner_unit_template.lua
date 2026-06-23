-- chunkname: @scripts/extension_systems/unit_templates/area_of_effect_unit_spawner_unit_template.lua

local UnitTemplate = require("scripts/extension_systems/unit_templates/utilities/unit_template")
local GAME_OBJECT_TYPE = "area_of_effect_unit_spawner"
local area_of_effect_unit_spawner_unit_template = {
	local_unit = function (unit_name, position, rotation, material)
		return unit_name, position, rotation, material
	end,
	husk_unit = function (session, object_id)
		local unit_name = "content/empty_unit"
		local position, rotation = UnitTemplate.position_rotation_from_game_object(session, object_id)

		return unit_name, position, rotation
	end,
	game_object_type = function ()
		return GAME_OBJECT_TYPE
	end,
	local_init = function (unit, config, template_context, game_object_data, husk_unit_name, placed_on_unit, owner_unit, unit_template_parameters)
		local salvo_seed = math.random_seed()
		local aoe_template_name = unit_template_parameters.aoe_template_name

		config:add("AreaOfEffectUnitSpawnerExtension", {
			aoe_template_name = aoe_template_name,
			source_position = unit_template_parameters.source_position,
			salvo_seed = salvo_seed,
			owner_unit = owner_unit,
		})
		config:parse_unit(unit)

		local owner_game_object_id = owner_unit and Managers.state.unit_spawner:game_object_id(owner_unit) or NetworkConstants.invalid_game_object_id

		game_object_data.position = Unit.local_position(unit, 1)
		game_object_data.rotation = Unit.local_rotation(unit, 1)
		game_object_data.aoe_template_id = NetworkLookup.area_of_effect_unit_spawner_templates[aoe_template_name]
		game_object_data.salvo_seed = salvo_seed
		game_object_data.owner_unit_id = owner_game_object_id
	end,
	husk_init = function (unit, config, template_context, game_session, game_object_id, owner_id)
		local aoe_template_id = GameSession.game_object_field(game_session, game_object_id, "aoe_template_id")
		local aoe_template_name = NetworkLookup.area_of_effect_unit_spawner_templates[aoe_template_id]
		local salvo_seed = GameSession.game_object_field(game_session, game_object_id, "salvo_seed")
		local source_position = GameSession.game_object_field(game_session, game_object_id, "source_position")
		local owner_unit_id = GameSession.game_object_field(game_session, game_object_id, "owner_unit_id")
		local owner_unit

		if owner_unit_id ~= NetworkConstants.invalid_game_object_id then
			owner_unit = Managers.state.unit_spawner:unit(owner_unit_id)
		end

		config:add("AreaOfEffectUnitSpawnerExtension", {
			aoe_template_name = aoe_template_name,
			source_position = source_position,
			salvo_seed = salvo_seed,
			owner_unit = owner_unit,
		})
		config:parse_unit(unit)
	end,
}

return area_of_effect_unit_spawner_unit_template
