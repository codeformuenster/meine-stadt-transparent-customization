# WIP Meine Stadt Transparent customization

This repository contains templates for customization of your meine-stadt-transparent instance

## Handling translations

- Edit some `{% trans "YOUR-TRANSLATIONS" %}` in your custom templates.
- Start a container

      sudo docker run --rm -it --user root --entrypoint /makemessages.sh -v $(pwd):/app/customization -v $(pwd)/makemessages.sh:/makemessages.sh -e TEMPLATE_DIRS=customization/templates konstin2/meine-stadt-transparent:v0.2.1
