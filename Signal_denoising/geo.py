from geopy.geocoders import Nominatim
from geopy import distance

geocoder = Nominatim(user_agent="U know it")
loc1 = "gościno"
loc2 = "zatoka gdańska"

coordinates1= geocoder.geocode(loc1)
coordinates2= geocoder.geocode(loc2)
lat1,long1=(coordinates1.latitude),(coordinates1.longitude)
lat2,long2=(coordinates2.latitude),(coordinates2.longitude)
place1=(lat1,long1)
place2=(lat2,long2)
print(place1)
print(place2)
print()
print(distance.distance(place1,place2))