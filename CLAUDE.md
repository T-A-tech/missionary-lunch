# Missionary Lunch

Aplicação Ruby on Rails para gerenciar almoços de missionários por ala/estaca.

## Revisão de Código (GitHub Actions)

### Convenções do projeto
- Multi-tenant: sempre verificar escopo de tenant antes de queries (`current_account`, `current_school`, etc.)
- Usar `ApplicationRecord` como base dos models
- Sidekiq para jobs assíncronos — nunca processar arquivos pesados inline
- Evitar N+1: usar `includes`, `preload` ou `eager_load` quando carregar associações
- Migrações devem ser reversíveis sempre que possível
- Nunca usar `update_all` ou `delete_all` sem where clause explícita

### O que sempre revisar
- Vazamentos de dados entre tenants
- Queries sem índice em tabelas grandes
- Callbacks `after_save`/`after_create` que disparam jobs duplicados
- Strong parameters ausentes ou muito permissivos
- Redirecionamentos sem validação de URL (open redirect)
