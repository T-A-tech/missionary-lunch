<p align="center">
  <img src="https://img.shields.io/badge/Rails-7.2-CC0000?style=for-the-badge&logo=rubyonrails&logoColor=white" />
  <img src="https://img.shields.io/badge/Ruby-3.3-CC342D?style=for-the-badge&logo=ruby&logoColor=white" />
  <img src="https://img.shields.io/badge/PostgreSQL-16-4169E1?style=for-the-badge&logo=postgresql&logoColor=white" />
  <img src="https://img.shields.io/badge/Docker-Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white" />
  <img src="https://img.shields.io/badge/Deploy-Fly.io-8B5CF6?style=for-the-badge&logo=flydotio&logoColor=white" />
</p>

<h1 align="center">Missionary Lunch</h1>

<p align="center">
  <strong>Sistema de agendamento de almoços com missionários para alas e ramos</strong>
</p>

<p align="center">
  Plataforma web que permite aos líderes de unidade gerar um link público<br>
  para que membros agendem almoços com os missionários de forma simples e organizada.
</p>

---

## Sobre o Projeto

O **Missionary Lunch** nasceu da necessidade de organizar os almoços dos missionários nas unidades da Igreja. Em vez de planilhas, grupos de WhatsApp ou anotações manuais, o líder da ala cria sua conta, recebe um link público e compartilha com os membros.

### Como funciona

```
Líder cria conta ➜ Recebe link público ➜ Compartilha com membros ➜ Membros agendam pelo calendário
```

**Para o líder:**
- Painel com calendário mensal mostrando dias livres e ocupados
- Lista de agendamentos com nome da família e telefone
- Link público exclusivo para compartilhar com os membros
- Gerenciamento de agendamentos (visualizar e remover)

**Para os membros:**
- Página pública com calendário visual (sem necessidade de login)
- Clique no dia disponível e preencha nome e telefone no pop-up
- Visualização clara de quais dias já estão ocupados

---

## Identidade Visual

O design segue a identidade visual institucional da Igreja:

| Cor | Hex | Uso |
|-----|-----|-----|
| **Navy** | `#003B71` | Navbar, títulos, botão principal |
| **Ouro** | `#D4A843` | Acentos, linha decorativa, badges |
| **Creme** | `#FAF8F4` | Fundo das páginas |

- Tipografia **Georgia** (serif) nos títulos
- Slideshow de imagens de templos e do Salvador como marca d'água na página pública

---

## Funcionalidades

- [x] Cadastro de líder com criação automática de estaca e ala
- [x] Login/logout com sessão segura (bcrypt)
- [x] Dashboard com calendário mensal e navegação entre meses
- [x] Link público com token único por ala
- [x] Calendário interativo com pop-up de agendamento
- [x] Validação de data (sem duplicatas, sem datas passadas)
- [x] Slideshow de imagens como marca d'água na página pública
- [x] Design responsivo (mobile, tablet, desktop)
- [x] Identidade visual institucional (Navy/Ouro/Creme/Georgia)
- [x] Locale pt-BR (meses em português)
- [x] Docker Compose para desenvolvimento local
- [x] Dockerfile multi-stage para produção

---

## Licença

Este projeto é de uso interno para unidades da Igreja de Jesus Cristo dos Santos dos Últimos Dias.

---

<br>

<h2 align="center">Para DEVs</h2>

<p align="center">
  <sub>Documentação técnica para desenvolvedores que desejam contribuir ou fazer deploy</sub>
</p>

---

## Stack Tecnológica

| Camada | Tecnologia |
|--------|-----------|
| **Backend** | Ruby on Rails 7.2 |
| **Banco de dados** | PostgreSQL 16 |
| **Servidor** | Puma |
| **Frontend** | ERB + Importmap + Turbo |
| **Autenticação** | `has_secure_password` (bcrypt) |
| **Container** | Docker + Docker Compose |
| **Deploy** | Fly.io (GRU - Guarulhos) |

---

## Estrutura do Projeto

