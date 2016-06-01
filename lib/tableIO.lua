--  The MIT License (MIT)
--  Copyright © 2016 Pietro Ribeiro Pepe.

--  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
--  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

-- Script to write table to file
-- Version 1.0 - 2016/05/22

local tableIO = {}

local writeTable

local function write(v,file)
	file:write(v)
end

local prints = {
	number = write,
	boolean = function(bool,file) write(tostring(bool),file) end,
	string = function(string,file) write("'"..string .."'",file) end,
	table = function(t,file,offset)
		writeTable(t,file,offset..'\t')
	end
}

function writeTable(t,file,offset)
	offset = offset or ''
	file:write('{')
	local off = offset..'\t'
	local first = true
	for i,v in pairs(t) do
		print(i,v)
		local f = prints[type(v)]
		if f then
			if first then first = false
			else file:write(',') end
			file:write('\n')
			if type(i)~='number' or i==0 then
				file:write(off..i..' = ')
			else
				file:write(off)
			end
			 f(v,file,offset)
		end
	end
	file:write('\n'..offset..'}')
end

--[[ tableIO.save
Save a table to a path, using io
-
Params:
	t: the table
	path: a string represeting where the file should be saved
	(optional)name: the name the table will have on the file, default is 'table'
-
Returns:
	-boolean: whether or not the save operation was successfull
	-string: when not successfull, the error message, otherwise, nil
]]
function tableIO.save(t,path,name)
	if type(t)~='table' then
		return false,'The input must be a table'
	end
	local file = io.open(path,'w')
	if file==nil then
		return false,'The file could not be opened'
	end
	name = name or 'table'
	file:write('local '..name..' = ')
	writeTable(t,file)
	file:write('\n\nreturn '..name)
	io.close(file)
	return true
end

function tableIO.loveSave(t,path,name)
   if type(t)~='table' then
		return false,'The input must be a table'
	end
	local file = love.filesystem.newFile(path)
   	file:open('w')
	if file==nil then
		return false,'The file could not be opened'
	end
	name = name or 'table'
	file:write('local '..name..' = ')
	writeTable(t,file)
	file:write('\n\nreturn '..name)
	file:close()
	return true
end

return tableIO