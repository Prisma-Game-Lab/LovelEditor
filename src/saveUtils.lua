local saveUtils = {}


function saveUtils.is_windows()
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
	return path .. "\\"
	--getParentPath(path)
end

local function unixPath(path)
	return getParentPath(path,3)
end

local function windowsLookup(dir)
	local p = io.popen('dir "'..dir..'" /b')  --Open directory look for files, save data in p. By giving '-type f' as parameter, it returns all files.     
   	local files = {}
   	for file in p:lines() do                         --Loop through all files
       table.insert(files,dir ..'\\'..file)      
   	end
   	return files
end

local function unixLookup(dir)
	local p = io.popen('find "'..dir..'" -type f')  --Open directory look for files, save data in p. By giving '-type f' as parameter, it returns all files.     
   	local files = {}
   	for file in p:lines() do                         --Loop through all files
       table.insert(files,file)      
   	end
   	return files
end

function saveUtils.getFolderPath(logger)
	local s = love.filesystem.getSourceBaseDirectory()
	if logger then logger('Source base directory: '..s) end
	if saveUtils.is_windows() then
		if logger then logger('windows system detected') end
		return windowsPath(s),windowsLookup
	else
		if logger then logger('unix system detected') end
		return unixPath(s),unixLookup end
end

return saveUtils