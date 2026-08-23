#!/bin/bash
set -e

echo "=== SCRIPT DE INSTALACIÓN INTELIGENTE (EFI / BIOS) POR CH3X ==="

# 1. Detectar si el sistema booted en EFI o BIOS
if [ -d /sys/firmware/efi/efivars ]; then
    FIRMWARE="UEFI"
    echo "[+] Sistema detectado en modo: UEFI"
else
    FIRMWARE="BIOS"
    echo "[+] Sistema detectado en modo: LEGACY BIOS"
fi

# 2. Detectar microcódigo de CPU
CPU_VENDOR=$(grep -m 1 'vendor_id' /proc/cpuinfo | awk '{print $4}')
if [ "$CPU_VENDOR" == "GenuineIntel" ]; then
    UCUBE="intel-ucode"
    echo "[+] CPU Intel detectada."
elif [ "$CPU_VENDOR" == "AuthenticAMD" ]; then
    UCUBE="amd-ucode"
    echo "[+] CPU AMD detectada."
else
    UCUBE=""
    echo "[!] CPU no reconocida, se omite el ucode."
fi

# 3. Selección de GPU
echo "Selecciona tu tarjeta gráfica principal:"
echo "1) NVIDIA (Propietarios)"
echo "2) NVIDIA (Nouveau - Open Source)"
echo "3) Intel / AMD Integrada / Otras (Drivers libres MESA)"
read -p "Elige una opción [1-3]: " GPU_CHOICE

case $GPU_CHOICE in
    1) GPU_PACKAGES="nvidia nvidia-utils nvidia-settings" ;;
    2) GPU_PACKAGES="xf86-video-nouveau mesa" ;;
    3) GPU_PACKAGES="mesa vulkan-intel" ;;
    *) GPU_PACKAGES="mesa" ;;
esac

# Pedir datos clave de usuario y disco antes de la acción pesada
read -p "Introduce el nombre para tu nuevo usuario: " NEWUSER
lsblk
read -p "Introduce el disco destino (ej. /dev/nvme0n1, /dev/sda): " DISK

echo "[+] Limpiando disco..."
sgdisk --zap-all "$DISK"

# 4. Particionado condicional según UEFI o BIOS
if [ "$FIRMWARE" == "UEFI" ]; then
    echo "[+] Creando tabla de particiones GPT para UEFI..."
    parted -s "$DISK" mklabel gpt
    parted -s "$DISK" mkpart ESP fat32 1MiB 512MiB
    parted -s "$DISK" set 1 esp on
    parted -s "$DISK" mkpart primary btrfs 512MiB 100%

    if [[ "$DISK" == *"nvme"* ]] || [[ "$DISK" == *"mmcblk"* ]]; then
        PART_EFI="${DISK}p1"
        PART_ROOT="${DISK}p2"
    else
        PART_EFI="${DISK}1"
        PART_ROOT="${DISK}2"
    fi
else
    echo "[+] Creando tabla de particiones MBR (DOS) para BIOS..."
    parted -s "$DISK" mklabel msdos
    parted -s "$DISK" mkpart primary ext2 1MiB 2MiB      
    parted -s "$DISK" set 1 boot on
    parted -s "$DISK" mkpart primary btrfs 2MiB 100%

    if [[ "$DISK" == *"nvme"* ]] || [[ "$DISK" == *"mmcblk"* ]]; then
        PART_ROOT="${DISK}p2"
    else
        PART_ROOT="${DISK}2"
    fi
fi

# 5. Formatear y montar Btrfs
echo "[+] Formateando particiones..."
if [ "$FIRMWARE" == "UEFI" ]; then
    mkfs.fat -F32 "$PART_EFI"
fi
mkfs.btrfs -f "$PART_ROOT"

mount "$PART_ROOT" /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@cache
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@snapshots
umount /mnt

