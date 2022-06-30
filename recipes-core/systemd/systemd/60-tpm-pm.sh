#!/bin/sh

case "$1" in
	pre)
		logger -t TPM "pre TPM device"
		;;
	post)
		logger -t TPM "after TPM resume"
		tpm2_startup
		;;
esac
