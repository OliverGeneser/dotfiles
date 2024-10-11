{ config
, lib
, ...
}:
with lib; let
  cfg = config.hardware.nvidia;
in
{
  options.hardware.nvidia = with types; {
    enable = mkEnableOption "Enable Nvidia";
  };

  config = mkIf cfg.enable {
    # Enable OpenGL
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    boot.kernelParams = [ "nvidia_drm.fbdev=1" "nvidia_drm.modeset=1" ];

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    environment.sessionVariables = {
      GDK_BACKEND = "wayland,x11";
      LIBVA_DRIVER_NAME = "nvidia";
      SDL_VIDEODRIVER = "wayland";
      NVD_BACKEND = "direct";
      CLUTTER_BACKEND = "wayland";
      GBM_BACKEND = "nvidia-drm";

      MOZ_ENABLE_WAYLAND = "1";
      MOZ_DISABLE_RDD_SANDBOX = "1";

      # https://wiki.archlinux.org/title/Java
      _JAVA_AWT_WM_NONREPARENTING = "1";
      AWT_TOOLKIT = "MToolkit";

      # QT HDPI
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_QPA_PLATFORM = "wayland";

      # Steam fixes https://www.reddit.com/r/linux_gaming/comments/zgrktp/raytracing_on_linux/
      PROTON_HIDE_NVIDIA_GPU = "0";
      PROTON_ENABLE_NVAPI = "1";
      PROTON_ENABLE_NGX_UPDATER = "1";
      VKD3D_CONFIG = "dxr,dxr11";
      __GL_GSYNC_ALLOWED = "1";
      __GL_VRR_ALLOWED = "1";
      __GL_MaxFramesAllowed = "1";
      XWAYLAND_NO_GLAMOR = "1"; # with this you'll need to use gamescope for gaming

      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";
      __NV_PRIME_RENDER_OFFLOAD = "1";
      __VK_LAYER_NV_optimus = "NVIDIA_only";
      WLR_DRM_NO_ATOMIC = "1";
      WLR_USE_LIBINPUT = "1";
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
    };

    hardware.nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
