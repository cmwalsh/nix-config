{ ... }:

{
  services.netdata = {
    enable = true;

    config = {
      global = {
        "bind to" = "0.0.0.0";
      };

      web = {
        "allow connections from" = "192.168.3.0/24";
      };
    };
  };
}
