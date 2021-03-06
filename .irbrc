# see https://github.com/k0kubun/dotfiles/commit/41716e66098fb30b845018716358567ac22ecd31#diff-4c4f336928651c6d17c19ca7d17e270b
def IRB.ls(obj, locals, grep)
  dump = proc do |name, strs|
    strs = strs.grep(/#{grep}/) if grep
    strs = strs.sort
    next if strs.empty?

    print "\e[1m\e[34m#{name}\e[0m: "
    if strs.size > 7
      len = [strs.map(&:length).max, 16].min
      puts; strs.each_slice(7) { |ss| puts "  #{ss.map { |s| "%-#{len}s" % s }.join('  ')}" }
    else
      puts strs.join('  ')
    end
  end

  dump.call('constants', obj.constants) if obj.respond_to?(:constants)

  klass = (obj.class == Class || obj.class == Module ? obj : obj.class)
  dump.call("#{klass}.methods", obj.singleton_methods(false))
  dump.call("#{klass}#methods", klass.public_instance_methods(false))

  dump.call('instance variables', obj.instance_variables)
  dump.call('class variables', klass.class_variables)
  dump.call('locals', locals)
end

IRB::Context.prepend(Module.new{
  def evaluate(line, *, **)
    if line.sub!(/\A\s*ls\s/, '')
      grep = nil
      line.gsub!(/(-G|--grep)\s+([^\s]+)/) { grep = $2; '' }
      obj    = (is_self = line.strip.empty?) ? 'self' : line.chomp
      locals = is_self ? 'local_variables' : '[]'
      line.replace("IRB.ls(#{obj}, #{locals}, #{grep.inspect}); _ = nil") # make `assignment_expression?(line)` true by replace
    end
    super
  end
})
