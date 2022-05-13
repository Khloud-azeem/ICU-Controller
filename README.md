# icu_controller

A major challenge in ICU room is the amount of wires surrounding each patients. Wearable sensors is expected to solve this problem. 
This project is an Flutter application interface to a 2-step system for connecting multiple wearables in multiple ICU rooms to the main server.
In each ICU room: 
All sensors connect to a local central unit via bluetooth. The central unit should act like a small server that swaps on all sensors in the room to acquire one reading from each sensor in each cycle.
The central unit of each room acts as a gateway for the sensors in this room. So, each central unit connects to the main hospital server via WiFi connection.

Any doctor can login to any terminal in the hospital (Mopile App or Website) and connect to the server to visualize
multiple rooms, each of multiple patients (2 rooms each has 3 patients as a prototype).
- For any patient, the doctor can monitor his/her vital signals on a signal viewer graph.
- The doctor can freeze and navigate through the patient signal history.
- From the client terminal the user can request to focus on a specific room or a specific patient where, due to emergency, the central unit would dedicate more priority to this specific patient.
