-- chunkname: @scripts/managers/pacing/auto_event/templates/live_event_saints_auto_event_template.lua

template = {}
template.live_event_saints_auto_event_template = {
	monster_limit_per_event = 0,
	name = "live_event_saints_auto_event_template",
	cooldown = {
		{
			3,
			6,
		},
		{
			3,
			6,
		},
		{
			3,
			6,
		},
		{
			3,
			6,
		},
		{
			3,
			6,
		},
		{
			3,
			6,
		},
	},
	waves_cooldown = {
		{
			0,
			1,
		},
		{
			3,
			3,
		},
		{
			3,
			3,
		},
		{
			3,
			3,
		},
		{
			3,
			3,
		},
		{
			3,
			3,
		},
	},
	inital_cooldown_types = {
		default = 1,
	},
	num_waves_by_resistance = {
		5,
		5,
		5,
		5,
		5,
	},
	monster_chance = {
		challenge = {
			0,
			0,
			0,
			0,
			0,
		},
		heat = {
			0,
			0,
			0,
			0,
			0,
			0,
			0,
		},
	},
	resistance_multiplier = {
		0.5,
		0.6,
		0.7,
		0.8,
		0.9,
		1.2,
	},
	points_base = {
		20,
		30,
		50,
		60,
		80,
	},
	size_multipliers = {
		default = 1,
		large = 1.5,
		small = 0.5,
	},
	composition = {
		default = {
			breeds = {
				{
					points = 0,
					breed_tags = {
						{
							"roamer",
						},
					},
					excluded_breed_tags = {
						{
							"elite",
							"ranged",
						},
					},
					weights = {
						{
							1,
							1,
							0.7,
							0.5,
							0.4,
						},
						{
							1,
							1,
							0.7,
							0.5,
							0.4,
						},
						{
							1,
							1,
							0.7,
							0.5,
							0.4,
						},
						{
							1,
							1,
							0.7,
							0.5,
							0.4,
						},
						{
							1,
							1,
							0.7,
							0.5,
							0.4,
						},
						{
							1,
							1,
							0.7,
							0.5,
							0.4,
						},
					},
				},
				{
					points = 0,
					breed_tags = {
						{
							"horde",
						},
					},
					excluded_breed_tags = {
						{
							"ranged",
						},
					},
					weights = {
						{
							5,
							3,
							2,
							1,
							0.5,
						},
						{
							5,
							3,
							2,
							1,
							0.5,
						},
						{
							5,
							3,
							2,
							1,
							0.5,
						},
						{
							5,
							3,
							2,
							1,
							0.5,
						},
						{
							5,
							3,
							2,
							1,
							0.5,
						},
						{
							5,
							3,
							2,
							1,
							0.5,
						},
					},
				},
				{
					points = 0,
					breed_tags = {
						{
							"elite",
							"melee",
						},
					},
					excluded_breed_tags = {},
					weights = {
						{
							0,
							0.5,
							1,
							2,
							3,
						},
						{
							0,
							0.5,
							1,
							2,
							3,
						},
						{
							0,
							0.5,
							1,
							2,
							3,
						},
						{
							0,
							0.5,
							1,
							2,
							3,
						},
						{
							0,
							0.5,
							1,
							2,
							3,
						},
						{
							0,
							0.5,
							1,
							2,
							3,
						},
					},
				},
			},
		},
	},
	conditional_function = function (t)
		local mutator = Managers.state.mutator:mutator("mutator_live_event_saints_shrine_gameplay")

		if not mutator then
			return t[1]
		end

		local scratchpad = mutator.scratchpad

		if not scratchpad then
			return t[1]
		end

		local shrines_completed = scratchpad.shrines_completed or 1

		shrines_completed = math.clamp(shrines_completed, 1, #t)

		return t[shrines_completed]
	end,
}

return template
