local saveUtils = {}


local function is_windows()
	return package.config:sub(1,1)=='\\'
end

local function getParentPath(path,times)
	times = times or 1
	local s = path
	for i=2,times do
		s = string.match(s,"^(.-)([/\\]+)([^/\\]+)$")
	end
	return s:match("(.-)[^%/]+$")
end

local function windowsPath()

end

local function getUnixPath(path)
	return getParentPath(path,3)
end

function saveUtils.getFolderPath()
	local s = love.filesystem.getSourceBaseDirectory()
	print(s)
	if is_windows() then return nil else return getUnixPath(s) end
end

return saveUtils