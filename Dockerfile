ARG MST_SOURCE_IMAGE=konstin2/meine-stadt-transparent:v0.2.5
FROM ${MST_SOURCE_IMAGE} AS source
FROM konstin2/meine-stadt-transparent@sha256:496607c9d036ba47c98f8369f6c1d4be7e2277fca65a0b51405c7dd337cc5271 AS source-latest
FROM node:10 AS front-end

ENV NODE_ENV=production \
  TEMPLATE_MAIN_CSS=mainapp-muenster
WORKDIR /app

COPY --from=source-latest /app/package.json /app/package.json
COPY --from=source-latest /app/package-lock.json /app/package-lock.json

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

# Copy /static from the source, but change the owner.
# Otherwise collectstatic in the next step fails because
# in the original container /static is owned by root:root
COPY --chown=www-data --from=source /static /static

# compile translations,
# execute collectstatic (https://github.com/meine-stadt-transparent/meine-stadt-transparent/blob/e9b09a0/meine_stadt_transparent/settings/__init__.py#L168-L172)
# etc
RUN cp etc/template.env .env && \
  /app/.venv/bin/python manage.py compilemessages -l de -l en && \
  /app/.venv/bin/python manage.py collectstatic --noinput && \
  rm .env
