local PortableRandom = class("PortableRandom")

PortableRandom.init = function (self, seed)
	self:set_seed(seed)
end

PortableRandom.next_random = function (self)
	local seed, random_value = math.next_random(self._seed)
	self._seed = seed

	return random_value
end

PortableRandom.random_range = function (self, min, max)
	local seed, random_value = math.next_random(self._seed, min, max)
	self._seed = seed

	return random_value
end

PortableRandom.seed = function (self)
	return self._seed
end

PortableRandom.set_seed = function (self, seed)
	self._seed = seed
end

return PortableRandom
