# SSH and secrets configuration
{ config, lib, pkgs, ... }:

{
  # SOPS configuration for secrets management
  sops = {
    defaultSopsFile = ../secrets/github_ssh.yaml;
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    # Secret for GitHub SSH key
    secrets.github_ssh_key = {
      path = "/home/undead/.ssh/id_ed25519";
      owner = "undead";
    };
  };

  # Service to add the GitHub SSH key to ssh-agent
  systemd.user.services.ssh-add-github = {
    description = "Add GitHub SSH key to ssh-agent";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.openssh}/bin/ssh-add /home/undead/.ssh/id_ed25519";
      RemainAfterExit = true;
    };
  };

  # Activation script to generate GitHub public key
  system.activationScripts.generateGitHubPubKey = {
    text = ''
      #!/bin/sh
      # Ensure the .ssh directory exists for the user "undead"
      mkdir -p /home/undead/.ssh

      # If the public key is not already present, generate it
      if [ ! -f /home/undead/.ssh/id_ed25519.pub ]; then
        echo "Generating public key from decrypted private key..."
        ${pkgs.openssh}/bin/ssh-keygen -y -f /home/undead/.ssh/id_ed25519 > /home/undead/.ssh/id_ed25519.pub

        # Set correct ownership and permissions (assuming the primary group for "undead" is "users")
        chown undead:users /home/undead/.ssh/id_ed25519.pub
        chmod 644 /home/undead/.ssh/id_ed25519.pub
        ${pkgs.gnused}/bin/sed -i 's/ [^ ]*$/ priyanshu.pansari@gmail.com/' /home/undead/.ssh/id_ed25519.pub
      fi
    '';
  };

  # Enable OpenSSH service
  services.openssh.enable = true;
}
