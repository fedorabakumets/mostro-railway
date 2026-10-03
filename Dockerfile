FROM mostrop2p/mostro:v0.19.1
USER root
COPY start.sh /start.sh
RUN chmod 755 /start.sh
CMD ["/start.sh"]
