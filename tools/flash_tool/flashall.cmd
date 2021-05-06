@ECHO OFF

for /r %%x in (*.bin) do set UBOOT=%%x
for /r %%x in (*.bz2) do set IMAGE=%%x

SET MODE=0

call:CHECK_DEVICE_MODE MODE

IF "%MODE%"=="none" (
	ECHO Device not in download mode
	ECHO Maybe device not connect with PC or device in normal mode.
	pause
	goto:eof
)

ECHO Device in %MODE% download mode, start flash!!
ECHO.

IF "%MODE%"=="serial" (
	uuu.exe SDP: boot -f %UBOOT%
	uuu.exe SDPV: delay 1000
	uuu.exe SDPV: write -f %UBOOT% -skipspl
	uuu.exe SDPV: jump
	timeout /t 10
)

uuu.exe FB: ucmd setenv fastboot_dev mmc
uuu.exe FB: ucmd setenv mmcdev ${emmc_dev}
uuu.exe FB: ucmd mmc dev ${emmc_dev}
uuu.exe FB: flash -raw2sparse all %IMAGE%/*
uuu.exe FB: flash bootloader %UBOOT%
uuu.exe FB: ucmd if env exists emmc_ack; then ; else setenv emmc_ack 0; fi;
uuu.exe FB: ucmd mmc partconf ${emmc_dev} ${emmc_ack} 1 0
uuu.exe FB: done

ECHO Rebooting device
uuu.exe FB: ucmd reset > NUL
ECHO Reboot successfully
pause
goto:eof


:CHECK_DEVICE_MODE
uuu.exe -lsusb 2>&1 | findstr /r /c:"FB"
IF %ERRORLEVEL% == 0  (
  SET %~1=fastboot
  goto:eof
)

uuu.exe -lsusb 2>&1 | findstr /r /c:"SDP"
IF %ERRORLEVEL% == 0  (
  SET %~1=serial
  goto:eof
)
SET %~1=none
goto:eof
