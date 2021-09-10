#!/bin/sh

### BEGIN INIT INFO
# tpm2-tss issu add so link
### END INIT INFO

DESC="tpm2-tss add so link"

case "${1}" in
	start)
		echo -n "Starting $DESC: "
		(cd /usr/lib; ln -s libtss2-esys.so.0.0.0 libtss2-esys.so; )
		(cd /usr/lib; ln -s libtss2-fapi.0.0.0 libtss2-fapi.so; )
		(cd /usr/lib; ln -s libtss2-mu.so.0.0.0 libtss2-mu.so; )
		(cd /usr/lib; ln -s libtss2-rc.so.so.0.0.0 libtss2-rc.so; )
		(cd /usr/lib; ln -s libtss2-sys.so.0.0.0 libtss2-sys.so; )
		(cd /usr/lib; ln -s libtss2-tcti-cmd.so.0.0.0 libtss2-tcti-cmd.so; )
		(cd /usr/lib; ln -s libtss2-tcti-device.so.0.0.0 libtss2-tcti-device.so; )
		(cd /usr/lib; ln -s libtss2-tcti-mssim.so.0.0.0 libtss2-tcti-mssim.so; )
		(cd /usr/lib; ln -s libtss2-tcti-swtpm.so.0.0.0 libtss2-tcti-swtpm.so; )
		(cd /usr/lib; ln -s libtss2-tctildr.so.0.0.0 libtss2-tctildr.so; )
		export TPM2TOOLS_TCTI="device:/dev/tpm0"
		tpm2_startup -c
		;;
	*)
		echo "Usage: ${NAME} {start}" >&2
		exit 3
		;;
esac

exit 0
