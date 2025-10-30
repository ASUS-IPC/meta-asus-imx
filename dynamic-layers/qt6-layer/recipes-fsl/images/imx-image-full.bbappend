IMAGE_FSTYPES = "wic.bz2"

IMAGE_INSTALL:append = " \
	asus-overlay \
	gptfdisk \
	vim \
	whiptail \
	cmocka \
	tpm2-tss \
	tpm2-tools \
	can-utils-cantest \
	can-utils-access \
	aziot-edged \
	networkmanager \
	networkmanager-nmcli \
	networkmanager-nmtui \
	networkmanager-wwan \
	bash-completion \
	phytool \
	pipewire \
	wireplumber \
"
