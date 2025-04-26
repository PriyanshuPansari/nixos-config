{ config, lib, pkgs, ... }:

{
  services.kanata = {
    enable = true;
    keyboards = {
      internalKeyboard = {
        devices = [
          "/dev/input/by-id/usb-SEMICO_Redgear_Shadow_Blade_Mechanical_Keyboard-event-kbd"
          "/dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-kbd"
          "/dev/input/by-id/usb-ITE_Tech._Inc._ITE_Device_8176_-event-kbd"
          "/dev/usb/by-id/usb-SINO_WEALTH_Bluetooth_Keyboard-event-kbd"
        ];
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          ;; Define source keys to intercept (left and right hand keys)
          (defsrc
            q w e r t y u i o p
            a s d f g h j k l ;
            z x c v b n m , . /
          )

          ;; Variables for timing and key groups
          (defvar
            tap-time 150
            hold-time 150
            left-hand-keys (
              q w e r t
              a s d f g
              z x c v b
            )
            right-hand-keys (
              y u i o p
              h j k l ;
              n m , . /
            )
          )

          ;; Base layer with normal keys and special aliases
          (deflayer base
            q w e @r @t y @u i o p
            @a @s @d @f g h @j @k @l @;
            z x c v b n m , . /
          )

          ;; Nomods layer: all keys type normally
          (deflayer nomods
            q w e r t y u i o p
            a s d f g h j k l ;
            z x c v b n m , . /
          )

          ;; Numpad layer: right side becomes number pad, others transparent
          (deflayer numpad
            _ _ _ _ _ _ 7 8 9 0
            _ _ _ _ _ _ 4 5 6 .
            _ _ _ _ _ _ 1 2 3 _
          )

          ;; Symbols layer: left side becomes symbols, others transparent
          (deflayer symbols
            S-1 S-2 S-3 S-4 S-5 _ _ _ _ _
            S-6 S-7 S-8 S-9 S-0 _ _ _ _ _
            _ - = + \ _ _ _ _ _
          )

          ;; Navigation layer: left side becomes navigation keys, others transparent
          (deflayer navigation
            _ _ _ _ _ home pgdn pgup end ins  
            _ _ _ _ _ left down up right del
            _ _ _ _ _ _ _ _ _ _
          )
          ;; Fake key to return to base layer (for modifiers)
          (deffakekeys
            to-base (layer-switch base)
          )

          ;; Aliases for all special behaviors
          (defalias
          ;; Tap behavior for modifiers: type key when tapped alone
          a (tap-hold-release-keys $tap-time $hold-time a lmet $left-hand-keys)
          s (tap-hold-release-keys $tap-time $hold-time s lalt $left-hand-keys)
          d (tap-hold-release-keys $tap-time $hold-time d lctl $left-hand-keys)
          f (tap-hold-release-keys $tap-time $hold-time f lsft $left-hand-keys)
          ;; Right hand modifiers
          j (tap-hold-release-keys $tap-time $hold-time j rsft $right-hand-keys)
          k (tap-hold-release-keys $tap-time $hold-time k rctl $right-hand-keys)
          l (tap-hold-release-keys $tap-time $hold-time l ralt $right-hand-keys)
          ; (tap-hold-release-keys $tap-time $hold-time ; rmet $right-hand-keys)
          ;; Layer triggers: tap to type, hold to activate layer
          r (tap-hold $tap-time $hold-time r (layer-while-held numpad))
          u (tap-hold $tap-time $hold-time u (layer-while-held symbols))
          t (tap-hold $tap-time $hold-time t (layer-while-held navigation))
          )
        '';
      };
    };
  };

  # Ensure the uinput group exists and kanata service has proper permissions
  users.groups.uinput = { };

  systemd.services.kanata-internalKeyboard.serviceConfig = {
    SupplementaryGroups = [
      "input"
      "uinput"
    ];
  };

  # Add udev rules for uinput
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0008", MODE="0666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0007", MODE="0666"
  '';
}
