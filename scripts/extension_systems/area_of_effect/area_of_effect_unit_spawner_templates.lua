-- chunkname: @scripts/extension_systems/area_of_effect/area_of_effect_unit_spawner_templates.lua

local AreaOfEffectLocalUnitPathTypes = require("scripts/extension_systems/area_of_effect/area_of_effect_local_unit_path_types")
local AreaOfEffectUnitSpawnerTemplates = {}
local PLAZA_SIZE = 30
local STREET_SIZE = 18
local CORRIDOR_SIZE = 10
local DEFAULT_SPREAD_UNITS = 7
local DEFAULT_NUM_SALVOS = 3
local DEFAULT_RADIUS = STREET_SIZE / 4
local DEFAULT_SPREAD_DELAY = 2.5 / DEFAULT_SPREAD_UNITS
local DEFAULT_TIME_TO_ARRIVE = 5
local DEAFAULT_TIME_BETWEEN_SALVOS = 6
local SOURCE_DISTANCE = 500

AreaOfEffectUnitSpawnerTemplates.expeditions_artillery_strike = {
	salvo = {
		initial_salvo_delay = 0.5,
		put_owner_to_sleep_when_done = true,
		spread_unit = "content/empty_unit",
		num_salvos = DEFAULT_NUM_SALVOS,
		time_between_salvos = {
			DEAFAULT_TIME_BETWEEN_SALVOS,
			DEAFAULT_TIME_BETWEEN_SALVOS * 1.2,
		},
		generate_source_position = function (seed, unit)
			local position = Unit.local_position(unit, 1)
			local dx, dy
			local hive_unit = World.units_by_resource(Managers.world:world("level_world"), "content/environment/matte_paintings/expeditions/hive_city/hive_backdrop")[1]

			if hive_unit then
				local rel = Unit.world_position(hive_unit, 1) - position

				rel = Vector3.normalize(rel) * SOURCE_DISTANCE
				dx, dy = rel[1], rel[2]
			else
				local location_level_name, fallback_level_name
				local levels = World.levels(Managers.world:world("level_world"))

				for i = 1, #levels do
					local level_name = Level.name(levels[i])

					if string.find(level_name, "location") then
						location_level_name = level_name

						break
					else
						fallback_level_name = level_name
					end
				end

				location_level_name = location_level_name or fallback_level_name

				local _
				local name_as_seed = tonumber(Application.make_hash(location_level_name), 16)

				_, dx, dy = math.get_uniformly_random_point_inside_sector_seeded(name_as_seed, SOURCE_DISTANCE, SOURCE_DISTANCE, 0, math.pi * 2)
			end

			position[1] = position[1] + dx
			position[2] = position[2] + dy

			return seed, position
		end,
		sfxs = {
			{
				play_from_source_position = true,
				sfx_name = "wwise/events/world/play_artillery_cannons_very_far",
				offset = {
					0,
					0,
					300,
				},
			},
		},
		spread = {
			raycast_height = 20,
			radius = DEFAULT_RADIUS,
			inner_radius = DEFAULT_RADIUS / 4,
			first_shot_radius = DEFAULT_RADIUS / 4,
			num_spread_units = DEFAULT_SPREAD_UNITS,
			spread_delay = {
				DEFAULT_SPREAD_DELAY * 0.65,
				DEFAULT_SPREAD_DELAY * 1.35,
			},
			sfxs = {
				{
					sfx_name = "wwise/events/weapon/play_explosion_artillery",
					delay = DEFAULT_TIME_TO_ARRIVE,
				},
				{
					sfx_name = "wwise/events/weapon/play_explosion_refl_gen",
					delay = DEFAULT_TIME_TO_ARRIVE,
				},
			},
			local_unit = {
				initial_path_progress = 0.5,
				unit_name = "content/weapons/player/ranged/missile_launcher/attachments/missile_01/expedition_artillery_strike_missile_01",
				path_type = AreaOfEffectLocalUnitPathTypes.arc,
				path_time = DEFAULT_TIME_TO_ARRIVE,
				arrival_angle = math.degrees_to_radians(78),
				vfx = {
					link = true,
					orphaned_policy = "stop",
					particle_name = "content/fx/particles/weapons/grenades/broker_boom_bringer_projectile_trail",
				},
			},
			explosion = {
				explosion_template_name = "expeditions_artillery_strike",
				rotate_flat_towards_source_position = true,
				delay = DEFAULT_TIME_TO_ARRIVE,
			},
		},
	},
}
AreaOfEffectUnitSpawnerTemplates.expeditions_artillery_strike_focused = table.clone(AreaOfEffectUnitSpawnerTemplates.expeditions_artillery_strike)

local FOCUSED_RADIUS = DEFAULT_RADIUS / 2

AreaOfEffectUnitSpawnerTemplates.expeditions_artillery_strike_focused.salvo.spread.radius = FOCUSED_RADIUS

return AreaOfEffectUnitSpawnerTemplates
