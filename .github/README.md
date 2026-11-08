<div align="center">

# Nitovim
<br>

## Screenshots
<br>

**Dashboard**

<img src="./assets/dashboard.png" width="350">
<br>
<br>

**Editor**
<br>
<img src="./assets/overview1.png" width="750">
<br>
|    |    |
|:-------:|:-------:|
| <img src="./assets/yazi.png" width="350"> | <img src="./assets/snackspicker.png" width="350"> |
| <img src="./assets/search-replace.png" width="350"> | <img src="./assets/git-blame.png" width="350"> |

</div>

# Run
```nix
nix run github:/onelocked/vimmax
```
# Installation

**Add vimmax as a flake input**
```nix
# In your flake.nix
inputs.vimmax.url = "github:onelocked/vimmax";
```

**NixOS or Home Manager**
```nix
# For NixOS
environment.packages = [
  inputs.vimmax.packages.${pkgs.stdenv.hostPlatform.system}.default
];

# For Home Manager
home.packages = [
  inputs.vimmax.packages.${pkgs.stdenv.hostPlatform.system}.default
];
```
