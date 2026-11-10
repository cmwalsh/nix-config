# Introduction

Welcome to my Nix powered homelab configuration. The code within is in constant flux and some of it is only partially deployed. You're welcome to use it, but while this works for me, it may not work for you. Here be dragons! LLAP 🖖

## Hardware

| Hostname    | Make/Model        | CPU                       | GPU                   | RAM |
| ----------- | ----------------- | ------------------------- | --------------------- | --- |
| `rocinante` | Topton N5105      | Intel N100                | None                  | 16  |
| `serenity`  | Minisforum N5 Pro | AMD Ryzen AI 9 HX PRO 370 | AMD Radeon 890M       | 16  |
| `defiant`   | Framework 13      | AMD Ryzen 7 7840U         | AMD Radeon 7080M      | 32  |
| `jarvis`    | B760M DS3H        | Intel i5-13500            | AMD Radeon RX 9070 XT | 64  |

## Secrets

Secrets are kept in this repo using sops-nix. Here is how to generate keys and where to put them:

1. Generate a _user_ key for reading, writing and updating the encrypted secrets file.

```
# Private key
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt

# Show public key
age-keygen -y ~/.config/sops/age/keys.txt
```

2. Generate a _host_ key for reading the secrets file.

```
# Private key
sudo mkdir -p /var/lib/sops/age
sudo age-keygen -o /var/lib/sops/age/keys.txt

# Show public key
sudo age-keygen -y /var/lib/sops/age/keys.txt
```

3. Create or update the encrypted secrets file.

```
# Create a new file
sops secrets/secrets.yaml

# Update an existing file
sops updatekeys secrets/secrets.yaml
```

## Deploy Age keys

Sometimes I need to re-deploy my age keys because I re-installed a machine. I keep a backup of the keys in an encrypted vault so they can be re-deployed. These commands remind me what I need to do to get sops-nix working again!

```
# Deploy user key
mkdir -p ~/.config/sops/age
cp keys ~/.config/sops/age
chown craig:users ~/.config/sops/age/keys.txt
chmod 644 ~/.config/sops/age/keys.txt
```

```
# Deploy host key
sudo mkdir -p /var/lib/sops/age
sudo cp keys.txt /var/lib/sops/age
sudo chown root:root /var/lib/sops/age/keys.txt
sudo chmod 600 /var/lib/sops/age/keys.txt
```
