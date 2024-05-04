local M = {}

M.init = function()
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

return M
