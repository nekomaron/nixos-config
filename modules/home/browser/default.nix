{ ... }:

{
  programs.firefox = {
    enable = true;
    profiles.default = {
      isDefault = true;
      settings = {
        # トラッキング防止を強化
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;

        # 新規タブページの余計な機能を抑制(お好みで調整可)
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

        # スタートアップページ(お好みのURLに変更可)
        "browser.startup.homepage" = "about:blank";
      };
    };
  };
}
