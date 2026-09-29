-- chunkname: @scripts/settings/fx/effect_templates/renegade_psyker_boss_circle_dance.lua

local RenegadeWizardActions = require("scripts/settings/breed/breed_actions/renegade/renegade_wizard_actions")
local names = {
	"first_ring",
	"second_ring",
	"third_ring",
	"fourth_ring",
}
local _dance_action = RenegadeWizardActions.dance
local _dance_event = _dance_action.anim_event[1]
local _dance_delay = _dance_action.delay
local _dance_damage_t = _dance_action.anim_damage_timings[_dance_event]
local _dance_clip_t = _dance_action.anim_duration[_dance_event]
local _dance_window = _dance_delay + _dance_clip_t
local _dance_damage_fraction = (_dance_delay + _dance_damage_t) / _dance_window
local DAMAGE_VFX_EARLY_CUTOFF = 0.7
local _damage_vfx_cutoff_t = math.max(_dance_window - DAMAGE_VFX_EARLY_CUTOFF, 0)
local RING_UNIT_NAME = "content/fx/units/enemies/renegade_wizard/decal_wizard_nurgle_ring_01"
local RING_MATERIAL_SLOT = "decal"
local RING_MATERIALS = {
	"content/fx/materials/decals/fx_decal_wizard_ring_nurgle_01",
	"content/fx/materials/decals/fx_decal_wizard_ring_nurgle_02",
	"content/fx/materials/decals/fx_decal_wizard_ring_nurgle_03",
	"content/fx/materials/decals/fx_decal_wizard_ring_nurgle_04",
}
local BOSS_STATIC_RING = "content/fx/particles/enemies/renegade_wizard/renegade_wizard_ring_damage_center"
local BOSS_STATIC_RING_CLOUD = "decal_ring_center"
local BOSS_STATIC_RING_MATERIAL_SLOT = "decal"
local BOSS_STATIC_RING_RAMP_IN_T = _dance_delay + _dance_damage_t
local RING_Z_OFFSET = 0.1
local RING_SCALES = {
	{
		16.8,
		16.8,
		2,
	},
	{
		27.8,
		27.8,
		2,
	},
	{
		39,
		39,
		2,
	},
	{
		50.5,
		50.5,
		2,
	},
}
local DAMAGE_VFX = {
	"content/fx/particles/enemies/renegade_wizard/renegade_wizard_ring_damage_slice_01",
	"content/fx/particles/enemies/renegade_wizard/renegade_wizard_ring_damage_slice_02",
	"content/fx/particles/enemies/renegade_wizard/renegade_wizard_ring_damage_slice_03",
	"content/fx/particles/enemies/renegade_wizard/renegade_wizard_ring_damage_slice_04",
}
local resources = {
	resources_vfx = {
		"content/fx/particles/enemies/renegade_wizard/renegade_wizard_ring_damage_slice_01",
		"content/fx/particles/enemies/renegade_wizard/renegade_wizard_ring_damage_slice_02",
		"content/fx/particles/enemies/renegade_wizard/renegade_wizard_ring_damage_slice_03",
		"content/fx/particles/enemies/renegade_wizard/renegade_wizard_ring_damage_slice_04",
		"content/fx/particles/enemies/renegade_wizard/renegade_wizard_ring_damage_center",
	},
	resources_sfx = {
		"wwise/events/minions/play_enemy_psyker_area_wave",
	},
}
local NUM_VFX_SLICES = 36
local SLICE_ANGLE = 360 / NUM_VFX_SLICES
local SFX = {
	"wwise/events/minions/play_enemy_psyker_area_wave",
}
local GOOP_UNIT = {
	default_value = 1.422,
	target_value = 0,
	unit_name = "cauldron_01_spill_01",
	variable = "emissive",
}
local RING_ERODE = {
	off = 1,
	on = 0,
	var_name = "ring_erode",
	ramp_in = _dance_damage_fraction,
	ramp_out = math.min(_dance_damage_fraction + 0.1, 1),
}
local SFX_SOURCE_RADIUS = 10
local SFX_SOURCE_OFFSETS = {
	{
		SFX_SOURCE_RADIUS,
		0,
	},
	{
		-SFX_SOURCE_RADIUS,
		0,
	},
	{
		0,
		SFX_SOURCE_RADIUS,
	},
	{
		0,
		-SFX_SOURCE_RADIUS,
	},
}
local DMG_EFFECT_IDS = {}
local DISSOLVE_T = 1.5

