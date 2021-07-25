sudo dnf install qemu-kvm qemu-img virt-manager libvirt
sudo sh -c '
if [ ! -r /etc/polkit-1/rules.d/56-libvirt.rules ] ; then
  cp 56-libvirt.rules /etc/polkit-1/rules.d
fi
'
sudo systemctl enable libvirtd
sudo systemctl start libvirtd

