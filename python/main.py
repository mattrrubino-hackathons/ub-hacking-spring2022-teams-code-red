from serial import Serial
from firebase_admin import initialize_app, credentials, db
import time

BAUD_RATE = 9600
PORT = "COM3"
CERT_PATH = "service-account.json"
DB_URL = "https://ubhacking-36a7b-default-rtdb.firebaseio.com/"

port = Serial(port=PORT, baudrate=BAUD_RATE)
cred = credentials.Certificate(CERT_PATH)
app = initialize_app(cred, { "databaseURL": DB_URL })

def setEnabled(enabled):
  port.write('a'.encode('ASCII') if enabled else 'b'.encode('ASCII'))

def setTriggered(triggered):
  port.write('c'.encode('ASCII') if triggered else 'd'.encode('ASCII'))

def onEnabledChange(evt):
  enabled = evt.data
  setEnabled(enabled)

def onTriggeredChange(evt):
  triggered = evt.data
  setTriggered(triggered)

def trigger():
  ref = db.reference("/house1")
  ref.update({"triggered": True})

def start():
  ref = db.reference("/house1/enabled")
  ref.listen(onEnabledChange)

  ref2 = db.reference("/house1/triggered")
  ref2.listen(onTriggeredChange)

  time.sleep(1)
  enabled = ref.get()
  triggered = ref2.get()
  setEnabled(enabled)
  setTriggered(triggered)

def loop():
  while True:
    data = port.read(1)
    if data:
      trigger()

    time.sleep(0.5)

start()
loop()
