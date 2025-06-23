-- chunkname: @scripts/settings/damage/impact_fx_injector.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local armor_hit_types = ArmorSettings.hit_types
local armor_types = ArmorSettings.types
local hit_effect_armor_type = ArmorSettings.hit_effect_types
local _inject_armor_impact_fx, _inject_surface_impact_fx, _inject_surface_decal_fx
local ImpactFxInjector = {}

ImpactFxInjector.inject = function (damage_type, fx_config)
	local armor_config = fx_config.armor

	if armor_config then
		_inject_armor_impact_fx(damage_type, armor_config)
	end

	local surface_config = fx_config.surface

	if surface_config then
		_inject_surface_impact_fx(damage_type, surface_config)
	end

	local surface_decal_config = fx_config.surface_decal

	if surface_decal_config then
		_inject_surface_decal_fx(damage_type, fx_config)
	end
end

function _inject_armor_impact_fx(damage_type, armor_config)
	local has_prop_armored_overrides = armor_config[hit_effect_armor_type.prop_armored] ~= nil

	if not has_prop_armored_overrides then
		armor_config[hit_effect_armor_type.prop_armored] = {
			sfx = {
				damage = {
					{
						event = "wwise/events/weapon/play_melee_hits_axe_light",
						append_husk_to_event_name = true
					},
					{
						event = "wwise/events/weapon/play_melee_hits_axe_armor",
						append_husk_to_event_name = true
					}
				},
				damage_reduced = {
					{
						event = "wwise/events/weapon/play_melee_hits_axe_light",
						append_husk_to_event_name = true
					},
					{
						event = "wwise/events/weapon/play_melee_hits_axe_armor",
						append_husk_to_event_name = true
					}
				},
				damage_negated = {
					{
						event = "wwise/events/weapon/melee_hits_blunt_no_damage",
						append_husk_to_event_name = true
					}
				}
			},
			vfx = {
				damage = {
					{
						effects = {
							"content/fx/particles/impacts/armor_penetrate"
						}
					},
					{
						effects = {
							"content/fx/particles/weapons/swords/chainsword/impact_metal_slash_01"
						}
					}
				},
				damage_reduced = {
					{
						effects = {
							"content/fx/particles/impacts/armor_penetrate"
						}
					},
					{
						effects = {
							"content/fx/particles/weapons/swords/chainsword/impact_metal_slash_01"
						}
					}
				},
				damage_negated = {
					{
						effects = {
							"content/fx/particles/impacts/damage_blocked"
						}
					},
					{
						effects = {
							"content/fx/particles/impacts/armor_ricochet"
						}
					}
				}
			}
		}
	else
		Log.info("ImpactFxInjector", "Found override for \"prop_armored\" impact fx on damage_type: %s", damage_type)
	end

	local has_prop_druglab_tank_overrides = armor_config[hit_effect_armor_type.prop_druglab_tank] ~= nil

	if not has_prop_druglab_tank_overrides then
		armor_config[hit_effect_armor_type.prop_druglab_tank] = {
			sfx = {
				damage = {
					{
						event = "wwise/events/weapon/play_melee_hits_axe_light",
						append_husk_to_event_name = true
					},
					{
						event = "wwise/events/weapon/play_melee_hits_axe_armor",
						append_husk_to_event_name = true
					}
				},
				damage_reduced = {
					{
						event = "wwise/events/weapon/play_melee_hits_axe_light",
						append_husk_to_event_name = true
					},
					{
						event = "wwise/events/weapon/play_melee_hits_axe_armor",
						append_husk_to_event_name = true
					}
				},
				damage_negated = {
					{
						event = "wwise/events/weapon/melee_hits_blunt_no_damage",
						append_husk_to_event_name = true
					}
				}
			},
			vfx = {
				damage = {
					{
						effects = {
							"content/fx/particles/impacts/armor_penetrate"
						}
					},
					{
						effects = {
							"content/fx/particles/weapons/swords/chainsword/impact_metal_slash_01"
						}
					},
					{
						effects = {
							"content/fx/particles/impacts/surfaces/impact_glass"
						}
					}
				},
				damage_reduced = {
					{
						effects = {
							"content/fx/particles/impacts/armor_penetrate"
						}
					},
					{
						effects = {
							"content/fx/particles/weapons/swords/chainsword/impact_metal_slash_01"
						}
					},
					{
						effects = {
							"content/fx/particles/impacts/surfaces/impact_glass"
						}
					}
				},
				damage_negated = {
					{
						effects = {
							"content/fx/particles/impacts/damage_blocked"
						}
					},
					{
						effects = {
							"content/fx/particles/impacts/armor_ricochet"
						}
					}
				}
			}
		}
	else
		Log.info("ImpactFxInjector", "Found override for \"prop_druglab_tank\" impact fx on damage_type: %s", damage_type)
	end

	local has_prop_ice_chunk_overrides = armor_config[hit_effect_armor_type.prop_ice_chunk] ~= nil

	if not has_prop_ice_chunk_overrides then
		armor_config[hit_effect_armor_type.prop_ice_chunk] = {
			sfx = {
				damage = {
					{
						event = "wwise/events/weapon/play_material_hit_ice",
						append_husk_to_event_name = true
					}
				},
				damage_reduced = {
					{
						event = "wwise/events/weapon/play_material_hit_ice",
						append_husk_to_event_name = true
					}
				},
				damage_negated = {
					{
						event = "wwise/events/weapon/melee_hits_blunt_no_damage",
						append_husk_to_event_name = true
					}
				}
			},
			vfx = {
				damage = {
					{
						effects = {
							"content/fx/particles/impacts/armor_penetrate"
						}
					},
					{
						effects = {
							"content/fx/particles/weapons/swords/chainsword/impact_metal_slash_01"
						}
					},
					{
						effects = {
							"content/fx/particles/impacts/surfaces/impact_ice_01"
						}
					}
				},
				damage_reduced = {
					{
						effects = {
							"content/fx/particles/impacts/armor_penetrate"
						}
					},
					{
						effects = {
							"content/fx/particles/weapons/swords/chainsword/impact_metal_slash_01"
						}
					},
					{
						effects = {
							"content/fx/particles/impacts/surfaces/impact_ice_01"
						}
					}
				},
				damage_negated = {
					{
						effects = {
							"content/fx/particles/impacts/damage_blocked"
						}
					},
					{
						effects = {
							"content/fx/particles/impacts/armor_ricochet"
						}
					}
				}
			}
		}
	else
		Log.info("ImpactFxInjector", "Found override for \"prop_ice_chunk\" impact fx on damage_type: %s", damage_type)
	end

	local has_prop_train_cogitator_overrides = armor_config[hit_effect_armor_type.prop_train_cogitator] ~= nil

	if not has_prop_train_cogitator_overrides then
		armor_config[hit_effect_armor_type.prop_train_cogitator] = {
			sfx = {
				damage = {
					{
						event = "wwise/events/weapon/play_cogitator_impact",
						append_husk_to_event_name = true
					}
				},
				damage_reduced = {
					{
						event = "wwise/events/weapon/play_cogitator_impact",
						append_husk_to_event_name = true
					}
				},
				damage_negated = {
					{
						event = "wwise/events/weapon/play_cogitator_impact",
						append_husk_to_event_name = true
					}
				}
			},
			vfx = {
				damage = {
					{
						effects = {
							"content/fx/particles/impacts/armor_penetrate"
						}
					},
					{
						effects = {
							"content/fx/particles/weapons/swords/chainsword/impact_metal_slash_01"
						}
					},
					{
						effects = {
							"content/fx/particles/impacts/surfaces/impact_metal"
						}
					}
				},
				damage_reduced = {
					{
						effects = {
							"content/fx/particles/impacts/armor_penetrate"
						}
					},
					{
						effects = {
							"content/fx/particles/weapons/swords/chainsword/impact_metal_slash_01"
						}
					},
					{
						effects = {
							"content/fx/particles/impacts/surfaces/impact_metal"
						}
					}
				},
				damage_negated = {
					{
						effects = {
							"content/fx/particles/impacts/damage_blocked"
						}
					},
					{
						effects = {
							"content/fx/particles/impacts/armor_ricochet"
						}
					}
				}
			}
		}
	else
		Log.info("ImpactFxInjector", "Found override for \"prop_train_cogitator\" impact fx on damage_type: %s", damage_type)
	end

	local has_void_shield_overrides = armor_config[armor_types.void_shield] ~= nil

	if not has_void_shield_overrides then
		armor_config[armor_types.void_shield] = {
			sfx = {
				[armor_hit_types.damage] = {
					{
						event = "wwise/events/minions/play_traitor_captain_shield_bullet_hits",
						append_husk_to_event_name = true
					}
				},
				[armor_hit_types.damage_negated] = {
					{
						event = "wwise/events/minions/play_traitor_captain_shield_bullet_hits",
						append_husk_to_event_name = true
					}
				}
			},
			vfx = {
				[armor_hit_types.damage] = {
					{
						normal_rotation = true,
						effects = {
							"content/fx/particles/impacts/enemies/renegade_captain/renegade_captain_shield_impact"
						}
					}
				},
				[armor_hit_types.damage_negated] = {
					{
						normal_rotation = true,
						effects = {
							"content/fx/particles/impacts/enemies/renegade_captain/renegade_captain_shield_impact"
						}
					}
				}
			}
		}
	else
		Log.info("ImpactFxInjector", "Found override for \"void_shield\" impact fx on damage_type: %s", damage_type)
	end

	local has_nurgle_totem_overrides = armor_config[hit_effect_armor_type.nurgle_totem] ~= nil

	if not has_nurgle_totem_overrides then
		armor_config[hit_effect_armor_type.nurgle_totem] = {
			sfx = {
				damage = {
					{
						event = "wwise/events/weapon/play_event_skull_totem_hit",
						append_husk_to_event_name = true
					},
					{
						event = "wwise/events/weapon/play_melee_hits_axe_light",
						append_husk_to_event_name = true
					}
				},
				damage_reduced = {
					{
						event = "wwise/events/weapon/play_event_skull_totem_hit",
						append_husk_to_event_name = true
					},
					{
						event = "wwise/events/weapon/play_melee_hits_axe_light",
						append_husk_to_event_name = true
					}
				},
				damage_negated = {
					{
						event = "wwise/events/weapon/play_melee_hits_axe_light",
						append_husk_to_event_name = true
					}
				}
			},
			vfx = {
				damage = {
					{
						effects = {
							"content/fx/particles/impacts/armor_penetrate"
						}
					},
					{
						effects = {
							"content/fx/particles/weapons/swords/chainsword/impact_metal_slash_01"
						}
					},
					{
						effects = {
							"content/fx/particles/impacts/surfaces/impact_metal"
						}
					}
				},
				damage_reduced = {
					{
						effects = {
							"content/fx/particles/impacts/armor_penetrate"
						}
					},
					{
						effects = {
							"content/fx/particles/weapons/swords/chainsword/impact_metal_slash_01"
						}
					},
					{
						effects = {
							"content/fx/particles/impacts/surfaces/impact_metal"
						}
					}
				},
				damage_negated = {
					{
						effects = {
							"content/fx/particles/impacts/damage_blocked"
						}
					},
					{
						effects = {
							"content/fx/particles/impacts/armor_ricochet"
						}
					}
				}
			}
		}
	else
		Log.info("ImpactFxInjector", "Found override for \"nurgle_totem\" impact fx on damage_type: %s", damage_type)
	end
end

function _inject_surface_impact_fx(damage_type, surface_config)
	return
end

function _inject_surface_decal_fx(damage_type, surface_decal_config)
	return
end

return ImpactFxInjector
