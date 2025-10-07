# Iron-VM - Virtual Machine Configuration

This configuration is optimized for testing your NixOS config in a virtual machine before deploying to bare metal.

## VM Optimizations Included

- **Virtio Drivers**: For better disk, network, and I/O performance
- **QEMU Guest Agent**: Better integration with QEMU/KVM hypervisors
- **VMware Tools**: Support for VMware Workstation/Fusion
- **ZRAM**: Compressed swap in RAM for better memory usage
- **Fast Boot**: Reduced boot timeout (1 second)
- **Serial Console**: For debugging and rescue scenarios
- **SSH Enabled**: Easy remote access (with password authentication for testing)
- **Clipboard Sharing**: Via SPICE agent

## Creating the VM

### Option 1: Using virt-manager (QEMU/KVM)

1. Download the latest NixOS ISO from https://nixos.org/download.html
2. Create a new VM in virt-manager:
   - **OS**: Linux, NixOS (or Generic Linux)
   - **Memory**: 4GB minimum (8GB recommended)
   - **CPU**: 2 cores minimum (4 recommended)
   - **Disk**: 40GB minimum
   - **Network**: NAT or Bridge mode
   - **Display**: SPICE or VNC
   - **Video**: VirtIO or QXL

3. During installation:
   ```bash
   # Set up your partitions
   sudo fdisk /dev/vda  # or /dev/sda
   
   # Format and mount
   sudo mkfs.ext4 /dev/vda1
   sudo mount /dev/vda1 /mnt
   
   # Generate initial config
   sudo nixos-generate-config --root /mnt
   
   # Clone your config repo
   nix-shell -p git
   git clone https://github.com/iron-tower-dev/nixos-config /mnt/etc/nixos/nixos-config
   
   # Copy the generated hardware-configuration.nix
   sudo cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/nixos-config/hosts/iron-vm/
   
   # Install
   sudo nixos-install --flake /mnt/etc/nixos/nixos-config#iron-vm
   ```

### Option 2: Using VMware Workstation/Fusion

1. Create a new VM:
   - **Guest OS**: Linux, Other Linux 5.x kernel 64-bit
   - **Memory**: 4GB minimum (8GB recommended)
   - **CPU**: 2 cores minimum
   - **Disk**: 40GB (can be thin-provisioned)
   - **Network**: NAT or Bridged

2. Enable 3D acceleration in VM settings
3. Follow the same installation steps as Option 1

### Option 3: Using VirtualBox

1. Create a new VM:
   - **Type**: Linux
   - **Version**: Linux 2.6 / 3.x / 4.x / 5.x (64-bit)
   - **Memory**: 4GB minimum
   - **CPU**: 2 cores minimum
   - **Disk**: 40GB VDI

2. In Settings:
   - Enable 3D Acceleration
   - Set Network to NAT or Bridged
   - Enable clipboard sharing

3. Note: You may need to adjust `virtualisation.virtualbox.guest.enable = true` in configuration.nix

## Building the Configuration

After installation, to test configuration changes:

```bash
# Build the configuration
sudo nixos-rebuild build --flake /etc/nixos/nixos-config#iron-vm

# Or build from your host machine (outside VM)
nix build .#nixosConfigurations.iron-vm.config.system.build.toplevel

# Apply changes in the VM
sudo nixos-rebuild switch --flake /etc/nixos/nixos-config#iron-vm
```

## Testing Workflow

1. **Make changes** to your config on the host machine
2. **Push changes** to git (or use shared folder)
3. **Pull changes** in the VM
4. **Rebuild and test** in the VM
5. **If successful**, deploy to bare metal

## Performance Tips

- Allocate enough RAM (8GB recommended for full desktop experience)
- Use VirtIO drivers for best performance
- Enable 3D acceleration in VM settings
- Consider using host passthrough CPU mode for better performance
- For QEMU/KVM, use `cache=writeback` for better disk performance

## Optional: Auto-login for Testing

To enable automatic login (makes testing faster, but less secure):

Uncomment in `configuration.nix`:
```nix
services.displayManager.autoLogin = {
  enable = true;
  user = "derrick";
};
```

## Shared Folders (Optional)

For easier config syncing, you can set up shared folders:

### QEMU/KVM (9p)
```nix
fileSystems."/mnt/shared" = {
  device = "shared";
  fsType = "9p";
  options = [ "trans=virtio" "version=9p2000.L" ];
};
```

### VMware
Enable shared folders in VM settings, then they'll be available via vmware-hgfsclient

### VirtualBox
Enable shared folders in VM settings and use vboxsf filesystem

## Troubleshooting

- **Slow graphics**: Ensure 3D acceleration is enabled and correct video drivers are loaded
- **No network**: Check that virtio_net module is loaded (`lsmod | grep virtio`)
- **Boot issues**: Use the serial console to debug (appears in VM logs)
- **Build failures**: Check the flake.lock is up to date with `nix flake update`

## SSH Access

SSH is enabled by default in the VM for easy access:

```bash
# From host machine
ssh derrick@<vm-ip>
```

To find the VM IP:
```bash
ip addr show
```
