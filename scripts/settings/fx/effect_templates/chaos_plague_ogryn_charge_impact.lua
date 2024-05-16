-- chunkname: @scripts/settings/fx/effect_templates/chaos_plague_ogryn_charge_impact.lua

local SFX_ATTACK_VCE = "wwise/events/minions/play_enemy_plague_ogryn_vce_attack"
local SFX_BELLY_BOUNCE = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_belly_bounce"
local SFX_TONGUE_FLUTTER = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_tongue_flutter"
local SFX_IMPACT = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_player_impact"
local SFX_STOP_CHARGE_VCE = "wwise/events/minions/stop_enemy_plague_ogryn_vce_charge"
local SFX_START = {
	ap_voice = SFX_ATTACK_VCE,
	j_guts = SFX_BELLY_BOUNCE,
	j_tongue1 = SFX_TONGUE_FLUTTER,
	j_head = SFX_IMPACT,
}
local SFX_STOP = {
	ap_voice = SFX_STOP_CHARGE_VCE,
}
local resources = {
	sfx_attack_vce = SFX_ATTACK_VCE,
	sfx_belly_bounce = SFX_BELLY_BOUNCE,
	sfx_tongue_flutter = SFX_TONGUE_FLUTTER,
	sfx_impact = SFX_IMPACT,
	sfx_stop_charge = SFX_STOP_CHARGE_VCE,
}
local effect_template = {
	name = "chaos_plague_ogryn_charge_impact",
	resources = resources,
	start = function (template_data, template_context)
		local wwise_world = template_context.wwise_world
		local unit = template_data.unit

		for node_name, sfx_event in pairs(SFX_START) do
			local node = Unit.node(unit, node_name)
			local position = Unit.world_position(unit, node)
			local source_id = WwiseWorld.make_auto_source(wwise_world, position)

			WwiseWorld.trigger_resource_event(wwise_world, sfx_event, source_id)
		end

		for node_name, sfx_event in pairs(SFX_STOP) do
			local node = Unit.node(unit, node_name)
			local position = Unit.world_position(unit, node)
			local source_id = WwiseWorld.make_auto_source(wwise_world, position)

			WwiseWorld.trigger_resource_event(wwise_world, sfx_event, source_id)
		end
	end,
	update = function (template_data, template_context, dt, t)
		return
	end,
	stop = function (template_data, template_context)
		return
	end,
}

return effect_template
