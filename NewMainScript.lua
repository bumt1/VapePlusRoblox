local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local delfile = delfile or function(file)
	writefile(file, '')
end

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/bumt1/VapePlusRoblox/'..readfile('newvape/profiles/commit.txt')..'/'..select(1, path:gsub('newvape/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('loader') then continue end
		if isfile(file) and select(1, readfile(file):find('--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.')) == 1 then
			delfile(file)
		end
	end
end

for _, folder in {'newvape', 'newvape/games', 'newvape/profiles', 'newvape/assets', 'newvape/libraries', 'newvape/guis'} do
	if not isfolder(folder) then
		makefolder(folder)
	end
end

if not shared.VapeDeveloper then
	local _, subbed = pcall(function()
		return game:HttpGet('https://github.com/bumt1/VapePlusRoblox')
	end)
	local commit = subbed:find('currentOid')
	commit = commit and subbed:sub(commit + 13, commit + 52) or nil
	commit = commit and #commit == 40 and commit or 'main'
	
	local oldCommit = isfile('newvape/profiles/commit.txt') and readfile('newvape/profiles/commit.txt') or ''
	
	if commit == 'main' or oldCommit ~= commit then
		-- Wipe old files and update everything
		wipeFolder('newvape')
		wipeFolder('newvape/games')
		wipeFolder('newvape/guis')
		wipeFolder('newvape/libraries')
		wipeFolder('newvape/profiles') -- Ensure profiles are also wiped

		writefile('newvape/profiles/commit.txt', commit)
	end
end

-- Download default profiles if they don't exist
local profiles = {
	"default6872274481.txt", 
	"gui.txt", 
	"whitelist.json" -- Adjust filenames
}

for _, profile in ipairs(profiles) do
	downloadFile("newvape/profiles/" .. profile)
end

-- Ensure the main script is executed
local mainScriptPath = "newvape/main.lua"
if not isfile(mainScriptPath) then
	downloadFile(mainScriptPath)
end

return loadstring(readfile(mainScriptPath), "main.lua")()