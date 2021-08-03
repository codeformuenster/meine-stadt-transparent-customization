ARG MST_SOURCE_IMAGE=konstin2/meine-stadt-transparent:v0.2.12
FROM ${MST_SOURCE_IMAGE} AS source
FROM node:14 AS front-end

ENV NODE_ENV=production \
  TEMPLATE_MAIN_CSS=mainapp-muenster
WORKDIR /app

COPY --from=source /app/package.json /app/package.json
COPY --from=source /app/package-lock.json /app/package-lock.json

RUN npm ci --dev

COPY --from=source /app/etc /app/etc
COPY customization /app/customization
COPY --from=source /app/mainapp/assets /app/mainapp/assets
RUN npm run build:prod

FROM ${MST_SOURCE_IMAGE}

ENV TEMPLATE_DIRS=customization/muenster/templates \
  TEMPLATE_MAIN_CSS=mainapp-muenster

COPY --chown=www-data --from=front-end /app/customization /app/customization
COPY --chown=www-data --from=front-end /app/mainapp/assets /app/mainapp/assets

# compile translations,
# execute collectstatic (https://github.com/meine-stadt-transparent/meine-stadt-transparent/blob/e9b09a0/meine_stadt_transparent/settings/__init__.py#L168-L172)
# etc
RUN cp etc/template.env .env && \
  /app/.venv/bin/python manage.py compilemessages -l de -l en && \
  /app/.venv/bin/python manage.py collectstatic --noinput && \
  rm .env
