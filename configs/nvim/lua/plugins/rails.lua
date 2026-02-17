return {
  {
    'jlcrochet/vim-ruby',
    ft = { 'ruby', 'eruby' }
  },
  'jlcrochet/vim-rbs',
  'noprompt/vim-yardoc',
  {
    'tpope/vim-rails',
    dependencies = 'tpope/vim-bundler',
    init = function()
      vim.g.rails_gem_projections = {
        ["view_component"] = {
          ['app/components/*_component.rb'] = {
            command = 'component',
            affinity = 'controller',
            test = { "spec/components/{}_spec.rb" },
          }
        },
        ["sidekiq"] = {
          ['app/sidekiq/*.rb'] = {
            command = 'job',
            affinity = 'model',
            test = { "spec/sidekiq/{}_job_spec.rb", "test/sidekiq/{}_job_test.rb" },
            template = { "class %SJob\n  include Sidekiq::Job\nend" },
          }
        }
      }
    end
  },
  'slim-template/vim-slim',
}
