return {
  {
    'rgroli/other.nvim',
    keys = {
      { "<leader>o", "<Cmd>Other<CR>", { silent = true } },
    },
    config = function()
      require("other-nvim").setup({
        rememberBuffers = false,
        mappings = {
          {
            pattern = "app/models/(.*).rb",
            target = {
              { target = "app/api/**/%1.rb", context = "api" },
              { target = "app/controllers/**/%1_controller.rb", context = "controller", transformer = "pluralize" },
              { target = "app/controllers/%1_controller.rb", context = "controller", transformer = "pluralize" },
              { target = "app/views/%1/**/*.html.*", context = "view", transformer = "pluralize" },
              { target = "app/policies/**/%1_policy.rb", context = "policy" },
              { target = "spec/mailers/%1_spec.rb", context = "mailer" },
              { target = "spec/models/%1_spec.rb", context = "spec" },
              { target = "app/decorators/%1_decorator.rb", context = "decorator" },
              { target = "spec/**/%1_spec.rb", context = "spec" },
              { target = "spec/factories/%1.rb", context = "factory", transformer = "pluralize" },
              { target = "sig/**/%1.rbs", context = "rbs" },
              { target = "app/components*/%1_component.rb", context = "component" },
              { target = "app/components*/%1_component.html.*", context = "view" },
            },
          },
          {
            pattern = "spec/models/(.*)_spec.rb",
            target = {
              { target = "spec/factories/%1.rb", context = "factory", transformer = "pluralize" },
              { target = "app/models/%1.rb", context = "models" },
            },
          },
          {
            pattern = "spec/factories/(.*).rb",
            target = {
              { target = "app/models/%1.rb", context = "models", transformer = "singularize" },
              { target = "spec/models/%1_spec.rb", context = "spec", transformer = "singularize" },
            },
          },
          {
            pattern = "app/services/**/(.*).rb",
            target = {
              { target = "spec/services/**/%1_spec.rb", context = "spec" },
            },
          },
          {
            pattern = "spec/services/**/(.*)_spec.rb",
            target = {
              { target = "app/services/**/%1.rb", context = "services" },
            },
          },
          {
            pattern = "app/controllers/*/(.*)_controller.rb",
            target = {
              { target = "spec/controllers/%1_spec.rb", context = "spec" },
              { target = "spec/requests/%1_spec.rb", context = "spec" },
              { target = "app/services/**/%1.rb", context = "services", transformer = "pluralize" },
              { target = "app/services/**/%1/*.rb", context = "services", transformer = "pluralize" },
              { target = "spec/factories/%1.rb", context = "factories", transformer = "singularize" },
              { target = "app/models/%1.rb", context = "models", transformer = "singularize" },
              { target = "app/models/%1.rb", context = "spec", transformer = "singularize" },
              { target = "app/views/%1/**/*.html.*", context = "view" },
              { target = "app/components*/%1_component.rb", context = "component", transformer = "singularize" },
              { target = "app/components*/%1_component.html.*", context = "view", transformer = "singularize" },
            },
          },
          {
            pattern = "spec/system/*/(.*)_spec.rb",
            target = {
              { target = "app/services/**/%1.rb", context = "services", transformer = "singularize" },
              { target = "app/services/**/%1/*.rb", context = "services", transformer = "singularize" },
              { target = "spec/factories/%1.rb", context = "factories" },
              { target = "app/models/%1.rb", context = "models", transformer = "singularize" },
              { target = "app/views/%1/**/*.html.*", context = "view" },
            },
          },
          {
            pattern = "app/components*/(.*)_component.rb",
            target = {
              { target = "spec/components*/%1_spec.rb", context = "spec" },
              { target = "app/models/%1.rb", context = "models" },
            },
          },
          {
            pattern = "app/views/(.*)/.*.html.*",
            target = {
              { target = "spec/factories/%1.rb", context = "factories", transformer = "singularize" },
              { target = "app/models/%1.rb", context = "models", transformer = "singularize" },
              { target = "app/controllers/**/%1_controller.rb", context = "controller", transformer = "pluralize" },
            },
          },
          {
            pattern = "lib/(.*).rb",
            target = {
              { target = "spec/%1_spec.rb", context = "spec" },
              { target = "sig/%1.rbs", context = "sig" },
            },
          },
          {
            pattern = "sig/**/(.*).rbs",
            target = {
              { target = "app/models/%1.rb", context = "model" },
              { target = "lib/%1.rb", context = "lib" },
              { target = "**/%1.rb" },
            },
          },
          {
            pattern = "spec/(.*)_spec.rb",
            target = {
              { target = "lib/%1.rb", context = "lib" },
              { target = "sig/%1.rbs", context = "sig" },
            },
          },
        },
      })
    end
  },
}
