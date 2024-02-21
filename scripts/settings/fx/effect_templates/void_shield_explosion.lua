local SHIELD_INVENTORY_SLOT_NAME = "slot_fx_void_shield"
local EXPLOSION_WOBBLE_MATERIAL_KEY = "size_wobble"
local SHIELD_EXPLOSION_VFX = "content/fx/particles/enemies/renegade_captain/renegade_captain_aoe_push"
local SHIELD_EXPLOSION_SFX = "wwise/events/minions/play_traitor_captain_shield_overload"
local _set_shield_wobble = nil
local resources = {
	shield_explosion_vfx = SHIELD_EXPLOSION_VFX,
	shield_explosion_sfx = SHIELD_EXPLOSION_SFX
}
local effect_template = {
	name = "void_shield_explosion",
	resources = resources,
	start = function (template_data, template_context)
		if DEDICATED_SERVER then
			return
		end

		local unit = template_data.unit
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local shield_unit = visual_loadout_extension:slot_unit(SHIELD_INVENTORY_SLOT_NAME)
		template_data.shield_unit = shield_unit
		local j_hips_node = Unit.node(unit, "j_hips")
		local position = Unit.world_position(unit, j_hips_node)
		local wwise_world = template_context.wwise_world
		local source_id = WwiseWorld.make_manual_source(wwise_world, position, Quaternion.identity())

		WwiseWorld.trigger_resource_event(wwise_world, SHIELD_EXPLOSION_SFX, source_id)

		template_data.source_id = source_id
		local world = template_context.world

		World.create_particles(world, SHIELD_EXPLOSION_VFX, position)
		_set_shield_wobble(shield_unit, 1)
	end,
	update = function (template_data, template_context, dt, t)
		return
	end,
	stop = function (template_data, template_context)
		if DEDICATED_SERVER then
			return
		end

		local shield_unit = template_data.shield_unit

		if Unit.alive(shield_unit) then
			_set_shield_wobble(shield_unit, 0)
		end

		local wwise_world = template_context.wwise_world
		local source_id = template_data.source_id

		WwiseWorld.destroy_manual_source(wwise_world, source_id)
	end
}

function _set_shield_wobble(shield_unit, wobble_amount)
	local include_children = true

	Unit.set_scalar_for_materials(shield_unit, EXPLOSION_WOBBLE_MATERIAL_KEY, wobble_amount, include_children)
end

return effect_template
