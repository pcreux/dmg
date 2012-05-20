# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'ctags-bundler', :emacs => true do
  watch(%r{^(lib)/.*\.rb$})  { ["lib"] }
  watch('Gemfile.lock')
end
