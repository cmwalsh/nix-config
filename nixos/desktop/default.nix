{ ... }:

{
  # The X server is still needed by Wine/legacy apps.
  services.xserver.enable = true;

  # PipeWire with PulseAudio/ALSA/JACK compatibility layers, so volume and
  # media keys work across native and legacy apps.
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
  };
}
