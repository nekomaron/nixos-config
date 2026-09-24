-- 🚀 LSP自動検知・自動起動
--    nix / markdown は extraPackages で確定インストール済み。
--    それ以外は各プロジェクトの devShell (nix develop) が供給する。

local function get_capabilities()
  local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
  if has_cmp then
    return cmp_lsp.default_capabilities()
  end
  return vim.lsp.protocol.make_client_capabilities()
end

vim.lsp.config('*', {
  capabilities = get_capabilities(),
})

local function detect_available_servers()
  local available = {}
  local lsp_files = vim.api.nvim_get_runtime_file("lsp/*.lua", true)

  for _, file in ipairs(lsp_files) do
    local name = vim.fn.fnamemodify(file, ":t:r")
    local ok, config = pcall(dofile, file)
    if ok and type(config) == "table" and config.cmd then
      local bin = type(config.cmd) == "table" and config.cmd[1] or nil
      if bin and vim.fn.executable(bin) == 1 then
        table.insert(available, name)
      end
    end
  end

  return available
end

vim.lsp.enable(detect_available_servers())
