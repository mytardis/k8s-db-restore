FROM alpine:3.6

ENV PGHOST='localhost:5432'
ENV PGDATABASE='postgres'
ENV PGUSER='postgres@postgres'
ENV PGPASSWORD='password'

RUN apk update
# https://pkgs.alpinelinux.org/packages?name=postgresql&branch=v3.6
RUN apk add postgresql

COPY restore.sh .

ENTRYPOINT [ "/bin/sh" ]
CMD [ "./restore.sh" ]
