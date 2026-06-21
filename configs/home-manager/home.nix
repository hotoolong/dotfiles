{ pkgs, ... }:
{
  home.username = "hotoolong";
  home.homeDirectory = "/Users/hotoolong";

  # 初回インストール時の値。以後は変更しないこと（Nixのstate互換性マーカー）
  home.stateVersion = "25.05";

  # brew から段階移行する CLI ツール
  # フェーズ1: まず数個だけ移し、移行後に Brewfile から削除していく
  home.packages = with pkgs; [
    jq
    fd
    ripgrep
    bat
  ];

  programs.home-manager.enable = true;
}
