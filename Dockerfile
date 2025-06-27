# Usa l'immagine base ufficiale di Python
FROM python:3.12-slim

# Installa git e certificati SSL
RUN apt-get update && apt-get install -y \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Imposta la directory di lavoro
WORKDIR /app

# Clona il repository e copia eventuali file locali (se serve)
RUN git clone https://github.com/nzo66/tvproxy . 
COPY . .

# Pre-crea la directory per i log e assegna i permessi
RUN mkdir -p /app/logs \
    && chown -R root:root /app/logs

# Aggiorna pip e installa le dipendenze senza cache
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Espone la porta 7860 per Flask/Gunicorn
EXPOSE 7860

# Avvia Gunicorn usando stdout/stderr per access- e error-log
CMD ["gunicorn", "app:app", \
     "-w", "4", \
     "--worker-class", "gevent", \
     "--worker-connections", "100", \
     "-b", "0.0.0.0:7860", \
     "--timeout", "120", \
     "--keep-alive", "5", \
     "--max-requests", "1000", \
     "--max-requests-jitter", "100", \
     "--access-logfile", "-", \
     "--error-logfile", "-"]