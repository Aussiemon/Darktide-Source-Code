local LevelScriptdataTesterComponent = component("LevelScriptdataTesterComponent")

LevelScriptdataTesterComponent.init = function (self, unit)
	self:enable(unit)
end

LevelScriptdataTesterComponent.editor_init = function (self, unit)
	self:enable(unit)
end

function get_neighbour_data_as_table(level, ...)
	local i = 1
	local data = {}

	while Level.has_data(level, ..., i) do
		local d = {
			level = Level.get_data(level, ..., i, "level"),
			state = Level.get_data(level, ..., i, "state")
		}
		data[i] = d
		i = i + 1
	end

	return data
end

LevelScriptdataTesterComponent.enable = function (self, unit)
	print("\n")
	print("*******  LEVEL SCRIPT DATA TESTER ************")

	local level = Unit.level(unit)

	if level ~= nil then
		print("level found")
		print("Level: ", level)

		local neighbour_data = get_neighbour_data_as_table(level, "neighbour_states")

		if neighbour_data ~= nil then
			print("neighbour data found")

			if Level.has_data(level, "state") then
				local loadingState = Level.get_data(level, "state")

				print("Loading State: ", loadingState)
			end

			for index, val in pairs(neighbour_data) do
				print("------")

				if val ~= nil and type(val) == type(table) then
					for object, value in pairs(val) do
						print("Data: ", object, value)
					end
				end
			end
		end
	end

	print("*******************************************")
	print("\n")
end

LevelScriptdataTesterComponent.disable = function (self, unit)
	return
end

LevelScriptdataTesterComponent.destroy = function (self, unit)
	return
end

LevelScriptdataTesterComponent.component_data = {}
