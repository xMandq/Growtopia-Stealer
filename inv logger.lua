file = io.open(os.getenv("USERPROFILE").."\\Desktop\\inv.txt", "w")
for _,cur in pairs(GetInventory()) do
    file:write(GetIteminfo(cur.id).name ..": "..math.floor(GetItemCount(cur.id)).."\n")
end
file:close()
