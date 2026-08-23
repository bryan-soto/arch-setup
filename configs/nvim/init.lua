require("config.options")
require("config.keymaps")
require("config.lazy")

local function set_transparency()
  -- Lista de grupos que suelen tener fondo sólido
  local groups = {
    "Normal",       -- Fondo principal
    "NormalNC",     -- Fondo de ventanas inactivas
    "NormalFloat",  -- Ventanas flotantes (menús, ayuda)
    "SignColumn",   -- Columna de signos (git, diagnósticos)
    "EndOfBuffer",  -- Área después del final del archivo
    "StatusLine",   -- Barra de estado (opcional, si no usas lualine transparente)
    "StatusLineNC",
    "TelescopeNormal",
    "TelescopeNormalNC",
    "TelescopeBorder",
    "TelescopePromptNormal",
    "TelescopePromptBorder",
    "TelescopeResultsNormal",
    "TelescopeResultsBorder",
    "TelescopePreviewNormal",
    "TelescopePreviewBorder",
    "TelescopeTitle",
    "TelescopeSelection",
  }

  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
  end
end

-- Aplicar inmediatamente
set_transparency()

-- Re-aplicar automáticamente cada vez que se carga un colorscheme
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_transparency,
})
