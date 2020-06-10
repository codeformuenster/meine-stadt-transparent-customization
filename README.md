# WIP Meine Stadt Transparent customization

This repository contains customized templates for [meine-stadt-transparent.codeformuenster.org](https://meine-stadt-transparent.codeformuenster.org), a [meine-stadt-transparent](https://github.com/meine-stadt-transparent/meine-stadt-transparent) instance.

## Handling translations

Although this customization files do not use translations, it is possible to utilize django translations.

- Create `customization/locale` directory
- Add some `{% trans "YOUR-TRANSLATIONS" %}` in your custom templates.
- Start a container to update the locale files

      sudo docker run --rm -it --user root --entrypoint /makemessages.sh -v $(pwd):/app/customization -v $(pwd)/makemessages.sh:/makemessages.sh -e TEMPLATE_DIRS=customization/templates -e ORIGINAL_UID=$(id -u) konstin2/meine-stadt-transparent:v0.2.5

- Edit the `*.po` generated files with your translations
