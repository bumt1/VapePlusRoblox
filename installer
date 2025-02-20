local isfile = isfile or function(file)
    local suc, res = pcall(function() return readfile(file) end)
    return suc and res ~= nil and res ~= ''
end

local delfile = delfile or function(file)
    if isfile(file) then
        delfile(file)
    end
end

local function downloadFile(url, path)
    local success, response = pcall(function()
        return game:HttpGet(url, true)
    end)
    
    if success and response and response ~= '404: Not Found' then
        writefile(path, response)
    else
        error("Failed to download file: " .. path)
    end
end

local function wipeFolder(path)
    if not isfolder(path) then return end
    for _, file in pairs(listfiles(path)) do
        if isfile(file) then
            delfile(file)
        end
    end
end

local function setupFolder(path)
    if isfolder(path) then
        wipeFolder(path)
    else
        makefolder(path)
    end
end

-- Main execution
setupFolder("NewVape")
setupFolder("NewVape/profiles")

local files = {
    {"https://raw.githubusercontent.com/bumt1/VapePlusRoblox/main/default6872274481.txt", "NewVape/profiles/default6872274481.txt"},
    {"https://raw.githubusercontent.com/bumt1/VapePlusRoblox/main/default6872265039.txt", "NewVape/profiles/default6872265039.txt"}
}

for _, fileData in ipairs(files) do
    local url, path = unpack(fileData)
    if isfile(path) then
        delfile(path)
    end
    downloadFile(url, path)
end

-- Send notification when installation is complete
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Installation Complete",
        Text = "Files have been successfully downloaded!",
        Duration = 5
    })
end)
