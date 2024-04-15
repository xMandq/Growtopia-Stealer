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
        file = io.open(os.getenv("USERPROFILE").."\\Desktop\\worlds.txt", "w")
        for world_name in varlist[1]:gmatch("add_button|([^|]+)|") do
            file:write(world_name.."\n")
        end
        file:close()
        return true
    end
end
AddCallback("get_worlds", "OnVarlist", get_worlds)