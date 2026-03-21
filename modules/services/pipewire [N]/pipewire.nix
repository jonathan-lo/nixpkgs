{ ... }:
{
  flake.modules.nixos.pipewire =
    { ... }:
    {
      boot.extraModprobeConfig = ''
        options snd-hda-intel model=(null),alc287-yoga9-bass-spk-pin
      '';
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    };
}
