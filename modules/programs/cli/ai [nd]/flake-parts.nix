{
  ...
}:
{
  flake-file.inputs = {
    llm-agents.url = "github:numtide/llm-agents.nix";
    mattpocock-skills.url = "github:mattpocock/skills";
    mattpocock-skills.flake = false;
  };
}
