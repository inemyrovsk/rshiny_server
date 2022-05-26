FROM jinseob2kim/docker-rshiny:latest
RUN chmod 777 /srv/shiny-server && chmod 777 /etc/shiny-server && \
    rm /srv/shiny-server/index.html && \
    rm -rf /srv/shiny-server/sample-apps/* && \
    rm /etc/shiny-server/shiny-server.conf

COPY app /srv/shiny-server/sample-apps/
COPY configs/shiny-server.conf /etc/shiny-server/
#RUN R -e "remotes::install_github(c('ohdsi/SqlRender', 'ohdsi/DatabaseConnector', 'ohdsi/OhdsiSharing', 'ohdsi/FeatureExtraction', 'ohdsi/CohortMethod', 'ohdsi/EmpiricalCalibration', 'ohdsi/MethodEvaluation'))"