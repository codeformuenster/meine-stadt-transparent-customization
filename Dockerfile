FROM konstin2/meine-stadt-transparent:v0.2.0

ENV TEMPLATE_DIRS=customization/templates

COPY --chown=www-data customization /app/customization

# compile translations etc
RUN cp etc/template.env .env && \
  /app/.venv/bin/python manage.py compilemessages --locale de && \
  rm .env
