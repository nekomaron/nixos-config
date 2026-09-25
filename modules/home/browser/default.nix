{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    languagePacks = [ "en-US" "ja" ];
    profiles.default = {
      isDefault = true;
      settings = {
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.startup.homepage" = "about:blank";
        "intl.locale.requested" = "ja,en-US";
      };
    };
  };
}
