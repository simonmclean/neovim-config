-- lua
local luaFormat = {
    formatCommand = "lua-format -i --no-keep-simple-function-one-line --column-limit=120",
    formatStdin = true
}

-- JavaScript/React/TypeScript
local prettier = {formatCommand = "./node_modules/.bin/prettier --stdin-filepath ${INPUT}", formatStdin = true}

local prettier_global = {formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true}

local eslint = {
    lintCommand = "./node_modules/.bin/eslint -f unix --stdin --stdin-filename ${INPUT}",
    lintIgnoreExitCode = true,
    lintStdin = true,
    lintFormats = {"%f:%l:%c: %m"},
    formatCommand = "./node_modules/.bin/eslint --fix-to-stdout --stdin --stdin-filename=${INPUT}",
    formatStdin = true
}

local shellcheck = {
    LintCommand = 'shellcheck -f gcc -x',
    lintFormats = {'%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m', '%f:%l:%c: %tote: %m'}
}

local shfmt = {formatCommand = 'shfmt -ci -s -bn', formatStdin = true}

local markdownlint = {
    -- TODO default to global lintrc
    -- lintcommand = 'markdownlint -s -c ./markdownlintrc',
    lintCommand = 'markdownlint -s',
    lintStdin = true,
    lintFormats = {'%f:%l %m', '%f:%l:%c %m', '%f: %l: %m'}
}

local markdownPandocFormat = {formatCommand = 'pandoc -f markdown -t gfm -sp --tab-stop=2', formatStdin = true}

return {
  -- init_options = {initializationOptions},
  cmd = { vim.fn.stdpath('data') .. "/lspinstall/efm/efm-langserver" },
  init_options = {documentFormatting = true, codeAction = false},
  filetypes = {
    "lua",
    "python",
    "typescript",
    "typescriptreact",
    "javascriptreact",
    "javascript",
    "sh",
    "html",
    "css",
    "json",
    "yaml",
    "markdown"
  },
  settings = {
    rootMarkers = {".git/", "package.json"},
    languages = {
      lua = {luaFormat},
      javascriptreact = {prettier, eslint},
      javascript = {prettier, eslint},
      typescript = {prettier, eslint},
      typescriptreact = {prettier, eslint},
      sh = {shellcheck, shfmt},
      html = {prettier_global},
      css = {prettier_global},
      json = {prettier_global},
      yaml = {prettier_global},
      -- markdown = {markdownPandocFormat, markdownlint},
      markdown = {markdownPandocFormat}
    }
  }
}
