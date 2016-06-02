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

local function windowsPath(path)
	return getParentPath(path)
end

local function unixPath(path)
	return getParentPath(path,3)
end

function saveUtils.getFolderPath()
	local s = love.filesystem.getSourceBaseDirectory()
	if is_windows() then return windowsPath(s) else return unixPath(s) end
end

return saveUtils