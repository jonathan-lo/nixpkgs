{
  ...
}:
{
  flake-file.inputs = {
    llm-agents.url = "github:numtide/llm-agents.nix";
    mattpocock-skills.url = "github:mattpocock/skills";
    mattpocock-skills.flake = false;
    pi-catppuccin.url = "github:otahontas/pi-coding-agent-catppuccin";
    pi-catppuccin.inputs.nixpkgs.follows = "nixpkgs";
  };
}
