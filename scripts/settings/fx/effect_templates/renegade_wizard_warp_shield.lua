-- chunkname: @scripts/settings/fx/effect_templates/renegade_wizard_warp_shield.lua

local SHIELD_INVENTORY_SLOT_NAME = "slot_fx_void_shield"
local FLY_VFX = "content/fx/particles/enemies/renegade_wizard/renegade_wizard_shield_loop"
local DISSOLVE_T = 0.7
local SHIELD_STATES = {
	on = QuaternionBox(0, 1, 0, 1),
	dissolved = QuaternionBox(1, 1, 0, 1),
	off = QuaternionBox(0, 0, 0, 0),
}
local SHIELD_INTENSITY_SCALAR = {
	off = 1,
	on = 0.2,
}
local OUTLINE_COLOR = {
	on = Vector3Box(0.04, 0.09, 0),
	off = Vector3Box(0, 0, 0),
}
local SHIELD_LIFE_SCALAR = {
	off = 0,
	on = 0,
}
local FLY_OPACITY = {
	off = 0,
	on = 1,
}
local FLY_CLOUDS = {
	"flies_base_cw",
	"flies_base_ccw",
}
local OUTLINE = "stimmed_color"
local FROM_AB_TO_CD = "material_variable_dabd86fe"
local INTENSITY = "material_variable"
local LIFE = "psyker_sphere_shield_life"
local OPACITY = "opacity"
local _get_network_values, _lerp_shield_state, _apply_shield_visuals
local effect_template = {
	name = "renegade_wizard_warp_shield",
	start = function (template_data, template_context)
		if DEDICATED_SERVER then
			return
		end

		local unit = template_data.unit
		local world = template_context.world
		local game_session, game_object_id = Managers.state.game_session:game_session(), Managers.state.unit_spawner:game_object_id(unit)

		template_data.game_session, template_data.game_object_id = game_session, game_object_id

		local breed = ScriptUnit.extension(unit, "unit_data_system"):breed()

		template_data.breed = breed

		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local shield_unit = visual_loadout_extension:slot_unit(SHIELD_INVENTORY_SLOT_NAME)

		template_data.shield_unit = shield_unit

		local orphaned_policy = "stop"
		local node_1 = Unit.node(shield_unit, "root_node")
		local unit_position = Unit.world_position(unit, 1)
		local particle_id = World.create_particles(template_context.world, FLY_VFX, unit_position, nil, nil, nil)

		World.link_particles(world, particle_id, unit, node_1, Matrix4x4.identity(), orphaned_policy)

		template_data.fly_particle_id = particle_id

		local toughness_extension = ScriptUnit.extension(unit, "toughness_system")

		template_data.toughness_extension = toughness_extension

		local toughness_template = toughness_extension:toughness_templates()

		template_data.toughness_template = toughness_template

		local wwise_world = template_context.wwise_world
		local source_id = WwiseWorld.make_manual_source(wwise_world, unit)

		template_data.source_id = source_id
		template_data.dissolve_t = 0
	end,
	update = function (template_data, template_context, dt, t)
		if DEDICATED_SERVER then
			return
		end

		local game_session, game_object_id = template_data.game_session, template_data.game_object_id
		local toughness_damage, _, _, should_dissolve = _get_network_values(game_session, game_object_id, template_data.breed)

		if should_dissolve and toughness_damage == 0 then
			template_data.is_dissolving = true
		end

		if template_data.is_dissolving then
			local direction = should_dissolve and 1 or -1
			local dissolve_t = math.clamp(template_data.dissolve_t + direction * dt / DISSOLVE_T, 0, 1)
			local dissolve_t_changed = dissolve_t ~= template_data.dissolve_t

			template_data.dissolve_t = dissolve_t

			if dissolve_t_changed then
				local shield_unit = template_data.shield_unit
				local shield_value = _lerp_shield_state(SHIELD_STATES.on, SHIELD_STATES.dissolved, dissolve_t)
				local shield_intensity_scalar = math.lerp(SHIELD_INTENSITY_SCALAR.on, SHIELD_INTENSITY_SCALAR.off, dissolve_t)
				local shield_life_scalar = math.lerp(SHIELD_LIFE_SCALAR.on, SHIELD_LIFE_SCALAR.off, dissolve_t)
				local fly_opacity_scalar = math.lerp(FLY_OPACITY.on, FLY_OPACITY.off, dissolve_t)

				Unit.set_vector4_for_materials(shield_unit, FROM_AB_TO_CD, shield_value, true)
				Unit.set_scalar_for_materials(shield_unit, INTENSITY, shield_intensity_scalar, true)
				Unit.set_scalar_for_materials(shield_unit, LIFE, shield_life_scalar, true)

				local world = template_context.world
				local fly_particle_id = template_data.fly_particle_id

				for i = 1, #FLY_CLOUDS do
					World.set_particles_material_scalar(world, fly_particle_id, FLY_CLOUDS[i], OPACITY, fly_opacity_scalar)
				end
			end

			if not should_dissolve and dissolve_t <= 0 then
				template_data.is_dissolving = false
				template_data.shield_on = nil
			end

			return
		end

		local shield_on = toughness_damage == 0

		if template_data.shield_on ~= shield_on then
			template_data.shield_on = shield_on

			_apply_shield_visuals(template_data, template_context, shield_on)
		end
	end,
	stop = function (template_data, template_context)
		if DEDICATED_SERVER then
			return
		end

		Unit.set_vector4_for_materials(template_data.shield_unit, FROM_AB_TO_CD, SHIELD_STATES.off:unbox(), true)
		Unit.set_scalar_for_materials(template_data.shield_unit, INTENSITY, 0, true)
	end,
}

