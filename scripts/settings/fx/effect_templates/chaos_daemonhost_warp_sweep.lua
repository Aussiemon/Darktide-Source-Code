-- chunkname: @scripts/settings/fx/effect_templates/chaos_daemonhost_warp_sweep.lua

local NODE_NAME_1 = "j_lefthand"
local NODE_NAME_2 = "j_righthand"
local VFX = "content/fx/particles/enemies/daemonhost/daemonhost_backhand_trail"
local MATERIAL = "body"
local EMISSIVE = {
	scalar_values = {
		face_intensity = 1,
		l_hand_intensity = 1
	},
	durations = {
		out = 1,
		to = 0.5,
		total = 1.8333333333333333
	}
}
local resources = {
	vfx = VFX
}

local function _start_vfx(position, node, template_data, template_context)
	local unit = template_data.unit
	local world = template_context.world
	local vfx_particle_id = World.create_particles(world, VFX, position, Quaternion.identity())

	World.link_particles(world, vfx_particle_id, unit, node, Matrix4x4.identity(), "destroy")

	return vfx_particle_id
end

local effect_template = {
	name = "chaos_daemonhost_warp_sweep",
	resources = resources,
	start = function (template_data, template_context)
		if DEDICATED_SERVER then
			return
		end

		local unit = template_data.unit
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local body_slot_unit = visual_loadout_extension:slot_unit("slot_body")

		template_data.body_slot_unit = body_slot_unit

		local node_1 = Unit.node(unit, NODE_NAME_1)
		local position_1 = Unit.world_position(unit, node_1)
		local particle_id_1 = _start_vfx(position_1, node_1, template_data, template_context)

		template_data.vfx_particle_id_1 = particle_id_1

		local node_2 = Unit.node(unit, NODE_NAME_2)
		local position_2 = Unit.world_position(unit, node_2)
		local particle_id_2 = _start_vfx(position_2, node_2, template_data, template_context)

		template_data.vfx_particle_id_2 = particle_id_2

		local t = Managers.time:time("gameplay")
		local durations = EMISSIVE.durations

		template_data.effect_out_t = t + durations.out
		template_data.effect_t = 0
	end,
	update = function (template_data, template_context, dt, t)
		if DEDICATED_SERVER then
			return
		end

		local effect_out_t = template_data.effect_out_t
		local effect_t = template_data.effect_t + dt

		template_data.effect_t = effect_t

		local body_slot_unit = template_data.body_slot_unit
		local durations = EMISSIVE.durations
		local to = durations.to
		local total = durations.total
		local scalar_values = EMISSIVE.scalar_values

		for scalar_key, intensity in pairs(scalar_values) do
			local lerp_value

			if effect_out_t < t then
				lerp_value = math.lerp(intensity, 0, effect_t / total)
			else
				lerp_value = math.lerp(0, intensity, effect_t / to)
			end

			local clamped_intensity = math.clamp(lerp_value, 0, 1)

			Unit.set_scalar_for_material(body_slot_unit, MATERIAL, scalar_key, clamped_intensity)
		end
	end,
	stop = function (template_data, template_context)
		if DEDICATED_SERVER then
			return
		end

		local world = template_context.world
		local vfx_particle_id_1 = template_data.vfx_particle_id_1

		World.stop_spawning_particles(world, vfx_particle_id_1)

		local vfx_particle_id_2 = template_data.vfx_particle_id_2

		World.stop_spawning_particles(world, vfx_particle_id_2)

		local body_slot_unit = template_data.body_slot_unit

		if ALIVE[body_slot_unit] then
			local scalar_values = EMISSIVE.scalar_values

			for scalar_key, _ in pairs(scalar_values) do
				Unit.set_scalar_for_material(body_slot_unit, MATERIAL, scalar_key, 0)
			end
		end
	end
}

return effect_template
