web: bin/start-pgbouncer-stunnel bundle exec puma --port $PORT --threads ${PUMA_MIN_THREADS:-0}:${PUMA_MAX_THREADS:-4} --workers ${PUMA_WORKERS:-1} --environment ${RACK_ENV:-development} --quiet
worker: bin/bundle exec sidekiq -c 3
