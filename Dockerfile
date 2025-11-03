FROM python:3.12-slim

ENV DEBIAN_FRONTEND=noninteractive

# Instala dependências do sistema
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Instala Poetry e adiciona ao PATH
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"

# Define onde o Poetry cria o ambiente virtual (fora do /usr/src/app)
ENV POETRY_VIRTUALENVS_IN_PROJECT=false
ENV POETRY_VIRTUALENVS_PATH="/opt/virtualenvs"

WORKDIR /usr/src/app

# Copia apenas arquivos de dependência para cache otimizado
COPY pyproject.toml poetry.lock ./

# Instala dependências principais
RUN poetry install --only main --no-root

# Copia o restante do projeto
COPY . .

EXPOSE 8000

# Usa o Poetry pra rodar o Django
CMD ["poetry", "run", "python", "manage.py", "runserver", "0.0.0.0:8000"]
