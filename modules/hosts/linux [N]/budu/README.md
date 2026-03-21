# nixos laptop configuration

```mermaid

flowchart TD
    nqfkzbv5dzykdd5hd5g77wmhf8l1908r6_flake_nix["`**flake.nix**

_qfkzbv5dzykdd5hd5g77wmhf8l1908r6_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_budu["`**flake.nix#modules.nixos.budu**

_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu_configuration_nix["`**modules/hosts/linux [N]/budu/configuration.nix**
flake.modules.nixos.budu
_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_system_minimal["`**flake.nix#modules.nixos.system-minimal**

_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_system_01_system_minimal_nixos_minimal_nix["`**modules/system/01-system-minimal/nixos-minimal.nix**
flake.modules.nixos.system-minimal
_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_determinate["`**flake.nix#modules.nixos.determinate**

_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_nix_tools_determinate__ND__determinate_nix["`**modules/nix/tools/determinate [ND]/determinate.nix**
flake.modules.nixos.determinate
_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_docker["`**flake.nix#modules.nixos.docker**

_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_programs_cli_docker_nix["`**modules/programs/cli/docker.nix**
flake.modules.nixos.docker
_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_nixpkgsConfig["`**flake.nix#modules.nixos.nixpkgsConfig**

_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_nix_tools_nixpkgs__ND__nixpkgs_nix["`**modules/nix/tools/nixpkgs [ND]/nixpkgs.nix**
flake.modules.nixos.nixpkgsConfig
_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_home_manager["`**flake.nix#modules.nixos.home-manager**

_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_nix_tools_home_manager__ND__home_manager_nix["`**modules/nix/tools/home-manager [ND]/home-manager.nix**
flake.modules.nixos.home-manager
_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    niwxx6rj3ljb5g195z4ppxkvsl789g4cq_nixos["`**nixos**

_iwxx6rj3ljb5g195z4ppxkvsl789g4cq_`"]
    niwxx6rj3ljb5g195z4ppxkvsl789g4cq_nixos_common_nix["`**nixos/common.nix**

_iwxx6rj3ljb5g195z4ppxkvsl789g4cq_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_cli["`**flake.nix#modules.nixos.cli**

_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_programs_cli_cli_nix["`**modules/programs/cli/cli.nix**
flake.modules.nixos.cli
_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_keyd["`**flake.nix#modules.nixos.keyd**

_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_services_keyd__N__keyd_nix["`**modules/services/keyd [N]/keyd.nix**
flake.modules.nixos.keyd
_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_gnome["`**flake.nix#modules.nixos.gnome**

_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_services_gnome__N__gnome_nix["`**modules/services/gnome [N]/gnome.nix**
flake.modules.nixos.gnome
_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_pipewire["`**flake.nix#modules.nixos.pipewire**

_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_services_pipewire__N__pipewire_nix["`**modules/services/pipewire [N]/pipewire.nix**
flake.modules.nixos.pipewire
_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_printing["`**flake.nix#modules.nixos.printing**

_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_services_printing__N__printing_nix["`**modules/services/printing [N]/printing.nix**
flake.modules.nixos.printing
_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_gpu["`**flake.nix#modules.nixos.gpu**

_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_services_gpu__N__gpu_nix["`**modules/services/gpu [N]/gpu.nix**
flake.modules.nixos.gpu
_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_steam["`**flake.nix#modules.nixos.steam**

_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_programs_desktop_steam_nix["`**modules/programs/desktop/steam.nix**
flake.modules.nixos.steam
_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_libreoffice["`**flake.nix#modules.nixos.libreoffice**

_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_programs_desktop_libreoffice_nix["`**modules/programs/desktop/libreoffice.nix**
flake.modules.nixos.libreoffice
_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_protonvpn["`**flake.nix#modules.nixos.protonvpn**

_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_programs_desktop_protonvpn_nix["`**modules/programs/desktop/protonvpn.nix**
flake.modules.nixos.protonvpn
_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_powerkey["`**flake.nix#modules.nixos.powerkey**

_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_services_powerkey__N__powerkey_nix["`**modules/services/powerkey [N]/powerkey.nix**
flake.modules.nixos.powerkey
_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu_flake_parts_nix["`**modules/hosts/linux [N]/budu/flake-parts.nix**
flake.modules.nixos.budu
_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu__hardware_configuration_nix["`**modules/hosts/linux [N]/budu/_hardware-configuration.nix**

_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nqfkzbv5dzykdd5hd5g77wmhf8l1908r6_nixos_modules_installer_scan_not_detected_nix["`**nixos/modules/installer/scan/not-detected.nix**

_qfkzbv5dzykdd5hd5g77wmhf8l1908r6_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu_users_jlo_nix["`**modules/hosts/linux [N]/budu/users/jlo.nix**
flake.modules.nixos.budu
_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_jlo["`**flake.nix#modules.nixos.jlo**

_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_users_jlo__ND__jlo_nix["`**modules/users/jlo [ND]/jlo.nix**
flake.modules.nixos.jlo
_zm39lfg0c8fa98kxw63y73qfwzch9izw_`"]
    nqfkzbv5dzykdd5hd5g77wmhf8l1908r6_flake_nix --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_budu
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_budu --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu_configuration_nix
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_budu --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu_flake_parts_nix
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_budu --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu_users_jlo_nix
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu_configuration_nix --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_system_minimal
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu_configuration_nix --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_determinate
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu_configuration_nix --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_docker
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu_configuration_nix --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_nixpkgsConfig
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu_configuration_nix --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_home_manager
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu_configuration_nix --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_cli
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu_configuration_nix --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_keyd
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu_configuration_nix --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_gnome
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu_configuration_nix --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_pipewire
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu_configuration_nix --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_printing
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu_configuration_nix --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_gpu
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu_configuration_nix --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_steam
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu_configuration_nix --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_libreoffice
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu_configuration_nix --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_protonvpn
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu_configuration_nix --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_powerkey
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_system_minimal --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_system_01_system_minimal_nixos_minimal_nix
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_determinate --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_nix_tools_determinate__ND__determinate_nix
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_docker --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_programs_cli_docker_nix
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_nixpkgsConfig --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_nix_tools_nixpkgs__ND__nixpkgs_nix
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_home_manager --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_nix_tools_home_manager__ND__home_manager_nix
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_nix_tools_home_manager__ND__home_manager_nix --> niwxx6rj3ljb5g195z4ppxkvsl789g4cq_nixos
    niwxx6rj3ljb5g195z4ppxkvsl789g4cq_nixos --> niwxx6rj3ljb5g195z4ppxkvsl789g4cq_nixos_common_nix
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_cli --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_programs_cli_cli_nix
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_keyd --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_services_keyd__N__keyd_nix
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_gnome --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_services_gnome__N__gnome_nix
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_pipewire --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_services_pipewire__N__pipewire_nix
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_printing --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_services_printing__N__printing_nix
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_gpu --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_services_gpu__N__gpu_nix
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_steam --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_programs_desktop_steam_nix
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_libreoffice --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_programs_desktop_libreoffice_nix
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_protonvpn --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_programs_desktop_protonvpn_nix
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_powerkey --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_services_powerkey__N__powerkey_nix
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu_flake_parts_nix --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu__hardware_configuration_nix
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu__hardware_configuration_nix --> nqfkzbv5dzykdd5hd5g77wmhf8l1908r6_nixos_modules_installer_scan_not_detected_nix
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu_users_jlo_nix --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_jlo
    nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_jlo --> nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_users_jlo__ND__jlo_nix
    style nqfkzbv5dzykdd5hd5g77wmhf8l1908r6_flake_nix fill:#e5b2c0,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_budu fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu_configuration_nix fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_system_minimal fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_system_01_system_minimal_nixos_minimal_nix fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_determinate fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_nix_tools_determinate__ND__determinate_nix fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_docker fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_programs_cli_docker_nix fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_nixpkgsConfig fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_nix_tools_nixpkgs__ND__nixpkgs_nix fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_home_manager fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_nix_tools_home_manager__ND__home_manager_nix fill:#c5e5b2,color:#000000
    style niwxx6rj3ljb5g195z4ppxkvsl789g4cq_nixos fill:#dcb2e5,color:#000000
    style niwxx6rj3ljb5g195z4ppxkvsl789g4cq_nixos_common_nix fill:#dcb2e5,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_cli fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_programs_cli_cli_nix fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_keyd fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_services_keyd__N__keyd_nix fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_gnome fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_services_gnome__N__gnome_nix fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_pipewire fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_services_pipewire__N__pipewire_nix fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_printing fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_services_printing__N__printing_nix fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_gpu fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_services_gpu__N__gpu_nix fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_steam fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_programs_desktop_steam_nix fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_libreoffice fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_programs_desktop_libreoffice_nix fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_protonvpn fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_programs_desktop_protonvpn_nix fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_powerkey fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_services_powerkey__N__powerkey_nix fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu_flake_parts_nix fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu__hardware_configuration_nix fill:#c5e5b2,color:#000000
    style nqfkzbv5dzykdd5hd5g77wmhf8l1908r6_nixos_modules_installer_scan_not_detected_nix fill:#e5b2c0,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_hosts_linux__N__budu_users_jlo_nix fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_flake_nix_modules_nixos_jlo fill:#c5e5b2,color:#000000
    style nzm39lfg0c8fa98kxw63y73qfwzch9izw_modules_users_jlo__ND__jlo_nix fill:#c5e5b2,color:#000000
```
