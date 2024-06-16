import json
from random import randint

with open("IDs\Addons.json", encoding="utf8") as file:
    addons = json.load(file)
with open("IDs\Items.json", encoding="utf8") as file:
    items = json.load(file)
with open("IDs\Offerings.json", encoding="utf8") as file:
    offerings = json.load(file)
    
min = 20
max = 50
bloodweb = {"CharacterItems":[]}

for addon in addons:
    bloodweb["CharacterItems"].append({"ItemId":addon["ItemId"],"Quantity":randint(min,max)})
    
for item in items:
    bloodweb["CharacterItems"].append({"ItemId":item["ItemId"],"Quantity":randint(min,max)})

for offering in offerings:
    bloodweb["CharacterItems"].append({"ItemId":offering["ItemId"],"Quantity":randint(min,max)})
    
with open("Files\BloodwebNoPerks.json", "w") as file:
    json.dump(bloodweb, file, separators=(',', ':'))
