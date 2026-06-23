-- chunkname: @scripts/settings/fx/effect_templates/companion_servo_skull_heal_effect.lua

local CompanionServoSkullHealEffectSettings = require("scripts/settings/companion/companion_servo_skull_heal_effect_settings")
local CompanionVisualLoadout = require("scripts/utilities/companion_visual_loadout")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local vfx = CompanionServoSkullHealEffectSettings.vfx
local sfx = CompanionServoSkullHealEffectSettings.sfx
local stage_01_duration_t = 1
local stage_02_duration_t = 0.75
local stage_03_duration_t = 0.75
local resources = {
	resources_vfx = vfx,
	resources_sfx = sfx,
}
local effect_template = {
	name = "companion_servo_skull_heal_effect",
	resources = resources,
	start = function (template_data, template_context)
		local unit = template_data.unit
		local fx_extension = ScriptUnit.has_extension(unit, "fx_system")

		if not fx_extension then
			return
		end

		local fx_system = Managers.state.extension:system("fx_system")
		local visual_loadout_extension = ScriptUnit.extension(template_data.unit, "visual_loadout_system")

		template_data.fx_system = fx_system
		template_data.visual_loadout_extension = visual_loadout_extension

		local slot_name = CompanionServoSkullHealEffectSettings.inventory_slot
		local fx_source_name = sfx.source_name
		local lookup_fx_sources = false
		local inventory_item = visual_loadout_extension:slot_item(slot_name)
		local attachment_unit, node = MinionVisualLoadout.attachment_unit_and_node_from_node_name(inventory_item, fx_source_name, lookup_fx_sources)

		template_data.attachment_unit = attachment_unit
		template_data.attachment_node = node

		Unit.set_scalar_for_material(attachment_unit, "skull_medicae_vials", "stage_01", 0)
		Unit.set_scalar_for_material(attachment_unit, "skull_medicae_vials", "stage_02", 0)
		Unit.set_scalar_for_material(attachment_unit, "skull_medicae_vials", "stage_03", 0)

		template_data._stage_01 = 0
		template_data._stage_02 = 0
		template_data._stage_03 = 0

		local wwise_world = template_context.wwise_world
		local source_id = WwiseWorld.make_manual_source(wwise_world, attachment_unit, node)
		local playing_id, stop_event_name = CompanionVisualLoadout.trigger_looping_gear_sound(unit, source_id, sfx.sound_alias, sfx.profile_properties_switch)

		template_data.source_id = source_id
		template_data.playing_id = playing_id
		template_data.stop_event_name = stop_event_name

		local attachment_node = template_data.attachment_node
		local from_pos = Unit.world_position(attachment_unit, attachment_node)
		local unit_rotation = Unit.world_rotation(unit, 1)
		local direction = Vector3.normalize(from_pos + Quaternion.forward(unit_rotation) - from_pos)
		local rotation = Quaternion.look(direction)

		if vfx.heal_particle then
			local world = template_context.world
			local effect_id = World.create_particles(world, vfx.heal_particle, from_pos, rotation, nil, template_data.particle_group)

			template_data.stream_effect_id = effect_id
		end
	end,
	update = function (template_data, template_context, dt, t)
		local stage_01 = template_data._stage_01
		local stage_02 = template_data._stage_02
		local stage_03 = template_data._stage_03
		local attachment_unit = template_data.attachment_unit

		if stage_01 < 1 then
			stage_01 = math.clamp01(stage_01 + dt / stage_01_duration_t)
			template_data._stage_01 = stage_01

			Unit.set_scalar_for_material(attachment_unit, "skull_medicae_vials", "stage_01", stage_01)
		elseif stage_02 < 1 then
			stage_02 = math.clamp01(stage_02 + dt / stage_02_duration_t)
			template_data._stage_02 = stage_02

			Unit.set_scalar_for_material(attachment_unit, "skull_medicae_vials", "stage_02", stage_02)
		elseif stage_03 < 1 then
			stage_03 = math.clamp01(stage_03 + dt / stage_03_duration_t)
			template_data._stage_03 = stage_03

			Unit.set_scalar_for_material(attachment_unit, "skull_medicae_vials", "stage_03", stage_03)
		end
	end,
	stop = function (template_data, template_context)
		local world = template_context.world
		local wwise_world = template_context.wwise_world
		local stream_effect_id = template_data.stream_effect_id

		if stream_effect_id then
			World.stop_spawning_particles(world, stream_effect_id)
		end

		local source_id = template_data.source_id
		local playing_id = template_data.playing_id
		local stop_event_name = template_data.stop_event_name

		if source_id and stop_event_name then
			WwiseWorld.trigger_resource_event(wwise_world, stop_event_name, source_id)
		elseif playing_id then
			WwiseWorld.stop_event(wwise_world, playing_id)
		end

		if source_id then
			WwiseWorld.destroy_manual_source(wwise_world, source_id)
		end

		local attachment_unit = template_data.attachment_unit

		Unit.set_scalar_for_material(attachment_unit, "skull_medicae_vials", "stage_01", 0)
		Unit.set_scalar_for_material(attachment_unit, "skull_medicae_vials", "stage_02", 0)
		Unit.set_scalar_for_material(attachment_unit, "skull_medicae_vials", "stage_03", 0)

		template_data.source_id = nil
		template_data.playing_id = nil
		template_data.stop_event_name = nil
	end,
}

return effect_template
