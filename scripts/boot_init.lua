-- chunkname: @scripts/boot_init.lua

if jit then
	jit.off()
end

if s3d and not s3d._imported then
	for k, v in pairs(s3d) do
		if rawget(_G, k) then
			error("Module name clash: " .. tostring(k))
		end

		rawset(_G, k, v)
	end

	s3d._imported = true

	if cjson and cjson.stingray_init then
		cjson = cjson.stingray_init()
	end

	Script.set_index_offset(1)
end

NOP = NOP or function ()
	return
end

local valid, local_content_revision = pcall(require, "scripts/optional/content_revision")

rawset(_G, "LOCAL_CONTENT_REVISION", valid and local_content_revision or "Unknown")
