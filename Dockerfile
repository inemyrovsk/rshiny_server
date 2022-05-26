FROM jinseob2kim/docker-rshiny:latest
USER root
WORKDIR /
RUN chmod 777 /srv/shiny-server && chmod 777 /etc/shiny-server && \
    rm /srv/shiny-server/index.html && \
    rm -rf /srv/shiny-server/sample-apps/*
RUN rm -rf /etc/shiny-server/

ADD ./configs/shiny-server/* /etc/shiny-server/
ADD ./app/* /home/js/ShinyApps/
RUN chmod 777 /srv/shiny-server
#RUN R -e "remotes::install_github(c('ohdsi/SqlRender', 'ohdsi/DatabaseConnector', 'ohdsi/OhdsiSharing', 'ohdsi/FeatureExtraction', 'ohdsi/CohortMethod', 'ohdsi/EmpiricalCalibration', 'ohdsi/MethodEvaluation'))"