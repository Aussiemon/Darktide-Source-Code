-- chunkname: @scripts/settings/fx/effect_templates/minion_stim_effect.lua

local MasterItems = require("scripts/backend/master_items")
local GRENADE_ITEM_NAME = "content/items/weapons/minions/ranged/minion_stim"
local resources = {
	grenade_item_name = GRENADE_ITEM_NAME,
}
local looping_sound_start_events = "wwise/events/player/play_syringe_power_start"
local looping_sound_stop_events = "wwise/events/player/play_syringe_power_stop"
local effect_template = {
	name = "minion_stim_effect",
	resources = resources,
	start = function (template_data, template_context)
		local unit, world = template_data.unit, template_context.world
		local item_definitions = MasterItems.get_cached()
		local grenade_item = item_definitions[GRENADE_ITEM_NAME]
		local base_unit_name = grenade_item.base_unit
		local grenade_unit = Managers.state.unit_spawner:spawn_unit(base_unit_name)
		local attach_node = grenade_item.wielded_attach_node
		local node = Unit.node(unit, attach_node)

		World.link_unit(world, grenade_unit, 1, unit, node)

		local j_hips_node = Unit.node(unit, "j_hips")
		local position = Unit.world_position(unit, j_hips_node)
		local wwise_world = template_context.wwise_world
		local source_id = WwiseWorld.make_manual_source(wwise_world, position, Quaternion.identity())

		WwiseWorld.trigger_resource_event(wwise_world, looping_sound_start_events, source_id)

		template_data.source_id = source_id
		template_data.grenade_unit = grenade_unit
	end,
	update = function (template_data, template_context, dt, t)
		return
	end,
	stop = function (template_data, template_context)
		local wwise_world = template_context.wwise_world
		local source_id = template_data.source_id

		WwiseWorld.trigger_resource_event(wwise_world, looping_sound_stop_events, source_id)
		WwiseWorld.destroy_manual_source(wwise_world, source_id)

		local grenade_unit = template_data.grenade_unit

		Managers.state.unit_spawner:mark_for_deletion(grenade_unit)
	end,
}

return effect_template
