{ config, pkgs, lib, ... }:

{
  # Fonts installation
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Main programming font
    jetbrains-mono
    nerd-fonts.jetbrains-mono

    # Alternative programming font
    fira-code
    nerd-fonts.fira-code

    # Emoji font
    noto-fonts-emoji

    # CJK fonts (for Chinese/Japanese/Korean)
    noto-fonts-cjk
  ];

  # Fontconfig configuration
  xdg.configFile."fontconfig/fonts.conf".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <!-- Default fonts -->
      <alias>
        <family>monospace</family>
        <prefer>
          <family>JetBrains Mono Nerd Font</family>
          <family>FiraCode Nerd Font</family>
          <family>Noto Sans Mono CJK SC</family>
          <family>JetBrains Mono</family>
          <family>Fira Code</family>
        </prefer>
      </alias>

      <alias>
        <family>sans-serif</family>
        <prefer>
          <family>Noto Sans</family>
          <family>Noto Sans CJK SC</family>
        </prefer>
      </alias>

      <alias>
        <family>serif</family>
        <prefer>
          <family>Noto Serif</family>
          <family>Noto Serif CJK SC</family>
        </prefer>
      </alias>

      <!-- Emoji font -->
      <alias binding="strong">
        <family>emoji</family>
        <prefer>
          <family>Noto Color Emoji</family>
        </prefer>
      </alias>

      <!-- Font rendering settings -->
      <match target="font">
        <edit mode="assign" name="antialias">
          <bool>true</bool>
        </edit>
        <edit mode="assign" name="hinting">
          <bool>true</bool>
        </edit>
        <edit mode="assign" name="hintstyle">
          <string>hintslight</string>
        </edit>
        <edit mode="assign" name="rgba">
          <const>rgb</const>
        </edit>
        <edit mode="assign" name="lcdfilter">
          <const>lcddefault</const>
        </edit>
      </match>

      <!-- Disable bitmap fonts -->
      <selectfont>
        <rejectfont>
          <pattern>
            <patelt name="scalable">
              <bool>false</bool>
            </patelt>
          </pattern>
        </rejectfont>
      </selectfont>
    </fontconfig>
  '';
}