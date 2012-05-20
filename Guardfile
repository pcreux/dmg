# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'ctags-bundler', :emacs => true do
  watch(%r{^(app|lib)/.*\.rb$})  { ["app", "lib"] }
  watch('Gemfile.lock')
end
