Pry.config.editor = "vim"

Pry.config.color = true

Pry.config.prompt_name = "[pry]"
Pry.config.prompt = proc do |obj, nest_level, _pry_|
  current_branch = `git rev-parse --abbrev-ref HEAD 2>/dev/null`.chomp
  current_branch = "#{current_branch[0..14]}.." if current_branch.length > 16
  current_branch = "(#{current_branch})" if current_branch

  num = "[#{_pry_.input_array.size}]"
  "#{num} #{current_branch} (#{Pry.view_clip(obj)})> "
end

if defined?(PryByebug)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
  Pry.commands.alias_command 'w', 'whereami'
  Pry.commands.alias_command 'vi', 'edit'
end

command_set = Pry::CommandSet.new do

  command 'sql', 'sqlを実行する' do |sql|
    if defined?(Rails)
      if sql.match('\Aselect')
        result = ActiveRecord::Base.connection.select_all(sql)
        output.puts result.to_hash
      else
        result = ActiveRecord::Base.connection.execute(sql)
        output.puts result.to_hash
      end
    end
  end

  command "copy", "Copy argument to the clip-board" do |str|
     IO.popen('pbcopy', 'w') { |f| f << str.to_s }
  end
end
Pry.config.commands.import command_set

