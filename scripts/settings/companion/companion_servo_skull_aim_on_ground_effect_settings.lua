-- chunkname: @scripts/settings/companion/companion_servo_skull_aim_on_ground_effect_settings.lua

local companion_servo_skull_aim_on_ground_effect_settings = {
	vfx = {
		flame_circle_particle = "content/fx/particles/abilities/cryptic/cryptic_servoskull_flamer_circle",
		flame_cone_particle = "content/fx/particles/abilities/cryptic/cryptic_servoskull_flamer_cone_decal",
		medicae_particle = "content/fx/particles/abilities/cryptic/cryptic_servoskull_medicae_circle",
	},
}

return settings("CompanionServoSkullAimOnGroundEffectSettings", companion_servo_skull_aim_on_ground_effect_settings)