local function _dissolve_floor_goop(template_data, reversed, dt)
	local circle_unit = template_data.circle_unit
	local world = Unit.world(circle_unit)

	if not template_data.goop_unit then
		template_data.goop_unit = World.unit_by_name(world, GOOP_UNIT.unit_name)
	elseif template_data.goop_unit then
		if not reversed then
			local direction = 1
			local dissolve_t = math.clamp(template_data.dissolve_t + direction * dt / DISSOLVE_T, 0, 1)
			local scalar = math.lerp(GOOP_UNIT.default_value, GOOP_UNIT.target_value, dissolve_t)

			template_data.dissolve_t = dissolve_t

			Unit.set_scalar_for_materials(template_data.goop_unit, GOOP_UNIT.variable, scalar, true)
		else
			Unit.set_scalar_for_materials(template_data.goop_unit, GOOP_UNIT.variable, GOOP_UNIT.default_value, true)
		end
	end
end

local function _update_ring_scalar(template_data, dt, t, safe_zone)
	local ring_units = template_data.ring_units

	if not ring_units then
		return
	end

	if not safe_zone or safe_zone <= 0 then
		return
	end

	if not template_data.ring_scalar_setup then
		template_data.ring_scalar_start = t
		template_data.ring_scalar_setup = true
	end

	local progress = math.clamp((t - template_data.ring_scalar_start) / _dance_window, 0, 1)
	local erode

	if progress < RING_ERODE.ramp_in then
		erode = math.lerp(RING_ERODE.off, RING_ERODE.on, progress / RING_ERODE.ramp_in)
	elseif progress < RING_ERODE.ramp_out then
		erode = RING_ERODE.on
	else
		local ramp_out_t = (progress - RING_ERODE.ramp_out) / (1 - RING_ERODE.ramp_out)

		erode = math.lerp(RING_ERODE.on, RING_ERODE.off, ramp_out_t)
	end

	for i = 1, #ring_units do
		local ring_unit = ring_units[i]

		if Unit.alive(ring_unit) then
			local value = i == safe_zone and RING_ERODE.off or erode

			Unit.set_scalar_for_materials(ring_unit, RING_ERODE.var_name, value, true)
		end
	end
end

local function _update_static_ring(template_data, t)
	local effect_id = template_data.static_ring_effect_id

	if not effect_id then
		return
	end

	local circle_unit = template_data.circle_unit
	local world = Unit.world(circle_unit)
	local material = template_data.static_ring_material

	if not material then
		local mesh = World.get_particles_mesh(world, effect_id, BOSS_STATIC_RING_CLOUD)

		if not mesh then
			return
		end

		material = Mesh.material(mesh, BOSS_STATIC_RING_MATERIAL_SLOT)
		template_data.static_ring_material = material

		Material.set_scalar(material, RING_ERODE.var_name, RING_ERODE.off)
	end

	if not template_data.static_ring_start then
		template_data.static_ring_start = t
	end

	local progress = math.clamp((t - template_data.static_ring_start) / BOSS_STATIC_RING_RAMP_IN_T, 0, 1)
	local erode = math.lerp(RING_ERODE.off, RING_ERODE.on, progress)

	Material.set_scalar(material, RING_ERODE.var_name, erode)
end

local function _setup(template_data, template_context, safe_zone)
	local circle_unit = template_data.circle_unit

	if template_data.dance_vfx_init then
		template_data.dance_vfx_init = nil
	end

	for i = 1, #names do
		Unit.set_visibility(circle_unit, names[i], false, true)
	end
end