function _apply_shield_visuals(template_data, template_context, shield_on)
	local shield_unit = template_data.shield_unit
	local state_key = shield_on and "on" or "off"

	Unit.set_vector4_for_materials(shield_unit, FROM_AB_TO_CD, SHIELD_STATES[state_key]:unbox(), true)
	Unit.set_scalar_for_materials(shield_unit, INTENSITY, SHIELD_INTENSITY_SCALAR[state_key], true)
	Unit.set_vector3_for_materials_in_unit_and_childs(template_data.unit, OUTLINE, OUTLINE_COLOR[state_key]:unbox())

	local world = template_context.world
	local fly_opacity = FLY_OPACITY[state_key]
	local fly_particle_id = template_data.fly_particle_id

	for i = 1, #FLY_CLOUDS do
		World.set_particles_material_scalar(world, fly_particle_id, FLY_CLOUDS[i], OPACITY, fly_opacity)
	end
end

function _lerp_shield_state(from_box, to_box, t_pct)
	local fx, fy, fz, fw = Quaternion.to_elements(from_box:unbox())
	local tx, ty, tz, tw = Quaternion.to_elements(to_box:unbox())

	return Quaternion.from_elements(math.lerp(fx, tx, t_pct), math.lerp(fy, ty, t_pct), math.lerp(fz, tz, t_pct), math.lerp(fw, tw, t_pct))
end

function _get_network_values(game_session, game_object_id, breed)
	local toughness_damage = GameSession.game_object_field(game_session, game_object_id, "toughness_damage")
	local max_toughness = GameSession.game_object_field(game_session, game_object_id, "toughness")
	local should_dissolve = GameSession.game_object_field(game_session, game_object_id, "dissolve_shield")
	local is_toughness_invulnerable = false

	if breed.can_have_invulnerable_toughness then
		is_toughness_invulnerable = GameSession.game_object_field(game_session, game_object_id, "is_toughness_invulnerable")
	end

	return toughness_damage, max_toughness, is_toughness_invulnerable, should_dissolve
end

return effect_template
