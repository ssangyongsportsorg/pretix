FROM pretix/standalone:latest


COPY ./scripts/0001_initial.py /pretix/src/pretix/base/migrations/0001_initial.py
COPY ./scripts/0001_squashed_0028_auto_20160816_1242.py /pretix/src/pretix/base/migrations/0001_squashed_0028_auto_20160816_1242.py

EXPOSE 80

CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:80", "pretix.wsgi:application"]
