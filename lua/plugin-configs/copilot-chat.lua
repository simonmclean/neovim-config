return {
  'CopilotC-Nvim/CopilotChat.nvim',
  event = 'VeryLazy',
  branch = 'main',
  dependencies = {
    { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
    { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
  },
  build = 'make tiktoken', -- Only on MacOS or Linux
  opts = {
    -- debug = true, -- Enable debugging
    -- See Configuration section for rest
  },
  keys = {
    { '<leader>cpc', '<cmd>CopilotChat<cr>', desc = 'CopilotChat' },
    { '<leader>cpe', '<cmd>CopilotChatExplain<cr>', desc = 'CopilotChatExplain' },
    { '<leader>cpo', '<cmd>CopilotChatOptimize<cr>', desc = 'CopilotChatOptimize' },
    { '<leader>cpr', '<cmd>CopilotChatReview<cr>', desc = 'CopilotChatReview' },
    { '<leader>cpd', '<cmd>CopilotChatDocs<cr>', desc = 'CopilotChatDocs (adds doc comment)' },
    { '<leader>cpf', '<cmd>CopilotChatFixDiagnostic<cr>', desc = 'CopilotChatFixDiagnostic' },
  },
  -- See Commands section for default commands if you want to lazy load on them
}
