{ ... }:

{
  sops = {
    defaultSopsFile = ../../secrets/shared.yaml;
    useSystemdActivation = true;

    age.generateKey = true;
    age.keyFile = "/var/lib/sops-nix/key.txt";
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}
