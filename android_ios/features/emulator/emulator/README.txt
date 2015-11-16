Emulator script is intended to use for manual testing or demo purposes.
It listen for changes in devices subdirectory and create/remove/update devices
according to *.json files which describe device and its state.
All changes caused by remote calls are also reflected in file content.
e.g. Sending light-control will cause file content change.
Note 1: Remember to reload file to get recent emualtor state.

See devices/example.json for more details.

Only 'state' (which represents peripherals state), 'alarms' (can be used to triger alarms), 'swVersion' and 'serialNb' can be dynamicaly updated.
After changing 'connection' or 'deviceId' you must disabe (change "enabled" to false and save file)
and enable (change "enabled" to true and save file) device again, to apply changes.

Properties with names starting with '_' (underscore) represents internal emulator state and should not be manually modified (actualy they can, but on your own risk).

Usaage:
    Just use start.bat/star.sh to start emulator.
    Add, remove, modify files.
    Press RETURN to stop emulator.

Triggering Alarms:
    Changing "active" property cause alarm trigger.
    If "sound" property is null, then no wav file is uploaded and storageUrl is used instead.
    If "sound" is not null then given file is uploaded and storageUrl is updated with new one.

Dependencies: listen, httpclient, test-unit, pubnub, logger, json
Note 2: Emulator uses 'listen' gem for watching dir changes.
        On Windows install 'wdm' gem to avoid pooling (see https://github.com/guard/listen for more details).