local effect_template = {
	name = "renegade_psyker_boss_circle_dance",
	resources = resources,
	start = function (template_data, template_context)
		local unit = template_data.unit
		local game_object_id = Managers.state.unit_spawner:game_object_id(unit)

		template_data.game_object_id = game_object_id

		local game_session = template_context.game_session
		local center_position = GameSession.game_object_field(game_session, game_object_id, "center_position")
		local circle_unit = Managers.state.unit_spawner:spawn_unit("content/characters/enemy/shared/psyker_boss_circle/psyker_boss_circle", center_position + Vector3(0, 0, 5))

		template_data.circle_unit = circle_unit
		template_data.damage_vfx_played = false
		template_data.dissolve_t = 0

		if not DEDICATED_SERVER then
			local world = Unit.world(circle_unit)
			local ring_units = {}
			local ring_position = center_position + Vector3(0, 0, RING_Z_OFFSET)

			for i = 1, #names do
				local ring_unit = World.spawn_unit_ex(world, RING_UNIT_NAME, nil, ring_position)

				if i > 1 then
					Unit.set_material(ring_unit, RING_MATERIAL_SLOT, RING_MATERIALS[i])
				end

				local scale = RING_SCALES[i]

				Unit.set_local_scale(ring_unit, 1, Vector3(scale[1], scale[2], scale[3]))
				Unit.set_scalar_for_materials(ring_unit, RING_ERODE.var_name, RING_ERODE.off, true)

				ring_units[i] = ring_unit
			end

			template_data.ring_units = ring_units

			local static_ring_effect_id = World.create_particles(world, BOSS_STATIC_RING, ring_position)

			template_data.static_ring_effect_id = static_ring_effect_id
		end
	end,
	update = function (template_data, template_context, dt, t)
		local game_object_id = template_data.game_object_id
		local game_session = template_context.game_session
		local safe_zone = GameSession.game_object_field(game_session, game_object_id, "safe_zone")

		if safe_zone > 0 and safe_zone <= #names and not template_data.setup_complete then
			template_data.safe_zone = safe_zone

			_setup(template_data, template_context, safe_zone)

			template_data.setup_complete = true
			template_data.ring_scalar_setup = false
		end

		if not DEDICATED_SERVER then
			_dissolve_floor_goop(template_data, false, dt)
			_update_ring_scalar(template_data, dt, t, safe_zone)
			_update_static_ring(template_data, t)
		end

		local should_play_damage_vfx = GameSession.game_object_field(game_session, game_object_id, "should_play_damage_vfx")
		local ring_scalar_start = template_data.ring_scalar_start

		if ring_scalar_start and t - ring_scalar_start >= _damage_vfx_cutoff_t then
			should_play_damage_vfx = false
		end

		if should_play_damage_vfx then
			if not DEDICATED_SERVER and not template_data.dance_vfx_init then
				template_data.dance_vfx_init = true

				local circle_unit = template_data.circle_unit
				local world = Unit.world(circle_unit)
				local center_position = GameSession.game_object_field(game_session, game_object_id, "center_position")

				for i = 1, #names do
					if i ~= safe_zone then
						local unit_position = center_position + Vector3(0, 0, 0.5)

						for j = 1, NUM_VFX_SLICES do
							local rotation = Quaternion.from_euler_angles_xyz(0, 0, SLICE_ANGLE * j)
							local effect_id = World.create_particles(world, DAMAGE_VFX[i], unit_position, rotation)

							DMG_EFFECT_IDS[#DMG_EFFECT_IDS + 1] = effect_id
						end
					end
				end

				local wwise_world = template_context.wwise_world

				for i = 1, #SFX_SOURCE_OFFSETS do
					local offset = SFX_SOURCE_OFFSETS[i]
					local source_position = center_position + Vector3(offset[1], offset[2], 0.5)
					local source_id = WwiseWorld.make_auto_source(wwise_world, source_position, Quaternion.identity())

					WwiseWorld.trigger_resource_event(wwise_world, SFX[1], source_id)
				end
			end
		elseif not should_play_damage_vfx and #DMG_EFFECT_IDS > 0 then
			for i = 1, #DMG_EFFECT_IDS do
				local effect_id = DMG_EFFECT_IDS[i]
				local circle_unit = template_data.circle_unit
				local world = Unit.world(circle_unit)

				World.stop_spawning_particles(world, effect_id)
			end

			table.clear(DMG_EFFECT_IDS)
		end

		if template_data.setup_complete and template_data.safe_zone ~= safe_zone then
			template_data.setup_complete = false
		end
	end,
	stop = function (template_data, template_context)
		_dissolve_floor_goop(template_data, true, nil)

		if #DMG_EFFECT_IDS > 0 then
			for i = 1, #DMG_EFFECT_IDS do
				local effect_id = DMG_EFFECT_IDS[i]
				local circle_unit = template_data.circle_unit
				local world = Unit.world(circle_unit)

				World.stop_spawning_particles(world, effect_id)
			end

			table.clear(DMG_EFFECT_IDS)
		end

		local circle_unit = template_data.circle_unit
		local world = Unit.world(circle_unit)
		local static_ring_effect_id = template_data.static_ring_effect_id

		if static_ring_effect_id then
			local static_ring_material = template_data.static_ring_material

			if static_ring_material then
				Material.set_scalar(static_ring_material, RING_ERODE.var_name, RING_ERODE.off)
			end

			World.stop_spawning_particles(world, static_ring_effect_id)

			template_data.static_ring_effect_id = nil
			template_data.static_ring_material = nil
		end

		local ring_units = template_data.ring_units

		if ring_units then
			for i = 1, #ring_units do
				local ring_unit = ring_units[i]

				if Unit.alive(ring_unit) then
					World.destroy_unit(world, ring_unit)
				end
			end

			template_data.ring_units = nil
		end

		World.unlink_unit(world, circle_unit)
		World.destroy_unit(world, circle_unit)
	end,
}

return effect_template
