#!/data/data/com.termux/files/usr/bin/bash
folder=raspbian-armhf
if [ -f "$folder" ]; then
	echo "Detected Raspbian is installed!"
	echo "Do you want to continue? [Y/N]"
	read -p "Your choose: " anykey
	case $anykey in
		([y],[Y])
			echo "Continue!"
			;;
		([N],[n])
			echo "Exit!"
			exit 1
			;;
		*)
			;;
	esac
fi
khanh="Raspbian-armhf-khanhnguyen.tar.xz"
if [ ! -f $khanh ]; then
	echo -e "\e[1;33m Check Architecture On Your Device \e[0m"
	case `dpkg --print-architecture` in
	amd64)
		echo "Device is not supported!" 
		exit 1
		;;
	i386)
		echo "Device is not supported!" 
		exit 1
		;;
	*)
		;;
	esac
fi
clear
echo ""
echo " Dang tai ve....."
echo ""
wget -O $khanh https://github.com/KhanhNguyen9872/Raspbian_armhf_Android/releases/download/raspbianarmhf/root.tar.xz
cur=`pwd`
mkdir -p "$folder"
cd "$folder"
echo ""
echo "Dang cai dat...."
echo ""
proot --link2symlink tar -xJf ${cur}/${khanh}||:
cd "$cur"
LAUNCHER=raspbian
cat > $LAUNCHER <<- EOM
#!/bin/bash
cd ${HOME}
unset LD_PRELOAD
## unset LD_PRELOAD in case termux-exec is installed
command="proot"
command+=" --link2symlink"
command+=" -0"
command+=" -r raspbian-armhf"
command+=" -b /dev"
command+=" -b /proc"
command+=" -b /sdcard"
command+=" -b /data"
command+=" -b /vendor"
command+=" -b /system"
command+=" -b /product"
command+=" -b /mnt"
command+=" -b /storage"
command+=" -b raspbian-armhf/root:/dev/shm"
command+=" -w /root"
command+=" /usr/bin/env -i"
command+=" HOME=/root"
command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
command+=" TERM=\$TERM"
command+=" LANG=C.UTF-8"
command+=" /bin/bash --login"
com="\$@"
if [ -z "\$1" ];then
    exec \$command
else
    \$command -c "\$com"
fi
EOM
termux-fix-shebang $LAUNCHER
mv raspbian ${PREFIX}/bin/raspbian
chmod 777 ${PREFIX}/bin/raspbian
clear
echo ""
echo "COMPLETED!"
echo "You can run 'raspbian' to start!"
echo ""
