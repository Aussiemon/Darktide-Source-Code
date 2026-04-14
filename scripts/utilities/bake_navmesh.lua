-- chunkname: @scripts/utilities/bake_navmesh.lua

local Component = require("scripts/utilities/component")
local BakeNavmesh = {}

local function log(str, ...)
	Log.debug("Ste -> BakeNavmesh:", str, ...)
end

local function read_gentag_field(unit, key, default)
	local value = Unit.get_data(unit, "GwNavGenTag", key)

	if value ~= nil then
		return value
	end

	return default
end

local function to_color(color_table)
	return Color(color_table[1], color_table[2], color_table[3], color_table[4])
end

local function set_navtag_from_unit(navtag_settings, nav_gen, unit)
	if not Unit.get_data(unit, "GwNavGenTag") then
		return false
	end

	local color = to_color(navtag_settings.color)

	GwNavGeneration.set_current_navtag(nav_gen, read_gentag_field(unit, "exclusive", navtag_settings.is_exclusive), color, read_gentag_field(unit, "layer_id", navtag_settings.layer_id), read_gentag_field(unit, "smartobject_id", navtag_settings.smartobject_id), read_gentag_field(unit, "gameobject_id", navtag_settings.gameobject_id), read_gentag_field(unit, "user_int", navtag_settings.user_data_id))

	return true
end

local function push_units(nav_gen, navtag_settings, units)
	local color = to_color(navtag_settings.color)

	for i = 1, #units do
		local unit = units[i]
		local consume_physics_mesh = Unit.get_data(unit, "gwnavgen_fromphysicsmesh")
		local consume_render_mesh = Unit.get_data(unit, "gwnavgen_fromrendermesh")

		if consume_physics_mesh == nil and consume_render_mesh == nil then
			consume_physics_mesh = true
			consume_render_mesh = false
		end

		if not set_navtag_from_unit(navtag_settings, nav_gen, unit) then
			GwNavGeneration.reset_current_navtag(nav_gen)
		end

		GwNavGeneration.push_unit_meshes(nav_gen, unit, consume_physics_mesh, consume_render_mesh, true)
	end
end