```
app/
├── controllers/
│   ├── application_controller.rb   # Auth helpers (current_user, require_login)
│   ├── sessions_controller.rb      # Login / Logout
│   ├── registrations_controller.rb # Cadastro de líder + ala
│   ├── dashboard_controller.rb     # Painel do líder
│   └── public_controller.rb        # Página pública (agendamento)
├── models/
│   ├── stake.rb                    # Estaca
│   ├── user.rb                     # Líder de ala
│   ├── ward.rb                     # Ala/Ramo (com token público)
│   └── appointment.rb              # Agendamento
├── views/
│   ├── layouts/application.html.erb
│   ├── sessions/new.html.erb       # Tela de login
│   ├── registrations/new.html.erb  # Tela de cadastro
│   ├── dashboard/
│   │   ├── index.html.erb          # Painel principal
│   │   └── appointments.html.erb   # Lista de agendamentos
│   └── public/
│       └── show.html.erb           # Página pública com calendário
config/
├── routes.rb
├── database.yml
└── locales/pt-BR.yml               # Tradução pt-BR
db/migrate/
├── 20240101000001_create_stakes.rb
├── 20240101000002_create_users.rb
├── 20240101000003_create_wards.rb
└── 20240101000004_create_appointments.rb
```

---

## Modelo de Dados

```
┌──────────┐       ┌──────────┐       ┌──────────────┐
│  Stake   │1    N │   Ward   │1    N │ Appointment  │
│──────────│───────│──────────│───────│──────────────│
│ name     │       │ name     │       │ scheduled_date│
│          │       │ public_  │       │ family_name  │
│          │       │   token  │       │ phone        │
│          │       │ user_id  │       │ reminder_sent│
│          │       │ stake_id │       │ ward_id      │
└──────────┘       └──────────┘       └──────────────┘
                        │1
                        │
                   ┌────┴─────┐
                   │   User   │
                   │──────────│
                   │ name     │
                   │ email    │
                   │ password │
                   │  _digest │
                   └──────────┘
```

---

## Rotas

| Método | Path | Controller#Action | Descrição |
|--------|------|-------------------|-----------|
| GET | `/login` | sessions#new | Tela de login |
| POST | `/login` | sessions#create | Autenticar |
| DELETE | `/logout` | sessions#destroy | Sair |
| GET | `/register` | registrations#new | Tela de cadastro |
| POST | `/register` | registrations#create | Criar conta |
| GET | `/dashboard` | dashboard#index | Painel do líder |
| GET | `/dashboard/appointments` | dashboard#appointments | Todos agendamentos |
| PATCH | `/dashboard/ward` | dashboard#update_ward | Atualizar nome da ala |
| DELETE | `/dashboard/appointments/:id` | dashboard#destroy_appointment | Remover agendamento |
| GET | `/w/:token` | public#show | Página pública da ala |
| POST | `/w/:token/appointments` | public#create | Criar agendamento |

---

## Rodando Localmente

### Pré-requisitos

- [Docker](https://docs.docker.com/get-docker/) e Docker Compose

### Subindo a aplicação

```bash
# Clone o repositório
git clone git@github.com:ansulima/missionary-lunch.git
cd missionary-lunch

# Suba os containers
docker compose up --build

# Acesse em http://localhost:3000
```

O comando `docker compose up` já:
- Sobe o PostgreSQL
- Cria o banco e roda as migrations
- Inicia o servidor Puma na porta 3000

### Parando

```bash
docker compose down
```

---

## Deploy no Fly.io

### Pré-requisitos

```bash
# Instale o Fly CLI
curl -L https://fly.io/install.sh | sh
flyctl auth login
```

### Primeiro deploy

```bash
# Crie o app e o banco Postgres
flyctl apps create missionary-lunch
flyctl postgres create --name missionary-lunch-db --region gru
flyctl postgres attach missionary-lunch-db

# Gere e configure o secret key
flyctl secrets set SECRET_KEY_BASE=$(bin/rails secret)

# Deploy
flyctl deploy
```

### Deploys seguintes

```bash
flyctl deploy
```

---

<p align="center">
  Desenvolvido com <strong>Ruby on Rails</strong> e muita dedicação<br>
  <sub>Co-authored with Claude Code</sub>
</p>
