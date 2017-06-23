FROM node

ENV PROJECT_PATH=/srv

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["build"]