local function get_static_world_units(world)
	log("Get world units")

	local static_units = {}
	local all_units = World.units(world)

	for i = 1, #all_units do
		local unit = all_units[i]

		if Unit.is_a(unit, "volume") == nil then
			local actor = Unit.actor(unit, 1)

			if actor and Actor.is_static(actor) then
				static_units[#static_units + 1] = unit

				log("Found static actor %s", unit)
			end
		end
	end

	return static_units
end

BakeNavmesh.generate_navmesh = function (world, nav_world, nav_gen, navgen_settings, navtag_settings, use_seedpoints, seed_point_unit_name, levels, asynchronous)
	log("*** Generating navmesh ***")
	log(" * Pushing units")

	local static_units = get_static_world_units(world)
	local consumed_units = {}

	local function consume_unit_in_level(unit)
		local do_consume_unit = true

		if Unit.has_data(unit, "gwnavseedpoint") then
			local gwnavseedpoint = Unit.get_data(unit, "gwnavseedpoint")

			if gwnavseedpoint == true then
				do_consume_unit = false
			end
		end

		if Unit.has_data(unit, "GwNavBoxObstacle") then
			do_consume_unit = false
		end

		if Unit.has_data(unit, "GwNavCylinderObstacle") then
			do_consume_unit = false
		end

		if Unit.has_data(unit, "GwNavTagBox") then
			do_consume_unit = false
		end

		if do_consume_unit == true and Unit.has_data(unit, "gwnavgenexcluded") == true and Unit.get_data(unit, "gwnavgenexcluded") == true then
			do_consume_unit = false
		end

		if do_consume_unit == true then
			consumed_units[#consumed_units + 1] = unit
		end

		local components = Component.get_all_components(unit)

		if components then
			for _, component in ipairs(components) do
				if component.get_navgen_units then
					local children = component:get_navgen_units()

					if #children > 0 then
						for _, child_unit in ipairs(children) do
							consume_unit_in_level(child_unit)
						end
					end
				end
			end
		end
	end

	local flying_navigation_system = Managers.state.extension:system("flying_navigation_system")

	flying_navigation_system:register_nav_units(static_units)

	local filter = Script.new_map(16384)
	local GwNavGeneration_push_indexed_mesh = GwNavGeneration.push_indexed_mesh

	for l = 1, #levels do
		local level_data = levels[l]
		local level_name = level_data.level_name
		local level = level_data.level
		local file_path = level_name .. "_nav_base"

		if Application.can_get_resource("lua", file_path) then
			local level_position = level_data.position:unbox()

			log(" * using nav_base to generate navmesh for level: " .. tostring(level_name))

			local nav_base = dofile(file_path).nav_base
			local triangle_indicies = nav_base.triangle_indicies
			local vertices = nav_base.vertices

			if GwNavGeneration_push_indexed_mesh then
				local pose = Matrix4x4.from_translation(level_position)

				GwNavGeneration.push_indexed_mesh(nav_gen, vertices, triangle_indicies, pose)
			else
				GwNavGeneration.begin_push_triangle(nav_gen)

				for i = 1, #triangle_indicies, 3 do
					local a = vertices[triangle_indicies[i]]
					local b = vertices[triangle_indicies[i + 1]]
					local c = vertices[triangle_indicies[i + 2]]

					GwNavGeneration.push_triangle(nav_gen, Vector3(a[1], a[2], a[3]) + level_position, Vector3(b[1], b[2], b[3]) + level_position, Vector3(c[1], c[2], c[3]) + level_position)
				end
			end

			local level_units = Level.units(level)

			for j = 1, #level_units do
				filter[level_units[j]] = true
			end
		end
	end

	for j = 1, #static_units do
		if filter[static_units[j]] == nil then
			consume_unit_in_level(static_units[j])
		end
	end

	if table.is_empty(filter) then
		for _, unit in ipairs(static_units) do
			consume_unit_in_level(unit)
		end
	end

	push_units(nav_gen, navtag_settings, consumed_units)

	if use_seedpoints then
		log(" * Pushing seedpoints")

		local units = World.units(world)

		for i = 1, #units do
			local unit = units[i]

			if Unit.has_data(unit, "gwnavseedpoint") then
				local gwnavseedpoint = Unit.get_data(unit, "gwnavseedpoint")

				if gwnavseedpoint == true then
					GwNavGeneration.push_seed_point(nav_gen, Unit.local_position(unit, 1))
				end
			elseif Unit.has_data(unit, "gwnavseedpoint_node") then
				local gwnavseedpoint = Unit.get_data(unit, "gwnavseedpoint_node")

				if gwnavseedpoint == true then
					local node_index = Unit.node(unit, "gwnavseedpoint")

					GwNavGeneration.push_seed_point(nav_gen, Unit.world_position(unit, node_index))
				end
			end
		end
	else
		local local_player = Managers.player:local_player(1)
		local local_player_unit = local_player.player_unit

		GwNavGeneration.push_seed_point(nav_gen, Unit.local_position(local_player_unit, 1))
	end

	for i = 1, #levels do
		local level_data = levels[i]
		local level_name = level_data.level_name
		local level_tm = Matrix4x4.from_quaternion_position(Quaternion.identity(), level_data.position:unbox())
		local file_path = level_name .. "_volume_data"

		if Application.can_get_resource("lua", file_path) then
			local volumes_data = require(file_path).volume_data

			for _, volume in ipairs(volumes_data) do
				local consume_volume = false
				local is_exclusive = false
				local layer_id = -1
				local smartobject_id = -1

				if string.find(volume.type, "gwnavexclusivetagvolume") ~= nil then
					is_exclusive = true
					consume_volume = true
				elseif string.find(volume.type, "gwnavtagvolume_layer") ~= nil then
					is_exclusive = false
					consume_volume = true

					local start_idx, end_idx = string.find(volume.type, "gwnavtagvolume_layer")
					local layer_id_string = string.sub(volume.type, end_idx + 1)

					layer_id = tonumber(layer_id_string)

					if layer_id == nil then
						layer_id = -1
					end
				elseif string.find(volume.type, "gwnavtagvolume_smartobject") ~= nil then
					is_exclusive = false
					consume_volume = true
					has_smartobject = true

					local start_idx, end_idx = string.find(volume.type, "gwnavtagvolume_smartobject")
					local smartobject_id_string = string.sub(volume.type, end_idx + 1)

					smartobject_id = tonumber(smartobject_id_string)

					if smartobject_id == nil then
						smartobject_id = -1
					end
				end

				if consume_volume == true then
					local color = Color(volume.color[1], volume.color[2], volume.color[3], volume.color[4])
					local bottom_points = {}

					for j = 1, #volume.bottom_points do
						local bottom_point = volume.bottom_points[j]

						bottom_points[#bottom_points + 1] = Matrix4x4.transform(level_tm, Vector3(bottom_point[1], bottom_point[2], bottom_point[3]))
					end

					local alt_min_vector = Vector3(volume.alt_min_vector[1], volume.alt_min_vector[2], volume.alt_min_vector[3])
					local alt_max_vector = Vector3(volume.alt_max_vector[1], volume.alt_max_vector[2], volume.alt_max_vector[3])

					GwNavGeneration.push_tagvolume_fromvolume(nav_gen, bottom_points, alt_min_vector.z, alt_max_vector.z, is_exclusive, color, layer_id, smartobject_id)
				end
			end
		end
	end

	log(" * starting generate")

	local sectors = {
		[math.uuid()] = "BakeNavmesh_Sector01",
	}
	local nav_data, job_id

	if asynchronous then
		job_id = GwNavGeneration.generate_async(nav_gen, nav_world, navgen_settings, sectors)
	else
		nav_data = GwNavGeneration.generate_and_use_immediately(nav_gen, nav_world, navgen_settings, sectors)
	end

	return nav_data, job_id
end

BakeNavmesh.is_navmesh_done = function (world, nav_world, job_id)
	local done, navmesh = GwNavGeneration.finish_async_generation(nav_world, job_id)

	return done, navmesh
end

BakeNavmesh.run = function (navgen_settings, navtag_settings, context, asynchronous)
	local world = context.world
	local nav_world = context.nav_world
	local nav_gen = GwNavGeneration.create(world)
	local use_seedpoints = true
	local seed_point_unit_name = context.seed_point_unit_name or "core/gwnav/units/seedpoint/seedpoint"
	local levels = context.levels

	if asynchronous then
		Log.info("BakeNavmesh", "Generating navmesh asynchronously")
	end

	local nav_data, job_id = BakeNavmesh.generate_navmesh(world, nav_world, nav_gen, navgen_settings, navtag_settings, use_seedpoints, seed_point_unit_name, levels, asynchronous)

	GwNavGeneration.destroy(nav_gen)

	return nav_data, job_id
end

return BakeNavmesh
