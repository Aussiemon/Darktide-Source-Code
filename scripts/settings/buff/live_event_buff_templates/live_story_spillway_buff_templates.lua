-- chunkname: @scripts/settings/buff/live_event_buff_templates/live_story_spillway_buff_templates.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local buff_proc_events = BuffSettings.proc_events
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_targets = BuffSettings.targets
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local templates = {}

table.make_unique(templates)

local SHIELD_POOL = 1200
local DAMAGE_REDUCTION = -0.7
local RECONSTRUCT = 1 / (1 + DAMAGE_REDUCTION)
local SHIELD_TINT = {
	0.35,
	0.02,
	0.05,
}
local NO_TINT = {
	0,
	0,
	0,
}
local SHIELD_VFX = "content/fx/particles/enemies/spillway_mini_campaign_toxgas_shield"
local SHIELD_VFX_NODE = "j_spine"
local BURST_EXPLOSION = ExplosionTemplates.live_story_spillway_void_shield_burst

local function _set_tint(unit, color)
	Unit.set_vector3_for_materials(unit, "stimmed_color", Vector3(color[1], color[2], color[3]), true)
end

local function _set_shield_vfx(template_data, template_context, enabled)
	local world = template_context.world

	if enabled then
		if template_data.vfx_id then
			return
		end

		local unit = template_context.unit
		local node = template_data.vfx_node
		local particle_id = World.create_particles(world, SHIELD_VFX, Unit.world_position(unit, node))

		World.link_particles(world, particle_id, unit, node, Matrix4x4.identity(), "destroy")

		template_data.vfx_id = particle_id
	elseif template_data.vfx_id then
		World.destroy_particles(world, template_data.vfx_id)

		template_data.vfx_id = nil
	end
end

templates.live_story_spillway_void_shield_buff = {
	class_name = "proc_buff",
	predicted = false,
	target = buff_targets.minion_only,
	proc_events = {
		[buff_proc_events.on_minion_damage_taken] = 1,
	},
	conditional_stat_buffs = {
		[buff_stat_buffs.unarmored_damage] = DAMAGE_REDUCTION,
		[buff_stat_buffs.armored_damage] = DAMAGE_REDUCTION,
		[buff_stat_buffs.resistant_damage] = DAMAGE_REDUCTION,
		[buff_stat_buffs.berserker_damage] = DAMAGE_REDUCTION,
		[buff_stat_buffs.super_armor_damage] = DAMAGE_REDUCTION,
		[buff_stat_buffs.disgustingly_resilient_damage] = DAMAGE_REDUCTION,
	},
	start_func = function (template_data, template_context)
		template_data.pool = SHIELD_POOL
		template_data.broken = false

		local unit = template_context.unit

		template_data.vfx_node = Unit.node(unit, SHIELD_VFX_NODE)

		_set_tint(unit, SHIELD_TINT)
		_set_shield_vfx(template_data, template_context, true)

		local position = Unit.world_position(unit, template_data.vfx_node)

		template_data.last_position = Vector3Box(position)
	end,
	update_func = function (template_data, template_context, dt, t, template)
		local unit = template_context.unit
		local current_position = Unit.world_position(unit, template_data.vfx_node)

		if current_position then
			template_data.last_position:store(current_position)
		end
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return not template_data.broken
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		template_data.pool = template_data.pool - params.damage_amount * RECONSTRUCT

		if template_data.pool <= 0 then
			template_data.broken = true
		end
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_data.broken or not HEALTH_ALIVE[template_context.unit]
	end,
	stop_func = function (template_data, template_context)
		local unit = template_context.unit

		_set_shield_vfx(template_data, template_context, false)

		if HEALTH_ALIVE[unit] then
			_set_tint(unit, NO_TINT)
		end

		if not template_context.is_server then
			return
		end

		local position = template_data.last_position:unbox()

		Explosion.create_explosion(template_context.world, template_context.physics_world, position, Quaternion.identity(), unit, BURST_EXPLOSION, DEFAULT_POWER_LEVEL, 1, nil)
	end,
}

return templates
