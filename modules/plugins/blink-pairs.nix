{
  neovim.mods = {
    plugins.blink-pairs = {
      enable = true;
      lazyLoad.settings.event = [
        "BufReadPost"
        "BufNewFile"
      ];
      settings.mappings.pairs."'" = [
        {
          pair = [ "'" ];
        }
      ];
      settings.highlights.groups = [
        "BlinkPairsRed"
        "BlinkPairsYellow"
        "BlinkPairsBlue"
        "BlinkPairsOrange"
        "BlinkPairsGreen"
        "BlinkPairsPurple"
        "BlinkPairsCyan"
      ];
    };
  };
}
