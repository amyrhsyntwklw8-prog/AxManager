#!/system/bin/sh

until [ "$(getprop sys.boot_completed)" = "1" ]; do
	sleep 5
done

/data/adb/modules/BKT/BKT >/dev/null 2>&1
