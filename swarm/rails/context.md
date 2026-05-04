# Lightning Rails — Claude Swarm Context

This project is built on **Lightning Rails** (https://docs.lightningrails.com/) and uses a Claude Swarm of specialized agents for development.

## Project Information

- **Boilerplate**: Lightning Rails
- **Rails Version**: {{RAILS_VERSION}}
- **Ruby Version**: {{RUBY_VERSION}}
- **Project Type**: Full-stack Rails (Hotwire)

## Lightning Rails Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Ruby on Rails 8, Ruby 3.3.6 |
| Auth | Devise + custom Magic Links (EmailLink model) |
| Authorization | Pundit (policies on all non-admin controllers) |
| Payments | Pay gem + Stripe |
| Frontend | Hotwire (Turbo + Stimulus), Tailwind CSS 4, DaisyUI 5, Lucide icons |
| Email | Resend gem |
| Admin | Motor Admin + Pretender (impersonation) |
| Feature Flags | Flipper (ActiveRecord adapter) |
| Background Jobs | Sidekiq + Sidekiq-Cron + Redis |
| File Storage | Cloudinary |
| Monitoring | Sentry |
| Testing | RSpec + Playwright + FactoryBot |
| I18n | Optional multi-language (EN, ES, FR, DE) |

## Swarm Configuration

The claude-swarm.yml defines specialized agents:
- **Architect**: Plans, scopes risk, coordinates — the entry point for all tasks
- **Backend**: Models, services, controllers, migrations, jobs, mailers
- **Frontend**: Views, Tailwind/DaisyUI, Turbo, Stimulus, helpers
- **Tests**: RSpec, Playwright, FactoryBot

## Key Boilerplate Patterns

- **Thin controllers** with business logic in `app/services/`
- **Pundit authorization** on all controller actions
- **Two auth paths**: Devise (password) + EmailLink (magic link)
- **Pay gem** for Stripe subscriptions and billing
- **DaisyUI-only styling** — no inline CSS, no raw SVGs
- **Lucide icons** via `lucide_icon` helper
- **Flash messages** via Turbo Streams (`flash_stream` helper)
- **Site metadata** in `config/meta.yml`
- **Admin panel** at `/motor_admin` (admin-only)
- **Feature flags** at `/flipper` (admin-only)

## Documentation

- Lightning Rails docs: https://docs.lightningrails.com/
- DaisyUI components: https://daisyui.com/components/
- Lucide icons: https://lucide.dev/
- Tailwind CSS: https://tailwindcss.com/docs
- Hotwire/Turbo: https://turbo.hotwired.dev/
- Stimulus: https://stimulus.hotwired.dev/
