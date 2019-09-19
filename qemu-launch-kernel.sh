#! /bin/sh

qemu-img create -f qcow2 disk-vm-snb-quantal-x86_64-510-0 256G
qemu-img create -f qcow2 disk-vm-snb-quantal-x86_64-510-1 256G

kvm=(
qemu-system-x86_64
-enable-kvm
-cpu SandyBridge
-kernel ../arch/x86/boot/bzImage
-initrd ramdisk.img
-m 2048
-smp 2
-device e1000,netdev=net0
-netdev user,id=net0
-boot order=nc
-no-reboot
-watchdog i6300esb
-watchdog-action debug
-rtc base=localtime
-drive file=disk-vm-snb-quantal-x86_64-510-0,media=disk,if=virtio
-drive file=disk-vm-snb-quantal-x86_64-510-1,media=disk,if=virtio
-serial stdio
-display none
-monitor null
)

append=(
ip=::::vm-snb-quantal-x86_64-510::dhcp
root=/dev/ram0
user=lkp
job=/job-script
ARCH=x86_64
kconfig=x86_64-lkp
branch=linux-devel/devel-catchup-201904120905
commit=853fbf894629ed7df6b3d494bdf0dca547325188
BOOT_IMAGE=/pkg/linux/x86_64-lkp/gcc-7/853fbf894629ed7df6b3d494bdf0dca547325188/vmlinuz-5.1.0-rc4-00059-g853fbf8
max_uptime=600
RESULT_ROOT=/result/boot/1/vm-snb-quantal-x86_64/quantal-core-x86_64-2018-11-09.cgz/x86_64-lkp/gcc-7/853fbf894629ed7df6b3d494bdf0dca547325188/3
result_service=tmpfs
debug
apic=debug
sysrq_always_enabled
rcupdate.rcu_cpu_stall_timeout=100
net.ifnames=0
printk.devkmsg=on
panic=-1
softlockup_panic=1
nmi_watchdog=panic
oops=panic
load_ramdisk=2
prompt_ramdisk=0
drbd.minor_count=8
systemd.log_level=err
ignore_loglevel
console=tty0
earlyprintk=ttyS0,115200
console=ttyS0,115200
vga=normal
rw
rcuperf.shutdown=0
)

"${kvm[@]}" -append "${append[*]}"
