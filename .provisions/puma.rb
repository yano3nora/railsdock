threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
threads threads_count, threads_count
# port        ENV.fetch("PORT") { 3000 }  # Disues
environment ENV.fetch("RAILS_ENV") { "development" }
plugin :tmp_restart

bind "unix:///var/tmp/sockets/puma.sock"