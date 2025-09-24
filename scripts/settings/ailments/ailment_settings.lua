-- chunkname: @scripts/settings/ailments/ailment_settings.lua

local ailment_settings = {}
local effects = table.enum("burning_fast", "burning_slow", "burning", "chain_lightning_ability", "chem_burning_fast", "chem_burning_slow", "chem_burning", "electrocution", "freezing_fast", "freezing_slow", "freezing", "gas_fast", "gas_slow", "gas", "stun", "warpfire", "bleedfire")

ailment_settings.effects = effects
ailment_settings.effect_templates = {
	[effects.burning_fast] = {
		duration = 1,
		offset_time = 0.5,
		material_textures = {
			{
				resource = "content/textures/ailment_masks/burn_mask_01",
				slot = "effect_mask",
			},
			{
				resource = "content/fx/textures/ramps/fire_ramp_01",
				slot = "effect_gradient",
			},
		},
	},
	[effects.bleedfire] = {
		duration = 2.5,
		offset_time = 1.2,
		material_textures = {
			{
				resource = "content/textures/ailment_masks/burn_mask_01",
				slot = "effect_mask",
			},
			{
				resource = "content/fx/textures/ramps/bleedfire_ramp_01",
				slot = "effect_gradient",
			},
		},
	},
	[effects.burning] = {
		duration = 2,
		offset_time = 1.2,
		material_textures = {
			{
				resource = "content/textures/ailment_masks/burn_mask_01",
				slot = "effect_mask",
			},
			{
				resource = "content/fx/textures/ramps/fire_ramp_01",
				slot = "effect_gradient",
			},
		},
	},
	[effects.burning_slow] = {
		duration = 4.5,
		offset_time = 1.2,
		material_textures = {
			{
				resource = "content/textures/ailment_masks/burn_mask_01",
				slot = "effect_mask",
			},
			{
				resource = "content/fx/textures/ramps/fire_ramp_01",
				slot = "effect_gradient",
			},
		},
	},
	[effects.chem_burning_fast] = {
		duration = 1,
		offset_time = 0.5,
		material_textures = {
			{
				resource = "content/textures/ailment_masks/burn_mask_01",
				slot = "effect_mask",
			},
			{
				resource = "content/fx/textures/ramps/green_ramp_01",
				slot = "effect_gradient",
			},
		},
	},
	[effects.chem_burning] = {
		duration = 2.3,
		offset_time = 1,
		material_textures = {
			{
				resource = "content/textures/ailment_masks/burn_mask_01",
				slot = "effect_mask",
			},
			{
				resource = "content/fx/textures/ramps/green_ramp_01",
				slot = "effect_gradient",
			},
		},
	},
	[effects.chem_burning_slow] = {
		duration = 4.5,
		offset_time = 1.2,
		material_textures = {
			{
				resource = "content/textures/ailment_masks/burn_mask_01",
				slot = "effect_mask",
			},
			{
				resource = "content/fx/textures/ramps/green_ramp_01",
				slot = "effect_gradient",
			},
		},
	},
	[effects.gas_fast] = {
		duration = 0.5,
		offset_time = 0.8,
		material_textures = {
			{
				resource = "content/textures/ailment_masks/gas_mask_01",
				slot = "effect_mask",
			},
			{
				resource = "content/fx/textures/ramps/green_ramp_01",
				slot = "effect_gradient",
			},
		},
	},
	[effects.gas] = {
		duration = 1.8,
		offset_time = 0.8,
		material_textures = {
			{
				resource = "content/textures/ailment_masks/gas_mask_01",
				slot = "effect_mask",
			},
			{
				resource = "content/fx/textures/ramps/green_ramp_01",
				slot = "effect_gradient",
			},
		},
	},
	[effects.gas_slow] = {
		duration = 6.5,
		offset_time = 0.8,
		material_textures = {
			{
				resource = "content/textures/ailment_masks/gas_mask_01",
				slot = "effect_mask",
			},
			{
				resource = "content/fx/textures/ramps/green_ramp_01",
				slot = "effect_gradient",
			},
		},
	},
	[effects.freezing_fast] = {
		duration = 1,
		offset_time = 0.5,
		material_textures = {
			{
				resource = "content/textures/ailment_masks/freeze_mask_01",
				slot = "effect_mask",
			},
			{
				resource = "content/fx/textures/ramps/freeze_ramp_01",
				slot = "effect_gradient",
			},
		},
	},
	[effects.freezing] = {
		duration = 2.5,
		offset_time = 0.5,
		material_textures = {
			{
				resource = "content/textures/ailment_masks/freeze_mask_01",
				slot = "effect_mask",
			},
			{
				resource = "content/fx/textures/ramps/freeze_ramp_01",
				slot = "effect_gradient",
			},
		},
	},
	[effects.freezing_slow] = {
		duration = 5.5,
		offset_time = 0.5,
		material_textures = {
			{
				resource = "content/textures/ailment_masks/freeze_mask_01",
				slot = "effect_mask",
			},
			{
				resource = "content/fx/textures/ramps/freeze_ramp_01",
				slot = "effect_gradient",
			},
		},
	},
	[effects.warpfire] = {
		duration = 2.5,
		offset_time = 1.2,
		material_textures = {
			{
				resource = "content/textures/ailment_masks/burn_mask_01",
				slot = "effect_mask",
			},
			{
				resource = "content/fx/textures/ramps/warp_ramp_controlled_01",
				slot = "effect_gradient",
			},
		},
	},
	[effects.electrocution] = {
		duration = 0.95,
		offset_time = 0.15,
		material_textures = {
			{
				resource = "content/textures/ailment_masks/burn_mask_01",
				slot = "effect_mask",
			},
			{
				resource = "content/fx/textures/ramps/thunder_ramp",
				slot = "effect_gradient",
			},
		},
	},
	[effects.chain_lightning_ability] = {
		duration = 0.95,
		offset_time = 0.15,
		material_textures = {
			{
				resource = "content/textures/ailment_masks/freeze_mask_01",
				slot = "effect_mask",
			},
			{
				resource = "content/fx/textures/ramps/protectorate_chainlightning_ramp_01",
				slot = "effect_gradient",
			},
		},
	},
	[effects.stun] = {
		duration = 1.95,
		offset_time = 0.2,
		material_textures = {
			{
				resource = "content/textures/ailment_masks/freeze_mask_01",
				slot = "effect_mask",
			},
			{
				resource = "content/fx/textures/ramps/metal_impact_ramp_01",
				slot = "effect_gradient",
			},
		},
	},
}

return settings("AilmentSettings", ailment_settings)
