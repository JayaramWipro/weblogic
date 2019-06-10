FROM store/oracle/weblogic:12.2.1.3

MAINTAINER Kumar Saurabh <kumar.saurabh11@wipro.com>

ENV DOMAIN_HOME="/u01/oracle/user_projects/domains/${DOMAIN_NAME}" \
    PRE_DOMAIN_HOME=/u01/oracle/user_projects \
    APP_NAME="sample" \
    APP_PKG_FILE="sample.war" \
    APP_PKG_LOCATION="/u01/oracle"

# Add files required to build this image
COPY container-scripts/* /u01/oracle/
COPY properties/domain.properties /u01/oracle/properties/

USER root
RUN chmod +xw /u01/oracle/*.sh && \
    chmod +xw /u01/oracle/*.py && \
    chmod +xw /u01/oracle/wlst && \
    chown -R oracle:oracle /u01/oracle/*.sh && \
    chown -R oracle:oracle /u01/oracle/*.py && \
    chown -R oracle:oracle /u01/oracle/wlst && \
    chown -R oracle:oracle /u01/oracle/sample.war && \
    /u01/oracle/createWlsDomain.sh && \
    /u01/oracle/wlst /u01/oracle/app-deploy.py && \
    chown -R oracle:oracle $PRE_DOMAIN_HOME && \
    chmod -R a+rwX $PRE_DOMAIN_HOME && \
    echo ". $DOMAIN_HOME/bin/setDomainEnv.sh" >> /u01/oracle/.bashrc

USER 1000

#Define default command to start script.
CMD ["sh", "-c", "${DOMAIN_HOME}/startWebLogic.sh"]
