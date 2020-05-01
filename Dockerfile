ARG MST_SOURCE_IMAGE=konstin2/meine-stadt-transparent:v0.2.5
FROM ${MST_SOURCE_IMAGE} AS source
FROM node:10 AS front-end

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

# compile translations etc
RUN cp etc/template.env .env && \
  /app/.venv/bin/python manage.py compilemessages --locale de && \
  rm .env