OPTS="noatime,compress=zstd:3,space_cache=v2"
mount -o "$OPTS",subvol=@ "$PART_ROOT" /mnt
mkdir -p /mnt/{boot,home,var/log,var/cache,.snapshots}
mount -o "$OPTS",subvol=@home "$PART_ROOT" /mnt/home
mount -o "$OPTS",subvol=@log "$PART_ROOT" /mnt/var/log
mount -o "$OPTS",subvol=@cache "$PART_ROOT" /mnt/var/cache
mount -o "$OPTS",subvol=@snapshots "$PART_ROOT" /mnt/.snapshots

if [ "$FIRMWARE" == "UEFI" ]; then
    mount "$PART_EFI" /mnt/boot
fi

# 6. Instalar paquetes base
echo "[+] Instalando paquetes base..."
pacstrap -K /mnt base base-devel linux linux-headers linux-firmware btrfs-progs iwd limine neovim bash-completion git "$UCUBE" "$GPU_PACKAGES"

genfstab -U /mnt >> /mnt/etc/fstab

# 7. Configuración interna en Chroot
cat << 'EOF' > /mnt/configure_system.sh
ln -sf /usr/share/zoneinfo/America/Mexico_City /etc/localtime
hwclock --systohc

sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=la-latin1" > /etc/vconsole.conf
echo "arch" > /etc/hostname

cat << 'HOSTS' > /etc/hosts
127.0.0.1    localhost
::1          localhost
127.0.1.1    arch.localdomain arch
HOSTS

echo "Configura la contraseña de ROOT:"
passwd
mkinitcpio -P
EOF

arch-chroot /mnt /bin/bash /configure_system.sh
rm /mnt/configure_system.sh

# 8. Instalación limpia de Limine según el modo detectado
ROOT_UUID=$(blkid -s UUID -o value "$PART_ROOT")

if [ "$FIRMWARE" == "UEFI" ]; then
    echo "[+] Instalando Limine para UEFI..."
    mkdir -p /mnt/boot/EFI/BOOT
    cp /usr/share/limine/BOOTX64.EFI /mnt/boot/EFI/BOOT/
    
    cat << EOF > /mnt/boot/limine.conf
timeout: 5
default_entry: 1

/Arch Linux (UEFI)
protocol: linux
path: boot():/vmlinuz-linux
cmdline: root=UUID=$ROOT_UUID rw rootflags=subvol=@
module_path: boot():/$UCUBE.img
module_path: boot():/initramfs-linux.img
EOF

else
    echo "[+] Instalando Limine para BIOS..."
    mkdir -p /mnt/boot/limine
    cp /usr/share/limine/limine-bios.sys /mnt/boot/limine/
    cp /usr/share/limine/limine-bios-cd.bin /mnt/boot/limine/
    
    limine bios-install "$DISK"

    cat << EOF > /mnt/boot/limine.conf
timeout: 5
default_entry: 1

/Arch Linux (BIOS)
protocol: linux
path: boot():/vmlinuz-linux
cmdline: root=UUID=$ROOT_UUID rw rootflags=subvol=@
module_path: boot():/$UCUBE.img
module_path: boot():/initramfs-linux.img
EOF
fi

# 9. Red, Usuario y Ajustes Finales
arch-chroot /mnt systemctl enable iwd.service
mkdir -p /mnt/etc/iwd
cat << 'EOF' > /mnt/etc/iwd/main.conf
[General]
EnableNetworkConfiguration=true

[Network]
NameResolvingService=systemd
EOF

arch-chroot /mnt systemctl enable systemd-resolved

echo "[+] Creando usuario $NEWUSER..."
arch-chroot /mnt useradd -m -G wheel -s /bin/bash "$NEWUSER"
echo "Establece la contraseña para el usuario $NEWUSER:"
arch-chroot /mnt passwd "$NEWUSER"

arch-chroot /mnt sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
sed -i '/#Color/a ILoveCandy' /mnt/etc/pacman.conf
sed -i "/\[multilib\]/,/Include/"'s/^#//' /mnt/etc/pacman.conf

echo "[+] ¡Instalación base finalizada con éxito para $FIRMWARE!"
echo "[+] Ya puedes desmontar o reiniciar para entrar a tu nuevo Arch."
umount -R /mnt
