{ pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    # TODO: 実際のGitHubアカウント情報に差し替える
    # userName = "あなたの名前";
    # userEmail = "your-email@example.com";

    settings = {
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "nvim";
      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        tree = "log --graph --oneline --all --decorate";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
