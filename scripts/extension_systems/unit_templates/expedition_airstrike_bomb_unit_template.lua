-- chunkname: @scripts/extension_systems/unit_templates/expedition_airstrike_bomb_unit_template.lua

local UnitTemplate = require("scripts/extension_systems/unit_templates/utilities/unit_template")
local GAME_OBJECT_TYPE = "expedition_airstrike_bomb"
local expedition_airstrike_bomb_unit_template = {
	local_unit = function (unit_name, position, rotation, material, prop_settings, placed_on_unit, spawn_interaction_cooldown)
		unit_name = unit_name or prop_settings.unit_name

		return unit_name, position, rotation, material
	end,
	husk_unit = function (session, object_id)
		local unit_name = "content/environment/gameplay/valkyrie_bombs/valkyrie_bomb_01"
		local position, rotation = UnitTemplate.position_rotation_from_game_object(session, object_id)

		return unit_name, position, rotation
	end,
	game_object_type = function ()
		return GAME_OBJECT_TYPE
	end,
	local_init = function (unit, config, template_context, game_object_data, force_direction_boxed)
		config:add("ComponentExtension")
		config:parse_unit(unit)

		game_object_data.position = Unit.local_position(unit, 1)
		game_object_data.rotation = Unit.local_rotation(unit, 1)

		local force_direction = force_direction_boxed:unbox()

		game_object_data.force_direction = force_direction

		local actor = Unit.actor(unit, "c_simple")
		local mass = Unit.get_data(unit, "mass") or 1
		local speed = Unit.get_data(unit, "speed_on_hit") or 2

		Actor.add_impulse(actor, force_direction * mass * speed)
		Actor.add_angular_velocity(actor, force_direction * mass * speed)
	end,
	husk_init = function (unit, config, template_context, game_session, game_object_id, owner_id)
		config:add("ComponentExtension")
		config:parse_unit(unit)

		local force_direction = GameSession.game_object_field(game_session, game_object_id, "force_direction")
		local actor = Unit.actor(unit, "c_simple")
		local mass = Unit.get_data(unit, "mass") or 1
		local speed = Unit.get_data(unit, "speed_on_hit") or 2

		Actor.add_impulse(actor, force_direction * mass * speed)
		Actor.add_angular_velocity(actor, force_direction * mass * speed)
	end,
}

return expedition_airstrike_bomb_unit_template
