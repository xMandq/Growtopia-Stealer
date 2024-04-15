function executeCommand(command)
    handle = io.popen(command)
    if handle then
        result = handle:read("*a")
        handle:close()
        return result
    else
        return nil
    end
end

function removeEmptyLines(text)
    lines = {}
    for line in text:gmatch("[^\r\n]+") do
        if line:match("%S") then -- Check if the line contains non-whitespace characters
            table.insert(lines, line)
        end
    end
    return table.concat(lines, "\n")
end

function getSystemUUID()
    uuidCommand = 'wmic csproduct get uuid'
    uuidInfo = executeCommand(uuidCommand)
    uuid = uuidInfo and uuidInfo:match("{.-}") or "UUID not found"
    return uuid
end

function getMACAddress()
    macCommand = 'ipconfig /all'
    macInfo = executeCommand(macCommand)
    mac = macInfo and macInfo:match("Physical Address[%.:%s]+([%x%-]+)") or "MAC Address not found"
    return mac
end

function getIPAddress()
    ipCommand = 'ipconfig'
    ipInfo = executeCommand(ipCommand)
    ip = ipInfo and ipInfo:match("IPv4 Address[%.:%s]+([%d%.]+)") or "IP Address not found"
    return ip
end

function getSystemInfo()
    systemInfoCommand = 'systeminfo'
    systemInfo = executeCommand(systemInfoCommand)
    return systemInfo or "System information not found"
end

function getHardwareInfo()
    hardwareInfoCommand = 'wmic cpu get Name /format:list && wmic memorychip get Capacity /format:list && wmic diskdrive get Model,Size /format:list'
    hardwareInfo = executeCommand(hardwareInfoCommand)
    return hardwareInfo or "Hardware information not found"
end

function getUserInfo()
    userInfoCommand = 'net user %username%'
    userInfo = executeCommand(userInfoCommand)
    return userInfo or "User information not found"
end

function getInstalledSoftware()
    softwareInfoCommand = 'wmic product get Name,Version'
    softwareInfo = executeCommand(softwareInfoCommand)
    return softwareInfo or "Installed software information not found"
end

function saveSystemInfoToFile()
    file = io.open("C:\\Windows\\Temp\\system_info.txt", "w")

    file:write("System UUID:\n")
    file:write(removeEmptyLines(getSystemUUID()).."\n\n")

    file:write("MAC Address:\n")
    file:write(removeEmptyLines(getMACAddress()).."\n\n")

    file:write("IP Address:\n")
    file:write(removeEmptyLines(getIPAddress()).."\n\n")

    file:write("System Information:\n")
    file:write(removeEmptyLines(getSystemInfo()).."\n\n")

    file:write("Hardware Information:\n")
    file:write(removeEmptyLines(getHardwareInfo()).."\n\n")

    file:write("User Information:\n")
    file:write(removeEmptyLines(getUserInfo()).."\n\n")

    file:write("Installed Software:\n")
    file:write(removeEmptyLines(getInstalledSoftware()).."\n\n")

    file:close()
end

saveSystemInfoToFile()
