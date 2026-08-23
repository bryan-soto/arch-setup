vim.g.mapleader = " "

-- Guardar y Salir
-- vim.keymap.set("n", "<leader>w", vim.cmd.write, { desc = "Guardar archivo" })
-- vim.keymap.set("n", "<leader>q", vim.cmd.quit,  { desc = "Cerrar ventana" })
-- vim.keymap.set("n", "<leader>x", vim.cmd.x,     { desc = "guardar y salir" })

-- Navegar entre Buffer
vim.keymap.set("n", "<leader>bn", vim.cmd.bnext,      { desc = "guardar y salir" })
vim.keymap.set("n", "<leader>bp", vim.cmd.bprevious,  { desc = "guardar y salir" })
vim.keymap.set("n", "<leader>bq", vim.cmd.bdelete,      { desc = "guardar y salir" })

-- Splits
vim.keymap.set("n", "<leader>sv", vim.cmd.vsplit, { desc = "Split en Vertical" })
vim.keymap.set("n", "<leader>sh", vim.cmd.split,  { desc = "Split en Horizontal" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Movimiento a la Izquierda" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Movimiento para Abajo" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Movimiento para Arriba" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Movimiento a la Derecha" })

-- Explorador nativo de NeoVim
vim.keymap.set("n", "<leader>ex", vim.cmd.Ex,    { desc = "Explorador de Neovim" })

-- Movimiento
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
