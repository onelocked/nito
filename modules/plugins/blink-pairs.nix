{
  neovim.mods =
    { lib, mkRaw, ... }:
    let
      inherit (lib.nixvim) listToUnkeyedAttrs;
      rule = chars: extra: (listToUnkeyedAttrs chars) // extra;
    in
    {
      plugins.blink-pairs = {
        enable = true;
        lazyLoad.settings.event = [
          "BufReadPost"
          "BufNewFile"
        ];
        settings.mappings.pairs."'" = [
          (rule [ "''" "''" ] {
            priority = 100;
            when = mkRaw ''function(ctx) return ctx:text_before_cursor(1) == "'" end'';
          })
          (rule [ "'" ] {
            enter = false;
            space = false;
          })
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
