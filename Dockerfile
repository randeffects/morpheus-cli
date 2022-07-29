FROM ruby:2.7.5

RUN gem install morpheus-cli -v 5.5.1.2

COPY ssl/bertramlabs.crt /usr/local/share/ca-certificates/

COPY ssl/morpheusdata.crt /usr/local/share/ca-certificates/

RUN update-ca-certificates

ENTRYPOINT ["morpheus"]