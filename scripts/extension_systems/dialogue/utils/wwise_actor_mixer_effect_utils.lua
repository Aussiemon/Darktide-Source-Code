-- chunkname: @scripts/extension_systems/dialogue/utils/wwise_actor_mixer_effect_utils.lua

local WwiseActorMixerEffectSettings = require("scripts/settings/dialogue/wwise_actor_mixer_effect_settings")
local WwiseActorMixerEffect = {}

WwiseActorMixerEffect.apply_preset = function (preset_name)
	local preset = WwiseActorMixerEffectSettings.presets[preset_name]

	if not preset then
		Log.error("WwiseActorMixerEffect", "Preset %q not found", preset_name)

		return false
	end

	local node_id = WwiseActorMixerEffectSettings.nodes.first_person

	for slot_name, effect_name in pairs(preset) do
		local slot_index = WwiseActorMixerEffectSettings.slots[slot_name]
		local effect_id = WwiseActorMixerEffectSettings.effects[effect_name]

		if not effect_id then
			Log.error("WwiseActorMixerEffect", "Error: Effect %q not found", effect_name)

			return false
		end

		Wwise.set_actor_mixer_effect(node_id, slot_index, Wwise.WWISE_INVALID_UNIQUE_ID)
		Wwise.set_actor_mixer_effect(node_id, slot_index, effect_id)
	end

	Wwise.set_actor_mixer_effect(node_id, WwiseActorMixerEffectSettings.slots.slot_3, Wwise.WWISE_INVALID_UNIQUE_ID)

	node_id = WwiseActorMixerEffectSettings.nodes.third_person

	for slot_name, effect_name in pairs(preset) do
		local slot_index = WwiseActorMixerEffectSettings.slots[slot_name]
		local effect_id = WwiseActorMixerEffectSettings.effects[effect_name]

		if not effect_id then
			Log.error("WwiseActorMixerEffect", "Error: Effect %q not found", effect_name)

			return false
		end

		Wwise.set_actor_mixer_effect(node_id, slot_index, Wwise.WWISE_INVALID_UNIQUE_ID)
		Wwise.set_actor_mixer_effect(node_id, slot_index, effect_id)
	end

	Wwise.set_actor_mixer_effect(node_id, WwiseActorMixerEffectSettings.slots.slot_3, Wwise.WWISE_INVALID_UNIQUE_ID)
	Wwise.set_actor_mixer_effect(node_id, WwiseActorMixerEffectSettings.slots.slot_3, WwiseActorMixerEffectSettings.effects.radio)

	return true
end

WwiseActorMixerEffect.clear_effects = function ()
	for slot_index = 0, 2 do
		Wwise.set_actor_mixer_effect(WwiseActorMixerEffectSettings.nodes.first_person, slot_index, Wwise.WWISE_INVALID_UNIQUE_ID)
		Wwise.set_actor_mixer_effect(WwiseActorMixerEffectSettings.nodes.third_person, slot_index, Wwise.WWISE_INVALID_UNIQUE_ID)
	end

	Wwise.set_actor_mixer_effect(WwiseActorMixerEffectSettings.nodes.first_person, 3, Wwise.WWISE_INVALID_UNIQUE_ID)
	Wwise.set_actor_mixer_effect(WwiseActorMixerEffectSettings.nodes.third_person, 3, WwiseActorMixerEffectSettings.effects.radio)
end

WwiseActorMixerEffect.preset_exists = function (preset_name)
	local preset = WwiseActorMixerEffectSettings.presets[preset_name]

	return preset ~= nil
end

WwiseActorMixerEffect.get_presets_list = function ()
	local presets_list = {}

	for preset_name, _ in pairs(WwiseActorMixerEffectSettings.presets) do
		table.insert(presets_list, preset_name)
	end

	return presets_list
end

return WwiseActorMixerEffect
