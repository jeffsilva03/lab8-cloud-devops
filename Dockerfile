# Etapa 1: instalar dependências
FROM python:3.11-slim AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt


# Etapa 2: executar a aplicação
FROM python:3.11-slim

WORKDIR /app

# Criar usuário sem privilégios de root
RUN addgroup --system appgroup && \
    adduser --system --ingroup appgroup appuser

# Copiar as dependências instaladas
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages

COPY --from=builder /usr/local/bin/uvicorn /usr/local/bin/uvicorn

# Copiar o código da API
COPY app/ ./app/

USER appuser

EXPOSE 8080

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
