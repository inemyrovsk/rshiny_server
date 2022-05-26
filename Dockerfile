FROM rocker/shiny:latest
USER root
WORKDIR /
RUN chmod 777 /srv/shiny-server && chmod 777 /etc/shiny-server && \
    rm /srv/shiny-server/index.html && \
    rm -rf /srv/shiny-server/sample-apps/* && rm -rf /etc/shiny-server/* && rm -rf /srv/shiny-server/*
COPY shiny-server.conf /etc/shiny-server/
ADD ./app/* /srv/shiny-server/
RUN chmod 777 /srv/shiny-server
#RUN R -e "remotes::install_github(c('ohdsi/SqlRender', 'ohdsi/DatabaseConnector', 'ohdsi/OhdsiSharing', 'ohdsi/FeatureExtraction', 'ohdsi/CohortMethod', 'ohdsi/EmpiricalCalibration', 'ohdsi/MethodEvaluation'))"