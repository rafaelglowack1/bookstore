FROM python:3.12-slim

ENV DEBIAN_FRONTEND=noninteractive

# Instala dependências do sistema (incluindo o Git)
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    gcc \
    git \
    && rm -rf /var/lib/apt/lists/*

# Instala Poetry e adiciona ao PATH
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"

# Configurações do Poetry
ENV POETRY_VIRTUALENVS_IN_PROJECT=false
ENV POETRY_VIRTUALENVS_PATH="/opt/virtualenvs"

WORKDIR /usr/src/app

# Copia apenas arquivos de dependência (para melhor uso de cache)
COPY pyproject.toml poetry.lock ./

# Instala TODAS as dependências do projeto (sem ignorar libs essenciais)
RUN poetry install --no-root

# Copia o restante do código do projeto
COPY . .

# Expõe a porta padrão do Django
EXPOSE 8000

# Comando padrão para rodar o servidor Django via Poetry
CMD ["poetry", "run", "python", "manage.py", "runserver", "0.0.0.0:8000"]
