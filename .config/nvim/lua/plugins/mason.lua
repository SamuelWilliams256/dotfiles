local mason_package_list = { "clangd", "cpptools" }

return {
    "williamboman/mason.nvim",
    -- "build" is executed when a plugin is installed or updated.
    build = function()
        -- TODO: This causes GUI weirdness if Neovim is currently being
        -- bootstrapped. Leaving in place because at least this installs
        -- packages automatically on launch if they haven't been installed
        -- already.
        vim.cmd("MasonInstall "..table.concat(mason_package_list, " "))
    end,
    -- "config" is executed when the plugin loads.
    config = function()
        require("mason").setup()

        -- Create a command that allows for simple, headless installation.
        vim.api.nvim_create_user_command("MasonInstallAll", function ()
            vim.cmd("MasonInstall "..table.concat(mason_package_list, " "))
        end, {})
    end
}

